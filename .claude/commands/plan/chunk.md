---
description: "[DEPRECATED] Plan immediate next tasks. Use `/plan:create` instead - auto-detects and presents next tasks chunk."
argument-hint: [optional: context about current work]
---

> **DEPRECATED**: This functionality has been merged into `/plan:create` for fully autonomous planning.
>
> **Migration guide:**
>
> - `/plan:chunk` → `/plan:create` (auto-detects incomplete phase and presents next 1-3 tasks)
> - `/plan:create` now handles chunk identification autonomously when phase is in progress
> - Just call `/plan:create` - it will show your next tasks immediately
>
> This command remains for backward compatibility but will be removed in a future version.

---

# Chunk Planning

<mission_control>
<objective>Identify immediate next 1-3 tasks from current phase</objective>
<success_criteria>User knows what to work on with clear task definitions</success_criteria>
</mission_control>

## Purpose

Identify the immediate next 1-3 tasks to work on. This is for when you want to focus on "what's next" without replanning the whole phase.

## Process

### Find Current Position

Read the phase plan:

```bash
cat .claude/workspace/planning/phases/XX-current/PLAN.md
```

Identify:

- Which tasks are complete (marked or inferred)
- Which task is next
- Dependencies between tasks

### Identify Chunk

Select 1-3 tasks that:

- Are next in sequence
- Have dependencies met
- Form a coherent chunk of work

Present:

```
Current phase: [Phase Name]
Progress: [X] of [Y] tasks complete

Next chunk:
1. Task [N]: [Name] - [Brief description]
2. Task [N+1]: [Name] - [Brief description]

Ready to work on these?
```

### Offer Execution

Options:

1. **Start working** - Begin with Task N
2. **Generate prompt** - Create meta-prompt for this chunk
3. **See full plan** - Review all remaining tasks
4. **Different chunk** - Pick different tasks

## Chunk Sizing

Good chunks:

- 1-3 tasks
- Can complete in one session
- Deliver something testable

**If user asks "what's next"** → Give them ONE task
**If user asks "plan my session"** → Give them 2-3 tasks

## Success Criteria

- [ ] Current position identified
- [ ] Next 1-3 tasks selected
- [ ] User knows what to work on

<critical_constraint>
MANDATORY: Select 1-3 tasks maximum (chunk sizing)

MANDATORY: Verify dependencies are met before selecting tasks

MANDATORY: Present clear, actionable task definitions

No exceptions. Chunks are for focus, not planning everything.
</critical_constraint>
