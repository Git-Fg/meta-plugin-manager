#!/bin/bash
# Verification Loop Wrapper
# Runs all 6 gates sequentially

set -euo pipefail

GATES_DIR="$(dirname "$0")/gates"
echo "[Verification Loop] Starting 6-phase verification..."

# Run gates sequentially
GATES=("build" "type" "lint" "test" "security" "diff")
PASSED=0
FAILED=0
SKIPPED=0

for gate in "${GATES[@]}"; do
  echo ""
  echo "=========================================="
  echo "Phase $((PASSED + FAILED + SKIPPED + 1)): ${gate^} Gate"
  echo "=========================================="

  if "${GATES_DIR}/${gate}-gate.sh"; then
    PASSED=$((PASSED + 1))
  else
    exit_code=$?
    if [ $exit_code -eq 2 ]; then
      SKIPPED=$((SKIPPED + 1))
    else
      FAILED=$((FAILED + 1))
      echo ""
      echo "[Verification Loop] ✗ Failed at ${gate^} Gate"
      echo "[Verification Loop] Passed: $PASSED, Skipped: $SKIPPED, Failed: $FAILED"
      exit 1
    fi
  fi
done

echo ""
echo "=========================================="
echo "[Verification Loop] ✓ All gates passed!"
echo "[Verification Loop] Passed: $PASSED, Skipped: $SKIPPED"
echo "=========================================="
exit 0
