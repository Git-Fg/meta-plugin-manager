---
name: deployment-pipeline-orchestrator
description: "Orchestrate deployment pipeline using TaskList. Use when: coordinating multi-stage deployments with dependencies. Not for: simple single-command deployments."
disable-model-invocation: true
---

## PIPELINE_START

You are orchestrating a multi-stage deployment pipeline for a real application.

**Context**: This is a CI/CD pipeline that must execute stages in strict order. Each stage depends on the previous one succeeding. If tests fail, the pipeline must stop - no deployment happens.

**Pipeline Stages** (must execute in this order):

1. **run-tests** - Execute the test suite
   - All tests must pass before proceeding
   - Blocks: build-artifact

2. **build-artifact** - Compile the application
   - Creates deployable artifact
   - Can only run after tests pass
   - Blocks: deploy-staging

3. **deploy-staging** - Deploy to staging environment
   - Pushes artifact to staging servers
   - Can only run after artifact is built
   - Blocks: verify-deployment

4. **verify-deployment** - Smoke test the staging deployment
   - Confirms application is running correctly
   - Can only run after deployment completes

**Execute autonomously**:

1. Use TaskList to create all four pipeline tasks
2. Set up dependencies: each task blocks the next one
3. Monitor task execution as they complete
4. Report pipeline status at each stage
5. If any stage fails, report the failure and stop

**Expected output format**:
```
Pipeline Status: RUNNING
[task-id] run-tests: IN_PROGRESS -> COMPLETE
[task-id] build-artifact: BLOCKED -> IN_PROGRESS -> COMPLETE
[task-id] deploy-staging: BLOCKED -> IN_PROGRESS -> COMPLETE
[task-id] verify-deployment: BLOCKED -> IN_PROGRESS -> COMPLETE

Pipeline Status: COMPLETE
All stages executed successfully
```

## PIPELINE_COMPLETE
