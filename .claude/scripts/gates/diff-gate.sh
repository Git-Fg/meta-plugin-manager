#!/bin/bash
set -euo pipefail

# Diff Gate - Phase 6 of Verification Loop
# Reviews changes for potential issues

LOG_FILE="${HOME}/.claude/homunculus/verification-log.jsonl"

start_time=$(date +%s)
warnings=()

# Check for commented-out code in staged changes
echo "[Diff Gate] Checking for commented-out code..."
if git diff --cached 2>/dev/null | grep -E '^\+.*//.*code|^\+.*#.*code' &> /dev/null; then
  warnings+=("Commented-out code detected in changes")
fi

# Check for TODO/FIXME left in changes
echo "[Diff Gate] Checking for TODO/FIXME..."
if git diff --cached 2>/dev/null | grep -E '^\+.*TODO|^\+.*FIXME|^\+.*XXX|^\+.*HACK' &> /dev/null; then
  warnings+=("TODO/FIXME comments left in changes")
fi

# Check for large files being added
echo "[Diff Gate] Checking for large files..."
while IFS= read -r file; do
  size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo 0)
  if [ "$size" -gt 1048576 ]; then # 1MB
    warnings+=("Large file being added: $file ($((size / 1024))KB)")
  fi
done < <(git diff --cached --name-only --diff-filter=A 2>/dev/null)

end_time=$(date +%s)
duration=$((end_time - start_time))

# Diff gate produces warnings, not failures
if [ ${#warnings[@]} -gt 0 ]; then
  log_result "warn" "$(IFS=,; echo "${warnings[*]}")" "$duration"
  echo "[Diff Gate] ⚠ Warnings:" >&2
  for warn in "${warnings[@]}"; do
    echo "  - $warn" >&2
  done
  exit 0  # Warnings don't block
fi

log_result "pass" "" "$duration"
echo "[Diff Gate] ✓ Passed (${duration}s)"
exit 0

log_result() {
  local status="$1"
  local error="$2"
  local duration="${3:-0}"
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  echo "{\"timestamp\":\"$timestamp\",\"gate\":\"diff\",\"status\":\"$status\",\"duration_ms\":$((duration * 1000))${error:+,\"error\":\"$error\"}}" >> "$LOG_FILE"
}
