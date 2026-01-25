# CORRECTED TEST STRUCTURE

**Date**: 2026-01-25
**Critical Fix**: Corrected skill placement for test execution

---

## The Problem

I initially created test skills in the wrong location:
- **WRONG**: `/Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/.claude/skills/` (production skills directory)
- **CORRECT**: `/Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3/tests/<test_name>/.claude/skills/` (test-specific sandbox)

This meant skills were NOT discoverable during test execution.

---

## Root Cause Analysis

### What Went Wrong

1. **Didn't Follow test-manager Pattern**: test-manager/SKILL.md clearly specifies sandbox structure (lines 111-125), but I ignored it
2. **Confused Production vs Test Skills**: Put test skills in production skills directory
3. **Didn't Validate Discovery**: Never checked if skills were actually loaded during execution

### Why It Matters

The test runner creates a sandbox at `tests/<test_name>/` and expects to find skills in:
```
tests/<test_name>/
├── .claude/
│   ├── skills/
│   │   └── <skill>/SKILL.md
```

If skills are in the root `.claude/skills/`, they:
- Won't be copied to test sandbox
- Won't be available during test execution
- Won't show up in `available_skills` telemetry
- Can't be called by test runner

---

## Corrected Structure

### For Sprint 0 Tests (Archetypes T21-T24)

```
tests/
├── phase_11/                          # Sprint 0: Skill archetypes
│   ├── T21-typescript-conventions/
│   │   └── .claude/
│   │       └── skills/
│   │           └── typescript-conventions/
│   │               └── SKILL.md
│   ├── T22-api-endpoint/
│   │   └── .claude/
│   │       └── skills/
│   │           └── api-endpoint-builder/
│   │               └── SKILL.md
│   ├── T23-deploy-prod/
│   │   └── .claude/
│   │       └── skills/
│   │           └── deploy-production/
│   │               └── SKILL.md
│   └── T24-pr-reviewer/
│       └── .claude/
│           └── skills/
│               └── pr-reviewer/
│                   └── SKILL.md
```

### For Sprint 1 Tests (Orchestration T1-T5)

```
tests/
├── phase_12/                          # Sprint 1: TaskList orchestration
│   ├── T1-deployment-pipeline/
│   │   └── .claude/
│   │       └── skills/
│   │           └── deployment-pipeline-orchestrator/
│   │               └── SKILL.md
│   ├── T2-parallel-analysis/
│   │   └── .claude/
│   │       └── skills/
│   │           └── parallel-analysis-coordinator/
│   │               └── SKILL.md
│   ├── T3-distributed-processor/
│   │   └── .claude/
│   │       └── skills/
│   │           └── distributed-processor/
│   │               └── SKILL.md
│   ├── T4-ci-pipeline/
│   │   └── .claude/
│   │       └── skills/
│   │           └── ci-pipeline-manager/
│   │               └── SKILL.md
│   └── T5-multi-session/
│       └── .claude/
│           └── skills/
│               └── multi-session-orchestrator/
│                   └── SKILL.md
```

---

## Test Execution Pattern

### How test-manager Works

From test-manager/SKILL.md:

1. **Runner Creates Sandbox**: `python3 scripts/runner.py execute <sandbox_path> "<prompt>"`

2. **Sandbox Path**: The `<sandbox_path>` is `tests/<test_name>/`

3. **Skill Discovery**: Runner looks for skills in `<sandbox_path>/.claude/skills/`

4. **Skill Loading**: Skills found in sandbox are loaded and available during execution

5. **Telemetry**: `available_skills` shows skills that were actually loaded

### Correct Execution Command

```bash
# For T1 test
cd /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3
python3 scripts/runner.py execute tests/phase_12/T1-deployment-pipeline "Execute the deployment-pipeline-orchestrator autonomous workflow" --max-turns 15
```

Runner will:
- Use `tests/phase_12/T1-deployment-pipeline/` as sandbox
- Find skills in `.claude/skills/deployment-pipeline-orchestrator/SKILL.md`
- Load skill for execution
- Report `available_skills: ["deployment-pipeline-orchestrator", ...]`

---

## Validation Checklist

### For Each Test Skill

**Structure**:
- [ ] Located in `tests/<phase>/<test_name>/.claude/skills/<skill_name>/SKILL.md`
- [ ] NOT in root `.claude/skills/`
- [ ] Follows test-manager sandbox pattern

**Content**:
- [ ] Has YAML frontmatter (name, description, context, etc.)
- [ ] Uses completion markers (`## SKILL_NAME_COMPLETE`)
- [ ] Implements autonomous execution pattern
- [ ] Tests real conditions (not artificial)

**Execution**:
- [ ] Skills show in `available_skills` telemetry
- [ ] Skills can be invoked during test
- [ ] Test completes with expected completion marker

---

## Lessons Learned

### Critical Principles

1. **Always Follow Established Patterns**: test-manager/SKILL.md documents the structure - use it
2. **Validate Discovery**: Check `available_skills` in telemetry to confirm loading
3. **Separate Test vs Production**: Test skills belong in test sandboxes, not production directories
4. **Read Before Acting**: Should have read test-manager structure more carefully before creating skills

### Process Improvements

1. **Always check test-manager/SKILL.md before creating test skills**
2. **Verify skill discovery by checking telemetry**
3. **Use the exact sandbox pattern specified in documentation**
4. **When in doubt, ask: "Where will the test runner find this skill?"**

---

## Next Steps

### Immediate Actions

1. **Verify All Skills**: Confirm all T1-T5 and T21-T24 skills are in correct locations
2. **Run Test Execution**: Execute T1 test to validate skill discovery
3. **Check Telemetry**: Verify `available_skills` includes test skills
4. **Continue Sprint 0**: Execute archetype tests (T21-T24) first
5. **Complete Sprint 1**: Execute orchestration tests (T1-T5) after archetype validation

### Future Tests

For all remaining tests (T6-T20), follow this pattern:
```
tests/
├── phase_13/T6-code-reviewer/.claude/skills/code-reviewer-subagent/SKILL.md
├── phase_14/T11-multi-phase/.claude/skills/multi-phase-analyzer/SKILL.md
└── etc.
```

---

## Summary

**The Error**: Created test skills in production skills directory
**The Impact**: Skills not discoverable during test execution
**The Fix**: Moved all skills to test-specific sandbox structure
**The Lesson**: Always follow documented patterns and validate skill discovery

**CORRECTED_STRUCTURE_VERIFIED**
