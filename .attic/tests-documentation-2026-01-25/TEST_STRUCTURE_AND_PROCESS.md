# Test Structure and Process Summary

**Date**: 2026-01-25
**Purpose**: Understand how tests are created, structured, and executed

---

## Overview

This document explains the complete test creation and execution process for the thecattoolkit_v3 project, focusing on the structure, patterns, and workflow.

---

## Part 1: Test Structure

### Directory Layout

```
tests/
├── skill_test_plan.json           # Master test plan with all tests and status
├── phase_1/ ... phase_8/          # Completed test phases (1-8)
├── phase_12/                      # Sprint 1: TaskList orchestration (T1-T5)
│   ├── test_T1.deployment.pipeline.orchestrator.skill.md
│   ├── test_T2.parallel.analysis.coordinator.skill.md
│   ├── test_T3.distributed.processor.skill.md
│   ├── test_T4.ci.pipeline.manager.skill.md
│   └── test_T5.multi.session.orchestrator.skill.md
├── phase_13/                      # Sprint 2: Subagent patterns (T6-T10)
├── phase_14/                      # Sprint 3: Skill-subagent orchestration (T11-T15)
├── phase_15/                      # Sprint 4: Advanced nesting (T16-T18)
├── phase_16/                      # Sprint 5: State patterns (T19-T20)
└── results/                       # Test results and summaries
    ├── INCOHERENCES_ET_ACTIONS_REQUISES.md
    ├── TEST_EXECUTION_LIMITATION_REPORT.md
    └── TEST_SUITE_FINAL_SUMMARY.md
```

### Test Skill Files

Each test has a skill file in `.claude/skills/`:

```
.claude/skills/
├── deployment-pipeline-orchestrator/      # T1
│   └── SKILL.md
├── parallel-analysis-coordinator/        # T2
│   └── SKILL.md
├── distributed-processor/                 # T3
│   └── SKILL.md
├── ci-pipeline-manager/                  # T4
│   └── SKILL.md
└── multi-session-orchestrator/           # T5
    └── SKILL.md
```

---

## Part 2: Test Creation Process

### Step 1: Define Test Specification

Tests are defined in `skill_test_plan.json` with:

```json
{
  "test_id": "T1",
  "name": "deployment-pipeline-orchestrator",
  "pattern": "TaskList sequential workflow",
  "real_scenario": "Multi-step deployment pipeline",
  "status": "NOT_STARTED",
  "priority": "HIGH",
  "description": "Orchestrate deployment pipeline using TaskList",
  "validation": "TaskList creates proper dependency chains",
  "skill_file": "phase_12/test_T1.deployment.pipeline.orchestrator.skill.md",
  "test_prompt": "Execute the deployment-pipeline-orchestrator autonomous workflow",
  "success_criteria": [
    "Tasks created with proper dependencies",
    "Sequential execution order validated",
    "Completion markers present",
    "Results aggregated correctly"
  ]
}
```

### Step 2: Create Skill File

Each test is implemented as a skill in `.claude/skills/<test-name>/SKILL.md`:

```yaml
---
name: deployment-pipeline-orchestrator
description: "Orchestrate deployment pipeline using TaskList. Use when: coordinating multi-stage deployments with dependencies. Not for: simple single-command deployments."
disable-model-invocation: true
---

## PIPELINE_START

You are orchestrating a multi-stage deployment pipeline for a real application.

**Context**: This is a CI/CD pipeline that must execute stages in strict order...

Execute autonomously:
1. Use TaskList to create all four pipeline tasks
2. Set up dependencies
3. Monitor task execution
4. Report pipeline status

## PIPELINE_COMPLETE
```

### Step 3: Key Test Design Patterns

**Pattern 1: Autonomous Execution**
- Uses imperative prompts: "Execute", "Perform", "Demonstrate"
- Includes completion markers: `## PIPELINE_START` / `## PIPELINE_COMPLETE`
- No user questions expected (0-1 permission denials)

**Pattern 2: Real Conditions**
- Tests mirror actual production usage
- Realistic scenarios (e.g., "CI/CD deployment pipeline")
- Not artificial test data (no "test1.txt", "test2.txt")

**Pattern 3: What, Not How**
- Specifies WHAT to achieve
- Allows Claude to decide HOW
- Natural language for TaskList workflows (per Layer 0 rules)

---

## Part 3: Test Execution Process

### Using test-manager Skill

The `test-manager` skill provides the `scripts/runner.py` tool:

**Execute Test**:
```bash
python3 scripts/runner.py execute <sandbox_path> "<prompt>" --max-turns 15
```

**Analyze Results**:
```bash
python3 scripts/runner.py summarize <path_to_raw_log.json>
```

### Real Execution Command

For test T1, the execution would be:

```bash
cd /Users/felix/Documents/claude-plugins-custom/thecattoolkit_v3

# Execute using claude with the skill loaded
claude --dangerously-skip-permissions \
  -p "Execute the deployment-pipeline-orchestrator autonomous workflow" \
  --stream-json \
  > tests/phase_12/raw_logs/test_T1.deployment.pipeline.orchestrator.json 2>&1
```

### Expected Telemetry Output

```json
{
  "status": "EXECUTED",
  "telemetry": {
    "available_tools": ["TaskList", "TaskCreate", "TaskUpdate", ...],
    "available_skills": ["deployment-pipeline-orchestrator", ...],
    "available_agents": ["general-purpose", ...],
    "tool_counts": {"TaskList": 4, "Bash": 3, "Write": 1},
    "tool_usage_sequence": ["TaskList", "Bash", "Bash", "TaskList", ...],
    "permission_denials": 0,
    "duration_ms": 45321,
    "num_turns": 8,
    "is_error": false
  }
}
```

---

## Part 4: Test Analysis Process

### Quality Validation

Tests are evaluated on three dimensions:

**1. Autonomy**
- Permission denials: 0-1 (target: 0)
- Completion marker: Present
- User intervention: None

**2. Real Conditions**
- Scenario mirrors actual usage
- Tests real capability
- Uses realistic data

**3. Flexibility**
- Specifies WHAT, not HOW
- Allows Claude's intelligence to work
- Not over-prescriptive

### Result Interpretation

**Success Criteria**:
```
✓ Tasks created with TaskCreate
✓ Dependencies set with addBlockedBy
✓ Sequential execution order validated
✓ Completion markers present (## PIPELINE_COMPLETE)
✓ Permission denials: 0
```

**Failure Patterns**:
```
✗ permission_denials > 5 → Not autonomous
✗ tool_usage_sequence: [] → Nothing executed
✗ is_error: true → Crash/exception
✗ Missing completion marker → Incomplete execution
```

---

## Part 5: Sprint Execution Strategy

### Sprint Structure

Tests are grouped into 5 sprints:

| Sprint | Tests | Focus | Duration |
|--------|-------|-------|----------|
| Sprint 1 | T1-T5 | TaskList orchestration | Week 1 |
| Sprint 2 | T6-T10 | Subagent patterns | Week 2 |
| Sprint 3 | T11-T15 | Orchestration integration | Week 3 |
| Sprint 4 | T16-T18 | Advanced nesting | Week 4 |
| Sprint 5 | T19-T20 | State patterns | Week 5 |

### Execution Order

**Within Sprint**:
1. Implement all test skill files (T1-T5)
2. Execute tests sequentially
3. Analyze results after each test
4. Update `skill_test_plan.json` with results
5. Proceed to next sprint only after completing current

**Between Sprints**:
1. Review and analyze completed sprint
2. Update documentation (CLAUDE.md)
3. Identify patterns and learnings
4. Proceed to next sprint

---

## Part 6: What We've Created So Far

### Completed Work

**1. Updated Test Plan** (`skill_test_plan.json`)
- Integrated 20 new tests (T1-T20)
- Created 5 new phases (12-16)
- Added implementation roadmap and success metrics

**2. Created Sprint 1 Tests** (T1-T5)
- `deployment-pipeline-orchestrator` - Sequential TaskList workflow
- `parallel-analysis-coordinator` - Parallel TaskList execution
- `distributed-processor` - TaskList + forked skills
- `ci-pipeline-manager` - TaskList error handling
- `multi-session-orchestrator` - Cross-session TaskList

**3. Created Test Skills in .claude/skills/**
- Each test skill follows autonomous execution pattern
- Uses completion markers
- Tests real conditions
- Specifies WHAT, not HOW

**4. Created Execution Plan** (`TASKLIST_EXECUTION_PLAN.md`)
- Detailed TaskList structure for test execution
- Success criteria for each test
- Progress tracking framework

### Next Steps (If Continuing)

1. **Execute T1**: Run `deployment-pipeline-orchestrator` test
2. **Analyze Results**: Check telemetry, validate success criteria
3. **Execute T2-T5**: Complete Sprint 1 tests
4. **Update JSON**: Mark tests as COMPLETED with findings
5. **Proceed to Sprint 2**: T6-T10 subagent patterns
6. **Continue Through All Sprints**: Complete all 20 tests

---

## Part 7: Key Learnings from Previous Tests

### Critical Discoveries

1. **Regular skill chains are one-way handoffs**
   - skill-a calls skill-b → control transfers permanently
   - skill-a never resumes after skill-b completes

2. **Forked skills enable subroutine pattern**
   - Control returns to caller after forked skill completes
   - Essential for orchestrator patterns

3. **Context isolation is complete**
   - Forked skills cannot access caller's context
   - Parameters pass via args, context does not

4. **Test design matters**
   - Artificial scenarios don't work in non-interactive mode
   - Real conditions are essential
   - Prompt specificity is critical

### Quality Gates Established

**Autonomy Check**:
- Max permission denials: 1
- Completion marker: Required
- User intervention: Not allowed

**Real Condition Check**:
- Scenario: Must mirror actual usage
- Data: Must be realistic
- Capability: Must test actual functionality

**Flexibility Check**:
- WHAT vs HOW: Specifies outcome, not process
- Intelligence: Allows Claude's judgment
- Constraints: Appropriate, not over-prescriptive

---

## Part 8: Test Anti-Patterns to Avoid

### Anti-Pattern 1: Recipe-Style Instructions
```yaml
# BAD
Step 1: Do X
Step 2: Do Y
Step 3: Do Z
```
→ Doesn't execute autonomously in non-interactive mode

### Anti-Pattern 2: Artificial Test Data
```yaml
# BAD
Count test1.txt, test2.txt, test3.txt
```
→ Tests contrived scenarios, not real usage

### Anti-Pattern 3: Over-Prescriptive Prompts
```yaml
# BAD
Use the skill to perform the test
```
→ Generic prompts don't trigger autonomous execution

### Correct Pattern
```yaml
# GOOD
Execute the deployment-pipeline-orchestrator autonomous workflow
```
→ Specific, imperative prompt that triggers action

---

## Summary

The test structure consists of:

1. **Test Specifications** - Defined in `skill_test_plan.json`
2. **Skill Implementations** - Located in `.claude/skills/<test-name>/SKILL.md`
3. **Execution** - Using `test-manager` runner with claude CLI
4. **Analysis** - Validate autonomy, real conditions, and flexibility
5. **Iteration** - Sprint-based execution with progress tracking

The key insight: Tests must be designed for **autonomous execution** in **real conditions** with **appropriate flexibility** to allow Claude's intelligence to work effectively.

**TASK_STRUCTURE_UNDERSTOOD**
