# Test Suite Refactoring Strategy

**Date**: 2026-01-24
**Purpose**: Transform test suite to use representative conditions and fully autonomous tests

---

## Executive Summary

Current test suite (Phase 1-11) was designed to validate Claude Code skill calling behaviors. While successful (75% completion, 96% success rate), the tests revealed a fundamental design issue:

**Problem**: Many tests were designed with artificial scenarios rather than real conditions, leading to unreliable autonomous execution.

**Solution**: Refactor remaining tests using updated test-manager patterns with focus on:
1. **Real conditions** - Tests mirror actual production usage
2. **Autonomy** - Tests complete without intervention (0-1 denials)
3. **Appropriate constraints** - Balance specificity with flexibility

---

## Current State Analysis

### Successfully Validated (24 tests - 75%)

| Phase | Status | Key Findings |
|-------|--------|--------------|
| 1 | ✅ Complete | Regular→Regular = one-way handoff |
| 2 | ✅ Complete | Context isolation = complete |
| 3 | ✅ Complete | Custom subagents accessible |
| 4 | ⚠️ Partial | Double-fork works, parallel needs work |
| 5 | ✅ Complete | Parameters pass correctly |
| 6 | ✅ Complete | Hub-and-spoke validated |
| 7 | ⚠️ Partial | Skill injection works, 7.2 incomplete |
| 8 | ⚠️ Partial | Error propagation analyzed, timeout pending |

### Need Refactoring (8 tests)

| Test ID | Name | Current Issue | Refactor Approach |
|---------|------|---------------|-----------------|
| 4.3 | Parallel Forked Execution | Failed - asked questions | Redesign as real orchestrator scenario |
| 4.4 | Nested Fork Depth 3+ | No raw log - doesn't exist | Remove or redesign as realistic test |
| 7.2 | Audit Workflow | Partial execution | Complete with real audit scenario |
| 9.1 | File System Access | Not started | Real project file organization test |
| 9.2 | Resource Contention | Not started | Real concurrent access test |
| 10.1 | State Persistence | Stub implementation | Real stateful workflow test |
| 10.2 | Agent Communication | Not started | Real agent delegation test |
| 8.2 | Timeout Handling | Not started | Real long-running task test |

### Phase 11 (38 tests) - RECOMMEND CANCELLATION

**Rationale**: Phase 11 tests compare recursive workflows vs TaskList. Given:
- Non-interactive testing limitations for multi-skill chains
- TaskList itself is well-documented and tested separately
- Research priority lower than core validation

**Recommendation**: Cancel Phase 11, document findings as "sufficient for validation"

---

## Refactoring Principles

### Principle 1: Real Conditions First

**Before**: Test artificial scenarios
```yaml
# BAD
---
name: test-counter
description: "Test file counting"
---
Count test1.txt, test2.txt, test3.txt
```

**After**: Test real workflows
```yaml
# GOOD
---
name: project-file-organizer
description: "Analyze real project file organization patterns"
context: fork
---

## TEST_START

You are analyzing a real project's file organization.

**Your task**: Scan and report organization patterns:
- Source files (src/, lib/, app/)
- Test files (test/, tests/, *.test.*, *.spec.*)
- Configuration (*.config.*, *.env.*, settings.*)
- Documentation (README*, *.md, docs/)

**Report**: Organization pattern, misplaced files, recommendations.

## TEST_COMPLETE
```

### Principle 2: Autonomous Execution

**Prompt Pattern**: `"[Action verb] the [test-name] autonomous workflow"`

**Good prompts**:
- `"Execute the project-file-organization autonomous workflow"`
- `"Demonstrate the service-health-check capability"`
- `"Perform the code-complexity-analysis test"`

**Bad prompts**:
- `"Use the skill"` → Too vague
- `"Test the file counter"` → Artificial scenario
- `"Step 1: Do X, Step 2: Do Y"` → Over-prescriptive

### Principle 3: Degrees of Freedom

**High Freedom** (Most tests):
```yaml
---
name: security-auditor
description: "Audit codebase for security vulnerabilities"
context: fork
agent: Explore
---

## TEST_START

You are performing a security audit on a real codebase.

**Your task**: Identify and report security issues:
- OWASP Top 10 vulnerabilities
- Hardcoded secrets/credentials
- Input sanitization issues
- Permission problems

**Approach**: Choose what to check based on codebase type and size.
**Report**: Severity-rated findings with line numbers.

## TEST_COMPLETE
```

**Medium Freedom** (Guided tests):
```yaml
---
name: compliance-verifier
description: "Verify required project files exist"
context: fork
---

## TEST_START

You are verifying project compliance with standards.

**Required files** (check all that apply):
- [ ] LICENSE (MIT/Apache/GPL)
- [ ] .env.example (environment template)
- [ ] SECURITY.md (security policy)
- [ ] CONTRIBUTING.md (contributor guide)

**Report missing items** with severity ratings.

## TEST_COMPLETE
```

**Low Freedom** (Compliance only):
- Use sparingly
- Only when reproducibility is critical
- Example: Regulatory compliance checks

---

## Specific Test Refactoring Plans

### Test 4.3: Parallel Forked Execution

**Current Issue**: Failed - orchestrator asked questions

**Refactored Design**:
```yaml
---
name: parallel-audit-orchestrator
description: "Orchestrate parallel security and code quality audits"
disable-model-invocation: true
---

## ORCHESTRATOR_START

You are orchestrating parallel audits on a real project.

**Execute autonomously**:
1. Call security-scanner (context: fork, agent: Explore)
   - Prompt: "Audit this codebase for OWASP Top 10 vulnerabilities"
2. Call complexity-analyzer (context: fork, agent: Explore)
   - Prompt: "Analyze this codebase for complexity patterns"

3. Wait for both to complete
4. Aggregate findings into comprehensive report

## ORCHESTRATOR_COMPLETE
```

**Worker Skills** (context: fork):
- `security-scanner`: "Scan for security issues, report findings"
- `complexity-analyzer`: "Calculate cyclomatic complexity, report outliers"

### Test 4.4: Nested Fork Depth 3+ - REMOVE

**Rationale**: Test doesn't exist, concept duplicates test 4.2 (double-fork already validated to depth 2)

**Action**: Mark as DEPRECATED, remove from test plan

### Test 7.2: Audit Workflow - COMPLETE

```yaml
---
name: project-auditor
description: "Comprehensive project audit with security, performance, and architecture validation"
disable-model-invocation: true
---

## AUDIT_START

You are conducting a comprehensive project audit.

**Execute autonomously**:
1. Scan project structure and identify key components
2. Analyze code for security vulnerabilities (SQL injection, XSS, secrets)
3. Check performance patterns (N+1 queries, missing indexes)
4. Review architecture patterns used
5. Generate comprehensive audit report

## AUDIT_COMPLETE
```

### Test 9.1: File System Access - REAL SCENARIO

```yaml
---
name: workspace-file-organizer
description: "Organize project files by type and purpose"
context: fork
---

## FILE_ORGANIZER_START

You are organizing a real project workspace.

**Your task**: Categorize and organize files:

**Scan for**:
- Source code (*.js, *.ts, *.py, *.go, *.rs)
- Test files (*test*, *.spec.*, tests/)
- Configuration (*.config.*, *.env.*, settings.*)
- Documentation (README*, *.md, docs/)
- Build artifacts (dist/, build/, *.o, *.a)

**Actions**:
- Report current organization state
- Identify misplaced files (sources in wrong locations)
- Recommend improvements

## FILE_ORGANIZER_COMPLETE
```

### Test 9.2: Resource Contention - REAL SCENARIO

```yaml
---
name: concurrent-file-processor
description: "Test concurrent file access patterns"
context: fork
---

## CONCURRENT_TEST_START

You are testing concurrent file access in a real workspace.

**Your task**:
1. Create test-file.json in shared location
2. Read and process it
3. Report any contention issues detected

**Real condition**: Multiple skills might access same resources

## CONCURRENT_TEST_COMPLETE
```

**Note**: For true parallel testing, use TaskList to create concurrent tasks.

### Test 10.1: State Persistence - REAL SCENARIO

```yaml
---
name: session-state-manager
description: "Demonstrate state persistence across skill invocations"
context: fork
---

## STATE_TEST_START

You are testing state persistence in forked context.

**Your task**:
1. Create state file: .test-state.json with {count: 1, timestamp: now}
2. Read it back and verify
3. Report: State persisted successfully

## STATE_TEST_COMPLETE
```

### Test 10.2: Agent Communication - REAL SCENARIO

```yaml
---
name: specialist-delegator
description: "Delegate specialized work to appropriate agents"
context: fork
---

## DELEGATOR_START

You are a delegator that routes work to specialists.

**Your task**: Process this codebase analysis request by delegating appropriately

**Available specialists**:
- Explore agent: For codebase exploration
- Plan agent: For architecture planning

**Execute autonomously**:
1. Assess what type of analysis is needed
2. Use Task tool to delegate to appropriate agent
3. Report findings

## DELEGATOR_COMPLETE
```

### Test 8.2: Timeout Handling - REAL SCENARIO

```yaml
---
name: long-running-scanner
description: "Test timeout handling with realistic long-running task"
context: fork
---

## TIMEOUT_TEST_START

You are scanning a large codebase for patterns.

**Your task**:
1. Search for all TODO comments in the codebase
2. Categorize by priority (high/medium/low)
3. Generate TODO report

**Time limit**: Work autonomously but efficiently

## TIMEOUT_TEST_COMPLETE
```

---

## TaskList Integration for Complex Tests

For multi-step workflows requiring orchestration, use TaskList:

```yaml
---
name: multi-phase-auditor
description: "Orchestrate multi-phase audit using TaskList"
disable-model-invocation: true
---

## AUDIT_START

You are orchestrating a multi-phase audit.

**Using TaskList**, create tasks:
1. Security audit (high priority)
2. Performance review (medium priority, blocked by security)
3. Documentation check (low priority, independent)

Execute each phase by delegating to appropriate specialist.

## AUDIT_COMPLETE
```

---

## Implementation Priority

### Phase 1: Critical Fixes (Immediate)
1. Remove test 4.4 (doesn't exist)
2. Update test 4.3 with real orchestrator scenario
3. Complete test 7.2 with real audit workflow

### Phase 2: Missing Tests (High Priority)
4. Implement test 9.1 (real file organization)
5. Implement test 10.1 (real state persistence)
6. Implement test 8.2 (real timeout scenario)

### Phase 3: Enhancement (Medium Priority)
7. Implement test 9.2 (resource contention)
8. Implement test 10.2 (agent delegation)

### Phase 4: Documentation
9. Update test plan with all changes
10. Document lessons learned
11. Create "Test Design Best Practices" guide

---

## Success Criteria

After refactoring, all tests must meet:

**Representativeness**:
- [ ] Tests real workflows, not artificial scenarios
- [ ] Uses realistic data/fixtures
- [ ] Mirrors production usage

**Autonomy**:
- [ ] 0-1 permission denials
- [ ] Clear completion marker
- [ ] No user intervention required

**Quality**:
- [ ] Specific prompt (not "Use the skill")
- [ ] Appropriate degree of freedom (high/medium/low)
- [ ] Clear output format specified

---

## Next Steps

1. **Immediate**: Cancel Phase 11 (38 tests) - not aligned with validation goals
2. **Priority**: Implement refactored tests 4.3, 7.2, 9.1, 10.1
3. **Documentation**: Create "Test Design Patterns" reference document
4. **Validation**: Run refactored tests, verify autonomy scores

**Target**: 28/28 tests completed (100%) with 95%+ average autonomy score.
