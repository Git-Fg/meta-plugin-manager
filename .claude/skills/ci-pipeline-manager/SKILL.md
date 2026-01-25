---
name: ci-pipeline-manager
description: This skill should be used when the user asks to "test TaskList error handling", "test CI pipeline recovery", "validate failure recovery workflows", or needs guidance on testing TaskList error handling and recovery behavior with CI pipelines (not for simple linear pipelines).
context: fork
---

## CI_START

You are managing a CI pipeline with error recovery capabilities.

**Context**: In real CI/CD, tests may fail. The pipeline must handle failures gracefully, cancel dependent tasks, and execute cleanup. This test validates TaskList's error handling behavior.

**Pipeline Tasks with Error Handling**:

1. **run-tests** - Execute test suite
   - In this test: SIMULATE test failure for validation
   - If this task fails: block all downstream tasks
   - Output: Test results (simulated failure)

2. **build** - Compile application
   - BLOCKED by: run-tests
   - Should NOT run if tests fail
   - Output: Build artifact or "SKIPPED"

3. **deploy** - Deploy to staging
   - BLOCKED by: build
   - Should NOT run if build doesn't happen
   - Output: Deployment status or "SKIPPED"

4. **cleanup-on-failure** - Cleanup resources
   - BLOCKED by: run-tests (triggers when run-tests completes, even on failure)
   - MUST execute even when tests fail
   - Output: Cleanup completion status

**Execute autonomously**:

1. Create TaskList with all four tasks
2. Set up blocking dependencies:
   - build blocked_by: ["run-tests"]
   - deploy blocked_by: ["build"]
   - cleanup-on-failure blocked_by: ["run-tests"]
3. Simulate test failure in run-tests task
4. Verify behavior:
   - build task should NOT execute (blocked by failed run-tests)
   - deploy task should NOT execute (build never ran)
   - cleanup-on-failure MUST execute (failure cleanup)
5. Report task states and pipeline status

**Expected output format**:
```
CI Pipeline: RUNNING
[task-id] run-tests: IN_PROGRESS -> FAILED
[task-id] build: BLOCKED -> SKIPPED (dependency failed)
[task-id] deploy: BLOCKED -> SKIPPED (dependency never ran)
[task-id] cleanup-on-failure: BLOCKED -> IN_PROGRESS -> COMPLETE

Pipeline Status: FAILED (with proper cleanup)
Tasks Executed: 2/4 (run-tests, cleanup-on-failure)
Tasks Blocked: 2/4 (build, deploy)

Error Handling: PASS - Failed task properly blocked dependents
Cleanup: PASS - Cleanup executed despite failure
```
