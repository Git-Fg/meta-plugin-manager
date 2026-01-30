---
description: "Capture decisions, patterns, gotchas, and context from conversation. Use when documenting key learnings. Keywords: capture, decision, pattern, gotcha, context, lesson, remember."
---

<mission_control>
<objective>Capture important information from conversation for future reference</objective>
<success_criteria>Item captured with context and stored location identified</success_criteria>
</mission_control>

## Quick Start

**To capture something:** Specify type as argument: `/capture decision|pattern|gotcha|context`

## Sub-Commands

| Sub-command | Use when | Skill to invoke |
|-------------|----------|-----------------|
| `/capture decision` | A significant choice was made | `rule-expertise` |
| `/capture pattern` | A reusable solution emerged | `ops:extract` |
| `/capture gotcha` | An issue or pitfall was encountered | `rule-expertise` |
| `/capture context` | Information worth preserving | `rule-expertise` |

## Workflow

1. Parse argument to identify capture type
2. Invoke appropriate skill for documentation patterns
3. Review conversation to identify item
4. Present summary: "Capture [type]: [summary]. Confirm?"

## Argument Handling

- **First argument** determines capture type
- If no argument, prompt user to specify: "What type of item to capture? (decision|pattern|gotcha|context)"

---

<critical_constraint>
Invoke the specified skill before capturing. Present one confirmation question only.
</critical_constraint>
