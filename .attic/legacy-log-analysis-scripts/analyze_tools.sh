#!/usr/bin/env bash
# analyze_tools.sh - Simple tool usage analyzer
# Usage: ./analyze_tools.sh <json-file>

set -euo pipefail

JSON_FILE="${1:-}"

if [ -z "$JSON_FILE" ]; then
    echo "Usage: $0 <json-file>"
    exit 1
fi

if [ ! -f "$JSON_FILE" ]; then
    echo "Error: File not found: $JSON_FILE"
    exit 1
fi

echo "# Tool Usage Report: $(basename "$JSON_FILE")"
echo ""

# Count tool usage
echo "## Summary"
TOOL_COUNT=$(grep -o '"name":"[^"]*"' "$JSON_FILE" | wc -l | tr -d ' ')
SKILL_COUNT=$(grep -o '"name":"Skill"' "$JSON_FILE" | wc -l | tr -d ' ')
echo "- Total Tool Uses: $TOOL_COUNT"
echo "- Skill Calls: $SKILL_COUNT"
echo "- Other Tools: $((TOOL_COUNT - SKILL_COUNT))"
echo ""

echo "## Tool Breakdown"
grep -o '"name":"[^"]*"' "$JSON_FILE" | sort | uniq -c | sort -rn | while read count tool; do
    tool_name=$(echo "$tool" | sed 's/"name":"\(.*\)"/\1/')
    echo "- $tool_name: $count"
done
echo ""

# Detect pattern
echo "## Pattern Detected"
if [ "$SKILL_COUNT" -eq 1 ]; then
    if grep -q '"status":"forked"' "$JSON_FILE" 2>/dev/null || grep -q 'forked execution' "$JSON_FILE" 2>/dev/null; then
        echo "Single Forked Skill"
    else
        echo "Single Regular Skill"
    fi
elif [ "$SKILL_COUNT" -gt 1 ]; then
    if grep -q '"status":"forked"' "$JSON_FILE" 2>/dev/null; then
        echo "Multi-Skill Forked Execution"
    else
        echo "Skill Chain"
    fi
else
    echo "No Skill Calls Detected"
fi
echo ""

# Show tool details
echo "## Skill Details"
grep -B2 -A2 '"name":"Skill"' "$JSON_FILE" | grep -E '(skill|Skill)' | head -20 || echo "No skill details found"
echo ""

# Show success/failure
if grep -q '"success":true' "$JSON_FILE"; then
    SUCCESS_COUNT=$(grep -o '"success":true' "$JSON_FILE" | wc -l | tr -d ' ')
    echo "## Success Rate"
    echo "Successful operations: $SUCCESS_COUNT"
fi
