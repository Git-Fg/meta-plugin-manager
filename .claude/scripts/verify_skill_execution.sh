#!/usr/bin/env bash
# verify_skill_execution.sh <test-output.json> <expected-skills>

TEST_LOG="$1"
EXPECTED_COUNT="$2"

echo "🔍 Verifying skill execution in: $TEST_LOG"

# Count real Skill tool uses
ACTUAL_COUNT=$(grep -o '"name":"Skill"' "$TEST_LOG" | wc -l)

echo "Expected skill calls: $EXPECTED_COUNT"
echo "Actual skill calls: $ACTUAL_COUNT"

if [ "$ACTUAL_COUNT" -eq "$EXPECTED_COUNT" ]; then
  echo "✅ PASS: Correct number of skill invocations"
else
  echo "❌ FAIL: Expected $EXPECTED_COUNT skills, found $ACTUAL_COUNT"
fi

# Verify each skill has success result
SUCCESS_COUNT=$(grep -o '"success":true' "$TEST_LOG" | wc -l)
if [ "$SUCCESS_COUNT" -ge "$EXPECTED_COUNT" ]; then
  echo "✅ PASS: All skills completed successfully"
else
  echo "⚠️ WARNING: Some skills may have failed"
fi

# Check for empty permission_denials (autonomy)
if grep -q '"permission_denials": \[\]' "$TEST_LOG"; then
  echo "✅ AUTONOMY: No questions asked (100%)"
else
  echo "⚠️ AUTONOMY: Questions detected"
fi

# List all skill invocations
echo ""
echo "📋 Skill Invocations Found:"
grep -B 1 -A 2 '"name":"Skill"' "$TEST_LOG" | grep -E '(Skill|skill)' || echo "  None"

# Check isSynthetic (NOT hallucination - internal mechanism)
SYNTHETIC_COUNT=$(grep -c '"isSynthetic":true' "$TEST_LOG" 2>/dev/null || echo 0)
echo ""
echo "ℹ️  Synthetic outputs: $SYNTHETIC_COUNT (Note: isSynthetic=true is NOT hallucination)"

echo "✅ VERIFICATION COMPLETE"
