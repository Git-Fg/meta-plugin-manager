---
description: "Review content for conciseness and trust. Use when assessing agent capacities. Keywords: trust, review, conciseness, content."
argument-hint: "[content-area]"
---

<mission_control>
<objective>Review content for conciseness and trust in agent capacities</objective>
<success_criteria>Trust review completed with identified improvements</success_criteria>
</mission_control>

## Quick Start

**If reviewing for trust:** Review rules and skills, explore codebase, ask questions iteratively, propose simplifications.

## Patterns

### Trust Review Flow

1. **Review rules/skills** - Examine for over-constraint
2. **Explore codebase** - Find related context
3. **Ask questions** - use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively to clarify areas
4. **Propose simplifications** - Identify unnecessary constraints
5. **Confirm** - Present for approval

### Over-Constraint Indicators

| Indicator | Description | Example |
|-----------|-------------|---------|
| Verbosity | More words than needed | 10-line explanation of obvious thing |
| Over-specification | Step-by-step scripts | "First do X, then Y, then Z" |
| Behavioral constraints | "ALWAYS do X" | "ALWAYS validate before save" |
| Duplication | Same rule in multiple places | Same constraint repeated |
| Obvious rules | Self-evident guidance | "Use kebab-case" for Python |

---

<critical_constraint>
Trust Claude to identify over-constraint from codebase. use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively until areas are clear.
</critical_constraint>
