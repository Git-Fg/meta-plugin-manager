---
description: "Capture context snippet for later reference. Use when wanting to remember specific information. Keywords: context, remember, note, save, reference."
argument-hint: "[topic]"
---

<mission_control>
<objective>Save a context snippet for future reference</objective>
<success_criteria>Context snippet captured with where to store it</success_criteria>
</mission_control>

## Quick Start

**If saving context:** Review conversation, ask questions iteratively, capture context.

## Patterns

### Context Capture Flow

1. **Review conversation** - Identify important context to preserve
2. **Ask questions** - use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively to clarify what, why, where
3. **Structure context** - Follow context snippet format
4. **Confirm** - Present for approval

### Context Snippet Structure Example

```markdown
## Context: [Title]

### What
[Description of the context]

### Why Important
[Rationale for preserving this]

### Duration
[How long this remains relevant]

### Storage
[Where to store this]

### Tags
[Keywords for retrieval]
```

---

<critical_constraint>
Trust Claude to identify context from conversation. use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively until context is clear.
</critical_constraint>
