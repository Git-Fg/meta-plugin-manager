# Merge Plan: CLI Testing Skills Unification

## Executive Summary

Merge `claude-cli-non-interactive` and `tool-analyzer` into a unified testing skill, then extract hardcoded logic from `tests/` folder into the merged skill's references.

**Goal**: Single cohesive skill that handles test execution, analysis, and reporting with embedded knowledge from test framework documentation.

---

## Phase 1: Skills Merger (claude-cli-non-interactive + tool-analyzer)

### Current State Analysis

| Skill | Purpose | Lines | References | Scripts |
|-------|---------|-------|------------|---------|
| `claude-cli-non-interactive` | Test execution workflow | ~400 | 6 files | None |
| `tool-analyzer` | Log analysis & reporting | ~190 | None | 1 script (analyze_tools.sh) |

**Overlap Analysis**:
- **Execution**: claude-cli-non-interactive handles test setup, execution, cleanup
- **Analysis**: tool-analyzer handles log parsing, pattern detection, reporting
- **Integration**: claude-cli-non-interactive **calls** tool-analyzer for verification
- **No duplication** - complementary workflows

### Proposed Structure: `test-runner` Skill

```
.claude/skills/test-runner/
├── SKILL.md                    # Main orchestration skill (~300 lines)
├── references/
│   ├── cli-flags.md            # From claude-cli-non-interactive
│   ├── execution-patterns.md   # From claude-cli-non-interactive/patterns.md
│   ├── autonomy-testing.md     # Merged: autonomy-scoring + autonomy-patterns
│   ├── verification.md         # From tool-analyzer (embedded logic)
│   ├── troubleshooting.md      # From claude-cli-non-interactive
│   ├── hallucination-detection.md
│   └── test-framework.md       # NEW: Extracted from tests/README.md
└── scripts/
    └── analyze_tools.sh        # From tool-analyzer (with TaskList detection)
```

### SKILL.md Structure

```yaml
---
name: test-runner
description: "Unified CLI testing workflow - execute skills/plugins/subagents tests with stream-json output, automated analysis, and comprehensive reporting"
user-invocable: true
---

# Test Runner

## Usage

**Single Test Execution**:
```
test-runner "Execute skill-name" /path/to/test/folder
```

**Batch Test Suite**:
```
test-runner "Run phase 2 tests" /path/to/tests/raw_logs/phase_2/
```

**Analysis Only**:
```
test-runner "Analyze" /path/to/test-output.json
```

## Win Condition

```markdown
## TEST_RUNNER_COMPLETE

Workflow: [execution|analysis|suite]
Tests: [count]
Passed: [count]
Failed: [count]
Autonomy: [score]%
Duration: [ms]
```

---

## Mode Selection (Implicit)

The skill detects intent from input:

1. **Execution Mode**: "Execute [skill]..." or "Run [test]..."
   - Follows full testing workflow (setup → execute → analyze → cleanup)

2. **Analysis Mode**: File path provided, "analyze" keyword
   - Calls analyze_tools.sh, parses results, reports findings

3. **Suite Mode**: Directory path with multiple tests
   - Batch processes all JSON files, aggregates results

---

## Workflow: Execution Mode

### Step 1: Pre-flight Checklist
- [ ] Test folder exists at path
- [ ] Test skills/agents created with correct YAML
- [ ] Win condition markers defined
- [ ] Absolute paths used (no /tmp/)

### Step 2: Execute Test
```bash
cd <test_folder> && claude --dangerously-skip-permissions -p "<prompt>" \
  --output-format stream-json --verbose --debug \
  --no-session-persistence --max-turns <N> \
  > <test_folder>/test-output.json 2>&1
```

### Step 3: Analyze Output
- Call analyze_tools.sh (embedded script)
- Parse verification results
- Check autonomy score (permission_denials)
- Verify completion markers

### Step 4: Report & Cleanup
- Generate comprehensive report
- Archive to .attic/ or delete

---

## Workflow: Analysis Mode

Calls embedded `analyze_tools.sh` script with:

**Detection Categories**:
1. Skill tool invocations (Skill tool calls)
2. Forked skill executions (status: forked)
3. Agent usage (agentId tracking)
4. TaskList tools (TaskCreate, TaskUpdate, TaskGet, TaskList) ← NEW
5. Execution flow (tool_use/tool_result counts)
6. Anti-hallucination checks
7. Completion markers
8. Final verdict (PASS/FAIL/PARTIAL)

---

## Workflow: Suite Mode

1. Discover all JSON files in directory
2. Process each file with analyze_tools.sh
3. Aggregate results across all tests
4. Generate comprehensive report:
   - Per-test results
   - Phase-by-phase breakdown
   - Autonomy scores
   - Hallucination detection
   - Total passed/failed

---

## Max-Turns Guidelines

| Test Type | --max-turns |
|-----------|-------------|
| Single skill | 10 |
| Skill chain (2-3) | 20 |
| Forked skills | 15 |
| Parallel execution | 25 |
| Complex pipeline | 50+ |

---

## See References

- [references/cli-flags.md](references/cli-flags.md) - All CLI flags
- [references/execution-patterns.md](references/execution-patterns.md) - Test patterns
- [references/autonomy-testing.md](references/autonomy-testing.md) - Autonomy scoring
- [references/verification.md](references/verification.md) - Verification logic
- [references/troubleshooting.md](references/troubleshooting.md) - Failure diagnosis
- [references/hallucination-detection.md](references/hallucination-detection.md) - Real vs synthetic
- [references/test-framework.md](references/test-framework.md) - Framework concepts
```

---

## Phase 2: Extract Hardcoded Logic from tests/

### Source: tests/README.md (~420 lines)

Extract to `references/test-framework.md`:

| Section (README.md) | Target (test-framework.md) | Content |
|---------------------|---------------------------|---------|
| Core Concepts | Framework Foundations | NDJSON format, autonomy scoring, win conditions |
| Test Phases | Phase Catalog | All 7 phases with duration estimates |
| Mandatory CLI Flags | CLI Reference | Flag table with purposes |
| Pre-Flight Checklist | Pre-Flight | Complete checklist |
| Testing Workflow | Test Lifecycle | Setup → Execute → Validate → Document |
| Expected Discoveries | Test Hypotheses | 8 hypotheses with validation criteria |
| Verification Checklist | Post-Test Verification | NDJSON, autonomy, results verification |
| Success Metrics | Quality Gates | Test/Phase/Framework level metrics |

### Source: tests/skill_test_plan.json

Create `references/test-suite.md` with:
- Phase structure (11 phases)
- Test catalog (67 tests)
- Expected outcomes per test
- Evidence file mapping

### Source: tests/raw_logs/

Keep as-is (test data), but skill should reference this structure:
```
tests/raw_logs/
├── phase_1/           # Basic skill calling
├── phase_2/           # Forked skills
├── phase_3/           # Forked + subagents
├── phase_4/           # Advanced patterns
├── phase_5/           # Context transfer
├── phase_6/           # Error handling
├── phase_7/           # Real-world scenarios
└── phase_11/          # TaskList integration (NEW)
```

---

## Phase 3: Migration Path

### Step 1: Create New Skill Structure

```bash
mkdir -p .claude/skills/test-runner/references
mkdir -p .claude/skills/test-runner/scripts
```

### Step 2: Merge Content

**Action Table**:

| Source | Destination | Action |
|--------|-------------|--------|
| claude-cli-non-interactive/SKILL.md | test-runner/SKILL.md | Merge (keep execution, add analysis) |
| tool-analyzer/SKILL.md | test-runner/SKILL.md | Merge (keep detection logic) |
| claude-cli-non-interactive/references/* | test-runner/references/ | Copy all |
| tool-analyzer/scripts/analyze_tools.sh | test-runner/scripts/ | Copy (with TaskList fix) |
| tests/README.md | test-runner/references/test-framework.md | Extract & refactor |
| tests/skill_test_plan.json | test-runner/references/test-suite.md | Extract structure |

### Step 3: Deprecate Old Skills

```bash
# Archive old skills
mv .claude/skills/claude-cli-non-interactive .attic/
mv .claude/skills/tool-analyzer .attic/
```

### Step 4: Update Documentation

Update CLAUDE.md and anti-patterns.md to reference `test-runner` instead of separate skills.

---

## Phase 4: Validation

### Test Plan

1. **Single Test Execution**: Run existing test with new skill
2. **Analysis Mode**: Verify analyze_tools.sh integration
3. **Suite Mode**: Process entire phase_2/ directory
4. **Backward Compatibility**: Verify old test patterns still work

### Success Criteria

- [ ] All existing tests pass with new skill
- [ ] analyze_tools.sh detects all tool types (Skill, Forked, Agent, TaskList)
- [ ] Suite mode produces aggregate reports
- [ ] References < 500 lines each (progressive disclosure)
- [ ] No hardcoded bash patterns in SKILL.md

---

## File Inventory

### Files to Create

```
.claude/skills/test-runner/
├── SKILL.md                    # NEW: Unified skill (~300 lines)
├── references/
│   ├── cli-flags.md            # COPY from claude-cli-non-interactive
│   ├── execution-patterns.md   # COPY from claude-cli-non-interactive/patterns.md
│   ├── autonomy-testing.md     # MERGE: autonomy-scoring + autonomy-patterns
│   ├── verification.md         # NEW: Extract from tool-analyzer/SKILL.md
│   ├── troubleshooting.md      # COPY from claude-cli-non-interactive
│   ├── hallucination-detection.md # COPY from claude-cli-non-interactive
│   ├── test-framework.md       # NEW: Extract from tests/README.md
│   └── test-suite.md           # NEW: Extract from tests/skill_test_plan.json
└── scripts/
    └── analyze_tools.sh        # COPY from tool-analyzer (with TaskList fix)
```

### Files to Archive

```
.attic/
├── claude-cli-non-interactive/     # DEPRECATED
│   └── references/
│       ├── cli-flags.md
│       ├── patterns.md
│       ├── autonomy-scoring.md
│       ├── autonomy-patterns.md
│       ├── troubleshooting.md
│       └── hallucination-detection.md
└── tool-analyzer/                  # DEPRECATED
    ├── SKILL.md
    └── scripts/
        └── analyze_tools.sh
```

### Files to Keep (test data)

```
tests/
├── raw_logs/               # KEEP: Test output data
├── skill_test_plan.json    # KEEP: Master test record
├── execution/              # KEEP: Supporting docs
├── frameworks/             # KEEP: Framework docs
├── reference/              # KEEP: Reference docs
└── results/                # KEEP: Test results
```

---

## Delta Standard Application

**Remove Claude-obvious content**:
- How to create directories (mkdir)
- How to redirect output (>, 2>&1)
- How to check files exist (ls, cat)

**Keep expert-only content**:
- NDJSON 3-line format structure
- permission_denials autonomy scoring
- stream-json flag combinations
- Win condition marker patterns
- TaskList tool detection patterns

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Skill regression | Archive old skills, keep tests/ folder intact |
| Documentation drift | Update all references to test-runner |
| Broken tests | Run validation suite before deprecating old skills |
| Token bloat | Enforce <500 line reference limit, split if needed |

---

## Timeline Estimate

| Phase | Duration | Effort |
|-------|----------|--------|
| Phase 1: Skills Merger | 30 min | Create unified SKILL.md |
| Phase 2: Extract Logic | 45 min | Create references/ from tests/ |
| Phase 3: Migration | 15 min | Move files, update docs |
| Phase 4: Validation | 30 min | Test all modes |
| **Total** | **2 hours** | 5 major steps |

---

## Next Action

Begin Phase 1: Create `.claude/skills/test-runner/SKILL.md` with unified execution and analysis workflows.
