# Complete Test Lifecycle

This reference covers the comprehensive workflow for executing tests from setup to completion.

## IMMEDIATE ACTION - Complete Test Lifecycle

When invoked with "Execute all remaining tests", follow this comprehensive lifecycle:

### PHASE 1: Setup (Before Each Test)

**Pre-Flight Checklist (CRITICAL)**:
- [ ] Test folder created at absolute path
- [ ] Test skills created in .claude/skills/
- [ ] Skills have correct YAML frontmatter
- [ ] Win condition markers defined (## COMPLETE)
- [ ] test-output.json will be saved in test folder
- [ ] Absolute paths used (no /tmp/, no relative paths)
- [ ] cd only used to set working directory (not for navigation)

**What to do**:
1. Read test plan JSON to find next NOT_STARTED test
2. Create TaskList entry for this test
3. Create test folder with absolute path structure
4. Generate skill files from test specification
5. Verify all prerequisites are met

### PHASE 2: Execute (Run Test)

**Mandatory CLI Flags** (ALWAYS use these):
- --dangerously-skip-permissions (auto-approve prompts)
- --output-format stream-json (NDJSON output)
- --verbose --debug (debug visibility)
- --no-session-persistence (don't save sessions)
- --max-turns N (limit conversation rounds)

**What to do**:
1. Set max-turns based on test complexity:
   - Single skill: 10 turns
   - Skill chain: 20 turns
   - Forked skills: 15 turns
   - Parallel execution: 25 turns
   - Complex pipeline: 50+ turns
2. Execute test with proper flags
3. Capture output to test-output.json

### PHASE 3: Validate (Verify Results)

**NDJSON Structure Check** (MUST have exactly 3 lines):
- [ ] Line 1: System init with skills array
- [ ] Line 2: Assistant message with completion markers
- [ ] Line 3: Result with num_turns, permission_denials

**Autonomy Score Check**:
- [ ] Count permission_denials array
- [ ] 0 denials = 100% autonomy (Excellent)
- [ ] 1-3 denials = 85-95% autonomy (Good)
- [ ] 4-5 denials = 75-80% autonomy (Acceptable)
- [ ] 6+ denials = <80% autonomy (Fail)

**Win Condition Verification**:
- [ ] All completion markers present (## COMPLETE)
- [ ] num_turns reasonable (not infinite loop)
- [ ] duration_ms acceptable
- [ ] No unexpected errors

**What to do**:
1. Verify NDJSON structure
2. Calculate autonomy score
3. Check completion markers
4. Validate against test expectations
5. Mark test as PASS/FAIL in TaskList

### PHASE 4: Document (Record & Archive)

**Test-Level Documentation**:
- [ ] Update test plan status (NOT_STARTED → COMPLETED/FAILED)
- [ ] Record autonomy score and duration
- [ ] Add completion timestamp
- [ ] Note any observations

**Archive Workflow**:
- If PASS: Move test folder to .attic/test_[id]_success
- If FAIL: Keep for analysis, then delete after review
- Update overall test progress statistics

**Phase Completion** (after all tests in phase):
- [ ] Review all test results
- [ ] Identify patterns
- [ ] Update mental model
- [ ] Plan next phase

### PHASE 5: Repeat or Complete

**Find Next Test**:
- Scan test plan for next NOT_STARTED test
- If found, return to PHASE 1
- If all complete, proceed to framework-level summary

**Framework Completion**:
- [ ] All phases complete
- [ ] All questions answered
- [ ] Model validated
- [ ] Patterns documented

**Deliverables**:
1. Test Results Document (all test outputs)
2. Findings Summary (key discoveries)
3. Pattern Catalog (validated patterns)
4. Mental Model (updated understanding)
5. Best Practices (how to use skills)
6. Anti-Patterns (what to avoid)
