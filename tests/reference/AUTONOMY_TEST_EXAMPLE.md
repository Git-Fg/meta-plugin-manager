# Autonomy Testing - Practical Example

## Scenario: Testing a Security Auditor Skill

### Skill Setup
```bash
mkdir -p /project/test_security_auditor/.claude/skills/security-auditor
```

### Skill Content (Autonomous Design)
```markdown
---
name: security-auditor
description: "Audits code for security issues"
user-invocable: true
context: fork
---

# Security Auditor - Autonomous Forked Skill

You are a forked skill auditing code for security vulnerabilities.

**AUTONOMY REQUIREMENT**: You CANNOT ask the user for input.

## Your Decision Criteria

1. **Eval usage**: Always flag as HIGH risk
2. **Hardcoded secrets**: Always flag as CRITICAL
3. **Missing validation**: Always flag as MEDIUM risk
4. **Default action**: If uncertain, flag as LOW risk and document uncertainty

## Your Task

1. Scan the codebase for security issues
2. Classify each issue (CRITICAL/HIGH/MEDIUM/LOW)
3. Provide auto-generated recommendations
4. Complete autonomously

## Output Format

```
## SECURITY_AUDIT_COMPLETE

Issues Found: [count]
- CRITICAL: [list]
- HIGH: [list]
- MEDIUM: [list]
- LOW: [list]

Recommendations:
1. [auto-generated]
2. [auto-generated]
```

You MUST complete without asking the user anything.
```

### Test Execution
```bash
cd /project/test_security_auditor && \
claude --dangerously-skip-permissions -p "Call security-auditor" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 15 \
  > /project/test_security_auditor/test-output.json 2>&1
```

### Autonomy Verification
```bash
# Method 1: Check permission_denials
if grep -q '"permission_denials": \[\]' /project/test_security_auditor/test-output.json; then
  echo "✅ AUTONOMY PASS: No permission denials"
  echo "Score: 100% (A+)"
else
  echo "❌ AUTONOMY FAIL: Permission denials detected"
  grep -A 3 '"permission_denials"' /project/test_security_auditor/test-output.json
fi

# Method 2: Full autonomy check
echo "=== AUTONOMY VERIFICATION ==="
echo "Permission denials: $(grep -o '"permission_denials"' /project/test_security_auditor/test-output.json || echo 'empty')"
echo "Completion marker: $(grep -o 'SECURITY_AUDIT_COMPLETE' /project/test_security_auditor/test-output.json || echo 'MISSING')"
echo "Num turns: $(grep -o '"num_turns": [0-9]*' /project/test_security_auditor/test-output.json | grep -o '[0-9]*' || echo 'N/A')"
echo "Duration: $(grep -o '"duration_ms": [0-9]*' /project/test_security_auditor/test-output.json | grep -o '[0-9]*' || echo 'N/A')ms"
```

### Expected Output Analysis
```bash
# Read the full output
cat /project/test_security_auditor/test-output.json

# Should see:
# - Empty permission_denials: "permission_denials": []
# - Reasonable num_turns: 2-3
# - Completion marker present

# ✅ Perfect autonomy: permission_denials = []
# ✅ Reasonable turns: 2-3
# ✅ Completion marker present
```

### Autonomy Test Report
```markdown
# Autonomy Test Report

## Skill: security-auditor
**Context**: Forked (required autonomy)
**Date**: 2026-01-23

## Test Results

### Autonomy ✅
- Permission denials: 0
- Autonomy score: 100%
- Grade: A+

### Completion ✅
- Completion marker: SECURITY_AUDIT_COMPLETE
- Num turns: 2
- Duration: 15,342ms

### Issues Found
- All decisions made independently
- No questions asked
- Auto-generated recommendations provided
- Completed without user interaction

## Conclusion
✅ PASS - Skill is fully autonomous
```

---

## Testing Multiple Autonomy Scenarios

### Scenario 1: Simple Decision
```markdown
Task: Choose between two options
Expected: 0 permission denials
```

### Scenario 2: Complex Workflow
```markdown
Task: Multi-step analysis with decisions at each step
Expected: 0 permission denials
```

### Scenario 3: Error Handling
```markdown
Task: Handle missing data autonomously
Expected: 0 permission denials, sensible defaults used
```

### Scenario 4: Edge Cases
```markdown
Task: Handle ambiguous situations
Expected: 0 permission denials, reasonable interpretation chosen
```

---

## Batch Autonomy Testing

```bash
#!/bin/bash
# batch-autonomy-test.sh - Test multiple skills for autonomy

SKILLS=("skill-a" "skill-b" "skill-c" "skill-d")

echo "=== BATCH AUTONOMY TESTING ==="
echo ""

for SKILL in "${SKILLS[@]}"; do
  echo "Testing: $SKILL"

  # Run test
  cd /project && \
  claude --dangerously-skip-permissions -p "Call $SKILL" \
    --output-format stream-json \
    --no-session-persistence \
    --max-turns 10 \
    > /tmp/$SKILL-output.json 2>&1

  # Check autonomy
  if grep -q '"permission_denials": \[\]' /tmp/$SKILL-output.json; then
    echo "  ✅ PASS (no questions asked)"
  elif grep -q '"permission_denials"' /tmp/$SKILL-output.json; then
    echo "  ❌ FAIL (questions detected)"
  else
    echo "  ❌ FAIL ($DENIALS denials)"
  fi
  echo ""
done

echo "=== SUMMARY ==="
echo "All skills tested for autonomy"
echo "See /tmp/*-output.json for details"
```

---

## Autonomy Test Integration

### In Test Plan
```markdown
## Test Suite: Skill Validation

### Phase 1: Autonomy
- [ ] Test skill autonomy (permission_denials = 0)
- [ ] Score autonomy (A+ if 0, FAIL if >0)
- [ ] Document autonomy violations if any

### Phase 2: Context
- [ ] Test context isolation
- [ ] Verify forked behavior
- [ ] Check parameter passing

### Phase 3: Functionality
- [ ] Test core functionality
- [ ] Verify completion markers
- [ ] Validate outputs
```

### In Test Results
```markdown
## Test Results

### Autonomy Testing
- Permission denials: 0 ✅
- Autonomy score: 100% (A+) ✅
- Questions asked: 0 ✅

### Context Testing
- Context isolation: PASS ✅
- Parameter passing: PASS ✅

### Overall
- Grade: A
- Status: PASS
```

---

## Autonomy Anti-Pattern Library

### ❌ Pattern 1: Question in Content
```markdown
# This skill will ask questions
"Which option do you prefer? Please tell me..."
```
**Fix**: Remove question, add decision criteria

### ❌ Pattern 2: Seeking Approval
```markdown
# This skill seeks approval
"Should I proceed with this approach?"
```
**Fix**: Add default behavior, remove seeking approval

### ❌ Pattern 3: Missing Criteria
```markdown
# This skill has no decision criteria
"Choose the best approach"
```
**Fix**: Add specific criteria for decisions

### ✅ Pattern 1: Built-in Criteria
```markdown
# This skill has criteria
"Based on TypeScript-first policy, choosing Option A"
```
**Status**: ✅ Autonomous

### ✅ Pattern 2: Default Behaviors
```markdown
# This skill has defaults
"If no config found, use default: strict mode, verbose logging"
```
**Status**: ✅ Autonomous

### ✅ Pattern 3: Auto-Complete
```markdown
# This skill completes independently
"Decision made. Task complete."
## SKILL_COMPLETE
```
**Status**: ✅ Autonomous

---

## Quick Start

1. **Create skill with autonomy requirement**
   ```yaml
   context: fork  # Required for isolation + autonomy
   ```

2. **Add decision criteria to skill content**
   ```markdown
   **Decision criteria**: [specific rules]
   ```

3. **Test with autonomy verification**
   ```bash
   grep '"permission_denials": \[\]' test-output.json
   ```

4. **Verify empty permission_denials**
   ```bash
   Expected: Empty array found
   Pass if: grep finds "permission_denials": []
   Fail if: grep finds non-empty array
   ```

---

This framework ensures every forked skill is systematically tested for autonomy.
