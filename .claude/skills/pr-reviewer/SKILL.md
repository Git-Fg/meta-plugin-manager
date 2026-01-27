---
name: pr-reviewer
description: "Review pull requests. Use when: Analyzing PRs for spec compliance, security, performance, and code quality. Not for: Writing new code or initial development."
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob, Bash
---

# PR Reviewer

Review pull request changes with comprehensive analysis including security, performance, code quality, and architecture.

## Dynamic Context Injection

This skill uses dynamic context injection with `!`command"` syntax to gather live PR data before review:

```markdown
## Current Context

- **PR diff**: !`git diff HEAD~1`
- **PR title**: !`git log -1 --pretty=format:%s`
- **PR description**: !`git log -1 --pretty=format:%b`
- **Changed files**: !`git diff --name-only HEAD~1`
- **Commits**: !`git log --oneline HEAD~1..HEAD`
```

## Two-Stage Review Architecture

**MANDATORY**: PR review must follow two-stage process:

1. **Stage 1**: Spec Compliance Review - Verify implementation matches requirements
2. **Stage 2**: Code Quality Review - Assess security, performance, quality, architecture

**NEVER skip stages or review out of order.**

### Stage 1: Spec Compliance Review

**First, verify implementation matches requirements:**

#### Spec Compliance Checklist

- [ ] All requirements from PR description implemented
- [ ] Nothing extra added (YAGNI violations)
- [ ] Acceptance criteria met
- [ ] Edge cases addressed
- [ ] No missing functionality

#### Spec Compliance Output

```markdown
## Stage 1: Spec Compliance Review

### Requirements Verification

✅ All required features implemented
✅ No extra features (YAGNI compliant)
✅ Acceptance criteria met

### Gap Analysis

- Missing: [List any gaps]
- Extra: [List any over-implementation]
- Ambiguous: [List unclear requirements]

**Result**: COMPLIANT | NON_COMPLIANT
```

### Stage 2: Code Quality Review

<router>
flowchart TD
    Start([Start Review]) --> Stage1{Stage 1:\nSpec Compliance}
    Stage1 -- PASS --> Stage2{Stage 2:\nCode Quality}
    Stage1 -- FAIL --> Return[Return to User\n(Fix Spec)]
    Stage2 -- PASS --> Approve[Approve PR]
    Stage2 -- FAIL --> RequestChanges[Request Changes\n(Fix Code)]
    RequestChanges --> Return
</router>

**Only after Stage 1 passes:**

Execute comprehensive review across four dimensions:

#### 1. Security Review

- Check for injection vulnerabilities (SQL, XSS, command injection)
- Verify authentication/authorization implementation
- Look for secrets exposure in code
- Validate input sanitization
- Check for OWASP Top 10 vulnerabilities

### 2. Performance Review

- Identify N+1 query problems
- Check for inefficient algorithms
- Look for missing database indexes
- Validate caching strategies
- Review API response times

### 3. Code Quality Review

- Review naming conventions
- Check for code duplication
- Verify test coverage
- Assess maintainability
- Check for code complexity issues

### 4. Architecture Review

- Check layer separation (MVC, clean architecture)
- Verify dependency injection
- Assess error handling patterns
- Review API design
- Check for proper abstractions

## Output Format

Provide structured feedback:

```markdown
PR Review: [PR Title]
Severity: HIGH | MEDIUM | LOW

Security Issues:

- [Issue] (severity)
  File: [path]
  Line: [number]
  Recommendation: [specific fix]

Performance Issues:

- [Issue] (severity)
  File: [path]
  Line: [number]
  Recommendation: [specific fix]

Code Quality Issues:

- [Issue] (severity)
  File: [path]
  Line: [number]
  Recommendation: [specific fix]

Architecture Issues:

- [Issue] (severity)
  File: [path]
  Line: [number]
  Recommendation: [specific fix]

Overall Assessment: PASS | NEEDS_CHANGES
```

## Review Loop Enforcement

**CRITICAL**: If issues found, fixes must be verified before approval.

### Review Loop Protocol

1. **Reviewer finds issues** → Report all issues clearly
2. **Developer fixes issues** → Resubmit for review
3. **Reviewer re-reviews** → Verify fixes actually work
4. **Repeat until approved** → No shortcuts, no exceptions

**NEVER approve with open issues.**

### Review Loop Template

```markdown
## Review Results

### Stage 1: Spec Compliance

**Status**: PASS | FAIL
[If FAIL: List specific gaps]

### Stage 2: Code Quality

**Status**: PASS | FAIL

#### Issues Found:

1. **[Severity]** - [Issue]
   - File: [path]
   - Line: [number]
   - Fix: [specific recommendation]

#### Required Changes:

- [ ] Fix issue 1
- [ ] Fix issue 2
- [ ] Re-review after fixes

**Review will continue until all issues resolved.**
```

## Review Checklist

### Security

- [ ] No SQL injection vulnerabilities
- [ ] XSS protection implemented
- [ ] Authentication properly checked
- [ ] Authorization enforced
- [ ] No secrets in code
- [ ] Input validation present
- [ ] Rate limiting configured

### Performance

- [ ] No N+1 queries
- [ ] Efficient algorithms used
- [ ] Proper indexing strategy
- [ ] Caching implemented where appropriate
- [ ] API responses optimized

### Code Quality

- [ ] Consistent naming conventions
- [ ] No code duplication
- [ ] Adequate test coverage
- [ ] Clear, readable code
- [ ] Proper error handling
- [ ] No commented-out code

### Architecture

- [ ] Proper layer separation
- [ ] Dependencies properly injected
- [ ] Errors handled appropriately
- [ ] API follows REST conventions
- [ ] Appropriate design patterns used

## Integration

This skill integrates with:

- `security` - Security vulnerability detection
- `coding-standards` - Code quality standards
- `backend-patterns` - Architecture best practices
- `tdd-workflow` - Testing requirements
