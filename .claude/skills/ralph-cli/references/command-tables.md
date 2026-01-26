# Ralph CLI: Complete Command Reference

Complete reference for all Ralph CLI commands, options, and usage patterns.

## Command Index

| Command | Purpose | Common Options |
|---------|---------|----------------|
| `run` | Execute orchestration loop | `--record-session`, `--continue`, `--dry-run` |
| `plan` | Start PDD planning session | `--backend` |
| `code-task` / `task` | Generate code task files | `--backend` |
| `events` | View event history | `--topic`, `--iteration`, `--format` |
| `emit` | Emit event to log | `--json`, `--file` |
| `init` | Initialize configuration | `--preset`, `--list-presets` |
| `clean` | Clean up artifacts | `--dry-run`, `--diagnostics` |
| `tools` | Runtime tools (memory/task) | Subcommands required |
| `loops` | Manage parallel loops | Subcommands required |

## ralph run

### Syntax
```bash
ralph run [OPTIONS]
```

### Options Table

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `-p, --prompt` | STRING | None | Inline prompt text (mutually exclusive with `-P`) |
| `-P, --prompt-file` | PATH | PROMPT.md | Prompt file path |
| `-b, --backend` | STRING | config | Override backend from config |
| `--max-iterations` | NUMBER | config | Override max iterations |
| `--completion-promise` | STRING | config | Override completion promise |
| `--dry-run` | FLAG | false | Show what would execute without running |
| `--continue` | FLAG | false | Resume from existing scratchpad |
| `--no-tui` | FLAG | false | Disable TUI observation mode |
| `-a, --autonomous` | FLAG | false | Force autonomous mode (headless) |
| `--idle-timeout` | SECONDS | 30 | Idle timeout for interactive mode |
| `--exclusive` | FLAG | false | Wait for primary loop slot |
| `--no-auto-merge` | FLAG | false | Skip auto-merge after loop completes |
| `-c, --config` | PATH | ralph.yml | Config file override |
| `--record-session` | FILE | None | Record session to JSONL file |
| `-v, --verbose` | FLAG | false | Enable verbose output |
| `--color` | MODE | auto | Color mode: auto, always, never |
| `-q, --quiet` | FLAG | false | Suppress output (for CI) |

### Usage Examples

```bash
# Basic execution
ralph run

# With inline prompt
ralph run -p "Build user authentication"

# Resume from checkpoint
ralph run --continue --no-tui

# Dry run validation
ralph run --dry-run

# Session recording for replay
ralph run --record-session .ralph/session.jsonl

# Autonomous mode with custom backend
ralph run --autonomous --backend gemini

# Parallel batch (manual merge)
ralph run --no-auto-merge -p "test all components"
```

## ralph plan

### Syntax
```bash
ralph plan [OPTIONS] [IDEA] [-- <CUSTOM_ARGS>...]
```

### Options Table

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `IDEA` | STRING | None | Rough idea to develop (optional) |
| `-b, --backend` | STRING | config | Backend to use |
| `-c, --config` | PATH | ralph.yml | Config file override |
| `--color` | MODE | auto | Color mode: auto, always, never |
| `-v, --verbose` | FLAG | false | Verbose output |
| `--` | | | Custom backend command and arguments |

### Usage Examples

```bash
# Start planning session (will prompt if no IDEA given)
ralph plan "Build REST API for user management"

# With custom backend
ralph plan --backend gemini "Design database schema"

# With custom backend command
ralph plan "Multi-step refactoring" -- /custom/backend --option value
```

## ralph code-task / ralph task

### Syntax
```bash
ralph code-task [OPTIONS] [INPUT] [-- <CUSTOM_ARGS>...]
ralph task [OPTIONS] [INPUT] [-- <CUSTOM_ARGS>...]
```

### Options Table

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `INPUT` | STRING/PATH | None | Description text or path to PDD plan file |
| `-b, --backend` | STRING | config | Backend to use |
| `-c, --config` | PATH | ralph.yml | Config file override |
| `--color` | MODE | auto | Color mode: auto, always, never |
| `-v, --verbose` | FLAG | false | Verbose output |
| `--` | | | Custom backend command and arguments |

### Usage Examples

```bash
# Generate task from description
ralph code-task "Implement JWT authentication"

# Generate task from PDD plan file
ralph code-task specs/plan.md

# With custom backend
ralph task --backend gemini "Design caching layer"
```

## ralph events

### Syntax
```bash
ralph events [OPTIONS]
```

### Options Table

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `--last` | NUMBER | None | Show only last N events |
| `--topic` | STRING | None | Filter by topic (e.g., "build.blocked") |
| `--iteration` | NUMBER | None | Filter by iteration number |
| `--format` | FORMAT | table | Output format: table, json |
| `--file` | PATH | auto | Path to events file |
| `--clear` | FLAG | false | Clear event history |
| `-c, --config` | PATH | ralph.yml | Config file override |
| `--color` | MODE | auto | Color mode: auto, always, never |
| `-v, --verbose` | FLAG | false | Verbose output |

### Usage Examples

```bash
# Show recent events
ralph events --last 20

# Filter by topic
ralph events --topic "test.passed"

# Filter by iteration
ralph events --iteration 15

# JSON output for parsing
ralph events --format json | jq '.[] | {topic, iteration}'

# Clear history
ralph events --clear
```

### Common Topic Patterns

| Topic Pattern | Purpose |
|---------------|---------|
| `workflow.*` | Initial workflow events |
| `design.*` | Test design phase |
| `execution.*` | Execution phase |
| `test.*` | Test results |
| `confession.*` | Validation issues |
| `LOOP_COMPLETE` | Workflow completion |

## ralph emit

### Syntax
```bash
ralph emit [OPTIONS] <TOPIC> [PAYLOAD]
```

### Options Table

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `TOPIC` | STRING | Required | Event topic (e.g., "build.done") |
| `PAYLOAD` | STRING | Empty | Event payload (optional) |
| `-j, --json` | FLAG | false | Parse payload as JSON |
| `--ts` | TIMESTAMP | now | Custom ISO 8601 timestamp |
| `--file` | PATH | .ralph/events.jsonl | Path to events file |
| `-c, --config` | PATH | ralph.yml | Config file override |
| `--color` | MODE | auto | Color mode: auto, always, never |
| `-v, --verbose` | FLAG | false | Verbose output |

### Usage Examples

```bash
# Emit simple event
ralph emit "build.done" "tests: pass, implementation: complete"

# Emit JSON payload
ralph emit "test.results" -j '{"tests": 15, "passed": 12, "failed": 3}'

# Emit with custom timestamp
ralph emit "deployment.complete" --ts 2026-01-26T10:00:00Z

# Emit to custom file
ralph emit "custom.event" "data" --file /path/to/events.jsonl
```

## ralph init

### Syntax
```bash
ralph init [OPTIONS]
```

### Options Table

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `--backend` | STRING | None | Backend: claude, kiro, gemini, codex, amp, custom |
| `--preset` | NAME | None | Copy embedded preset to ralph.yml |
| `--list-presets` | FLAG | false | List all available presets |
| `--force` | FLAG | false | Overwrite existing ralph.yml |
| `-c, --config` | PATH | ralph.yml | Config file path |
| `--color` | MODE | auto | Color mode: auto, always, never |
| `-v, --verbose` | FLAG | false | Verbose output |

### Usage Examples

```bash
# List all presets
ralph init --list-presets

# Initialize from preset
ralph init --preset feature

# Initialize with backend override
ralph init --preset debug --backend gemini

# Overwrite existing config
ralph init --preset feature --force
```

### Available Presets (v2.2.5)

| Category | Presets |
|----------|---------|
| **Development** | feature, feature-minimal, tdd-red-green, spec-driven, refactor |
| **Review** | review, pr-review, adversarial-review, confession-loop |
| **Analysis** | debug, scientific-method, code-archaeology, gap-analysis, research |
| **Learning** | socratic-learning |
| **Collaboration** | mob-programming |
| **Operations** | deploy, incident-response, migration-safety, performance-optimization |
| **Design** | api-design, documentation-first |
| **Documentation** | docs |
| **Utilities** | hatless-baseline, merge-loop |

## ralph clean

### Syntax
```bash
ralph clean [OPTIONS]
```

### Options Table

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `--dry-run` | FLAG | false | Preview what would be deleted |
| `--diagnostics` | FLAG | false | Clean diagnostic logs (not .agent/) |
| `-c, --config` | PATH | ralph.yml | Config file override |
| `--color` | MODE | auto | Color mode: auto, always, never |
| `-v, --verbose` | FLAG | false | Verbose output |

### Usage Examples

```bash
# Preview cleanup
ralph clean --dry-run

# Clean .agent/ directory
ralph clean

# Clean diagnostic logs
ralph clean --diagnostics
```

## ralph tools

### Syntax
```bash
ralph tools <COMMAND> [OPTIONS]
```

### Subcommands
- `memory` - Manage persistent memories
- `task` - Manage work items
- `help` - Show help

### Usage Examples
```bash
# Memory operations
ralph tools memory add "pattern content" -t pattern --tags api
ralph tools memory list --last 10
ralph tools memory search "api" --tags pattern

# Task operations
ralph tools task add "Implement feature" -p 1
ralph tools task ready
ralph tools task close <id>
```

## ralph tools memory

### Syntax
```bash
ralph tools memory <COMMAND> [OPTIONS]
```

### Subcommands

| Command | Purpose |
|---------|---------|
| `add` | Store new memory |
| `list` | List all memories |
| `show` | Show single memory by ID |
| `delete` | Delete memory by ID |
| `search` | Find memories by query |
| `prime` | Output memories for context injection |
| `init` | Initialize memories file |

### ralph tools memory add

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `CONTENT` | STRING | Required | Memory content to store |
| `-t, --type` | TYPE | pattern | Memory type: pattern, decision, fix, context |
| `--tags` | TAGS | None | Comma-separated tags |
| `--format` | FORMAT | table | Output: table, json, markdown, quiet |
| `--root` | PATH | cwd | Working directory |

```bash
ralph tools memory add "API routes use kebab-case" -t pattern --tags api,routing
ralph tools memory add "Chose Postgres for concurrent writes" -t decision --tags database
ralph tools memory add "ECONNREFUSED on :5432 means run docker-compose" -t fix --tags postgres,docker
```

### ralph tools memory list

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `-t, --type` | TYPE | None | Filter by memory type |
| `--last` | NUMBER | None | Show only last N memories |
| `--format` | FORMAT | table | Output: table, json, markdown, quiet |
| `--root` | PATH | cwd | Working directory |

```bash
ralph tools memory list
ralph tools memory list -t pattern --last 10
ralph tools memory list --format json
```

### ralph tools memory search

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `QUERY` | STRING | None | Search query (fuzzy match) |
| `-t, --type` | TYPE | None | Filter by type |
| `--tags` | TAGS | None | Filter by tags (comma-separated) |
| `--all` | FLAG | false | Show all results (no limit) |
| `--format` | FORMAT | table | Output: table, json, markdown, quiet |
| `--root` | PATH | cwd | Working directory |

```bash
ralph tools memory search "api"
ralph tools memory search -t fix "error"
ralph tools memory search --tags api,auth --all
```

### ralph tools memory prime

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `--budget` | TOKENS | 0 | Max tokens (0 = unlimited) |
| `-t, --type` | TYPES | None | Filter by types (comma-separated) |
| `--tags` | TAGS | None | Filter by tags |
| `--recent` | DAYS | 0 | Only memories from last N days |
| `--format` | FORMAT | markdown | Output: table, json, markdown, quiet |
| `--root` | PATH | cwd | Working directory |

```bash
ralph tools memory prime --budget 2000
ralph tools memory prime -t pattern --tags api
ralph tools memory prime --recent 7 --budget 1500
```

### ralph tools memory show/delete/init

```bash
# Show memory
ralph tools memory show mem-1737372000-a1b2

# Delete memory
ralph tools memory delete mem-1737372000-a1b2

# Initialize memories file
ralph tools memory init --force
```

## ralph tools task

### Syntax
```bash
ralph tools task <COMMAND> [OPTIONS]
```

### Subcommands

| Command | Purpose |
|---------|---------|
| `add` | Create new task |
| `list` | List all tasks |
| `ready` | Show unblocked tasks |
| `close` | Mark task as complete |
| `show` | Show single task by ID |

### ralph tools task add

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `TITLE` | STRING | Required | Task title |
| `-p, --priority` | NUMBER | 3 | Priority (1-5, 1 = highest) |
| `-d, --description` | STRING | None | Task description |
| `--blocked-by` | IDS | None | Task IDs that must complete first (comma-separated) |
| `--format` | FORMAT | table | Output: table, json, quiet |
| `--root` | PATH | cwd | Working directory |

```bash
ralph tools task add "Implement auth" -p 1
ralph tools task add "Add tests" -p 2 --blocked-by task-abc123
ralph tools task add "Fix bug" -d "Login fails when token expires" -p 1
```

### ralph tools task list

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `-s, --status` | STATUS | None | Filter: open, in_progress, closed |
| `--format` | FORMAT | table | Output: table, json, quiet |
| `--root` | PATH | cwd | Working directory |

```bash
ralph tools task list
ralph tools task list -s open
ralph tools task list --format json
```

### ralph tools task ready/close/show

```bash
# Show unblocked tasks
ralph tools task ready

# Close task
ralph tools task close task-abc123

# Show task details
ralph tools task show task-abc123
```

## ralph loops

### Syntax
```bash
ralph loops [OPTIONS] [COMMAND]
```

### Subcommands

| Command | Purpose |
|---------|---------|
| `list` | List all loops (default) |
| `logs` | View loop output/logs |
| `history` | Show event history for loop |
| `retry` | Re-run merge for failed loop |
| `discard` | Abandon loop and clean up |
| `stop` | Stop a running loop |
| `prune` | Clean up stale loops |
| `attach` | Open shell in loop's worktree |
| `diff` | Show diff from merge-base |
| `merge` | Merge completed loop |

### ralph loops list

```bash
ralph loops list
```

Shows all loops with status: running, completed, failed.

### ralph loops logs

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `LOOP_ID` | ID | Required | Loop ID (e.g., ralph-20250126-a3f2 or a3f2) |
| `-f, --follow` | FLAG | false | Follow output in real-time |

```bash
ralph loops logs ralph-20250126-a3f2
ralph loops logs a3f2 -f
```

### ralph loops history

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `LOOP_ID` | ID | Required | Loop ID |
| `--json` | FLAG | false | Output raw JSONL instead of table |

```bash
ralph loops history ralph-20250126-a3f2
ralph loops history a3f2 --json
```

### ralph loops diff

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `LOOP_ID` | ID | Required | Loop ID |
| `--stat` | FLAG | false | Show stat only (no diff content) |

```bash
ralph loops diff ralph-20250126-a3f2
ralph loops diff a3f2 --stat
```

### ralph loops merge/retry/discard/stop

```bash
# Merge completed loop
ralph loops merge ralph-20250126-a3f2

# Force merge even if state is 'merging'
ralph loops merge ralph-20250126-a3f2 --force

# Re-run merge for failed loop
ralph loops retry ralph-20250126-a3f2

# Discard loop (clean up worktree)
ralph loops discard ralph-20250126-a3f2 -y

# Stop running loop
ralph loops stop ralph-20250126-a3f2
ralph loops stop a3f2 --force
```

### ralph loops prune/attach

```bash
# Clean up stale loops (crashed processes)
ralph loops prune

# Open shell in loop's worktree
ralph loops attach ralph-20250126-a3f2
```

## Global Options

These options are available for all commands:

| Option | Description |
|--------|-------------|
| `-c, --config` | Config file override (default: ralph.yml) |
| `-v, --verbose` | Enable verbose output |
| `--color` | Color mode: auto, always, never |
| `-h, --help` | Print help summary |
| `-V, --version` | Print version |

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General error |
| 2 | Command usage error |
| 124 | Timeout |
| 126 | Command not found |
| 127 | Command not found (PATH issue) |
