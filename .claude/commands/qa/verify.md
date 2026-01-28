---
name: verify
description: Comprehensive verification workflow for quality gates. Use after completing features, before PRs, or when ensuring code quality. Runs build, types, lint, tests, security, and diff checks.
disable-model-invocation: true
---

<mission_control>
<objective>Execute 6-phase verification pipeline (build → type → lint → test → security → diff)</objective>
<success_criteria>All quality gates pass, report generated with any failures identified</success_criteria>
</mission_control>

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

- `Glob: package.json` → `Bash: npm run build | tail -20`
- `Glob: Cargo.toml` → `Bash: cargo build | tail -20`
- `Glob: go.mod` → `Bash: go build | tail -20`

**If build fails**: STOP and fix before continuing.

### Phase 2: Type Check

Verify type safety:

- `Glob: tsconfig.json` → `Bash: tsc --noEmit | head -30`
- `Glob: pyproject.toml` → `Bash: pyright . | head -30`

Report all type errors. Fix critical ones before continuing.

### Phase 3: Lint Check

Enforce code style standards:

- `Glob: package.json` → `Bash: npm run lint | head -30`
- `Glob: pyproject.toml` → `Bash: ruff check . | head -30`

Report warning count. Fix critical style issues.

### Phase 4: Test Suite

Run tests with coverage:

- `Glob: package.json` → `Bash: npm run test -- --coverage | tail -50`
- `Glob: pyproject.toml` → `Bash: pytest --cov=. --cov-report=term-missing | tail -50`

**Target**: 80% minimum coverage.

**Report**:

- Total tests: X
- Passed: X
- Failed: X
- Coverage: X%

### Phase 5: Security Scan

Check for security issues:

- `Grep: "sk-\|api_key\|password" --include="*.ts" --include="*.js"` - Secrets
- `Grep: "console.log" --include="*.ts" --include="*.tsx" src/` - Debug code
- `Bash: git diff --name-only | xargs grep -n "TODO\|FIXME"` - TODOs in diff

### Phase 6: Diff Review

Review what changed:

- `Bash: git diff --stat` - Changed files summary
- `Bash: git diff HEAD~1 --name-only` - Changed file list
- `Bash: git diff` - Actual changes for review

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

- `engineering-lifecycle` - TDD patterns for test-first development
- `quality-standards` - Quality validation framework
- `coding-standards` - Style and convention reference

## Arguments

This command does not interpret special arguments. Everything after `qa/verify` is treated as additional context for the verification report.

**Optional context you can provide**:

- Focus areas ("focus on type errors")
- Severity threshold ("only show critical issues")
- Skip phases ("skip security scan")

---

<critical_constraint>
MANDATORY: Execute all 6 phases in order - stop on first failure
MANDATORY: Provide specific file:line references for all failures
MANDATORY: Report coverage percentage - flag below 80%
MANDATORY: Never skip security scan - secrets in code are catastrophic
No exceptions. Verification must be comprehensive and honest.
</critical_constraint>
