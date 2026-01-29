---
name: handoff:create-full
description: "Create comprehensive handoff with git state, workspace context, and full session metadata. Use when ending a session and needing complete context preservation for seamless continuation."
argument-hint: "[session-name]"
---

# Full Handoff Creation

<mission_control>
<objective>Create comprehensive handoff document with complete session context for seamless continuation</objective>
<success_criteria>Handoff saved to handoff-full.yaml with complete context preservation</success_criteria>
</mission_control>

## Existing handoffs

```
!`find .claude/workspace/handoffs -maxdepth 1 -type f ! -name ".*" ! -path "*/.*" 2>/dev/null | sort`
```

If `handoff-full.yaml` exists: Archive before creating new one

## Git State

```
Branch: !`git branch --show-current`
Commit: !`git rev-parse HEAD`
Status: !`git status --porcelain`
```

## Document Session

Extract session name from `$ARGUMENTS` or conversation context. Trust your judgment to preserve ALL relevant context.

## Build Complete Handoff

Create `handoff-full.yaml` containing:

1. **Session metadata** - date, session name, status, outcome, goal, now, test command
2. **Git state** - branch, commit, status, log, diff summary
3. **All work done** - every task, file, change, and impact from this session
4. **All decisions** - with rationale, trade-offs, and consequences
5. **All questions** - answered and unanswered
6. **All blockers** - current and potential
7. **All next steps** - with priorities and dependencies
8. **All artifacts** - files created, modified, deleted
9. **All discoveries** - learnings, patterns, insights
10. **All context** - assumptions, constraints, configuration changes

**Rule**: If it exists in the conversation or git state, it goes in the handoff. No exceptions.

## Save

```
Write: .claude/workspace/handoffs/handoff-full.yaml
```

If complete replacement needed:

```
mv .claude/workspace/handoffs/handoff-full.yaml .claude/workspace/handoffs/.attic/handoff-full_$(date +%Y%m%d_%H%M%S).yaml 2>/dev/null || true
```

---

<critical_constraint>
MANDATORY: Preserve EVERY piece of context from this session
MANDATORY: No information left behind - if it was discussed, it's in the handoff
MANDATORY: Archive before write if replacing
No exceptions. Zero-information-loss context preservation.
</critical_constraint>
