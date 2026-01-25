---
name: deployment-pipeline-orchestrator
description: "Orchestrate deployment pipeline using TaskList with sequential dependencies"
context: fork
agent: Plan
allowed-tools: Task, TaskCreate, TaskUpdate, Read, Bash
---

# Deployment Pipeline Orchestrator

Execute deployment pipeline with sequential TaskList dependencies:

## TASKLIST_CREATION

Create TaskList with sequential dependencies:
1. Build task (id: build)
2. Test task (id: test, blockedBy: build)
3. Deploy task (id: deploy, blockedBy: test)
4. Verify task (id: verify, blockedBy: deploy)

## EXECUTION_WORKFLOW

Execute tasks in dependency order:
- Build must complete before test starts
- Test must complete before deploy starts
- Deploy must complete before verify starts

## VALIDATION

Verify:
- Tasks created with proper dependencies
- Sequential execution order maintained
- Each task outputs completion marker
- Final report aggregates all results

## DEPLOYMENT_PIPELINE_COMPLETE

Pipeline executed successfully with all stages verified.
