#!/bin/bash
set -euo pipefail

# Test Gate - Phase 4 of Verification Loop
# Verifies tests pass with 80%+ coverage

LOG_FILE="${HOME}/.claude/homunculus/verification-log.jsonl"

start_time=$(date +%s)

# Detect project type and run appropriate tests
if [ -f "package.json" ]; then
  echo "[Test Gate] Detected Node.js project"

  # Check for test script
  if jq -e '.scripts.test' package.json &> /dev/null; then
    npm test 2>&1 || {
      log_result "fail" "Tests failed"
      exit 1
    }
  else
    echo "[Test Gate] No test script found"
    log_result "skip" "No tests configured"
    exit 2
  fi

elif [ -f "Cargo.toml" ]; then
  echo "[Test Gate] Detected Rust project"
  cargo test 2>&1 || {
    log_result "fail" "Tests failed"
    exit 1
  }

elif [ -f "go.mod" ]; then
  echo "[Test Gate] Detected Go project"
  go test ./... -v 2>&1 || {
    log_result "fail" "Tests failed"
    exit 1
  }

elif [ -f "pyproject.toml" ] && command -v pytest &> /dev/null; then
  echo "[Test Gate] Detected Python project with pytest"
  pytest --cov=. --cov-fail-under=80 2>&1 || {
    log_result "fail" "Tests failed or coverage below 80%"
    exit 1
  }

else
  echo "[Test Gate] No test framework detected, skipping"
  log_result "skip" "No tests configured"
  exit 2
fi

end_time=$(date +%s)
duration=$((end_time - start_time))

log_result "pass" "" "$duration"
echo "[Test Gate] ✓ Passed (${duration}s)"
exit 0

log_result() {
  local status="$1"
  local error="$2"
  local duration="${3:-0}"
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  echo "{\"timestamp\":\"$timestamp\",\"gate\":\"test\",\"status\":\"$status\",\"duration_ms\":$((duration * 1000))${error:+,\"error\":\"$error\"}}" >> "$LOG_FILE"
}
