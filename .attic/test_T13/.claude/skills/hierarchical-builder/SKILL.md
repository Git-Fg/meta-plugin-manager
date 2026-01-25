---
name: hierarchical-builder
description: "Hierarchical build system with nested TaskList and forked skill workers"
context: fork
agent: Plan
allowed-tools: Task, TaskCreate, TaskUpdate, Skill, Read, Bash
---

# Hierarchical Builder

You are orchestrating a hierarchical build system with nested TaskList workflows.

## BUILD_START

Create a parent TaskList to coordinate the overall build:

**Parent TaskList**:
1. **build-frontend** - Build frontend components (creates nested TaskList)
2. **build-backend** - Build backend services (creates nested TaskList)

Execute these tasks and verify the hierarchical build completes successfully.

## BUILD_COMPLETE

All build tasks completed successfully.
