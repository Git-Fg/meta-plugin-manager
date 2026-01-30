---
description: "Refine project rules. Use when rules need updating or improvement. Keywords: refine, rules, update, improve, claude."
argument-hint: "[rule-name]"
---

<mission_control>
<objective>Update and improve project rules</objective>
<success_criteria>Rules refined with identified improvements</success_criteria>
</mission_control>

## Quick Start

**If refining rules:** Review rules, explore codebase, ask questions iteratively, apply refinements.

## Patterns

### Refinement Flow

1. **Review rules** - Examine current rules for issues
2. **Explore codebase** - Identify drift between rules and practice
3. **Ask questions** - use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively to clarify what, how
4. **Apply refinements** - Update rules
5. **Confirm** - Present changes for approval

### Refinement Types

| Type | Description | Example |
|------|-------------|---------|
| Clarification | Make vague rules more specific | "Be consistent" → "Use kebab-case" |
| Addition | Add missing rules | New security requirement |
| Removal | Remove obsolete rules | Outdated tooling references |
| Rewriting | Restructure for clarity | New organization |

---

<critical_constraint>
Trust Claude to identify rule improvements from codebase. use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively until scope is clear.
</critical_constraint>
