#!/usr/bin/env bash
# Tool Usage Verifier - Detects actual tool/skill/agent/forked usage patterns
# Verifies that skills were genuinely invoked (not hallucinated or manually read)
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

echo "# Tool/Skill Execution Verification: $(basename "$JSON_FILE")"
echo ""

# 1. VERIFY ACTUAL SKILL TOOL INVOCATIONS
echo "## 1. Actual Skill Tool Invocations (Critical)"
echo ""

# Find all tool_use entries with name:"Skill"
SKILL_CALLS=$(grep '"type":"tool_use"' "$JSON_FILE" | grep '"name":"Skill"' || true)

if [ -z "$SKILL_CALLS" ]; then
    echo "❌ **CRITICAL**: NO SKILL TOOL CALLS FOUND"
    echo "   The model did NOT invoke any skills via the Skill tool"
else
    echo "✅ **VERIFIED**: Found actual Skill tool invocations"
    echo ""

    # Extract skill names and IDs
    echo "**Skill Invocations:**"
    echo "$SKILL_CALLS" | while IFS= read -r call; do
        SKILL_NAME=$(echo "$call" | grep -o '"skill":"[^"]*"' | cut -d'"' -f4)
        TOOL_ID=$(echo "$call" | grep -o '"id":"call_function_[^"]*"' | cut -d'"' -f4)
        echo "  - Skill: $SKILL_NAME"
        echo "    Tool ID: $TOOL_ID"
    done
fi

echo ""

# 2. VERIFY SUCCESSFUL TOOL RESULTS
echo "## 2. Tool Result Verification (Success Check)"
echo ""

# For each skill call, verify there's a matching successful tool_result
TOTAL_SKILLS=$(echo "$SKILL_CALLS" | wc -l)
VERIFIED_SUCCESS=0
VERIFIED_FAILED=0

if [ -n "$SKILL_CALLS" ]; then
    while IFS= read -r call; do
        TOOL_ID=$(echo "$call" | grep -o '"id":"call_function_[^"]*"' | cut -d'"' -f4)
        SKILL_NAME=$(echo "$call" | grep -o '"skill":"[^"]*"' | cut -d'"' -f4)

        # Find matching tool_result
        RESULT=$(grep "\"tool_use_id\":\"$TOOL_ID\"" "$JSON_FILE" | grep -A1 '"type":"user"' | grep 'tool_result' | head -1 || true)

        if [ -n "$RESULT" ]; then
            SUCCESS=$(echo "$RESULT" | grep -o '"success":true' || echo "")
            if [ -n "$SUCCESS" ]; then
                echo "✅ $SKILL_NAME - SUCCESS (ID: $TOOL_ID)"
                VERIFIED_SUCCESS=$((VERIFIED_SUCCESS + 1))
            else
                echo "❌ $SKILL_NAME - FAILED (ID: $TOOL_ID)"
                VERIFIED_FAILED=$((VERIFIED_FAILED + 1))
            fi
        else
            echo "⚠️  $SKILL_NAME - NO RESULT FOUND (ID: $TOOL_ID)"
            VERIFIED_FAILED=$((VERIFIED_FAILED + 1))
        fi
    done <<< "$SKILL_CALLS"
fi

echo ""
echo "**Summary:** $VERIFIED_SUCCESS/$TOTAL_SKILLS skills succeeded"

echo ""

# 3. FORKED SKILL VERIFICATION
echo "## 3. Forked Execution Verification"
echo ""

FORKED_SKILLS=$(grep '"status":"forked"' "$JSON_FILE" | grep '"tool_use_result"' || true)

if [ -n "$FORKED_SKILLS" ]; then
    echo "✅ **VERIFIED**: Found forked skill executions"
    echo ""
    echo "$FORKED_SKILLS" | while IFS= read -r line; do
        SKILL_NAME=$(echo "$line" | grep -o '"commandName":"[^"]*"' | cut -d'"' -f4)
        AGENT_ID=$(echo "$line" | grep -o '"agentId":"[^"]*"' | cut -d'"' -f4)
        echo "  - Forked Skill: $SKILL_NAME"
        echo "    Agent ID: $AGENT_ID"
    done
else
    echo "ℹ️  No forked skill executions detected"
fi

echo ""

# 4. AGENT USAGE TRACKING
echo "## 4. Agent Usage Tracking"
echo ""

AGENT_USAGE=$(grep -o '"agentId":"[^"]*"' "$JSON_FILE" | sort | uniq -c || true)

if [ -n "$AGENT_USAGE" ]; then
    echo "**Agents Invoked:**"
    echo "$AGENT_USAGE" | while IFS= read -r line; do
        COUNT=$(echo "$line" | awk '{print $1}')
        AGENT=$(echo "$line" | awk '{print $2}' | cut -d'"' -f4)
        echo "  - Agent $AGENT: $COUNT skill(s)"
    done
else
    echo "No agent assignments found"
fi

echo ""

# 5. EXECUTION FLOW
echo "## 5. Execution Flow"
echo ""

# Count different message types
TOOL_USE_COUNT=$(grep '"type":"tool_use"' "$JSON_FILE" | wc -l)
TOOL_RESULT_COUNT=$(grep '"type":"tool_result"' "$JSON_FILE" | wc -l)
ASSISTANT_MSG_COUNT=$(grep '"type":"assistant"' "$JSON_FILE" | wc -l)

echo "- Tool Use Events: $TOOL_USE_COUNT"
echo "- Tool Result Events: $TOOL_RESULT_COUNT"
echo "- Assistant Messages: $ASSISTANT_MSG_COUNT"

echo ""

# 6. ANTI-HALLUCINATION CHECKS
echo "## 6. Anti-Hallucination Checks"
echo ""

# Check for manual SKILL.md reading (potential cheating)
MANUAL_SKILL_READ=$(grep -E '"name":"(Read|Bash)"' "$JSON_FILE" | grep -E '\.claude/skills.*\.md' | grep -v 'tool_use_result' | wc -l || true)

if [ "$MANUAL_SKILL_READ" -gt 0 ]; then
    echo "⚠️  **WARNING**: Detected potential manual SKILL.md reading"
    echo "   Found $MANUAL_SKILL_READ file reads of .claude/skills/*.md outside skill execution"
    echo ""
    grep -E '"name":"(Read|Bash)"' "$JSON_FILE" | grep -E '\.claude/skills.*\.md' | head -5 | while IFS= read -r line; do
        echo "   - $line"
    done
else
    echo "✅ No manual SKILL.md reading detected (good!)"
fi

echo ""

# 7. COMPLETION VERIFICATION
echo "## 7. Completion Markers"
echo ""

COMPLETION_MARKERS=$(grep -o "## [A-Z_]*COMPLETE" "$JSON_FILE" | sort | uniq || true)

if [ -n "$COMPLETION_MARKERS" ]; then
    echo "$COMPLETION_MARKERS" | awk '{print "- " $0}'
else
    echo "- No completion markers found"
fi

echo ""

# 8. FINAL VERDICT
echo "## Final Verification Summary"
echo ""

if [ "$TOTAL_SKILLS" -eq 0 ]; then
    echo "❌ **FAIL**: No skills were invoked via Skill tool"
elif [ "$VERIFIED_SUCCESS" -eq "$TOTAL_SKILLS" ] && [ "$VERIFIED_SUCCESS" -gt 0 ]; then
    echo "✅ **PASS**: All $TOTAL_SKILLS skills successfully invoked via Skill tool"
    if [ -n "$FORKED_SKILLS" ]; then
        FORKED_COUNT=$(echo "$FORKED_SKILLS" | wc -l)
        echo "   - Including $FORKED_COUNT forked execution(s) with agent isolation"
    fi
    if [ "$MANUAL_SKILL_READ" -eq 0 ]; then
        echo "   - No manual SKILL.md reading detected"
    fi
else
    echo "⚠️  **PARTIAL**: $VERIFIED_SUCCESS/$TOTAL_SKILLS skills succeeded"
    if [ "$VERIFIED_FAILED" -gt 0 ]; then
        echo "   - $VERIFIED_FAILED skill(s) failed or incomplete"
    fi
fi

echo ""
echo "---"
