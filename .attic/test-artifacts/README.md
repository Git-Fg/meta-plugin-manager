# Skill Testing Framework - Non-Interactive CLI Mode

## Overview

Complete testing framework for validating skill calling, context handling, and forking behavior using **non-interactive CLI testing** with print mode (`-p`) and `stream-json` output format.

ABSOLUTE CONSTRAINT: You must analyze ALL log files to verify test success. **MANDATORY WORKFLOW**:
1. **First**: Call the `tool-analyzer` skill to automate pattern detection
2. **Then**: Read the full log manually if the analyzer output is unclear
3. Watch for synthetic skill use (hallucinated) vs. real tool/task/skill use

**Core Principles**:
- ✅ Non-interactive execution (autonomous skills)
- ✅ Stream-JSON NDJSON output (3-line format)
- ✅ Absolute paths (no /tmp/, no relative paths)
- ✅ One folder per test (isolation)
- ✅ Autonomy scoring (permission_denials)
- ✅ Win condition markers (## COMPLETE)

## Testing Workflow

### Step 1: Review Framework
```bash
cat /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/README.md
cat /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/skill_test_plan.json | jq '.test_plan.phases[0]'
cat /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/execution/quick_reference.md
```

### Step 2: Start Testing (Phase 1, Test 1.1)
```bash
# Create test directory with absolute path
mkdir -p /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1/.claude/skills/skill-b
mkdir -p /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1/.claude/skills/skill-a

# Create skills with completion markers
cat > /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1/.claude/skills/skill-b/SKILL.md << 'EOF'
---
name: skill-b
description: "Simple transitive skill for testing"
---

## SKILL_B_COMPLETE

Processing completed successfully.
EOF

# Execute with non-interactive flags (MANDATORY)
cd /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1 && \
claude --dangerously-skip-permissions -p "Call skill-a" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 10 \
  > /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1/test-output.json 2>&1

# Verify NDJSON structure (3 lines)
[ "$(wc -l < /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_1_1/test-output.json)" -eq 3 ] && echo "✅ NDJSON OK"
```

### Step 3: Progress Through Phases
```bash
# Complete Phase 1 (2 tests)
# Move to Phase 2 (3 tests) - Forked skills testing
# Continue through Phase 7
# Document results at each step
# Archive to .attic/ after completion
```

## Core Concepts

### NDJSON Output Format (3 Lines)
Every test produces exactly 3 lines of NDJSON:

**Line 1: System Initialization**
```json
{"type":"system","subtype":"init","tools":[...],"skills":[...],"agents":[...]}
```
- Verifies skills loaded
- Shows available tools

**Line 2: Assistant Message**
```json
{"type":"assistant","content":[{"type":"text","text":"..."}]}
```
- Contains skill execution output
- Includes completion markers (## SKILL_COMPLETE)

**Line 3: Result Summary**
```json
{"type":"result","result":{"num_turns":10,"duration_ms":5000,"permission_denials":[]}}
```
- `permission_denials`: Autonomy score (empty = 100%)
- `num_turns`: Conversation rounds
- `duration_ms`: Execution time

### Autonomy Scoring
| Permission Denials | Autonomy Score | Grade |
|-------------------|---------------|-------|
| 0 | 100% | A+ |
| 1 | 95% | A |
| 2-3 | 85-90% | B |
| 4-5 | 75-80% | C |
| 6+ | <75% | FAIL |

**Verification**: `grep '"permission_denials": \[\]' test-output.json`

### Win Condition Markers
All transitive skills MUST output completion markers:
- `## SKILL_B_COMPLETE`
- `## SKILL_A_COMPLETE`
- `## FORKED_SKILL_COMPLETE`

**Purpose**: Signal completion to calling skill

## Test Phases

### Phase 1: Basic Skill Calling (2 tests)
**Goal**: Verify skills can call other skills
**Focus**: Win conditions, context preservation
**Duration**: ~30 minutes

### Phase 2: Forked Skills (3 tests)
**Goal**: Test context: fork behavior
**Focus**: Isolation, autonomy, Explore tools
**Duration**: ~45 minutes

### Phase 3: Forked + Subagents (2 tests)
**Goal**: Test subagent access from forks
**Focus**: Tool availability, execution
**Duration**: ~45 minutes

### Phase 4: Advanced Patterns (3 tests)
**Goal**: Test complex interactions
**Focus**: Nested forking, parallel execution
**Duration**: ~60 minutes

### Phase 5: Context Transfer (2 tests)
**Goal**: Test parameter passing
**Focus**: Data flow, boundaries
**Duration**: ~30 minutes

### Phase 6: Error Handling (2 tests)
**Goal**: Test failure scenarios
**Focus**: Error propagation, recovery
**Duration**: ~30 minutes

### Phase 7: Real-World (2 tests)
**Goal**: Test practical scenarios
**Focus**: Audit workflows, pipelines
**Duration**: ~60 minutes

**Total Duration**: ~5 hours

## Mandatory CLI Flags (Non-Interactive Testing)

**ALWAYS use these flags for every test**:
```bash
--dangerously-skip-permissions    # Auto-approve prompts
--output-format stream-json        # NDJSON output (3 lines)
--verbose --debug                 # Debug visibility
--no-session-persistence          # Don't save sessions
--max-turns N                     # Limit conversation rounds
```

**Example**:
```bash
claude --dangerously-skip-permissions -p "Call skill-name" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns 10 \
  > test-output.json 2>&1
```

## Pre-Flight Checklist (CRITICAL)

**Before EVERY test, verify**:
- [ ] Test folder created at `/Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name/`
- [ ] Test skills created in `.claude/skills/`
- [ ] Skills have correct YAML frontmatter
- [ ] Win condition markers defined (## COMPLETE)
- [ ] test-output.json will be saved in test folder
- [ ] You will analyze the log using tool-analyzer skill (then read manually if needed)
- [ ] Absolute paths used (no /tmp/, no relative paths)
- [ ] cd only used to set working directory (not for navigation)

**ONLY after checklist complete, proceed to execution.**

## Key Questions to Answer

### About Win Conditions
1. Do completion markers signal completion?
2. Can skills wait for markers?
3. Do results transfer back?
4. Can skills chain?

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

## Testing Workflow

### For Each Test

**Setup** (10 minutes):
- [ ] Create skill files
- [ ] Define win conditions
- [ ] Set calling relationships
- [ ] Prepare test data

**Execute** (5-10 minutes):
- [ ] Call skill
- [ ] Capture output
- [ ] Verify markers
- [ ] Check context

**Validate** (5 minutes):
- [ ] Call tool-analyzer skill to analyze test-output.json
- [ ] Results match expected
- [ ] Context behaves correctly
- [ ] No unexpected errors

**Document** (5 minutes):
- [ ] Fill template
- [ ] Note observations
- [ ] Update findings
- [ ] Plan next test

**Total**: ~25 minutes per test

### Phase Completion

After each phase:
- [ ] Review all test results
- [ ] Identify patterns
- [ ] Update mental model
- [ ] Adjust expectations
- [ ] Plan next phase

## Expected Discoveries

### Hypothesis 1: Win Conditions Enable Chaining
**Test**: Phase 1, Tests 1.1-1.2
**Expect**: Markers appear, results transfer
**Impact**: Enables reliable skill workflows

### Hypothesis 2: Context Isolation is Real
**Test**: Phase 2, Tests 2.1-2.3
**Expect**: No access to main context in forks
**Impact**: Safe to use forking for isolation

### Hypothesis 3: Forked Skills Can Use Subagents
**Test**: Phase 3, Tests 3.1-3.2
**Expect**: Subagents accessible from forks
**Impact**: Complex pipelines possible

### Hypothesis 4: Context Transitions Work
**Test**: Phase 4, Tests 4.1-4.3
**Expect**: Forked → Regular restores context
**Impact**: Flexible workflow patterns

### Hypothesis 5: Parallel Execution Works
**Test**: Phase 4, Test 4.3
**Expect**: Multiple forks run parallel
**Impact**: Performance optimization

### Hypothesis 6: Parameters Pass Correctly
**Test**: Phase 5, Tests 5.1-5.2
**Expect**: Data flows, boundaries respected
**Impact**: Data-driven workflows

### Hypothesis 7: Error Handling Works
**Test**: Phase 6, Tests 6.1-6.2
**Expect**: Errors propagate, recovery possible
**Impact**: Robust workflows

### Hypothesis 8: Real-World Works
**Test**: Phase 7, Tests 7.1-7.2
**Expect**: Practical scenarios succeed
**Impact**: Production-ready patterns

## Success Metrics

### Test-Level Success
- ✅ All markers appear
- ✅ Context behaves as expected
- ✅ Results transfer correctly
- ✅ No unexpected errors

### Phase-Level Success
- ✅ All tests pass
- ✅ Patterns identified
- ✅ Mental model updated
- ✅ Next phase planned

### Framework-Level Success
- ✅ All phases complete
- ✅ All questions answered
- ✅ Model validated
- ✅ Patterns documented

## Deliverables

After testing:
1. **Test Results Document** - All test outputs
2. **Findings Summary** - Key discoveries
3. **Pattern Catalog** - Validated patterns
4. **Mental Model** - Updated understanding
5. **Best Practices** - How to use skills
6. **Anti-Patterns** - What to avoid

## Next Steps After Testing

### Immediate (Day 1)
- Complete all 20 tests
- Document all findings
- Identify patterns
- Update mental model

### Short-term (Week 1)
- Apply findings to real projects
- Build actual workflows
- Refine skill architecture
- Update documentation

### Long-term (Month 1)
- Use validated patterns
- Avoid discovered anti-patterns
- Share findings
- Iterate based on use

## Verification Checklist

**After each test, verify in test-output.json**:

### NDJSON Structure
- [ ] **3 lines present** - Check with `wc -l test-output.json`
- [ ] **Line 1**: System init with skills array
- [ ] **Line 2**: Assistant message with completion markers
- [ ] **Line 3**: Result with num_turns, permission_denials

### Autonomy Score
- [ ] **permission_denials is empty** - `grep '"permission_denials": \[\]'`
- [ ] **0 = 100% autonomy** (Excellent)
- [ ] **1-3 = 85-95% autonomy** (Good)
- [ ] **4+ = <80% autonomy** (Needs improvement)

### Test Results
- [ ] **All completion markers present** - `grep "COMPLETE"`
- [ ] **num_turns reasonable** (not infinite loop)
- [ ] **duration_ms acceptable**
- [ ] **No unexpected errors**

## Archive Successful Tests

**After successful test completion**:
```bash
# Move to .attic/ for reference
mv /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name \
   /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/.attic/test_name_success

# Failed tests can be deleted after analysis
rm -rf /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name
```

## Files Location

All in `/Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/`:
```
tests/
├── README.md                           # This file
├── skill_test_plan.json                # Test specifications
├── execution/
│   ├── EXECUTION_STEPS.md              # Step-by-step guide
│   └── quick_reference.md              # Quick reference
├── frameworks/
│   ├── AUTONOMY_TESTING_FRAMEWORK.md    # Autonomy testing guide
│   ├── AUTONOMY_QUICK_REFERENCE.md     # Autonomy quick ref
│   └── AUTONOMY_TEST_EXAMPLE.md        # Autonomy examples
├── reference/
│   ├── subagent_config_test.md         # Subagent testing
│   └── test_implementation_guide.md    # Implementation guide
└── results/
    ├── TEST_RESULTS.md                 # Test results
    ├── FINAL_TEST_COMPLETION_REPORT.md # Completion report
    └── REMAINING_TESTS_PROGRESS.md     # Progress tracking
```

## Ready to Begin

Everything is prepared. Start with:
```bash
# Review the test plan
cat /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/skill_test_plan.json | jq '.test_plan.phases[0]'

# Begin Phase 1, Test 1.1
# Create skill-b and skill-a in /tests/test_1_1/
# Execute with non-interactive flags
# Verify NDJSON structure and autonomy
```

**Goal**: Empirically understand skill interactions, context handling, and forking behavior using non-interactive CLI testing.
```