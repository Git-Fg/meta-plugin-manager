---
name: pr-reviewer
description: Review pull request changes with live PR data
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob, Bash
---

## PR_REVIEW_START

Review pull request changes with live PR data.

**Dynamic Context Injection** (template for PR data):

The following variables should be injected before skill execution:
- **PR diff**: {PR_DIFF} - Full diff of changes
- **PR title**: {PR_TITLE} - Pull request title
- **PR description**: {PR_DESCRIPTION} - Pull request description
- **Changed files**: {CHANGED_FILES} - List of modified files
- **Commits**: {COMMITS} - Commit messages

**Example injection format** (see references/pr-data-injection.md for details):
```bash
# Pre-execution hook should inject PR context
PR_DIFF=$(git diff origin/main...HEAD)
PR_TITLE=$(git log -1 --pretty=%s)
# ... etc
```

**Your Task**:

Based on the injected PR context, perform comprehensive code review:

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
