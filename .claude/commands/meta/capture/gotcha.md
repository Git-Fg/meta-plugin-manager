---
description: "Capture gotcha or lesson learned. Use when encountering non-obvious issues worth remembering. Keywords: gotcha, lesson, learned, pitfall."
argument-hint: "[topic]"
---

<mission_control>
<objective>Document gotcha or lesson learned from conversation</objective>
<success_criteria>Gotcha documented with context and prevention guidance</success_criteria>
</mission_control>

## Quick Start

**If capturing a gotcha:** Review conversation, ask questions iteratively, document lesson.

## Patterns

### Gotcha Capture Flow

1. **Review conversation** - Identify lessons learned or pitfalls encountered
2. **Ask questions** - use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively to clarify what, why, how to prevent
3. **Structure gotcha** - Follow gotcha documentation format
4. **Confirm** - Present for approval

### Gotcha Structure Example

```markdown
## Gotcha: [Title]

### What Happened
[Description of the issue]

### Why It Happened
[Root cause analysis]

### How to Detect
[Signs that indicate this issue]

### How to Prevent
[Prevention strategies]

### Related
[Related issues or skills]
```

---

<critical_constraint>
Trust Claude to identify gotchas from conversation. use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively until lesson is clear.
</critical_constraint>
