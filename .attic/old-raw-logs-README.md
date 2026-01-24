# Raw Test Logs Archive

**Purpose**: Complete archive of all test execution logs in NDJSON format
**Total Tests**: 14
**Execution Date**: 2026-01-23
**Methodology**: Non-interactive CLI testing with stream-json output

---

## Directory Structure

```
raw_logs/
├── README.md (this file)
├── phase_1/         # Basic skill calling tests
├── phase_2/          # Forked skills and context isolation tests
├── phase_3/          # Forked skills with subagents
├── phase_4/          # Advanced forked patterns
├── phase_5/          # Context transfer tests
├── phase_6/          # Complex layered orchestration
└── phase_7/          # Subagent capabilities
```

---

## Test Index

### Phase 1: Basic Skill Calling (2 tests)

| Test | Filename | Status | Key Finding |
|------|----------|--------|-------------|
| 1.1 | `test_1_1_basic_skill_calling.json` | ✅ PASS | Skills can call other skills |
| 1.2 | `test_1_2_three_skill_chain.json` | ⚠️ NEEDS REFINEMENT | Chain implementation |

### Phase 2: Forked Skills & Context Isolation (6 tests)

| Test | Filename | Status | Key Finding |
|------|----------|--------|-------------|
| 2.2 | `test_2_2_context_isolation.json` | ✅ PASS | Context variables blocked |
| 2.3 | `test_2_3_forked_autonomy.json` | ✅ PASS | Forked skills autonomous |
| 2.4 | `test_2_4_standard_fork_secret_check_FAILED.json` | ❌ FAILED | **Standard forks LEAK context** |
| 2.5 | `test_2_5_explore_agent_secret_check.json` | ✅ PASS | Explore agent maintains isolation |
| 2.6 | `test_2_6_custom_subagent_secret_check.json` | ✅ PASS | Custom subagent maintains isolation |

**🚨 CRITICAL**: Test 2.4 reveals that standard `context: fork` does NOT provide context isolation. Secrets leak to forked skills.

### Phase 3: Forked Skills with Subagents (1 test)

| Test | Filename | Status | Key Finding |
|------|----------|--------|-------------|
| 3.2 | `test_3_2_forked_with_custom_subagents.json` | ✅ PASS | Forked skills can use subagents |

### Phase 4: Advanced Forked Patterns (2 tests)

| Test | Filename | Status | Key Finding |
|------|----------|--------|-------------|
| 4.2 | `test_4_2_double_fork.json` | ✅ PASS | Forked→forked works |
| 4.3 | `test_4_3_parallel_forked_FAILED.json` | ❌ FAILED | Parallel execution needs explicit orchestration |

### Phase 5: Context Transfer (1 test)

| Test | Filename | Status | Key Finding |
|------|----------|--------|-------------|
| 5.1 | `test_5_1_parameter_passing.json` | ✅ PASS | Parameters can pass to forked |

### Phase 6: Complex Layered Orchestration (2 tests)

| Test | Filename | Status | Key Finding |
|------|----------|--------|-------------|
| 6.1 | `test_6_1_three_layer_hierarchy.json` | ⚠️ NEEDS REFINEMENT | Hierarchical orchestration |
| 6.2 | `test_6_2_parallel_workers.json` | ⚠️ NEEDS REFINEMENT | Parallel worker coordination |

### Phase 7: Subagent Capabilities (1 test)

| Test | Filename | Status | Key Finding |
|------|----------|--------|-------------|
| 7.1 | `test_7_1_subagent_skill_injection.json` | ✅ PASS | **Hub-and-spoke confirmed** |

---

## NDJSON Format

Each test log contains exactly **3 lines** of NDJSON:

**Line 1**: System initialization
```json
{"type":"system","subtype":"init","cwd":"...","tools":[...],"skills":[...],"agents":[...]}
```

**Line 2**: Assistant message
```json
{"type":"assistant","content":[{"type":"text","text":"..."}]}
```

**Line 3**: Result summary
```json
{"type":"result","result":{"num_turns":10,"duration_ms":5000,"permission_denials":[]}}
```

---

## Key Metrics

### Autonomy Scores
All tests achieved **100% autonomy** (0 permission denials):
- Zero questions asked
- Perfect non-interactive execution
- Autonomous skill completion

### Success Rate
- **✅ PASSED**: 9/14 (64%)
- **❌ FAILED**: 2/14 (14%)
- **⚠️ NEEDS REFINEMENT**: 3/14 (22%)

### Duration Analysis
- Fastest: ~13 seconds (test_1_1)
- Slowest: ~99 seconds (test_2_5)
- Average: ~45 seconds

---

## Critical Discoveries

### 🚨 Context Isolation Failure
**Test**: `test_2_4_standard_fork_secret_check_FAILED.json`
**Finding**: Standard `context: fork` does NOT isolate context
**Evidence**: Secret "BLUE_BANANA" leaked to forked skill

**Implication**: Cannot use standard forked skills for security/isolation

### ✅ Agent-Based Isolation
**Tests**: `test_2_5_explore_agent_secret_check.json`, `test_2_6_custom_subagent_secret_check.json`
**Finding**: Forked skills WITH agents maintain isolation
**Evidence**: Both correctly returned "UNKNOWN"

**Implication**: Must use `context: fork` + `agent: Explore` (or custom agent) for true isolation

### ✅ Hub-and-Spoke Architecture
**Test**: `test_7_1_subagent_skill_injection.json`
**Finding**: Skills can be equipped with agents that have injected skills
**Evidence**: Both EQUIPPED_COMPLETE and UTILITY_USED markers present

**Implication**: Modular, composable workflows confirmed working

---

## Usage

### View a Specific Test Log
```bash
# Example: View Test 2.4 (the critical failure)
cat /tests/raw_logs/phase_2/test_2_4_standard_fork_secret_check_FAILED.json | jq .

# View key result fields
cat /tests/raw_logs/phase_2/test_2_4_standard_fork_secret_check_FAILED.json | tail -1 | jq '.result.permission_denials, .result.num_turns'
```

### Verify Autonomy Score
```bash
# Check permission_denials (should be empty array for 100% autonomy)
grep '"permission_denials": \[\]' /tests/raw_logs/phase_2/test_2_5_explore_agent_secret_check.json
```

### Check Win Condition Markers
```bash
# Look for completion markers in assistant message
grep "COMPLETE" /tests/raw_logs/phase_7/test_7_1_subagent_skill_injection.json
```

---

## Test Execution Summary

**Complete execution report**: See `/attic/TEST_EXECUTION_SUMMARY.md`

---

**Archive Created**: 2026-01-23
**Total Logs**: 14 test execution logs
**Format**: NDJSON (3 lines per test)
**Status**: Complete archive of all skill testing phases
