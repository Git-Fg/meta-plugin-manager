#!/usr/bin/env bash
# validate_agent.sh - Validate subagent frontmatter
#
# Dependencies: python3 (for YAML handling if needed)
#
# Exit Codes:
#   0 - Validation passed
#   1 - Validation failed

set -euo pipefail

usage() {
    cat << 'EOF'
Usage: validate_agent.sh <agent-file>

Validates subagent configuration and frontmatter.

ARGUMENTS:
  agent-file    Path to agent .md file

EXAMPLES:
  validate_agent.sh .claude/agents/my-agent.md
  validate_agent.sh plugin/agents/reviewer.md
EOF
    exit 1
}

# Valid agent types
VALID_TYPES=("general-purpose" "bash" "explore" "plan")
VALID_MODELS=("haiku" "sonnet" "opus")
VALID_FIELDS=("name" "description" "tools" "disallowedTools" "model" "permissionMode" "skills" "hooks")
INVALID_FIELDS=("context" "agent" "user-invocable" "disable-model-invocation")

validate_agent() {
    local agent_file="$1"

    if [[ ! -f "$agent_file" ]]; then
        echo "❌ FAIL: Agent file does not exist: $agent_file"
        return 1
    fi

    # Check for YAML frontmatter
    if ! grep -q "^---" "$agent_file"; then
        echo "❌ FAIL: Missing YAML frontmatter (no --- delimiter)"
        return 1
    fi

    local score=100
    local issues=()
    local warnings=()

    # Check required fields
    if ! grep -q "^name:" "$agent_file"; then
        issues+=("Missing required field: name")
        score=$((score - 20))
    fi

    if ! grep -q "^description:" "$agent_file"; then
        issues+=("Missing required field: description")
        score=$((score - 20))
    fi

    # Check for invalid fields (subagent-specific)
    for field in "${INVALID_FIELDS[@]}"; do
        if grep -q "^${field}:" "$agent_file"; then
            issues+=("Invalid field for subagent: ${field}")
            score=$((score - 15))
        fi
    done

    # Check model value if present
    if grep -q "^model:" "$agent_file"; then
        local model
        model=$(grep "^model:" "$agent_file" | sed 's/model: //' | sed 's/["'\'']//g' | xargs)
        local valid_model=false
        for valid in "${VALID_MODELS[@]}"; do
            if [[ "$model" == "$valid" ]]; then
                valid_model=true
                break
            fi
        done
        if [[ "$valid_model" == "false" ]]; then
            warnings+=("Unknown model: ${model}")
            score=$((score - 5))
        fi
    fi

    # Check tools format
    if grep -q "^tools:" "$agent_file"; then
        # Tools should be a list
        if ! grep -A 5 "^tools:" "$agent_file" | grep -q "^\s*-"; then
            issues+=("tools field must be a list")
            score=$((score - 10))
        fi
    fi

    # Check disallowedTools format
    if grep -q "^disallowedTools:" "$agent_file"; then
        if ! grep -A 5 "^disallowedTools:" "$agent_file" | grep -q "^\s*-"; then
            issues+=("disallowedTools field must be a list")
            score=$((score - 10))
        fi
    fi

    # Report results
    local agent_name
    agent_name=$(basename "$agent_file" .md)

    echo "Validating: $agent_name"

    if [[ $score -ge 90 ]]; then
        local grade="A"
        local status="✅ Exemplary"
    elif [[ $score -ge 75 ]]; then
        local grade="B"
        local status="✅ Good"
    elif [[ $score -ge 60 ]]; then
        local grade="C"
        local status="⚠️  Adequate"
    elif [[ $score -ge 40 ]]; then
        local grade="D"
        local status="❌ Poor"
    else
        local grade="F"
        local status="❌ Failing"
    fi

    echo ""
    echo "Quality Score: ${score}/100"
    echo "Grade: ${grade} (${status})"

    if [[ ${#issues[@]} -gt 0 ]]; then
        echo ""
        echo "❌ Issues (${#issues[@]}):"
        for issue in "${issues[@]}"; do
            echo "  ${issue}"
        done
    fi

    if [[ ${#warnings[@]} -gt 0 ]]; then
        echo ""
        echo "⚠️  Warnings (${#warnings[@]}):"
        for warning in "${warnings[@]}"; do
            echo "  ${warning}"
        done
    fi

    if [[ $score -ge 75 ]]; then
        echo ""
        echo "✅ PASS: Agent configuration is valid"
        return 0
    else
        echo ""
        echo "❌ FAIL: Agent configuration needs improvement"
        return 1
    fi
}

# Parse arguments
if [[ $# -lt 1 ]]; then
    usage
fi

validate_agent "$1"
