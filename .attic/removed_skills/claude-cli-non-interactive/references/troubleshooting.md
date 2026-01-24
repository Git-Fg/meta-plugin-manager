# Test Troubleshooting

Common test failures and solutions.

> **MANDATORY**: Never use `cd` to navigate. Only use `cd` in same command as claude to set its working directory. Always use absolute paths.

## Real-Time Monitoring Pattern

**Execute in background, monitor output, cancel on issues:**

```bash
!pwd
mkdir <use-actual-path>test-name

# Run test in background (cd only used to set claude's working directory)
cd <use-actual-path>test-name && claude --dangerously-skip-permissions -p "test prompt" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 10 \
  > <use-actual-path>test-name/test-output.json 2>&1 &
TEST_PID=$!

# Monitor output in real-time (using absolute paths)
while kill -0 $TEST_PID 2>/dev/null; do
  clear
  echo "=== Test Output (last 10 lines) ==="
  tail -n 10 <use-actual-path>test-name/test-output.json 2>/dev/null || echo "Waiting..."

  # Check for early failure indicators
  grep -qi "error\|fail\|exception" <use-actual-path>test-name/test-output.json 2>/dev/null && {
    kill $TEST_PID 2>/dev/null
    echo "Test failed - cancelling and fixing issue"
    break
  }

  sleep 2
done

# Final output and cleanup
cat <use-actual-path>test-name/test-output.json
rm <use-actual-path>test-name/test-output.json
rm -rf <use-actual-path>test-name
```

## Issue: High Question Count

**Symptom**: `"permission_denials"` array has >3 entries.

**Cause**: Skill asks questions instead of executing autonomously.

**Fix**:
1. Add specific context to skill instructions
2. Include decision-making criteria in SKILL.md
3. Provide examples of expected outcomes

```markdown
## Decision Criteria
- Use X when condition A
- Use Y when condition B
- Default to X unless Z is detected
```

## Issue: Missing Completion Markers

**Symptom**: No `## MARKER_NAME` in result field.

**Cause**: Skill doesn't output required marker.

**Fix**: Ensure skill has explicit completion section:

```markdown
## WIN CONDITION
Must output: ## SKILL_COMPLETE
```

## Issue: Context Leakage

**Symptom**: Forked skill accesses main conversation variables.

**Cause**: Missing `context: fork` in frontmatter.

**Fix**: Add to skill frontmatter:

```yaml
---
context: fork
---
```

## Issue: Timeout / Max Turns Exceeded

**Symptom**: `"stop_reason": "max_turns_reached"` in result.

**Cause**: Loop, too-complex workflow, or insufficient turn budget.

**Fix**:
1. Check for infinite loops in skill logic
2. Increase `--max-turns` for complex workflows
3. Break complex task into sub-skills

## Issue: Skills Not Loading

**Symptom**: Test skill missing from line 1 `"skills"` array.

**Cause**: Incorrect skill directory structure or YAML syntax.

**Fix**:
```
.claude/skills/skill-name/SKILL.md  # Correct
.claude/skills/skill-name.md         # Wrong
.claude/skills/SKILL.md              # Wrong
```

## Issue: Wrong Output Format

**Symptom**: Text output instead of NDJSON.

**Cause**: Missing `--output-format stream-json --verbose`.

**Fix**: Always use stream-json with verbose for print mode.

## Issue: Permission Prompts Blocking

**Symptom**: Test hangs indefinitely.

**Cause**: Missing `--dangerously-skip-permissions`.

**Fix**: Always include for non-interactive testing.

## Debug via NDJSON Structure

**Line 1 (system init)** - Verify setup:
- `"skills"`: Your test skills listed?
- `"mcp_servers"`: Required servers connected?
- `"agents"`: Custom agents available?

**Line 3 (result)** - Verify execution:
- `"num_turns"`: Expected range?
- `"permission_denials"`: Should be empty
- `"duration_ms"`: Within expected time?
- `"total_cost_usd"`: Reasonable cost?

## Path Navigation Best Practices

**WRONG** ❌:
```bash
cd test-name
claude -p "test" > output.json 2>&1
cat output.json
```

**CORRECT** ✅:
```bash
!pwd  # Get actual path
mkdir <use-actual-path>test-name
cd <use-actual-path>test-name && claude -p "test" > <use-actual-path>test-name/output.json 2>&1
cat <use-actual-path>test-name/output.json
rm <use-actual-path>test-name/output.json
rm -rf <use-actual-path>test-name
```
