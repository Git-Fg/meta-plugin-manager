---
name: migration-orchestrator
description: "Multi-session workflow with TaskList"
context: fork
agent: Plan
allowed-tools: Task, TaskCreate, Read, TaskUpdate, Bash
---

# Migration Orchestrator

Execute cross-session workflow for project migration.

## SESSION_START

You are executing a multi-session migration workflow using TaskList persistence.

**Context**: Real-world migrations often span multiple sessions. TaskList must persist state so work can continue across sessions.

**Multi-Session Workflow**:

**Session 1**:
1. Create TaskList with migration phases
2. Execute phase 1 (database migration)
3. Mark task as COMPLETE
4. Report TaskList ID for continuation

**Session 2**:
1. Load existing TaskList by ID
2. Verify phase 1 status preserved
3. Execute phase 2 (application migration)
4. Complete remaining tasks
5. Report: Cross-session continuation successful

**Execute autonomously**:

### Session 1 - Initial Migration

1. Create TaskList with migration phases:
   - phase-1-database: Database schema migration
   - phase-2-application: Application code migration
   - phase-3-validation: Migration validation

2. Mark phase-1-database as IN_PROGRESS
3. Execute database migration (simulated):
   - Analyze current schema
   - Generate migration scripts
   - Execute migration
4. Mark phase-1-database as COMPLETE
5. Report TaskList ID for Session 2 continuation

### Session 2 - Continuation

1. Load existing TaskList by ID
2. Verify phase-1-database status is preserved (COMPLETE)
3. Mark phase-2-application as IN_PROGRESS
4. Execute application migration (simulated):
   - Update configuration files
   - Migrate code dependencies
   - Update API endpoints
5. Mark phase-2-application as COMPLETE
6. Mark phase-3-validation as IN_PROGRESS
7. Execute validation (simulated):
   - Verify database integrity
   - Test application functionality
   - Validate migration success
8. Mark phase-3-validation as COMPLETE
9. Report: Cross-session continuation successful

**Expected output format**:

Session 1:
```
SESSION 1: Initial Migration
TaskList Created with ID: [id]
phase-1-database: IN_PROGRESS -> COMPLETE
phase-2-application: PENDING
phase-3-validation: PENDING

SESSION 1 COMPLETE
TaskList ID: [id] - Save for Session 2
```

Session 2:
```
SESSION 2: Continuation
TaskList Loaded: [id]
phase-1-database: COMPLETE (preserved)
phase-2-application: IN_PROGRESS -> COMPLETE
phase-3-validation: IN_PROGRESS -> COMPLETE

MIGRATION_COMPLETE
Cross-Session Continuation: SUCCESS
```

## SESSION_1_COMPLETE
