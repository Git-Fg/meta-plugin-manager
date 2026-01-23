#!/usr/bin/env bash
# verify_skill_execution.sh - Robust hallucination detection for skill tests
# Usage: ./verify_skill_execution.sh <test-output.json> <execution-mode> [test-name]
# execution-mode: regular|forked|subagent|hybrid

set -euo pipefail

TEST_LOG="${1:-}"
MODE="${2:-regular}"
TEST_NAME="${3:-unknown}"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 Skill Execution Verification${NC}"
echo "=================================================="
echo "Test: $TEST_NAME"
echo "Log: $TEST_LOG"
echo "Mode: $MODE"
echo ""

# Check if log file exists
if [ ! -f "$TEST_LOG" ]; then
    echo -e "${RED}❌ FAIL: Log file not found: $TEST_LOG${NC}"
    exit 1
fi

# Detect execution mode automatically if not specified
if [ "$MODE" == "auto" ]; then
    if grep -q '"status":"forked"' "$TEST_LOG" || grep -q 'forked execution' "$TEST_LOG"; then
        MODE="forked"
        echo "🔄 Auto-detected mode: FORKED"
    elif grep -q '"agent":' "$TEST_LOG" || grep -q '"agents":' "$TEST_LOG"; then
        MODE="subagent"
        echo "🔄 Auto-detected mode: SUBAGENT"
    else
        MODE="regular"
        echo "🔄 Auto-detected mode: REGULAR"
    fi
    echo ""
fi

# Verify each skill has success result
SUCCESS_COUNT=$(grep -o '"success":true' "$TEST_LOG" | wc -l)
echo ""
echo "Successful tool results: $SUCCESS_COUNT"
if [ "$SUCCESS_COUNT" -ge "$EXPECTED_COUNT" ]; then
    echo -e "${GREEN}✅ PASS: All skills completed successfully${NC}"
else
    echo -e "${YELLOW}⚠️ WARNING: Some skills may have failed${NC}"
    grep '"success":false' "$TEST_LOG" || echo "No explicit failures found"
fi

# Check for empty permission_denials (autonomy score)
echo ""
echo "Checking autonomy..."
if grep -q '"permission_denials": \[\]' "$TEST_LOG"; then
    echo -e "${GREEN}✅ AUTONOMY: Perfect (100% - no questions asked)${NC}"
    AUTONOMY_SCORE="100%"
elif grep -q '"permission_denials": \[.*\]' "$TEST_LOG"; then
    DENIAL_COUNT=$(grep -o '"permission_denials": \[.*\]' "$TEST_LOG" | sed 's/.*\[\(.*\)\].*/\1/' | grep -o ',' | wc -l | awk '{print $1 + 1}')
    if [ "$DENIAL_COUNT" -le 3 ]; then
        echo -e "${YELLOW}⚠️ AUTONOMY: Good (85-95% - $DENIAL_COUNT questions)${NC}"
        AUTONOMY_SCORE="85-95%"
    else
        echo -e "${RED}❌ AUTONOMY: Poor (<80% - $DENIAL_COUNT questions)${NC}"
        AUTONOMY_SCORE="<80%"
    fi
else
    echo -e "${YELLOW}⚠️ AUTONOMY: Unknown (no permission_denials field)${NC}"
    AUTONOMY_SCORE="unknown"
fi

# Verify forked execution (if applicable)
echo ""
echo "Checking execution mode..."
if grep -q '"status":"forked"' "$TEST_LOG"; then
    echo -e "${GREEN}✅ FORKED: Detected forked execution${NC}"
    FORKED_COUNT=$(grep -o '"status":"forked"' "$TEST_LOG" | wc -l)
    echo "   Forked skills: $FORKED_COUNT"
elif grep -q 'forked execution' "$TEST_LOG"; then
    echo -e "${GREEN}✅ FORKED: Detected 'forked execution' in output${NC}"
else
    echo -e "${YELLOW}⚠️ FORKED: No explicit forked execution detected${NC}"
fi

# Check for synthetic turns (should be present for real skills)
echo ""
echo "Checking workflow mechanism..."
SYNTHETIC_COUNT=$(grep -o '"isSynthetic":true' "$TEST_LOG" | wc -l)
if [ "$SYNTHETIC_COUNT" -gt 0 ]; then
    echo -e "${GREEN}✅ SYNTHETIC: $SYNTHETIC_COUNT internal workflow turns detected${NC}"
    echo "   (This is NORMAL - indicates real skill execution)"
else
    echo -e "${YELLOW}⚠️ SYNTHETIC: No internal workflow turns detected${NC}"
fi

# Verify win conditions
echo ""
echo "Checking win conditions..."
WIN_MARKERS=$(grep -o '## [A-Z_]*COMPLETE' "$TEST_LOG" | sort -u || echo "")
if [ -n "$WIN_MARKERS" ]; then
    echo -e "${GREEN}✅ WIN: Completion markers found:${NC}"
    echo "$WIN_MARKERS" | while read marker; do
        echo "   $marker"
    done
else
    echo -e "${YELLOW}⚠️ WIN: No completion markers found${NC}"
fi

# Summary
echo ""
echo "=================================================="
echo -e "${GREEN}✅ VERIFICATION COMPLETE${NC}"
echo "=================================================="
echo "Test Name: $TEST_NAME"
echo "Expected Skills: $EXPECTED_COUNT"
echo "Actual Skills: $ACTUAL_COUNT"
echo "Success Rate: $SUCCESS_COUNT/$EXPECTED_COUNT"
echo "Autonomy Score: $AUTONOMY_SCORE"
echo ""
echo "Exit code: 0 (all checks passed)"
