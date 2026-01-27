# Agent Triggering Examples: Best Practices

Complete guide to writing effective `<example>` blocks in agent descriptions for reliable triggering.

## Proactive Activation Language

**Strong activation language ensures agents trigger reliably.**

For critical agents that MUST run proactively, use strong activation keywords in your description:

### Activation Keywords

| Keyword | Usage | When to Use |
|---------|-------|-------------|
| `PROACTIVELY` | Agent runs automatically after relevant work | Code review, security analysis, validation |
| `MUST BE USED` | Mandatory gate that cannot be skipped | Security reviews, quality checks, testing |
| `Automatically activated` | Triggers based on context without asking | Planning, analysis, documentation |
| `Immediately after` | Timing-specific activation | Post-commit, post-deployment checks |
| `Before [action]` | Pre-condition gate | Before commit, before deploy |

### Strong vs Weak Activation

**Strong activation (use these):**
```yaml
# Proactive + Mandatory
description: Expert code reviewer. Use PROACTIVELY after writing code.
MUST BE USED for all code changes before commit.

# Automatic triggering
description: Expert planner. Automatically activated for feature
implementation requests exceeding 5 files.

# Timing-specific with mandate
description: Security analyzer. MUST BE USED immediately after
implementing authentication, payment, or data handling code.

# Pre-condition gate
description: Test validator. MUST BE USED before committing any test
changes to ensure quality.
```

**Weak activation (avoid these):**
```yaml
❌ "Use this agent for code review"
❌ "Helps with planning tasks"
❌ "Can be used for security analysis"
❌ "Available for validation"
```

### Pattern: Proactive After Work

```yaml
---
name: code-reviewer
description: Expert code quality reviewer. Use PROACTIVELY after writing
or modifying code. MUST BE USED for all code changes. Examples:

<example>
Context: User just finished implementing a feature
user: "I've added the user authentication system"
assistant: "Great! Let me review the implementation."
<commentary>
Code was written (authentication is security-critical). PROACTIVELY
trigger code-reviewer agent for mandatory security and quality review.
</commentary>
assistant: "I'll use the code-reviewer agent to analyze the authentication code."
</example>

<example>
Context: User explicitly requests review
user: "Can you review my changes?"
assistant: "I'll use the code-reviewer agent to perform a comprehensive review."
<commentary>
Explicit review request also triggers the agent.
</commentary>
---
```

### Pattern: Automatic Activation

```yaml
---
name: architect
description: Software architecture specialist. Automatically activated
for architectural decisions, system design, and complex refactoring.
Use PROACTIVELY when planning features affecting 3+ files. Examples:

<example>
Context: User requests complex feature implementation
user: "I need to add real-time collaboration across multiple components"
assistant: "This requires architectural planning."
<commentary>
Multi-component feature request (affects 3+ files). Automatically
trigger architect agent for system design.
</commentary>
assistant: "I'll use the architect agent to design the architecture."
</example>
---
```

### Pattern: Mandatory Pre-Condition

```yaml
---
name: security-analyzer
description: Security vulnerability specialist. MUST BE USED before
deploying any code handling user input, authentication, or payments.
Use PROACTIVELY after implementing security-critical features. Examples:

<example>
Context: User implemented payment processing
user: "I've added the Stripe integration for payments"
assistant: "Let me review this for security issues."
<commentary>
Payment code is security-critical. MUST USE security-analyzer
before this can be deployed.
</commentary>
assistant: "I'll use the security-analyzer agent to conduct a security review."
</example>
---
```

### Pattern: Timing-Specific

```yaml
---
name: test-validator
description: Test quality specialist. Use PROACTIVELY after writing
tests. MUST BE USED before committing test changes. Examples:

<example>
Context: User wrote tests for a new feature
user: "I've added tests for the user registration flow"
assistant: "Let me validate the test quality."
<commentary>
Tests were written. PROACTIVELY validate test quality before commit.
</commentary>
assistant: "I'll use the test-validator agent to review the tests."
</example>
---
```

### Summary: Writing Strong Descriptions

Combine strong keywords with clear conditions:

```yaml
# Template
description: [Role]. [STRONG KEYWORD] when [condition].
[MORE STRONG KEYWORDS] for [scenario]. Examples:

# Examples
description: Expert code reviewer. Use PROACTIVELY after writing code.
MUST BE USED for all changes before commit.

description: Security specialist. MUST BE USED before deploying
authentication/payment code. Use PROACTIVELY for security features.

description: Test generator. Automatically activated for new code
without tests. Use when test coverage is needed.
```

---

## Example Block Format

The standard format for triggering examples:

```markdown
<example>
Context: [Describe the situation - what led to this interaction]
user: "[Exact user message or request]"
assistant: "[How Claude should respond before triggering]"
<commentary>
[Explanation of why this agent should be triggered in this scenario]
</commentary>
assistant: "[How Claude triggers the agent - usually 'I'll use the [agent-name] agent...']"
</example>
```

## Anatomy of a Good Example

### Context

**Purpose:** Set the scene - what happened before the user's message

**Good contexts:**
```
Context: User just implemented a new authentication feature
Context: User has created a PR and wants it reviewed
Context: User is debugging a test failure
Context: After writing several functions without documentation
```

**Bad contexts:**
```
Context: User needs help (too vague)
Context: Normal usage (not specific)
```

### User Message

**Purpose:** Show the exact phrasing that should trigger the agent

**Good user messages:**
```
user: "I've added the OAuth flow, can you check it?"
user: "Review PR #123"
user: "Why is this test failing?"
user: "Add docs for these functions"
```

**Vary the phrasing:**
Include multiple examples with different phrasings for the same intent:
```
Example 1: user: "Review my code"
Example 2: user: "Can you check this implementation?"
Example 3: user: "Look over my changes"
```

### Assistant Response (Before Triggering)

**Purpose:** Show what Claude says before launching the agent

**Good responses:**
```
assistant: "I'll analyze your OAuth implementation."
assistant: "Let me review that PR for you."
assistant: "I'll investigate the test failure."
```

**Proactive example:**
```
assistant: "Great! Now let me review the code quality."
<commentary>
Code was just written, proactively trigger review agent.
</commentary>
```

### Commentary

**Purpose:** Explain the reasoning - WHY this agent should trigger

**Good commentary:**
```
<commentary>
User explicitly requested code review, trigger the code-reviewer agent.
</commentary>

<commentary>
After code implementation, proactively use review agent to check quality.
</commentary>

<commentary>
PR analysis request matches pr-analyzer agent's expertise.
</commentary>
```

**Include decision logic:**
```
<commentary>
User wrote tests (Test tool used). The test-analyzer agent should check
test quality and coverage before continuing.
</commentary>
```

### Assistant Response (Triggering)

**Purpose:** Show how Claude invokes the agent

**Standard pattern:**
```
assistant: "I'll use the [agent-name] agent to [what it will do]."
```

**Examples:**
```
assistant: "I'll use the code-reviewer agent to analyze the changes."
assistant: "Let me use the test-generator agent to create comprehensive tests."
assistant: "I'll use the security-analyzer agent to check for vulnerabilities."
```

## Example Types

### Type 1: Explicit Request

User directly asks for what the agent does:

```markdown
<example>
Context: User explicitly requests security analysis
user: "Check my code for security vulnerabilities"
assistant: "I'll use the security-analyzer agent to perform a thorough security review."
<commentary>
Direct security analysis request triggers the security-analyzer agent.
</commentary>
</example>
```

### Type 2: Proactive Triggering

Agent triggers after relevant work without explicit request:

```markdown
<example>
Context: User just implemented database queries
user: "I've added the user search functionality"
assistant: "Great! Let me review it for security."
<commentary>
Database code written. Proactively trigger security-analyzer to check
for SQL injection and other database security issues.
</commentary>
assistant: "I'll use the security-analyzer agent to check the database code."
</example>
```

### Type 3: Implicit Request

User implies need without stating it directly:

```markdown
<example>
Context: User mentions code is hard to understand
user: "This code is confusing and hard to follow"
assistant: "I can help improve the code clarity."
<commentary>
User indicates complexity issues. Trigger code-simplifier agent to refactor
for better readability.
</commentary>
assistant: "I'll use the code-simplifier agent to suggest improvements."
</example>
```

### Type 4: Tool Usage Pattern

Agent triggers based on prior tool usage:

```markdown
<example>
Context: User made multiple edits to test files
user: "I've updated all the tests"
assistant: "Great! Let me verify test quality."
<commentary>
Multiple Edit tools used on test files. Proactively trigger test-quality-analyzer
to ensure tests follow best practices.
</commentary>
assistant: "I'll use the test-quality-analyzer agent to review the tests."
</example>
```

## Multiple Examples Strategy

### Cover Different Phrasings

```markdown
<example>
user: "Review my code"
[...]
</example>

<example>
user: "Can you check my implementation?"
[...]
</example>

<example>
user: "Look over these changes"
[...]
</example>
```

### Cover Proactive and Reactive

```markdown
<example>
Context: User explicitly requests review
user: "Review my code for issues"
[...]
</example>

<example>
Context: After user writes code
user: "I've implemented the feature"
assistant: "Great! Now let me review it."
<commentary>
Code written, proactively review.
</commentary>
[...]
</example>
```

### Cover Edge Cases

```markdown
<example>
Context: Typical usage
user: "Check my PR"
[...]
</example>

<example>
Context: Large PR that needs thorough analysis
user: "This is a big PR, can you do a deep review?"
[...]
<commentary>
Large PR mentioned, use thorough analysis mode.
</commentary>
</example>
```

## Common Mistakes

### ❌ Missing Context

```markdown
<example>
user: "Review my code"
assistant: "I'll use the code-reviewer agent."
</example>
```

**Why bad:** No context about what led to this request.

### ✅ With Context

```markdown
<example>
Context: User just finished implementing authentication
user: "Review my code"
assistant: "I'll use the code-reviewer agent to analyze the auth implementation."
<commentary>
Auth code written, review for security and best practices.
</commentary>
</example>
```

### ❌ No Commentary

```markdown
<example>
Context: User requests review
user: "Check my changes"
assistant: "I'll use the reviewer agent."
</example>
```

**Why bad:** Doesn't explain WHY agent triggers.

### ✅ With Commentary

```markdown
<example>
Context: User requests review after making changes
user: "Check my changes"
assistant: "I'll use the code-reviewer agent to analyze the modifications."
<commentary>
Code review request triggers agent to check quality, security, and adherence to standards.
</commentary>
</example>
```

### ❌ Agent Responds Directly

```markdown
<example>
user: "Review my code"
assistant: "I found the following issues: [lists issues]"
</example>
```

**Why bad:** Shows agent's output, not triggering.

### ✅ Shows Triggering

```markdown
<example>
user: "Review my code"
assistant: "I'll use the code-reviewer agent to perform the review."
<commentary>
Review request triggers the agent.
</commentary>
</example>
```

## How Many Examples?

### Minimum: 2 Examples

Cover at least:
1. Explicit request
2. One variation or proactive trigger

### Recommended: 3-4 Examples

Cover:
1. Explicit request (direct ask)
2. Implicit request (user implies need)
3. Proactive trigger (after relevant work)
4. Edge case or specific scenario

### Maximum: 6 Examples

More than 6 makes description too long. Focus on most important scenarios.

## Template Library

### Code Review Agent

```markdown
<example>
Context: User just implemented a new feature
user: "I've added the user registration feature"
assistant: "Great! Let me review the code quality."
<commentary>
Code written, proactively trigger code-reviewer agent.
</commentary>
assistant: "I'll use the code-reviewer agent to analyze the implementation."
</example>

<example>
Context: User explicitly requests review
user: "Can you review my changes for issues?"
assistant: "I'll use the code-reviewer agent to perform a thorough review."
<commentary>
Explicit review request triggers the agent.
</commentary>
</example>
```

### Test Generation Agent

```markdown
<example>
Context: User implemented functions without tests
user: "I've added the data processing functions"
assistant: "Great! Let me generate tests for these."
<commentary>
New code without tests, proactively trigger test-generator agent.
</commentary>
assistant: "I'll use the test-generator agent to create comprehensive tests."
</example>

<example>
Context: User explicitly asks for tests
user: "Generate tests for my code"
assistant: "I'll use the test-generator agent to create a complete test suite."
<commentary>
Direct test generation request triggers the agent.
</commentary>
</example>
```

### Documentation Agent

```markdown
<example>
Context: User added new API endpoints
user: "I've implemented the REST API endpoints"
assistant: "I'll document these endpoints."
<commentary>
New API code, proactively generate documentation.
</commentary>
assistant: "I'll use the api-docs-writer agent to create comprehensive documentation."
</example>

<example>
Context: User requests documentation
user: "Write docs for this API"
assistant: "I'll use the api-docs-writer agent to generate clear documentation."
<commentary>
Documentation request triggers the agent.
</commentary>
</example>
```

### Validation Agent

```markdown
<example>
Context: User ready to commit changes
user: "I'm ready to commit this code"
assistant: "Let me validate it first."
<commentary>
Before commit, proactively validate with validation-agent.
</commentary>
assistant: "I'll use the code-validator agent to check for issues."
</example>

<example>
Context: User asks for validation
user: "Validate my implementation"
assistant: "I'll use the code-validator agent to verify correctness."
<commentary>
Explicit validation request triggers the agent.
</commentary>
</example>
```

## Debugging Triggering Issues

### Agent Not Triggering

**Check:**
1. Examples include relevant keywords from user message
2. Context matches actual usage scenarios
3. Commentary explains triggering logic clearly
4. Assistant shows use of Agent tool in examples

**Fix:**
Add more examples covering different phrasings.

### Agent Triggers Too Often

**Check:**
1. Examples are too broad or generic
2. Triggering conditions overlap with other agents
3. Commentary doesn't distinguish when NOT to use

**Fix:**
Make examples more specific, add negative examples.

### Agent Triggers in Wrong Scenarios

**Check:**
1. Examples don't match actual intended use
2. Commentary suggests inappropriate triggering

**Fix:**
Revise examples to show only correct triggering scenarios.

## Best Practices Summary

✅ **DO:**
- Include 2-4 concrete, specific examples
- Show both explicit and proactive triggering
- Provide clear context for each example
- Explain reasoning in commentary
- Vary user message phrasing
- Show Claude using Agent tool

❌ **DON'T:**
- Use generic, vague examples
- Omit context or commentary
- Show only one type of triggering
- Skip the agent invocation step
- Make examples too similar
- Forget to explain why agent triggers

## Conclusion

Well-crafted examples are crucial for reliable agent triggering. Invest time in creating diverse, specific examples that clearly demonstrate when and why the agent should be used.
