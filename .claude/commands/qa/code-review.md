---
name: code-review
description: Comprehensive security and quality review of uncommitted changes. Use before: git commit, creating PR, or merging changes. Reviews security issues, code quality, and best practices. Blocks commit if critical issues found.
disable-model-invocation: true
---

<mission_control>
<objective>Perform comprehensive security and quality review of uncommitted changes</objective>
<success_criteria>Review report with CRITICAL/HIGH/MEDIUM/LOW issues, file:line references, and block decision</success_criteria>
</mission_control>

# Code Review Command

Comprehensive security and quality review of uncommitted changes before committing.

## What This Command Does

Perform multi-level review of all uncommitted changes:

1. **Get changed files** - `git diff --name-only HEAD`
2. **Analyze each file for**:
   - **Security Issues (CRITICAL)**: Hardcoded credentials, API keys, tokens, SQL injection, XSS vulnerabilities
   - **Code Quality (HIGH)**: Long functions, large files, deep nesting, missing error handling, console.log, TODOs
   - **Best Practices (MEDIUM)**: Mutation patterns, emoji in code, missing tests, accessibility

3. **Generate report** with severity levels and actionable fixes

4. **Block commit** if CRITICAL or HIGH issues found

**Never approve code with security vulnerabilities!**

## Security Issues (CRITICAL)

### Detection Patterns

```bash
# Check for secrets
git diff | grep -E "(sk-|api_key|token|password|secret)"
grep -rn "sk-" --include="*.ts" --include="*.js" . 2>/dev/null | head -10

# Check for hardcoded credentials
git diff | grep -E "(mongodb://|postgres://|mysql://|redis://)"

# Check for API keys
git diff | grep -E "(AIza|AIzaSy|AKIA|ghp_|github_pat)"
```

### What to Block

- Hardcoded API keys, tokens, passwords
- SQL injection vulnerabilities
- XSS vulnerabilities
- Missing input validation
- Insecure dependencies
- Path traversal risks

## Code Quality Issues (HIGH)

### Detection Patterns

```bash
# Check for long functions
git diff | grep -E "(function|const.*=.*=>)\s*\{" | awk 'length > 50 {print FILE ":" NR ":" length+1 }'

# Check for large files
git diff --name-only | xargs wc -l | awk '$1 > 800 {print $1}'

# Check for deep nesting
git diff | grep -E "^\s{20,}"  # 20+ spaces = 5+ levels

# Check for console.log
git diff | grep -n "console\.log"

# Check for TODO/FIXME
git diff | grep -n "TODO\|FIXME"
```

### What to Flag

- Functions > 50 lines
- Files > 800 lines
- Nesting depth > 4 levels
- Missing error handling
- console.log statements (production code)
- TODO/FIXME comments
- Missing JSDoc for public APIs

## Best Practices (MEDIUM)

### Detection Patterns

```bash
# Check for mutation patterns
git diff | grep -E "(\\.[^=]*=[^=])"  # Direct assignment

# Check for emoji in code
git diff | grep -E ":[a-z_]+:"

# Check for accessibility issues
# (manual review of UI components)
```

### What to Flag

- Mutation patterns (use immutable instead)
- Emoji usage in code/comments
- Missing tests for new code
- Accessibility issues (a11y)

## Report Format

```
CODE REVIEW REPORT
==================

Changed Files: 3

CRITICAL Issues (BLOCKING):
1. [File]:[Line] - Hardcoded API key detected
   - Impact: Security vulnerability, credentials exposure
   - Fix: Remove credentials, use environment variables
   - Block: YES

HIGH Priority Issues:
1. [File]:[Line] - Function is 120 lines (should be < 50)
   - Impact: Maintainability issue
   - Fix: Break into smaller functions
   - Block: NO

MEDIUM Priority Issues:
1. [File]:[Line] - Using mutation instead of immutable pattern
   - Impact: Potential bug, performance issue
   - Fix: Use spread operator or structuredClone
   - Block: NO

LOW Priority Issues:
1. [File]:[Line] - Missing JSDoc for public API
   - Impact: Documentation gap
   - Fix: Add JSDoc comment
   - Block: NO

OVERALL STATUS: [READY FOR COMMIT / HAS BLOCKING ISSUES / NEEDS IMPROVEMENT]

Recommendations:
1. [High-priority improvement suggestion]
2. [Optional enhancement]
```

## Review Process

### 1. Get Changed Files

```bash
git diff --name-only HEAD
git diff HEAD~1 --name-only
```

### 2. Analyze Each File

For each changed file, run:

```bash
# Show full diff
git diff HEAD -- [file]

# Check for specific patterns
git diff HEAD -- [file] | grep -n "console\.log"
```

### 3. Categorize Issues

Assign severity based on impact:

- **CRITICAL**: Security vulnerabilities, exposure of secrets
- **HIGH**: Maintainability blockers, anti-patterns
- **MEDIUM**: Best practice violations, performance issues
- **LOW**: Documentation gaps, minor improvements

### 4. Generate Report

Produce formatted report with:

- Issue severity
- File location and line numbers
- Clear description of the problem
- Suggested fix with code example

### 5. Block Decision

**BLOCK commit if**:

- ANY CRITICAL issues found
- Multiple HIGH issues found
- User requests block after review

## Integration

This command integrates with:

- `verify` - Run after code review for complete quality check
- `coding-standards` - Reference for patterns and anti-patterns
- `security-scan` - Additional security scanning if available

## Arguments

This command does not interpret special arguments. Everything after `qa/code-review` is treated as additional context for the code review process.

**Optional context you can provide**:

- Scope ("only review backend changes")
- Severity threshold ("only show critical and high issues")
- Focus areas ("emphasize security")

---

<critical_constraint>
MANDATORY: Block commit if CRITICAL security issues found
MANDATORY: Block commit if multiple HIGH priority issues found
MANDATORY: Provide file:line references for every issue
MANDATORY: Never approve code with hardcoded credentials or secrets
No exceptions. Security vulnerabilities must always be blocked.
</critical_constraint>
