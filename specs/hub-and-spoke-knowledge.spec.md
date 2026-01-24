# Hub-and-Spoke Knowledge Specification

## Summary
This specification defines the hub-and-spoke pattern for skill orchestration, emphasizing the critical requirement for `context: fork` in worker skills to enable result aggregation and proper workflow coordination.

## Critical Gap: Context Fork Implementation

### Current Status
**CRITICAL VIOLATION**: 0 of 18 skills use `context: fork` despite specification emphasis

**Evidence**:
- Specification claims: "ALL delegate skills MUST use `context: fork`"
- Implementation reality: No skills implement this pattern
- Test results: Validate pattern works in isolation
- Production gap: No real-world examples exist

**Impact**:
- Hub-spoke pattern documented but not production-implemented
- Users have no examples to follow
- Spec contradicts implementation reality

## Pattern Architecture

### Hub Skill (Router)
**Characteristics**:
- Regular skill (NO `context: fork`)
- Has `disable-model-invocation: true` OR is user-invokable
- Delegates work to worker skills
- Aggregates results from workers
- Does NOT lose project context

### Worker Skills (Delegates)
**Critical Requirement**: ALL workers MUST use `context: fork`
**Characteristics**:
- Forked skills (MUST have `context: fork` in frontmatter)
- Execute in isolated context
- Cannot access hub's conversation history
- Accept parameters via $ARGUMENTS
- Return results to hub for aggregation

## Given-When-Then Acceptance Criteria

### G1: Hub Configuration
**Given** a hub skill orchestrating workers
**When** it delegates work
**Then** it MUST:
- Be a regular skill (no context: fork)
- Have disable-model-invocation: true OR user-invokable
- Call worker skills with proper parameters
- Aggregate results from ALL workers

### G2: Worker Configuration
**Given** a worker skill delegated by hub
**When** it receives work
**Then** it MUST:
- Have `context: fork` in YAML frontmatter
- Execute in isolated context (no hub conversation access)
- Accept parameters via $ARGUMENTS
- Complete with WIN CONDITION marker
- Return results to hub

### G3: Result Aggregation
**Given** hub delegates to multiple workers
**When** workers complete execution
**Then** hub MUST:
- Receive results from ALL workers
- Aggregate results into comprehensive output
- Coordinate workflow completion
- Output final WIN marker

### G4: Context Isolation
**Given** forked worker execution
**When** it runs in isolated context
**Then** it MUST NOT have access to:
- Hub's conversation history
- Hub's user preferences
- Hub's session state
- Hub's previous workflow steps

**But it MUST have access to**:
- Parameters passed via $ARGUMENTS
- Its own execution context
- Files it creates/modifies
- Available tools and skills

## Pattern Variations

### Variation 1: Simple Hub-Spoke
**Structure**:
```
Hub (regular) → Worker 1 (forked)
             → Worker 2 (forked)
             → Worker 3 (forked)
```

**Use Case**: Parallel analysis of different components
**Example**:
- Hub: Quality Audit Orchestrator
- Worker 1: Code Quality Analyzer (forked)
- Worker 2: Security Scanner (forked)
- Worker 3: Performance Monitor (forked)

### Variation 2: Multi-Level Hub-Spoke
**Structure**:
```
Main Hub (regular)
├── Sub-Hub 1 (forked)
│   ├── Worker 1.1 (forked)
│   └── Worker 1.2 (forked)
└── Sub-Hub 2 (forked)
    ├── Worker 2.1 (forked)
    └── Worker 2.2 (forked)
```

**Use Case**: Complex workflows with nested specialization
**Note**: Each Sub-Hub is also a forked worker from Main Hub

### Variation 3: Aggregating Hub
**Structure**:
```
Hub (regular)
├── Worker A (forked) → Result A
├── Worker B (forked) → Result B
└── Worker C (forked) → Result C
→ Hub aggregates A+B+C → Final Report
```

**Use Case**: Comprehensive analysis requiring synthesis
**Example**: Full project audit combining multiple dimensions

## Input/Output Examples

### Example 1: Quality Audit Hub-Spoke
**Input**: Comprehensive quality audit request
```
"Perform full quality audit on this project"
```

**Hub Execution** (Quality Audit Orchestrator):
```yaml
---
name: quality-audit-orchestrator
user-invocable: true
---

Scan project structure
Delegate to forked workers:
1. Call code-quality-worker (forked) with args="scan=comprehensive"
2. Call security-scanner-worker (forked) with args="scope=all"
3. Call performance-analyzer-worker (forked) with args="metrics=detailed"
4. Wait for all results
Aggregate findings into report
Output: ## QUALITY_AUDIT_ORCHESTRATOR_COMPLETE
```

**Worker Execution** (Code Quality Worker):
```yaml
---
name: code-quality-worker
context: fork  # CRITICAL: Enables isolation and aggregation
user-invocable: false
---

Isolated context (no access to hub's conversation)
Parse parameters from $ARGUMENTS
Execute code quality analysis
Output: ## CODE_QUALITY_WORKER_COMPLETE
```

**Final Output**:
```
# Quality Audit Report

## Code Quality Analysis
[Results from code-quality-worker]

## Security Assessment
[Results from security-scanner-worker]

## Performance Metrics
[Results from performance-analyzer-worker]

## QUALITY_AUDIT_ORCHESTRATOR_COMPLETE
```

### Example 2: Multi-Level Hub-Spoke
**Input**: Complex architecture review
```
"Review microservices architecture for scalability"
```

**Structure**:
```
Main Hub: Architecture Review Orchestrator
├── Sub-Hub: Service Layer Review (forked)
│   ├── Worker: API Gateway Analysis (forked)
│   └── Worker: Service Mesh Review (forked)
└── Sub-Hub: Data Layer Review (forked)
    ├── Worker: Database Design (forked)
    └── Worker: Cache Strategy (forked)
```

## Edge Cases and Error Conditions

### E1: Hub Without Forked Workers
**Condition**: Hub delegates to regular (non-forked) workers
**Error**: `HUB_SPOKE_VIOLATION` - Workers must fork for aggregation
**Resolution**: Add `context: fork` to ALL worker skills

### E2: Worker Missing Context Fork
**Condition**: Worker called by hub without `context: fork`
**Error**: `WORKER_CONTEXT_ERROR` - Cannot aggregate results
**Resolution**: Add `context: fork` to worker YAML frontmatter

### E3: Hub Uses Context Fork
**Condition**: Hub skill has `context: fork`
**Error**: `HUB_CONTEXT_ERROR` - Hub should be regular skill
**Resolution**: Remove `context: fork` from hub skill

### E4: Worker Accesses Hub Context
**Condition**: Worker attempts to read hub's conversation
**Error**: `CONTEXT_ISOLATION_VIOLATION` - Forked skills cannot access hub context
**Resolution**: Use parameters for data transfer only

### E5: Missing WIN Markers
**Condition**: Worker completes without WIN marker
**Error**: `SKILL_COMPLETION_ERROR` - Hub cannot detect completion
**Resolution**: Add proper WIN marker to worker skill

## Security Model

### Context Isolation
**What Workers LOSE** (cannot access):
- Hub's conversation history
- Hub's user preferences
- Hub's session state
- Hub's previous workflow steps
- Hub's project context

**What Workers RETAIN** (can access):
- Parameters via $ARGUMENTS
- Their own isolated execution context
- Files they create/modify
- Available tools and skills
- External APIs and services

### Security Boundary
**Purpose**: Complete isolation prevents:
- Unauthorized context access
- State pollution between workers
- Hub conversation contamination
- Security boundary violations

**Trade-off**: Workers cannot "see" hub's context but gain:
- Secure isolation
- Parallel execution safety
- Clean separation of concerns
- Aggregation without interference

## Implementation Guidelines

### Step 1: Identify Hub Role
**Questions**:
1. Does this skill delegate work to other skills?
2. Does it need to aggregate results?
3. Is it user-invokable or router?

**If YES to all → This is a Hub Skill**
- Make it regular (no context: fork)
- Add disable-model-invocation: true if router
- Ensure user-invokable if direct use

### Step 2: Identify Worker Roles
**Questions**:
1. Does this skill receive delegated work?
2. Does it need to return results to hub?
3. Should it run in isolation?

**If YES to all → This is a Worker Skill**
- Add `context: fork` to YAML frontmatter
- Accept parameters via $ARGUMENTS
- Output WIN marker on completion

### Step 3: Design Workflow
**Hub Design**:
1. List all workers needed
2. Define parameters for each worker
3. Plan result aggregation strategy
4. Ensure all workers use context: fork

**Worker Design**:
1. Define input parameters
2. Implement isolated execution
3. Output clear results
4. Add WIN marker

### Step 4: Implement Pattern
```yaml
# Hub Skill YAML
---
name: hub-skill-name
user-invocable: true  # OR disable-model-invocation: true
---

# Worker Skill YAML
---
name: worker-skill-name
context: fork  # CRITICAL for hub-spoke
user-invokable: false
---
```

### Step 5: Test Aggregation
1. Invoke hub skill
2. Verify all workers execute
3. Check hub receives all results
4. Confirm aggregation works
5. Validate WIN markers present

## Anti-Patterns to Avoid

### ❌ Pattern 1: Regular Skill Chain
```
Skill A → Skill B → Skill C
```
**Problem**: One-way handoff, control never returns
**Solution**: Use hub-spoke with forked workers

### ❌ Pattern 2: Hub Without Forked Workers
```
Hub (regular) → Worker (regular)
```
**Problem**: Cannot aggregate results
**Solution**: Add `context: fork` to worker

### ❌ Pattern 3: Worker as Hub
```
Worker (forked) → Sub-Worker (regular)
```
**Problem**: Forked skill should not delegate further
**Solution**: Make top-level worker a hub, sub-worker also forked

### ❌ Pattern 4: Missing Aggregation
```
Hub → Worker 1 (forked)
     → Worker 2 (forked)
     → [No aggregation code]
```
**Problem**: Results not combined
**Solution**: Add aggregation logic to hub

## Testing Strategy

### Test 1: Hub Configuration
**Verify**: Hub is regular skill, not forked
**Check**: YAML frontmatter has NO context: fork
**Expected**: Hub executes with full context

### Test 2: Worker Configuration
**Verify**: ALL workers have context: fork
**Check**: YAML frontmatter has context: fork
**Expected**: Workers execute in isolation

### Test 3: Result Aggregation
**Verify**: Hub receives results from all workers
**Check**: Aggregation logic present
**Expected**: Comprehensive output combining all results

### Test 4: Context Isolation
**Verify**: Workers cannot access hub context
**Check**: No hub conversation access
**Expected**: Complete isolation

## Quality Framework Integration

### Discoverability
- Clear pattern documentation
- Examples of hub and worker roles
- Anti-pattern warnings
- Implementation guidance

### Standards Compliance
- Follows Agent Skills specification
- Uses context: fork correctly
- Implements WIN markers
- Maintains progressive disclosure

### Maintainability
- Clear separation of hub/worker roles
- Documented pattern variations
- Easy to test and validate
- Simple refactoring path

## Current Implementation Status

### ✅ Test-Validated Patterns
- Hub-spoke works in test environment
- Context fork isolation verified
- Aggregation pattern functional
- Test results: test_6.1, test_6.2

### ❌ Production Gap
- 0 skills use context: fork
- No production hub-spoke examples
- Spec emphasizes but implementation lacks
- Users have no real-world reference

### 📋 Required Implementation
1. Create at least one hub-spoke example
2. Implement context: fork in worker skills
3. Document production use cases
4. Validate in real workflows

## Fix Priority

### Immediate (Critical)
1. **DECISION**: Determine if spec is aspirational or implementation required
2. **IMPLEMENT**: Create hub-spoke examples with context: fork
3. **MIGRATE**: Update existing skills needing pattern
4. **VALIDATE**: Test in production workflows

### Short-term (High)
5. Create hub-spoke pattern library
6. Add pattern detection tools
7. Train developers on pattern usage
8. Create anti-pattern warnings

### Medium-term (Medium)
9. Build pattern validation into quality framework
10. Add automated testing for hub-spoke
11. Create pattern troubleshooting guide
12. Document performance characteristics

## Out of Scope

### Not Covered by This Specification
- Skill architecture basics (see skills.spec.md)
- TaskList integration (see tasklist.spec.md)
- Quality framework details (see quality.spec.md)
- Testing methodologies (see quality.spec.md)

## References
- Skills spec: `specs/skills.spec.md`
- Architecture rules: `.claude/rules/architecture.md`
- Quick reference: `.claude/rules/quick-reference.md`
- Anti-patterns: `.claude/rules/anti-patterns.md`
- Test results: `tests/raw_logs/phase_6/test_6.1.json`
- Test results: `tests/raw_logs/phase_6/test_6.2.json`
