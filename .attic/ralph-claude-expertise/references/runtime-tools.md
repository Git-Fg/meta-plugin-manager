# Runtime Tools Reference

The `ralph tools` command provides utilities for memory and task management during Ralph execution.

---

## Two Task Systems

| System | Command | Purpose | Storage |
|--------|---------|---------|---------|
| **Runtime tasks** | `ralph tools task` | Track work items during runs | `.agent/tasks.jsonl` |
| **Code tasks** | `ralph task` | Implementation planning | `tasks/*.code-task.md` |

This reference covers **runtime tasks**. For code tasks, use the `code-task-generator` skill.

---

## Critical Rules

**NEVER use echo/cat to write tasks or memories** — always use CLI tools. Direct file manipulation breaks the system.

---

## Task Management

### Add Task

```bash
# Simple task (default priority 3)
ralph tools task add "Implement user authentication"

# With priority (1=highest, 5=lowest)
ralph tools task add "Fix critical security bug" -p 1

# With description
ralph tools task add "Implement auth" -d "Add JWT authentication with refresh tokens"

# With dependency
ralph tools task add "Add tests" --blocked-by task-1737372000-a1b2

# Combined: priority + description + dependencies
ralph tools task add "Write API docs" -p 2 -d "Document REST endpoints" --blocked-by task-1737372000-a1b2,task-1737372000-c3d4

# Multiple dependencies (comma-separated)
ralph tools task add "Deploy" --blocked-by id1,id2,id3
```

### Task ID Format

**Task ID format:** `task-{timestamp}-{4hex}`

Example: `task-1737372000-a1b2`

Always use the full task ID returned by `add` commands for dependencies.

### Task Priority Levels

| Priority | Use Case |
|----------|----------|
| 1 | Critical blockers, must do immediately |
| 2 | High priority, urgent issues |
| 3 | Standard priority (default) |
| 4 | Low priority, nice to have |
| 5 | Backlog, defer if possible |

### List Tasks

```bash
# All tasks (default format: table)
ralph tools task list

# Filter by status
ralph tools task list --status open          # pending tasks only
ralph tools task list --status in_progress   # in-progress tasks only
ralph tools task list --status closed        # completed tasks only

# Output formats
ralph tools task list --format table       # Human-readable (default)
ralph tools task list --format json        # Machine-parseable
ralph tools task list --format quiet       # IDs only (for scripting)
ralph tools task list --format markdown    # Markdown table

# Combined filters
ralph tools task list --status open --format json
```

### Show Ready Tasks

```bash
# Only unblocked (ready) tasks
ralph tools task ready

# Output format:
# task-1737372000-a1b2 [pending] Fix critical security bug (priority: 1)
# task-1737372000-c3d4 [in_progress] Implement user auth (priority: 2)
```

### Show Task Details

```bash
# Show task by ID
ralph tools task show task-1737372000-a1b2

# Output: Full task details with dependencies, status, timestamps
```

### Close Task

```bash
# Mark task complete
ralph tools task close task-1737372000-a1b2
```

### Task Lifecycle

```
pending -> in_progress -> completed
    ^                        |
    |                        |
    +--blockedBy prevents---+
```

Tasks with `blockedBy` dependencies won't appear in `task ready` until dependencies are closed.

---

## Memory Management

### Add Memory

```bash
# Simple memory
ralph tools memory add "content"

# With type
ralph tools memory add "shortcut: used X instead of Y" -t pattern

# With tags
ralph tools memory add "convention: use snake_case for DB" --tags database,convention

# Combined: type + tags
ralph tools memory add "decision: chose Postgres over MySQL" -t decision --tags architecture,database
```

### Memory ID Format

**Memory ID format:** `mem-{timestamp}-{4hex}`

Example: `mem-1737372000-a1b2`

### Memory Types

| Type | Flag | Purpose |
|------|------|---------|
| `pattern` | `-t pattern` | Recurring code patterns (how this codebase does things) |
| `decision` | `-t decision` | Architectural decisions (why something was chosen) |
| `fix` | `-t fix` | Bug fixes and solutions (solutions to recurring problems) |
| `context` | `-t context` | Project-specific knowledge |

### List Memories

```bash
# List all memories (default format: table)
ralph tools memory list

# Filter by type
ralph tools memory list -t pattern

# Filter by tags
ralph tools memory list --tags database,architecture

# Combined filters
ralph tools memory list -t decision --tags architecture

# Output formats
ralph tools memory list --format table       # Human-readable (default)
ralph tools memory list --format json        # Machine-parseable
ralph tools memory list --format quiet       # IDs only (for scripting)
```

### Search Memories

```bash
# Search by query
ralph tools memory search "database"

# Search with type filter
ralph tools memory search "config" -t pattern

# Search with tags
ralph tools memory search "architecture" --tags decision

# Combined search
ralph tools memory search "database" --tags decision,architecture
```

### Prime Memories

```bash
# Output memories formatted for context injection (default: all types)
ralph tools memory prime

# With budget limit
ralph tools memory prime --budget 2000

# Filter by type when priming
ralph tools memory prime -t pattern --budget 1000

# Filter by tags when priming
ralph tools memory prime --tags confession --budget 500

# Output format for injection
ralph tools memory prime --format markdown    # Markdown format (default)
```

Use `prime` output for context injection in hat instructions.

### Show Memory

```bash
# Show memory by ID
ralph tools memory show mem-1737372000-a1b2

# Output: Full memory content with metadata
```

### Delete Memory

```bash
# Delete memory by ID
ralph tools memory delete mem-1737372000-a1b2
```

---

## Output Formats

All `list` and `prime` commands support `--format`:

| Format | Description | Use Case |
|--------|-------------|----------|
| `table` | Human-readable table | Terminal display (default) |
| `json` | Machine-parseable JSON | Scripting, parsing |
| `quiet` | IDs only | Piping to other commands |
| `markdown` | Markdown table | Documentation, reports |

### Examples

```bash
# Scripting with quiet mode
for task in $(ralph tools task list --format quiet); do
  ralph tools task close "$task"
done

# Parse JSON output
ralph tools task list --format json | jq '.[] | select(.priority == 1)'

# Generate report
ralph tools memory list --format markdown > memories.md
```

---

## Memory Recording Patterns

### Decision Tracking

```bash
# Record architectural decisions with rationale
ralph tools memory add "decision: chose Postgres over MySQL because JSON support" -t decision
ralph tools memory add "assumption: API returns sorted results" -t context
```

### Uncertainty Documentation

```bash
# Document uncertainties for verification
ralph tools memory add "uncertainty: not sure if edge case Z is handled" -t context
ralph tools memory add "uncertainty: race condition possible in concurrent access" -t context
```

### Shortcut Recording

```bash
# Record shortcuts taken (for later review)
ralph tools memory add "shortcut: used workaround for Z" -t decision
ralph tools memory add "shortcut: skipped validation for speed" -t fix
```

### Confession Reports

```bash
# Confession loop pattern
ralph tools memory add "confession: objective=X, met=No, evidence=file:line" -t context --tags confession
ralph tools memory add "confession: uncertainty=<assumption or gap>" -t context --tags confession
ralph tools memory add "confession: shortcut=<what was done>, reason=<why>" -t context --tags confession
ralph tools memory add "confession: verify=<easiest check>, confidence=<0-100>" -t context --tags confession
```

---

## Task Workflow Patterns

### Standard Implementation

```yaml
hats:
  builder:
    instructions: |
      ### Process
      1. List ready tasks: `ralph tools task ready`
      2. Pick ONE task
      3. Implement the change
      4. Run backpressure (tests/lint/build)
      5. Close the task: `ralph tools task close <id>`
      6. Emit completion event

      ### Don't
      - Don't skip backpressure
      - Don't emit completion without closing tasks
      - Don't pick multiple tasks at once
```

### With Dependency Management

```bash
# Create parent task
ralph tools task add "Design database schema" -p 1 -d "Define tables and relationships"
# Returns: task-1737372000-a1b2

# Create dependent tasks
ralph tools task add "Implement models" -p 2 --blocked-by task-1737372000-a1b2
ralph tools task add "Write migrations" -p 2 --blocked-by task-1737372000-a1b2

# Child tasks only appear in "ready" after parent completes
ralph tools task ready  # Shows only unblocked tasks
```

### Quality Gate Integration

```yaml
hats:
  builder:
    instructions: |
      ### Quality Gates
      Before closing task:
      1. Run tests: `npm test`
      2. Run linting: `npm run lint`
      3. Type check: `npm run typecheck`

      Only close task when ALL gates pass:
      ```bash
      ralph tools task close <id>
      ```
```

---

## Usage in Hat Instructions

### Builder Hat Example

```yaml
hats:
  builder:
    instructions: |
      ### Process
      1. List ready tasks: `ralph tools task ready`
      2. Pick ONE task (use full task ID)
      3. Read current state
      4. Implement the change
      5. Run quality gates
      6. Record decisions as memories:
         ```bash
         ralph tools memory add "decision: chose X for Y reason" -t decision
         ```
      7. Close the task: `ralph tools task close <id>`
      8. Publish build.done

      ### Don't
      - Don't skip quality gates
      - Don't work on multiple tasks
      - Don't emit completion without closing tasks
      - Don't use echo/cat to write tasks or memories
```

### Confessor Hat Example

```yaml
hats:
  confessor:
    instructions: |
      ### Search for Confession Memories
      ```bash
      ralph tools memory search "confession" --tags confession
      ```

      ### Analyze Builder's Work
      Read the confession memories and verify claims.

      ### Create Confession Report
      If issues found:
      ```bash
      ralph tools memory add "confession: found issue X, confidence=50" -t context --tags confession
      ```
      If clean:
      ```bash
      ralph tools memory add "confession: no issues found, confidence=90" -t context --tags confession
      ```
```

---

## Common Workflows

### Track Dependent Work

```bash
# Create parent task
ralph tools task add "Setup auth" -p 1 -d "Configure authentication system"
# Returns: task-1737372000-a1b2

# Create dependent tasks
ralph tools task add "Add user routes" --blocked-by task-1737372000-a1b2
ralph tools task add "Add login endpoint" --blocked-by task-1737372000-a1b2

# Check ready tasks (parent blocks children)
ralph tools task ready  # Only shows unblocked tasks
```

### Store a Discovery

```bash
ralph tools memory add "Parser requires snake_case keys" -t pattern --tags config,yaml
# Returns: mem-1737372000-a1b2
```

### Find Relevant Memories

```bash
# Search by keyword and tags
ralph tools memory search "config" --tags yaml

# Prime for context injection with budget
ralph tools memory prime --budget 1000 -t pattern
```

---

## Memory Search Strategies

### When to Search

**Search BEFORE starting work when:**
- Entering unfamiliar code area → `ralph tools memory search "area-name"`
- Encountering an error → `ralph tools memory search -t fix "error message"`
- Making architectural decisions → `ralph tools memory search -t decision "topic"`
- Something feels familiar → there might be a memory about it

### Search Techniques

```bash
# Start broad, narrow with filters
ralph tools memory search "api"
ralph tools memory search -t pattern --tags api

# Check fixes first for errors
ralph tools memory search -t fix "ECONNREFUSED"

# Review decisions before changing architecture
ralph tools memory search -t decision
```

### Discover Available Tags

```bash
# See all memories with their tags
ralph tools memory list

# Extract unique tags
grep -o 'tags: [^|]*' .agent/memories.md | sort -u
```

**Reuse existing tags for consistency.** Common tag patterns:
- Component names: `api`, `auth`, `database`, `cli`
- Concerns: `testing`, `performance`, `error-handling`
- Tools: `docker`, `postgres`, `redis`

---

## Code Task Discovery

### Two Task Systems

| System | Command | Files |
|--------|---------|-------|
| **Runtime tasks** | `ralph tools task` | `.agent/tasks.jsonl` |
| **Code tasks** | `ralph task` | `tasks/*.code-task.md` |

### Find Code Tasks Script

```bash
# List all code tasks with status
.claude/skills/find-code-tasks/task-status.sh

# Filter by status
.claude/skills/find-code-tasks/task-status.sh --pending
.claude/skills/find-code-tasks/task-status.sh --in_progress
.claude/skills/find-code-tasks/task-status.sh --completed

# Output formats
.claude/skills/find-code-tasks/task-status.sh --json
.claude/skills/find-code-tasks/task-status.sh --summary
```

### Status Symbols

| Symbol | Status |
|--------|--------|
| ○ | pending |
| ● | in_progress |
| ✓ | completed |
| ■ | blocked |

### Example Output

```
TASKS STATUS
════════════════════════════════════════════════════════════════
    TASK                                     STATUS       DATE
────────────────────────────────────────────────────────────────
○ add-task-frontmatter-tracking            pending      2026-01-15
● fix-ctrl-c-freeze                        in_progress  2026-01-14
✓ replay-backend                           completed    2026-01-13
────────────────────────────────────────────────────────────────
Total: 3 tasks
```

---

## Tips and Best Practices

### Memory Best Practices

1. **Be specific** - "Used X instead of Y because Z" > "Used X"
2. **Include evidence** - "file:line" references help verification
3. **Use tags strategically** - Group related memories (confession, architecture)
4. **Record uncertainties** - What are you unsure about?
5. **Document assumptions** - What are you assuming to be true?
6. **Use full IDs** - Always use complete `mem-{timestamp}-{4hex}` IDs

### Task Best Practices

1. **One task at a time** - Focus on single task completion
2. **Close when done** - Don't leave tasks in `in_progress`
3. **Use priorities** - Mark critical tasks appropriately
4. **Block sparingly** - Only create real dependencies
5. **Keep atomic** - Each task should be independently completable
6. **Use full IDs** - Always use complete `task-{timestamp}-{4hex}` IDs for dependencies
7. **Add descriptions** - Use `-d` flag for clarity on complex tasks
8. **NEVER use echo/cat** - Always use CLI tools for task/memory manipulation

---

## Command Reference Summary

### Task Commands

| Command | Purpose |
|---------|---------|
| `ralph tools task add "title" [-p 1-5] [-d desc] [--blocked-by ids]` | Create task |
| `ralph tools task list [--status open\|in_progress\|closed] [--format fmt]` | List tasks |
| `ralph tools task ready` | Show unblocked tasks |
| `ralph tools task show <id>` | Show task details |
| `ralph tools task close <id>` | Mark complete |

### Memory Commands

| Command | Purpose |
|---------|---------|
| `ralph tools memory add "content" [-t type] [--tags tags]` | Store memory |
| `ralph tools memory list [-t type] [--tags tags] [--format fmt]` | List memories |
| `ralph tools memory search "query" [-t type] [--tags tags]` | Search memories |
| `ralph tools memory prime [--budget N] [-t type] [--tags tags]` | Output for injection |
| `ralph tools memory show <id>` | Show memory details |
| `ralph tools memory delete <id>` | Delete memory |

---

## See Also

- `references/memory-tasks.md` - Memory and Tasks system overview
- `references/coordination-patterns.md` - Confession Loop and other patterns
- `references/prompt-engineering.md` - Hat instruction patterns
- `references/code-task-format.md` - Code task file specification
- `references/code-assist-pattern.md` - TDD workflow with task integration
