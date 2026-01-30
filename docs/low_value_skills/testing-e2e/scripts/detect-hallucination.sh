#!/bin/bash
# testing-e2e/scripts/detect-hallucination.sh
# Detect hallucination patterns in test logs

set -uo pipefail

LOG_FILE="${1:-}"
PROMPT_FILE="${2:-}"

usage() {
    cat << EOF
Usage: $(basename "$0") <log_file> [prompt_file]

Detect hallucination patterns in test execution logs.

ARGUMENTS:
    log_file      Path to test execution log (required)
    prompt_file   Path to prompt file (optional, for comparison)

EXIT CODES:
    0 - No hallucination detected
    1 - Hallucination detected
    2 - Error (missing file, etc.)

EXAMPLES:
    $(basename "$0") test.log
    $(basename "$0") test.log prompt.md

EOF
}

if [ -z "$LOG_FILE" ]; then
    echo "Error: Log file required" >&2
    usage
    exit 2
fi

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file not found: $LOG_FILE" >&2
    exit 2
fi

HALLUCINATION_FOUND=0

# Check 1: "Read" instead of "invoke"
# Skills should be invoked, not just read about
if [ -n "$PROMPT_FILE" ] && [ -f "$PROMPT_FILE" ]; then
    if grep -qi "read.*skill\|look at.*skill\|check.*skill\|examine.*skill" "$PROMPT_FILE" 2>/dev/null; then
        if ! grep -qi "invoke.*skill\|use.*skill\|call.*skill" "$PROMPT_FILE" 2>/dev/null; then
            echo "HALLUCINATION: Prompt suggests reading instead of invoking skill"
            HALLUCINATION_FOUND=1
        fi
    fi
fi

# Check 2: Insufficient verification steps
# Tests should verify results, not just output
VERIFICATION_COUNT=$(grep -ci "verify\|validate\|check\|confirm\|ensure\|assert" "$LOG_FILE" 2>/dev/null || echo "0")
if [ "$VERIFICATION_COUNT" -lt 2 ]; then
    echo "HALLUCINATION: Insufficient verification steps ($VERIFICATION_COUNT found, need >= 2)"
    HALLUCINATION_FOUND=1
fi

# Check 3: Generic/vague output
# Should contain specific details, not just "I understand" or "done"
if grep -qi "I understand\|I see\|looks good\|seems right\|that should work\|done\." "$LOG_FILE" 2>/dev/null; then
    # Only flag if it's the only output (no actual work)
    LINE_COUNT=$(wc -l < "$LOG_FILE" 2>/dev/null || echo "0")
    if [ "$LINE_COUNT" -lt 10 ]; then
        echo "HALLUCINATION: Generic output detected (too brief)"
        HALLUCINATION_FOUND=1
    fi
fi

# Check 4: Wrong skill/command mentioned
# Claude should reference correct component names
if grep -qi "self-learning\|skill-authoring\|command-refine" "$LOG_FILE" 2>/dev/null; then
    # Check if Claude is confused about which skill to use
    WRONG_CONTEXT=$(grep -c "instead of\|rather than\|instead use" "$LOG_FILE" 2>/dev/null || echo "0")
    if [ "$WRONG_CONTEXT" -gt 0 ]; then
        echo "HALLUCINATION: Claude suggesting wrong skill/context"
        HALLUCINATION_FOUND=1
    fi
fi

# Check 5: Skipped critical steps
# Missing required outputs or validations
MISSING_OUTPUT=$(grep -c "no output\|nothing to show\|can't help\|I can't" "$LOG_FILE" 2>/dev/null || echo "0")
if [ "$MISSING_OUTPUT" -gt 2 ]; then
    echo "HALLUCINATION: Multiple empty or unhelpful responses"
    HALLUCINATION_FOUND=1
fi

# Check 6: Error patterns
ERROR_COUNT=$(grep -ci "error\|failed\|exception\|cannot\|unable" "$LOG_FILE" 2>/dev/null || echo "0")
if [ "$ERROR_COUNT" -gt 5 ]; then
    echo "HALLUCINATION: Too many errors in output ($ERROR_COUNT)"
    HALLUCINATION_FOUND=1
fi

# Final result
if [ $HALLUCINATION_FOUND -eq 1 ]; then
    echo "RESULT: Hallucination detected"
    exit 1
else
    echo "RESULT: No hallucination detected"
    exit 0
fi
