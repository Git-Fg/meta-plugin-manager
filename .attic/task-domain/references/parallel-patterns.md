# Multi-Agent Coordination Patterns

Complete guide to coordinating multiple subagents using TaskList for parallel execution, distributed processing, and collaborative workflows.

## Overview

TaskList enables multiple subagents to work on the same task list simultaneously. Each subagent can claim tasks via the `owner` field, execute its assigned work, and update task status. This enables true distributed processing.

## Coordination Models

### Model 1: Hub-and-Spoke

**Structure**:
```
Hub (orchestrator) creates tasks
Spokes (subagents) claim and execute tasks
Hub monitors progress and aggregates results
```

**Use When**:
- Central coordination needed
- Results need aggregation
- Orchestrator manages dependencies

**Example**:
```
Hub: Creates tasks 1-10
Agent A: Claims tasks 1-3
Agent B: Claims tasks 4-6
Agent C: Claims tasks 7-9
Hub: Aggregates all results, completes task 10
```

### Model 2: Peer-to-Peer

**Structure**:
```
All subagents have equal standing
Tasks have no predefined assignment
Any subagent can claim any unclaimed task
```

**Use When**:
- Self-organizing team
- Dynamic task allocation
- No central coordinator needed

**Example**:
```
Tasks 1-10 created (no owner)
Agent A: Claims task 1, completes
Agent B: Claims task 2, completes
Agent A: Claims task 3, completes
[All agents self-organize]
```

### Model 3: Specialized Agents

**Structure**:
```
Different agent types for different tasks
Owner field indicates specialization
Agents claim tasks matching their type
```

**Use When**:
- Tasks require different specializations
- Agent types optimize execution
- Clear task categorization

**Example**:
```
plan-agent: Claims architecture tasks
general-agent: Claims implementation tasks
bash-agent: Claims command execution tasks
explore-agent: Claims analysis tasks
```

## Parallel Execution Patterns

### Pattern 1: Independent Tasks

**Scenario**: Tasks with no dependencies can run simultaneously

**Setup**:
```
Task A: "Build frontend" (no dependencies)
Task B: "Build backend" (no dependencies)
Task C: "Build database" (no dependencies)
```

**Execution**:
```
Agent A: Claims Task A, executes
Agent B: Claims Task B, executes (simultaneously with A)
Agent C: Claims Task C, executes (simultaneously with A, B)
```

**Result**: 3x speedup vs sequential execution

### Pattern 2: Parallel with Final Aggregation

**Scenario**: Independent tasks with one aggregation task

**Setup**:
```
Task A: "Analyze frontend" (no dependencies)
Task B: "Analyze backend" (no dependencies)
Task C: "Analyze database" (no dependencies)
Task D: "Generate unified report" (blocked by A, B, C)
```

**Execution**:
```
Phase 1: A, B, C execute in parallel
Phase 2: D waits for A, B, C to complete
Phase 3: D aggregates results
```

**Result**: Parallel analysis, unified output

### Pattern 3: Pipeline Parallelism

**Scenario**: Multiple stages, different tasks per stage

**Setup**:
```
Stage 1: Task A, Task B (parallel)
Stage 2: Task C, Task D (parallel, depend on A)
Stage 3: Task E (depends on C, D)
```

**Execution**:
```
Agent A: Executes Task A
Agent B: Executes Task B (parallel with A)
[Both complete]
Agent C: Executes Task C (depends on A)
Agent D: Executes Task D (depends on B)
Agent E: Executes Task E (depends on C, D)
```

**Result**: Pipeline throughput optimization

## Owner Field Strategies

### Strategy 1: Agent Type Ownership

**Pattern**: Owner indicates agent specialization

**Setup**:
```
Task: "Design architecture" → Owner: "plan-agent"
Task: "Implement feature" → Owner: "general-agent"
Task: "Run tests" → Owner: "bash-agent"
Task: "Analyze code" → Owner: "explore-agent"
```

**Claiming Logic**:
```python
if task.subject.startswith("Design"):
    agent = "plan-agent"
elif task.subject.startswith("Run"):
    agent = "bash-agent"
elif task.subject.startswith("Analyze"):
    agent = "explore-agent"
else:
    agent = "general-agent"
```

### Strategy 2: Session Ownership

**Pattern**: Owner indicates which session claimed task

**Setup**:
```
Task: "Implement feature X" → Owner: "session-1"
Task: "Implement feature Y" → Owner: "session-2"
Task: "Implement feature Z" → Owner: null (unclaimed)
```

**Claiming Logic**:
```
Session 1 scans for null owner, claims Task X
Session 2 scans for null owner, claims Task Y
Session 1 completes Task X
Session 2 completes Task Y
```

### Strategy 3: Role-Based Ownership

**Pattern**: Owner indicates functional role

**Setup**:
```
Task: "Frontend work" → Owner: "frontend-dev"
Task: "Backend work" → Owner: "backend-dev"
Task: "QA work" → Owner: "qa-tester"
Task: "DevOps work" → Owner: "devops-engineer"
```

**Claiming Logic**:
```python
if "frontend" in task.tags:
    owner = "frontend-dev"
elif "backend" in task.tags:
    owner = "backend-dev"
elif "qa" in task.tags:
    owner = "qa-tester"
```

## Coordination Protocols

### Protocol 1: Claim and Release

**Workflow**:
```
1. Agent scans for tasks with owner = null
2. Agent claims task by setting owner to itself
3. Agent executes task
4. Agent releases task by setting status = completed
```

**Implementation**:
```python
# Claim
task.owner = "agent-a"
task.status = "in_progress"

# Execute
[do work]

# Release
task.status = "completed"
```

### Protocol 2: Bidirectional Handoff

**Workflow**:
```
1. Agent A starts task, sets owner = "agent-a"
2. Agent A completes partial work
3. Agent A sets owner = "agent-b" (handoff)
4. Agent B continues work
5. Agent B completes task
```

**Use When**:
- Task requires multiple specializations
- Handoff between agent types
- Collaborative execution

### Protocol 3: Escalation

**Workflow**:
```
1. haiku agent attempts task
2. haiku agent encounters complexity beyond capability
3. haiku agent sets owner = "sonnet-agent"
4. sonnet agent continues task
5. sonnet agent may escalate to opus if needed
```

**Use When**:
- Cost optimization (start cheap, escalate if needed)
- Uncertain task complexity
- Adaptive resource allocation

## Dependency Management

### Dependency Enforcement

**Setup**:
```
Task A: "Design schema" (no dependencies)
Task B: "Implement schema" (blocked by A)
Task C: "Test schema" (blocked by B)
```

**Execution**:
```
Agent A: Claims and completes Task A
Agent B: Task B unblocked, claims and completes
Agent C: Task C unblocked, claims and completes
```

**Key**: Tasks with unmet dependencies cannot execute

### Cross-Agent Dependencies

**Scenario**: Task from Agent A blocks Task for Agent B

**Setup**:
```
Task A (Agent A): "Create API spec" (no dependencies)
Task B (Agent B): "Implement API" (blocked by A)
```

**Execution**:
```
Agent A: Completes Task A
Agent B: Sees Task A completed, Task B unblocked
Agent B: Claims and completes Task B
```

**Key**: Dependencies work across agent boundaries

## Workflow Examples

### Example 1: Full-Stack Development

**Tasks**:
```
1. "Design database schema" (plan-agent)
2. "Create backend API" (general-agent, blocked by 1)
3. "Build frontend UI" (general-agent, blocked by 1)
4. "Integrate frontend and backend" (general-agent, blocked by 2,3)
5. "Run integration tests" (bash-agent, blocked by 4)
```

**Execution**:
```
plan-agent: Completes task 1
general-agent A: Claims task 2
general-agent B: Claims task 3 (parallel with A)
general-agent A: Completes task 2
general-agent B: Completes task 3
general-agent C: Claims task 4 (unblocked)
bash-agent: Claims task 5 (blocked by 4)
general-agent C: Completes task 4
bash-agent: Task 5 unblocked, completes
```

### Example 2: Multi-Stage Validation

**Tasks**:
```
1. "Security scan" (bash-agent)
2. "Performance test" (bash-agent)
3. "Accessibility audit" (explore-agent)
4. "Compliance check" (explore-agent)
5. "Generate validation report" (general-agent, blocked by 1,2,3,4)
```

**Execution**:
```
bash-agent A: Claims task 1
bash-agent B: Claims task 2 (parallel with A)
explore-agent A: Claims task 3 (parallel with A, B)
explore-agent B: Claims task 4 (parallel with A, B, C)
[All complete in parallel]
general-agent: Task 5 unblocked, completes
```

### Example 3: Cost-Optimized Pipeline

**Tasks**:
```
1. "Quick validation" (haiku, general-agent)
2. "Detailed analysis" (sonnet, general-agent, blocked by 1)
3. "Complex design" (opus, plan-agent, blocked by 2)
4. "Implementation" (sonnet, general-agent, blocked by 3)
5. "Final validation" (haiku, bash-agent, blocked by 4)
```

**Execution**:
```
haiku-agent: Completes task 1 (finds issues)
sonnet-agent: Task 2 unblocked, completes (confirms issues)
opus-agent: Task 3 unblocked, completes (designs solution)
sonnet-agent: Task 4 unblocked, completes (implements)
haiku-agent: Task 5 unblocked, completes (validates)
```

**Result**: Cost optimization via appropriate model selection

## Claiming Algorithms

### Algorithm 1: First-Come-First-Served

```python
def claim_task(agent_id, all_tasks):
    for task in all_tasks:
        if task.owner is None and task.status == "pending":
            task.owner = agent_id
            task.status = "in_progress"
            return task
    return None  # No unclaimed tasks
```

### Algorithm 2: Specialization Matching

```python
def claim_task_by_specialization(agent_type, all_tasks):
    for task in all_tasks:
        if task.owner is None and task.status == "pending":
            if matches_specialization(task, agent_type):
                task.owner = f"{agent_type}-agent"
                task.status = "in_progress"
                return task
    return None
```

### Algorithm 3: Priority-Based

```python
def claim_highest_priority_task(agent_id, all_tasks):
    # Sort by priority (metadata.priority)
    sorted_tasks = sort_by_priority(all_tasks)
    for task in sorted_tasks:
        if task.owner is None and task.status == "pending":
            task.owner = agent_id
            task.status = "in_progress"
            return task
    return None
```

## Synchronization Patterns

### Pattern 1: Barrier Synchronization

**Scenario**: Multiple agents must complete before proceeding

**Setup**:
```
Task A, Task B, Task C (parallel, no dependencies)
Task D (blocked by A, B, C)
```

**Behavior**: Task D waits for A, B, C all complete

### Pattern 2: Pipeline Synchronization

**Scenario**: Sequential stages with parallel tasks within stages

**Setup**:
```
Stage 1: Task A, Task B (parallel)
Stage 2: Task C (blocked by A), Task D (blocked by B)
Stage 3: Task E (blocked by C, D)
```

**Behavior**: Each stage waits for previous stage

### Pattern 3: Producer-Consumer

**Scenario**: One agent produces work, another consumes

**Setup**:
```
Task A: "Generate test data" (producer)
Task B: "Run tests with data" (consumer, blocked by A)
```

**Behavior**: Consumer waits for producer

## Advanced Patterns

### Pattern 1: Dynamic Task Creation

**Scenario**: Agent creates new tasks during execution

**Workflow**:
```
Task A: "Analyze requirements"
[During execution, discovers 3 sub-tasks]
Creates Task A1, A2, A3
Task B: "Implement feature" (blocked by A1, A2, A3)
```

### Pattern 2: Adaptive Agent Selection

**Scenario**: Task complexity determines agent type

**Workflow**:
```
Task: "Build feature" (owner = null)
Agent evaluates complexity:
  - Simple → Claim with haiku
  - Medium → Claim with sonnet
  - Complex → Claim with opus
```

### Pattern 3: Fault Tolerance

**Scenario**: Agent fails, task reassigned

**Workflow**:
```
Task A: Owner = "agent-1", status = "in_progress"
[Agent-1 crashes or times out]
Monitor detects stale in_progress
Task A: Owner = "agent-2", status = "pending"
Agent-2 retries task
```

## Best Practices

### 1. Use Descriptive Owner Values

**Good**:
```
"frontend-session-1"
"qa-automation-agent"
"plan-architect-session"
```

**Poor**:
```
"agent"
"session"
"me"
```

### 2. Check Dependencies Before Claiming

**Good**:
```python
if can_execute(task, agent_capabilities):
    claim(task)
```

**Poor**:
```python
claim(task)  # May claim task you can't execute
```

### 3. Update Status Promptly

**Good**:
```python
task.status = "in_progress"  # Immediate claim
[do work]
task.status = "completed"  # Immediate completion
```

**Poor**:
```python
task.owner = "agent-1"
[do work]
[long delay]
task.status = "completed"  # Stale status
```

### 4. Handle Failed Claims

**Good**:
```python
try:
    claim_task(task)
except ClaimFailed:
    log_failure()
    release_task(task)  # Make available for others
```

## Troubleshooting

### Issue: Task Starvation

**Symptoms**: Task never claimed, stays pending forever

**Causes**:
- No agent capable of executing task
- Task dependencies never satisfied
- Owner value mismatch

**Solutions**:
- Verify agent capabilities match task requirements
- Check dependency configuration
- Use consistent owner naming

### Issue: Duplicate Claims

**Symptoms**: Multiple agents claim same task

**Causes**:
- Race condition in claiming
- Owner field not atomic
- Concurrent updates

**Solutions**:
- Use atomic compare-and-swap
- Add retry logic with backoff
- Accept occasional conflicts (harmless)

### Issue: Deadlock

**Symptoms**: Two tasks waiting for each other

**Causes**:
- Circular dependencies
- Cross-task blocking

**Solutions**:
- Design dependency DAG carefully
- Avoid circular dependencies
- Add timeout mechanisms

## Summary

**Key Concepts**:
1. Owner field assigns tasks to agents
2. Multiple agents work on same task list
3. Dependencies enforce execution order
4. Parallel execution for independent tasks
5. Agent specialization optimizes execution

**Coordination Models**:
- Hub-and-spoke: Central coordinator
- Peer-to-peer: Self-organizing
- Specialized agents: Task-type matching

**Parallel Patterns**:
- Independent tasks: True parallelism
- Parallel + aggregation: Pipeline
- Pipeline parallelism: Stage optimization

**Protocols**:
- Claim and release: Basic lifecycle
- Bidirectional handoff: Collaboration
- Escalation: Adaptive resource allocation

**Result**: Distributed processing with TaskList coordination
