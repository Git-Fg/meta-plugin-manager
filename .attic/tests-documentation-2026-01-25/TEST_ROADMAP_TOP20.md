# Test Suite Roadmap: Top 20 Critical Tests

**Date**: 2026-01-24
**Status**: Strategy defined, ready for implementation

---

## Executive Summary

To achieve **complete validation** of Claude Code's orchestration and nesting capabilities, **20 new tests** are identified across 5 categories:

| Category | Tests | Focus |
|----------|-------|-------|
| **A. TaskList Orchestration** | 5 | TaskList sequential, parallel, with forked skills, error handling, cross-session |
| **B. Subagent Orchestration** | 5 | Skill composition, dynamic context, error recovery, multi-subagent coordination, timeout |
| **C. Skill-Subagent Orchestration** | 5 | Skill→Subagent→Skill chains, TaskList integration, nested TaskList, error recovery, aggregation |
| **D. Advanced Nesting** | 3 | Triple-level forking, forked skill with TaskList, circular dependencies |
| **E. State & Session** | 2 | State persistence in forked context, multi-session workflows |

---

## Current Gap Analysis

### Already Validated (9 patterns) ✅
1. Regular→Regular (one-way)
2. Regular→Forked (subroutine)
3. Context isolation
4. Parameter passing
5. Double-fork depth 2
6. Hub-and-spoke (forked workers)
7. Subagent skill injection
8. Forked skill autonomy
9. Error propagation (content-level)

### Missing Validation (11 patterns) ❌
1. TaskList sequential workflow
2. TaskList parallel execution
3. TaskList with forked skills
4. TaskList error handling
5. Cross-session TaskList
6. Subagent skill composition
7. Dynamic context injection
8. Subagent error recovery
9. Multi-subagent coordination
10. Subagent timeout handling
11. Skill→Subagent→Skill chains
12. Hub-and-spoke with TaskList
13. Nested TaskList with forked skills
14. Error recovery in skill chains
15. Skill aggregation from subagents
16. Triple-level forking
17. Forked skill with TaskList
18. Circular dependency detection
19. State persistence in forked context
20. Multi-session workflows

---

## Implementation Roadmap

### Sprint 1: TaskList Foundation (Tests T1-T5)
**Goal**: Validate TaskList as orchestration primitive

| Test | Name | Pattern | Real Scenario |
|------|------|---------|---------------|
| T1 | deployment-pipeline-orchestrator | TaskList sequential | CI/CD pipeline |
| T2 | parallel-analysis-coordinator | TaskList parallel | Code analysis |
| T3 | distributed-processor | TaskList + forked skills | Data processing |
| T4 | ci-pipeline-manager | TaskList error handling | CI with recovery |
| T5 | multi-session-orchestrator | Cross-session TaskList | Long-running workflow |

**Success Criteria**:
- TaskList executes dependencies correctly
- TaskList handles parallel execution
- TaskList coordinates with forked skills
- TaskList handles errors with proper blocking
- TaskList persists across sessions

### Sprint 2: Subagent Patterns (Tests T6-T10)
**Goal**: Validate subagent orchestration capabilities

| Test | Name | Pattern | Real Scenario |
|------|------|---------|---------------|
| T6 | code-reviewer-subagent | Subagent skill composition | Code review |
| T7 | context-aware-analyzer | Dynamic context injection | Context-aware analysis |
| T8 | resilient-processor | Subagent error recovery | Data processing |
| T9 | distributed-validator | Multi-subagent coordination | System validation |
| T10 | big-data-processor | Subagent timeout | Big data processing |

**Success Criteria**:
- Subagents use injected skills correctly
- Dynamic context passes to subagents
- Subagents handle errors autonomously
- Multiple subagents coordinate properly
- Subagents handle timeouts gracefully

### Sprint 3: Orchestration Integration (Tests T11-T15)
**Goal**: Validate skill-subagent-TaskList integration

| Test | Name | Pattern | Real Scenario |
|------|------|---------|---------------|
| T11 | multi-phase-analyzer | Skill→Subagent→Skill | Multi-phase analysis |
| T12 | tasklist-audit-hub | Hub-and-Spoke with TaskList | Complex audit |
| T13 | hierarchical-builder | Nested TaskList + forked skills | Build system |
| T14 | resilient-workflow | Error recovery in chains | Resilient workflow |
| T15 | system-reporter | Skill aggregation from subagents | System reporting |

**Success Criteria**:
- Skills successfully call subagents that call skills
- TaskList coordinates with forked skills
- Nested TaskList structures work
- Error recovery works across skill chains
- Skills aggregate multi-subagent results

### Sprint 4: Advanced Patterns (Tests T16-T18)
**Goal**: Validate complex nesting and edge cases

| Test | Name | Pattern | Real Scenario |
|------|------|---------|---------------|
| T16 | deep-analysis-pipeline | Triple-level forking | Deep analysis |
| T17 | isolated-coordinator | Forked skill with TaskList | Isolated processing |
| T18 | dependency-resolver | Circular dependency detection | Build system |

**Success Criteria**:
- Three-level nesting works with isolation
- Forked skills can use TaskList internally
- Circular dependencies are detected and reported

### Sprint 5: State Patterns (Tests T19-T20)
**Goal**: Validate state and session management

| Test | Name | Pattern | Real Scenario |
|------|------|---------|---------------|
| T19 | incremental-analyzer | State persistence in forked context | Incremental analysis |
| T20 | migration-orchestrator | Multi-session workflow | Project migration |

**Success Criteria**:
- Forked skills can maintain state across invocations
- TaskList enables cross-session workflow continuation

---

## Test Design Template

All 20 tests follow this structure:

```yaml
---
name: <realistic-test-name>
description: "Test <capability> in <real condition>. Use when: <trigger>. Not for: <boundaries>."
context: fork  # For isolation in most tests
---

## TEST_START

You are in a realistic <condition>. Your task is to <outcome>.

**Context**: <real-world scenario description>
**Resources available**: <tools, skills, agents>
**Expected output**: <specific format>

Execute autonomously and report findings.

## TEST_COMPLETE
```

---

## Prompt Strategy

**For all tests**: `"[Action verb] the <test-name> autonomous workflow"`

**Good prompts**:
- "Execute the deployment-pipeline autonomous workflow"
- "Demonstrate the parallel-analysis-coordination capability"
- "Perform the multi-session-orchestrator test"

**Avoid**:
- "Use the test-skill"
- "Test the X"
- "Call the skill"

---

## Quality Gates

Each test must pass:

**Autonomy Check**:
- [ ] 0-1 permission denials
- [ ] Completion marker present
- [ ] No user intervention required

**Real Condition Check**:
- [ ] Scenario mirrors actual usage
- [ ] Data/fixtures are realistic
- [ ] Tests actual capability

**Flexibility Check**:
- [ ] Specifies WHAT, not HOW
- [ ] Allows Claude's intelligence to work
- [ ] Not over-prescriptive

---

## Success Metrics

**After implementing all 20 tests**:

**Coverage**: 29 patterns validated (9 existing + 20 new)
**Autonomy**: 95%+ average (0-1 denials per test)
**Representativeness**: 100% of tests use real scenarios
**Completeness**: All orchestration patterns covered

---

## Implementation Priority

1. **Sprint 1** (Week 1): Tests T1-T5 - TaskList foundation
2. **Sprint 2** (Week 2): Tests T6-T10 - Subagent patterns
3. **Sprint 3** (Week 3): Tests T11-T15 - Orchestration integration
4. **Sprint 4** (Week 4): Tests T16-T18 - Advanced patterns
5. **Sprint 5** (Week 5): Tests T19-T20 - State patterns

**Total Duration**: 5 weeks for complete implementation
**Quick Wins**: Sprint 1 (T1-T5) provides immediate TaskList validation

---

## Files Created

1. **TOP_20_CRITICAL_TESTS.md** - This file
2. **REFACTORING_STRATEGY.md** - Refactoring guide for existing tests
3. **FINAL_STATUS_AND_ACTION_PLAN.md** - Current state and next steps

---

## Recommendation

**Start with Sprint 1 (T1-T5)** - TaskList patterns are foundational and high-value.

These 5 tests alone will validate:
- Sequential workflow execution with dependencies
- Parallel execution without blocking
- Integration with forked skills
- Error handling and recovery
- Cross-session persistence

Once TaskList patterns are validated, subsequent sprints can build on that foundation.

---

**TEST_STRATEGY_COMPLETE**
