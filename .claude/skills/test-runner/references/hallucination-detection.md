# Hallucination Detection Framework

**ABSOLUTE CONSTRAINT**: Always verify real execution vs hallucination. The `isSynthetic: true` field indicates internal workflow mechanism, NOT failure.

## Real Execution Verification

**For each expected skill step (A/B/C), assert ALL of these:**

### 1. Tool Use Exists
```json
{
  "type": "assistant",
  "content": [{"type": "tool_use", "name": "Skill", "input": {"skill": "skill-x"}}]
}
```

### 2. Matching Tool Result
```json
{
  "type": "user",
  "content": [{
    "tool_result": {
      "tool_use_id": "SAME_ID_AS_ABOVE",
      "success": true,
      "commandName": "skill-x"
    }
  }]
}
```

### 3. Expected Tool Count
- Define expected `Skill` tool uses per test
- Count actual `{"name": "Skill"}` entries in log
- Verify exactly N tool uses for N expected skills

## Automated Verification (RECOMMENDED)

**Use the `test-runner` skill instead of manual verification**

The `test-runner` skill automatically performs all verification steps:
- Counts skill invocations
- Checks success rates
- Verifies autonomy scores
- Detects execution patterns
- Identifies anomalies

**Call the skill**:
```bash
# The test-runner will analyze test-output.json and provide:
# - Execution pattern detection
# - Skill invocation counts
# - Autonomy scores
# - Success/failure analysis
# - Pattern validation
```

## Manual Verification (if test-runner unclear)

```bash
TEST_LOG="<path-to-test-output.json>"
EXPECTED_COUNT="<expected-number-of-skills>"

echo "🔍 Manual verification of: $TEST_LOG"

# Count real Skill tool uses
ACTUAL_COUNT=$(grep -o '"name":"Skill"' "$TEST_LOG" | wc -l)
echo "Expected: $EXPECTED_COUNT, Actual: $ACTUAL_COUNT"

# Check autonomy
if grep -q '"permission_denials": \[\]' "$TEST_LOG"; then
  echo "✅ AUTONOMY: 100% (no questions)"
fi

# Check for completion markers
if grep -q "COMPLETE" "$TEST_LOG"; then
  echo "✅ COMPLETION: Win conditions met"
fi
```

## Expected Tool Counts by Test Type

| Test Type | Expected Skill Calls | Verification Pattern |
|-----------|---------------------|---------------------|
| Single skill | 1 | 1 tool_use → 1 success |
| Chain (A→B→C) | 3 | 3 sequential tool_uses |
| Forked worker | 1 | 1 tool_use with "forked" status |
| Orchestrator pattern | N | Orchestrator + N workers |
| Nested forks | N | Each fork level = 1 tool_use |

## What is NOT Hallucination

✅ **isSynthetic: true** = Internal workflow mechanism for skill output injection
✅ **Reading SKILL.md** = Part of skill mechanism (progressive disclosure)
✅ **Multiple tool_uses** = Normal for skill chains
✅ **Agent IDs in results** = Real forked execution evidence

## What IS Hallucination

❌ Missing `tool_use` with `name:"Skill"`
❌ No matching `tool_result` for expected skill
❌ Reading SKILL.md via `Bash cat` instead of Skill mechanism
❌ Text-only "skill execution" without tool invocations
