#!/bin/bash
set -euo pipefail

# Build Gate - Phase 1 of Verification Loop
# Verifies the project builds successfully

LOG_FILE="${HOME}/.claude/homunculus/verification-log.jsonl"
mkdir -p "$(dirname "$LOG_FILE")"

start_time=$(date +%s)

# Detect project type and run appropriate build command
if [ -f "package.json" ]; then
  # Node.js project
  echo "[Build Gate] Detected Node.js project"

  # Detect package manager
  if command -v pnpm &> /dev/null && [ -f "pnpm-lock.yaml" ]; then
    echo "[Build Gate] Using pnpm"
    pnpm build 2>&1 || {
      log_result "fail" "pnpm build failed"
      exit 1
    }
  elif command -v yarn &> /dev/null && [ -f "yarn.lock" ]; then
    echo "[Build Gate] Using yarn"
    yarn build 2>&1 || {
      log_result "fail" "yarn build failed"
      exit 1
    }
  else
    echo "[Build Gate] Using npm"
    npm run build 2>&1 || {
      # Check if build script exists
      if ! jq -e '.scripts.build' package.json &> /dev/null; then
        echo "[Build Gate] No build script found, skipping"
        log_result "skip" "No build script"
        exit 2
      fi
      log_result "fail" "npm run build failed"
      exit 1
    }
  fi

elif [ -f "Cargo.toml" ]; then
  # Rust project
  echo "[Build Gate] Detected Rust project"
  cargo build 2>&1 || {
    log_result "fail" "cargo build failed"
    exit 1
  }

elif [ -f "go.mod" ]; then
  # Go project
  echo "[Build Gate] Detected Go project"
  go build ./... 2>&1 || {
    log_result "fail" "go build failed"
    exit 1
  }

elif [ -f "pom.xml" ]; then
  # Maven project
  echo "[Build Gate] Detected Maven project"
  mvn compile 2>&1 || {
    log_result "fail" "mvn compile failed"
    exit 1
  }

elif [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
  # Gradle project
  echo "[Build Gate] Detected Gradle project"
  gradle build 2>&1 || {
    log_result "fail" "gradle build failed"
    exit 1
  }

elif [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
  # Python project
  echo "[Build Gate] Detected Python project"
  python -m build 2>&1 || {
    log_result "fail" "python build failed"
    exit 1
  }

else
  echo "[Build Gate] No build system detected, skipping"
  log_result "skip" "No build system"
  exit 2
fi

end_time=$(date +%s)
duration=$((end_time - start_time))

log_result "pass" "" "$duration"
echo "[Build Gate] ✓ Passed (${duration}s)"
exit 0

log_result() {
  local status="$1"
  local error="$2"
  local duration="${3:-0}"
  local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

  local log_entry="{\"timestamp\":\"$timestamp\",\"gate\":\"build\",\"status\":\"$status\",\"duration_ms\":$((duration * 1000))"

  if [ -n "$error" ]; then
    log_entry="$log_entry,\"error\":\"$error\""
  fi

  log_entry="$log_entry}"
  echo "$log_entry" >> "$LOG_FILE"
}
