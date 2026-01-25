---
name: ci-pipeline-manager
description: This skill should be used when the user asks to "test TaskList error handling", "test CI pipeline recovery", "validate failure recovery workflows", or needs guidance on testing TaskList error handling and recovery behavior with CI pipelines (not for simple linear pipelines).
context: fork
---

# CI Pipeline Error Recovery Testing

Think of CI pipelines as **safety systems in a car**—when the engine fails (tests fail), the airbags must deploy (cleanup runs), and other systems must shut down (deploy blocks) to prevent damage.

## CI_START

You are managing a CI pipeline with error recovery capabilities.

**Context**: In real CI/CD, tests may fail. The pipeline must handle failures gracefully, cancel dependent tasks, and execute cleanup. This test validates TaskList's error handling behavior.

## Pipeline Architecture

**Four-task pipeline with error handling:**

1. **run-tests** - Execute test suite
   - Simulates test failure for validation
   - Failure: blocks all downstream tasks
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
   - BLOCKED by: run-tests (triggers when run-tests completes)
   - MUST execute even when tests fail
   - Output: Cleanup completion status

## Recognition Patterns

**When to use ci-pipeline-manager:**
```
✅ Good: "Test that failed tasks properly block dependents"
✅ Good: "Validate cleanup runs despite test failures"
✅ Good: "Ensure deploy doesn't run when build is skipped"
❌ Bad: Simple linear pipeline with no dependencies
❌ Bad: Testing individual task execution

Why good: Complex error recovery requires testing blocking logic.
```

**Pattern Match:**
- User mentions "CI pipeline", "error handling", "failure recovery"
- Tasks have dependencies that should block on failure
- Need to validate cleanup and blocking behavior

**Recognition:** "Does this pipeline have dependent tasks that should block on failure?" → Use ci-pipeline-manager.

## Execution Workflow

**Execute autonomously:**

1. **Create TaskList** with all four tasks
2. **Set up blocking dependencies:**
   - build blocked_by: ["run-tests"]
   - deploy blocked_by: ["build"]
   - cleanup-on-failure blocked_by: ["run-tests"]
3. **Simulate test failure** in run-tests task
4. **Verify behavior:**
   - build task should NOT execute (blocked by failed run-tests)
   - deploy task should NOT execute (build never ran)
   - cleanup-on-failure MUST execute (failure cleanup)
5. **Report task states** and pipeline status

## Expected Output

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

**Contrast:**
```
✅ Good: cleanup-on-failure executes despite run-tests failure
✅ Good: build and deploy are skipped due to dependency failure
❌ Bad: Dependent tasks run after parent failure
❌ Bad: Cleanup doesn't execute on failure

Why good: Proper error handling prevents cascading failures and resource leaks.
```

**Recognition:** "Does this output show proper error handling?" → Check: 1) Failed task blocked dependents, 2) Cleanup executed despite failure.
