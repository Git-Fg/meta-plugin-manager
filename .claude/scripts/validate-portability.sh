#!/bin/bash

# Portability Invariant Validation System
# Tests that components work in isolation without external dependencies

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Validation counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0

# Function to log status
log_status() {
    local status=$1
    local message=$2
    if [ "$status" == "PASS" ]; then
        echo -e "${GREEN}✓ PASS${NC}: $message"
        ((PASSED_CHECKS++))
    elif [ "$status" == "FAIL" ]; then
        echo -e "${RED}✗ FAIL${NC}: $message"
        ((FAILED_CHECKS++))
    elif [ "$status" == "INFO" ]; then
        echo -e "${YELLOW}ℹ INFO${NC}: $message"
    fi
    ((TOTAL_CHECKS++))
}

# Function to check for external references
check_external_references() {
    local file=$1
    log_status "INFO" "Checking for external .claude/rules/ references in $file"

    # Check for actual external references (not just mentions in the text)
    # Look for patterns like "see .claude/rules/" or "reference .claude/rules/" but exclude "Never reference .claude/rules/"
    if grep -E "(see|reference)\s+\.claude/rules/" "$file" 2>/dev/null | grep -v "Never reference" | grep -q .; then
        log_status "FAIL" "Found external .claude/rules/ reference (not portable)"
        grep -n -E "(see|reference)\s+\.claude/rules/" "$file" | grep -v "Never reference" || true
        return 1
    else
        log_status "PASS" "No external .claude/rules/ references found"
        return 0
    fi
}

# Function to check for Success Criteria
check_success_criteria() {
    local file=$1
    log_status "INFO" "Checking for Success Criteria section in $file"

    if grep -q "## Success Criteria" "$file" 2>/dev/null; then
        log_status "PASS" "Success Criteria section found"

        # Check if ANY Success Criteria section is self-validating
        # Look for phrases like "without external dependencies" or "using only this content"
        if grep -E "(without external dependencies|using only this content|no external dependencies required)" "$file" 2>/dev/null | grep -q .; then
            log_status "PASS" "Success Criteria is self-validating"
            return 0
        else
            log_status "FAIL" "Success Criteria found but not self-validating"
            return 1
        fi
    else
        log_status "FAIL" "Success Criteria section not found"
        return 1
    fi
}

# Function to check Teaching Formula
check_teaching_formula() {
    local file=$1
    log_status "INFO" "Checking Teaching Formula integration in $file"

    local formula_check=0

    # Check for Metaphor
    if grep -q "\*\*Metaphor\*\*" "$file" 2>/dev/null || grep -q "Metaphor:" "$file" 2>/dev/null; then
        log_status "PASS" "Teaching Formula: Metaphor found"
        ((formula_check++))
    else
        log_status "FAIL" "Teaching Formula: Metaphor not found"
    fi

    # Check for Contrast Examples (Good/Bad)
    if grep -q "✅ Good:" "$file" 2>/dev/null && grep -q "❌ Bad:" "$file" 2>/dev/null; then
        log_status "PASS" "Teaching Formula: Contrast Examples found"
        ((formula_check++))
    else
        log_status "FAIL" "Teaching Formula: Contrast Examples not found"
    fi

    # Check for Recognition Questions
    local recognition_count=$(grep -c "Recognition:" "$file" 2>/dev/null || echo "0")
    if [ "$recognition_count" -ge 3 ]; then
        log_status "PASS" "Teaching Formula: Recognition Questions found ($recognition_count)"
        ((formula_check++))
    else
        log_status "FAIL" "Teaching Formula: Recognition Questions not found (found $recognition_count, need 3)"
    fi

    if [ $formula_check -eq 3 ]; then
        return 0
    else
        return 1
    fi
}

# Function to check self-containment
check_self_containment() {
    local file=$1
    log_status "INFO" "Checking self-containment in $file"

    # Check for inline examples
    if grep -q '```' "$file" 2>/dev/null; then
        log_status "PASS" "Examples appear to be inlined (code blocks found)"
    else
        log_status "FAIL" "No code blocks found - examples may not be inlined"
        return 1
    fi

    # Check for problematic external file references (exclude legitimate mentions)
    # Look for "See X" or "Reference X" where X is not a code block or example
    if grep -iE "(see|reference|check)\s+[a-zA-Z_/-]+\.md" "$file" 2>/dev/null | grep -vE "(Never reference|See \.claude/rules|Recognition:)" | grep -q .; then
        log_status "FAIL" "Found potential external file references"
        grep -n -iE "(see|reference|check)\s+[a-zA-Z_/-]+\.md" "$file" | grep -vE "(Never reference|See \.claude/rules|Recognition:)" || true
        return 1
    else
        log_status "PASS" "No external file references found"
        return 0
    fi
}

# Function to check Portability Invariant
check_portability_invariant() {
    local file=$1
    log_status "INFO" "Checking Portability Invariant in $file"

    # Check for bundled philosophy
    if grep -q "Bundle condensed.*philosophy\|Think of.*like.*shared refrigerator\|Delta Standard" "$file" 2>/dev/null; then
        log_status "PASS" "Bundled philosophy found"
    else
        log_status "FAIL" "Bundled philosophy not found"
        return 1
    fi

    # Check for Portability requirement
    if grep -q "Portability.*MANDATORY\|Portability.*Invariant\|Work.*in.*isolation" "$file" 2>/dev/null; then
        log_status "PASS" "Portability requirement stated"
    else
        log_status "FAIL" "Portability requirement not stated"
        return 1
    fi

    return 0
}

# Function to validate component type
validate_component_type() {
    local file=$1

    # Check if it's a skill
    if echo "$file" | grep -q "skill-development/SKILL.md"; then
        echo "skill"
    # Check if it's a command
    elif echo "$file" | grep -q "command-development/SKILL.md"; then
        echo "command"
    # Check if it's an agent
    elif echo "$file" | grep -q "agent-development/SKILL.md"; then
        echo "agent"
    # Check if it's a hook
    elif echo "$file" | grep -q "hook-development/SKILL.md"; then
        echo "hook"
    # Check if it's MCP
    elif echo "$file" | grep -q "mcp-development/SKILL.md"; then
        echo "mcp"
    else
        echo "unknown"
    fi
}

# Main validation function
validate_component() {
    local file=$1

    echo ""
    echo "============================================"
    echo "Validating: $file"
    echo "============================================"

    if [ ! -f "$file" ]; then
        log_status "FAIL" "File not found: $file"
        return 1
    fi

    local component_type=$(validate_component_type "$file")
    echo "Component Type: $component_type"
    echo ""

    # Run all checks
    check_external_references "$file"
    check_success_criteria "$file"
    check_teaching_formula "$file"
    check_self_containment "$file"
    check_portability_invariant "$file"

    echo ""
    echo "============================================"
    echo "Validation Summary for $file"
    echo "============================================"
    echo "Total Checks: $TOTAL_CHECKS"
    echo -e "Passed: ${GREEN}$PASSED_CHECKS${NC}"
    echo -e "Failed: ${RED}$FAILED_CHECKS${NC}"

    if [ $FAILED_CHECKS -eq 0 ]; then
        echo -e "${GREEN}✓ PORTABILITY VALIDATION PASSED${NC}"
        echo "This component works in isolation!"
        return 0
    else
        echo -e "${RED}✗ PORTABILITY VALIDATION FAILED${NC}"
        echo "This component has portability issues."
        return 1
    fi
}

# Function to validate all meta-skills
validate_all_meta_skills() {
    local base_dir=".claude/skills"
    local files=(
        "$base_dir/skill-development/SKILL.md"
        "$base_dir/command-development/SKILL.md"
        "$base_dir/agent-development/SKILL.md"
        "$base_dir/hook-development/SKILL.md"
        "$base_dir/mcp-development/SKILL.md"
    )

    local total_components=${#files[@]}
    local passed_components=0
    local failed_components=0

    echo "============================================"
    echo "PORTABILITY INVARIANT VALIDATION SYSTEM"
    echo "Testing all meta-skills for isolation"
    echo "============================================"
    echo ""

    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            # Reset counters for each component
            TOTAL_CHECKS=0
            PASSED_CHECKS=0
            FAILED_CHECKS=0

            if validate_component "$file"; then
                ((passed_components++))
            else
                ((failed_components++))
            fi
        else
            log_status "FAIL" "File not found: $file"
            ((failed_components++))
        fi
    done

    echo ""
    echo "============================================"
    echo "OVERALL PORTABILITY VALIDATION RESULTS"
    echo "============================================"
    echo "Total Components: $total_components"
    echo -e "Passed: ${GREEN}$passed_components${NC}"
    echo -e "Failed: ${RED}$failed_components${NC}"
    echo ""

    if [ $failed_components -eq 0 ]; then
        echo -e "${GREEN}✓ ALL COMPONENTS ARE PORTABLE${NC}"
        echo "Seed System creates portable organisms!"
        return 0
    else
        echo -e "${RED}✗ PORTABILITY ISSUES FOUND${NC}"
        echo "Some components need fixes."
        return 1
    fi
}

# Function to test component in isolation
test_isolation() {
    local file=$1
    local test_dir=$(mktemp -d)

    log_status "INFO" "Testing isolation: copying component to fresh directory"

    # Create minimal test environment
    mkdir -p "$test_dir/.claude/skills/test-skill"
    cp "$file" "$test_dir/.claude/skills/test-skill/SKILL.md"

    # Try to validate without any rules
    cd "$test_dir"

    # Check if component references external files
    if grep -q "\.claude/rules/" "$test_dir/.claude/skills/test-skill/SKILL.md" 2>/dev/null; then
        log_status "FAIL" "Component references external .claude/rules/ (breaks isolation)"
        rm -rf "$test_dir"
        return 1
    fi

    # Check if Success Criteria is self-contained
    if ! grep -q "Self-validation:.*without external dependencies" "$test_dir/.claude/skills/test-skill/SKILL.md" 2>/dev/null; then
        log_status "FAIL" "Success Criteria not self-contained"
        rm -rf "$test_dir"
        return 1
    fi

    log_status "PASS" "Component passes isolation test"
    rm -rf "$test_dir"
    return 0
}

# Function to show usage
show_usage() {
    cat << EOF
Portability Invariant Validation System

Usage: $0 [COMMAND] [FILE]

Commands:
    validate FILE      Validate a specific component file
    all              Validate all meta-skills (default)
    test FILE        Test component in isolation
    help             Show this help message

Examples:
    $0 all
    $0 validate .claude/skills/skill-development/SKILL.md
    $0 test .claude/skills/command-development/SKILL.md

Exit Codes:
    0 - All validations passed
    1 - One or more validations failed

EOF
}

# Main execution
main() {
    case "${1:-all}" in
        "validate")
            if [ -z "${2:-}" ]; then
                echo "Error: File path required"
                show_usage
                exit 1
            fi
            validate_component "$2"
            ;;
        "all")
            validate_all_meta_skills
            ;;
        "test")
            if [ -z "${2:-}" ]; then
                echo "Error: File path required"
                show_usage
                exit 1
            fi
            test_isolation "$2"
            ;;
        "help"|"-h"|"--help")
            show_usage
            exit 0
            ;;
        *)
            echo "Error: Unknown command '$1'"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
