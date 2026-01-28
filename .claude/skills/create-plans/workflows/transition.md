# Workflow: Transition to Next Phase

## Required Reading

**Read these files NOW:**

1. `.claude/workspace/planning/ROADMAP.md`
2. Current phase's plan files (`*-PLAN.md`)
3. Current phase's summary files (`*-SUMMARY.md`)

## Purpose

Mark current phase complete and advance to next. This is the natural point
where progress tracking happens - implicit via forward motion.

"Planning next phase" = "current phase is done"

## Process

#### verify_completion

Check current phase has all plan summaries:

```bash
ls .claude/workspace/planning/phases/XX-current/*-PLAN.md 2>/dev/null | sort
ls .claude/workspace/planning/phases/XX-current/*-SUMMARY.md 2>/dev/null | sort
```

**Verification logic:**

- Count PLAN files
- Count SUMMARY files
- If counts match: all plans complete
- If counts don't match: incomplete

**If all plans complete:**
Ask user to confirm marking phase complete and moving to next.

**If plans incomplete:**
Present the situation with actionable options: continue current phase, mark complete anyway, or review what's left.

#### cleanup_handoff

Check for lingering handoffs:

```bash
ls .claude/workspace/planning/phases/XX-current/.continue-here*.md 2>/dev/null
```

If found, delete them - phase is complete, handoffs are stale.

Pattern matches:

- `.continue-here.md` (legacy)
- `.continue-here-01-02.md` (plan-specific)

#### update_roadmap

Update `.claude/workspace/planning/ROADMAP.md`:

- Mark current phase: `[x] Complete`
- Add completion date
- Update plan count to final (e.g., "3/3 plans complete")
- Update Progress table
- Keep next phase as `[ ] Not started`

**Example:**

```markdown
## Phases

- [x] Phase 1: Foundation (completed 2025-01-15)
- [ ] Phase 2: Authentication ← Next
- [ ] Phase 3: Core Features

## Progress

| Phase             | Plans Complete | Status      | Completed  |
| ----------------- | -------------- | ----------- | ---------- |
| 1. Foundation     | 3/3            | Complete    | 2025-01-15 |
| 2. Authentication | 0/2            | Not started | -          |
| 3. Core Features  | 0/1            | Not started | -          |
```

#### archive_prompts

If prompts were generated for the phase, they stay in place.
The `completed/` subfolder pattern from create-meta-prompts handles archival.

#### offer_next_phase

After marking phase complete, present options for next action: plan next phase, review roadmap, or take a break.

<implicit_tracking>
Progress tracking is IMPLICIT:

- "Plan phase 2" → Phase 1 must be done (or ask)
- "Plan phase 3" → Phases 1-2 must be done (or ask)
- Transition workflow makes it explicit in ROADMAP.md

No separate "update progress" step. Forward motion IS progress.

<partial_completion>
If user wants to move on but phase isn't fully complete:

```
Phase [X] has incomplete plans:
- {phase}-02-PLAN.md (not executed)
- {phase}-03-PLAN.md (not executed)

Options:
1. Mark complete anyway (plans weren't needed)
2. Defer work to later phase
3. Stay and finish current phase
```

Respect user judgment - they know if work matters.

**If marking complete with incomplete plans:**

- Update ROADMAP: "2/3 plans complete" (not "3/3")
- Note in transition message which plans were skipped

## Success Criteria

Transition is complete when:

- [ ] Current phase plan summaries verified (all exist or user chose to skip)
- [ ] Any stale handoffs deleted
- [ ] ROADMAP.md updated with completion status and plan count
- [ ] Progress table updated
- [ ] User knows next steps
