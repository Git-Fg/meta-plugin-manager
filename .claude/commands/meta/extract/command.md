---
description: "Extract command candidate from conversation. Use when identifying automatable logic suitable for command. Keywords: extract, command, candidate, automatable."
argument-hint: "[logic-description]"
---

<mission_control>
<objective>Identify automatable logic for command creation</objective>
<success_criteria>Command candidate specified with type and rationale</success_criteria>
</mission_control>

## Quick Start

**If extracting command:** Review conversation, explore codebase, ask questions iteratively, create command.

## Patterns

### Command Extraction Flow

1. **Review conversation** - Look for automatable logic
2. **Explore codebase** - Find related context
3. **Ask questions** - use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively to clarify scope
4. **Create command** - Write command content
5. **Confirm** - Present for approval

### Command vs Skill Decision

| Factor | Command | Skill |
|--------|---------|-------|
| Freedom | High (agent decides) | Low (prescribed steps) |
| Structure | Single file | SKILL.md + optional references/ |
| Injection | @ and ! supported | Not supported |
| Length | Short (~50 lines) | Variable (~100-400 lines) |
| Reuse | One-off tasks | Repeated patterns |

### Command Structure Reference

```markdown
---
description: "Brief action. Use when [condition]. Keywords: [auto-discovery]."
argument-hint: "[expected-arg]"
---

<mission_control>
<objective>What this command achieves</objective>
<success_criteria>How to verify success</success_criteria>
</mission_control>

## Quick Start

**If you need X:** Do Y

## Patterns

[Relevant patterns]

---

<critical_constraint>
Trust Claude to identify command candidates. use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively until scope is clear.
</critical_constraint>
