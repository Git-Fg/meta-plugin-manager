#!/bin/bash
set -euo pipefail

# Security Gate - Phase 5 of Verification Loop
# Verifies no security issues

LOG_FILE="${HOME}/.claude/homunculus/verification-log.jsonl"

start_time=$(date +%s)
issues_found=0
errors=()

# Check for hardcoded secrets in staged changes
echo "[Security Gate] Checking for hardcoded secrets..."
if git diff --cached 2>/dev/null | grep -iE '^\+.*(password|secret|api_key|token|private_key|auth_key).*=.*["\x27]' | grep -vE '(example|test|mock|dummy|placeholder)' &> /dev/null; then
  issues_found=1
  errors+=("Hardcoded secrets detected in staged changes")
fi

# Check for console.log statements in staged changes (only for JS/TS)
echo "[Security Gate] Checking for console.log statements..."
if git diff --cached --name-only 2>/dev/null | grep -E '\.(js|ts|jsx|tsx)$' &> /dev/null; then
  if git diff --cached 2>/dev/null | grep -E '^\+.*console\.(log|debug|info|warn)' | grep -vE '(example|test|mock)' &> /dev/null; then
    issues_found=1
    errors+=("Debug console.log statements detected")
  fi
fi

# Check for world-writable files
echo "[Security Gate] Checking file permissions..."
if find . -type f -perm /o+w ! -path "./.git/*" ! -path "./node_modules/*" 2>/dev/null | grep -q .; then
  issues_found=1
  errors+=("World-writable files detected")
fi

# Run vulnerability audit if package manager supports it
if [ -f "package.json" ] && command -v npm &> /dev/null; then
  echo "[Security Gate] Running npm audit..."
  if npm audit --production 2>&1 | grep -q "vulnerabilities"; then
    # Only fail for high/critical vulnerabilities
    if npm audit --production 2>&1 | grep -E "high|critical" &> /dev/null; then
      issues_found=1
      errors+=("High/critical vulnerabilities detected")
    fi
  fi
fi

end_time=$(date +%s)
duration=$((end_time - start_time))

if [ $issues_found -eq 1 ]; then
  log_result "fail" "$(IFS=,; echo "${errors[*]}")" "$duration"
  echo "[Security Gate] ✗ Failed:" >&2
  for err in "${errors[@]}"; do
    echo "  - $err" >&2
  done
  exit 1
fi

log_result "pass" "" "$duration"
echo "[Security Gate] ✓ Passed (${duration}s)"
exit 0

log_result() {
  local status="$1"
  local error="$2"
  local duration="${3:-0}"
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  echo "{\"timestamp\":\"$timestamp\",\"gate\":\"security\",\"status\":\"$status\",\"duration_ms\":$((duration * 1000))${error:+,\"error\":\"$error\"}}" >> "$LOG_FILE"
}
