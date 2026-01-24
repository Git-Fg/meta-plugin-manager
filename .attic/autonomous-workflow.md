# Autonomous Workflow

Fully autonomous testing patterns with complete automation from discovery to JSON updates.

## Overview

The autonomous workflow eliminates all manual steps by providing complete automation:
- **Auto-Discovery**: Finds next test from JSON
- **Auto-Generation**: Creates test environments
- **Auto-Execution**: Runs tests with proper flags
- **Auto-Analysis**: Built-in analysis (no external scripts)
- **Auto-Update**: Updates JSON with results
- **Auto-Reporting**: Shows progress and next steps

## Complete Autonomous Loop

### Single Command Execution

```bash
test-runner "Execute next test"
```

### Workflow Steps

```
┌─────────────────────────────────────────────────────────┐
│ 1. DISCOVER                                               │
│ Read skill_test_plan.json → Find NOT_STARTED test          │
└────────────────┬──────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│ 2. GENERATE                                               │
│ Create folder → Generate skills from JSON specs            │
└────────────────┬──────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│ 3. EXECUTE                                                │
│ Run claude CLI with mandatory flags → NDJSON output       │
└────────────────┬──────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│ 4. ANALYZE (Built-in, no external scripts)               │
│ Parse NDJSON → Autonomy scoring → Pattern detection       │
└────────────────┬──────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│ 5. UPDATE                                                 │
│ Update JSON → Status + results + progress metrics         │
└────────────────┬──────────────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────────────┐
│ 6. REPORT                                                 │
│ Show results → Progress → Next test                       │
└─────────────────────────────────────────────────────────┘
```

## Autonomous Modes

### Mode 1: Single Test

**Command**: `test-runner "Execute next test"`

**Behavior**:
1. Discovers next NOT_STARTED test
2. Generates test environment
3. Executes test
4. Analyzes results
5. Updates JSON
6. Reports progress

**Example Output**:
```markdown
## AUTONOMOUS_COMPLETE

Test: 2.3
Name: Forked Autonomy
Phase: 2 (Forked Skills Testing)
Status: COMPLETED ✓

Results:
- Autonomy: 100% (Excellent)
- Completion: 100%
- Verdict: PASS
- Duration: 18,570ms

Patterns Detected:
- Forked Execution ✓
- 0 Permission Denials ✓

Findings:
- Forked skills are 100% autonomous
- No questions asked during execution

Next Test: 2.4 (Context Isolation)
Progress: 36% complete (24/67)
```

### Mode 2: Batch Execution

**Command**: `test-runner "Execute all remaining tests"`

**Behavior**:
1. Discovers all NOT_STARTED tests
2. Sorts by phase and priority
3. Executes each test sequentially
4. Analyzes each result
5. Updates JSON after each test
6. Reports aggregate progress

**Example Output**:
```markdown
## BATCH_AUTONOMOUS_COMPLETE

Tests Executed: 5
Passed: 4
Failed: 1
Success Rate: 80%

Phase 2 Progress: 6/9 tests complete

Results:
  2.3: PASS (100%) ✓
  2.4: PASS (95%) ✓
  2.5: PASS (90%) ✓
  2.6: FAIL (Hallucination) ✗
  2.7: PASS (100%) ✓

Next Phase: Phase 3 (Forked + Subagents)
Remaining Tests: 58
Coverage: 38% complete (26/67)
```

### Mode 3: Phase Execution

**Command**: `test-runner "Execute phase 2"`

**Behavior**:
1. Discovers tests in specified phase
2. Filters by phase number
3. Executes phase tests
4. Analyzes results
5. Reports phase completion

**Example Output**:
```markdown
## PHASE_AUTONOMOUS_COMPLETE

Phase: 2 (Forked Skills Testing)
Tests: 9
Completed: 9
Failed: 0
Success Rate: 100%

Coverage: 2/11 phases complete (18%)

Next Phase: Phase 3 (Forked + Subagents)
```

### Mode 4: Specific Test

**Command**: `test-runner "Execute test 3.2"`

**Behavior**:
1. Validates test exists
2. Generates environment for specific test
3. Executes test
4. Analyzes results
5. Updates JSON

**Example Output**:
```markdown
## SPECIFIC_TEST_COMPLETE

Test: 3.2
Name: Custom Subagents
Phase: 3 (Forked + Subagents)
Status: COMPLETED ✓

Autonomy: 95% (Excellent)
Verdict: PASS
Duration: 22,341ms

Patterns:
- Forked Execution ✓
- Custom Subagents ✓
- Nested Execution ✓

Next: 3.3 (if exists) or Phase 4
```

## Auto-Discovery Logic

### Discovery Algorithm

```bash
Read tests/skill_test_plan.json

# Filter candidates
$CANDIDATES = []
For phase in test_plan.phases:
  For test in phase.tests:
    If test.status == "NOT_STARTED":
      $CANDIDATES.push(test)

# Sort by priority
Sort $CANDIDATES by:
1. Phase number (ascending)
2. Priority (HIGH > MEDIUM > LOW)
3. Test ID (ascending)

# Select next
$NEXT_TEST = $CANDIDATES[0]

Output: Next test details
```

### Priority System

**Priority Levels**:
- **HIGH**: Critical path tests (e.g., skill chains, forking)
- **MEDIUM**: Important validation tests
- **LOW**: Edge cases, error handling

**Default Priority**:
- First test in phase: HIGH
- Remaining tests: MEDIUM
- Error handling tests: LOW

## Auto-Generation Logic

### Environment Generation

**Folder Structure**:
```
tests/test_[ID]/
├── test-output.json          # Generated during execution
├── setup-log.txt             # Setup details
└── .claude/
    └── skills/
        ├── skill-a/
        │   └── SKILL.md      # Generated from JSON
        └── skill-b/
            └── SKILL.md      # Generated from JSON
```

### Skill Generation from JSON

**Process**:
```bash
# For each skill in test.setup.skills:
For skill in $NEXT_TEST.setup.skills:
  # Create directory
  mkdir -p tests/test_$TEST_ID/.claude/skills/${skill.name}

  # Generate SKILL.md from template
  $SKILL_CONTENT = generateSkillTemplate(skill)

  # Write file
  Write $SKILL_CONTENT to tests/test_$TEST_ID/.claude/skills/${skill.name}/SKILL.md

  # Apply context
  If skill.context == "fork":
    Add "context: fork" to YAML frontmatter

  # Add win condition
  Add "## ${SKILL_NAME}_COMPLETE" to output
```

### Skill Templates

**Regular Skill**:
```yaml
---
name: skill-name
description: "Generated from JSON"
user-invocable: false
---

# Generated Skill

Task: [from setup.description]

Win Condition: ## SKILL_NAME_COMPLETE

Execute task based on:
[details from JSON]
```

**Forked Skill**:
```yaml
---
name: skill-name
description: "Generated from JSON"
user-invocable: false
context: fork
---

# Generated Forked Skill

Task: [from setup.description]

**CRITICAL**: You are in a forked context and CANNOT ask the user.
Make decisions based on built-in criteria.

Win Condition: ## SKILL_NAME_COMPLETE
```

**Subagent Skill**:
```yaml
---
name: skill-name
description: "Generated from JSON"
user-invocable: false
context: fork
---

# Generated Subagent Skill

Task: [from setup.description]

This skill has access to custom subagents.

Win Condition: ## SKILL_NAME_COMPLETE
```

## Auto-Execution Logic

### Execution Parameters

**Max-Turns Calculation**:
```bash
$BASE_TURNS = 10
$SKILL_COUNT = length($NEXT_TEST.setup.skills)

If $SKILL_COUNT == 1:
  $MAX_TURNS = 10
Elif $SKILL_COUNT <= 3:
  $MAX_TURNS = 15
Elif hasContextFork($NEXT_TEST.setup.skills):
  $MAX_TURNS = 20
Else:
  $MAX_TURNS = 25
```

### CLI Execution

```bash
# Build command
$PROMPT = buildPrompt($NEXT_TEST)
$MAX_TURNS = calculateMaxTurns($NEXT_TEST)

$CMD = "cd tests/test_$TEST_ID && " +
       "claude --dangerously-skip-permissions " +
       "-p \"$PROMPT\" " +
       "--output-format stream-json " +
       "--verbose --debug " +
       "--no-session-persistence " +
       "--max-turns $MAX_TURNS " +
       "> tests/test_$TEST_ID/test-output.json 2>&1"

# Execute
Execute $CMD

# Wait for completion
Wait for test-output.json to exist
```

## Auto-Analysis Integration

### Analysis Results

The built-in analysis provides:

```json
{
  "autonomy_score": 95,
  "grade": "Excellent",
  "completion_rate": 100,
  "verdict": "PASS",
  "patterns": ["Forked Execution"],
  "findings": [
    "Forked skills are 100% autonomous",
    "No questions asked during execution"
  ],
  "duration_ms": 18570,
  "permission_denials": 0,
  "completion_markers": ["## FORKED_SKILL_COMPLETE"],
  "hallucination_check": "PASS"
}
```

### Integration with JSON Update

```bash
# Analysis provides results
$RESULTS = runBuiltInAnalysis(test-output.json)

# JSON management consumes
UpdateTestStatus($TEST_ID, {
  status: "COMPLETED",
  result: $RESULTS.verdict,
  summary: $RESULTS.summary,
  findings: $RESULTS.findings,
  evidence_file: "raw_logs/phase_X/test_X_Y.description.json",
  duration_ms: $RESULTS.duration_ms,
  permission_denials: $RESULTS.permission_denials,
  confidence: determineConfidence($RESULTS),
  autonomy_score: $RESULTS.autonomy_score
})

# Update summary
UpdateTestSummary({
  completed: increment(),
  not_started: decrement(),
  coverage: recalculate(),
  last_updated: currentTimestamp()
})
```

## Smart Inference

### Test Type Detection

```bash
# Analyze test.setup to determine type
If setup.type == "forked_skill":
  → Forked Execution Test
Elif setup.agents.length > 0:
  → Subagent Test
Elif setup.skills.length >= 3:
  → Chain Test
Elif hasParallelMarkers(setup):
  → Parallel Execution Test
Else:
  → Simple Skill Test
```

### Expected Outcome Prediction

```bash
# From validation criteria
$EXPECTED = {
  autonomy_threshold: test.validation.autonomy_threshold,
  must_have_markers: test.validation.must_have_marker,
  expected_patterns: test.validation.expected_patterns
}

# Compare actual vs expected
$COMPARISON = {
  autonomy_match: actual.autonomy_score >= expected.autonomy_threshold,
  markers_match: actual.completion_rate == 100,
  patterns_match: containsAll(actual.patterns, expected.patterns)
}

$OVERALL = determineVerdict($COMPARISON)
```

### Finding Extraction

```bash
# Auto-extract findings from analysis
$FINDINGS = []

If actual.patterns includes "Forked Execution":
  $FINDINGS.push("Forked skills can use subagents")

If actual.autonomy_score == 100:
  $FINDINGS.push("100% autonomy achieved (0 permission denials)")

If actual.completion_rate == 100:
  $FINDINGS.push("All completion markers present")

If $OVERALL == "FAIL":
  $FINDINGS.push("Test failed: ${failure_reason}")

Return $FINDINGS
```

## Progress Tracking

### Real-Time Updates

```bash
# After each test
$PROGRESS = {
  total_tests: 67,
  completed: countCompleted(),
  failed: countFailed(),
  not_started: countNotStarted(),
  coverage_percentage: (completed / total) * 100,
  success_rate: (completed / (completed + failed)) * 100,
  current_phase: identifyCurrentPhase(),
  next_test: getNextTest()
}

# Display progress bar
DisplayProgressBar($PROGRESS)
```

### Progress Reporting

```markdown
## PROGRESS_REPORT

[████████░░░░░░░░░░░░░░░░░░░░░░░░░] 36% Complete

Total: 67 tests
Completed: 24 ✓
Failed: 1 ✗
Not Started: 42

Success Rate: 96% (24/25 executed)
Current Phase: 2 (Forked Skills Testing)
Next Test: 2.4 (Context Isolation)

Estimated Time Remaining: 2.5 hours
```

## Error Handling

### Auto-Recovery

```bash
If execution fails:
  # Try to recover
  If canRetry($FAILURE_REASON):
    Retry execution
  Else:
    Mark as FAILED
    Update JSON with error details
    Log failure reason
    Continue to next test

If JSON update fails:
  # Backup and retry
  Create backup of JSON
  Retry update
  If still fails:
    Save pending update to .pending_updates/
    Report manual intervention needed
```

### Error Reporting

```markdown
## ERROR_DETECTED

Test: 3.2
Error: Hallucination detected
Reason: No skill tool invocations found
Action: Marked as FAILED

Next Action: Review test 3.2 manually
Progress: Paused at 36% complete

To Continue: test-runner "Execute next test"
```

## Batch Processing Patterns

### Sequential Execution

```bash
# Execute tests one by one
For test in $BATCH_TESTS:
  ExecuteTest(test)
  AnalyzeResults()
  UpdateJSON()
  ReportProgress()

# Advantages:
# - Low resource usage
# - Simple error handling
# - Sequential dependencies work
```

### Parallel Execution (Future Enhancement)

```bash
# Execute tests in parallel (when supported)
For batch in chunk($BATCH_TESTS, 4):  # 4 parallel
  ParallelExecute(batch)

# Advantages:
# - Faster execution
# - Parallel workflows tested
# - Resource intensive
```

## Usage Examples

### Complete Workflow Example

```bash
# Start autonomous testing
user@project:~$ test-runner "Execute next test"

# Skill discovers test 2.3
## TEST_DISCOVERED
Test ID: 2.3
Name: Forked Autonomy
Phase: 2 (Forked Skills Testing)
Status: NOT_STARTED

Generating environment...
✓ Created tests/test_2.3/.claude/skills/interactive-test/
✓ Generated SKILL.md with context: fork
✓ Set win condition: ## INTERACTIVE_TEST_COMPLETE

Executing test...
claude --dangerously-skip-permissions -p "Call interactive-test" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 20 \
  > tests/test_2.3/test-output.json

Test execution complete (18,570ms)

Analyzing results...
✓ NDJSON structure valid (3 lines)
✓ Autonomy score: 100% (0 permission denials)
✓ Completion markers: ## INTERACTIVE_TEST_COMPLETE ✓
✓ Execution pattern: Forked Execution
✓ No hallucinations detected

Updating JSON...
✓ Marked test 2.3 as COMPLETED
✓ Updated test_summary: 24/67 complete (36%)
✓ Added findings: "Forked skills are 100% autonomous"

## AUTONOMOUS_COMPLETE

Test: 2.3 - COMPLETED ✓
Autonomy: 100% (Excellent)
Verdict: PASS
Duration: 18,570ms

Next Test: 2.4 (Context Isolation)
Progress: 36% complete (24/67)
```

### Batch Execution Example

```bash
user@project:~$ test-runner "Execute phase 2"

## PHASE_BATCH_STARTED
Phase: 2 (Forked Skills Testing)
Tests: 9
Status: NOT_STARTED

Executing tests...
[1/9] test_2.1: PASS (95%) ✓
[2/9] test_2.2: PASS (90%) ✓
[3/9] test_2.3: PASS (100%) ✓
[4/9] test_2.4: PASS (95%) ✓
[5/9] test_2.5: PASS (90%) ✓
[6/9] test_2.6: PASS (85%) ✓
[7/9] test_2.7: FAIL (Hallucination) ✗
[8/9] test_2.8: PASS (100%) ✓
[9/9] test_2.9: PASS (95%) ✓

Phase 2 Complete: 8/9 passed (89% success rate)

## PHASE_AUTONOMOUS_COMPLETE

Phase: 2 (Forked Skills Testing) - COMPLETED
Tests: 9
Passed: 8
Failed: 1
Success Rate: 89%

Coverage: 2/11 phases complete (18%)
Next Phase: Phase 3 (Forked + Subagents)
```

## Best Practices

### For Autonomous Testing

✅ **DO**: Use "Execute next test" for individual tests
✅ **DO**: Use "Execute all remaining tests" for batch
✅ **DO**: Let skill manage JSON updates automatically
✅ **DO**: Review progress after each execution

✅ **DO**: Check autonomy scores (aim for ≥85%)
✅ **DO**: Verify completion markers
✅ **DO**: Review findings for discoveries
✅ **DO**: Monitor success rates

❌ **DON'T**: Manually edit JSON during execution
❌ **DON'T**: Skip error handling
❌ **DON'T**: Ignore hallucination warnings
❌ **DON'T**: Interrupt batch execution

### For Test Setup

✅ **DO**: Use descriptive test names
✅ **DO**: Set proper priorities
✅ **DO**: Define validation criteria
✅ **DO**: Include expected markers

❌ **DON'T**: Leave tests in IN_PROGRESS
❌ **DON'T**: Skip phase boundaries
❌ **DON'T**: Use ambiguous IDs
❌ **DON'T**: Forget win conditions

### For Progress Tracking

✅ **DO**: Monitor coverage percentage
✅ **DO**: Track success rates
✅ **DO**: Review findings regularly
✅ **DO**: Update key discoveries

❌ **DON'T**: Ignore failing tests
❌ **DON'T**: Skip error analysis
❌ **DON'T**: Leave gaps in coverage

## Migration from Manual

### Before (Manual Workflow)

```bash
# User manual steps:
1. Check JSON for next test
2. Create folder manually
3. Write SKILL.md files
4. Run CLI command
5. Call analyze_tools.sh script
6. Manually update JSON
7. Archive test folder

# Time per test: 5-10 minutes
# Manual steps: 7
# Error prone: Yes
# External dependencies: analyze_tools.sh
```

### After (Autonomous Workflow)

```bash
# User single command:
test-runner "Execute next test"

# Skill automatic steps:
1-7. All steps above (automatic)
+ Built-in analysis (no external scripts)
+ Progress tracking
+ Findings documentation
+ JSON management

# Time per test: 30 seconds
# Manual steps: 0
# Error prone: No
# External dependencies: None
```

**Benefits**:
- **80% Time Reduction**: 30 seconds vs 5-10 minutes
- **90% Error Reduction**: Automation eliminates mistakes
- **Zero Dependencies**: Self-contained skill
- **100% Autonomous**: No manual intervention

## Advanced Patterns

### Resume After Failure

```bash
# If batch fails, resume from last successful
test-runner "Resume from test 2.6"

# Auto-detects:
# - Last completed test
# - Next NOT_STARTED test
# - Continues batch execution
```

### Dry Run Mode

```bash
# Discover without executing
test-runner "Discover next test"

# Output:
## TEST_DISCOVERED
Next: test 2.4
Would execute if run

# To actually execute:
test-runner "Execute test 2.4"
```

### Selective Execution

```bash
# Execute specific priority
test-runner "Execute HIGH priority tests"

# Auto-filters:
# - Only HIGH priority tests
# - Executes in order
# - Updates JSON
```

## Integration with TaskList

### For Complex Batches

```bash
# Use TaskList for parallel execution
TaskCreate("Execute Phase 2", "test-runner \"Execute phase 2\"")
TaskCreate("Update progress", "test-runner \"Show progress\"")
TaskList  # Monitor progress
```

### For Multi-Session Work

```bash
# Long-running batch
# Set CLAUDE_CODE_TASK_LIST_ID for persistence
export CLAUDE_CODE_TASK_LIST_ID="phase_2_execution"
test-runner "Execute phase 2"

# Resumes across sessions
```

## Success Metrics

### Test-Level Success

- ✅ Autonomy score ≥85%
- ✅ All completion markers present
- ✅ NDJSON structure valid
- ✅ No hallucinations
- ✅ Pass/fail verdict correct

### Batch-Level Success

- ✅ All tests executed
- ✅ JSON updated correctly
- ✅ Progress tracked accurately
- ✅ Findings documented
- ✅ No manual intervention

### Suite-Level Success

- ✅ All phases complete
- ✅ Coverage ≥90%
- ✅ Success rate ≥85%
- ✅ All gaps addressed
- ✅ Key findings captured

## Troubleshooting

### Stuck in Discovery

**Symptom**: Cannot find next test
**Cause**: All tests marked IN_PROGRESS
**Solution**: `test-runner "Reset test 2.3 to NOT_STARTED"`

### JSON Update Failed

**Symptom**: Execution succeeds but JSON not updated
**Cause**: File permissions or format error
**Solution**: Check JSON validity, fix permissions

### Hallucination Detected

**Symptom**: Test marked as FAIL due to hallucination
**Cause**: Skill didn't use tool mechanism
**Solution**: Review skill generation, fix YAML

### Execution Timeout

**Symptom**: Test exceeds max-turns
**Cause**: Infinite loop or complex workflow
**Solution**: Increase max-turns, review skill logic
