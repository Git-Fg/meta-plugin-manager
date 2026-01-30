---
description: "Review all components, architecture, or trust. Use when auditing project health. Keywords: review, audit, quality, components, architecture, trust, conciseness."
---

<mission_control>
<objective>Review .claude/ components for quality and consistency</objective>
<success_criteria>Review completed with findings and recommendations</success_criteria>
</mission_control>

## Quick Start

**To audit:** Specify type as argument: `/audit review|architecture|trust`

## Sub-Commands

| Sub-command | Use when | Skill to invoke |
|-------------|----------|-----------------|
| `/audit review` | Auditing project health | `testing-e2e` |
| `/audit architecture` | Assessing design decisions | `quality-standards` |
| `/audit trust` | Reviewing for over-constraint | `simplification-principles` |

## Workflow

1. Parse argument to identify audit type
2. Invoke appropriate skill for assessment
3. Review target content for issues
4. Present findings: "[Type] findings: [list]. Fix? Confirm?"

## Argument Handling

- **First argument** determines audit type
- If no argument, prompt user to specify: "What to audit? (review|architecture|trust)"

---

<critical_constraint>
Invoke the specified skill before auditing. Present one confirmation question only.
</critical_constraint>
