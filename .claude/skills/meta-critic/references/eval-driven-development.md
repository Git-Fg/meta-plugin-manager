# Eval-Driven Development (EDD)

Formal evaluation framework for validating component quality and detecting regressions.

---

## Philosophy

Eval-Driven Development treats evals as the "unit tests of AI development":
- Define expected behavior BEFORE implementation
- Run evals continuously during development
- Track regressions with each change
- Use pass@k metrics for reliability measurement

**Integration with Meta-Critic**: Use EDD principles when validating components. Treat evals as Success Criteria that can be objectively verified.

---

## Eval Types

### Capability Evals

Test if Claude can do something it couldn't before:

```markdown
[CAPABILITY EVAL: feature-name]
Task: Description of what Claude should accomplish
Success Criteria:
  - [ ] Criterion 1
  - [ ] Criterion 2
  - [ ] Criterion 3
Expected Output: Description of expected result
```

**Use for**: New features, enhanced capabilities, expanded scope

### Regression Evals

Ensure changes don't break existing functionality:

```markdown
[REGRESSION EVAL: feature-name]
Baseline: SHA or checkpoint name
Tests:
  - existing-test-1: PASS/FAIL
  - existing-test-2: PASS/FAIL
  - existing-test-3: PASS/FAIL
Result: X/Y passed (previously Y/Y)
```

**Use for**: Refactoring, updates, dependency changes

---

## Grader Types

### 1. Code-Based Grader

Deterministic checks using code:

```bash
# Check if file contains expected pattern
grep -q "export function handleAuth" src/auth.ts && echo "PASS" || echo "FAIL"

# Check if tests pass
npm test -- --testPathPattern="auth" && echo "PASS" || echo "FAIL"

# Check if build succeeds
npm run build && echo "PASS" || echo "FAIL"

# Check for required files
test -f ".claude/skills/my-skill/SKILL.md" && echo "PASS" || echo "FAIL"
```

**When to use**: Objective, verifiable criteria

### 2. Model-Based Grader

Use Claude to evaluate open-ended outputs:

```markdown
[MODEL GRADER PROMPT]
Evaluate the following code change:
1. Does it solve the stated problem?
2. Is it well-structured?
3. Are edge cases handled?
4. Is error handling appropriate?

Score: 1-5 (1=poor, 5=excellent)
Reasoning: [explanation]
```

**When to use**: Subjective quality assessment, design review

### 3. Human Grader

Flag for manual review:

```markdown
[HUMAN REVIEW REQUIRED]
Change: Description of what changed
Reason: Why human review is needed
Risk Level: LOW/MEDIUM/HIGH
```

**When to use**: Security changes, destructive operations, complex architecture

---

## Metrics

### pass@k

"At least one success in k attempts"
- **pass@1**: First attempt success rate
- **pass@3**: Success within 3 attempts
- **pass@5**: Success within 5 attempts

**Typical target**: pass@3 > 90%

### pass^k

"All k trials succeed"
- Higher bar for reliability
- **pass^3**: 3 consecutive successes
- **pass^5**: 5 consecutive successes

**Use for**: Critical paths, security-sensitive operations

---

## Eval Workflow

### 1. Define (Before Coding)

```markdown
## EVAL DEFINITION: feature-xyz

### Capability Evals
1. Can create new user account
2. Can validate email format
3. Can hash password securely

### Regression Evals
1. Existing login still works
2. Session management unchanged
3. Logout flow intact

### Success Metrics
- pass@3 > 90% for capability evals
- pass^3 = 100% for regression evals
```

### 2. Implement

Write code to pass the defined evals.

### 3. Evaluate

```bash
# Run capability evals
[Run each capability eval, record PASS/FAIL]

# Run regression evals
npm test -- --testPathPattern="existing"

# Generate report
```

### 4. Report

```markdown
EVAL REPORT: feature-xyz
========================

Capability Evals:
  create-user:     PASS (pass@1)
  validate-email:  PASS (pass@2)
  hash-password:   PASS (pass@1)
  Overall:         3/3 passed

Regression Evals:
  login-flow:      PASS
  session-mgmt:    PASS
  logout-flow:     PASS
  Overall:         3/3 passed

Metrics:
  pass@1: 67% (2/3)
  pass@3: 100% (3/3)

Status: READY FOR REVIEW
```

---

## Integration with Meta-Critic

### Using EDD in Validation

When reviewing components, apply EDD principles:

1. **Define Success Criteria** - What must this component achieve?
2. **Apply Graders** - Code-based for objective, model-based for subjective
3. **Track Metrics** - Document pass@k for reliability
4. **Check Regressions** - Verify existing functionality preserved

### Example Meta-Critic Integration

```markdown
### High Priority Issues

**Missing Success Criteria**
- **File**: .claude/skills/my-skill/SKILL.md
- **Issue**: No objective validation criteria defined
- **Standard**: EDD requires evals be defined before implementation
- **Fix**: Add Success Criteria section with measurable outcomes

**Suggestion**: Consider code-based grader for verification:
```bash
# Verify skill loads
grep -q "name: my-skill" .claude/skills/my-skill/SKILL.md && echo "PASS"
```
```

---

## Eval Storage

Store evals in project:

```
.claude/
  evals/
    feature-xyz.md      # Eval definition
    feature-xyz.log     # Eval run history
    baseline.json       # Regression baselines
```

---

## Best Practices

1. **Define evals BEFORE coding** - Forces clear thinking about success criteria
2. **Run evals frequently** - Catch regressions early
3. **Track pass@k over time** - Monitor reliability trends
4. **Use code graders when possible** - Deterministic > probabilistic
5. **Human review for security** - Never fully automate security checks
6. **Keep evals fast** - Slow evals don't get run
7. **Version evals with code** - Evals are first-class artifacts

---

## Quick Reference

| Grader Type | When to Use | Example |
|-------------|-------------|---------|
| Code-based | Objective criteria | File exists, tests pass, build succeeds |
| Model-based | Subjective quality | Code review, design assessment |
| Human | Security/destructive | Auth changes, database migrations |

| Metric | Meaning | Target |
|--------|---------|--------|
| pass@1 | First attempt success | Maximize for speed |
| pass@3 | Success within 3 attempts | >90% for reliability |
| pass@5 | Success within 5 attempts | >95% for robustness |
| pass^3 | 3 consecutive successes | 100% for critical paths |
