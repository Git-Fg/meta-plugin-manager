# Context Window Spanning

Complete guide to breaking the context window limit using TaskList for indefinitely long projects.

## Overview

TaskList enables **indefinitely long projects** by allowing work to continue across multiple sessions. When a conversation fills its context window, simply start a new session with the same TaskList ID and continue where you left off.

## The Context Window Problem

### Context Window Limit

Claude Code has a finite context window per conversation:
- **Default limit**: Conversation capacity is bounded
- **When full**: Conversation must end or lose early context
- **Impact**: Long projects hit this limit
- **Traditional solution**: Start new conversation, lose all context

### Problem Scenario

```
Session 1: Start project
[Work proceeds...]
[Context window fills]
[Early conversation gets truncated]
[Continue with degraded context]
[Eventually: Context unusable]

Traditional result: Project must restart or continue with poor context
```

## TaskList Solution: Context Spanning

### How It Works

TaskList stores tasks persistently in the filesystem:
- **Location**: `~/.claude/tasks/[task-list-id]/`
- **Format**: JSON files per task
- **Persistence**: Survives session termination
- **Access**: Any session can read/write task state

### Key Mechanism

**CLAUDE_CODE_TASK_LIST_ID environment variable**:
- Set before starting Claude
- Identifies which task list to use
- Multiple sessions can share same ID
- Tasks persist across sessions

### Workflow

```
Session 1: CLAUDE_CODE_TASK_LIST_ID=my-project claude
[Work proceeds...]
[Context window fills]
[Exit session]

Session 2: CLAUDE_CODE_TASK_LIST_ID=my-project claude
[New session, fresh context window]
[Loads existing tasks from ~/.claude/tasks/my-project/]
[Continues where Session 1 left off]
[Context window fills again]
[Exit session]

Session 3: CLAUDE_CODE_TASK_LIST_ID=my-project claude
[New session, fresh context window again]
[Loads existing tasks]
[Continues where Session 2 left off]
[Project completes]

Result: Indefinitely long project possible
```

## When to Use Context Spanning

### Use Context Spanning When:

1. **Complex multi-phase projects**: Projects with 10+ phases
2. **Long-running development**: Projects spanning days/weeks
3. **Large codebases**: Extensive exploration and modification
4. **Iterative workflows**: Multiple rounds of refinement
5. **Context-heavy work**: Projects requiring lots of conversation

### Examples

**Example 1: Large Refactoring Project**
```
Phase 1: Analyze codebase structure (fills context)
Phase 2: Design refactoring strategy (fills context)
Phase 3: Implement changes (fills context)
Phase 4: Validate and test (fills context)
Phase 5: Documentation and cleanup

Total: 5+ sessions needed
```

**Example 2: Multi-Feature Implementation**
```
Feature A: Design, implement, test (fills context)
Feature B: Design, implement, test (fills context)
Feature C: Design, implement, test (fills context)
Feature D: Design, implement, test (fills context)

Total: 4+ sessions needed
```

**Example 3: Architecture Evolution**
```
Iteration 1: Initial architecture (fills context)
Iteration 2: Refine based on feedback (fills context)
Iteration 3: Major redesign (fills context)
Iteration 4: Optimization passes (fills context)

Total: 4+ sessions needed
```

## Setting Up Context Spanning

### Basic Setup

**Step 1**: Choose a task list ID
```bash
export TASK_ID=my-project
```

**Step 2**: Start Claude with task list ID
```bash
CLAUDE_CODE_TASK_LIST_ID=$TASK_ID claude
```

**Step 3**: Work normally until context fills

**Step 4**: Exit and start new session with same ID
```bash
CLAUDE_CODE_TASK_LIST_ID=$TASK_ID claude
```

**Step 5**: Continue where you left off

### Persistent Configuration

**Option 1: Shell alias**
```bash
alias myproject="CLAUDE_CODE_TASK_LIST_ID=my-project claude"
```

**Option 2: Environment file**
```bash
# .env.local
CLAUDE_CODE_TASK_LIST_ID=my-project

# Source before starting
source .env.local
claude
```

**Option 3: Project settings**
```json
// .claude/settings.json
{
  "env": {
    "CLAUDE_CODE_TASK_LIST_ID": "my-project"
  }
}
```

## Task State Persistence

### What Persists

**Task Metadata**:
- Task ID and subject
- Description and activeForm
- Status (pending, in_progress, completed)
- Dependencies (blockedBy)
- Owner assignment
- Creation and modification timestamps

**What DOESN'T Persist**:
- Conversation history (each session has fresh context)
- Session-specific decisions (must be documented in tasks)

### Task File Structure

```
~/.claude/tasks/
└── my-project/
    └── tasks/
        ├── task-abc123.json
        ├── task-def456.json
        └── task-ghi789.json
```

**Example task file**:
```json
{
  "subject": "Analyze codebase structure",
  "description": "Scan and document project structure",
  "status": "completed",
  "activeForm": "Analyzing codebase structure",
  "blockedBy": [],
  "owner": "session-1",
  "createdAt": "2026-01-23T10:00:00Z",
  "completedAt": "2026-01-23T11:30:00Z"
}
```

## Session Handoff Patterns

### Pattern 1: Clean Break

**When**: Natural break point reached

**Session 1**:
```
[Work completes Phase 1]
[Update task status to completed]
[Document session state in task description]
[Exit]
```

**Session 2**:
```
[Start fresh]
[Read completed tasks for context]
[Begin Phase 2]
```

### Pattern 2: Mid-Task Handoff

**When**: Context fills during active task

**Session 1**:
```
[Working on Task X]
[Context filling]
[Update Task X status: in_progress]
[Document current progress in task description]
[Exit]
```

**Session 2**:
```
[Start fresh]
[Read Task X for context]
[Continue from documented progress]
[Complete Task X]
```

### Pattern 3: Dependency Documentation

**When**: Complex dependencies between sessions

**Session 1**:
```
[Complete Task A]
[Task B depends on Task A]
[Document Task A results in Task B description]
[Exit before Task B starts]
```

**Session 2**:
```
[Read Task A results from Task B description]
[Start Task B with context from Session 1]
[Complete Task B]
```

## Best Practices

### 1. Document Task Progress

**Good** (detailed progress):
```markdown
Task: "Implement user authentication"
Status: in_progress
Description: "Implemented login form (Session 1). Need to add
OAuth integration (Session 2). Database schema ready.
See auth-schema.sql for reference."
```

**Poor** (vague progress):
```markdown
Task: "Implement user authentication"
Status: in_progress
Description: "Work in progress"
```

### 2. Use Descriptive Task Names

**Good** (specific, bounded):
```
"Implement login form UI"
"Add OAuth integration"
"Create user database schema"
```

**Poor** (vague, unbounded):
```
"Work on authentication"
"Continue auth stuff"
"More auth work"
```

### 3. Break Work into Sessions

**Good** (session-sized tasks):
```
Session 1: "Analyze requirements and design architecture"
Session 2: "Implement core features"
Session 3: "Add edge cases and error handling"
Session 4: "Testing and documentation"
```

**Poor** (oversized tasks):
```
"Build entire application"
"Do everything"
```

### 4. Reference Artifacts

**Good** (external references):
```markdown
Task: "Implement API client"
Description: "Based on API spec in docs/api-spec.md.
Use fetch-api pattern from examples/api-client.js.
See Session 1 conversation for design decisions."
```

**Poor** (no references):
```markdown
Task: "Implement API client"
Description: "Build API client"
```

## Context Spanning Anti-Patterns

### ❌ Wrong: Losing Context Between Sessions

**Problem**: Session 2 doesn't know what Session 1 decided

**Solution**: Document decisions in task descriptions

**Example**:
```markdown
Task: "Choose authentication method"
Description: "Session 1 decided on OAuth 2.0.
See AUTH_DECISIONS.md for rationale.
Session 2: Implement using chosen method."
```

### ❌ Wrong: Oversized Tasks

**Problem**: Task too large to complete in one session

**Solution**: Break into session-sized subtasks

**Example**:
```markdown
Bad: "Build entire application"

Good:
- "Design architecture" (Session 1)
- "Implement core features" (Session 2)
- "Add polish and testing" (Session 3)
```

### ❌ Wrong: No Task List ID

**Problem**: Each session creates new task list

**Solution**: Always use same CLAUDE_CODE_TASK_LIST_ID

**Example**:
```bash
# Bad: Each session is isolated
claude  # Session 1
claude  # Session 2 (new task list!)

# Good: Same task list across sessions
CLAUDE_CODE_TASK_LIST_ID=my-project claude  # Session 1
CLAUDE_CODE_TASK_LIST_ID=my-project claude  # Session 2 (same list!)
```

## Advanced Patterns

### Pattern: Checkpoint System

Use tasks as checkpoints for complex workflows:

```
Checkpoint 1: "Requirements validated"
Checkpoint 2: "Architecture designed"
Checkpoint 3: "Core features implemented"
Checkpoint 4: "Testing complete"
Checkpoint 5: "Documentation ready"

Each checkpoint = Session boundary potential
```

### Pattern: Rollback Recovery

Document task state for recovery from issues:

```
Task: "Implement feature X"
Status: in_progress
Description: "Session 1: Completed UI. Session 2: Hit bug
in data layer. Rollback to Session 1 state, re-approach
data layer differently."
```

### Pattern: Parallel Session Tracks

Multiple independent workstreams:

```
Track A (feature-1): CLAUDE_CODE_TASK_LIST_ID=feature-1
Track B (feature-2): CLAUDE_CODE_TASK_LIST_ID=feature-2
Track C (feature-3): CLAUDE_CODE_TASK_LIST_ID=feature-3

Each track has independent session progression
```

## Verification

### Test Context Spanning

**Step 1**: Create task list
```bash
CLAUDE_CODE_TASK_LIST_ID=test-spanning claude
```

**Step 2**: Create tasks in Session 1
```
Create task: "Task A"
Mark complete: "Task A"
Exit session
```

**Step 3**: Resume in Session 2
```bash
CLAUDE_CODE_TASK_LIST_ID=test-spanning claude
```

**Step 4**: Verify tasks persist
```
List tasks: Should see "Task A" completed
Create task: "Task B"
```

**Step 5**: Verify in new session
```bash
CLAUDE_CODE_TASK_LIST_ID=test-spanning claude
```

**Step 6**: Verify both tasks exist
```
List tasks: Should see "Task A" completed, "Task B" pending
```

## Troubleshooting

### Issue: Tasks Not Persisting

**Symptoms**: New session doesn't see previous tasks

**Solutions**:
1. Verify CLAUDE_CODE_TASK_LIST_ID is set
2. Check ID matches exactly (case-sensitive)
3. Confirm task files exist: `ls ~/.claude/tasks/[id]/`

### Issue: Wrong Task List

**Symptoms**: Seeing tasks from different project

**Solutions**:
1. Verify correct CLAUDE_CODE_TASK_LIST_ID
2. Use unique IDs per project
3. Check task directory: `ls ~/.claude/tasks/`

### Issue: Context Loss Between Sessions

**Symptoms**: Session 2 doesn't know Session 1 decisions

**Solutions**:
1. Document decisions in task descriptions
2. Reference external artifacts (docs, diagrams)
3. Create checkpoint tasks for major milestones

## Summary

**Key Concepts**:
1. TaskList breaks context window limit
2. CLAUDE_CODE_TASK_LIST_ID enables session continuation
3. Tasks persist in ~/.claude/tasks/[id]/
4. Document progress for smooth handoffs
5. Break work into session-sized tasks

**Benefits**:
- Indefinitely long projects possible
- No context loss between sessions
- Smooth project continuation
- Checkpoint-based workflow

**When to Use**:
- Complex multi-phase projects
- Long-running development
- Large codebase work
- Context-heavy workflows

**Result**: Projects never limited by context window
