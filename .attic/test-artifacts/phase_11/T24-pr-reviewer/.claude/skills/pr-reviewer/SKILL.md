---
name: pr-reviewer
description: Review pull request changes with live PR data
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob, Bash
---

## PR_REVIEW_START

You are reviewing a pull request with live data injected dynamically.

**Dynamic Context Injection** (executed before skill runs):

- **PR diff**: !`head -100 tests/raw_logs/test_1.1.basic.skill.calling.json`
- **PR title**: !`echo "Add user authentication with JWT"`
- **PR description**: !`echo "Implements JWT-based authentication for API endpoints"`
- **Changed files**: !`echo "src/auth/login.ts, src/auth/middleware.ts, tests/auth/"`
- **Commits**: !`echo "feat(auth): add JWT middleware\nfix: correct error handling\ndocs: update README"`

**Your Task**:

Based on the PR context above, perform comprehensive code review:

1. **Security Review**
   - Check for injection vulnerabilities
   - Verify authentication/authorization
   - Look for secrets exposure
   - Validate input sanitization

2. **Performance Review**
   - Identify N+1 queries
   - Check for inefficient algorithms
   - Look for missing indexes
   - Validate caching strategies

3. **Code Quality Review**
   - Review naming conventions
   - Check for code duplication
   - Verify test coverage
   - Assess maintainability

4. **Architecture Review**
   - Check layer separation
   - Verify dependency injection
   - Assess error handling
   - Review API design

**Output Format**:
```
PR Review: [Title]
Severity: HIGH | MEDIUM | LOW

Security Issues:
- [Issue] (severity)
  File: [path]
  Line: [number]

Performance Issues:
- [Issue] (severity)
  File: [path]
  Line: [number]

Code Quality Issues:
- [Issue] (severity)
  File: [path]
  Line: [number]

Architecture Issues:
- [Issue] (severity)
  File: [path]
  Line: [number]

Overall Assessment: [PASS | NEEDS_CHANGES]
```

Execute review autonomously with dynamic context.

## PR_REVIEW_COMPLETE
