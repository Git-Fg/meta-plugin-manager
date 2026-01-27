---
name: verify
description: Comprehensive verification workflow for quality gates. Use after completing features, before PRs, or when ensuring code quality. Runs build, types, lint, tests, security, and diff checks.
disable-model-invocation: true
---

# Verify Command

Comprehensive quality gate verification for completed work.

## What This Command Does

Execute 6-phase verification pipeline to ensure code quality before committing or creating PRs:

1. **Build Verification** - Confirm project builds successfully
2. **Type Check** - Verify type safety (TypeScript/Python)
3. **Lint Check** - Enforce code style standards
4. **Test Suite** - Run tests with coverage reporting
5. **Security Scan** - Check for secrets, console.log, unsafe patterns
6. **Diff Review** - Review changes for unintended modifications

## How It Works

### Phase 1: Build Verification

Confirm the project builds successfully:

```bash
# Detect and run appropriate build command
if [ -f "package.json" ]; then
  npm run build 2>&1 | tail -20
elif [ -f "Cargo.toml" ]; then
  cargo build 2>&1 | tail -20
elif [ -f "go.mod" ]; then
  go build 2>&1 | tail -20
fi
```

**If build fails**: STOP and fix before continuing.

### Phase 2: Type Check

Verify type safety:

```bash
# TypeScript projects
npx tsc --noEmit 2>&1 | head -30

# Python projects
pyright . 2>&1 | head -30
```

Report all type errors. Fix critical ones before continuing.

### Phase 3: Lint Check

Enforce code style standards:

```bash
# JavaScript/TypeScript
npm run lint 2>&1 | head -30

# Python
ruff check . 2>&1 | head -30
```

Report warning count. Fix critical style issues.

### Phase 4: Test Suite

Run tests with coverage:

```bash
# Run tests with coverage
npm run test -- --coverage 2>&1 | tail -50

# Or for Python
pytest --cov=. --cov-report=term-missing 2>&1 | tail -50
```

**Target**: 80% minimum coverage.

**Report**:
- Total tests: X
- Passed: X
- Failed: X
- Coverage: X%

### Phase 5: Security Scan

Check for security issues:

```bash
# Check for secrets
grep -rn "sk-" --include="*.ts" --include="*.js" --include="*.tsx" . 2>/dev/null | head -10
grep -rn "api_key" --include="*.ts" --include="*.js" . 2>/dev/null | head -10

# Check for console.log in production code
grep -rn "console.log" --include="*.ts" --include="*.tsx" src/ 2>/dev/null | head -10

# Check for TODO/FIXME in new files
git diff --name-only | xargs grep -n "TODO\|FIXME" 2>/dev/null | head -10
```

### Phase 6: Diff Review

Review what changed:

```bash
# Show changed files
git diff --stat

# Show changed file list
git diff HEAD~1 --name-only

# Show actual changes for review
git diff
```

Review each changed file for:
- Unintended changes
- Missing error handling
- Potential edge cases
- Debug code left in

## Output Format

After running all phases, produce a verification report:

```
VERIFICATION REPORT
==================

Build:     [PASS/FAIL]
Types:     [PASS/FAIL] (X errors)
Lint:      [PASS/FAIL] (X warnings)
Tests:     [PASS/FAIL] (X/Y passed, Z% coverage)
Security:  [PASS/FAIL] (X issues)
Diff:      [X files changed]

Overall:   [READY/NOT READY] for PR/commit

Issues to Fix:
1. [Issue description] - File:line
2. [Issue description] - File:line

Recommendations:
1. [Optional improvement suggestion]
```

## Continuous Mode

For long sessions, run verification every 15 minutes or after major changes:

**Checkpoint strategy**:
- After completing each function
- After finishing a component
- Before moving to next task

Run `qa/verify` at each checkpoint.

## Best Practices

1. **Fix build issues first** - Don't waste time on other checks if build fails
2. **Address type errors** - Type errors often hide real bugs
3. **Don't ignore lint warnings** - Style issues compound over time
4. **Watch coverage percentage** - Below 80% means missing tests
5. **Never skip security scan** - Secrets in code are catastrophic
6. **Review your own diff** - You'll catch issues before reviewers do

## Related Skills

This command integrates with:
- `tdd-workflow` - TDD patterns for test-first development
- `meta-critic` - Quality validation framework
- `coding-standards` - Style and convention reference

## Arguments

This command does not interpret special arguments. Everything after `qa/verify` is treated as additional context for the verification report.

**Optional context you can provide**:
- Focus areas ("focus on type errors")
- Severity threshold ("only show critical issues")
- Skip phases ("skip security scan")
