#!/bin/bash
set -euo pipefail

# Read input from stdin
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Check if this is a dangerous operation
if [[ "$command" =~ (^|[[:space:]])rm([[:space:]]|$) ]]; then
    echo '[Hook] 🚫 BLOCKED: rm usage is dangerous using this tool.' >&2
    echo "[Hook] Command: $command" >&2
    echo '[Hook] 💡 Use "trash" instead: moves files to trash (recoverable)' >&2
    echo '[Hook] 🔄 Alternative: "mv directory .attic/" to safely archive' >&2

    # Exit with code 2 to block the command
    # (Hook documentation: exit 2 = block, exit 0 = allow)
    exit 2
fi

# Allow non-dangerous commands
exit 0
