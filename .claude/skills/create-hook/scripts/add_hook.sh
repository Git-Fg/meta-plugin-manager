#!/usr/bin/env bash
# add_hook.sh - Add hook to settings.json
#
# Dependencies: python3 (for JSON handling)
#
# Exit Codes:
#   0 - Success
#   1 - Input validation error
#   2 - File system error
#   3 - JSON error

set -euo pipefail

# Configuration
SETTINGS_FILE="${CLAUDE_PROJECT_DIR}/.claude/settings.json"
SCRIPTS_DIR="${CLAUDE_PROJECT_DIR}/.claude/scripts"

usage() {
    cat << 'EOF'
Usage: add_hook.sh [OPTIONS]

Adds a hook to .claude/settings.json.

OPTIONS:
  --event EVENT            Event type: PreToolUse|PostToolUse|Stop (required)
  --matcher MATCHER        Tool pattern or name (required)
  --type TYPE              Hook type: command|prompt (required)
  --command CMD            Script path (for command type)
  --scope SCOPE            Configuration scope: settings|component (default: settings)

EXAMPLES:
  # Add command hook for Write tool
  add_hook.sh --event PreToolUse --matcher Write --type command \
    --command './.claude/scripts/validate.sh'

  # Add prompt hook for Stop event
  add_hook.sh --event Stop --matcher '*' --type prompt

EOF
    exit 1
}

# Check python3 availability
if ! command -v python3 &> /dev/null; then
    echo "ERROR: python3 is required for JSON handling"
    exit 3
fi

add_hook() {
    local event="$1"
    local matcher="$2"
    local hook_type="$3"
    local command="$4"
    local scope="${5:-settings}"

    # Create scripts directory
    mkdir -p "$SCRIPTS_DIR"

    # Create settings.json if doesn't exist
    if [[ ! -f "$SETTINGS_FILE" ]]; then
        cat > "$SETTINGS_FILE" << 'EOF'
{
  "hooks": {}
}
EOF
    fi

    # Use python for safe merge
    python3 - "$event" "$matcher" "$hook_type" "$command" "$SETTINGS_FILE" "$SCRIPTS_DIR" << 'PYTHON_EOF'
import json
import sys
import os

event = sys.argv[1]
matcher = sys.argv[2]
hook_type = sys.argv[3]
command = sys.argv[4]
settings_file = sys.argv[5]
scripts_dir = sys.argv[6]

try:
    with open(settings_file, 'r') as f:
        config = json.load(f)
except json.JSONDecodeError as e:
    print(f"ERROR: Invalid JSON in {settings_file}: {e}")
    sys.exit(1)

# Ensure hooks object exists
if 'hooks' not in config:
    config['hooks'] = {}

# Ensure event array exists
if event not in config['hooks']:
    config['hooks'][event] = []

# Build hook object
hook_obj = {
    'matcher': matcher,
    'hooks': []
}

if hook_type == 'command':
    hook_obj['hooks'].append({
        'type': 'command',
        'command': command
    })
elif hook_type == 'prompt':
    hook_obj['hooks'].append({
        'type': 'prompt'
    })
else:
    print(f"ERROR: Unknown hook type: {hook_type}")
    sys.exit(1)

# Add hook
config['hooks'][event].append(hook_obj)

# Write back
with open(settings_file, 'w') as f:
    json.dump(config, f, indent=2)

print(f"✅ Hook added: {event} → {matcher}")
print(f"   Type: {hook_type}")
if hook_type == 'command':
    print(f"   Command: {command}")
PYTHON_EOF
}

# Parse arguments
EVENT=""
MATCHER=""
TYPE=""
COMMAND=""
SCOPE="settings"

while [[ $# -gt 0 ]]; do
    case $1 in
        --event)
            EVENT="$2"
            shift 2
            ;;
        --matcher)
            MATCHER="$2"
            shift 2
            ;;
        --type)
            TYPE="$2"
            shift 2
            ;;
        --command)
            COMMAND="$2"
            shift 2
            ;;
        --scope)
            SCOPE="$2"
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
if [[ -z "$EVENT" || -z "$MATCHER" || -z "$TYPE" ]]; then
    echo "ERROR: --event, --matcher, and --type are required."
    usage
fi

# Validate command type requires command
if [[ "$TYPE" == "command" && -z "$COMMAND" ]]; then
    echo "ERROR: --command is required for command type"
    exit 1
fi

# Set CLAUDE_PROJECT_DIR if not set
if [[ -z "${CLAUDE_PROJECT_DIR:-}" ]]; then
    export CLAUDE_PROJECT_DIR="$(pwd)"
fi

add_hook "$EVENT" "$MATCHER" "$TYPE" "$COMMAND" "$SCOPE"

exit 0
