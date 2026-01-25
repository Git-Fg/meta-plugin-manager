---
name: hierarchical-builder
description: "Test nested TaskList with forked skill workers"
context: fork
agent: Plan
allowed-tools: Task, TaskCreate, Skill, Read
---

# Hierarchical Builder

Execute nested TaskList:

## PARENT_TASKLIST

Create parent TaskList

## CHILD_TASKLISTS

Create child TaskLists within parent tasks

## WORKER_EXECUTION

Call forked skills from child tasks

## HIERARCHICAL_COMPLETE

Nested TaskList completed successfully.
