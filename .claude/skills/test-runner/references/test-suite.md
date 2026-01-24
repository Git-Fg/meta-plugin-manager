# Master Test Suite Structure

The master test plan (`tests/skill_test_plan.json`) defines comprehensive testing across multiple phases.

## Test Suite Overview

**Total Tests**: 67 tests across 11 phases
**Coverage**: Skill interactions, context forking, TaskList workflows
**Version**: 8.0
**Last Updated**: 2026-01-23

## Key Findings (from actual test results)

- **Critical Discovery 1**: Regular skill chains are one-way handoffs - control never returns
- **Critical Discovery 2**: Forked skills enable subroutine pattern - isolated execution with control return
- **Critical Discovery 3**: Context isolation is complete - parameters pass but context doesn't
- **Critical Discovery 4**: Forked skills are 100% autonomous - 0 permission denials across all tests
- **Critical Discovery 5**: Custom subagents and specialized tools accessible in forked context
- **Critical Discovery 6**: Double-fork (nested forks) works correctly
- **Critical Discovery 7**: TaskList tools added as built-in orchestration primitives (Layer 0)

## Test Phases Structure

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

### Phase 8-11: TaskList and Recursive Workflows (51 tests)
**Goal**: Comprehensive coverage of TaskList nested workflows
**Focus**: Recursive vs TaskList patterns, dependency management
**Duration**: ~3 hours

## Recursive Workflow Taxonomy

### Type 1: Linear Chain
**Pattern**: `skill-a → skill-b → skill-c`
- Control transfers permanently (one-way handoff)
- No control return to original skill

### Type 2: Forked Subroutine
**Pattern**: `skill-a → forked-skill (isolated) → skill-a resumes`
- Control returns to caller
- Forked skill has isolated context
- Parameters pass via args

### Type 3: Nested Forks
**Pattern**: `forked-a → forked-b → forked-a resumes`
- Each level isolated
- Control returns properly at each level
- Validated in testing

### Type 4: Hub-and-Spoke
**Pattern**: Hub skill → multiple forked workers → Hub aggregates
- Hub orchestrates
- Workers execute in isolation
- Hub must use `context: fork` for ALL workers to aggregate results

### Type 5: TaskList Orchestrated
**Pattern**: TaskList → TaskCreate → TaskUpdate → TaskList
- Built-in orchestration primitives
- Dependency tracking
- Multi-session support

## Test Suite Categories

### Discovery Tests
- Verify skill loading
- Check tool availability
- Validate YAML frontmatter

### Interaction Tests
- Regular → Regular chains
- Regular → Forked workflows
- Forked → Forked nested execution

### Isolation Tests
- Context preservation in regular skills
- Context isolation in forked skills
- Parameter passing validation

### Tool Tests
- Built-in tool access from forks
- Custom subagent access
- TaskList tool verification

### Autonomy Tests
- Permission denial scoring
- Question detection
- Self-completion verification

### Error Tests
- Failure propagation
- Recovery mechanisms
- Timeout handling

### Performance Tests
- Parallel execution
- Concurrent workflows
- Resource utilization

## Test Execution Strategy

### Sequential Execution (Phases 1-7)
Complete phases in order to build understanding:
1. Start with basic calling patterns
2. Progress to forked contexts
3. Add complexity gradually
4. Validate each phase before proceeding

### Parallel Execution (Phases 8-11)
Use TaskList for distributed testing:
- Multiple test workers
- Real-time synchronization
- Cross-phase validation

## Test Validation Checklist

### Per-Test Validation
- [ ] NDJSON structure correct (3 lines)
- [ ] All completion markers present
- [ ] Autonomy score ≥80%
- [ ] No unexpected errors
- [ ] Context behaves as expected

### Per-Phase Validation
- [ ] All tests pass
- [ ] Patterns identified
- [ ] Discoveries documented
- [ ] Mental model updated

### Suite-Level Validation
- [ ] All phases complete
- [ ] Key questions answered
- [ ] Findings catalogued
- [ ] Best practices derived

## Expected Deliverables

After complete test suite execution:

1. **Test Results Document** - All 67 test outputs
2. **Findings Summary** - 7 key discoveries
3. **Pattern Catalog** - 5 workflow types validated
4. **Mental Model** - Updated understanding
5. **Best Practices** - How to use skills effectively
6. **Anti-Patterns** - What to avoid
7. **Test Suite Documentation** - How to run tests

## Test Execution Example

```bash
# Run entire test suite
test-runner "Execute all tests" tests/raw_logs/

# Run specific phase
test-runner "Execute Phase 2" tests/raw_logs/phase_2/

# Run single test
test-runner "Execute test-2.3" tests/raw_logs/phase_2/test_2_3_forked_subagent.json

# Analyze results
test-runner "Analyze" tests/test_2_3/test-output.json
```

## Gap Analysis

**Identified Gaps** (from test plan):
- NESTED TASKLIST workflows not fully covered (added 19 new tests)
- Comparative analysis of recursive vs TaskList patterns needed
- Complete coverage of all TaskList nested workflows

**Resolution**:
- Added Phase 11: 38 comparative tests for COMPLETE TaskList analysis
- Comprehensive coverage of recursive vs TaskList patterns
- Full validation of TaskList dependency management

## Success Criteria

### Framework Success
- All 67 tests executed
- All phases completed
- All key questions answered
- All gaps addressed

### Quality Success
- Test success rate ≥90%
- Autonomy scores ≥80%
- No critical failures
- Pattern validation complete

### Documentation Success
- Findings captured
- Patterns catalogued
- Best practices documented
- Anti-patterns identified
