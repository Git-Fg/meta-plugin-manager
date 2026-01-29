---
name: brainstorm
description: "Guided decision-making for complex problems with multiple variables. Use when exploring options, prioritizing features, or evaluating tradeoffs. Not for simple tasks."
---

# Brainstorm

## Context

This command routes to appropriate analytical framework commands based on problem type:

| Problem Type          | Route To                    |
| --------------------- | --------------------------- |
| Root cause analysis   | `consider:5-whys`           |
| 80/20 prioritization  | `consider:pareto`           |
| Avoiding failure      | `consider:inversion`        |
| Removing vs adding    | `consider:via-negativa`     |
| Cost/benefit analysis | `consider:opportunity-cost` |
| First principles      | `consider:first-principles` |

## Workflow

### 1. Detect

Analyze `$ARGUMENTS` for problem characteristics:

- **Decision type**: choice, prioritization, root cause, innovation
- **Complexity**: simple (one variable) vs complex (multiple variables)
- **Stage**: initial exploration vs trade-off evaluation

Use `AskUserQuestion` (L'Entonnoir) with recognition-based options to identify the analytical framework needed.

### 2. Execute

Route to appropriate command:

| Problem Type          | Route To                    |
| --------------------- | --------------------------- |
| Root cause analysis   | `consider:5-whys`           |
| 80/20 prioritization  | `consider:pareto`           |
| Avoiding failure      | `consider:inversion`        |
| Removing vs adding    | `consider:via-negativa`     |
| Cost/benefit analysis | `consider:opportunity-cost` |
| First principles      | `consider:first-principles` |

### 3. Verify

Confirm decision-making output meets quality criteria:

- Problem space fully mapped
- Options evaluated against constraints
- User recognizes optimal path
- Clear action emerges

---

## Genetic Code

This component carries essential Seed System principles for context: fork isolation:

<critical_constraint>
MANDATORY: All components MUST be self-contained (zero .claude/rules dependency)
MANDATORY: Description MUST use What-When-Not-Includes format in third person
MANDATORY: No component references another component by name in description
MANDATORY: Use XML for control, Markdown for data
No exceptions. Portability invariant must be maintained.
</critical_constraint>
