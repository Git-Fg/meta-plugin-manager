# Test Framework Guide

Complete testing framework for validating skill calling, context handling, and forking behavior using **non-interactive CLI testing** with print mode (`-p`) and `stream-json` output format.

## Core Principles

- ✅ Non-interactive execution (autonomous skills)
- ✅ Stream-JSON NDJSON output (3-line format)
- ✅ Absolute paths (no /tmp/, no relative paths)
- ✅ One folder per test (isolation)
- ✅ Autonomy scoring (permission_denials)
- ✅ Win condition markers (## COMPLETE)

## NDJSON Output Format (3 Lines)

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
- [ ] Test folder created with absolute path
- [ ] Test skills created in `.claude/skills/`
- [ ] Skills have correct YAML frontmatter
- [ ] Win condition markers defined (## COMPLETE)
- [ ] test-output.json will be saved in test folder
- [ ] You will analyze the log using test-runner (then read manually if needed)
- [ ] Absolute paths used (no /tmp/, no relative paths)
- [ ] cd only used to set working directory (not for navigation)

**ONLY after checklist complete, proceed to execution.**

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
- [ ] Call test-runner to analyze test-output.json
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

## Win Condition Markers

All transitive skills MUST output completion markers:
- `## SKILL_B_COMPLETE`
- `## SKILL_A_COMPLETE`
- `## FORKED_SKILL_COMPLETE`

**Purpose**: Signal completion to calling skill

## Testing Patterns

### Basic Skill Calling
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

## Archive Successful Tests

**After successful test completion**:
```bash
# Move to .attic/ for reference
mv /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name \
   /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/.attic/test_name_success

# Failed tests can be deleted after analysis
rm -rf /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/test_name
```

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

## MANDATORY ANALYSIS WORKFLOW

**ABSOLUTE CONSTRAINT**: You must analyze ALL log files to verify test success. **MANDATORY WORKFLOW**:
1. **First**: Call the `test-runner` skill to automate pattern detection
2. **Then**: Read the full log manually if the analyzer output is unclear
3. Watch for synthetic skill use (hallucinated) vs. real tool/task/skill use

**Core Principle**: Always verify real execution vs hallucination.
