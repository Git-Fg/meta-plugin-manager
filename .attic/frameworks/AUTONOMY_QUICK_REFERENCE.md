# Autonomy Testing - Quick Reference

## The One-Line Test
```bash
# Check if skill asked questions
grep '"permission_denials": \[\]' test-output.json && echo "✅ PASS" || echo "❌ FAIL"
# Expected: Empty array found
```

## Autonomy Rule

**Forked skills MUST be autonomous** - they cannot ask questions.

## Testing Checklist

### Pre-Test
- [ ] Skill has `context: fork` (for isolation)
- [ ] Skill has built-in decision criteria
- [ ] Skill has default behaviors
- [ ] No question words in skill content
- [ ] Test directory created with absolute path
- [ ] Win condition marker defined

### During Test
```bash
cd /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name
claude --dangerously-skip-permissions -p "Call skill-name" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 10 \
  > /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name/test-output.json 2>&1
```

### Post-Test Verification
```bash
# Check NDJSON structure (3 lines)
[ "$(wc -l < /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name/test-output.json)" -eq 3 ] && echo "✅ NDJSON OK"

# Check permission_denials
grep '"permission_denials": \[\]' /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name/test-output.json && \
  echo "✅ No questions asked"

# Alternative: Check for any permission_denials
if grep -q '"permission_denials"' /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name/test-output.json; then
  echo "⚠️ Found permission_denials in output"
fi

# Check completion
grep "COMPLETE" /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name/test-output.json
```

## Scoring

| Denials | Score | Action |
|---------|-------|--------|
| 0 | 100% | ✅ Pass |
| 1 | 95% | ⚠️ Acceptable |
| 2-3 | 85-90% | ⚠️ Review |
| 4+ | <80% | ❌ Fail |

## Autonomy Template

```markdown
## Autonomous Skill

You are a forked skill. Task: [specific task]

**CRITICAL**: You are in a forked context and CANNOT ask the user.
Make your own decision based on [criteria].

Output: ## AUTONOMY_TEST_COMPLETE with your decision.
```

## Anti-Patterns

❌ **Ask for clarification**
```
"I need to know which approach you prefer..."
```

❌ **Seek approval**
```
"Should I proceed with this plan?"
```

❌ **Defer decision**
```
"You should decide whether to..."
```

## Design Principles

✅ **Built-in criteria**
```
"Based on the TypeScript-first policy, I choose Option A"
```

✅ **Default behaviors**
```
"If no config found, use sensible defaults"
```

✅ **Complete independently**
```
"Decision made and task completed."
```

## Common Test Scenarios

| Test | Purpose | Verification |
|------|---------|--------------|
| Basic autonomy | Single decision | permission_denials = [] |
| Multi-decision | Complex workflow | All decisions autonomous |
| Context fork | Isolation + autonomy | Both verified |
| Error handling | Failure recovery | Autonomous error handling |

## Quick Commands

```bash
# Test autonomy (with absolute paths)
cd /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name
claude --dangerously-skip-permissions -p "Call skill-name" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 10 \
  > /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name/test-output.json 2>&1

# Verify NDJSON structure
[ "$(wc -l < /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name/test-output.json)" -eq 3 ] && echo "✅ 3 lines"

# Verify autonomy
grep '"permission_denials": \[\]' /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name/test-output.json

# Check for questions (if not empty)
grep -A 5 '"permission_denials": \[' /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name/test-output.json

# Check completion marker
grep "COMPLETE" /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name/test-output.json

# View full result section
grep -A 10 '"result"' /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name/test-output.json

# Archive successful tests
mv /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name \
   /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/.attic/test_name_success
```

## Full Framework

See: `tests/AUTONOMY_TESTING_FRAMEWORK.md`
