# JSON Management System

Manages the skill_test_plan.json file for tracking test progress, status updates, and automated test discovery.

## Core Operations

### 1. Read Test Plan

**Purpose**: Parse skill_test_plan.json and extract test specifications

**Process**:
```bash
Read tests/skill_test_plan.json into $TEST_PLAN

Parse structure:
- test_summary: {
    total_tests,
    completed,
    failed,
    not_started,
    coverage,
    raw_logs_analyzed,
    last_updated
  }
- key_findings: {
    critical_discovery_1 through critical_discovery_7,
    issue_identified,
    research_question,
    gap_identified
  }
- recursive_workflow_taxonomy: {
    type_1_linear_chain,
    type_2_hub_spoke,
    type_3_nested_forks,
    type_4_subagent_skills,
    type_5_parallel
  }
- tasklist_workflow_taxonomy: {
    nested_tasklist,
    tasklist_by_skill,
    tasklist_by_subagent,
    tasklist_errors,
    tasklist_state,
    tasklist_performance,
    tasklist_owner,
    tasklist_advanced
  }
- phases: [
    {
      phase: 1,
      name: "Basic Skill Calling",
      description: "...",
      tests: [...]
    }
  ]

Output: ## JSON_PARSED with parsed structure
```

### 2. Find Next Test

**Purpose**: Auto-discover next NOT_STARTED test

**Process**:
```bash
Scan $TEST_PLAN.phases array
For each phase in phases:
  For each test in phase.tests:
    If test.status == "NOT_STARTED":
      Add to $CANDIDATES

Sort $CANDIDATES by:
1. Phase number (ascending)
2. Test ID (ascending)
3. Priority (if present)

Select: First item in sorted list

Output: ## TEST_DISCOVERED with test details
```

**Output Format**:
```json
{
  "test_id": "test_2_3",
  "phase": "phase_2",
  "phase_name": "Forked Skills Testing",
  "name": "Forked Autonomy",
  "status": "NOT_STARTED",
  "priority": "HIGH",
  "setup": {
    "type": "forked_skill",
    "skills": [
      {
        "name": "interactive-test",
        "context": "fork",
        "description": "Tests autonomy with decision points"
      }
    ],
    "expected_marker": "INTERACTIVE_TEST_COMPLETE"
  },
  "validation": {
    "autonomy_score": ">=80%",
    "must_have_marker": true,
    "expected_status": "forked"
  }
}
```

### 3. Update Test Status

**Purpose**: Update JSON with execution results

**Process**:
```bash
# Read current JSON
Read tests/skill_test_plan.json
Parse into $CURRENT_PLAN

# Find test
For each phase in $CURRENT_PLAN.phases:
  For each test in phase.tests:
    If test.test_id == $TEST_ID:
      $TARGET_TEST = test
      Break

# Update status
$TARGET_TEST.status = $NEW_STATUS  # IN_PROGRESS, COMPLETED, FAILED

# Add results
If $NEW_STATUS == "COMPLETED" OR $NEW_STATUS == "FAILED":
  $TARGET_TEST.results = {
    "timestamp": $CURRENT_TIMESTAMP,
    "execution_time_ms": $DURATION_MS,
    "autonomy_score": $AUTONOMY_SCORE,
    "completion_marker": $MARKER_DETECTED,
    "pass_fail": $VERDICT,
    "findings": $FINDINGS_ARRAY,
    "permission_denials": $DENIALS_COUNT,
    "evidence_file": "raw_logs/phase_X/test_X_Y.description.json"
  }

# Update test_summary
$CURRENT_PLAN.test_summary.completed++
$CURRENT_PLAN.test_summary.not_started--
$CURRENT_PLAN.test_summary.coverage = calculateCoverage()
$CURRENT_PLAN.test_summary.last_updated = $CURRENT_TIMESTAMP

# Write back
Write $CURRENT_PLAN to tests/skill_test_plan.json

Output: ## JSON_UPDATED
```

### 4. Calculate Coverage

**Purpose**: Update coverage percentage

**Process**:
```bash
total = $TEST_PLAN.test_summary.total_tests
completed = $TEST_PLAN.test_summary.completed
failed = $TEST_PLAN.test_summary.failed
not_started = $TEST_PLAN.test_summary.not_started

coverage_percentage = (completed / total) * 100
success_rate = (completed / (completed + failed)) * 100

$TEST_PLAN.test_summary.coverage = "${coverage_percentage}% complete (${completed}/${total})"
$TEST_PLAN.test_summary.success_rate = "${success_rate}% success rate (${completed}/${completed + failed} executed)"

Output: Coverage metrics
```

### 5. Add Key Finding

**Purpose**: Add new discovery to key_findings

**Process**:
```bash
Read tests/skill_test_plan.json

# Determine finding type
If finding relates to skill chains:
  $FINDING_KEY = "critical_discovery_X"
If finding relates to forking:
  $FINDING_KEY = "critical_discovery_X"
If finding relates to TaskList:
  $FINDING_KEY = "critical_discovery_X"

# Add finding
$TEST_PLAN.key_findings[$FINDING_KEY] = $FINDING_DESCRIPTION

# Update timestamp
$TEST_PLAN.test_summary.last_updated = $CURRENT_TIMESTAMP

Write $TEST_PLAN to tests/skill_test_plan.json

Output: ## FINDING_ADDED
```

## JSON Structure

### Test Summary

```json
{
  "test_summary": {
    "total_tests": 67,
    "completed": 23,
    "failed": 1,
    "not_started": 43,
    "coverage": "34% complete (23/67), 92% success rate (23/25 executed)",
    "raw_logs_analyzed": 25,
    "last_updated": "2026-01-23"
  }
}
```

### Phase Structure

```json
{
  "phase": 1,
  "name": "Basic Skill Calling",
  "description": "Test skills calling other skills without forking",
  "tests": [
    {
      "test_id": "1.1",
      "name": "Basic skill calling",
      "status": "COMPLETED",
      "confidence": "HIGH",
      "result": "PASS",
      "summary": "Regular → Regular skill handoff works correctly",
      "findings": "One-way handoff confirmed - caller does NOT resume after called skill",
      "win_condition": "Skill chaining works but control transfers permanently",
      "evidence_file": "raw_logs/phase_1/test_1.1.basic.skill.calling.json",
      "duration_ms": 7736,
      "permission_denials": 0
    }
  ]
}
```

### Test Status Values

- **NOT_STARTED**: Test has not been executed
- **IN_PROGRESS**: Test is currently running
- **COMPLETED**: Test finished successfully
- **FAILED**: Test finished with failures
- **SKIPPED**: Test was intentionally skipped

## Usage Examples

### Discover Next Test

```bash
# Auto-discover from JSON
test-runner "Show next test"

Output:
## TEST_DISCOVERED
Test ID: 2.3
Name: Forked Autonomy
Phase: 2 (Forked Skills Testing)
Status: NOT_STARTED
Priority: HIGH

Next: Execute test-runner "Execute test 2.3"
```

### Execute and Update

```bash
# Execute test
test-runner "Execute next test"

# Skill automatically:
# 1. Discovers next test
# 2. Generates environment
# 3. Executes test
# 4. Analyzes results
# 5. Updates JSON with results
# 6. Reports progress
```

### View Progress

```bash
# Show test plan summary
test-runner "Show progress"

Output:
## PROGRESS_SUMMARY
Total Tests: 67
Completed: 23 (34%)
Failed: 1
Not Started: 43
Success Rate: 92%

Next Test: 2.3 (Forked Autonomy)
Phase 2 Progress: 3/5 tests complete
```

### Mark Test Complete

```bash
# Manual status update
test-runner "Mark test 3.1 as completed with findings: Forked skills can use subagents"

Output: ## JSON_UPDATED
Test 3.1 marked as COMPLETED
Coverage: 35% complete (24/67)
```

## Error Handling

### JSON Parse Errors

```bash
If Read fails:
  Output: ## JSON_ERROR
  Error: Cannot parse skill_test_plan.json
  Action: Check file exists and is valid JSON

If Write fails:
  Output: ## JSON_ERROR
  Error: Cannot write to skill_test_plan.json
  Action: Check file permissions
```

### Test Not Found

```bash
If test_id not found:
  Output: ## TEST_NOT_FOUND
  Error: Test X.Y does not exist
  Action: Verify test_id is correct
  Available: List of available test IDs
```

### Invalid Status

```bash
If invalid status:
  Output: ## INVALID_STATUS
  Error: Status must be NOT_STARTED, IN_PROGRESS, COMPLETED, FAILED, or SKIPPED
  Action: Use valid status value
```

## Migration from Manual

### Before (Manual)

```bash
# User manually:
# 1. Checks JSON for next test
# 2. Creates folder
# 3. Writes skills
# 4. Runs CLI
# 5. Calls analyze_tools.sh
# 6. Manually updates JSON
# 7. Archives test
```

### After (Autonomous)

```bash
# User just runs:
test-runner "Execute next test"

# Skill automatically handles:
# 1-7. All steps above
# Plus: Built-in analysis
# Plus: Progress tracking
# Plus: Findings documentation
```

## Best Practices

### For JSON Management

✅ **DO**: Let skill manage JSON updates automatically
✅ **DO**: Use "Execute next test" for sequential execution
✅ **DO**: Review test_summary after batch execution
✅ **DO**: Check key_findings for new discoveries

❌ **DON'T**: Manually edit skill_test_plan.json while skill is running
❌ **DON'T**: Skip validation after JSON updates
❌ **DON'T**: Use relative paths in evidence_file fields

### For Test Discovery

✅ **DO**: Keep tests in logical phase order
✅ **DO**: Set proper priority for critical tests
✅ **DO**: Use descriptive test names
✅ **DO**: Document expected outcomes in setup.validation

❌ **DON'T**: Leave many tests in IN_PROGRESS state
❌ **DON'T**: Skip phase boundaries
❌ **DON'T**: Use ambiguous test IDs

### For Status Updates

✅ **DO**: Use COMPLETED for successful tests
✅ **DO**: Use FAILED for tests with errors
✅ **DO**: Document findings in results
✅ **DO**: Track autonomy scores

❌ **DON'T**: Use COMPLETED for failed tests
❌ **DON'T**: Leave results empty
❌ **DON'T**: Forget to update test_summary

## Integration with Analysis Engine

JSON management works seamlessly with built-in analysis:

```bash
# Analysis provides results
$AUTONOMY_SCORE = calculateAutonomy($PERMISSION_DENIALS)
$VERDICT = determineVerdict($VALIDATION, $COMPLETION_MARKERS)
$FINDINGS = extractFindings($TEST_EXECUTION)

# JSON management updates
Update test.status = "COMPLETED"
Add results object
Update test_summary
Write to JSON
```

This provides complete automation: discover → execute → analyze → update.
