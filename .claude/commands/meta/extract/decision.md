---
description: "Extract decision record. Use when making architectural choices worth documenting. Keywords: extract, decision, record, adr, architecture."
argument-hint: "[topic]"
---

<mission_control>
<objective>Create formal decision record from conversation</objective>
<success_criteria>ADR created with context, alternatives, and rationale</success_criteria>
</mission_control>

## Quick Start

**If extracting a decision:** Review conversation, explore codebase, ask questions iteratively, create ADR.

## Patterns

### Decision Extraction Flow

1. **Review conversation** - Identify decisions made
2. **Explore codebase** - Find related context
3. **Ask questions** - use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively to clarify details
4. **Create ADR** - Write decision record
5. **Confirm** - Present for approval

### ADR Structure Example

```markdown
## ADR: [Number] - [Title]

**Date:** YYYY-MM-DD
**Status:** [Proposed|Accepted|Deprecated]
**Type:** [Architectural|Technical|Process]

### Context
[What triggered this decision]

### Decision
[What was decided]

### Alternatives
[What else was considered]

### Consequences
Positive:
- [List]

Negative:
- [List]

### Related
[References to other decisions or documents]
```

---

<critical_constraint>
Trust Claude to identify decisions from conversation. use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively until topic is clear.
</critical_constraint>
