#!/bin/bash
# Guard script to warn about cat commands
# Encourages use of Read tool instead of bash cat

INPUT="$*"

# Check if command contains cat
if echo "$INPUT" | grep -qE '\bcat\s+'; then
  echo "⚠️  WARNING: Cat command detected" >&2
  echo "Consider using the Read tool instead of 'cat' for better performance and safety." >&2
fi

exit 0
