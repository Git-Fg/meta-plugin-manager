---
name: distributed-processor
description: "Process data using TaskList and forked skills"
context: fork
agent: Plan
allowed-tools: Task, TaskCreate, Skill, Read, Bash
---

# Distributed Processor

Process data using TaskList and forked skills:

## TASKLIST_CREATION

Create TaskList with tasks that invoke forked skills:
1. Data ingestion task (calls forked skill)
2. Processing task (calls forked skill)
3. Aggregation task (calls forked skill)

## EXECUTION_WORKFLOW

Execute with TaskList coordination:
- TaskList creates tasks
- Tasks invoke forked skills via Skill tool
- Parallel execution with isolation
- Results aggregation from workers

## IMPLEMENTATION

Create TaskList ID and tasks:

```bash
CLAUDE_CODE_TASK_LIST_ID="distributed-processor-test"
export CLAUDE_CODE_TASK_LIST_ID
```

Create three tasks:
1. Task 1: Data ingestion - invokes data-ingestor skill
2. Task 2: Data processing - invokes data-processor skill
3. Task 3: Result aggregation - invokes result-aggregator skill

Each task uses Skill tool to invoke forked worker skills with context: fork for isolation.

## VALIDATION

Verify:
- TaskList tasks invoke forked skills via Skill tool
- Parallel execution with isolation
- Results aggregation works

## DISTRIBUTED_PROCESSING_COMPLETE

Distributed processing completed successfully.
