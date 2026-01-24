---
name: test-runner
description: "Unified CLI testing workflow - execute skills/plugins/subagents tests with stream-json output, automated analysis, and comprehensive reporting"
user-invocable: true
---

# Test Runner

Unified testing workflow for skills, plugins, and subagents using Claude CLI print mode with automated log analysis.

## 🚨 MANDATORY EXECUTION PATTERN - COPY THIS TEMPLATE

**EVERY test must follow this exact pattern. NO exceptions.**

```bash
# Step 1: Create test folder with ABSOLUTE path
mkdir -p /ABSOLUTE/PATH/tests/test_X_X/.claude/skills/skill-name

# Step 2: Create skill file
cat > /ABSOLUTE/PATH/tests/test_X_X/.claude/skills/skill-name/SKILL.md << 'EOF'
---
name: skill-name
description: "Test skill"
---

## SKILL_COMPLETE
EOF

# Step 3: Execute test (SYNCHRONOUS ONLY - NEVER use run_in_background)
cd /ABSOLUTE/PATH/tests/test_X_X && \
claude --dangerously-skip-permissions -p "Call skill-name" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 10 \
  > /ABSOLUTE/PATH/tests/test_X_X/test-output.json 2>&1

# Step 4: Verify NDJSON structure (MUST be exactly 3 lines)
wc -l /ABSOLUTE/PATH/tests/test_X_X/test-output.json
# Expected output: 3

# Step 5: Verify autonomy score
grep '"permission_denials":\s*\[\]' /ABSOLUTE/PATH/tests/test_X_X/test-output.json && echo "100% autonomy"
```

### ⛔ FORBIDDEN PATTERNS - NEVER DO THIS

❌ **NEVER** use `run_in_background: true` for test execution
❌ **NEVER** execute without `cd /ABSOLUTE/PATH &&` prefix
❌ **NEVER** use relative paths or `/tmp/` for test folders
❌ **NEVER** redirect output without `2>&1` (stderr must be captured)
❌ **NEVER** skip verifying the 3-line NDJSON structure
❌ **NEVER** use `timeout` command directly (use max-turns instead)

---

## MANDATORY POST-EXECUTION VERIFICATION (CRITICAL)

**EVERY test execution MUST be followed by this exact verification sequence.**

### Results Location Rule

```
tests/
├── test_X_X/              # PRIMARY: Write results here first
│   └── test-output.json   # Fresh execution output
└── raw_logs/              # SECONDARY: Archive here AFTER validation
    └── phase_X/
        └── test_X_Y.description.json  # Archived/renamed copy
```

**WORKFLOW**: Always write to `test_X_X/test-output.json` first. Only migrate to `raw_logs/` AFTER successful validation.

### Step 1: Verify NDJSON Structure

```bash
# Check line count (MUST be exactly 3)
wc -l /ABSOLUTE/PATH/tests/test_X_X/test-output.json
# Expected output: 3
```

**If not 3 lines**: TEST INVALID - re-execute with correct flags

### Step 2: Run Comprehensive Analysis Script (MANDATORY)

```bash
# This script verifies: real skill calls, success status, autonomy, hallucination detection
bash scripts/analyze_tools.sh \
  /ABSOLUTE/PATH/tests/test_X_X/test-output.json
```

**What the script checks**:
- ✅ Real Skill tool invocations (not hallucinated)
- ✅ Tool result verification (success/failure)
- ✅ Forked execution detection
- ✅ TaskList tool usage tracking
- ✅ Agent usage tracking
- ✅ Anti-hallucination checks (manual SKILL.md reading)
- ✅ Completion marker verification
- ✅ Permission denials counting
- ✅ Final verdict (PASS/FAIL/PARTIAL)

**Script output shows**: Verdict + autonomy score + detailed breakdown

### Step 3: Migrate to raw_logs (AFTER validation passes)

```bash
# ONLY after analyze_tools.sh shows PASS or acceptable PARTIAL
# Rename and move to raw_logs with descriptive name
mv /ABSOLUTE/PATH/tests/test_X_X/test-output.json \
   /ABSOLUTE/PATH/tests/raw_logs/phase_X/test_X_Y.description.json

# Where:
# - phase_X = the test phase number (1-7)
# - test_X_Y = test ID (e.g., test_2_3)
# - description = brief test name (e.g., forked_subagent)
```

**When to migrate**:
- ✅ AFTER analyze_tools.sh completes successfully
- ✅ AFTER you record the verdict/autonomy score
- ✅ BEFORE starting the next test

**When NOT to migrate**:
- ❌ If test failed and needs re-execution (keep in test_X_X folder)
- ❌ If you need to manually inspect the raw output

### Step 4: Verify Critical Indicators (Manual Confirmation)

After script completes, verify these specific metrics:

```bash
# 1. Verify NDJSON line count
LINES=$(wc -l < /ABSOLUTE/PATH/tests/test_X_X/test-output.json)
[ "$LINES" -eq 3 ] && echo "✅ NDJSON valid" || echo "❌ NDJSON invalid: $LINES lines"

# 2. Check for Skill tool invocations
grep '"type":"tool_use"' /ABSOLUTE/PATH/tests/test_X_X/test-output.json | grep '"name":"Skill"' && echo "✅ Skill calls found" || echo "❌ No Skill calls"

# 3. Verify completion markers
grep "##.*COMPLETE" /ABSOLUTE/PATH/tests/test_X_X/test-output.json && echo "✅ Completion markers" || echo "⚠️ No completion markers"

# 4. Check autonomy (0 denials = 100%)
grep '"permission_denials":\s*\[\]' /ABSOLUTE/PATH/tests/test_X_X/test-output.json && echo "✅ 100% autonomy" || echo "⚠️ Permission denials present"
```

### Step 4: Extract Metrics for Documentation

```bash
# Duration in ms
jq -r '.result.duration_ms' /ABSOLUTE/PATH/tests/test_X_X/test-output.json

# Number of turns
jq -r '.result.num_turns' /ABSOLUTE/PATH/tests/test_X_X/test-output.json

# Permission denials count
jq -r '.result.permission_denials | length' /ABSOLUTE/PATH/tests/test_X_X/test-output.json
```

### Step 5: Record Results

Update TaskList status with:
- Autonomy score (from permission_denials count)
- Test verdict (PASS/FAIL based on criteria)
- Key findings from script output
- Any anomalies or issues detected

---

## Step-by-Step Test Execution (MANDATORY WORKFLOW)

### Phase 1: Setup (Pre-Flight)

1. **Read test plan** to identify next NOT_STARTED test
2. **Create test folder** with ABSOLUTE path: `mkdir -p /ABSOLUTE/PATH/tests/test_X_X/.claude/skills/`
3. **Create skill files** in that folder using Write tool or `cat > file << 'EOF'`
4. **Verify skills exist**: `ls -la /ABSOLUTE/PATH/tests/test_X_X/.claude/skills/`

### Phase 2: Execute (SYNCHRONOUS)

5. **Execute test** using the MANDATORY pattern above:
   ```bash
   cd /ABSOLUTE/PATH/tests/test_X_X && \
   claude --dangerously-skip-permissions -p "Call skill-name" \
     --output-format stream-json --verbose --debug \
     --no-session-persistence --max-turns N \
     > /ABSOLUTE/PATH/tests/test_X_X/test-output.json 2>&1
   ```
6. **Wait for completion** - command will return when done (synchronous only)
7. **Verify file exists**: `test -f /ABSOLUTE/PATH/tests/test_X_X/test-output.json`

### Phase 3: Validate (Post-Execution) - MANDATORY

8. **MANDATORY: Run comprehensive analysis script**:
   ```bash
   bash scripts/analyze_tools.sh \
     /ABSOLUTE/PATH/tests/test_X_X/test-output.json
   ```

9. **MANDATORY: Verify all critical checks**:
   - [ ] NDJSON has exactly 3 lines
   - [ ] Skill tool invocations found (not hallucinated)
   - [ ] All skills show success status
   - [ ] Completion markers present
   - [ ] Permission denials count acceptable (0-3 preferred)

10. **MANDATORY: Extract metrics**:
    - Autonomy score from permission_denials
    - Duration from result.duration_ms
    - Turn count from result.num_turns

### Phase 4: Archive (After Validation)

11. **Migrate to raw_logs AFTER validation passes**:
   ```bash
   # Move archived log with descriptive name
   mv /ABSOLUTE/PATH/tests/test_X_X/test-output.json \
      /ABSOLUTE/PATH/tests/raw_logs/phase_X/test_X_Y.description.json
   ```

**Naming convention**: `test_X_Y.description.json`
- `X_Y` = test ID from test plan (e.g., 2_3)
- `description` = brief descriptive name (e.g., forked_subagent, hub_spoke)

**Only migrate when**:
- ✅ Validation passed (acceptable verdict from analyze_tools.sh)
- ✅ Metrics recorded (autonomy, duration, etc.)
- ❌ Keep in test_X_X folder if test needs re-execution

### Phase 5: Document

12. **Update TaskList** status to completed
13. **Record findings** in test plan or results

---

## Test Folder Lifecycle (When to Clean Up)

```
tests/
├── test_X_X/              # ACTIVE: Test in progress or needs review
│   ├── .claude/skills/    # Test skills
│   └── test-output.json   # Fresh output (before analysis)
│
└── raw_logs/              # ARCHIVED: Validated test results
    └── phase_X/
        └── test_X_Y.description.json
```

**Lifecycle states**:
1. **Setup** → test_X_X folder created, skills added
2. **Execute** → test-output.json written
3. **Validate** → analyze_tools.sh run on test-output.json
4. **Archive** → test-output.json moved to raw_logs/ (rename with description)
5. **Cleanup** → test_X_X folder removed (if migration successful)

**When to delete test_X_X folder**:
- ✅ After successful migration to raw_logs
- ✅ After recording all metrics
- ❌ Keep if test failed and needs re-execution

**When to keep test_X_X folder**:
- ❌ Test failed and needs debugging
- ❌ Need to re-execute with different parameters
- ❌ Manual inspection of raw output needed

---

## RECOMMENDED: Context Validation

Read these URLs when accuracy matters for testing work:

### Primary Documentation
- **CLI Reference Guide**: https://code.claude.com/docs/en/cli-reference
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Print mode, stream-json output, testing workflows

- **Agent Skills Testing**: https://code.claude.com/docs/en/skills
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Skill testing patterns, autonomy validation

### When to Fetch vs Skip
**Fetch when**:
- Documentation may have changed since last read
- User requests verification of CLI testing patterns
- Starting new test suite or debugging test issues
- Uncertain about current testing best practices

**Skip when**:
- Running tests based on established patterns
- Local-only work without external dependencies
- Working offline
- Recently read and documentation is stable

**Trust your judgment**: You know when validation is needed for accurate test execution.

## WIN CONDITION

```markdown
## TEST_RUNNER_COMPLETE

Workflow: [mode]
Tests Run: [count]
Results: [summary]
Autonomy: [score]%
```

---

## Quick Examples

### Execution Mode (PRIMARY - Use This First)

**This is the PRIMARY pattern for test execution. Follow this exactly.**

```bash
# Create test folder
mkdir -p /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1/.claude/skills/test-skill

# Create skill
cat > /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1/.claude/skills/test-skill/SKILL.md << 'EOF'
---
name: test-skill
description: "Test skill"
---

## SKILL_COMPLETE
EOF

# Execute test (SYNCHRONOUS - follow exactly)
cd /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1 && \
claude --dangerously-skip-permissions -p "Call test-skill" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 10 \
  > /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1/test-output.json 2>&1

# Verify output (MUST be 3 lines)
wc -l /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1/test-output.json
```

### Analysis Mode (MANDATORY After Each Test)

**CRITICAL: Every test execution MUST be followed by analysis using the analysis script.**

```bash
# Step 1: REQUIRED - Analyze fresh test output
bash scripts/analyze_tools.sh \
  /ABSOLUTE/PATH/tests/test_X_X/test-output.json

# Step 2: AFTER validation passes - migrate to raw_logs
mv /ABSOLUTE/PATH/tests/test_X_X/test-output.json \
   /ABSOLUTE/PATH/tests/raw_logs/phase_X/test_X_Y.description.json

# Step 3: OPTIONAL - JSON test plan operations
uv run scripts/test_runner_helper.py progress
uv run scripts/test_runner_helper.py find-next
```

**Analysis Script Output:**
- Verdict: PASS/FAIL/PARTIAL
- Autonomy score (0-100%)
- Permission denials count
- Skill invocations verified
- Completion markers found
- Hallucination detection
- Tool usage breakdown

**Remember**: Only migrate to raw_logs AFTER analyze_tools.sh confirms acceptable results.

### Autonomous Mode (For Batch Execution)

```bash
# Execute next test (fully automatic)
test-runner "Execute next test"

# Run all remaining tests
test-runner "Execute all remaining tests"

# Execute specific phase
test-runner "Execute phase 2"

# Execute specific test by ID
test-runner "Execute test 2.3"

# Show current progress
test-runner "Show progress"
```

```bash
# Create test folder
mkdir -p /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1/.claude/skills/test-skill

# Execute test
cd /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1 && \
claude --dangerously-skip-permissions -p "Call test-skill" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 10 \
  > /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1/test-output.json 2>&1
```

### Analysis Mode

```bash
# Analyze single test file
test-runner "Analyze" tests/test-output.json

# Analyze entire directory (batch)
test-runner "Analyze" tests/raw_logs/phase_2/

# Show test plan progress
test-runner "Show progress"

# Discover next test to run
test-runner "Discover next test"
```

---

## Core Testing Concepts

### NDJSON Output Structure (3 Lines)

- **Line 1**: System init (`tools`, `skills`, `agents`, `mcp_servers`)
- **Line 2**: Assistant message
- **Line 3**: Result (`num_turns`, `duration_ms`, `permission_denials`)

### Mandatory CLI Flags

```bash
--dangerously-skip-permissions    # Auto-approve prompts
--output-format stream-json        # NDJSON output
--verbose --debug                 # Debug visibility
--no-session-persistence          # Don't save sessions
--max-turns N                     # Limit conversation rounds
```

### Autonomy Scoring

| Denials | Score | Grade |
|---------|-------|-------|
| 0 | 95-100% | Excellence |
| 1-3 | 85-95% | Good |
| 4-5 | 80-84% | Acceptable |
| 6+ | <80% | Fail |

Check: `grep '"permission_denials"' test-output.json`

---

## Best Practices

### PRIMARY: Test Execution (MANDATORY PATTERN)

✅ **ALWAYS**: Use `cd /ABSOLUTE/PATH && claude ... > output.json 2>&1` pattern
✅ **ALWAYS**: Execute SYNCHRONONOUSLY - wait for command to complete
✅ **ALWAYS**: Use ABSOLUTE paths - never relative paths or /tmp/
✅ **ALWAYS**: Include `2>&1` to capture stderr in output
✅ **ALWAYS**: Write to `test_X_X/test-output.json` first (NOT raw_logs yet)
✅ **ALWAYS**: Run `analyze_tools.sh` on test-output.json after execution
✅ **ALWAYS**: Verify 3-line NDJSON structure after execution
✅ **ALWAYS**: Check autonomy score in permission_denials field
✅ **ALWAYS**: Create ONE folder per test with test_X_X naming
✅ **ALWAYS**: Migrate to `raw_logs/phase_X/test_X_Y.description.json` AFTER validation

❌ **NEVER**: Use `run_in_background: true` for test execution
❌ **NEVER**: Use `timeout` command - use `--max-turns` instead
❌ **NEVER**: Execute without `cd /ABSOLUTE/PATH &&` prefix
❌ **NEVER**: Create test skills in /tmp/ or any temporary location
❌ **NEVER**: Skip verifying the 3-line NDJSON output structure
❌ **NEVER**: Migrate to raw_logs BEFORE running analyze_tools.sh
❌ **NEVER**: Archive failed tests (keep in test_X_X for re-execution)

### For TaskList Integration

✅ **DO**: Use TaskList to track test execution progress
✅ **DO**: Create one task per test or per phase
✅ **DO**: Use TaskUpdate to mark tests as in_progress/completed
✅ **DO**: Read skill_test_plan.json with jq for precise parsing

❌ **DON'T**: Manually edit skill_test_plan.json without jq
❌ **DON'T**: Skip TaskList tracking - it's critical for batch execution

---

## Pre-Flight Checklist (MANDATORY - Verify Before Each Test)

**Check EVERY item before executing ANY test:**

### Setup Verification
- [ ] Test folder created at `/ABSOLUTE/PATH/tests/test_X_X/.claude/skills/`
- [ ] Skill file(s) created in the skills subfolder
- [ ] Skills have correct YAML frontmatter (name, description, context)
- [ ] Skills have completion markers (## SKILL_COMPLETE or similar)

### Path Verification
- [ ] Using ABSOLUTE paths (starting with /)
- [ ] No relative paths (no ../, no ./)
- [ ] No /tmp/ or temporary directories

### Command Verification
- [ ] Command starts with `cd /ABSOLUTE/PATH/tests/test_X_X &&`
- [ ] All mandatory flags present: `--dangerously-skip-permissions`, `--output-format stream-json`, `--verbose --debug`, `--no-session-persistence`, `--max-turns N`
- [ ] Output redirects to `/ABSOLUTE/PATH/tests/test_X_X/test-output.json`
- [ ] Includes `2>&1` to capture stderr
- [ ] NO `run_in_background: true`
- [ ] NO `timeout` command wrapper

### Post-Execution Verification
- [ ] test-output.json file exists
- [ ] File has exactly 3 lines (`wc -l` returns 3)
- [ ] Line 1 is system init with tools/skills arrays
- [ ] Line 2 is assistant message with content
- [ ] Line 3 is result with num_turns, permission_denials
- [ ] permission_denials array is empty or has acceptable count

**ONLY when ALL items checked, proceed to next test.**

---

## IMMEDIATE ACTION - Complete Test Lifecycle

See [references/complete-test-lifecycle.md](references/complete-test-lifecycle.md) for the comprehensive workflow covering all 5 phases from setup to completion.

---

## Expected Discoveries (Per Phase)

The test runner should validate these hypotheses:

### Phase 1: Basic Skill Calling
**Hypothesis**: Win Conditions Enable Chaining
- **Expected**: Completion markers appear, results transfer
- **Impact**: Enables reliable skill workflows

### Phase 2: Forked Skills
**Hypothesis**: Context Isolation is Real
- **Expected**: No access to main context in forks
- **Impact**: Safe to use forking for isolation

### Phase 3: Forked + Subagents
**Hypothesis**: Forked Skills Can Use Subagents
- **Expected**: Subagents accessible from forks
- **Impact**: Complex pipelines possible

### Phase 4: Advanced Patterns
**Hypothesis**: Context Transitions Work
- **Expected**: Forked → Regular restores context
- **Impact**: Flexible workflow patterns

### Phase 5: Context Transfer
**Hypothesis**: Parameters Pass Correctly
- **Expected**: Data flows, boundaries respected
- **Impact**: Data-driven workflows

### Phase 6: Error Handling
**Hypothesis**: Error Handling Works
- **Expected**: Errors propagate, recovery possible
- **Impact**: Robust workflows

### Phase 7: Real-World
**Hypothesis**: Real-World Works
- **Expected**: Practical scenarios succeed
- **Impact**: Production-ready patterns

---

## TaskList Integration Patterns

See [references/tasklist-integration-patterns.md](references/tasklist-integration-patterns.md) for detailed patterns covering lifecycle execution, phase-based testing, hypothesis validation, and retry recovery.

---

## Success Metrics

### Test-Level Success Criteria
- ✅ All completion markers present
- ✅ Context behaves as expected
- ✅ Results transfer correctly
- ✅ No unexpected errors
- ✅ Autonomy score ≥80%

### Phase-Level Success Criteria
- ✅ All tests in phase pass
- ✅ Patterns identified
- ✅ Mental model updated
- ✅ Next phase planned
- ✅ Hypotheses validated

### Framework-Level Success Criteria
- ✅ All phases complete
- ✅ All key questions answered
- ✅ Model validated
- ✅ Patterns documented
- ✅ Best practices established

---

## Key Questions to Validate

The test runner must answer these questions through execution:

### About Win Conditions
1. Do completion markers signal completion?
2. Can skills wait for markers?
3. Do results transfer back?
4. Can skills chain properly?

### About Context
5. Is main context preserved in regular skills?
6. Is main context isolated in forked skills?
7. Can variables pass to forked skills?
8. Can conversation history access?

### About Forking
9. Can forked skills use subagents?
10. Can forked skills call regular skills?
11. Can forked skills call other forked skills?
12. Can multiple forked skills run parallel?

### About Error Handling
13. How do failures propagate?
14. Can errors be recovered?
15. What happens with missing markers?
16. How does timeout work?

### About Real-World Use
17. Do audit workflows work?
18. Do multi-stage analyses work?
19. Can hub-and-spoke patterns work?
20. Can parallel workers combine results?

The test runner should track which questions get answered by each test and ensure comprehensive coverage.

---

## Practical JSON Operations

### Operation 1: Find Next Test
To locate the next test to execute:
- Open the test plan JSON file
- Search for tests where status equals "NOT_STARTED"
- Select the first one in the list
- This is your target test

### Operation 2: Get Test Details
To retrieve a specific test's information:
- Identify the test ID (e.g., "2.3")
- Search the JSON for the test with that ID
- Extract the name, phase, and expected behavior
- Use these details to set up the test environment

### Operation 3: Update Test Status
To mark a test as completed:
- Open the test plan JSON file
- Find the test by its ID
- Change the status field to "COMPLETED"
- Add autonomy score and duration metrics
- Save the updated file

### Operation 4: Count Progress
To track overall progress:
- Count total tests in the plan
- Count completed tests
- Count failed tests
- Calculate remaining tests
- Report the statistics

### Operation 5: Track Lifecycle Stage
To monitor where each test is in the lifecycle:
- Setup: Just created, skills being generated
- Execute: Currently running
- Validate: Being analyzed
- Document: Results being recorded
- Archived: Moved to .attic/

### Operation 6: Update Phase Status
When all tests in a phase complete:
- Mark phase as complete
- Record discoveries found
- Update mental model
- Plan next phase strategy

### Operation 7: Generate Deliverables
Create final documentation:
1. Test Results Document
2. Findings Summary
3. Pattern Catalog
4. Best Practices Guide
5. Anti-Patterns List
6. Updated Mental Model

---

## Complete Workflow (Setup to Deliverables)

See [references/complete-workflow.md](references/complete-workflow.md) for the complete workflow from initial setup through final deliverables, including execution loops and phase reviews.

---

## Comprehensive Error Handling

See [references/comprehensive-error-handling.md](references/comprehensive-error-handling.md) for detailed error scenarios and troubleshooting procedures, including test output analysis and status updates.

---

## Skills Best Practices

See [references/skills-best-practices.md](references/skills-best-practices.md) for best practices including script usage, progressive disclosure, skill composition patterns, and autonomy standards.

## Anti-Patterns

### Execution Anti-Patterns (CRITICAL)
❌ **NEVER**: Use `run_in_background: true` for test execution - causes hangs
❌ **NEVER**: Wrap claude command in `timeout` - use `--max-turns` instead
❌ **NEVER**: Execute without `cd /ABSOLUTE/PATH &&` prefix - wrong working directory
❌ **NEVER**: Redirect output without `2>&1` - loses error information
❌ **NEVER**: Use relative paths - causes location confusion
❌ **NEVER**: Create test folders in /tmp/ - not persistent

### Workflow Anti-Patterns
❌ **NEVER**: Create test runner scripts (run_*.sh, batch_*.sh)
❌ **NEVER**: Run multiple tests in monitoring loops
❌ **NEVER**: Manually edit JSON during autonomous execution

### Positive Patterns (ALWAYS DO)
✅ **ALWAYS**: Execute SYNCHRONONOUSLY with `cd /path && claude ... > output.json 2>&1`
✅ **ALWAYS**: Create ONE folder per test with test_X_X naming
✅ **ALWAYS**: Use absolute paths starting with /
✅ **ALWAYS**: Verify 3-line NDJSON structure after execution
✅ **ALWAYS**: Check permission_denials for autonomy score
✅ **ALWAYS**: Use TaskList for tracking multi-test execution

---

## Helper Scripts Available (For Test Plan Management)

### Script 1: analyze_tools.sh (MANDATORY - Run After EVERY Test)

**Purpose**: Validates test execution, detects real tool usage, scores autonomy

**WHEN to use**:
- ✅ **MANDATORY**: After EVERY test execution (no exceptions)
- ✅ Before migrating logs to raw_logs
- ✅ Before recording results/documentation

**HOW to use**:
```bash
# Run on fresh test output (in test_X_X folder)
bash scripts/analyze_tools.sh \
  /ABSOLUTE/PATH/tests/test_X_X/test-output.json

# Optional: JSON output for automation
bash .../analyze_tools.sh /ABSOLUTE/PATH/tests/test_X_X/test-output.json --json
```

**What it outputs**:
```
## 1. Actual Skill Tool Invocations (Critical)
✅ **VERIFIED**: Found actual Skill tool invocations

## 2. Tool Result Verification (Success Check)
✅ test-skill - SUCCESS (ID: call_function_...)
**Summary:** 1/1 skills succeeded

## 3-7. [Additional verification sections...]

## Final Verification Summary
✅ **PASS**: All 1 skills successfully invoked via Skill tool
```

**Key metrics to record**:
- Verdict (PASS/FAIL/PARTIAL)
- Autonomy score (0-100%)
- Permission denials count
- Duration in ms
- Turn count

---

### Script 2: test_runner_helper.sh (OPTIONAL - For Complex JSON Operations)

**Purpose**: JSON test plan parsing, batch operations, lifecycle tracking

**WHEN to use**:
- ✅ When you need to find the next NOT_STARTED test
- ✅ When updating JSON test plan status
- ✅ When tracking lifecycle stages
- ✅ When doing batch operations on multiple tests
- ❌ NOT needed for single test execution (use jq directly instead)

**HOW to use**:
```bash
# Find next test to run
uv run scripts/test_runner_helper.py find-next

# Update test status in JSON
uv run scripts/test_runner_helper.py update-status "2.3" "COMPLETED" "100" "5432"

# Show overall progress
uv run scripts/test_runner_helper.py progress

# Other commands (less common):
# lifecycle-stage <test_id> <stage>
# phase-complete <phase_number>
# add-finding <test_id> <finding>
```

**When NOT to use**:
- ❌ For simple test execution (not needed)
- ❌ For basic JSON queries (use `jq` directly)
- ❌ When TaskList tracking is sufficient

---

### Summary: Script Usage Decision Tree

```
After test execution?
├─ YES → Run analyze_tools.sh (MANDATORY)
│         ├─ Verdict PASS/PARTIAL? → Migrate to raw_logs
│         └─ Verdict FAIL? → Keep in test_X_X, re-execute
└─ NO → Don't run yet

Need to update JSON test plan?
├─ Complex batch operation? → test_runner_helper.sh (OPTIONAL)
├─ Simple status update? → Use jq directly
└─ Using TaskList? → Skip JSON operations
```

---

## Summary

The test-runner skill provides a complete testing framework for validating skill calling, context handling, and forking behavior using non-interactive CLI mode.

**Complete Lifecycle Coverage**:
- **Setup**: Pre-flight checklist, folder structure, skill generation
- **Execute**: CLI testing with mandatory flags, NDJSON capture to `test_X_X/test-output.json`
- **Validate**: Run `analyze_tools.sh`, structure check, autonomy scoring
- **Archive**: Migrate to `raw_logs/phase_X/test_X_Y.description.json` AFTER validation
- **Cleanup**: Remove test_X_X folder after successful migration
- **Document**: Status updates, progress tracking, finding recording
- **Deliverables**: Comprehensive documentation and pattern catalog

**Key Requirements**:
- Stream-JSON NDJSON output (exactly 3 lines)
- Autonomy scoring (aim for ≥80%, best 100%)
- Win condition markers (## COMPLETE)
- TaskList orchestration for all phases
- Absolute paths (no relative or /tmp/)
- One folder per test for isolation

**Time Management** (per README):
- Single test: ~25 minutes (setup 10 + execute 5-10 + validate 5 + document 5)
- Phase 1 (Basic Calling): ~30 minutes (2 tests)
- Phase 2 (Forked Skills): ~45 minutes (3 tests)
- Phase 3 (Forked + Subagents): ~45 minutes (2 tests)
- Phase 4 (Advanced Patterns): ~60 minutes (3 tests)
- Phase 5 (Context Transfer): ~30 minutes (2 tests)
- Phase 6 (Error Handling): ~30 minutes (2 tests)
- Phase 7 (Real-World): ~60 minutes (2 tests)
- **Total Duration**: ~5 hours for complete framework

**Success Criteria**:
- Test-Level: All markers present, context correct, no errors
- Phase-Level: All tests pass, patterns identified, mental model updated
- Framework-Level: All phases complete, all questions answered, patterns documented

**Deliverables**:
1. Test Results Document (all outputs)
2. Findings Summary (key discoveries)
3. Pattern Catalog (validated patterns)
4. Best Practices (how to use skills)
5. Anti-Patterns (what to avoid)
6. Mental Model (updated understanding)

---

## References

### Core Functionality

1. **[references/json-management.md](references/json-management.md)** - JSON read/write operations, test discovery, status tracking
2. **[references/analysis-engine.md](references/analysis-engine.md)** - Built-in analysis logic (NDJSON parsing, autonomy scoring, pattern detection)
3. **[references/script-integration.md](references/script-integration.md)** - Script leveraging, dynamic context injection, dual output modes

### Testing Framework

3. **[references/cli-flags.md](references/cli-flags.md)** - All CLI flags, safety limits
4. **[references/execution-patterns.md](references/execution-patterns.md)** - Pre-configured test patterns
5. **[references/autonomy-testing.md](references/autonomy-testing.md)** - Autonomy scoring and patterns
6. **[references/test-framework.md](references/test-framework.md)** - Testing framework guide

### Analysis & Verification

7. **[references/verification.md](references/verification.md)** - Log analysis and verification
8. **[references/hallucination-detection.md](references/hallucination-detection.md)** - Real vs synthetic execution
9. **[references/troubleshooting.md](references/troubleshooting.md)** - Real-time monitoring, diagnosis

### Documentation

10. **[references/test-suite.md](references/test-suite.md)** - Master test suite structure

---

## Max-Turns Guidelines

| Test Type | --max-turns |
|-----------|-------------|
| Single skill | 10 |
| Skill chain (2-3) | 20 |
| Forked skills | 15 |
| Parallel execution | 25 |
| Complex pipeline | 50+ |
