# Multi-Session Collaboration

Complete guide to real-time collaboration across multiple Claude Code sessions using TaskList.

## Overview

Multiple Claude Code sessions can collaborate on the same Task List in **real-time**. When one session updates a task, that change is immediately broadcasted to all other sessions working on the same task list.

## Real-Time Synchronization

### How It Works

**Broadcast Mechanism**:
- All sessions with same CLAUDE_CODE_TASK_LIST_ID connect to same task list
- When any session updates a task, change is written to task JSON file
- Other sessions detect file change and reload task state
- Result: All sessions see updates immediately

**Filesystem as Bus**:
```
~/.claude/tasks/shared-project/tasks/
├── task-1.json  [Session A updates]
├── task-2.json  [Session B updates]
└── task-3.json  [Session A updates]

Both sessions see all changes immediately
```

### Synchronization Timeline

```
Time 00:00 - Session A starts with CLAUDE_CODE_TASK_LIST_ID=shared
Time 00:05 - Session A creates Task 1
Time 00:10 - Session B starts with CLAUDE_CODE_TASK_LIST_ID=shared
Time 00:11 - Session B sees Task 1 (loaded from filesystem)
Time 00:15 - Session B claims Task 1, updates owner
Time 00:16 - Session A sees Task 1 owner change (reloaded)
Time 00:20 - Session A creates Task 2, Task 3
Time 00:21 - Session B sees Task 2, Task 3
Time 00:25 - Session B completes Task 1
Time 00:26 - Session A sees Task 1 completed
```

## When to Use Multi-Session Collaboration

### Use Multi-Session When:

1. **Team Collaboration**: Multiple people working on same project
2. **Parallel Execution**: Different sessions handle different tasks
3. **Distributed Processing**: Divide work across multiple Claude instances
4. **Real-Time Coordination**: Need immediate visibility of changes
5. **Specialized Sessions**: Different sessions optimized for different work types

### Examples

**Example 1: Team Development**
```
Session A (Developer A): Implement frontend features
Session B (Developer B): Implement backend features
Shared task list: Full project task breakdown

Both see each other's progress in real-time
```

**Example 2: Parallel Validation**
```
Session A: Run security audit
Session B: Run performance tests
Session C: Run accessibility checks
Shared task list: Validation tasks

All results visible to all sessions immediately
```

**Example 3: Specialized Workflows**
```
Session A (Plan agent): Architecture design
Session B (General agent): Implementation
Session C (Bash agent): Build and deploy
Shared task list: Project phases

Each session claims tasks matching its specialization
```

## Setting Up Multi-Session Collaboration

### Basic Setup

**Terminal 1 (Session A)**:
```bash
CLAUDE_CODE_TASK_LIST_ID=shared-project claude
```

**Terminal 2 (Session B)**:
```bash
CLAUDE_CODE_TASK_LIST_ID=shared-project claude
```

**Result**: Both sessions connected to same task list

### Verification

**In Session A**:
```
Create task: "Task from Session A"
List tasks: Should see "Task from Session A"
```

**In Session B** (within seconds):
```
List tasks: Should see "Task from Session A"
Create task: "Task from Session B"
```

**In Session A** (within seconds):
```
List tasks: Should see both "Task from Session A" and "Task from Session B"
```

## Collaboration Patterns

### Pattern 1: Task Claiming

**Scenario**: Multiple sessions, tasks need assignment

**Workflow**:
```
Session A: Creates 10 tasks for project
Session B: Claims tasks 1-5 (updates owner to "Session B")
Session A: Sees tasks 1-5 claimed, works on tasks 6-10
Session B: Completes tasks 1-5
Session A: Sees tasks 1-5 completed, continues work
```

**Task Claiming**:
```markdown
Task: "Implement feature X"
Owner: null (unclaimed)

Session B updates:
Task: "Implement feature X"
Owner: "Session B"
Status: in_progress
```

### Pattern 2: Parallel Execution

**Scenario**: Independent tasks can run simultaneously

**Workflow**:
```
Session A: Claims Task A, Task B
Session B: Claims Task C, Task D
Session A: Works on Task A, Task B in parallel
Session B: Works on Task C, Task D in parallel
Both complete independently
Both see each other's completion
```

**Key**: No dependencies between Task A/B and Task C/D

### Pattern 3: Sequential Handoff

**Scenario**: Task must pass between sessions

**Workflow**:
```
Session A: Completes Task 1
Session B: Sees Task 1 completed
Session B: Starts Task 2 (depends on Task 1)
Session A: Sees Task 2 in progress
```

**Key**: Dependencies enforced across sessions

### Pattern 4: Specialized Sessions

**Scenario**: Different sessions have different capabilities

**Workflow**:
```
Session A (Plan agent): Claims architecture tasks
Session B (General agent): Claims implementation tasks
Session C (Bash agent): Claims command execution tasks

Each session claims tasks matching its specialization
Owner field indicates which session should handle each task
```

## Owner Field Usage

### Setting Owner

**When Creating Tasks**:
```markdown
Task: "Implement feature X"
Owner: "Session A"  # Claim this task for Session A
```

**When Updating Tasks**:
```markdown
Task: "Implement feature X"
Owner: "Session B"  # Transfer from Session A to Session B
Status: in_progress
```

### Owner Semantics

| Owner Value | Meaning |
|-------------|---------|
| `null` | Unclaimed, any session can claim |
| `"Session A"` | Claimed by Session A |
| `"plan-agent"` | Claimed by session with plan agent |
| `"bash-worker"` | Claimed by bash-optimized session |

**Best Practice**: Use descriptive owner values indicating session type or identifier

## Conflict Resolution

### Concurrent Updates

**Scenario**: Both sessions update same task simultaneously

**What Happens**:
- Last write wins (filesystem semantics)
- Earlier update may be overwritten

**Mitigation Strategies**:

**Strategy 1: Task Division**
```
Assign different tasks to different sessions
Minimize concurrent updates to same task
```

**Strategy 2: Owner Field**
```
Use owner field to claim tasks
Only owner should update task status
```

**Strategy 3: Communication**
```
Use task descriptions to coordinate
Document intended changes before making them
```

### Race Conditions

**Scenario**: Session A and Session B both claim unclaimed task

**What Happens**:
- Both set owner to themselves
- Whichever update writes last wins

**Mitigation**:
- Check owner before claiming
- Use descriptive coordination in task descriptions
- Accept occasional race conditions as harmless

## Best Practices

### 1. Use Descriptive Owner Values

**Good** (clear identification):
```markdown
Owner: "frontend-dev-session"
Owner: "backend-api-session"
Owner: "qa-tester-session"
```

**Poor** (ambiguous):
```markdown
Owner: "session"
Owner: "me"
Owner: null
```

### 2. Document Handoffs

**Good** (clear handoff):
```markdown
Task: "Implement API integration"
Owner: "Session A"
Status: completed
Description: "OAuth flow implemented. Session B: Add error handling.
See session-1-decisions.md for implementation notes."
```

**Poor** (no handoff context):
```markdown
Task: "Implement API integration"
Owner: "Session A"
Status: completed
Description: "Done"
```

### 3. Coordinate Via Task Descriptions

**Good** (coordinated):
```markdown
Task: "Database migration"
Description: "Session A: Designed migration schema.
Session B: Implement migration script.
Session C: Test migration in staging.
Coordination: B waits for A, C waits for B."
```

**Poor** (uncoordinated):
```markdown
Task: "Database migration"
Description: "Migrate database"
```

### 4. Use Dependencies for Coordination

**Good** (coordinated via dependencies):
```markdown
Task 1: "Design schema"
Status: completed
Blocked by: []

Task 2: "Implement migration"
Status: pending
Blocked by: ["Task 1"]

Task 3: "Test migration"
Status: pending
Blocked by: ["Task 2"]

Result: Automatic coordination across sessions
```

## Real-World Scenarios

### Scenario 1: Pair Programming

**Setup**:
```
Session A (Driver): Writes code
Session B (Navigator): Reviews and guides
```

**Workflow**:
```
Task: "Implement feature X"
Owner: "Session A"

Session A: Implements feature
Session B: Reviews implementation
Task: "Code review for feature X"
Owner: "Session B"

Both see each other's progress
```

### Scenario 2: Team Development

**Setup**:
```
Session A (Frontend): UI components
Session B (Backend): API endpoints
Session C (DevOps): Deployment pipeline
```

**Workflow**:
```
Task A: "Build login form" → Owner: Session A
Task B: "Create auth endpoint" → Owner: Session B
Task C: "Deploy to staging" → Owner: Session C

All sessions see overall project progress
Dependencies: Task C waits for A and B
```

### Scenario 3: Continuous Validation

**Setup**:
```
Session A: Development work
Session B: Continuous testing
Session C: Security monitoring
```

**Workflow**:
```
Session A: Completes feature
Session B: Automatically runs tests
Session C: Automatically scans for security issues

All sessions see validation results
Features flagged if tests/security fail
```

## Limitations

### No Built-in Conflict Detection

**Current Behavior**: Last write wins

**Workaround**: Use owner field and task descriptions to coordinate

### No Direct Session Communication

**Current Behavior**: Sessions only communicate via task list

**Workaround**: Document decisions in task descriptions, use shared artifacts

### No Presence Detection

**Current Behavior**: Can't see which sessions are active

**Workaround**: Use owner field updates to indicate activity

## Troubleshooting

### Issue: Changes Not Visible

**Symptoms**: Session B doesn't see Session A's updates

**Solutions**:
1. Verify both use same CLAUDE_CODE_TASK_LIST_ID (exact match)
2. Check task files exist: `ls ~/.claude/tasks/[id]/`
3. Wait a few seconds for file system propagation
4. Use TaskList to refresh task state

### Issue: Stale Updates

**Symptoms**: Seeing old task state

**Solutions**:
1. Use TaskList to reload tasks
2. Check task file modification times
3. Verify no caching issues

### Issue: Owner Conflicts

**Symptoms**: Multiple sessions claim same task

**Solutions**:
1. Use task descriptions to coordinate claiming
2. Check owner before claiming
3. Accept occasional conflicts as harmless

## Advanced Patterns

### Pattern: Role-Based Sessions

**Setup**:
```
Session A (Architect): Plan agent, design tasks
Session B (Builder): General agent, implementation tasks
Session C (Tester): Explore agent, validation tasks
```

**Coordination**:
```
Task owner indicates role: "architect", "builder", "tester"
Each session claims tasks matching its role
```

### Pattern: Swarm Execution

**Setup**:
```
Session A: Claims Task 1
Session B: Claims Task 2
Session C: Claims Task 3
All tasks independent, run in parallel
```

**Result**: Distributed processing across sessions

### Pattern: Supervised Learning

**Setup**:
```
Session A (Supervisor): Creates and assigns tasks
Session B, C, D (Workers): Claim and complete tasks
Session A monitors progress, provides guidance
```

**Coordination**:
```
Supervisor creates tasks with null owner
Workers claim tasks by setting owner
Supervisor sees all progress in real-time
```

## Summary

**Key Concepts**:
1. Multiple sessions share task list via CLAUDE_CODE_TASK_LIST_ID
2. Updates broadcast to all sessions via filesystem
3. Owner field coordinates task assignment
4. Dependencies enforce coordination across sessions
5. Task descriptions document handoffs

**Benefits**:
- Real-time collaboration
- Parallel execution
- Distributed processing
- Team coordination
- Specialized workflows

**When to Use**:
- Team projects
- Parallel validation
- Distributed processing
- Real-time coordination
- Specialized session types

**Result**: Multiple Claude sessions working together seamlessly
