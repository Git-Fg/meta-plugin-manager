#!/bin/bash
set -euo pipefail

# Read input from stdin
input=$(cat)
command=$(echo "$input" | jq -r '.tool_input.command // empty')

# Check if this is specifically rm -rf (recursive force delete)
# Pattern matches: rm -rf with any flags, or rm -r -f
if [[ "$command" =~ ^[[:space:]]*rm[[:space:]]+(-rf|-fr|-r[[:space:]]+-f|-f[[:space:]]*-r)[[:space:]] ]]; then
    echo '[Hook] BLOCKED: rm -rf detected. This cannot be undone.' >&2
    echo "[Hook] Command: $command" >&2
    echo '[Hook] Use "trash" command instead: moves files to OS trash (recoverable)' >&2

    # Exit with code 2 to block the command
    # (Hook documentation: exit 2 = block, exit 0 = allow)
    exit 2
fi

# Check for destructive rm patterns with path traversal
if [[ "$command" =~ rm[[:space:]].*\.\./ ]]; then
    echo '[Hook] BLOCKED: rm with path traversal detected.' >&2
    echo "[Hook] Command: $command" >&2
    exit 2
fi

# Allow non-dangerous commands
exit 0
