---
name: multi-session-orchestrator
description: "Test TaskList cross-session persistence"
context: fork
agent: Plan
allowed-tools: Task, TaskCreate, TaskUpdate, Read, Bash
---

# Multi-Session Orchestrator

Test TaskList cross-session persistence:

## TASKLIST_CREATION

Create TaskList for cross-session test:
1. Session initialization task
2. Data processing task
3. Session continuation task
4. Finalization task

## EXECUTION_WORKFLOW

Execute with persistence:
- Create TaskList with unique ID
- Execute initial tasks
- Persist state across sessions
- Continue in new session

## VALIDATION

Verify:
- TaskList ID persisted
- Task status preserved across sessions
- Continuation works correctly

## MULTI_SESSION_COMPLETE

Cross-session persistence test completed successfully.
