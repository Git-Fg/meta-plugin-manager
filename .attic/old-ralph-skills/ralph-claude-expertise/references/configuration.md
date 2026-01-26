# Complete Ralph Configuration Reference

Full schema for `ralph.yml` configuration file.

---

## Event Loop Configuration

```yaml
event_loop:
  # Required: The event that signals completion
  completion_promise: "LOOP_COMPLETE"

  # Required: Maximum number of orchestration loops
  max_iterations: 100

  # Optional: Maximum runtime in seconds (default: 14400 = 4 hours)
  max_runtime_seconds: 14400

  # Optional: Idle timeout in seconds (default: 1800 = 30 minutes)
  idle_timeout_secs: 1800

  # Optional: First event published to start the loop
  starting_event: "task.start"

  # Optional: Prompt file injected at each iteration
  prompt_file: "PROMPT.md"

  # Optional: Checkpoint every N iterations (default: 5)
  checkpoint_interval: 5
```

---

## CLI Backend Configuration

```yaml
cli:
  # Backend: claude, kiro, gemini, codex, amp, copilot, opencode, custom
  backend: "claude"

  # Prompt mode: arg (CLI argument) or stdin
  prompt_mode: "arg"
```

### Supported Backends

| Backend | Description | Use Case |
|---------|-------------|----------|
| `claude` | Anthropic Claude (default) | General purpose, best reasoning |
| `kiro` | Kiro with MCP tools | AWS/cloud tasks with tool support |
| `gemini` | Google Gemini | Fresh perspective, cost optimization |
| `codex` | OpenAI Codex | Legacy compatibility |
| `amp` | AMP backend | Specific use cases |
| `copilot` | GitHub Copilot | Alternative model |
| `opencode` | OpenCode backend | Open source focus |
| `custom` | Custom command | Internal tools |

---

## Core Behaviors

```yaml
core:
  # Shared memory file across iterations
  scratchpad: ".agent/scratchpad.md"

  # Directory for specifications
  specs_dir: "./specs/"

  # Rules injected into every prompt
  guardrails:
    - "Fresh context each iteration - scratchpad is memory"
    - "Don't assume 'not implemented' - search first"
    - "Backpressure is law - tests/typecheck/lint must pass"
```

---

## Memories Configuration

Memories provide persistent learning across sessions.

```yaml
memories:
  # Enable/disable memory system
  enabled: true

  # Injection mode: auto, manual, none
  inject: auto

  # Max tokens to inject (0 = unlimited)
  budget: 2000

  # Filter by type
  filter:
    types: []  # pattern, decision, fix, context
    tags: []   # Filter by tag names
    recent: 0  # Only memories from last N days (0 = no limit)
```

### Memory Types

| Type | Purpose | Example |
|------|---------|---------|
| `pattern` | Recurring code patterns | "shortcut: used X instead of Y because..." |
| `decision` | Architectural decisions | "assumption: API returns sorted results" |
| `fix` | Bug fixes and solutions | "uncertainty: not sure if edge case Z is handled" |
| `context` | Project-specific context | "convention: always use snake_case for DB columns" |

### Injection Modes

| Mode | Behavior |
|------|----------|
| `auto` | Ralph prepends memories at start of each iteration (default) |
| `manual` | Agent must explicitly run `ralph tools memory search` |
| `none` | Memories disabled entirely |

---

## Tasks Configuration

Runtime work tracking system.

```yaml
tasks:
  # Enable/disable task system
  enabled: true
```

When `tasks.enabled: false`, Ralph uses scratchpad-only mode for task tracking.

---

## Hats Configuration

Define specialized personas for multi-agent coordination.

```yaml
hats:
  my_hat:
    # Display name shown in TUI and logs
    name: "Display Name"

    # REQUIRED: What this hat does (Ralph uses this for delegation)
    description: "What this hat does"

    # Events that activate this hat
    triggers: ["event.a", "event.b"]

    # Events this hat can emit
    publishes: ["event.c", "event.d"]

    # Fallback event if hat forgets to emit
    default_publishes: "event.c"

    # Optional: Cap on activations
    max_activations: 10

    # Optional: Backend override for this hat
    backend: "claude"

    # Prompt injected when this hat is active
    instructions: |
      ## PHASE NAME
      Clear purpose statement.

      ### Process
      1. First step
      2. Second step
      3. Third step

      ### Don't
      - Don't do X
      - Don't do Y

      ### Event Format
      When complete, publish event.c
```

### Required Fields

Every hat MUST have:
- `name` - Display name
- `description` - What the hat does (REQUIRED for delegation)
- `triggers` - Events that activate the hat
- `publishes` - Events the hat can emit
- `instructions` - Prompt content

### Optional Fields

- `default_publishes` - Fallback event
- `max_activations` - Activation cap
- `backend` - Backend override

---

## Prompt File Configuration

Use `prompt_file` in event_loop to inject consistent prompts:

```yaml
event_loop:
  prompt_file: "PROMPT.md"  # File contents prepended to each iteration
  completion_promise: "LOOP_COMPLETE"
```

**PROMPT.md** contains project-specific context injected at every iteration:

```markdown
# Project Context

This is a Rust project using async/await patterns.
- Use `tokio` for async runtime
- Prefer `?` operator for error propagation
- Run tests with `cargo test`
- Format with `cargo fmt`
```

**Override at runtime:**
```bash
# Use different prompt file
ralph run -P CUSTOM_PROMPT.md

# No prompt file
ralph run -p "inline prompt overrides prompt_file"
```

---

## Complete Example Configuration

```yaml
# ralph.yml

cli:
  backend: "claude"
  prompt_mode: "arg"

event_loop:
  completion_promise: "LOOP_COMPLETE"
  max_iterations: 50
  max_runtime_seconds: 7200
  idle_timeout_secs: 1800
  starting_event: "task.start"
  prompt_file: "PROMPT.md"
  checkpoint_interval: 5

core:
  scratchpad: ".agent/scratchpad.md"
  specs_dir: "./specs/"
  guardrails:
    - "Fresh context each iteration - scratchpad is memory"
    - "Don't assume 'not implemented' - search first"
    - "Backpressure is law - tests/typecheck/lint must pass"

memories:
  enabled: true
  inject: auto
  budget: 2000
  filter:
    types: []
    tags: []
    recent: 0

tasks:
  enabled: true

hats:
  planner:
    name: "Planner"
    description: "Creates detailed plans from requirements"
    triggers: ["task.start"]
    publishes: ["plan.ready"]
    instructions: |
      ## PLANNER PHASE
      Analyze the task and create a detailed plan.

  builder:
    name: "Builder"
    description: "Implements code from the plan"
    triggers: ["plan.ready"]
    publishes: ["build.done"]
    instructions: |
      ## BUILDER PHASE
      Implement one task at a time from the plan.

  reviewer:
    name: "Reviewer"
    description: "Reviews implementation for quality"
    triggers: ["build.done"]
    publishes: ["review.approved", "review.changes_requested"]
    instructions: |
      ## REVIEWER PHASE
      Review the code changes for quality and correctness.
```

---

## Configuration Validation

Ralph validates configurations on startup:

### Required Fields
- `event_loop.completion_promise`
- `event_loop.max_iterations`
- `cli.backend`
- Every hat must have `description`

### Reserved Triggers
- `task.start` - Reserved for Ralph
- `task.resume` - Reserved for Ralph

### Routing Rules
- Each trigger pattern must map to exactly one hat
- No ambiguous routing (multiple hats on same trigger)

---

## Environment Variables

Ralph respects these environment variables:

| Variable | Purpose |
|----------|---------|
| `ANTHROPIC_API_KEY` | Claude API key |
| `RALPH_CONFIG` | Override config file path |
| `RALPH_HOME` | Override Ralph home directory |

---

## See Also

- `references/hat-backends.md` - Per-hat backend configuration
- `references/memory-tasks.md` - Memory and Tasks system
- `references/runtime-tools.md` - CLI tools for runtime management
