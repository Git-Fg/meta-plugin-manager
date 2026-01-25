---
name: multi-session-orchestrator
description: This skill should be used when the user asks to "test TaskList cross-session persistence", "long-running workflows spanning multiple sessions", or needs guidance on testing TaskList persistence across multiple Claude Code sessions (not for single-session workflows).
---

# Multi-Session Orchestration

Think of multi-session orchestration as **passing a relay race baton**—when one session ends, another session must pick up exactly where the previous one left off, with all progress and state preserved.

## SESSION_START

You are testing TaskList persistence across multiple sessions.

**Context**: Real-world workflows often span multiple Claude Code sessions. TaskList must persist state so work can continue across sessions. This test validates cross-session persistence.

## Recognition Patterns

**When to use multi-session-orchestrator:**
```
✅ Good: "Test TaskList cross-session persistence"
✅ Good: "Long-running workflows spanning multiple sessions"
✅ Good: "Validate workflow state persistence"
❌ Bad: Single-session workflows
❌ Bad: Short tasks that complete in one session

Why good: Multi-session orchestration ensures workflow continuity across session boundaries.
```

**Pattern Match:**
- User mentions "cross-session", "long-running workflows", "persist state"
- Workflows that span multiple sessions
- Need to test persistence behavior

**Recognition:** "Does this workflow need to persist across session boundaries?" → Use multi-session-orchestrator.

## Multi-Session Workflow

**Session 1** (Initial Session):
1. Create TaskList with migration phases:
   - database-migration - Migrate database schema
   - application-migration - Migrate application code
   - data-validation - Validate migrated data
2. Mark database-migration as IN_PROGRESS
3. Execute database migration
4. Mark database-migration as COMPLETE
5. **CRITICAL**: Report TaskList ID for session continuation
   - This ID is required to resume in Session 2

**Session 2** (Resume Session):
1. Load existing TaskList by ID
2. Verify database-migration status is preserved (COMPLETE)
3. Mark application-migration as IN_PROGRESS
4. Execute application migration
5. Mark application-migration as COMPLETE
6. Mark data-validation as IN_PROGRESS
7. Execute data validation
8. Mark data-validation as COMPLETE
9. Report: Session 2 complete, migration finished

## Execution Workflow

**Execute autonomously:**

**For Session 1**:
1. Create TaskList with three migration tasks
2. Execute database-migration task
3. Report: TaskList ID for resumption

**For Session 2** (simulated continuation):
1. Verify TaskList state persisted
2. Continue execution from where Session 1 ended
3. Complete remaining tasks
4. Report: Cross-session continuation successful

## Expected Output

**Session 1 Output:**
```
Multi-Session Orchestration: SESSION 1
TaskList Created: [task-list-id]
[task-id] database-migration: IN_PROGRESS -> COMPLETE
[task-id] application-migration: PENDING
[task-id] data-validation: PENDING

SESSION 1 COMPLETE
TaskList ID: [id] - Save this for Session 2
```

**Session 2 Output (simulated):**
```
Multi-Session Orchestration: SESSION 2
TaskList Loaded: [task-list-id]
[task-id] database-migration: COMPLETE (status preserved)
[task-id] application-migration: IN_PROGRESS -> COMPLETE
[task-id] data-validation: IN_PROGRESS -> COMPLETE

SESSION 2 COMPLETE
Cross-Session Continuation: SUCCESS
Task State Persistence: VERIFIED
```

**Contrast:**
```
✅ Good: TaskList ID saved and used to resume
✅ Good: Status preserved across sessions
✅ Good: Continuation seamless from previous state
❌ Bad: TaskList recreated in Session 2
❌ Bad: Previous state lost

Why good: State persistence enables true multi-session workflows.
```

**Recognition:** "Does this output demonstrate proper cross-session persistence?" → Check: 1) TaskList ID continuity, 2) Status preservation, 3) Seamless continuation.
