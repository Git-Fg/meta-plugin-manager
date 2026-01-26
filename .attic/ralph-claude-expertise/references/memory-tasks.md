# Memory and Tasks System

Ralph uses two complementary systems for state management: Memories (persistent learning) and Tasks (runtime work tracking).

---

## Overview

| System | Purpose | Storage | Lifetime |
|--------|---------|---------|----------|
| **Memories** | Accumulated wisdom across sessions | `.agent/memories.md` | Persistent |
| **Tasks** | Runtime work tracking | `.agent/tasks.jsonl` | Session-based |

Both systems are enabled by default. To use legacy scratchpad-only mode, set both to `false`.

---

## Memories System

Memories provide persistent learning across Ralph sessions. They accumulate wisdom about:
- Codebase patterns and conventions
- Architectural decisions and rationale
- Recurring problem solutions
- Project-specific context

### Configuration

```yaml
memories:
  enabled: true                         # Set false to disable
  inject: auto                          # auto, manual, or none
  budget: 2000                          # Max tokens to inject (0 = unlimited)
  filter:
    types: []                           # Filter by type
    tags: []                            # Filter by tags
    recent: 0                           # Only memories from last N days (0 = no limit)
```

### Memory Types

| Type | Purpose | Example |
|------|---------|---------|
| `pattern` | Recurring code patterns | "shortcut: used X instead of Y because..." |
| `decision` | Architectural decisions | "assumption: API returns sorted results" |
| `fix` | Bug fixes and solutions | "uncertainty: not sure if edge case Z is handled" |
| `context` | Project-specific context | "convention: always use snake_case for DB columns" |

### Injection Modes

| Mode | Behavior | Use Case |
|------|----------|----------|
| `auto` | Ralph prepends memories at start of each iteration | Default, automatic context |
| `manual` | Agent must explicitly run `ralph tools memory search` | Selective memory retrieval |
| `none` | Memories disabled entirely | Scratchpad-only mode |

### Filter Examples

```yaml
# Only pattern and decision memories
memories:
  filter:
    types: ["pattern", "decision"]

# Only memories with specific tags
memories:
  filter:
    tags: ["confession", "architecture"]

# Only memories from last 7 days
memories:
  filter:
    recent: 7

# Combined filters
memories:
  filter:
    types: ["pattern", "decision"]
    tags: ["architecture"]
    recent: 30
```

### Memory Recording Patterns

Record internal monologue for self-assessment and learning:

```bash
# Decision tracking
ralph tools memory add "shortcut: used X instead of Y because..." -t decision

# Uncertainty documentation
ralph tools memory add "uncertainty: not sure if edge case Z is handled" -t context

# Assumption tracking
ralph tools memory add "assumption: API returns sorted results" -t context

# Confession reports
ralph tools memory add "confession: objective=X, met=Yes/Partial/No, evidence=file:line" -t context --tags confession
```

---

## Tasks System

Tasks provide runtime work tracking with dependency management.

### Configuration

```yaml
tasks:
  enabled: true    # Set false to use scratchpad-only mode
```

### Task Structure

```json
{
  "id": "unique-id",
  "title": "Task title",
  "status": "pending",
  "priority": 3,
  "blockedBy": ["task-id-1", "task-id-2"],
  "blocks": ["task-id-3"],
  "createdAt": "2024-01-25T10:00:00Z"
}
```

### Task Status Values

| Status | Meaning |
|--------|---------|
| `pending` | Task not yet started |
| `in_progress` | Task currently being worked on |
| `completed` | Task finished |

### Task Priority Levels

| Priority | Use Case |
|----------|----------|
| 1 | Critical blockers, must do immediately |
| 2 | High priority, urgent issues |
| 3 | Standard priority (default) |
| 4 | Low priority, nice to have |
| 5 | Backlog, defer if possible |

---

## Task Lifecycle

### Standard Workflow

```bash
# 1. List ready (unblocked) tasks
ralph tools task ready

# 2. Pick one task
# (Get task ID from output)

# 3. Set task to in_progress
ralph tools task start <id>

# 4. Implement the change
# (Do the work)

# 5. Run backpressure (tests/lint/typecheck)

# 6. Close the task
ralph tools task close <id>
```

### With Dependencies

```bash
# Create task with dependency
ralph tools task add "Implement feature X" --blocked-by <parent-task-id>

# Child task won't appear in "ready" until parent completes
ralph tools task ready  # Shows only unblocked tasks
```

---

## Scratchpad-Only Mode (Legacy)

When both memories and tasks are disabled, all hats share `.agent/scratchpad.md` for:
- Task tracking (`[ ]`, `[x]`, `[~]` markers)
- Context preservation between iterations
- Handoff between hats

```yaml
memories:
  enabled: false

tasks:
  enabled: false
```

### Scratchpad Task Format

```markdown
# Tasks

## Pending
- [ ] Task 1: Description
- [ ] Task 2: Description

## In Progress
- [~] Task 3: Description

## Completed
- [x] Task 4: Description
```

---

## Integration Patterns

### Confession Loop with Memories

The Confession Loop pattern uses memories for honest self-assessment:

```yaml
hats:
  builder:
    instructions: |
      Record internal monologue as memories:
      ```bash
      ralph tools memory add "shortcut: used X instead of Y" -t decision
      ralph tools memory add "uncertainty: not sure about Z" -t context
      ```

  confessor:
    instructions: |
      Search for confession memories:
      ```bash
      ralph tools memory search "shortcut OR uncertainty OR assumption"
      ```

      Create confession report:
      ```bash
      ralph tools memory add "confession: objective=X, met=No, evidence=file:line" -t context --tags confession
      ```
```

### Task-Driven Workflow

```yaml
hats:
  builder:
    instructions: |
      ### Process
      1. List ready tasks: `ralph tools task ready`
      2. Pick one task
      3. Implement the change
      4. Run backpressure (tests/lint/build)
      5. Close the task: `ralph tools task close <id>`
      6. Emit completion event

      ### Don't
      - Don't skip backpressure
      - Don't emit completion without closing tasks
      - Don't pick multiple tasks at once
```

---

## Best Practices

### Memories

1. **Record decisions with rationale** - Why was X chosen over Y?
2. **Document uncertainties** - What are you unsure about?
3. **Track assumptions** - What are you assuming to be true?
4. **Use tags strategically** - Group related memories for retrieval
5. **Review and prune** - Remove outdated memories periodically

### Tasks

1. **One task at a time** - Focus on single task completion
2. **Block responsibly** - Only create dependencies when necessary
3. **Close when done** - Don't leave tasks in `in_progress`
4. **Use priorities** - Mark critical tasks appropriately
5. **Keep tasks atomic** - Each task should be independently completable

---

## See Also

- `references/runtime-tools.md` - CLI commands for memory and task management
- `references/coordination-patterns.md` - Patterns that use memories/tasks
- `references/prompt-engineering.md` - Hat instruction patterns
