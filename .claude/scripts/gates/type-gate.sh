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
    echo ""
    echo "❌ TYPE GATE FAILED: TypeScript"
    echo ""
    echo "Micro-Prompt: Fix TypeScript type errors"
    echo ""
    echo "1. Run 'tsc --noEmit' to see all errors"
    echo "2. Fix type mismatches in source files"
    echo "3. Run tsc --noEmit again to verify"
    echo ""
    echo "Invocation: skill:typescript-conventions"
    log_result "fail" "TypeScript type check failed"
    exit 1
  }

elif [ -f "pyproject.toml" ] && command -v mypy &> /dev/null; then
  # Python project with mypy
  echo "[Type Gate] Detected Python project with mypy"
  mypy . 2>&1 || {
    echo ""
    echo "❌ TYPE GATE FAILED: mypy"
    echo ""
    echo "Micro-Prompt: Fix mypy type errors"
    echo ""
    echo "1. Run 'mypy .' to see all errors"
    echo "2. Add type annotations or ignore comments"
    echo "3. Run mypy again to verify"
    echo ""
    echo "Invocation: skill:typescript-conventions"
    log_result "fail" "mypy type check failed"
    exit 1
  }

elif [ -f "pyproject.toml" ] && command -v pyright &> /dev/null; then
  # Python project with pyright
  echo "[Type Gate] Detected Python project with pyright"
  pyright . 2>&1 || {
    echo ""
    echo "❌ TYPE GATE FAILED: pyright"
    echo ""
    echo "Micro-Prompt: Fix pyright type errors"
    echo ""
    echo "1. Run 'pyright .' to see all errors"
    echo "2. Add type annotations or suppress strict mode"
    echo "3. Run pyright again to verify"
    echo ""
    echo "Invocation: skill:typescript-conventions"
    log_result "fail" "pyright type check failed"
    exit 1
  }

elif [ -f "go.mod" ]; then
  # Go project
  echo "[Type Gate] Detected Go project"
  go vet ./... 2>&1 || {
    echo ""
    echo "❌ TYPE GATE FAILED: go vet"
    echo ""
    echo "Micro-Prompt: Fix Go vet errors"
    echo ""
    echo "1. Run 'go vet ./...' to see all issues"
    echo "2. Fix suspicious code patterns"
    echo "3. Run go vet again to verify"
    echo ""
    echo "Invocation: skill:quality-standards"
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
