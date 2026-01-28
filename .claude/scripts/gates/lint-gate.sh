#!/bin/bash
set -euo pipefail

# Lint Gate - Phase 3 of Verification Loop
# Verifies code style and quality

LOG_FILE="${HOME}/.claude/homunculus/verification-log.jsonl"

start_time=$(date +%s)

# Detect project type and run appropriate linter
if [ -f ".eslintrc.json" ] || [ -f ".eslintrc.js" ] || [ -f "eslint.config.js" ]; then
  echo "[Lint Gate] Detected ESLint configuration"
  npx eslint . 2>&1 || {
    log_result "fail" "ESLint errors found"
    exit 1
  }

elif [ -f ".pylintrc" ] || [ -f "pyproject.toml" ] && command -v pylint &> /dev/null; then
  echo "[Lint Gate] Detected Python project with pylint"
  pylint **/*.py 2>&1 || {
    log_result "fail" "pylint errors found"
    exit 1
  }

elif [ -f "Cargo.toml" ]; then
  echo "[Lint Gate] Detected Rust project"
  cargo clippy 2>&1 || {
    log_result "fail" "clippy errors found"
    exit 1
  }

elif [ -f "go.mod" ]; then
  echo "[Lint Gate] Detected Go project"
  gofmt -l . | grep -q . && {
    log_result "fail" "Go code not formatted"
    exit 1
  }

else
  echo "[Lint Gate] No linter configured, skipping"
  log_result "skip" "No linter configured"
  exit 2
fi

end_time=$(date +%s)
duration=$((end_time - start_time))

log_result "pass" "" "$duration"
echo "[Lint Gate] ✓ Passed (${duration}s)"
exit 0

log_result() {
  local status="$1"
  local error="$2"
  local duration="${3:-0}"
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  echo "{\"timestamp\":\"$timestamp\",\"gate\":\"lint\",\"status\":\"$status\",\"duration_ms\":$((duration * 1000))${error:+,\"error\":\"$error\"}}" >> "$LOG_FILE"
}
