---
description: "Create context handoff document for continuing work in fresh context. Use when pausing work or switching sessions."
argument-hint: [optional: specific context to capture]
---

# Handoff Creation

<mission_control>
<objective>Create comprehensive handoff document enabling seamless continuation in fresh context</objective>
<success_criteria>Handoff document created in phase directory with comprehensive context for zero-information-loss handoff</success_criteria>
</mission_control>

## Purpose

Create a context handoff for pausing work. Handoffs capture everything needed to continue in a fresh session.

## Process

### Scan Current State

Analyze conversation to capture:

1. **What phase/task are we in?**
   - Check planning structure
   - Identify current phase
   - Find current task number

2. **What's been completed?**
   - Files created/modified
   - Tasks completed in this phase
   - Decisions made

3. **What's remaining?**
   - Current task status
   - Next tasks in queue
   - Blockers or dependencies

### Determine Handoff Location

- `Grep: "in_progress" .claude/workspace/planning/phases/**/PLAN.md` → Find current phase with in-progress status
- `Bash: dirname "$(grep -l 'in_progress' .claude/workspace/planning/phases/*/*-PLAN.md 2>/dev/null | head -1)"` → Get current phase directory

Create handoff as: `.claude/workspace/planning/phases/XX-phase-name/.continue-here.md`

### Write Handoff

Use YAML frontmatter for quick parsing:

```yaml
---
phase: "01-foundation"
task: "Task 3 of 5"
status: "in_progress"
last_updated: "[timestamp]"
---

# Context Summary

[Concise summary of where we are]

## Work Completed

- [Task 1]: [Brief description] - COMPLETED
- [Task 2]: [Brief description] - COMPLETED

## Current Task

**Task 3: [Task name]**
- Status: [in_progress/blocked]
- What's done: [specific progress]
- What's left: [remaining work]
- Blocker: [if any]

## Work Remaining

- [Task 4]: [Next task] - [Description]
- [Task 5]: [Following task] - [Description]

## Critical Context

[Key decisions, assumptions, blockers, environment notes]
```

### CONFIRM

After creating handoff:

```
Handoff created: .claude/workspace/planning/phases/XX-name/.continue-here.md

Use /plan:resume to continue from this handoff in your next session.
```

## Handoff Format

**File:** `.claude/workspace/planning/phases/XX-name/.continue-here.md`

```markdown
---
phase: "01-foundation"
task: "Task 3 of 5"
status: "in_progress"
last_updated: "2026-01-28T14:30:00Z"
---

# Handoff: Phase [Name] - Task [N]

## Quick Summary

[One sentence about current state]

## Completed This Phase

- **Task 1**: [Name] - [Outcome]
- **Task 2**: [Name] - [Outcome]

## Current Task

**Task 3**: [Task name]

- **Status**: [in_progress/blocked/testing]
- **Progress**: [What's been done]
- **Remaining**: [What's left to do]
- **Blocker**: [If applicable]

## Work Remaining

- **Task 4**: [Name] - [Description]
- **Task 5**: [Name] - [Description]

## Critical Context

[Key decisions, assumptions, environment notes, blockers]

## Files Modified

- `path/to/file.ts:123-145` - [Change description]
- `path/to/other.py` - [Change description]

## Next Session Action

[What to do when resuming: continue Task 3, start Task 4, etc.]
```

## Success Criteria

- [ ] Current phase and task identified
- [ ] Completed work documented
- [ ] Current task status captured
- [ ] Remaining tasks listed
- [ ] Critical context preserved
- [ ] Handoff file created in phase directory
- [ ] User informed how to resume

<critical_constraint>
MANDATORY: Comprehensive detail over brevity - zero information loss

MANDATORY: Include file:line references for all changes

MANDATORY: Use YAML frontmatter for quick parsing

MANDATORY: Place handoff in phase directory (.continue-here.md)

No exceptions. Handoff must enable seamless continuation.
</critical_constraint>
