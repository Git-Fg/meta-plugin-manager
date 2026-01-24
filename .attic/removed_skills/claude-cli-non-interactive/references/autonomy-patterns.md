# Autonomy Testing Patterns

**CRITICAL**: Forked skills MUST complete without asking questions. Verify autonomy.

## Autonomy Verification

```bash
# Check permission_denials array (MANDATORY)
grep -o '"permission_denials": \[\]' <project_path>/test_folder/test-output.json

# Alternative: Check for empty permission_denials
if grep -q '"permission_denials": \[\]' <project_path>/test_folder/test-output.json; then
  echo "✅ PASS: No questions asked"
else
  echo "⚠️ FAIL: Questions detected"
fi
```

**Expected**: `"permission_denials": []` (empty array)

## Autonomy Test Template

```bash
cat > <project_path>/test_autonomy/.claude/skills/test-autonomy/SKILL.md << 'EOF'
---
name: test-autonomy
description: "Tests skill autonomy"
user-invocable: true
context: fork
---

You are a forked skill. Task: Choose between Option A or B for a project.

**CRITICAL**: You are in a forked context and CANNOT ask the user.
Make your own decision based on built-in criteria.

Output: ## AUTONOMY_TEST_COMPLETE with your decision.
EOF

cd <project_path>/test_autonomy && claude --dangerously-skip-permissions -p "Call test-autonomy" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 10 \
  > <project_path>/test_autonomy/test-output.json 2>&1

# Verify autonomy
if grep -q '"permission_denials": \[\]' <project_path>/test_autonomy/test-output.json; then
  echo "✅ AUTONOMY: PASS (no questions asked)"
else
  echo "❌ AUTONOMY: FAIL (questions detected)"
  grep '"permission_denials"' <project_path>/test_autonomy/test-output.json || true
fi
```

## Autonomy Scoring

| Permission Denials | Autonomy Score | Grade |
|-------------------|---------------|-------|
| 0 | 100% | A+ |
| 1 | 95% | A |
| 2-3 | 85-90% | B |
| 4-5 | 75-80% | C |
| 6+ | <75% | FAIL |

## Common Autonomy Violations

- Asking for clarification
- Seeking user approval
- Deferring decisions
- Requesting additional information

## Autonomous Design Principles

✅ **DO**: Include decision criteria in skill content
✅ **DO**: Provide default behaviors for all scenarios
✅ **DO**: Make choices based on project context
✅ **DO**: Complete without user interaction

❌ **DON'T**: Include question words in skill content
❌ **DON'T**: Leave decisions to the user
❌ **DON'T**: Ask for clarification
❌ **DON'T**: Request approval or confirmation
