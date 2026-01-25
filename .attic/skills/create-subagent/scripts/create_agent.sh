#!/usr/bin/env bash
# create_agent.sh - Create subagent file
#
# Exit Codes:
#   0 - Success
#   1 - Input validation error
#   2 - File system error

set -euo pipefail

# Configuration
AGENTS_DIR="${CLAUDE_PROJECT_DIR}/.claude/agents"
DEFAULT_TYPE="general-purpose"
DEFAULT_MODEL="sonnet"
DEFAULT_CONTEXT="auto"

usage() {
    cat << 'EOF'
Usage: create_agent.sh [OPTIONS]

Creates a new subagent configuration file.

OPTIONS:
  --name NAME              Agent name (required, kebab-case)
  --description DESC       Agent description (required)
  --type TYPE              Agent type: general-purpose|bash|explore|plan (default: general-purpose)
  --model MODEL            Model: haiku|sonnet|opus (default: sonnet)
  --tools TOOLS            Comma-separated tool allowlist (e.g., Bash,Read)
  --disallowedTools TOOLS  Comma-separated tool denylist (e.g., Write,Edit)
  --context CONTEXT        Context: project|plugin|user|auto (default: auto)

EXAMPLES:
  create_agent.sh --name deploy-agent \
    --description "Automates deployment workflow" \
    --type bash

  create_agent.sh --name code-reviewer \
    --description "Reviews code for quality" \
    --tools Read,Grep,Glob \
    --disallowedTools Write,Edit

EOF
    exit 1
}

detect_context() {
    local context="$1"

    if [[ "$context" == "auto" ]]; then
        # Auto-detect based on directory structure
        if [[ -f "plugin.json" || -d "plugin/agents" ]]; then
            echo "plugin"
            return 0
        elif [[ -d ".claude/agents" ]]; then
            echo "project"
            return 0
        elif [[ -d "$HOME/.claude/agents" ]]; then
            echo "user"
            return 0
        else
            echo "project"
            return 0
        fi
    else
        echo "$context"
        return 0
    fi
}

get_agents_dir() {
    local context="$1"

    case "$context" in
        plugin)
            if [[ -d "plugin/agents" ]]; then
                echo "plugin/agents"
            elif [[ -f "plugin.json" ]]; then
                echo "agents"
            else
                echo ".claude/agents"
            fi
            ;;
        user)
            echo "$HOME/.claude/agents"
            ;;
        project|*)
            echo ".claude/agents"
            ;;
    esac
}

create_agent() {
    local name="$1"
    local description="$2"
    local agent_type="$3"
    local model="$4"
    local tools="$5"
    local disallowed_tools="$6"
    local context="$7"

    # Detect context and determine agents directory
    local detected_context
    detected_context=$(detect_context "$context")

    local agents_dir
    agents_dir=$(get_agents_dir "$detected_context")

    # Create agents directory
    mkdir -p "$agents_dir"

    local agent_file="${agents_dir}/${name}.md"

    # Check if agent already exists
    if [[ -f "$agent_file" ]]; then
        echo "ERROR: Agent file already exists: $agent_file"
        exit 2
    fi

    # Build frontmatter
    local frontmatter="---\n"
    frontmatter+="name: ${name}\n"
    frontmatter+="description: ${description}\n"

    # Only add model if not default
    if [[ "$model" != "$DEFAULT_MODEL" ]]; then
        frontmatter+="model: ${model}\n"
    fi

    # Add tools if specified
    if [[ -n "$tools" ]]; then
        frontmatter+="tools:\n"
        IFS=',' read -ra TOOL_ARRAY <<< "$tools"
        for tool in "${TOOL_ARRAY[@]}"; do
            frontmatter+="  - ${tool}\n"
        done
    fi

    # Add disallowedTools if specified
    if [[ -n "$disallowed_tools" ]]; then
        frontmatter+="disallowedTools:\n"
        IFS=',' read -ra TOOL_ARRAY <<< "$disallowed_tools"
        for tool in "${TOOL_ARRAY[@]}"; do
            frontmatter+="  - ${tool}\n"
        done
    fi

    frontmatter+="---\n"

    # Generate agent file
    cat > "$agent_file" << AGENT_EOF
${frontmatter}

# ${name}

Your role is ${description}.

## Instructions

Add specific instructions for this agent here.
AGENT_EOF

    echo "✅ Agent created: $agent_file"
    echo "   Context: ${detected_context}"
    echo "   Next: Edit the agent file to add specific instructions"
}

# Parse arguments
NAME=""
DESCRIPTION=""
TYPE="$DEFAULT_TYPE"
MODEL="$DEFAULT_MODEL"
TOOLS=""
DISALLOWED_TOOLS=""
CONTEXT="$DEFAULT_CONTEXT"

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
        --type)
            TYPE="$2"
            shift 2
            ;;
        --model)
            MODEL="$2"
            shift 2
            ;;
        --tools)
            TOOLS="$2"
            shift 2
            ;;
        --disallowedTools)
            DISALLOWED_TOOLS="$2"
            shift 2
            ;;
        --context)
            CONTEXT="$2"
            shift 2
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

# Set CLAUDE_PROJECT_DIR if not set
if [[ -z "${CLAUDE_PROJECT_DIR:-}" ]]; then
    export CLAUDE_PROJECT_DIR="$(pwd)"
fi

create_agent "$NAME" "$DESCRIPTION" "$TYPE" "$MODEL" "$TOOLS" "$DISALLOWED_TOOLS" "$CONTEXT"

exit 0
