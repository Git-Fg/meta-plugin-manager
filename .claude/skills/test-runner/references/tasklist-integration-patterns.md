# TaskList Integration Patterns

This reference covers TaskList integration patterns for test execution workflows.

## TaskList Integration Patterns

### Pattern 1: Complete Lifecycle Execution
For comprehensive test execution:

1. **Setup Phase**:
   - Create master task "Execute All Tests"
   - Find all NOT_STARTED tests
   - Create individual setup tasks for each test

2. **Execute Phase**:
   - For each test: setup → execute → validate → document
   - Update TaskList at each lifecycle stage
   - Track autonomy scores and completion markers

3. **Complete Phase**:
   - Mark master task as completed
   - Generate final summary with all metrics

### Pattern 2: Phase-Based Execution
For structured phase-by-phase testing:

1. For each phase (1-7):
   - Create phase task
   - Create individual test tasks (blocked by phase task)
2. Execute all tests in phase
3. Review phase results
4. Mark phase complete
5. Move to next phase

### Pattern 3: Hypothesis-Driven Validation
For discovery-focused testing:

1. Create hypothesis validation tasks
2. For each hypothesis:
   - Run required tests
   - Verify expected outcomes
   - Document discoveries
3. Update mental model based on results

### Pattern 4: Retry & Recovery
For handling failures:

1. Scan for FAILED tests
2. Create retry task
3. For each failed test:
   - Reset to NOT_STARTED
   - Execute with additional diagnostics
   - Update TaskList with recovery status
