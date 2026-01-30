---
description: "Reflect on session, detect drift, or identify patterns. Use when reviewing work. Keywords: reflect, session, improve, retrospective, drift, patterns, recurring."
---

<mission_control>
<objective>Review and analyze conversation or project state</objective>
<success_criteria>Analysis completed with findings and action items</success_criteria>
</mission_control>

## Quick Start

**To reflect:** Specify type as argument: `/reflect session|drift|patterns`

## Sub-Commands

| Sub-command | Use when | Skill to invoke |
|-------------|----------|-----------------|
| `/reflect session` | Ending session or reviewing work | `ops:reflect` |
| `/reflect drift` | Knowledge may be scattered | `ops:drift` |
| `/reflect patterns` | Noticing recurring issues | `ops:reflect` |

## Workflow

1. Parse argument to identify reflection type
2. Invoke appropriate skill for analysis
3. Review conversation or project for findings
4. Present summary: "[Type] findings: [list]. Document? Confirm?"

## Argument Handling

- **First argument** determines reflection type
- If no argument, prompt user to specify: "What to reflect on? (session|drift|patterns)"

---

<critical_constraint>
Invoke the specified skill before analyzing. Present one confirmation question only.
</critical_constraint>
