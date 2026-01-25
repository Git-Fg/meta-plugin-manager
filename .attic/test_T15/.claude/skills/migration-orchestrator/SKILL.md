---
name: migration-orchestrator
description: "Test multi-session workflow with TaskList persistence"
context: fork
agent: Plan
allowed-tools: Task, TaskCreate, Read
---

# Migration Orchestrator

Execute cross-session workflow:

## SESSION_1

Complete phase 1

## SESSION_2

Continue phase 2

## MIGRATION_COMPLETE

Migration completed across sessions.
