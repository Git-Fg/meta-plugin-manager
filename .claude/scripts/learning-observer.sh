#!/bin/bash
set -euo pipefail

# Continuous Learning v2 - Observation Hook
#
# Captures tool use events for pattern analysis.
# Claude Code passes hook data via stdin as JSON.
#
# Compatible with Seed System hook patterns.

CONFIG_DIR="${HOME}/.claude/homunculus"
OBSERVATIONS_FILE="${CONFIG_DIR}/observations.jsonl"
MAX_FILE_SIZE_MB=10

# Ensure directory exists
mkdir -p "$CONFIG_DIR"

# Skip if disabled
if [ -f "$CONFIG_DIR/disabled" ]; then
  exit 0
fi

# Read JSON from stdin (Claude Code hook format)
INPUT_JSON=$(cat)

# Exit if no input
if [ -z "$INPUT_JSON" ]; then
  exit 0
fi

# Parse using jq for compatibility with Seed System
TOOL_NAME=$(echo "$INPUT_JSON" | jq -r '.tool // .tool_name // "unknown"')
TOOL_INPUT=$(echo "$INPUT_JSON" | jq -r '.tool_input // .input // {}' | head -c 5000)
TOOL_OUTPUT=$(echo "$INPUT_JSON" | jq -r '.tool_output // .output // ""' | head -c 5000)
SESSION_ID=$(echo "$INPUT_JSON" | jq -r '.session_id // .session // "unknown"')

# Determine event type based on hook context
# PostToolUse = tool_complete (has output), PreToolUse = tool_start
if [ -n "$TOOL_OUTPUT" ] && [ "$TOOL_OUTPUT" != "null" ] && [ "$TOOL_OUTPUT" != "{}" ]; then
  EVENT_TYPE="tool_complete"
else
  EVENT_TYPE="tool_start"
fi

# Archive if file too large
if [ -f "$OBSERVATIONS_FILE" ]; then
  file_size_mb=$(du -m "$OBSERVATIONS_FILE" 2>/dev/null | cut -f1)
  if [ "${file_size_mb:-0}" -ge "$MAX_FILE_SIZE_MB" ]; then
    archive_dir="${CONFIG_DIR}/observations.archive"
    mkdir -p "$archive_dir"
    mv "$OBSERVATIONS_FILE" "$archive_dir/observations-$(date +%Y%m%d-%H%M%S).jsonl"
  fi
fi

# Build and write observation
timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

jq -n \
  --arg timestamp "$timestamp" \
  --arg event "$EVENT_TYPE" \
  --arg tool "$TOOL_NAME" \
  --arg session "$SESSION_ID" \
  --arg input "$TOOL_INPUT" \
  --arg output "$TOOL_OUTPUT" \
  '{
    timestamp: $timestamp,
    event: $event,
    tool: $tool,
    session: $session,
    input: (if $input != "" and $input != "null" then $input else null end),
    output: (if $output != "" and $output != "null" then $output else null end)
  }' >> "$OBSERVATIONS_FILE"

exit 0
