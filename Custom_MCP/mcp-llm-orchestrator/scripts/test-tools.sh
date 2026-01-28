#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MCP_SERVER="node $SCRIPT_DIR/../dist/index.js"

echo "=== MCP LLM Orchestrator Test Suite ==="
echo ""

# Test 1: Tool listing
echo "[1/5] Testing tool listing..."
TOOLS=$(npx @modelcontextprotocol/inspector --cli "$MCP_SERVER" --method tools/list 2>/dev/null | jq -r '.tools[].name' || echo "")
echo "Available tools:"
echo "$TOOLS"
echo ""

# Test 2: ask_gemini_flash (fast, no API key needed for basic test)
echo "[2/5] Testing ask_gemini_flash..."
npx @modelcontextprotocol/inspector --cli "$MCP_SERVER" \
  --method tools/call --tool-name ask_gemini_flash \
  --tool-arg 'query="What is 2+2? Answer with just the number."' 2>/dev/null | jq -r '.content[0].text // "No response"'
echo ""

# Test 3: ask_perplexity (requires API key - will show error if not set)
echo "[3/5] Testing ask_perplexity..."
npx @modelcontextprotocol/inspector --cli "$MCP_SERVER" \
  --method tools/call --tool-name ask_perplexity \
  --tool-arg 'query="What is the MCP protocol?"' \
  --tool-arg 'model="sonar"' 2>/dev/null | jq -r '.content[0].text // "No response"'
echo ""

# Test 4: ask_gemini_pro (requires API key - will show error if not set)
echo "[4/5] Testing ask_gemini_pro..."
npx @modelcontextprotocol/inspector --cli "$MCP_SERVER" \
  --method tools/call --tool-name ask_gemini_pro \
  --tool-arg 'query="What are the latest developments in AI?"' 2>/dev/null | jq -r '.content[0].text // "No response"'
echo ""

# Test 5: analyze_media (requires API key - test with inline data if fixture exists)
echo "[5/5] Testing analyze_media..."
if [ -f "$SCRIPT_DIR/../test-fixtures/sample.jpg" ]; then
  IMG_DATA=$(base64 -w0 "$SCRIPT_DIR/../test-fixtures/sample.jpg")
  npx @modelcontextprotocol/inspector --cli "$MCP_SERVER" \
    --method tools/call --tool-name analyze_media \
    --tool-arg 'prompt="Describe what you see in one sentence."' \
    --tool-arg 'mediaType="image"' \
    --tool-arg 'mediaSource="inline"' \
    --tool-arg 'mimeType="image/jpeg"' \
    --tool-arg "data=$IMG_DATA" \
    --tool-arg 'model="gemini-3-flash-preview"' 2>/dev/null | jq -r '.content[0].text // "No response"'
else
  echo "Skipping (no test-fixtures/sample.jpg found)"
  echo "To test: add a small image at test-fixtures/sample.jpg"
fi
echo ""

echo "=== Test suite complete ==="
echo "Note: Tests requiring API keys may show errors if keys are not configured."
echo "Configure PERPLEXITY_API_KEY and GOOGLE_API_KEY in your environment."
