---
description: "Identify recurring patterns. Use when noticing the same issues or approaches. Keywords: patterns, recurring, identify, trends."
argument-hint: "[pattern-type]"
---

<mission_control>
<objective>Analyze conversation for recurring patterns</objective>
<success_criteria>Patterns identified with frequency and suggested actions</success_criteria>
</mission_control>

## Quick Start

**If identifying patterns:** Review conversation, explore codebase, ask questions iteratively, document patterns.

## Patterns

### Pattern Identification Flow

1. **Review conversation** - Look for recurring issues, questions, approaches
2. **Explore codebase** - Find related context
3. **Ask questions** - use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively to clarify type
4. **Document patterns** - Record findings with frequency
5. **Confirm** - Present for approval

### Pattern Categories

| Category | Description | Example |
|----------|-------------|---------|
| Issues | Problems that repeat | Same type of bug multiple times |
| Questions | Recurring inquiries | Same clarification asked repeatedly |
| Approaches | Common solutions | Same pattern used across tasks |
| Anti-patterns | Patterns to avoid | Recurring mistakes |

---

<critical_constraint>
Trust Claude to identify patterns from conversation. use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively until type is clear.
</critical_constraint>
