---
name: ralph-claude-expertise
description: "Ralph Orchestrator expertise: workflow design, preset selection, execution configuration, coordination patterns, and programmatic Claude. Use when: user mentions 'ralph', 'orchestrator', 'hat-based workflow'; multi-stage task completion; quality gates and backpressure needed; long-running autonomous workflows. Not for: simple single-task operations, interactive debugging sessions. CRITICAL: Read references/ before creating workflows, validating configs, or diagnosing issues."
---

# Ralph Orchestrator Expertise

Think of Ralph as an **autonomous drone with quality sensors**—it flies through your codebase autonomously, making decisions based on fresh context each iteration, while quality gates ensure it only accepts work that meets your standards.

## CRITICAL: Read References Before Acting

**Before performing ANY task related to Ralph, you MUST read the relevant reference:**

| Task | MUST Read |
|------|-----------|
| Creating/modifying hat configurations | `references/hat-design.md` |
| Designing event flows or coordination | `references/coordination-patterns.md` |
| Writing prompts or instructions | `references/prompt-engineering.md` |
| Validating preset behavior | `references/validation.md` |
| Diagnosing routing or TUI issues | `references/troubleshooting.md` |
| Programmatic Claude execution | `references/claude-automation.md` |

**Why references are mandatory**: References contain complete implementation patterns, common pitfalls, and working examples. Proceeding without reading them leads to malformed configurations, broken workflows, and wasted time.

## Core Philosophy

**Fresh Context** + **Backpressure** = reliable automation

- **Fresh Context**: Each loop starts clean, re-reading state every iteration
- **Backpressure**: Quality gates reject bad work
- **Event Coordination**: Hats communicate via events, not assumptions
- **The Plan Is Disposable**: Regeneration is cheap
- **Let Ralph Ralph**: Autonomous iteration over micromanagement

## Quick Start

**For most users, follow this path:**

1. **List presets**: `ralph init --list-presets`
2. **Initialize**: `ralph init --preset <name>` (ALWAYS start with preset, never from scratch)
3. **Review**: Read generated `ralph.yml`
4. **Customize**: Adjust hat instructions, quality gates, or project context (only if needed)
5. **Create PROMPT.md**: Write task in human-readable format
6. **Run**: `ralph run` or `ralph run --tui`

**For custom hat-based workflows**, read `references/hat-design.md` first.

## Two Orchestration Approaches

### Preset Workflows (Recommended - 95% of use cases)

Start with proven patterns for common tasks.

```bash
ralph init --preset <name>
ralph run
```

**Ideal for:** Features, reviews, debugging, documentation

**Decision Tree:** Need quick task completion? → Use Presets. Not sure? → Start with Presets.

### Adaptive Framework (Advanced - 5% of use cases)

Single workflow for comprehensive analysis with auto-detection.

```bash
cat > PROMPT.md << 'EOF'
Perform comprehensive audit:
- Detect dead code, errors, incoherence
- Find missing error handling
- Fix all issues found
- Generate structured report
EOF

ralph emit "audit.start"
```

**Ideal for:** Comprehensive codebase analysis, spec verification, automatic fixing

## Quick Preset Reference

| Preset | Purpose |
|--------|---------|
| `feature` | Build features |
| `tdd-red-green` | Test-driven development |
| `spec-driven` | Specification-driven development |
| `review` | Code review |
| `security-audit` | Security auditing |
| `debug` | Debug specific issues |
| `docs` | Write documentation |

For complete preset patterns with full hat instructions, see `references/coordination-patterns.md`.

## Execution Modes

### Traditional Mode (Simple Loop)

No hats, no events—just Ralph iterating until completion:

```yaml
# ralph.yml
cli:
  backend: "claude"

event_loop:
  completion_promise: "LOOP_COMPLETE"
  max_iterations: 100
```

**Use when**: Simple, single-focused tasks without role separation.

### Hat-Based Mode (Event-Driven)

**CRITICAL**: Read `references/hat-design.md` before creating hat-based workflows.

Specialized personas hand off work through events:

```yaml
# ralph.yml
cli:
  backend: "claude"

event_loop:
  completion_promise: "LOOP_COMPLETE"
  max_iterations: 100
  starting_event: "task.start"

hats:
  my_hat:
    name: "Display Name"
    description: "What this hat does"
    triggers: ["task.start"]
    publishes: ["work.done"]
    instructions: |
      Prompt injected when this hat is active.
```

**Use when**: Complex workflows requiring specialized roles, handoffs, or multi-agent coordination.

## Core Configuration Schema

```yaml
# Event loop settings
event_loop:
  completion_promise: "LOOP_COMPLETE"  # Output that signals completion
  max_iterations: 100                   # Maximum orchestration loops
  max_runtime_seconds: 14400            # 4 hours max runtime
  idle_timeout_secs: 1800               # 30 min idle timeout
  starting_event: "task.start"          # First event published
  prompt_file: "PROMPT.md"              # Optional: prompt injection file

# CLI backend settings
cli:
  backend: "claude"                     # claude, kiro, gemini, codex, amp, copilot, opencode, custom

# Memories - persistent learning across sessions
memories:
  enabled: true                         # Set false to disable
  inject: auto                          # auto, manual, or none
  budget: 2000                          # Max tokens to inject (0 = unlimited)

# Tasks - runtime work tracking
tasks:
  enabled: true                         # Set false to use scratchpad-only mode

# Custom hats
hats:
  my_hat:
    name: "Display Name"                # Shown in TUI and logs
    description: "What this hat does"   # REQUIRED - Ralph uses this for delegation
    triggers: ["event.a"]               # Events that activate this hat
    publishes: ["event.b"]              # Events this hat can emit
    default_publishes: "event.b"        # Fallback if hat forgets to emit
    max_activations: 10                 # Optional cap on activations
    backend: "claude"                   # Optional backend override
    instructions: |
      Prompt injected when this hat is active.
```

For complete configuration details, see `references/hat-design.md`.

## Hat Schema (Quick Reference)

**CRITICAL**: Read `references/hat-design.md` before creating hats. This is only a quick reference.

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Display name with optional emoji (e.g., "🔍 Analyzer") |
| `description` | Yes | Short description of the hat's purpose (one sentence) |
| `triggers` | Yes | Events that activate this hat (list) |
| `publishes` | Yes | Events this hat can emit (list) |
| `default_publishes` | Recommended | Fallback event if hat forgets to publish |
| `instructions` | Yes | Role-specific prompt (use `\|` for multiline) |
| `max_activations` | Optional | Cap on hat activations |
| `backend` | Optional | Override default backend |

**Fields That DON'T Exist** (avoid these):
- `emoji` → Put emoji in `name` field
- `system_prompt` → Use `instructions`
- `subscriptions` / `publications` → Use `triggers` / `publishes`

## Event Flow Design

**CRITICAL**: Read `references/coordination-patterns.md` before designing event flows.

### Constraints

- Each trigger maps to **exactly ONE** hat (no ambiguous routing)
- `task.start` and `task.resume` are **RESERVED** (never use as triggers)
- Every hat must publish at least one event
- Chain must eventually reach `LOOP_COMPLETE`

### Event Naming Conventions

```
<phase>.ready / <phase>.done           # Phase transitions
<thing>.approved / <thing>.rejected    # Review gates
<noun>.found / <noun>.missing          # Discovery events
<action>.request / <action>.complete   # Request-response
```

**Examples:** `analysis.complete`, `review.approved`, `build.blocked`, `spec.rejected`

### Validation Checklist

Before running preset:
- [ ] Each trigger maps to exactly ONE hat
- [ ] No hat uses `task.start` or `task.resume` as triggers
- [ ] Every hat has `name`, `description`, `triggers`, `publishes`
- [ ] `default_publishes` set for hats with multiple publish options
- [ ] Event chain can reach `LOOP_COMPLETE`
- [ ] No orphan events (warning only)

## Coordination Patterns (Quick Reference)

**CRITICAL**: Read `references/coordination-patterns.md` for complete implementations.

| Scenario | Pattern | Preset |
|----------|---------|--------|
| Sequential phases | Linear Pipeline | `tdd-red-green` |
| Spec approval required | Contract-First | `spec-driven` |
| Multiple perspectives | Cyclic Rotation | `mob-programming` |
| Security review | Adversarial | `adversarial-review` |
| Complex debugging | Hypothesis-Driven | `scientific-method` |
| Standard development | Basic delegation | `feature` |

## CLI Reference

### Commands

| Command | Description |
|---------|-------------|
| `ralph run` | Run orchestration loop (default) |
| `ralph run --continue` | Resume from existing state |
| `ralph events` | View event history |
| `ralph init` | Initialize configuration file |
| `ralph clean` | Clean up `.agent/` directory |
| `ralph emit` | Emit event to event log |
| `ralph tools` | Runtime tools for memories/tasks |

### Runtime Tools

```bash
# Memory management
ralph tools memory add "content" -t pattern --tags tag1,tag2
ralph tools memory search "query"
ralph tools memory prime --budget 2000

# Task management
ralph tools task add "Title" -p 1
ralph tools task list
ralph tools task ready
ralph tools task close <id>
```

For complete runtime tools documentation, see `references/hat-design.md`.

## TUI State Interpretation

When running Ralph with `--tui` mode, understanding the visual state helps diagnose workflow behavior.

### Header Components (Top 3 lines)

| Component | Format | Meaning |
|-----------|--------|---------|
| **Iteration counter** | `[iter N]` or `[iter N/M]` | Current iteration / max iterations |
| **Elapsed time** | `MM:SS` | Time since workflow start |
| **Hat indicator** | `🎩 Hat Name` | Currently active hat |
| **Mode indicator** | `▶ auto` / `⏸ paused` | Loop is running or paused |

### Footer Components (Bottom 3 lines)

| Component | Format | Meaning |
|-----------|--------|---------|
| **Activity state** | `◉ active` / `◯ idle` / `■ done` | Current workflow status |
| **Last event** | `event.name` | Most recent event published |

### State Interpretation Guide

| Observation | Inference |
|-------------|-----------|
| Iteration counter not incrementing | Hat may not be publishing required event |
| Idle countdown approaching zero | Hat is stuck thinking (may need intervention) |
| Same hat stays active across multiple lines | Possible same-iteration switching (bad) |
| `■ done` without completion | Check for orphan events |

**CRITICAL**: If you see routing issues, read `references/troubleshooting.md` immediately.

## Per-Hat Backend Configuration

Different hats can use different backends:

```yaml
cli:
  backend: "claude"  # Default backend

hats:
  builder:
    backend: "claude"

  researcher:
    backend:
      type: "kiro"
      agent: "researcher"  # Kiro with MCP tools

  reviewer:
    backend: "gemini"  # Different model for fresh perspective
```

**CRITICAL**: Read `references/hat-design.md` before configuring backends.

## Quality Standards

**For ALL workflows:**
- **Fresh Context**: Re-read state every iteration
- **Backpressure**: Quality gates reject low-quality work
- **Event Coordination**: Hats communicate via events
- **Clear Instructions**: Detailed guidance for each hat
- **Scratchpad Format**: Structured output

**Priority: Long-Running, Non-Interactive**
Ralph excels at autonomous processing:
- **max_iterations**: 20-50 (not 5-10)
- **max_runtime_seconds**: 3600-7200+ (1-2+ hours)
- **Non-interactive**: No user input during execution
- **Batch processing**: Multiple files, comprehensive analysis

## Backpressure

Ralph enforces quality gates. When a builder publishes `build.done`, include evidence:

```
tests: pass, lint: pass, typecheck: pass
```

This ensures work doesn't proceed without meeting quality standards.

## Critical Rules

- **ALWAYS read references before creating workflows** - This prevents malformed configurations
- **Always start with preset** - never create ralph.yml from scratch
- **Use long-running configuration** - Ralph excels at autonomous processing
- **Trust Fresh Context** - re-reading is reliability, not inefficiency
- **Enforce quality gates** - backpressure prevents bad work

## Troubleshooting

**CRITICAL**: Before attempting any troubleshooting, read `references/troubleshooting.md`.

### Quick Diagnosis

| Symptom | Likely Cause | Action |
|---------|-------------|--------|
| Workflow hangs | Orphan events | Check `ralph events` for event history |
| Same hat active too long | Same-iteration switching | Read `references/troubleshooting.md` |
| Quality rejected | Tests/lint/typecheck failed | Fix actual code issues, don't work around |

For comprehensive troubleshooting, see `references/troubleshooting.md`.

## References

**CRITICAL**: Read these BEFORE performing related tasks:

| Task | Reference | Why Read It |
|------|-----------|-------------|
| Creating/modifying hat configs | `references/hat-design.md` | Complete hat schema, patterns, pitfalls |
| Designing event flows or coordination | `references/coordination-patterns.md` | Full pattern implementations with working examples |
| Writing prompts or instructions | `references/prompt-engineering.md` | Clean publishes, fresh context, quality gates |
| Validating preset behavior | `references/validation.md` | Routing checks, TUI validation, build output |
| Diagnosing routing or TUI issues | `references/troubleshooting.md` | Root cause analysis, common fixes |
| Programmatic Claude execution | `references/claude-automation.md` | Robust patterns, verification protocols |

## Examples

See `examples/` for working code samples:
- `examples/simple-preset.yml` - Basic preset configuration
- `examples/hat-based.yml` - Event-driven hat workflow
- `examples/PROMPT.md` - Task prompt template
