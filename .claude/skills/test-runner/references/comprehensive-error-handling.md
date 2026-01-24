# Comprehensive Error Handling

This reference covers common error scenarios and troubleshooting procedures for test execution.

## Comprehensive Error Handling

### Error: Missing Test Plan
**Symptoms**: Test plan file not found
**What to do**:
- Create a basic test plan template with placeholder test entries
- The test runner needs a valid JSON structure to work with
- Use the skill_test_plan.json as a template

### Error: No Tests Defined
**Symptoms**: Tests array is empty
**What to do**:
- Verify the test plan has a valid tests array
- If empty, either populate it with tests or mark the execution task as complete
- Check phase structure is correct

### Error: Test Output Invalid
**Symptoms**: NDJSON doesn't have 3 lines, or malformed JSON
**What to do**:
- Verify the test produced exactly 3 lines of NDJSON output
- Check that each line is valid JSON
- Investigate what went wrong during test execution
- Review max-turns setting (may need more)

### Error: Concurrent Execution
**Symptoms**: Multiple test runners running simultaneously
**What to do**:
- Use a simple lock file mechanism to prevent multiple test runs
- Only allow one test runner process at a time
- Check for existing test-output.json files

### Error: Permission Denied
**Symptoms**: Cannot create folders or update files
**What to do**:
- Ensure you have read/write permissions to test directories
- Check that the test runner can create folders
- Verify write access to skill_test_plan.json

### Error: Autonomy Score Too Low
**Symptoms**: Many permission denials (>5)
**What to do**:
- Review the test instructions for clarity
- Ensure autonomous completion is possible
- Consider if test needs redesign
- May indicate flaky test or unclear requirements

### Error: Missing Completion Markers
**Symptoms**: Test runs but no COMPLETE markers found
**What to do**:
- Check that skills have proper win condition markers
- Verify the test expects the right markers
- May indicate incomplete skill implementation

### Error: Phase Not Completing
**Symptoms**: Tests in phase all pass individually but phase never completes
**What to do**:
- Check TaskList dependencies are correct
- Verify phase task isn't waiting on unfinished tests
- Review addBlockedBy relationships

### Analyze Test Output

To understand what happened during test execution:

**Check Autonomy**:
- Look for the permission_denials array in the result
- Count how many permission denials occurred
- 0 denials = 100% autonomy (Excellent)
- 1-3 denials = 90% autonomy (Good)
- 4-5 denials = 80% autonomy (Acceptable)
- 6+ denials = <80% autonomy (Fail)

**Count Skill Usage**:
- Search for "Skill" tool invocations
- Count how many times the Skill tool was used
- This shows how actively the test used skills

**Check TaskList Usage**:
- Look for TaskCreate, TaskUpdate, and TaskList calls
- Count how many TaskList operations occurred
- This shows orchestration complexity

**Verify Completion**:
- Search for "COMPLETE" markers in the output
- Each test should have at least one completion marker
- These mark successful test phases

**Detect Forking**:
- Look for "context: fork" references
- This indicates isolated subagent execution
- Important for understanding test architecture

### Update Test Status

To record test results in the plan:

1. Open the test plan JSON file
2. Find the test by its ID
3. Update the status to "COMPLETED" or "FAILED"
4. Add autonomy score and duration
5. Save the file
6. Update the overall summary statistics
