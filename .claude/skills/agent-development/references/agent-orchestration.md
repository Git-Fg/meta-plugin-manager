# Agent Orchestration Patterns

Guide to coordinating multiple agents for complex, multi-stage workflows.

---

## Sequential Agent Workflows

For complex tasks requiring multiple stages of analysis and action, use sequential agent workflows. Each agent builds on the previous agent's work through structured handoffs.

### Workflow Types

#### Feature Workflow
Full feature implementation from planning to security validation:

```
planner -> tdd-guide -> code-reviewer -> security-reviewer
```

**Use for:** New feature implementation, multi-file changes, complex functionality

**Flow:**
1. **Planner**: Creates implementation plan, identifies dependencies, breaks down phases
2. **TDD Guide**: Writes tests first, implements to pass tests, ensures coverage
3. **Code Reviewer**: Analyzes implementation quality, checks best practices
4. **Security Reviewer**: Validates security, checks vulnerabilities (especially for auth/payments)

#### Bugfix Workflow
Investigation and fix for reported issues:

```
explorer -> tdd-guide -> code-reviewer
```

**Use for:** Bug investigation, error resolution, unexpected behavior

**Flow:**
1. **Explorer**: Investigates issue, identifies root cause, locates affected code
2. **TDD Guide**: Writes reproduction test, implements fix, verifies solution
3. **Code Reviewer**: Validates fix quality, checks for regression

#### Refactor Workflow
Safe refactoring with validation:

```
architect -> code-reviewer -> tdd-guide
```

**Use for:** Large refactoring, architectural changes, system redesign

**Flow:**
1. **Architect**: Analyzes current state, designs new architecture, documents trade-offs
2. **Code Reviewer**: Validates refactoring approach, checks for breaking changes
3. **TDD Guide**: Ensures tests still pass, adds tests for new structure

#### Security Workflow
Security-focused deep review:

```
security-reviewer -> code-reviewer -> architect
```

**Use for:** Security audits, authentication/payment implementation, compliance checks

**Flow:**
1. **Security Reviewer**: Identifies vulnerabilities, assesses risk, provides remediation
2. **Code Reviewer**: Checks code quality in context of security findings
3. **Architect**: Evaluates architectural security implications, recommends systemic improvements

---

## Handoff Document Format

Between agents in a sequential workflow, use structured handoff documents to pass context and findings.

### Handoff Template

```markdown
## HANDOFF: [previous-agent-name] -> [next-agent-name]

### Context
[Summary of what was done in previous stage]
[Task scope and objectives]

### Findings
[Key discoveries, decisions, or insights from previous agent]
[Technical decisions made and rationale]

### Files Modified
- `path/to/file1.ext`: [Change summary]
- `path/to/file2.ext`: [Change summary]

### Open Questions
[Unresolved items that next agent should address]
[Ambiguities or uncertainties requiring further investigation]

### Recommendations
[Suggested next steps for next agent]
[Specific areas to focus on or investigate]

### Risks Identified
[Risks discovered that next agent should consider]
[Potential issues to watch for]
```

### Handoff Examples

#### Example 1: Planner to TDD Guide

```markdown
## HANDOFF: planner -> tdd-guide

### Context
Planned implementation of user authentication system with JWT tokens. Scope includes login, logout, token refresh, and password reset functionality.

### Findings
- Authentication should use JWT with 15-minute expiration
- Token refresh endpoint required for UX
- Password reset needs secure token generation
- Session management requires Redis for revocation

### Files to Create
- `src/auth/auth.controller.ts`: Login/logout endpoints
- `src/auth/jwt.service.ts`: Token generation and validation
- `src/auth/password-reset.service.ts`: Password reset logic
- `src/auth/session.service.ts`: Session management with Redis

### Open Questions
- Should we implement multi-factor authentication? (Deferred for now)
- Token refresh rotation strategy needs confirmation

### Recommendations
Focus on core JWT flow first. Ensure tests cover edge cases: expired tokens, invalid signatures, refresh token rotation.

### Risks Identified
- JWT secret management needs secure environment variable configuration
- Redis dependency for sessions adds infrastructure complexity
```

#### Example 2: Code Reviewer to Security Reviewer

```markdown
## HANDOFF: code-reviewer -> security-reviewer

### Context
Reviewed authentication implementation for code quality, best practices, and maintainability.

### Findings
- Code follows project conventions
- Error handling is comprehensive
- Logging appropriately implemented
- One potential security concern noted below

### Files Reviewed
- `src/auth/auth.controller.ts`: Login/logout endpoints
- `src/auth/jwt.service.ts`: Token generation and validation
- `src/middleware/auth.middleware.ts`: Request authentication

### Issues Found
- **Major**: JWT secret stored directly in environment variable without validation
  - Location: `src/auth/jwt.service.ts:15`
  - Impact: Application may start with empty secret, generating insecure tokens
  - Recommendation: Validate secret exists and meets minimum complexity on startup

### Open Questions
- Are there any OWASP vulnerabilities not caught in code review?
- Token expiration timing needs security validation

### Recommendations
Please conduct security-focused review of authentication flows, especially token handling and secret management.

### Risks Identified
- Token refresh flow may be vulnerable to replay attacks
- Password reset tokens may have insufficient entropy
```

---

## Parallel Execution Patterns

For independent operations that don't depend on each other, run agents in parallel to save time.

### When to Use Parallel Execution

**Good candidates for parallel execution:**
- Independent code analysis (security, performance, type safety)
- Multiple file reviews (different modules, independent components)
- Non-blocking validation steps (linting, formatting, testing)
- Multi-perspective analysis (different viewpoints on same code)

**Bad candidates for parallel execution:**
- Sequential dependencies (output of one is input to another)
- Shared resources with conflicts (writing to same files)
- Required ordering (tests must pass before security review)

### Parallel Execution Pattern

```markdown
### Parallel Phase: Independent Analysis
Run simultaneously:
- Agent 1: Security analysis of auth.ts
- Agent 2: Performance review of cache.ts
- Agent 3: Type checking of utils.ts

### Merge Results
Combine outputs into single report
```

### Parallel vs Sequential Decision

| Scenario | Pattern | Rationale |
|----------|---------|-----------|
| Security + Performance + Quality review | **Parallel** | Independent checks, no dependencies |
| Planner -> TDD -> Code Review | **Sequential** | Each builds on previous output |
| Multiple file type checking | **Parallel** | Independent files, no conflicts |
| Bug investigation -> Fix -> Validation | **Sequential** | Fix depends on investigation, validation depends on fix |

---

## Multi-Perspective Analysis

For complex problems requiring diverse expertise, use split-role sub-agents to analyze from multiple perspectives.

### Multi-Perspective Pattern

```markdown
For [complex problem], launch multiple specialist agents in parallel:

1. **Factual Reviewer**: Verify correctness, check for bugs, validate logic
2. **Senior Engineer**: Assess code quality, maintainability, patterns
3. **Security Expert**: Identify vulnerabilities, check input handling
4. **Consistency Reviewer**: Verify adherence to conventions and standards
5. **Redundancy Checker**: Look for duplicated code, extraction opportunities
```

### Example: Complex Authentication PR

```markdown
### Multi-Perspective PR Review

Launch simultaneously:

1. **Code Reviewer** (Quality):
   - Code organization and structure
   - Naming conventions
   - Error handling patterns
   - Documentation completeness

2. **Security Reviewer** (Security):
   - OWASP Top 10 vulnerabilities
   - JWT handling and storage
   - Password hashing strength
   - Session management security

3. **Architect** (Design):
   - System design appropriateness
   - Scalability considerations
   - Integration patterns
   - Technical debt implications

4. **TDD Guide** (Testing):
   - Test coverage completeness
   - Test quality and maintainability
   - Edge case coverage
   - Mock appropriateness

### Merge Results
Synthesize findings into comprehensive review with prioritized action items.
```

---

## Orchestration Best Practices

### Start with the Right Agent

**Always start with planner for:**
- Features affecting 5+ files
- Complex functionality with multiple components
- Tasks requiring architectural decisions
- Work with unclear scope or requirements

**Start directly with appropriate agent for:**
- Simple bug fixes (start with explorer)
- Clear single-file changes (start with code-reviewer)
- Specific security review (start with security-reviewer)

### Include Code Reviewer

**Always include code-reviewer agent:**
- Before merging any PR
- After implementing features or fixes
- Before committing refactoring changes
- When code quality is uncertain

### Use Security Reviewer

**Always use security-reviewer agent for:**
- Authentication and authorization code
- Payment processing or financial transactions
- Personal identifiable information (PII) handling
- Any code accepting user input
- Before deploying to production

### Handoff Quality

**Good handoffs:**
- Concise but complete (2-3 paragraphs max)
- Include specific file:line references
- Highlight critical decisions and their rationale
- List open questions clearly
- Provide actionable recommendations

**Bad handoffs:**
- Missing context (why was this done?)
- No file references (where should next agent look?)
- Vague recommendations (what exactly should be done?)
- Missing risks (what could go wrong?)

---

## Workflow Execution Pattern

### Sequential Execution

```markdown
For [workflow-type] workflow:

1. **Invoke [agent-1]** with initial context
2. **Collect output** as structured handoff document
3. **Pass to [agent-2]** with handoff
4. **Collect output** as structured handoff document
5. **Continue through chain**
6. **Aggregate results** into final report
```

### Parallel Execution

```markdown
For independent analysis:

### Parallel Phase
Launch agents simultaneously:
- [agent-1]: [specific task]
- [agent-2]: [specific task]
- [agent-3]: [specific task]

### Merge Results
Combine outputs into single report:
- Aggregate findings
- Prioritize by severity/impact
- Resolve conflicts
- Generate final recommendations
```

### Hybrid Execution

```markdown
### Phase 1: Parallel Analysis
Launch simultaneously:
- [agent-1]: [task]
- [agent-2]: [task]

### Phase 2: Sequential Processing
Pass combined results to:
- [agent-3]: [uses results from phase 1]

### Final Report
Aggregate all findings into comprehensive output
```

---

## Final Report Format

After completing agent workflows, generate a structured final report:

```markdown
ORCHESTRATION REPORT
====================
Workflow: [feature | bugfix | refactor | security]
Task: [task description]
Agents: [agent-chain]

SUMMARY
-------
[One paragraph overview of what was accomplished]

AGENT OUTPUTS
-------------
[Agent-1]: [summary of findings]
[Agent-2]: [summary of findings]
[Agent-3]: [summary of findings]

FILES CHANGED
-------------
- `path/to/file1.ext`: [change summary]
- `path/to/file2.ext`: [change summary]

TEST RESULTS
------------
[Pass/Fail summary, coverage percentage]

SECURITY STATUS
---------------
[Security findings summary, if applicable]

RECOMMENDATION
--------------
SHIP / NEEDS WORK / BLOCKED
[Specific actions needed if not SHIP]
```

---

## Common Anti-Patterns

### Sequential When Parallel Would Work

❌ Bad:
```markdown
First run security-reviewer on auth.ts
Then run code-reviewer on auth.ts
Then run performance review on auth.ts
```

✅ Good:
```markdown
Launch simultaneously:
- Security review of auth.ts
- Code quality review of auth.ts
- Performance review of auth.ts
```

### Parallel When Sequential Required

❌ Bad:
```markdown
Launch simultaneously:
- Planner (creates plan)
- TDD Guide (implements tests)
```

✅ Good:
```markdown
Sequential: planner -> tdd-guide
(TDD Guide needs Planner's output to know what to test)
```

### Missing Handoff Context

❌ Bad:
```markdown
## HANDOFF: planner -> tdd-guide

Done planning. Next agent please.
```

✅ Good:
```markdown
## HANDOFF: planner -> tdd-guide

### Context
Planned authentication system with JWT.

### Files to Create
- `src/auth/jwt.service.ts`
- `src/auth/auth.controller.ts`

### Open Questions
Token refresh strategy needs confirmation.
```

---

## Summary

**Key principles:**
- Sequential for dependent operations (output becomes input)
- Parallel for independent operations (save time)
- Structured handoffs for context continuity
- Multi-perspective for complex problems
- Always include code-reviewer before merge
- Always include security-reviewer for sensitive code

**Decision matrix:**
| Situation | Pattern |
|-----------|---------|
| Complex feature | Sequential: planner -> tdd-guide -> code-reviewer -> security |
| Bug fix | Sequential: explorer -> tdd-guide -> code-reviewer |
| Multiple independent reviews | Parallel: launch all, merge results |
| Multi-faceted problem | Multi-perspective: launch specialists, synthesize |
