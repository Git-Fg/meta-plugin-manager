---
description: Drill to root cause by asking why repeatedly
argument-hint: [problem or leave blank for current context]
---

<mission_control>
<objective>Apply 5 Whys technique to drill from symptoms to actionable root cause</objective>
<success_criteria>Root cause identified with specific intervention that prevents recurrence</success_criteria>
</mission_control>

<interaction_schema>
problem_statement → why_1 → why_2 → why_3 → why_4 → why_5 → root_cause → intervention
</interaction_schema>

## Objective

Apply the 5 Whys technique to $ARGUMENTS (or the current discussion if no arguments provided).

Keep asking "why" until you hit the root cause, not just symptoms.

## Process

1. State the problem clearly
2. Ask "Why does this happen?" - Answer 1
3. Ask "Why?" about Answer 1 - Answer 2
4. Ask "Why?" about Answer 2 - Answer 3
5. Continue until you hit a root cause (usually 5 iterations, sometimes fewer)
6. Identify actionable intervention at the root

## Output Format

**Problem:** [clear statement]

**Why 1:** [surface cause]
**Why 2:** [deeper cause]
**Why 3:** [even deeper]
**Why 4:** [approaching root]
**Why 5:** [root cause]

**Root Cause:** [the actual thing to fix]

**Intervention:** [specific action at the root level]

## Success Criteria

- Moves past symptoms to actual cause
- Each "why" digs genuinely deeper
- Stops when hitting actionable root (not infinite regress)
- Intervention addresses root, not surface
- Prevents same problem from recurring

<critical_constraint>
MANDATORY: Each "why" must dig genuinely deeper, not just rephrase
MANDATORY: Stop at actionable root, not infinite regress
MANDATORY: Intervention must address root cause, not surface symptoms
No exceptions. The goal is prevention, not symptom management.
</critical_constraint>
