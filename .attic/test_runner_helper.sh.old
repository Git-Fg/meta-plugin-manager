#!/bin/bash
# Helper script for test-runner complex operations
# Purpose: JSON parsing, batch operations, and lifecycle tracking
# Usage: Call from test-runner skill for complex operations
# Natural language instructions remain in SKILL.md

set -euo pipefail

# Test plan path: configurable via environment variable with project-relative default
# Rationale: Default to project-relative path, allow override for testing or alternative locations
TEST_PLAN="${TEST_PLAN:-./tests/skill_test_plan.json}"

# Function to find next test
find_next_test() {
    if [ ! -f "$TEST_PLAN" ]; then
        echo "ERROR: Test plan not found: $TEST_PLAN"
        exit 1
    fi

    NEXT_TEST=$(cat "$TEST_PLAN" | jq -r '.test_plan.phases[] | .tests[]? | select(.status == "NOT_STARTED") | .test_id' | head -1)

    if [ -z "$NEXT_TEST" ] || [ "$NEXT_TEST" = "null" ]; then
        echo "No more tests to run"
        return 1
    fi

    echo "$NEXT_TEST"
    return 0
}

# Function to update test status
update_test_status() {
    local test_id="$1"
    local status="$2"
    local autonomy="${3:-}"
    local duration="${4:-}"

    if [ -z "$test_id" ] || [ -z "$status" ]; then
        echo "ERROR: test_id and status are required"
        exit 1
    fi

    # Update status
    cat "$TEST_PLAN" | jq --arg test "$test_id" --arg st "$status" \
        '.test_plan.phases[] | .tests[]? | select(.test_id == $test) | .status = $st' \
        > "${TEST_PLAN}.tmp" && mv "${TEST_PLAN}.tmp" "$TEST_PLAN"

    # Update autonomy if provided
    if [ -n "$autonomy" ]; then
        cat "$TEST_PLAN" | jq --arg test "$test_id" --arg score "$autonomy" \
            '.test_plan.phases[] | .tests[]? | select(.test_id == $test) | .autonomy_score = ($score | tonumber)' \
            > "${TEST_PLAN}.tmp" && mv "${TEST_PLAN}.tmp" "$TEST_PLAN"
    fi

    # Update duration if provided
    if [ -n "$duration" ]; then
        cat "$TEST_PLAN" | jq --arg test "$test_id" --arg dur "$duration" \
            '.test_plan.phases[] | .tests[]? | select(.test_id == $test) | .duration_ms = ($dur | tonumber)' \
            > "${TEST_PLAN}.tmp" && mv "${TEST_PLAN}.tmp" "$TEST_PLAN"
    fi

    echo "Updated test $test_id to status $status"
}

# Function to get test progress
get_progress() {
    if [ ! -f "$TEST_PLAN" ]; then
        echo "ERROR: Test plan not found"
        exit 1
    fi

    TOTAL=$(cat "$TEST_PLAN" | jq '[.test_plan.phases[] | .tests[]?] | length')
    COMPLETED=$(cat "$TEST_PLAN" | jq '[.test_plan.phases[] | .tests[]? | select(.status == "COMPLETED")] | length')
    FAILED=$(cat "$TEST_PLAN" | jq '[.test_plan.phases[] | .tests[]? | select(.status == "FAILED")] | length')
    NOT_STARTED=$(cat "$TEST_PLAN" | jq '[.test_plan.phases[] | .tests[]? | select(.status == "NOT_STARTED")] | length')

    echo "Progress: $COMPLETED/$TOTAL completed, $FAILED failed, $NOT_STARTED remaining"
}

# Function to analyze test output
analyze_output() {
    local output_file="$1"

    if [ ! -f "$output_file" ]; then
        echo "ERROR: Output file not found: $output_file"
        exit 1
    fi

    # Validate JSON structure before processing
    # Rationale: "Solve, don't punt" - validate format explicitly before parsing
    if ! jq empty "$output_file" 2>/dev/null; then
        echo "ERROR: Invalid JSON file: $output_file"
        echo "Run 'jq . < \"$output_file\"' to see validation details"
        exit 2
    fi

    # Check NDJSON structure
    LINES=$(wc -l < "$output_file")
    if [ "$LINES" -ne 3 ]; then
        echo "WARNING: Expected 3 lines, got $LINES"
    fi

    # Get autonomy score
    PERMISSION_DENIALS=$(jq -r '.result.permission_denials | length' "$output_file" 2>/dev/null || echo "0")

    if [ "$PERMISSION_DENIALS" -eq 0 ]; then
        AUTONOMY=100
        GRADE="Excellence"
    elif [ "$PERMISSION_DENIALS" -le 3 ]; then
        AUTONOMY=90
        GRADE="Good"
    elif [ "$PERMISSION_DENIALS" -le 5 ]; then
        AUTONOMY=80
        GRADE="Acceptable"
    else
        AUTONOMY=70
        GRADE="Fail"
    fi

    # Check completion markers
    HAS_COMPLETE=$(jq -r '[.[] | select(.content[]?.text? | contains("COMPLETE"))] | length' "$output_file" 2>/dev/null || echo "0")

    echo "Autonomy: $AUTONOMY% ($GRADE)"
    echo "Permission denials: $PERMISSION_DENIALS"
    echo "Completion markers: $HAS_COMPLETE"

    # Get duration
    DURATION=$(jq -r '.result.duration_ms' "$output_file" 2>/dev/null || echo "0")
    echo "Duration: ${DURATION}ms"

    # Return JSON for automation
    jq -n \
        --arg autonomy "$AUTONOMY" \
        --arg grade "$GRADE" \
        --arg denials "$PERMISSION_DENIALS" \
        --arg markers "$HAS_COMPLETE" \
        --arg duration "$DURATION" \
        --arg lines "$LINES" \
        '{
            autonomy_score: ($autonomy | tonumber),
            grade: $grade,
            permission_denials: ($denials | tonumber),
            completion_markers: ($markers | tonumber),
            duration_ms: ($duration | tonumber),
            ndjson_lines: ($lines | tonumber),
            valid_ndjson: ($lines | tonumber) == 3
        }'
}

# Function to detect tool usage in NDJSON
detect_tool_usage() {
    local output_file="$1"

    if [ ! -f "$output_file" ]; then
        echo "ERROR: Output file not found: $output_file"
        exit 1
    fi

    # Count tool invocations by type
    local skill_count=$(jq -r '[.[] | select(.type == "tool_use" and .name == "Skill")] | length' "$output_file" 2>/dev/null || echo "0")
    local tasklist_count=$(jq -r '[.[] | select(.type == "tool_use" and (.name == "TaskList" or .name == "TaskCreate" or .name == "TaskUpdate" or .name == "TaskGet"))] | length' "$output_file" 2>/dev/null || echo "0")
    local read_count=$(jq -r '[.[] | select(.type == "tool_use" and .name == "Read")] | length' "$output_file" 2>/dev/null || echo "0")
    local write_count=$(jq -r '[.[] | select(.type == "tool_use" and (.name == "Write" or .name == "Edit"))] | length' "$output_file" 2>/dev/null || echo "0")
    local bash_count=$(jq -r '[.[] | select(.type == "tool_use" and .name == "Bash")] | length' "$output_file" 2>/dev/null || echo "0")
    local total_tools=$(jq -r '[.[] | select(.type == "tool_use")] | length' "$output_file" 2>/dev/null || echo "0")

    # Return tool usage report
    jq -n \
        --arg skill "$skill_count" \
        --arg tasklist "$tasklist_count" \
        --arg read "$read_count" \
        --arg write "$write_count" \
        --arg bash "$bash_count" \
        --arg total "$total_tools" \
        '{
            tools_used: {
                Skill: ($skill | tonumber),
                TaskList: ($tasklist | tonumber),
                Read: ($read | tonumber),
                WriteEdit: ($write | tonumber),
                Bash: ($bash | tonumber)
            },
            total_tool_invocations: ($total | tonumber)
        }'
}

# Function to analyze test execution comprehensively
analyze_test_execution() {
    local output_file="$1"

    echo "=== COMPREHENSIVE TEST ANALYSIS ==="
    echo ""

    # Basic analysis
    echo "### Basic Metrics"
    analyze_output "$output_file"
    echo ""

    # Tool detection
    echo "### Tool Usage"
    detect_tool_usage "$output_file"
    echo ""

    # Extract tool invocation details
    echo "### Tool Invocation Details"
    jq -r '
        [.[] | select(.type == "tool_use")] |
        group_by(.name) |
        map({tool: .[0].name, count: length}) |
        .[] | "\(.tool): \(.count) invocations"
    ' "$output_file" 2>/dev/null || echo "No tool invocations found"

    echo ""

    # Check for specific patterns
    echo "### Execution Patterns"
    local forked=$(jq -r '[.[] | select(.content[]?.text? | contains("context: fork"))] | length' "$output_file" 2>/dev/null || echo "0")
    if [ "$forked" -gt 0 ]; then
        echo "✅ Forked execution detected"
    fi

    local autonomous=$(jq -r '.result.permission_denials | length' "$output_file" 2>/dev/null || echo "1")
    if [ "$autonomous" -eq 0 ]; then
        echo "✅ Fully autonomous execution"
    else
        echo "⚠️ Required $autonomous permission prompts"
    fi
}

# Function to track lifecycle stage
update_lifecycle_stage() {
    local test_id="$1"
    local stage="$2"

    if [ -z "$test_id" ] || [ -z "$stage" ]; then
        echo "ERROR: test_id and stage are required"
        exit 1
    fi

    # Valid stages: setup, execute, validate, document, archived
    cat "$TEST_PLAN" | jq --arg test "$test_id" --arg stage "$stage" \
        '.test_plan.phases[].tests[] | select(.test_id == $test) | .lifecycle_stage = $stage' \
        > "${TEST_PLAN}.tmp" && mv "${TEST_PLAN}.tmp" "$TEST_PLAN"

    echo "Updated test $test_id to lifecycle stage: $stage"
}

# Function to mark phase complete
mark_phase_complete() {
    local phase="$1"

    if [ -z "$phase" ]; then
        echo "ERROR: phase number required"
        exit 1
    fi

    # Mark all tests in phase as complete
    cat "$TEST_PLAN" | jq --arg phase "$phase" \
        '.test_plan.phases[] | select(.phase_number == ($phase | tonumber)) | .status = "COMPLETED"' \
        > "${TEST_PLAN}.tmp" && mv "${TEST_PLAN}.tmp" "$TEST_PLAN"

    echo "Marked phase $phase as complete"
}

# Function to add finding
add_finding() {
    local test_id="$1"
    local finding="$2"

    if [ -z "$test_id" ] || [ -z "$finding" ]; then
        echo "ERROR: test_id and finding are required"
        exit 1
    fi

    # Append finding to test record
    cat "$TEST_PLAN" | jq --arg test "$test_id" --arg finding "$finding" \
        '.test_plan.phases[] | .tests[]? | select(.test_id == $test) | .findings += [$finding]' \
        > "${TEST_PLAN}.tmp" && mv "${TEST_PLAN}.tmp" "$TEST_PLAN"

    echo "Added finding to test $test_id"
}

# Main command handling
case "$1" in
    find-next)
        find_next_test
        ;;
    update-status)
        if [ $# -lt 3 ]; then
            echo "Usage: $0 update-status <test_id> <status> [autonomy] [duration]"
            exit 1
        fi
        update_test_status "$2" "$3" "$4" "$5"
        ;;
    progress)
        get_progress
        ;;
    analyze)
        if [ $# -lt 2 ]; then
            echo "Usage: $0 analyze <output_file>"
            exit 1
        fi
        analyze_output "$2"
        ;;
    detect-tools)
        if [ $# -lt 2 ]; then
            echo "Usage: $0 detect-tools <output_file>"
            exit 1
        fi
        detect_tool_usage "$2"
        ;;
    analyze-execution)
        if [ $# -lt 2 ]; then
            echo "Usage: $0 analyze-execution <output_file>"
            exit 1
        fi
        analyze_test_execution "$2"
        ;;
    lifecycle-stage)
        if [ $# -lt 3 ]; then
            echo "Usage: $0 lifecycle-stage <test_id> <stage>"
            exit 1
        fi
        update_lifecycle_stage "$2" "$3"
        ;;
    phase-complete)
        if [ $# -lt 2 ]; then
            echo "Usage: $0 phase-complete <phase_number>"
            exit 1
        fi
        mark_phase_complete "$2"
        ;;
    add-finding)
        if [ $# -lt 3 ]; then
            echo "Usage: $0 add-finding <test_id> <finding>"
            exit 1
        fi
        add_finding "$2" "$3"
        ;;
    *)
        echo "Usage: $0 {find-next|update-status|progress|analyze|lifecycle-stage|phase-complete|add-finding}"
        echo ""
        echo "Commands:"
        echo "  find-next        - Find the next test to run"
        echo "  update-status     - Update test status"
        echo "  progress         - Show test progress"
        echo "  analyze          - Analyze test output"
        echo "  lifecycle-stage  - Update test lifecycle stage"
        echo "  phase-complete   - Mark phase as complete"
        echo "  add-finding      - Add finding to test"
        exit 1
        ;;
esac
