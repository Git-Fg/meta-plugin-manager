---
description: "Capture decision from conversation. Use when making architectural choices worth documenting. Keywords: decision, record, adr, architecture."
argument-hint: "[topic]"
---

<mission_control>
<objective>Create formal decision record from conversation</objective>
<success_criteria>ADR created with context, alternatives, and rationale</success_criteria>
</mission_control>

## Quick Start

**If documenting a decision:** Review conversation, ask questions iteratively, capture decision.

## Patterns

### Decision Capture Flow

1. **Review conversation** - Identify decisions made
2. **Ask questions** - use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively to clarify context, alternatives, rationale
3. **Structure ADR** - Follow decision record format
4. **Confirm** - Present for approval

### ADR Structure Example

```markdown
## Decision: [Title]

**Status:** [Proposed|Accepted|Deprecated]
**Date:** YYYY-MM-DD

### Context
[What triggered this]

### Decision
[What was chosen]

### Alternatives
[What else was considered]

### Consequences
[Positive and negative outcomes]
```

---

<critical_constraint>
Trust Claude to identify decisions from conversation. use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively until all context is clear.
</critical_constraint>
