---
name: parallel-analysis-coordinator
description: "Coordinate parallel analysis tasks using TaskList"
context: fork
agent: Plan
allowed-tools: Task, TaskCreate, TaskUpdate, Read, Bash
---

# Parallel Analysis Coordinator

Execute parallel analysis using TaskList:

## TASKLIST_CREATION

Create TaskList with parallel tasks (no blocking dependencies):
1. Security analysis task
2. Performance analysis task
3. Code quality analysis task
4. Documentation analysis task

## EXECUTION_WORKFLOW

Execute tasks in parallel:
- All tasks start simultaneously
- No blocking dependencies between tasks
- Each task runs independently
- Aggregate results when all complete

## VALIDATION

Verify:
- Independent tasks created without blocking
- Concurrent execution achieved
- Results aggregated into comprehensive report

## PARALLEL_ANALYSIS_COMPLETE

Parallel analysis completed successfully with all findings.
