# Triggering Examples

Use when crafting agent descriptions with effective triggering conditions.

---

## Strong Activation Keywords

| Keyword                   | Usage                    | Example                                         |
| ------------------------- | ------------------------ | ----------------------------------------------- |
| `PROACTIVELY`             | Agent runs automatically | "Use PROACTIVELY after writing code"            |
| `MUST BE USED`            | Mandatory gate           | "MUST BE USED for all code changes"             |
| `Automatically activated` | Context-based trigger    | "Automatically activated for features >5 files" |
| `Immediately after`       | Timing-specific          | "Immediately after implementing auth code"      |
| `Before [action]`         | Pre-condition            | "Before deploying to production"                |

---

## Example Blocks

### Explicit Request

```markdown
<example>
Context: User explicitly requests security analysis
user: "Check my code for security vulnerabilities"
assistant: "I'll use the security-analyzer agent to perform a thorough review."
<commentary>
Direct security analysis request triggers the security-analyzer agent.
</commentary>
</example>
```

### Proactive Trigger

```markdown
<example>
Context: User just implemented database queries
user: "I've added the user search functionality"
assistant: "Great! Let me review it for security."
<commentary>
Database code written. Proactively trigger security-analyzer.
</commentary>
assistant: "I'll use the security-analyzer agent to check the database code."
</example>
```

### Implicit Request

```markdown
<example>
Context: User mentions code is hard to understand
user: "This code is confusing and hard to follow"
assistant: "I can help improve the code clarity."
<commentary>
User indicates complexity issues. Trigger code-simplifier agent.
</commentary>
assistant: "I'll use the code-simplifier agent to suggest improvements."
</example>
```

### Tool Usage Pattern

```markdown
<example>
Context: User made multiple edits to test files
user: "I've updated all the tests"
assistant: "Great! Let me verify test quality."
<commentary>
Multiple Edit tools used on test files. Proactively trigger test-quality-analyzer.
</commentary>
assistant: "I'll use the test-quality-analyzer agent to review the tests."
</example>
```

---

## Minimum Requirements

| Count         | Description                               |
| ------------- | ----------------------------------------- |
| 2 minimum     | 1 explicit + 1 proactive/variation        |
| 3 recommended | Explicit, implicit, proactive             |
| 6 maximum     | Beyond that, description becomes too long |

---

## Common Mistakes

### Missing Context

```markdown
❌ Bad:
<example>
user: "Review my code"
assistant: "I'll use the code-reviewer agent."
</example>
```

### No Commentary

```markdown
❌ Bad:
<example>
Context: User requests review
user: "Check my changes"
assistant: "I'll use the reviewer agent."
</example>
```

### Agent Responds Directly

```markdown
❌ Bad:
<example>
user: "Review my code"
assistant: "I found the following issues: [lists issues]"
</example>
```

---

## Best Practices

- Include 2-4 concrete examples
- Show both explicit and proactive triggering
- Provide clear context for each
- Explain reasoning in commentary
- Vary user message phrasing
- Show Claude using Agent tool
