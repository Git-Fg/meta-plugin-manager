---
description: "Capture reusable pattern from conversation. Use when identifying approaches worth reusing. Keywords: pattern, reusable, approach, capture."
argument-hint: "[pattern-name]"
---

<mission_control>
<objective>Document reusable pattern from conversation</objective>
<success_criteria>Pattern documented with context and usage guidance</success_criteria>
</mission_control>

## Quick Start

**If capturing a pattern:** Review conversation, ask questions iteratively, document pattern.

## Patterns

### Pattern Capture Flow

1. **Review conversation** - Identify reusable approaches
2. **Ask questions** - use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively to clarify when, why, how
3. **Structure pattern** - Follow pattern documentation format
4. **Confirm** - Present for approval

### Pattern Structure Example

```markdown
## Pattern: [Name]

### When to Use
[Conditions that trigger this pattern]

### Why
[Benefits and rationale]

### How
[Implementation guidance]

### Example
```[language]
[Code example]
```

### Related
[Related patterns or skills]
```

---

<critical_constraint>
Trust Claude to identify patterns from conversation. use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively until pattern is clear.
</critical_constraint>
