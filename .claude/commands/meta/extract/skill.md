---
description: "Extract skill candidate from conversation. Use when identifying automatable logic suitable for skill. Keywords: extract, skill, candidate, automatable."
argument-hint: "[logic-description]"
---

<mission_control>
<objective>Identify automatable logic for skill creation</objective>
<success_criteria>Skill candidate specified with type and rationale</success_criteria>
</mission_control>

## Quick Start

**If extracting skill:** Review conversation, explore codebase, ask questions iteratively, create skill.

## Patterns

### Skill Extraction Flow

1. **Review conversation** - Look for complex automatable logic
2. **Explore codebase** - Find related context
3. **Ask questions** - use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively to clarify scope
4. **Create skill** - Write SKILL.md content
5. **Confirm** - Present for approval

### Command vs Skill Decision

| Factor | Command | Skill |
|--------|---------|-------|
| Freedom | High (agent decides) | Low (prescribed steps) |
| Structure | Single file | SKILL.md + optional references/ |
| Injection | @ and ! supported | Not supported |
| Length | Short (~50 lines) | Variable (~100-400 lines) |
| Reuse | One-off tasks | Repeated patterns |

### Skill Structure Reference

```markdown
---
name: skill-name
description: "Brief description. Use when [condition]. Keywords: [auto-discovery]."
---

<mission_control>
<objective>What this skill achieves</objective>
<success_criteria>How to verify success</success_criteria>
</mission_control>

## Quick Start

**If you need X:** Do Y

## Navigation

| If you need... | Read this section... |
| :------------- | :------------------- |
| Topic A | ## PATTERN: Core A |
| Topic B | ## PATTERN: Core B |

## PATTERN: Core Pattern

[Main content with examples]

---

<critical_constraint>
Trust Claude to identify skill candidates. use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively until scope is clear.
</critical_constraint>
