# Top 20 Critical Tests: Orchestration & Nesting Patterns

**Purpose**: Comprehensive validation of subagent/skill/TaskList orchestration patterns
**Date**: 2026-01-24
**Strategy**: Real conditions + autonomous execution + TaskList integration

---

## Coverage Analysis

### Already Validated (9 Patterns)
✅ Regular→Regular (one-way)
✅ Regular→Forked (subroutine)
✅ Context isolation (complete)
✅ Parameter passing (via args)
✅ Double-fork depth 2
✅ Hub-and-spoke (forked workers)
✅ Subagent skill injection
✅ Forked skill autonomy
✅ Error propagation (content-level)

### Critical Gaps (11 Patterns Missing)
❌ True parallel execution
❌ TaskList-based orchestration
❌ Subagent→Skill coordination
❌ Skill→Subagent→Skill chains
❌ Multi-session workflows
❌ State persistence across sessions
❌ Dynamic context injection
❌ Error recovery patterns
❌ Long-running workflows
❌ Resource contention
❌ Cross-agent communication

---

## Top 20 Critical Tests

### Category A: TaskList Orchestration (5 tests)

#### Test T1: TaskList Sequential Workflow
**Pattern**: TaskList with sequential dependencies
**Real Scenario**: Multi-step deployment pipeline

```yaml
---
name: deployment-pipeline-orchestrator
description: "Orchestrate deployment pipeline using TaskList"
disable-model-invocation: true
---

## PIPELINE_START

You are orchestrating a multi-stage deployment pipeline.

**Using TaskList**, create this workflow:
1. "run-tests" - Execute test suite
2. "build-artifact" - Compile application (blocked by: ["run-tests"])
3. "deploy-staging" - Deploy to staging (blocked_by: ["build-artifact"])
4. "verify-deployment" - Smoke test staging (blocked_by: ["deploy-staging"])

**Execute autonomously**:
- Create tasks with TaskCreate
- Set up dependencies with addBlockedBy
- Monitor task completion
- Aggregate results

## PIPELINE_COMPLETE
```

**Validation**: TaskList creates proper dependency chains, tasks execute in correct order

---

#### Test T2: TaskList Parallel Execution
**Pattern**: TaskList with concurrent independent tasks
**Real Scenario**: Parallel code analysis

```yaml
---
name: parallel-analysis-coordinator
description: "Coordinate parallel analysis tasks using TaskList"
context: fork
---

## PARALLEL_START

You are coordinating parallel analysis of a codebase.

**Using TaskList**, create independent tasks:
1. "security-scan" - Security vulnerability scan
2. "complexity-analysis" - Code complexity metrics
3. "dependency-check" - Dependency vulnerabilities
4. "license-audit" - License compliance

**Execute autonomously**:
- All tasks run concurrently (no blocking)
- Wait for all to complete
- Aggregate results into report

## PARALLEL_COMPLETE
```

**Validation**: TaskList executes tasks concurrently, properly aggregates results

---

#### Test T3: TaskList with Forked Skills
**Pattern**: TaskList tasks that invoke forked skills
**Real Scenario**: Distributed data processing

```yaml
---
name: distributed-processor
description: "Process data using TaskList and forked skills"
context: fork
---

## PROCESSING_START

You are coordinating distributed data processing.

**Using TaskList**, create:
1. "process-region-a" - Call region-processor-skill (forked)
2. "process-region-b" - Call region-processor-skill (forked)
3. "process-region-c" - Call region-processor-skill (forked)
4. "aggregate-results" - Aggregate all outputs

**Execute autonomously**:
- Use TaskCreate for each task
- Use Skill tool with context: fork for workers
- Aggregate results when all complete

## PROCESSING_COMPLETE
```

**Validation**: TaskList coordinates with forked skills correctly

---

#### Test T4: TaskList Error Handling
**Pattern**: TaskList behavior when tasks fail
**Real Scenario**: CI pipeline with failure recovery

```yaml
---
name: ci-pipeline-manager
description: "Test TaskList error handling and recovery"
context: fork
---

## CI_START

You are managing a CI pipeline with error recovery.

**Using TaskList**, create:
1. "run-tests" - Execute test suite
2. "build" - Compile (blocked_by: ["run-tests"])
3. "deploy" - Deploy to staging (blocked_by: ["build"])
4. "cleanup-on-failure" - Cleanup (blocked_by: ["run-tests"], triggered on failure

**Execute autonomously**:
- Simulate test failure in run-tests
- Verify cleanup-on-failure executes
- Verify deploy never runs
- Report task states

## CI_COMPLETE
```

**Validation**: TaskList properly handles task failures and dependent task blocking

---

#### Test T5: Cross-Session TaskList
**Pattern**: TaskList persistence across sessions
**Real Scenario: Long-running multi-session workflow

```yaml
---
name: multi-session-orchestrator
description: "Test TaskList cross-session persistence"
---

## SESSION_START

You are testing TaskList persistence across sessions.

**Session 1**:
1. Using TaskList, create: "long-task-1", "long-task-2", "long-task-3"
2. Mark task-1 as IN_PROGRESS
3. Report: TaskList ID for session continuation

**Session 2** (simulate with CLAUDE_CODE_TASK_LIST_ID):
1. Load existing TaskList by ID
2. Verify task-1 status preserved
3. Complete task-1, update task-2
4. Report continuation worked

## SESSION_COMPLETE
```

**Validation**: TaskList persists state across sessions, tasks maintain status

---

### Category B: Subagent Orchestration (5 tests)

#### Test T6: Subagent Skill Composition
**Pattern**: Subagent with injected skills calling those skills
**Real Scenario**: Code reviewer with quality checks

```yaml
---
name: code-reviewer-subagent
description: "Subagent that reviews code using injected skills"
agent: general-purpose
skills: ["security-review", "style-review", "test-coverage"]
---

## REVIEW_START

You are a code reviewer with specialized skills.

**Review autonomously**:
1. Read the codebase
2. Use security-review skill to check for vulnerabilities
3. Use style-review skill to check code style
4. Use test-coverage skill to verify tests
5. Aggregate all findings into review report

## REVIEW_COMPLETE
```

**Validation**: Subagent successfully uses injected skills, composes results

---

#### Test T7: Dynamic Context Injection
**Pattern**: Subagent receives dynamic context from caller
**Real Scenario: Context-aware specialist

```yaml
---
name: context-aware-analyzer
description: "Analyzer that receives project context dynamically"
context: fork
---

## ANALYZE_START

You are analyzing a codebase.

**Context provided via args**: Project type, tech stack, analysis goals

**Execute autonomously**:
1. Parse the provided context
2. Tailor analysis approach based on project type
3. Apply appropriate patterns for tech stack
4. Report findings with context-aware recommendations

## ANALYZE_COMPLETE
```

**Validation**: Subagent receives and utilizes dynamic context correctly

---

#### Test T8: Subagent Error Recovery
**Pattern**: Subagent handles errors and reports appropriately
**Real Scenario: Robust data processor

```yaml
---
name: resilient-processor
description: "Subagent that handles errors gracefully"
agent: general-purpose
---

## PROCESSING_START

You are processing data with error recovery.

**Execute autonomously**:
1. Attempt to process data-source-A
2. If it fails, try data-source-B
3. If both fail, generate error report with recovery suggestions
4. Log all attempts and outcomes

## PROCESSING_COMPLETE
```

**Validation**: Subagent implements error recovery logic autonomously

---

#### Test T9: Multi-Subagent Coordination
**Pattern**: Multiple subagents working together
**Real Scenario: Distributed system validation

```yaml
---
name: distributed-validator
description: "Coordinate multiple subagents for system validation"
---

## VALIDATION_START

You are coordinating validation across multiple domains.

**Execute autonomously**:
1. Use Task tool to spawn security-validator subagent
2. Use Task tool to spawn performance-validator subagent
3. Use Task tool to spawn compliance-validator subagent
4. Wait for all to complete
5. Aggregate findings into comprehensive report

## VALIDATION_COMPLETE
```

**Validation**: Multiple subagents coordinate properly, results aggregated

---

#### Test T10: Subagent Timeout Handling
**Pattern**: Subagent with long-running operation timeout
**Real Scenario: Big data processor

```yaml
---
name: big-data-processor
description: "Test subagent timeout handling"
agent: general-purpose
---

## PROCESSING_START

You are processing a large dataset.

**Execute autonomously**:
1. Process as much data as possible within time budget
2. If timeout approaches, save progress checkpoint
3. Report: completed items, checkpoint location, continuation instructions

## PROCESSING_COMPLETE
```

**Validation**: Subagent handles timeouts gracefully with progress preservation

---

### Category C: Skill-Subagent Orchestration (5 tests)

#### Test T11: Skill Calling Subagent Calling Skill
**Pattern**: Regular skill → Subagent → Forked skill chain
**Real Scenario: Multi-phase analysis

```yaml
---
name: multi-phase-analyzer
description: "Orchestrate multi-phase analysis with subagent and skill"
---

## ANALYSIS_START

You are conducting multi-phase codebase analysis.

**Phase 1**: Use Task tool to spawn code-explorer subagent
- Subagent explores codebase structure

**Phase 2**: Call vulnerability-scanner skill (context: fork)
- Skill scans for security issues

**Phase 3**: Aggregate findings from both phases
- Combine structure and vulnerability data

## ANALYSIS_COMPLETE
```

**Validation**: Three-layer coordination works (skill → subagent → forked skill)

---

#### Test T12: Hub-and-Spoke with TaskList
**Pattern**: Hub skill uses TaskList to coordinate workers
**Real Scenario: Complex audit orchestration

```yaml
---
name: tasklist-audit-hub
description: "Orchestrate audit using TaskList for coordination"
disable-model-invocation: true
---

## AUDIT_HUB_START

You are orchestrating a comprehensive audit.

**Using TaskList**, create worker tasks:
1. "security-audit" - Call security-auditor skill (forked)
2. "performance-audit" - Call performance-analyzer skill (forked)
3. "compliance-audit" - Call compliance-checker skill (forked)
4. "aggregate-results" - Aggregate all audit results (blocked_by: all audits)

**Execute autonomously**:
- Create TaskList tasks for each audit
- Each task calls appropriate forked skill via Skill tool
- Aggregation task waits for all audits
- Generate comprehensive report

## AUDIT_HUB_COMPLETE
```

**Validation**: TaskList + forked skills coordination works

---

#### Test T13: Nested TaskList with Forked Skills
**Pattern**: TaskList within a TaskList task using forked skills
**Real Scenario: Hierarchical build system

```yaml
---
name: hierarchical-builder
description: "Test nested TaskList with forked skill workers"
---

## BUILD_START

You are orchestrating a hierarchical build.

**Level 1 TaskList**:
1. "build-frontend" - (creates nested TaskList)
2. "build-backend" - (creates nested TaskList)

**Level 2 TaskList** (within build-frontend):
1. "compile-assets" - Call asset-compiler skill (forked)
2. "bundle-scripts" - Call bundler skill (forked)

**Execute autonomously**:
- Create parent TaskList
- Parent tasks create child TaskLists
- Child tasks call forked skills via Skill tool
- Verify all complete successfully

## BUILD_COMPLETE
```

**Validation**: Nested TaskList with forked skills works correctly

---

#### Test T14: Error Recovery in Skill Chains
**Pattern**: Skill handles subagent failure gracefully
**Real Scenario: Resilient workflow

```yaml
---
name: resilient-workflow
description: "Handle failures in skill-subagent chains"
---

## WORKFLOW_START

You are executing a workflow with fallback options.

**Primary path**:
1. Call preferred-subagent via Task tool
2. If it fails, call fallback-subagent
3. If both fail, execute fallback procedure directly
4. Report result with path taken

**Execute autonomously** with error handling at each step.

## WORKFLOW_COMPLETE
```

**Validation**: Skill chains handle subagent failures with fallbacks

---

#### Test T15: Skill Aggregation from Multiple Subagents
**Pattern**: One skill collects results from multiple subagents
**Real Scenario: Comprehensive system report

```yaml
---
name: system-reporter
description: "Aggregate results from multiple specialist subagents"
---

## REPORT_START

You are generating a comprehensive system report.

**Execute autonomously**:
1. Use Task tool to spawn security-analyst subagent
2. Use Task tool to spawn performance-analyst subagent
3. Use Task tool to spawn architecture-analyst subagent
4. Collect all results
5. Synthesize into comprehensive report

## REPORT_COMPLETE
```

**Validation**: Skill successfully collects and synthesizes multi-subagent results

---

### Category D: Advanced Nesting Patterns (3 tests)

#### Test T16: Triple-Level Forking
**Pattern**: Skill → Forked Subagent → Forked Skill
**Real Scenario: Deep analysis pipeline

```yaml
---
name: deep-analysis-pipeline
description: "Test triple-level forking with real analysis"
---

## PIPELINE_START

You are orchestrating deep analysis.

**Level 1**: Call deep-explorer subagent (Task tool)
- Subagent will work in isolated context

**Level 2**: Subagent calls pattern-analyzer skill (context: fork)
- Skill analyzes patterns in isolation

**Level 3**: Pattern-analyzer calls anomaly-detector skill (context: fork)
- Deepest level detection

**Execute autonomously** through all three levels.
Report findings with level information.

## PIPELINE_COMPLETE
```

**Validation**: Three-level nesting works with proper isolation

---

#### Test T17: Forked Skill Orchestration with TaskList
**Pattern**: Forked skill uses TaskList to coordinate work
**Real Scenario: Isolated parallel processing

```yaml
---
name: isolated-coordinator
description: "Forked skill that uses TaskList internally"
context: fork
---

## COORDINATION_START

You are coordinating work in complete isolation.

**Using TaskList internally**, create:
1. "worker-1" - Process data chunk A
2. "worker-2" - Process data chunk B
3. "worker-3" - Process data chunk C
4. "merge" - Combine all results

**Execute autonomously**:
- TaskList used within forked context
- All processing happens in isolation
- Return merged results to caller

## COORDINATION_COMPLETE
```

**Validation**: Forked skill can use TaskList for internal coordination

---

#### Test T18: Circular Dependency Detection
**Pattern**: Detect and handle circular dependencies
**Real Scenario: Build system with circular refs

```yaml
---
name: dependency-resolver
description: "Detect and resolve circular dependencies"
context: fork
---

## RESOLUTION_START

You are analyzing a dependency graph for circular references.

**Execute autonomously**:
1. Scan for circular references (A→B→A, A→B→C→A, etc.)
2. Report all circular dependency chains found
3. For each cycle, identify breaking point
4. Recommend resolution strategies

## RESOLUTION_COMPLETE
```

**Validation**: System detects and reports circular dependencies correctly

---

### Category E: State & Session Patterns (2 tests)

#### Test T19: State Persistence in Forked Context
**Pattern**: Forked skill maintains state across invocations
**Real Scenario: Incremental analysis

```yaml
---
name: incremental-analyzer
description: "Test state persistence across skill invocations"
context: fork
---

## ANALYSIS_START

You are performing incremental analysis.

**State management**:
- First invocation: Create .analysis-state.json with {phase: "discovery", findings: []}
- Subsequent invocations: Load state, continue analysis
- Final invocation: Report complete analysis

**Execute autonomously** across three invocations.

## ANALYSIS_COMPLETE
```

**Validation**: Forked skill can maintain state across separate invocations

---

#### Test T20: Multi-Session Workflow with TaskList
**Pattern**: TaskList enables cross-session workflow continuation
**Real Scenario: Long-running project migration

```yaml
---
name: migration-orchestrator
description: "Test multi-session workflow with TaskList persistence"
---

## MIGRATION_START

You are orchestrating a multi-phase migration.

**Session 1** (CLAUDE_CODE_TASK_LIST_ID set):
1. Create TaskList with migration phases
2. Mark phase-1 as IN_PROGRESS
3. Execute database-migration
4. Update task to COMPLETE
5. Report: Session 1 complete, TaskList ID: [ID]

**Session 2** (continue with same ID):
1. Load TaskList by ID
2. Verify phase-1 status
3. Mark phase-2 as IN_PROGRESS
4. Execute application-migration
5. Update task to COMPLETE
6. Report: Session 2 complete, migration finished

## MIGRATION_COMPLETE
```

**Validation**: TaskList enables workflow continuation across sessions

---

## Implementation Priority

### Phase 1: Critical Gaps (Tests T1-T5)
- **T1**: TaskList Sequential Workflow
- **T2**: TaskList Parallel Execution
- **T3**: TaskList with Forked Skills
- **T4**: TaskList Error Handling
- **T5**: Cross-Session TaskList

### Phase 2: Subagent Patterns (Tests T6-T10)
- **T6**: Subagent Skill Composition
- **T7**: Dynamic Context Injection
- **T8**: Subagent Error Recovery
- **T9**: Multi-Subagent Coordination
- **T10**: Subagent Timeout Handling

### Phase 3: Orchestration Patterns (Tests T11-T15)
- **T11**: Skill→Subagent→Skill Chain
- **T12**: Hub-and-Spoke with TaskList
- **T13**: Nested TaskList with Forked Skills
- **T14**: Error Recovery in Skill Chains
- **T15: Skill Aggregation from Subagents

### Phase 4: Advanced Nesting (Tests T16-T18)
- **T16**: Triple-Level Forking
- **T17**: Forked Skill with TaskList
- **T18**: Circular Dependency Detection

### Phase 5: State Patterns (Tests T19-T20)
- **T19**: State Persistence in Forked Context
- **T20**: Multi-Session Workflow

---

## Test Design Principles Applied

All 20 tests follow:
1. **Real conditions** - Test actual usage scenarios, not artificial ones
2. **Autonomous execution** - Complete without intervention (0-1 denials target)
3. **Specific prompts** - "Execute", "Demonstrate", "Perform" - not "Use the skill"
4. **Appropriate constraints** - High/Medium/Low freedom based on test type
5. **Clear completion markers** - Each test has ## TEST_NAME_COMPLETE
6. **Representative data** - Use real project structures, not test1.txt

---

## Success Criteria

After implementing these 20 tests:

**Coverage**:
- [ ] TaskList orchestration patterns (5 tests)
- [ ] Subagent orchestration patterns (5 tests)
- [ ] Skill-subagent orchestration (5 tests)
- [ ] Advanced nesting patterns (3 tests)
- [ ] State/session patterns (2 tests)

**Quality**:
- [ ] All tests achieve 95%+ autonomy (0-1 denials)
- [ ] All tests use realistic scenarios
- [ ] All tests have specific prompts
- [ ] All tests pass representativeness check

**Integration**:
- [ ] TaskList + skills coordination validated
- [ ] TaskList + subagents coordination validated
- [ ] Skills + subagents + TaskList full stack validated

---

## Next Actions

1. **Implement Phase 1** (T1-T5): TaskList orchestration patterns
2. **Implement Phase 2** (T6-T10): Subagent patterns
3. **Implement Phase 3** (T11-T15): Orchestration patterns
4. **Implement Phase 4** (T16-T18): Advanced nesting
5. **Implement Phase 5** (T19-T20): State patterns

**Target**: Complete validation of all orchestration and nesting patterns in Claude Code.

---

**TEST_COVERAGE_ANALYSIS_COMPLETE**
