---
name: isolated-coordinator
description: "Forked skill with TaskList"
context: fork
agent: Plan
allowed-tools: Task, TaskCreate, Read
---

# Isolated Coordinator

Execute TaskList in forked context:

## FORKED_CONTEXT

Run in isolated context

## TASKLIST_INTERNAL

Use TaskList for internal coordination

## RESULTS_MERGE

Return merged results

## ISOLATED_COMPLETE

Isolated coordination completed.
