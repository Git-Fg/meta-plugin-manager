# Execution Modes Reference

Route plan execution based on checkpoint types and quality requirements.

## Mode Selection

| Checkpoint Types                 | Quality Gates?  | Execution Mode |
| -------------------------------- | --------------- | -------------- |
| None                             | No              | AUTONOMOUS     |
| Only `human-verify`              | No              | SEGMENTED      |
| Has `decision` or `human-action` | Any             | MAIN CONTEXT   |
| Any                              | Yes (requested) | REVIEWED       |

## Mode 1: AUTONOMOUS (Fully Subagent)

Use when: Plan has NO checkpoints (`type="auto"`)

Flow:

1. Load PLAN.md
2. Detect: all tasks are `type="auto"`
3. Spawn single subagent with fresh context for entire plan
4. Subagent executes all tasks, creates SUMMARY.md
5. Commit with plan guidance

## Mode 2: SEGMENTED (Subagent + Main Context)

Use when: Plan has ONLY `checkpoint:human-verify` checkpoints

Flow:

1. Parse plan into segments by checkpoint
2. For each autonomous segment: spawn subagent with fresh context
3. At each checkpoint: execute in main context, wait for user verification
4. Continue to next segment with fresh subagent
5. Aggregate results → SUMMARY → commit

## Mode 3: MAIN CONTEXT (Sequential)

Use when: Plan has `checkpoint:decision` or `checkpoint:human-action` checkpoints

Flow:

1. Execute tasks sequentially in main context
2. At checkpoint: present decision/action to user, wait for response
3. Continue execution with decision context
4. Decisions affect subsequent task execution
5. SUMMARY → commit

## Mode 4: REVIEWED (Fresh Subagent + Two-Stage Review)

Use when: Quality gates required OR explicitly requested

Flow per task:

1. Dispatch fresh subagent to implement task
2. Stage 1: Spec compliance review (requirements match implementation?)
3. If fails: send back to implementer → re-review
4. Stage 2: Quality review (security, performance, code quality)
5. If fails: send back to implementer → re-review
6. Mark task complete → proceed to next task

## Quick Reference

| Mode       | Checkpoints     | Session  | Review        | When to Use          |
| ---------- | --------------- | -------- | ------------- | -------------------- |
| AUTONOMOUS | None            | Subagent | No            | Fully auto plans     |
| SEGMENTED  | human-verify    | Mixed    | No            | Verify-then-continue |
| MAIN       | decision/action | Main     | No            | Decision-dependent   |
| REVIEWED   | Any             | Subagent | Yes (2-stage) | Quality-critical     |

## Red Flags

Never:

- Skip mode analysis (jump to execution without determining mode)
- Use batch mode when segmented is appropriate
- Skip checkpoint verification
- Proceed with unfixed review issues

If mode is unclear:

- Re-read plan for checkpoint types
- Check if quality gates are explicitly required
- Default to SEGMENTED if unsure (safer than AUTONOMOUS)
