---
description: "Execute PLAN.md files with fresh context and generate SUMMARY.md outcomes. Use when running implementation phases."
argument-hint: [path/to/PLAN.md or "auto" for latest]
---

# Plan Execution

<mission_control>
<objective>Execute PLAN.md as an executable prompt and generate SUMMARY.md outcome</objective>
<success_criteria>All tasks completed, SUMMARY.md created, ROADMAP.md updated</success_criteria>
</mission_control>

## Purpose

Execute PLAN.md files with fresh context. PLAN.md IS the executable prompt - it contains all tasks, verification criteria, and success metrics for the phase.

## Process

### Identify Plan

**If $ARGUMENTS is "auto" or empty:**

Find the next plan to execute:

- `Read: .claude/workspace/planning/ROADMAP.md` - Check roadmap for in-progress phase
- `Glob: .claude/workspace/planning/phases/*/*-PLAN.md` - Find plans
- `Glob: .claude/workspace/planning/phases/*/*-SUMMARY.md` - Find summaries

**Logic:**

- If `01-01-PLAN.md` exists but `01-01-SUMMARY.md` doesn't → execute 01-01
- Pattern: `Bash: find .claude/workspace/planning/phases -name "*-PLAN.md" ! -name "*-SUMMARY.md" | head -1`

**If $ARGUMENTS is a path:** Use that plan directly

### Parse Execution Mode

Check for checkpoints to determine execution mode:

- `Grep: "checkpoint:" .claude/workspace/planning/phases/*/*-PLAN.md`

**Execution modes:**

- **AUTONOMOUS**: No checkpoints → Use subagent for entire plan
- **SEGMENTED**: Verify checkpoints only → Subagent for segments, main for checkpoints
- **MAIN CONTEXT**: Decision/action checkpoints → Sequential execution
- **REVIEWED**: Quality gates → Two-stage review process

### Load Execution Orchestrator

Use `Skill: engineering-lifecycle` for intelligent execution routing.

The skill handles:

- Mode selection based on checkpoint analysis
- Subagent spawning and management
- Checkpoint protocol implementation
- State management during execution

**Command role:** Identify plan, parse mode, delegate to skill
**Skill role:** Execution logic, subagent coordination, checkpoint handling

### Execute

Delegate to `Skill: engineering-lifecycle` with:

- Plan file path
- Execution mode (autonomous/segmented/main/reviewed)
- Checkpoint locations (if any)

### Create Summary

After execution completes, create SUMMARY.md:

- `Write: .claude/workspace/planning/phases/*/*-SUMMARY.md`
- Document: tasks completed, deviations, time taken

### Update Roadmap

Update phase status in ROADMAP.md:

- `Edit: .claude/workspace/planning/ROADMAP.md` - Mark phase status
- Update task counts if needed

### Commit Changes

- `Bash: git add . && git commit -m "feat: complete [phase-name] plan [N]"`

## Usage Patterns

**Auto-detect (execute next plan):**

```
/plan:execute
[Finds next incomplete plan, executes it]
```

**Explicit plan:**

```
/plan:execute .claude/workspace/planning/phases/01-foundation/01-01-PLAN.md
```

**After plan creation:**

```
/plan:execute
[Most recently created plan]
```

## Success Criteria

- [ ] Correct plan identified
- [ ] Execution mode determined
- [ ] Tasks executed via engineering-lifecycle
- [ ] SUMMARY.md created in phase directory
- [ ] ROADMAP.md updated
- [ ] Changes committed
- [ ] User informed of outcome

<critical_constraint>
MANDATORY: PLAN.md IS the executable prompt (not a document to transform)

MANDATORY: Delegate execution to engineering-lifecycle skill

MANDATORY: Create SUMMARY.md after execution (marks phase progress)

MANDATORY: Update ROADMAP.md status after completion

No exceptions. Plans are self-contained prompts with embedded deviation rules.
</critical_constraint>
