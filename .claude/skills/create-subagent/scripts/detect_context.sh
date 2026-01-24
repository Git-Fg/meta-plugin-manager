#!/usr/bin/env bash
# detect_context.sh - Detect project/plugin/user context
#
# Exit Codes:
#   0 - Context detected

set -euo pipefail

usage() {
    cat << 'EOF'
Usage: detect_context.sh

Detects the current working context for subagent creation.

OUTPUT FORMAT:
  context_type|agents_directory

EXAMPLES:
  detect_context.sh
  # Output: project|.claude/agents

EOF
    exit 1
}

detect_context() {
    local context=""
    local agents_dir=""

    # Check for plugin context
    if [[ -f "plugin.json" ]]; then
        context="plugin"
        if [[ -d "agents" ]]; then
            agents_dir="agents"
        else
            agents_dir=".claude/agents"
        fi
    elif [[ -d "plugin/agents" ]]; then
        context="plugin"
        agents_dir="plugin/agents"
    # Check for project context
    elif [[ -d ".claude/agents" ]]; then
        context="project"
        agents_dir=".claude/agents"
    # Check for user context
    elif [[ -d "$HOME/.claude/agents" ]]; then
        context="user"
        agents_dir="$HOME/.claude/agents"
    # Default to project context
    else
        context="project"
        agents_dir=".claude/agents"
    fi

    echo "${context}|${agents_dir}"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            ;;
        *)
            echo "ERROR: Unknown option: $1"
            usage
            ;;
    esac
done

detect_context
