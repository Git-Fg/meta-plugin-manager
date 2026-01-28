---
description: "Execute all PLAN.md files in order with fresh context. Use when running complete implementation phases sequentially."
argument-hint: [optional: phase directory or "auto" for all incomplete plans]
---

# Execute All Plans

<mission_control>
<objective>Execute all incomplete PLAN.md files sequentially with fresh context for each</objective>
<success_criteria>All plans executed, SUMMARY.md files created, ROADMAP.md updated</success_criteria>
</mission_control>

## Purpose

Execute all incomplete PLAN.md files in order. Each plan gets fresh context via subagent, preventing context degradation across multiple phases.

## Process

### Find Plans

**If $ARGUMENTS is "auto" or empty:**

Find all incomplete plans:

- `Glob: .claude/workspace/planning/phases/**/*-PLAN.md` → Collect plan files
- `Glob: .claude/workspace/planning/phases/**/*-SUMMARY.md` → Collect summary files
- `Bash: diff <(echo "$PLANS" | sort) <(echo "$SUMMARIES" | sed "s/-SUMMARY/-PLAN/") | grep "^<" | sed "s/^< //"` → Identify incomplete plans

**Logic:**

- `01-01-PLAN.md` exists but `01-01-SUMMARY.md` missing → incomplete
- List all incomplete plans in order

**If $ARGUMENTS is a phase directory:** Execute only plans in that phase.

### Parse Execution Mode

For each plan, check checkpoints:

- `Grep: "checkpoint:" .claude/workspace/planning/phases/XX-name/{phase}-{plan}-PLAN.md` → Extract checkpoint markers

**Execution modes:**

- **AUTONOMOUS**: No checkpoints → Use subagent for entire plan
- **SEGMENTED**: Verify checkpoints only → Subagent for segments, main for checkpoints
- **MAIN CONTEXT**: Decision/action checkpoints → Sequential execution with user interaction
- **REVIEWED**: Quality gates → Two-stage review process

### Execute Sequentially

For each incomplete plan in order:

1. **Load plan** as executable prompt
2. **Determine mode** from checkpoint analysis
3. **Execute via** `Skill: engineering-lifecycle`
4. **Create SUMMARY.md** with outcomes and deviations
5. **Update ROADMAP.md** phase status
6. **Commit** the phase completion

### Create Summary

After each plan completes, create SUMMARY.md:

```markdown
# Summary: Phase [Name] - Plan [N]

## Completion

- [x] All tasks completed successfully

## Tasks Completed

1. [Task N]: [Name] - [Outcome]
2. [Task N+1]: [Name] - [Outcome]

## Deviations

[If any occurred, document per deviation rules]

## Time Taken

[Optional: actual vs estimated]
```

### Update Roadmap

After each plan:

- `Read: .claude/workspace/planning/ROADMAP.md` → Parse phase status
- `Edit: .claude/workspace/planning/ROADMAP.md` → Mark phase status as "completed" or "in_progress"

### Commit Progress

After each plan completion:

- `Bash: git add .claude/workspace/planning/phases/XX-name/ && git commit -m "feat: complete [phase-name] plan [N]"` → Commit phase completion

### Final Report

After all plans complete:

```
Execution complete:
- [N] plans executed
- [M] tasks completed
- [D] deviations handled
- [C] commits created

Phase status:
- [Phase 1]: completed
- [Phase 2]: completed
- [Phase 3]: in_progress
```

## Usage Patterns

**Execute all incomplete plans:**

```
/plan:execute-all
[Finds all incomplete plans, executes sequentially]
```

**Execute specific phase:**

```
/plan:execute-all 01-foundation
[Executes only plans in 01-foundation phase]
```

**After creating roadmap:**

```
/plan:execute-all
[Executes all plans from start]
```

## Safety Features

**Check before execution:**

```
Found [N] incomplete plans:
1. phases/01-foundation/01-01-PLAN.md
2. phases/01-foundation/01-02-PLAN.md
3. phases/02-auth/02-01-PLAN.md

Execute all? (yes / review specific / cancel)
```

**Pause on errors:**

- If plan fails, stop and ask for direction
- Don't continue without user confirmation

**Handoff on context limit:**

- At 15% context remaining, create handoff
- Resume with `/plan:resume`

## Success Criteria

- [ ] All incomplete plans identified
- [ ] Execution mode determined for each
- [ ] Plans executed sequentially via engineering-lifecycle
- [ ] SUMMARY.md created for each completed plan
- [ ] ROADMAP.md updated after each plan
- [ ] Commits created for each phase
- [ ] Final report presented

<critical_constraint>
MANDATORY: Execute sequentially, not in parallel (dependencies matter)

MANDATORY: Fresh context for each plan (subagent delegation)

MANDATORY: Create SUMMARY.md after each plan (not batch at end)

MANDATORY: Commit after each phase (atomic progress)

MANDATORY: Pause on errors for user direction

MANDATORY: Handoff at 15% context remaining

No exceptions. Sequential execution ensures dependencies are respected.
</critical_constraint>
