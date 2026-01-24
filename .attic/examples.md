# Examples - Usage Guide

Comprehensive examples for using the test-runner skill in various scenarios.

## Quick Start Examples

### Example 1: Execute Next Test (Recommended)

```bash
# Most common use case
test-runner "Execute next test"

# Output:
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

### Example 2: Analyze Existing Test

```bash
# Analyze a test that was run manually
test-runner "Analyze" tests/test_1_1/test-output.json

# Output:
## ANALYSIS_COMPLETE

Test: test_1_1
NDJSON Structure: ✓ (3 lines)
Autonomy: 95% (Excellent)
Completion Markers: ✓
Execution Pattern: Regular Chain
Hallucination Check: ✓ (No issues)

Details:
- Line 1: System init (10 tools, 2 skills)
- Line 2: Assistant message with completion marker
- Line 3: Result (10 turns, 7,736ms, 0 denials)

Verdict: PASS
```

### Example 3: Show Progress

```bash
# View current test plan status
test-runner "Show progress"

# Output:
## PROGRESS_SUMMARY

Total Tests: 67
Completed: 24 (36%)
Failed: 1
Not Started: 42
Success Rate: 96% (24/25 executed)

Phase Breakdown:
Phase 1: ✓ Complete (2/2)
Phase 2: In Progress (7/9)
Phase 3: Not Started (0/2)
Phase 4: Not Started (0/3)
Phase 5+: Not Started (0/51)

Current Phase: 2
Next Test: 2.4 (Context Isolation)
```

## Autonomous Execution Examples

### Example 4: Single Autonomous Test

```bash
# Complete automation for one test
test-runner "Execute test 3.1"

# Output:
## AUTONOMOUS_STARTED

Test: 3.1
Name: Forked with Subagents
Phase: 3 (Forked + Subagents)
Status: NOT_STARTED → IN_PROGRESS

Generating environment...
✓ Created tests/test_3.1/.claude/skills/forked-subagent/
✓ Generated SKILL.md with context: fork
✓ Added subagent configuration
✓ Set win condition: ## FORKED_SUBAGENT_COMPLETE

Executing test...
[... execution logs ...]

Analyzing results...
✓ NDJSON structure valid
✓ Autonomy score: 95%
✓ Completion marker present
✓ Subagent pattern detected

Updating JSON...
✓ Status: COMPLETED
✓ Result: PASS
✓ Evidence: raw_logs/phase_3/test_3.1.forked.with.subagents.json

## AUTONOMOUS_COMPLETE

Test: 3.1 - COMPLETED ✓
Autonomy: 95% (Excellent)
Verdict: PASS
Duration: 22,341ms
```

### Example 5: Execute All Remaining Tests

```bash
# Run entire test suite
test-runner "Execute all remaining tests"

# Output:
## BATCH_AUTONOMOUS_STARTED

Tests to Execute: 42
Estimated Time: 2.5 hours
Phases: 2-11

Executing tests sequentially...
[1/42] test_2.4: PASS (100%) ✓
[2/42] test_2.5: PASS (95%) ✓
[3/42] test_2.6: PASS (90%) ✓
[4/42] test_2.7: FAIL (Hallucination) ✗
[... continues ...]
[40/42] test_10.5: PASS (100%) ✓
[41/42] test_10.6: PASS (95%) ✓
[42/42] test_11.1: PASS (90%) ✓

## BATCH_AUTONOMOUS_COMPLETE

Tests Executed: 42
Passed: 38
Failed: 4
Success Rate: 90%

Total Suite: 67 tests
Completed: 62 (93%)
Failed: 5
Coverage: 93% complete

Next: Review failed tests (2.7, 5.3, 7.2, 9.1)
```

### Example 6: Execute Phase

```bash
# Run specific phase only
test-runner "Execute phase 4"

# Output:
## PHASE_AUTONOMOUS_STARTED

Phase: 4 (Advanced Patterns)
Tests: 3
Priority: HIGH

Executing Phase 4 tests...
[1/3] test_4.1: PASS (100%) ✓
[2/3] test_4.2: PASS (95%) ✓
[3/3] test_4.3: PASS (90%) ✓

## PHASE_AUTONOMOUS_COMPLETE

Phase: 4 - COMPLETED ✓
Tests: 3/3 passed
Success Rate: 100%

Coverage: 4/11 phases complete (36%)
Next Phase: Phase 5 (Context Transfer)
```

## Manual Mode Examples

### Example 7: Manual Test Setup and Execution

```bash
# Create test manually (legacy workflow)
mkdir -p /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1/.claude/skills/skill-b
mkdir -p /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1/.claude/skills/skill-a

# Create skill-b
cat > /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1/.claude/skills/skill-b/SKILL.md << 'EOF'
---
name: skill-b
description: "Simple transitive skill for testing"
---

## SKILL_B_COMPLETE

Processing completed successfully.
EOF

# Create skill-a
cat > /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1/.claude/skills/skill-a/SKILL.md << 'EOF'
---
name: skill-a
description: "Calls skill-b"
user-invocable: true
---

## SKILL_A_COMPLETE

Calling skill-b to test skill chaining.

[SCall skill-b]
EOF

# Execute test
cd /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1 && \
claude --dangerously-skip-permissions -p "Call skill-a" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 10 \
  > /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1/test-output.json 2>&1

# Analyze with built-in (no external script)
test-runner "Analyze" /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1/test-output.json

# Output:
## ANALYSIS_COMPLETE

Test: test_1_1
Autonomy: 100% (Excellent)
Verdict: PASS
Duration: 7,736ms

Completion Markers: ✓
- ## SKILL_B_COMPLETE ✓
- ## SKILL_A_COMPLETE ✓

Execution Pattern: Regular Chain
Findings: One-way handoff confirmed
```

## Analysis Examples

### Example 8: Single File Analysis

```bash
# Detailed analysis of one test
test-runner "Analyze test 2.3 in detail"

# Output:
## DETAILED_ANALYSIS

File: tests/test_2_3/test-output.json

NDJSON Structure:
✓ Line 1: System init (12 tools, 3 skills)
✓ Line 2: Assistant message (2,847 chars)
✓ Line 3: Result summary

Autonomy Analysis:
✓ Permission Denials: 0
✓ Questions Asked: 0
✓ Autonomy Score: 100% (A+)
✓ Grade: Excellence

Completion Verification:
✓ ## INTERACTIVE_TEST_COMPLETE found
✓ Marker present at line 2
✓ Expected: 1 marker
✓ Found: 1 marker
✓ Completion Rate: 100%

Execution Patterns:
✓ Forked Execution detected
✓ Context: fork used
✓ No TaskList tools
✓ No Subagent usage

Tool Usage:
- Skill Calls: 1
- Read Operations: 3
- Edit Operations: 1
- Bash Commands: 2

Hallucination Check:
✓ Real tool invocations found
✓ Matching results present
✓ No manual file reading
✓ No synthetic markers

Verdict: PASS (100% autonomy)
```

### Example 9: Batch Analysis

```bash
# Analyze entire directory
test-runner "Analyze all" tests/raw_logs/phase_2/

# Output:
## BATCH_ANALYSIS_COMPLETE

Phase: 2 (Forked Skills Testing)
Files Analyzed: 9
Total Duration: 156,789ms

Results Summary:
✓ Passed: 8 tests
✗ Failed: 1 test
Success Rate: 89%

Detailed Results:
  test_2.1.basic.fork.json
    Autonomy: 100% ✓
    Verdict: PASS
    Duration: 12,450ms

  test_2.2.context.isolation.json
    Autonomy: 95% ✓
    Verdict: PASS
    Duration: 15,230ms

  test_2.3.forked.autonomy.json
    Autonomy: 100% ✓
    Verdict: PASS
    Duration: 18,570ms

  test_2.4.standard.fork.json
    Autonomy: 0% ✗
    Verdict: FAIL
    Duration: 45,120ms
    Reason: 8 permission denials

  [... 5 more tests ...]

Aggregate Metrics:
Average Autonomy: 88%
Median Duration: 17,500ms
Fastest: 12,450ms (test_2.1)
Slowest: 45,120ms (test_2.4 - failed)

Findings:
- Forked skills achieve 100% autonomy
- Standard forking has issues (test_2.4)
- Context isolation works correctly
- Subagent integration successful
```

### Example 10: Autonomy Verification

```bash
# Check autonomy scores across tests
test-runner "Show autonomy scores"

# Output:
## AUTONOMY_REPORT

Tests Analyzed: 25
Average Autonomy: 92%

Score Distribution:
100% (Excellent): 15 tests ████████████████
  95%: 4 tests  ████
  90%: 3 tests  ███
  85%: 2 tests  ██
  <85% (Fail): 1 test ▌

Phase Breakdown:
Phase 1: 100% avg (2/2 tests)
Phase 2: 88% avg (8/9 tests)
Phase 3: 95% avg (2/2 tests)
Phase 4: 90% avg (3/3 tests)
Phase 5+: 85% avg (10/10 tests)

Tests Needing Improvement:
- test_2.4: 0% autonomy (8 denials)
- test_5.3: 70% autonomy (3 denials)

Recommendations:
✓ Forked skills maintain excellent autonomy
⚠ Standard forking needs refinement (test_2.4)
✓ Context isolation preserves autonomy
```

## JSON Management Examples

### Example 11: Update Test Status

```bash
# Manually mark test as completed
test-runner "Mark test 3.2 as completed with findings: Custom subagents work correctly"

# Output:
## JSON_UPDATED

Test: 3.2
Status: NOT_STARTED → COMPLETED
Result: PASS
Findings: "Custom subagents work correctly"

Progress Updated:
✓ Completed: 24 → 25
✓ Not Started: 42 → 41
✓ Coverage: 36% → 37%

Next Test: 3.3 (or next NOT_STARTED)
```

### Example 12: Mark Test Failed

```bash
# Record test failure
test-runner "Mark test 7.2 as failed with reason: Parallel execution timeout"

# Output:
## JSON_UPDATED

Test: 7.2
Status: NOT_STARTED → FAILED
Result: FAIL
Reason: "Parallel execution timeout"

Progress Updated:
✓ Failed: 1 → 2
✓ Not Started: 42 → 41
✓ Coverage: 36% → 37%

Next Test: Continue with 7.3
```

### Example 13: Show Test Plan

```bash
# View test plan summary
test-runner "Show test plan"

# Output:
## TEST_PLAN_SUMMARY

Name: Skill Interaction & Context Fork Testing
Version: 8.0
Description: Updated with Phase 11: Complete Recursive vs TaskList Coverage

Key Findings:
✓ Regular skill chains are one-way handoffs
✓ Forked skills enable subroutine pattern
✓ Context isolation is complete
✓ Forked skills are 100% autonomous
✓ Custom subagents accessible in forked context
✓ Nested forks work correctly
✓ TaskList tools added as built-in primitives

Workflow Taxonomy:
Type 1 (Linear Chain): BROKEN
Type 2 (Hub-Spoke): WORKS
Type 3 (Nested Forks): WORKS (depth 2)
Type 4 (Subagent Skills): WORKS
Type 5 (Parallel): PARTIAL

Test Summary:
Total: 67
Completed: 24 (36%)
Failed: 1
Not Started: 42
Success Rate: 96%
```

## Advanced Examples

### Example 14: Discover Next Test

```bash
# Find what to test next
test-runner "Discover next test"

# Output:
## TEST_DISCOVERED

Next Test: 2.4
Name: Standard Fork
Phase: 2 (Forked Skills Testing)
Priority: HIGH
Status: NOT_STARTED

Setup:
- Type: Forked Skill
- Skills: forked-skill (context: fork)
- Expected Marker: ## FORKED_SKILL_COMPLETE

Validation:
- Autonomy Threshold: ≥80%
- Must Have Marker: Yes
- Expected Pattern: Forked Execution

Estimated Duration: 15-20 seconds

To Execute: test-runner "Execute test 2.4"
```

### Example 15: Resume After Failure

```bash
# Continue from specific test
test-runner "Resume from test 2.7"

# Output:
## RESUME_DETECTED

Last Completed: test_2.6
Next Test: test_2.7
Status: NOT_STARTED

Continuing batch execution...
```

### Example 16: Dry Run

```bash
# Preview what would happen
test-runner "Dry run phase 3"

# Output:
## DRY_RUN

Phase: 3 (Forked + Subagents)
Tests: 2
Status: All NOT_STARTED

Would Execute:
[1] test_3.1: Forked with Subagents
    Estimated: 20 seconds
    Priority: HIGH

[2] test_3.2: Custom Subagents
    Estimated: 25 seconds
    Priority: HIGH

Total Estimated Time: 45 seconds

To Execute: test-runner "Execute phase 3"
```

### Example 17: Selective Execution

```bash
# Execute only HIGH priority tests
test-runner "Execute HIGH priority tests"

# Output:
## SELECTIVE_EXECUTION

Priority Filter: HIGH
Tests Found: 12

Executing in order:
[1/12] test_1.1: Basic skill calling (HIGH)
[2/12] test_2.1: Basic fork (HIGH)
[3/12] test_2.3: Forked autonomy (HIGH)
[... 9 more ...]

## SELECTIVE_COMPLETE

Executed: 12 tests
Passed: 11
Failed: 1
Success Rate: 92%

Coverage: 18% → 36%
```

## Error Handling Examples

### Example 18: Handle JSON Error

```bash
# If JSON is invalid
test-runner "Execute next test"

# Output:
## ERROR_DETECTED

File: tests/skill_test_plan.json
Error: JSON parse error at line 45
Invalid token: '}'
Action: Fix JSON syntax

Validating JSON structure...
Expected: tests/skill_test_plan.json to be valid JSON

To Fix:
1. Open tests/skill_test_plan.json
2. Check line 45 for syntax error
3. Validate with: jq . tests/skill_test_plan.json
4. Re-run: test-runner "Execute next test"
```

### Example 19: Handle Hallucination

```bash
# If test fails hallucination check
test-runner "Execute test 5.3"

# Output:
## AUTONOMOUS_COMPLETE

Test: 5.3 - FAILED ✗

Autonomy: 70% (Acceptable)
Verdict: FAIL
Reason: Hallucination detected

Hallucination Check:
✗ No skill tool invocations found
✗ Text-only execution detected
✗ Missing completion markers

Expected:
- At least 1 skill tool use
- ## SKILL_5_3_COMPLETE marker
- Real execution (not text claims)

Next Action:
Review test 5.3 setup
Regenerate skills with proper YAML
Re-run: test-runner "Execute test 5.3"
```

### Example 20: Handle Missing Test

```bash
# If test doesn't exist
test-runner "Execute test 99.9"

# Output:
## TEST_NOT_FOUND

Test ID: 99.9
Error: Test does not exist

Available Tests:
Phase 1: 1.1, 1.2
Phase 2: 2.1, 2.2, ..., 2.9
Phase 3: 3.1, 3.2
Phase 4: 4.1, 4.2, 4.3
...

To Execute Next Test:
test-runner "Execute next test"
```

## Integration Examples

### Example 21: Integration with TaskList

```bash
# Use TaskList for complex batch
TaskCreate("Execute Phase 2", "test-runner \"Execute phase 2\"")
TaskCreate("Verify Phase 2", "test-runner \"Analyze phase 2 results\"")
TaskCreate("Generate Report", "test-runner \"Show progress\"")

TaskList  # Monitor progress

# Output:
[Task 1] Execute Phase 2: IN_PROGRESS
[Task 2] Verify Phase 2: PENDING
[Task 3] Generate Report: PENDING
```

### Example 22: Multi-Session Execution

```bash
# Session 1: Start long batch
export CLAUDE_CODE_TASK_LIST_ID="phase_2_execution"
test-runner "Execute phase 2"

# [Session ends at test 2.5]

# Session 2: Resume
export CLAUDE_CODE_TASK_LIST_ID="phase_2_execution"
test-runner "Execute next test"

# Auto-resumes from test 2.6
```

### Example 23: Custom Test Creation

```bash
# Generate test from JSON spec
test-runner "Create test 11.39 with setup: Nested TaskList workflow"

# Output:
## TEST_GENERATED

Test: 11.39
Name: Nested TaskList Workflow
Phase: 11 (TaskList Advanced)
Status: NOT_STARTED

Created:
✓ tests/test_11_39/.claude/skills/nested-tasklist/
✓ Generated SKILL.md
✓ Added setup validation
✓ Set win condition: ## NESTED_TASKLIST_COMPLETE

To Execute: test-runner "Execute test 11.39"
```

## Best Practices Examples

### ✅ DO: Use Autonomous Mode

```bash
# Recommended: Full automation
test-runner "Execute next test"
```

### ❌ DON'T: Manual JSON Editing

```bash
# Not recommended: Manual edit
# Edit tests/skill_test_plan.json manually
# Risk: Breaking JSON structure
```

### ✅ DO: Check Progress Regularly

```bash
# After batch execution
test-runner "Show progress"

# Review findings
test-runner "Show key findings"
```

### ✅ DO: Review Failed Tests

```bash
# Analyze failures
test-runner "Show failed tests"

# Review specific failure
test-runner "Analyze" tests/test_2_4/test-output.json
```

### ✅ DO: Monitor Autonomy Scores

```bash
# Check scores across tests
test-runner "Show autonomy scores"

# Aim for ≥85% average
```

## Migration Examples

### From Manual to Autonomous

**Before (Manual)**:
```bash
# 7 manual steps
1. Check JSON for next test
2. Create folder
3. Write skills
4. Run CLI
5. Call analyze_tools.sh
6. Update JSON
7. Archive

Time: 5-10 minutes per test
```

**After (Autonomous)**:
```bash
# 1 automatic step
test-runner "Execute next test"

Time: 30 seconds per test
Savings: 80% time reduction
```

### From External Script to Built-in

**Before (analyze_tools.sh)**:
```bash
# External bash dependency
bash .claude/skills/test-runner/scripts/analyze_tools.sh test-output.json
```

**After (Built-in)**:
```bash
# No external dependencies
test-runner "Analyze" test-output.json

Benefits:
- Faster (no subprocess)
- Integrated (JSON management)
- Self-contained (no external files)
```

## Summary Table

| Use Case | Command | Time | Autonomy |
|----------|---------|------|----------|
| Next test | `test-runner "Execute next test"` | 30s | 100% |
| All tests | `test-runner "Execute all remaining"` | 2.5h | 100% |
| Phase | `test-runner "Execute phase X"` | 5-10m | 100% |
| Specific | `test-runner "Execute test X.Y"` | 30s | 100% |
| Analyze | `test-runner "Analyze" file.json` | 5s | N/A |
| Batch | `test-runner "Analyze" directory/` | 10s | N/A |
| Progress | `test-runner "Show progress"` | 2s | N/A |

## Quick Reference

```bash
# Core commands
test-runner "Execute next test"
test-runner "Execute all remaining tests"
test-runner "Execute phase 2"
test-runner "Execute test 2.3"

# Analysis commands
test-runner "Analyze" tests/test.json
test-runner "Analyze all" tests/raw_logs/phase_2/

# Management commands
test-runner "Show progress"
test-runner "Show test plan"
test-runner "Discover next test"
test-runner "Mark test X.Y as completed"

# Advanced commands
test-runner "Execute HIGH priority tests"
test-runner "Dry run phase 3"
test-runner "Resume from test X.Y"
test-runner "Show autonomy scores"
```
