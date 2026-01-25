# Simple Command Examples

Basic slash command patterns for common use cases.

**Important:** All examples below are written as instructions FOR Claude (agent consumption), not messages TO users. Commands tell Claude what to do, not tell users what will happen.

**Design Philosophy:** These examples demonstrate high-trust commands that specify WHAT to achieve and WHY it matters, then let Claude determine HOW based on context.

## Example 1: Code Review Command

**File:** `.claude/commands/review.md`

```markdown
---
description: Review code for quality and issues
---

Review the code in this repository for:

1. **Code Quality:**
   - Readability and maintainability
   - Consistent style and formatting
   - Appropriate abstraction levels

2. **Potential Issues:**
   - Logic errors or bugs
   - Edge cases not handled
   - Performance concerns

3. **Best Practices:**
   - Design patterns used correctly
   - Error handling present
   - Documentation adequate

Provide specific feedback with file and line references.
```

**Usage:**
```
> /review
```

---

## Example 2: Security Review Command

**File:** `.claude/commands/security-review.md`

```markdown
---
description: Review code for security vulnerabilities
model: sonnet
---

Perform comprehensive security review checking for:

**Common Vulnerabilities:**
- SQL injection risks
- Cross-site scripting (XSS)
- Authentication/authorization issues
- Insecure data handling
- Hardcoded secrets or credentials

**Security Best Practices:**
- Input validation present
- Output encoding correct
- Secure defaults used
- Error messages safe
- Logging appropriate (no sensitive data)

For each issue found:
- File and line number
- Severity (Critical/High/Medium/Low)
- Description of vulnerability
- Recommended fix

Prioritize issues by severity.
```

**Usage:**
```
> /security-review
```

---

## Example 3: Test Command with File Argument

**File:** `.claude/commands/test-file.md`

```markdown
---
description: Run tests for specific file
argument-hint: [test-file]
---

Identify the testing framework used in this project, then run tests for $1.

Analyze results:
- Tests passed/failed
- Code coverage
- Performance issues
- Flaky tests

If failures found, suggest fixes based on error messages.
```

**Usage:**
```
> /test-file src/utils/helpers.test.ts
```

**Note:** This uses an adaptive pattern - it asks Claude to detect the testing framework rather than hardcoding `npm test`.

---

## Example 4: Documentation Generator

**File:** `.claude/commands/document.md`

```markdown
---
description: Generate documentation for file
argument-hint: [source-file]
---

Generate comprehensive documentation for @$1

Include:

**Overview:**
- Purpose and responsibility
- Main functionality
- Dependencies

**API Documentation:**
- Function/method signatures
- Parameter descriptions with types
- Return values with types
- Exceptions/errors thrown

**Usage Examples:**
- Basic usage
- Common patterns
- Edge cases

**Implementation Notes:**
- Algorithm complexity
- Performance considerations
- Known limitations

Format as Markdown suitable for project documentation.
```

**Usage:**
```
> /document src/api/users.ts
```

---

## Example 5: Git Status Summary

**File:** `.claude/commands/git-status.md`

```markdown
---
description: Summarize Git repository status
---

Current repository context:
- Branch: !`git branch --show-current`
- Status: !`git status --short`
- Recent commits: !`git log --oneline -5`
- Remote status: !`git fetch && git status -sb`

Based on the context above, provide:
- Summary of changes
- Suggested next actions
- Any warnings or issues
```

**Usage:**
```
> /git-status
```

**Note:** Uses `!` for context gathering only, then trusts Claude to analyze and suggest actions.

---

## Example 6: Deployment Command

**File:** `.claude/commands/deploy.md`

```markdown
---
description: Deploy to specified environment
argument-hint: [environment]
allowed-tools: Bash(kubectl:*)
disable-model-invocation: true
---

Deploy to $1 environment.

Current context:
!`git log -1 --oneline`
!`git status --short`

Determine and execute the appropriate deployment steps for $1:
- Validate environment configuration exists
- Build application if needed
- Deploy to target environment
- Verify deployment success
- Run smoke tests

Document current version for rollback if issues occur.
```

**Usage:**
```
> /deploy staging
```

**Note:** High-trust approach for deployment - gathers context but lets Claude determine the steps.

---

## Example 7: Comparison Command

**File:** `.claude/commands/compare-files.md`

```markdown
---
description: Compare two files
argument-hint: [file1] [file2]
---

Compare @$1 with @$2

**Analysis:**

1. **Differences:**
   - Lines added
   - Lines removed
   - Lines modified

2. **Functional Changes:**
   - Breaking changes
   - New features
   - Bug fixes
   - Refactoring

3. **Impact:**
   - Affected components
   - Required updates elsewhere
   - Migration requirements

4. **Recommendations:**
   - Code review focus areas
   - Testing requirements
   - Documentation updates needed

Present as structured comparison report.
```

**Usage:**
```
> /compare-files src/old-api.ts src/new-api.ts
```

---

## Example 8: Quick Fix Command

**File:** `.claude/commands/quick-fix.md`

```markdown
---
description: Quick fix for common issues
argument-hint: [issue-description]
model: haiku
---

Quickly fix: $ARGUMENTS

**Approach:**
Identify the issue, find relevant code, and propose a fix.

Focus on:
- Simple, direct solution
- Minimal changes
- Following existing patterns
- No breaking changes

Provide code changes with file paths and line numbers.
```

**Usage:**
```
> /quick-fix button not responding to clicks
> /quick-fix typo in error message
```

---

## Example 9: Research Command

**File:** `.claude/commands/research.md`

```markdown
---
description: Research best practices for topic
argument-hint: [topic]
model: sonnet
---

Research best practices for: $ARGUMENTS

**Coverage:**

1. **Current State:**
   - How we currently handle this
   - Existing implementations

2. **Industry Standards:**
   - Common patterns
   - Recommended approaches
   - Tools and libraries

3. **Comparison:**
   - Our approach vs standards
   - Gaps or improvements needed
   - Migration considerations

4. **Recommendations:**
   - Concrete action items
   - Priority and effort estimates
   - Resources for implementation

Provide actionable guidance based on research.
```

**Usage:**
```
> /research error handling in async operations
> /research API authentication patterns
```

---

## Example 10: Explain Code Command

**File:** `.claude/commands/explain.md`

```markdown
---
description: Explain how code works
argument-hint: [file-or-function]
---

Explain @$1 in detail

**Explanation Structure:**

1. **Overview:**
   - What it does
   - Why it exists
   - How it fits in system

2. **Step-by-Step:**
   - Key algorithms or logic
   - Important details
   - Data flow

3. **Inputs and Outputs:**
   - Parameters and types
   - Return values
   - Side effects

4. **Edge Cases:**
   - Error handling
   - Special cases
   - Limitations

5. **Usage Examples:**
   - How to call it
   - Common patterns
   - Integration points

Explain at level appropriate for junior engineer.
```

**Usage:**
```
> /explain src/utils/cache.ts
> /explain AuthService.login
```

---

## Key Patterns

### Pattern 1: High-Trust Analysis

```markdown
---
description: Analyze and suggest improvements
---

Analyze the codebase for potential improvements.

Focus on:
- Performance bottlenecks
- Code organization
- Test coverage
- Documentation gaps

Provide prioritized recommendations with effort estimates.
```

**Use for:** Code review, documentation, analysis

### Pattern 2: Context Gathering

```markdown
---
description: Review with context
allowed-tools: Bash(git:*)
---

Current changes: !`git diff --name-only`
Current branch: !`git branch --show-current`

Review the changes above for:
- Security issues
- Performance concerns
- Best practices violations
```

**Use for:** Repository status, commit analysis

### Pattern 3: Adaptive Execution

```markdown
---
description: Run tests intelligently
---

Identify the testing framework used, then run the appropriate test suite for $1.

Analyze results and suggest fixes for any failures.
```

**Use for:** File operations, targeted actions

### Pattern 4: File Comparison

```markdown
Compare @$1 with @$2...

Identify functional changes, breaking changes, and migration requirements.
```

**Use for:** Diff analysis, migration planning

### Pattern 5: Outcome-Focused

```markdown
---
description: Investigate performance
---

Investigate performance bottlenecks in the codebase.

Rules of thumb:
- Focus on high-impact areas (database queries, hot paths)
- Consider both code and architecture issues
- Don't modify code during investigation

Provide findings with impact assessment and optimization priorities.
```

**Use for:** Informed decision making

## Tips for Writing Simple Commands

1. **Define outcomes, not steps:** Tell Claude WHAT to achieve, not HOW to do it
2. **Use `!` for context only:** Gather state, then let Claude reason
3. **Provide heuristics:** Use "rules of thumb" instead of rigid validation
4. **Adaptive over static:** Ask Claude to detect patterns rather than hardcoding
5. **Trust AI judgment:** Let Claude determine the best approach based on context
