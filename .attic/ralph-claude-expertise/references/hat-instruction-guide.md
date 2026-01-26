# Hat Instruction Design Guide

Hat instructions define agent behavior when activated. This guide provides patterns for effective hat design.

---

## Design Principles

1. **Description is critical** — Ralph uses descriptions to delegate. Make them clear and specific.

2. **One hat, one responsibility** — Each hat should have a focused purpose. If using "and" in description, consider splitting.

3. **Events are routing signals, not data** — Keep payloads brief. Store detailed output in files and reference in events.

4. **Design for recovery** — Handle unexpected states gracefully. Ralph catches orphaned events as universal fallback.

5. **Test with simple prompts first** — Complex topologies have emergent behavior. Start simple, validate flow, then add complexity.

---

## Instruction Structure

```yaml
hats:
  my_hat:
    name: "Display Name"
    description: "What this hat does"
    triggers: ["event.start"]
    publishes: ["event.done"]
    default_publishes: "event.done"
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
      ralph emit "event.done" "status: pass, summary: brief description"
```

---

## Best Practices

| Practice | Example | Why |
|----------|---------|-----|
| Clear phase header | `## BUILDER PHASE` | Identifies role immediately |
| Numbered process | `1. Pick task 2. Build 3. Test` | Unambiguous execution order |
| Explicit don'ts | `### Don't` sections | Prevents common mistakes |
| Event format template | `ralph emit "done" "summary"` | Ensures consistent event structure |
| Memory recording | `ralph tools memory add` | Preserves context for other hats |
| Task lifecycle | `pick → close` loop | Prevents task leakage |
| Backpressure enforcement | `Run tests before emitting done` | Quality gates |

---

## Instruction Patterns

### Task Lifecycle Pattern

```yaml
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

### Memory Recording Pattern

```yaml
instructions: |
  ### Record Internal Monologue
  Before emitting done event, record:
  ```bash
  # Decisions made
  ralph tools memory add "decision: chose X over Y because..." -t decision

  # Uncertainties/assumptions
  ralph tools memory add "assumption: API returns sorted" -t context

  # Shortcuts taken
  ralph tools memory add "shortcut: used workaround for Z" -t decision
  ```
```

### Event Format Patterns

Structured events enable downstream parsing and verification:

```bash
# Simple backpressure event
ralph emit "build.done" "tests: pass, lint: pass. Implemented feature X"

# Confidence-based event
ralph emit "confession.clean" "confidence: 85, summary: no issues found, verification: tests pass"

# Blocker event
ralph emit "build.blocked" "tried: X, failed: Y error, reason: missing dependency Z"

# Escalation event
ralph emit "escalate.human" "issue: security vulnerability in auth, severity: high, action: needed"
```

### Conditional Event Logic

```yaml
instructions: |
  ### Completion Decision
  If tests pass AND all tasks closed:
    - Emit "build.done" with summary
    - Do NOT emit completion promise

  If tests fail:
    - Emit "build.failed" with error details
    - Create fix task: `ralph tools task add "Fix: specific error" -p 1`

  If blocked:
    - Emit "build.blocked" with what was tried
    - Document blocker as memory
```

---

## Event Routing

Events use glob-style pattern matching:

| Pattern | Matches |
|---------|---------|
| `task.start` | Exactly `task.start` |
| `build.*` | `build.done`, `build.blocked`, etc. |
| `*.done` | All `.done` events |
| `*` | Everything (Ralph's fallback) |

**Priority**: Specific patterns > wildcards. Global wildcard (`*`) only triggers if no specific handler exists.

---

## Emitting Events

```bash
# Simple event
ralph emit "build.done" "tests: pass, lint: pass"

# JSON payload
ralph emit "review.done" --json '{"status": "approved", "issues": 0}'

# Direct handoff (bypasses routing)
ralph emit "handoff" --target reviewer "Please review"
```

In agent output, use XML tags:
```xml
<event topic="impl.done">Implementation complete</event>
<event topic="handoff" target="reviewer">Please review</event>
```

---

## Per-Hat Backend Configuration

Different hats can use different backends:

```yaml
cli:
  backend: "claude"  # Default backend

hats:
  builder:
    name: "Builder"
    description: "Implements code"
    triggers: ["build.task"]
    publishes: ["build.done"]
    backend: "claude"

  researcher:
    name: "Researcher"
    description: "Researches technical questions"
    triggers: ["research.task"]
    publishes: ["research.done"]
    backend:
      type: "kiro"
      agent: "researcher"               # Kiro with MCP tools

  reviewer:
    name: "Reviewer"
    description: "Reviews code changes"
    triggers: ["review.task"]
    publishes: ["review.done"]
    backend: "gemini"                   # Different model for fresh perspective
```

### Backend Types

| Type | Syntax | Invocation |
|------|--------|------------|
| Named | `backend: "claude"` | Standard backend |
| Kiro Agent | `backend: { type: "kiro", agent: "name" }` | `kiro-cli --agent name ...` |
| Custom | `backend: { command: "...", args: [...] }` | Your command |

### When to Mix Backends

| Scenario | Recommended Backend |
|----------|---------------------|
| Complex coding | Claude (best reasoning) |
| AWS/cloud tasks | Kiro with agent (MCP tools) |
| Code review | Different model (fresh perspective) |
| Internal tools | Custom backend |
| Cost optimization | Faster/cheaper model |
