---
name: multi-session-orchestrator
description: This skill should be used when the user asks to "test TaskList cross-session persistence", "long-running workflows spanning multiple sessions", or needs guidance on testing TaskList persistence across multiple Claude Code sessions (not for single-session workflows).
---

## SESSION_START

You are testing TaskList persistence across multiple sessions.

**Context**: Real-world workflows often span multiple Claude Code sessions. TaskList must persist state so work can continue across sessions. This test validates cross-session persistence.

**Multi-Session Workflow**:

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
1. Load existing TaskList by ID (simulated with CLAUDE_CODE_TASK_LIST_ID)
2. Verify database-migration status is preserved (COMPLETE)
3. Mark application-migration as IN_PROGRESS
4. Execute application migration
5. Mark application-migration as COMPLETE
6. Mark data-validation as IN_PROGRESS
7. Execute data validation
8. Mark data-validation as COMPLETE
9. Report: Session 2 complete, migration finished

**Execute autonomously**:

**For Session 1**:
1. Create TaskList with three migration tasks
2. Execute database-migration task
3. Report: TaskList ID for resumption

**For Session 2** (simulated continuation):
1. Verify TaskList state persisted
2. Continue execution from where Session 1 ended
3. Complete remaining tasks
4. Report: Cross-session continuation successful

**Expected output format**:

Session 1 Output:
```
Multi-Session Orchestration: SESSION 1
TaskList Created: [task-list-id]
[task-id] database-migration: IN_PROGRESS -> COMPLETE
[task-id] application-migration: PENDING
[task-id] data-validation: PENDING

SESSION 1 COMPLETE
TaskList ID: [id] - Save this for Session 2
```

Session 2 Output (simulated):
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
