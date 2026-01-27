#!/bin/bash
set -euo pipefail

# Type Gate - Phase 2 of Verification Loop
# Verifies type safety

LOG_FILE="${HOME}/.claude/homunculus/verification-log.jsonl"

start_time=$(date +%s)

# Detect project type and run appropriate type checking
if [ -f "tsconfig.json" ]; then
  echo "[Type Gate] Detected TypeScript project"
  tsc --noEmit 2>&1 || {
    log_result "fail" "TypeScript type check failed"
    exit 1
  }

elif [ -f "pyproject.toml" ] && command -v mypy &> /dev/null; then
  # Python project with mypy
  echo "[Type Gate] Detected Python project with mypy"
  mypy . 2>&1 || {
    log_result "fail" "mypy type check failed"
    exit 1
  }

elif [ -f "pyproject.toml" ] && command -v pyright &> /dev/null; then
  # Python project with pyright
  echo "[Type Gate] Detected Python project with pyright"
  pyright . 2>&1 || {
    log_result "fail" "pyright type check failed"
    exit 1
  }

elif [ -f "go.mod" ]; then
  # Go project
  echo "[Type Gate] Detected Go project"
  go vet ./... 2>&1 || {
    log_result "fail" "go vet failed"
    exit 1
  }

else
  echo "[Type Gate] No type system detected, skipping"
  log_result "skip" "No type system"
  exit 2
fi

end_time=$(date +%s)
duration=$((end_time - start_time))

log_result "pass" "" "$duration"
echo "[Type Gate] ✓ Passed (${duration}s)"
exit 0

log_result() {
  local status="$1"
  local error="$2"
  local duration="${3:-0}"
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  echo "{\"timestamp\":\"$timestamp\",\"gate\":\"type\",\"status\":\"$status\",\"duration_ms\":$((duration * 1000))${error:+,\"error\":\"$error\"}}" >> "$LOG_FILE"
}
