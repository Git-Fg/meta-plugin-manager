#!/usr/bin/env bash
# validate_hook.sh - Validate hook configuration
#
# Dependencies: python3 (for JSON handling)
#
# Exit Codes:
#   0 - Validation passed
#   1 - Validation failed

set -euo pipefail

# Configuration
SETTINGS_FILE="${CLAUDE_PROJECT_DIR}/.claude/settings.json"

usage() {
    cat << 'EOF'
Usage: validate_hook.sh

Validates hook configuration in .claude/settings.json.

EXAMPLES:
  validate_hook.sh
EOF
    exit 1
}

# Check python3 availability
if ! command -v python3 &> /dev/null; then
    echo "ERROR: python3 is required"
    exit 1
fi

validate_hook() {
    # Set CLAUDE_PROJECT_DIR if not set
    if [[ -z "${CLAUDE_PROJECT_DIR:-}" ]]; then
        export CLAUDE_PROJECT_DIR="$(pwd)"
    fi

    if [[ ! -f "$SETTINGS_FILE" ]]; then
        echo "❌ FAIL: settings.json does not exist: $SETTINGS_FILE"
        return 1
    fi

    python3 - "$SETTINGS_FILE" "$CLAUDE_PROJECT_DIR" << 'PYTHON_EOF'
import json
import sys
import os

settings_file = sys.argv[1]
project_dir = sys.argv[2]

try:
    with open(settings_file, 'r') as f:
        config = json.load(f)
except json.JSONDecodeError as e:
    print(f"❌ FAIL: Invalid JSON: {e}")
    sys.exit(1)
except FileNotFoundError:
    print(f"❌ FAIL: File not found: {settings_file}")
    sys.exit(1)

# Validate structure
if 'hooks' not in config:
    print("⚠️  WARNING: No 'hooks' key found in settings.json")
    print("   This is valid if you haven't added any hooks yet.")
    sys.exit(0)

hooks = config['hooks']
if not isinstance(hooks, dict):
    print("❌ FAIL: 'hooks' must be an object")
    sys.exit(1)

# Count hooks
total_hooks = 0
issues = []
warnings = []

# Valid events
valid_events = [
    'PreToolUse', 'PostToolUse', 'Stop',
    'SessionStart', 'SessionEnd', 'UserPromptSubmit'
]

# Validate each event
for event_name, hook_list in hooks.items():
    if event_name not in valid_events:
        warnings.append(f"Unknown event type: {event_name}")
        continue

    if not isinstance(hook_list, list):
        issues.append(f"{event_name}: Must be an array")
        continue

    for idx, hook_entry in enumerate(hook_list):
        if not isinstance(hook_entry, dict):
            issues.append(f"{event_name}[{idx}]: Must be an object")
            continue

        if 'matcher' not in hook_entry:
            issues.append(f"{event_name}[{idx}]: Missing 'matcher'")
            continue

        if 'hooks' not in hook_entry:
            issues.append(f"{event_name}[{idx}]: Missing 'hooks' array")
            continue

        hook_defs = hook_entry['hooks']
        if not isinstance(hook_defs, list):
            issues.append(f"{event_name}[{idx}]: 'hooks' must be an array")
            continue

        for hook_def in hook_defs:
            total_hooks += 1

            hook_type = hook_def.get('type', '')
            if hook_type not in ['command', 'prompt']:
                issues.append(f"{event_name}[{idx}]: Unknown hook type '{hook_type}'")
                continue

            if hook_type == 'command':
                if 'command' not in hook_def:
                    issues.append(f"{event_name}[{idx}]: Missing 'command' for command type")
                    continue

                # Check if script exists
                command = hook_def['command']
                # Handle relative paths
                if command.startswith('./'):
                    script_path = os.path.join(project_dir, command)
                    if not os.path.exists(script_path):
                        warnings.append(f"{event_name}[{idx}]: Script not found: {command}")
                    elif not os.access(script_path, os.X_OK):
                        warnings.append(f"{event_name}[{idx}]: Script not executable: {command}")

# Report results
print(f"📊 Found {total_hooks} hook(s)")

if issues:
    print(f"\n❌ Critical Issues ({len(issues)}):")
    for issue in issues:
        print(f"  {issue}")

if warnings:
    print(f"\n⚠️  Warnings ({len(warnings)}):")
    for warning in warnings:
        print(f"  {warning}")

if not issues:
    print(f"\n✅ PASS: Hook configuration is valid")
    sys.exit(0)
else:
    print(f"\n❌ FAIL: Hook configuration has issues")
    sys.exit(1)
PYTHON_EOF
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

validate_hook
