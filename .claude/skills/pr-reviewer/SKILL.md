---
name: pr-reviewer
description: "Review pull request changes with live PR data injection for comprehensive code review."
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

## Review Process

Execute comprehensive review across four dimensions:

### 1. Security Review
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
