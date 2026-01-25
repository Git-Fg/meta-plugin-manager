#!/usr/bin/env bash
# scaffold_skill.sh - Create new skill with proper structure
#
# Dependencies: None (bash built-ins only)
#
# Exit Codes:
#   0 - Success
#   1 - Input validation error
#   2 - File system error
#   3 - Invalid skill name

set -euo pipefail

# Configuration
SKILL_DIR="${CLAUDE_PROJECT_DIR}/.claude/skills"
DEFAULT_CONTEXT="regular"
DEFAULT_USER_INVOCABLE="true"

usage() {
    cat << 'EOF'
Usage: scaffold_skill.sh [OPTIONS]

Creates a new skill with proper YAML structure and templates.

OPTIONS:
  --name NAME              Skill name (required, kebab-case)
  --description TEXT       Skill description (required, What-When-Not format)
  --context TYPE           Context type: regular|fork (default: regular)
  --user-invocable BOOL    User invocable: true|false (default: true)
  --force                  Overwrite if exists

EXAMPLES:
  scaffold_skill.sh --name analyze-data \
    --description "Analyze CSV files. Use when processing data. Not for real-time."

  scaffold_skill.sh --name code-scanner \
    --description "Scan codebase for patterns. Use when auditing." \
    --context fork

EOF
    exit 1
}

# Input validation
validate_name() {
    local name="$1"
    if [[ ! "$name" =~ ^[a-z][a-z0-9-]*[a-z0-9]$ ]]; then
        echo "ERROR: Invalid skill name '$name'. Use kebab-case (lowercase with hyphens)."
        exit 3
    fi
}

validate_description() {
    local desc="$1"
    if [[ -z "$desc" ]]; then
        echo "ERROR: Description cannot be empty."
        exit 1
    fi
}

# Main scaffold function
scaffold_skill() {
    local name="$1"
    local description="$2"
    local context="${3:-$DEFAULT_CONTEXT}"
    local user_invocable="${4:-$DEFAULT_USER_INVOCABLE}"
    local force="${5:-false}"

    # Create skill directory
    local skill_path="${SKILL_DIR}/${name}"
    if [[ -d "$skill_path" && "$force" != "true" ]]; then
        echo "ERROR: Skill directory already exists: $skill_path"
        echo "Use --force to overwrite."
        exit 2
    fi

    mkdir -p "$skill_path"

    # Generate SKILL.md
    local context_block=""
    local agent_block=""
    local completion_marker

    # Uppercase completion marker (portable)
    completion_marker=$(echo "$name" | tr '[:lower:]' '[:upper:]')_COMPLETE

    if [[ "$context" == "fork" ]]; then
        context_block="context: fork"
        agent_block="agent: Explore"
    fi

    cat > "${skill_path}/SKILL.md" << SKILL_EOF
---
name: ${name}
description: "${description}"
user-invocable: ${user_invocable}
${context_block}
${agent_block}
---

# ${name}

## Core Purpose
[Brief description of what this skill achieves]

## Capabilities
[List of functions/actions this skill performs]

## Examples
[1-2 concrete examples]

## ${completion_marker}
SKILL_EOF

    # Create references directory
    mkdir -p "${skill_path}/references"

    echo "✅ Skill created: ${skill_path}/SKILL.md"
    echo "   Next: Edit SKILL.md to add capabilities and examples"
}

# Parse arguments
NAME=""
DESCRIPTION=""
CONTEXT="$DEFAULT_CONTEXT"
USER_INVOCABLE="$DEFAULT_USER_INVOCABLE"
FORCE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --name)
            NAME="$2"
            shift 2
            ;;
        --description)
            DESCRIPTION="$2"
            shift 2
            ;;
        --context)
            CONTEXT="$2"
            shift 2
            ;;
        --user-invocable)
            USER_INVOCABLE="$2"
            shift 2
            ;;
        --force)
            FORCE=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "ERROR: Unknown option: $1"
            usage
            ;;
    esac
done

# Validate required arguments
if [[ -z "$NAME" || -z "$DESCRIPTION" ]]; then
    echo "ERROR: --name and --description are required."
    usage
fi

validate_name "$NAME"
validate_description "$DESCRIPTION"

# Set CLAUDE_PROJECT_DIR if not set
if [[ -z "${CLAUDE_PROJECT_DIR:-}" ]]; then
    export CLAUDE_PROJECT_DIR="$(pwd)"
fi

# Create skill
scaffold_skill "$NAME" "$DESCRIPTION" "$CONTEXT" "$USER_INVOCABLE" "$FORCE"

exit 0
