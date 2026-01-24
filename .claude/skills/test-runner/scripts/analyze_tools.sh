#!/usr/bin/env bash
# Tool Usage Verifier - Detects actual tool/skill/agent/forked usage patterns
# Verifies that skills were genuinely invoked (not hallucinated or manually read)
# Usage: ./analyze_tools.sh <json-file> [--json]
#        --json: Output machine-readable JSON

set -euo pipefail

JSON_FILE="${1:-}"
JSON_OUTPUT="${2:-}"

if [ -z "$JSON_FILE" ]; then
    echo "Usage: $0 <json-file> [--json]"
    exit 1
fi

if [ ! -f "$JSON_FILE" ]; then
    echo "Error: File not found: $JSON_FILE"
    exit 1
fi

# Validate JSON structure before processing
# Rationale: "Solve, don't punt" - validate input format explicitly rather than failing cryptically
if ! jq empty "$JSON_FILE" 2>/dev/null; then
    echo "Error: Invalid JSON file: $JSON_FILE"
    echo "Run 'jq . < \"$JSON_FILE\"' to see validation details"
    exit 2
fi

# Enable JSON output mode
if [ "$JSON_OUTPUT" = "--json" ]; then
    JSON_MODE=true
else
    JSON_MODE=false
fi

# Function to output JSON
output_json() {
    if [ "$JSON_MODE" = true ]; then
        echo "$1"
    fi
}

# Function to output human-readable
output_text() {
    if [ "$JSON_MODE" = false ]; then
        echo "$1"
    fi
}

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
    FORKED_COUNT=$(echo "$FORKED_SKILLS" | wc -l | tr -d ' ')
else
    echo "ℹ️  No forked skill executions detected"
    FORKED_COUNT=0
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

# 5. TASKLIST TOOL DETECTION
echo "## 5. TaskList Tool Usage"
echo ""

TASKLIST_TOOLS=$(grep '"type":"tool_use"' "$JSON_FILE" | grep -E '"name":"Task(Create|Update|Get|List)"' || true)

if [ -n "$TASKLIST_TOOLS" ]; then
    echo "✅ **VERIFIED**: Found TaskList tool invocations"
    echo ""
    echo "**TaskList Tool Usage:**"
    echo "$TASKLIST_TOOLS" | while IFS= read -r call; do
        TOOL_NAME=$(echo "$call" | grep -oE '"name":"Task(Create|Update|Get|List)"' | cut -d'"' -f4)
        TOOL_ID=$(echo "$call" | grep -o '"id":"call_function_[^"]*"' | cut -d'"' -f4)
        echo "  - Tool: $TOOL_NAME"
        echo "    Tool ID: $TOOL_ID"
    done

    # Count by tool type (initialize to 0 for use in JSON output)
    echo ""
    echo "**By Tool Type:**"
    TASKCREATE_COUNT=$(grep '"type":"tool_use"' "$JSON_FILE" | grep '"name":"TaskCreate"' | wc -l | tr -d ' ')
    TASKUPDATE_COUNT=$(grep '"type":"tool_use"' "$JSON_FILE" | grep '"name":"TaskUpdate"' | wc -l | tr -d ' ')
    TASKGET_COUNT=$(grep '"type":"tool_use"' "$JSON_FILE" | grep '"name":"TaskGet"' | wc -l | tr -d ' ')
    TASKLIST_COUNT=$(grep '"type":"tool_use"' "$JSON_FILE" | grep '"name":"TaskList"' | wc -l | tr -d ' ')
else
    # Initialize counts to 0 when no TaskList tools found
    TASKCREATE_COUNT=0
    TASKUPDATE_COUNT=0
    TASKGET_COUNT=0
    TASKLIST_COUNT=0

    echo "  - TaskCreate: $TASKCREATE_COUNT invocation(s)"
    echo "  - TaskUpdate: $TASKUPDATE_COUNT invocation(s)"
    echo "  - TaskGet: $TASKGET_COUNT invocation(s)"
    echo "  - TaskList: $TASKLIST_COUNT invocation(s)"
else
    echo "ℹ️  No TaskList tools detected"
    echo "   (TaskList tools: TaskCreate, TaskUpdate, TaskGet, TaskList)"
fi

echo ""

# 6. EXECUTION FLOW
echo "## 6. Execution Flow"
echo ""

# Count different message types
TOOL_USE_COUNT=$(grep '"type":"tool_use"' "$JSON_FILE" | wc -l)
TOOL_RESULT_COUNT=$(grep '"type":"tool_result"' "$JSON_FILE" | wc -l)
ASSISTANT_MSG_COUNT=$(grep '"type":"assistant"' "$JSON_FILE" | wc -l)

echo "- Tool Use Events: $TOOL_USE_COUNT"
echo "- Tool Result Events: $TOOL_RESULT_COUNT"
echo "- Assistant Messages: $ASSISTANT_MSG_COUNT"

echo ""

# 7. ANTI-HALLUCINATION CHECKS
echo "## 7. Anti-Hallucination Checks"
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

# 8. COMPLETION VERIFICATION
echo "## 8. Completion Markers"
echo ""

COMPLETION_MARKERS=$(grep -o "## [A-Z_]*COMPLETE" "$JSON_FILE" | sort | uniq || true)

if [ -n "$COMPLETION_MARKERS" ]; then
    echo "$COMPLETION_MARKERS" | awk '{print "- " $0}'
else
    echo "- No completion markers found"
fi

echo ""

# 9. FINAL VERDICT
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

# 10. JSON OUTPUT (for skill consumption)
if [ "$JSON_MODE" = true ]; then
    # Calculate autonomy score
    PERMISSION_DENIALS=$(grep -o '"permission_denials":\[[^]]*\]' "$JSON_FILE" | head -1)
    DENIAL_COUNT=0
    if echo "$PERMISSION_DENIALS" | grep -q "AskUserQuestion"; then
        DENIAL_COUNT=$(echo "$PERMISSION_DENIALS" | grep -o "AskUserQuestion" | wc -l | tr -d ' ')
    fi

    # Determine autonomy score
    if [ "$DENIAL_COUNT" -eq 0 ]; then
        AUTONOMY_SCORE=100
        AUTONOMY_GRADE="Excellence"
    elif [ "$DENIAL_COUNT" -le 3 ]; then
        AUTONOMY_SCORE=90
        AUTONOMY_GRADE="Good"
    elif [ "$DENIAL_COUNT" -le 5 ]; then
        AUTONOMY_SCORE=80
        AUTONOMY_GRADE="Acceptable"
    else
        AUTONOMY_SCORE=70
        AUTONOMY_GRADE="Fail"
    fi

    # Extract completion markers
    MARKERS=$(grep -o "## [A-Z_]*COMPLETE" "$JSON_FILE" | tr '\n' ',' | sed 's/,$//' | sed 's/^"/"/' | sed 's/"$/"/')

    # Determine final verdict
    if [ "$TOTAL_SKILLS" -eq 0 ]; then
        VERDICT="FAIL"
    elif [ "$VERIFIED_SUCCESS" -eq "$TOTAL_SKILLS" ] && [ "$VERIFIED_SUCCESS" -gt 0 ]; then
        VERDICT="PASS"
    else
        VERDICT="PARTIAL"
    fi

    # Output JSON
    cat <<EOF
{
  "verdict": "$VERDICT",
  "autonomy_score": $AUTONOMY_SCORE,
  "autonomy_grade": "$AUTONOMY_GRADE",
  "permission_denials": $DENIAL_COUNT,
  "skill_invocations": $TOTAL_SKILLS,
  "verified_success": $VERIFIED_SUCCESS,
  "forked_skills": $FORKED_COUNT,
  "tasklist_tools": {
    "taskcreate": $TASKCREATE_COUNT,
    "taskupdate": $TASKUPDATE_COUNT,
    "tasklist": $TASKLIST_COUNT
  },
  "completion_markers": [$MARKERS],
  "hallucination_detected": $MANUAL_SKILL_READ,
  "duration_ms": $(grep -o '"duration_ms":[0-9]*' "$JSON_FILE" | head -1 | cut -d':' -f2),
  "num_turns": $(grep -o '"num_turns":[0-9]*' "$JSON_FILE" | head -1 | cut -d':' -f2)
}
EOF
fi
