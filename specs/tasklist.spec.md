# TaskList Specification

## Summary
This specification defines the TaskList workflow orchestration system as Layer 0 - the fundamental primitive for complex, multi-session workflows exceeding autonomous state tracking.

## TaskList Layer Architecture

### Layer 0: Workflow State Engine
TaskList operates as Layer 0 - the fundamental primitive for complex workflows that:
- Span multiple sessions through context window boundaries
- Enable indefinitely long projects
- Provide multi-session collaboration with real-time updates
- Coordinate dependencies between complex steps

### Relationship to Skills
- **TaskList (Layer 0)**: Orchestrates complex workflows
- **Skills (Layer 2)**: Execute domain-specific tasks
- **NOT on same layer**: TaskList enables indefinitely long projects; skills implement functionality

## Given-When-Then Acceptance Criteria

### G1: Context Window Spanning
**Given** a workflow that exceeds context window limits
**When** the conversation approaches the limit
**Then** it MUST:
- Set `CLAUDE_CODE_TASK_LIST_ID` for persistence
- Save current state to TaskList
- Resume in new session with same ID
- Continue where previous session left off

**Example Workflow**:
```
Session 1: Create tasks, execute first 5
Session 1 → Context window fills
Session 2: Set CLAUDE_CODE_TASK_LIST_ID=same-id
Session 2: TaskList auto-resumes from task 6
```

### G2: Multi-Session Collaboration
**Given** two sessions working on same TaskList
**When** one session updates a task
**Then** it MUST:
- Broadcast changes to all sessions
- Synchronize in real-time
- Maintain consistency across all sessions
- Use owner field to assign specific tasks

### G3: Skill Integration
**Given** a skill needs complex orchestration
**When** workflow has 5+ steps with dependencies
**Then** it SHOULD:
- Create TaskList for orchestration
- Define dependencies between tasks
- Track progress visually (Ctrl+T)
- Persist across sessions if needed

### G4: Subagent Coordination
**Given** distributed work across subagents
**When** spawning subagents for parallel work
**Then** it MUST:
- Use TaskList owner field to assign tasks
- Coordinate multiple subagents on same TaskList
- Track subagent progress and results
- Aggregate outputs when complete

### G5: Dependency Tracking
**Given** sequential steps in workflow
**When** step B depends on step A
**Then** it MUST:
- Block task B until task A completes
- Use dependency tracking primitives
- Prevent skipping critical steps
- Show visual progress with blockers

## TaskList Workflow Types

### Type 1: Context Spanning (REQUIRED)
**Pattern**: Session breaks, TaskList continues
**Implementation**: Set `CLAUDE_CODE_TASK_LIST_ID`
**Example**:
```
Long-running project spanning days
Task 1-10: First session
Context fills → Save state
Session 2: Resume task 11-20
```

### Type 2: Multi-Session Collaboration (REQUIRED)
**Pattern**: Multiple sessions work simultaneously
**Implementation**: Real-time synchronization
**Example**:
```
Terminal 1: Task 1-5
Terminal 2: Task 6-10 (sees Terminal 1 updates live)
Terminal 1: Updates task 3 → Broadcast to Terminal 2
```

### Type 3: Nested TaskList (CRITICAL - UNKNOWN STATUS)
**Pattern**: TaskList-A creates TaskList-B
**Implementation**: UNKNOWN - requires implementation
**Test Coverage**: 11.11-11.15 (NEW)
**Requirements**:
- Parent TaskList can spawn child TaskList
- Child TaskList completes before parent continues
- Proper state isolation between levels
- Error handling for nested failures

### Type 4: TaskList by Skill (CRITICAL - UNKNOWN STATUS)
**Pattern**: Skills create their own TaskLists
**Implementation**: UNKNOWN - requires implementation
**Test Coverage**: 11.16-11.18 (NEW)
**Requirements**:
- Skill determines when to create TaskList
- Skill manages TaskList lifecycle
- Skill uses TaskList for its complex workflows
- TaskList integrates with skill autonomy

### Type 5: TaskList by Subagent (HIGH - UNKNOWN STATUS)
**Pattern**: Subagents use TaskList for coordination
**Implementation**: UNKNOWN - requires implementation
**Test Coverage**: 11.19 (NEW)
**Requirements**:
- Subagent can create TaskList
- TaskList coordinates subagent work
- Proper integration with subagent tools
- State persistence across subagent invocations

### Type 6: TaskList Errors (HIGH - UNKNOWN STATUS)
**Pattern**: Error handling for TaskList failures
**Implementation**: UNKNOWN - requires implementation
**Test Coverage**: 11.20-11.23 (NEW)
**Requirements**:
- Handle task failure gracefully
- Retry mechanisms for transient failures
- Error propagation to parent workflows
- Dead task detection and cleanup

### Type 7: TaskList Performance (MEDIUM - UNKNOWN STATUS)
**Pattern**: Performance optimization and stress testing
**Implementation**: UNKNOWN - requires implementation
**Test Coverage**: 11.26-11.28 (NEW)
**Requirements**:
- Benchmark TaskList operations
- Optimize for large task counts
- Memory management for long-running workflows
- Performance monitoring and alerting

## Input/Output Examples

### Example 1: Context Spanning
**Input**: Long-running workflow
```
Project requires 50 steps across multiple days
```

**Process**:
```
Day 1: Create TaskList ID=my-project
Day 1: Execute tasks 1-15
Day 1: Context fills, save state

Day 2: Set CLAUDE_CODE_TASK_LIST_ID=my-project
Day 2: Resume from task 16
```

**Output**:
```
Task 1-15: COMPLETED (Day 1)
Task 16-30: COMPLETED (Day 2)
Task 31-50: PENDING
```

### Example 2: Subagent Coordination
**Input**: Distributed analysis
```
Analyze 10 codebases in parallel
```

**Process**:
```
Create TaskList with 10 tasks
Assign each to different subagent
Owner field: subagent-1, subagent-2, etc.
Monitor progress in real-time
```

**Output**:
```
Task 1 (subagent-1): COMPLETED - /repo/1 analyzed
Task 2 (subagent-2): COMPLETED - /repo/2 analyzed
...
Task 10 (subagent-10): IN_PROGRESS
```

### Example 3: Skill-Created TaskList
**Input**: Complex quality audit
```
Audit 50 files across 5 dimensions
```

**Process**:
```
Quality Audit Skill determines complexity
Creates TaskList for orchestration
Skill manages TaskList execution
Skill aggregates final results
```

**Output**:
```
TaskList created by skill
50 audit tasks completed
Summary report generated
Quality score: 85/100
```

## Edge Cases and Error Conditions

### E1: Orphaned TaskLists
**Condition**: TaskList ID set but no tasks exist
**Error**: `TASKLIST_NOT_FOUND` - TaskList may have been cleaned up
**Resolution**: Create new TaskList or recover from backup

### E2: Dependency Deadlocks
**Condition**: Circular dependencies between tasks
**Error**: `DEPENDENCY_DEADLOCK` - Tasks block each other indefinitely
**Resolution**: Break circular dependency, restructure workflow

### E3: Session Collision
**Condition**: Two sessions modify same task simultaneously
**Error**: `CONFLICT` - Last writer wins, potential data loss
**Resolution**: Use owner field to partition work

### E4: Nested TaskList Failure
**Condition**: Child TaskList fails to complete
**Error**: `NESTED_TASKLIST_ERROR` - Parent cannot continue
**Resolution**: Handle child failure, retry or skip

## "Unhobbling" Principle

### Rationale
TodoWrite was removed because newer models handle simple tasks autonomously. TaskList exists specifically for **complex projects exceeding autonomous state tracking**.

### Threshold Decision
**Question**: "Would this exceed Claude's autonomous state tracking?"
- **Yes**: Use TaskList for orchestration
- **No**: Use skills directly

### Examples

#### Use TaskList (Complex)
- Multi-day projects with dependencies
- Complex workflows with 5+ steps
- Work requiring context spanning
- Multi-session collaboration

#### Don't Use TaskList (Simple)
- 2-3 step workflows
- Session-bound work
- Simple autonomous tasks
- One-shot operations

## Implementation Guidelines

### When to Use TaskList
1. **Complexity**: 5+ steps with dependencies
2. **Persistence**: Must survive context boundaries
3. **Collaboration**: Multiple sessions working together
4. **Scale**: Long-running, large-scale projects

### How to Use TaskList
1. **Create**: Define tasks with dependencies
2. **Assign**: Use owner field for subagent coordination
3. **Track**: Monitor progress visually
4. **Persist**: Set CLAUDE_CODE_TASK_LIST_ID for multi-session
5. **Coordinate**: Use blocking for sequential steps

### Natural Language Citations (CRITICAL)
**ALWAYS use natural language** when describing TaskList:
- ✅ "Validation must complete before optimization"
- ✅ "Scan structure first, then validate components"
- ❌ Don't provide code examples like TaskCreate()

**Why**: TaskList is fundamental primitive; Claude already knows how to use it

## Integration Patterns

### Pattern 1: Skill Orchestrates TaskList
**Use Case**: Complex skill needs workflow tracking
**Implementation**:
- Skill creates TaskList
- Skill executes tasks via TaskList
- Skill aggregates results
- TaskList enables progress visualization

### Pattern 2: TaskList Coordinates Subagents
**Use Case**: Distributed work across subagents
**Implementation**:
- Create TaskList with task assignments
- Set owner field to subagent IDs
- Subagents execute assigned tasks
- TaskList tracks and aggregates results

### Pattern 3: Multi-Session Project
**Use Case**: Work spanning days/weeks
**Implementation**:
- Set CLAUDE_CODE_TASK_LIST_ID at start
- Work sessions save state to TaskList
- Resume in new sessions with same ID
- Continue until completion

## Non-Functional Requirements

### Performance
- TaskList operations complete in <1 second
- Support 100+ tasks in single TaskList
- Efficient state persistence and recovery
- Minimal memory overhead

### Reliability
- State persists across sessions
- Recovery from partial failures
- Consistent real-time synchronization
- Dead task detection and cleanup

### Security
- TaskList files stored in `~/.claude/tasks/[id]/`
- Access control via session ownership
- Secure state sharing between sessions
- No sensitive data in task descriptions

## Quality Framework Integration

### Autonomy
- TaskList enables autonomous complex workflows
- Self-managing progress and dependencies
- Automatic state persistence
- Minimal user intervention required

### Discoverability
- Clear task descriptions and dependencies
- Visual progress tracking (Ctrl+T)
- Owner field shows task assignments
- Status indicators for each task

### Maintainability
- File-based TaskList for external tooling
- Clear task boundaries and descriptions
- Dependency tracking prevents errors
- Natural language task descriptions

## Current Implementation Status

### ✅ Implemented
- Context spanning (theoretical)
- Multi-session collaboration (theoretical)
- TaskList tools as built-in primitives

### ❌ UNKNOWN STATUS (CRITICAL)
- Nested TaskList workflows (11.11-11.15)
- TaskList created by skills (11.16-11.18)
- TaskList by subagents (11.19)
- Error handling patterns (11.20-11.23)
- Performance optimization (11.26-11.28)

### 📋 Partially Implemented
- TaskList state management (11.24-11.25)
- Owner field behavior (11.29-11.33)

## Fix Priority

### Immediate (Critical)
1. Implement nested TaskList workflows
2. Add TaskList creation by skills
3. Define TaskList error handling patterns

### Short-term (High)
4. Implement TaskList by subagents
5. Add TaskList performance optimization
6. Create real-world examples

### Medium-term (Medium)
7. Benchmark and optimize performance
8. Add monitoring and alerting
9. Create TaskList debugging tools

## Out of Scope

### Not Covered by This Specification
- Skill architecture (see skills.spec.md)
- Subagent design (see subagents.spec.md)
- Testing frameworks (see quality.spec.md)
- Hooks configuration (see hooks.spec.md)

## References
- Layer 0 architecture: `.claude/rules/architecture.md`
- Quick reference: `.claude/rules/quick-reference.md`
- Test plan: `tests/skill_test_plan.json`
- TaskList workflows: Phase 11 tests
