---
name: ralph-design
description: "Ralph Orchestrator design philosophy: hat-based workflows, event coordination, preset selection, and configuration architecture. Use when: designing Ralph workflows, choosing presets, creating hat schemas, planning event flows, or configuring ralph.yml. NOT for: CLI command syntax or execution monitoring."
---

# Ralph Orchestrator Design

Design philosophy for Ralph hat-based workflows: event coordination, preset selection, hat schema design, and configuration architecture.

## Core Philosophy

**Fresh Context** + **Backpressure** = reliable automation

- **Fresh Context**: Each loop starts clean, re-reading state every iteration
- **Backpressure**: Quality gates reject bad work
- **Event Coordination**: Hats communicate via events, not assumptions
- **The Plan Is Disposable**: Regeneration is cheap
- **Let Ralph Ralph**: Autonomous iteration over micromanagement

### Fresh Context Principle

Each hat executes in its **own iteration** with fresh context:

```
Iter 1: Ralph → publishes starting event → STOPS
Iter 2: Hat A → does work → publishes next event → STOPS
Iter 3: Hat B → does work → publishes next event → STOPS
Iter 4: Hat C → does work → LOOP_COMPLETE
```

**Why this matters**: Re-reading state is reliability, not inefficiency. Each iteration starts clean with current state from scratchpad and memories.

### Backpressure Principle

Quality gates reject bad work. Hats must publish evidence:

```
tests: pass, lint: pass, typecheck: pass
```

This ensures work doesn't proceed without meeting quality standards.

## Two Orchestration Approaches

### Preset Workflows

Start with proven patterns for common tasks.

```bash
ralph init --preset <name>
ralph run
```

**Ideal for:**
- Features, reviews, debugging, documentation
- Quick setup with predictable structure
- Common workflows with proven patterns

### Adaptive Framework

Single workflow handles comprehensive analysis with auto-detection.

```bash
# Create PROMPT.md with analysis requirements
ralph emit "audit.start"
```

**Ideal for:**
- Comprehensive codebase analysis
- Spec verification
- Automatic fixing

## Decision Matrix

| Goal | Approach | Setup |
|------|----------|-------|
| Build feature quickly | Preset | `ralph init --preset feature` |
| Find and fix issues | Adaptive Framework | Create PROMPT.md + run |
| Review code quality | Preset | `ralph init --preset review` |
| Debug specific bug | Preset | `ralph init --preset debug` |
| Write documentation | Preset | `ralph init --preset docs` |

## Preset Selection

### Decision Tree

```
START: What do you want to accomplish?
│
├─ Build new functionality
│  ├─ Test-first required? → tdd-red-green
│  ├─ Spec-driven? → spec-driven
│  ├─ Docs-first? → documentation-first
│  └─ Standard feature → feature
│
├─ Review or audit
│  ├─ Security focus → adversarial-review
│  └─ Standard review → review
│
├─ Debug or investigate
│  ├─ Specific bug → debug
│  └─ Legacy code → code-archaeology
│
└─ Write documentation
   └─ General docs → docs
```

### Preset Catalog

**Always check available presets first:**

```bash
ralph init --list-presets
```

**Common preset categories:**

| Category | Typical Presets |
|----------|----------------|
| **Development** | feature, feature-minimal, tdd-red-green, spec-driven, refactor |
| **Review & Quality** | review, pr-review, adversarial-review, confession-loop |
| **Analysis & Debugging** | debug, scientific-method, code-archaeology, gap-analysis, research |
| **Learning** | socratic-learning |
| **Collaboration** | mob-programming |
| **Operations** | deploy, incident-response, migration-safety, performance-optimization |
| **Design** | api-design, documentation-first |
| **Documentation** | docs |
| **Utilities** | hatless-baseline, merge-loop |

### Setup Process

**ALWAYS start with a preset** - never create ralph.yml from scratch:

1. **List presets**: `ralph init --list-presets`
2. **Select preset**: Choose from Decision Matrix
3. **Initialize**: `ralph init --preset <name>`
4. **Review configuration**: Read generated ralph.yml
5. **Customize** (if needed):
   - Adjust hat instructions
   - Update event names
   - Modify quality gates
   - Add project context
6. **Create PROMPT.md**: Write task in human-readable format
7. **Run**: `ralph run`

**When to customize vs choose different preset:**
- **Light edits**: Change names, minor instructions, quality gates
- **Choose different preset**: If changing >50% of structure
- **Ask user**: If fundamental changes needed

## Hat Schema Design

### Required Hat Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Display name with optional emoji (e.g., "🔍 Analyzer") |
| `description` | Yes | Short description of the hat's purpose |
| `triggers` | Yes | Events that activate this hat (list) |
| `publishes` | Yes | Events this hat can emit (list) |
| `default_publishes` | Recommended | Fallback event if hat forgets to publish |
| `instructions` | Yes | Role-specific prompt (use `\|` for multiline) |
| `max_activations` | Optional | Cap on hat activations |
| `backend` | Optional | Override default backend |

### Fields That DON'T Exist

Avoid these - they're not in the schema:
- `emoji` → Put emoji in `name` field
- `system_prompt` → Use `instructions`
- `subscriptions` / `publications` → Use `triggers` / `publishes`

### Complete Hat Example

```yaml
hats:
  builder:
    name: "🔨 Builder"
    description: "Implements code changes and runs tests"
    triggers: ["task.start", "plan.approved"]
    publishes: ["build.done", "build.blocked"]
    default_publishes: "build.done"
    max_activations: 50
    backend: "claude"
    instructions: |
      ## Builder Phase

      Your job: Implement the task from PROMPT.md.

      ### Process
      1. Read the task from PROMPT.md
      2. Pick one task from `ralph tools task ready`
      3. Implement the change
      4. Run tests: `cargo test` or `npm test`
      5. If tests pass: Publish `build.done`
      6. If blocked: Publish `build.blocked` with reason

      ### Quality Gates
      - Tests MUST pass before publishing `build.done`
      - Lint MUST pass (check with `cargo clippy` or equivalent)
      - Document any shortcuts taken

      ### Event Format
      ```bash
      ralph emit "build.done" "tests: pass, implementation: complete"
      # Or if blocked:
      ralph emit "build.blocked" "blocked on: external API unavailable"
      ```

      ### Don't
      - Don't skip tests
      - Don't publish `LOOP_COMPLETE` (that's for coordinator)
      - Don't ignore backpressure

  reviewer:
    name: "✅ Reviewer"
    description: "Reviews code changes for quality"
    triggers: ["build.done"]
    publishes: ["review.approved", "review.rejected"]
    default_publishes: "review.approved"
    instructions: |
      ## Reviewer Phase

      Review the changes made by Builder.

      ### Checklist
      - [ ] Tests pass
      - [ ] Code is clean and readable
      - [ ] No obvious bugs
      - [ ] Follows project conventions

      ### Decision
      - If all checks pass: Publish `review.approved`
      - If issues found: Publish `review.rejected` with specific feedback

      ### Event Format
      ```bash
      ralph emit "review.approved" "quality: good, tests: pass"
      # Or if rejected:
      ralph emit "review.rejected" "issue: missing error handling"
      ```
```

## Event Flow Design

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

### Clean Publishes Pattern

Ralph v2 Architecture: YAML files define **Business Logic** (the "What"). The Ralph binary automatically injects **Mechanics** (the "How") at runtime.

**Good - Just Use Publish:**
```yaml
hats:
  builder:
    publishes: ["build.done"]
    instructions: |
      When complete, publish build.done
```

**Bad - Don't Show Internal Mechanics:**
```yaml
instructions: |
  When work is complete, write to .ralph/events.jsonl:
  {"topic": "build.done", "data": {"status": "complete"}}
```

### Validation Checklist

Before running preset:
- [ ] Each trigger maps to exactly ONE hat
- [ ] No hat uses `task.start` or `task.resume` as triggers
- [ ] Every hat has `name`, `description`, `triggers`, `publishes`
- [ ] `default_publishes` set for hats with multiple publish options
- [ ] Event chain can reach `LOOP_COMPLETE`
- [ ] No orphan events (warning only)

## Coordination Patterns

### Core Patterns

| Scenario | Pattern | Preset |
|----------|---------|--------|
| Sequential phases | Linear Pipeline | `tdd-red-green` |
| Spec approval required | Contract-First | `spec-driven` |
| Multiple perspectives | Cyclic Rotation | `mob-programming` |
| Security review | Adversarial | `adversarial-review` |
| Complex debugging | Hypothesis-Driven | `scientific-method` |
| Confidence-aware completion | Confession Loop | `confession-loop` |
| Specialist tasks | Coordinator-Specialist | `gap-analysis` |
| Standard development | Basic delegation | `feature` |

### Pattern Implementations

#### Pipeline (Sequential)
```
A → B → C → done
```
**Use for:** Analysis workflows, document processing
**Example:** `analyze → summarize → report → LOOP_COMPLETE`

#### Critic-Actor (Review Loop)
```
Actor → Critic → approved/rejected
                    ↓
         rejected → Actor (retry)
```
**Use for:** Code review, quality gates

#### Supervisor-Worker
```
Supervisor → worker.task → Worker → work.done → Supervisor
```
**Use for:** Complex task decomposition

#### Scientific Method
```
Observe → Hypothesize → Test → confirmed/rejected
                                    ↓
                         rejected → Observe
```
**Use for:** Debugging, investigation

## Complex Monitoring Mode

**For:** Multi-hat coordination workflows requiring intelligent supervision.

### Trigger Detection

Trigger **Complex Monitoring Mode** when the selected preset involves:
- **Multi-hat coordination**: `confession-loop`, `adversarial-review`, `mob-programming`
- **Cyclic patterns**: Workflows that rotate through hats repeatedly
- **Adversarial processes**: Red team / blue team, critic-actor patterns
- **Confidence-aware loops**: Workflows with confidence scoring and quality gates

### Monitoring Strategy

When Complex Monitoring Mode is triggered, delegate to the **ralph-watchdog agent**:

1. Uses **state inspection** (ralph events, ralph tools task ready) instead of log parsing
2. Monitors **logical patterns** (e.g., "Did Red Team actually find vulnerabilities?")
3. Validates **event flow integrity** (no same-iteration switching)
4. Checks **invariant compliance** (preset-specific rules)
5. Reports every **2 minutes** or on **immediate escalation**

## Hat Routing Performance Validation

Validate that hats get fresh context each iteration (Tenet #1: Fresh Context Is Reliability).

### How to Check

**Count iterations vs events:**
```bash
# Count iterations
grep -c "_meta.loop_start\|ITERATION" .ralph/events.jsonl

# Count events published
grep -c "bus.publish" .ralph/events.jsonl
```

**Expected:** iterations ≈ events published (one event per iteration)
**Bad sign:** 2-3 iterations but 5+ events (all work in single iteration)

### Routing Performance Triage

| Pattern | Diagnosis | Action |
|---------|-----------|--------|
| iterations ≈ events | ✅ Good | Hat routing working |
| iterations << events | ⚠️ Same-iteration switching | Check prompt has STOP instruction |
| iterations >> events | ⚠️ Recovery loops | Agent not publishing required events |
| 0 events | ❌ Broken | Events not being read from JSONL |

## Programmatic Claude Execution

For hats that execute Claude autonomously (external testing, CI/CD).

### Robust Pattern

```bash
cd <target_directory>/

claude \
  --print \
  --output-format stream-json \
  --permission-mode acceptEdits \
  --no-session-persistence \
  -p "Execute workflow..." \
  | tee raw_log.json
```

**Critical flags:**
- `--print` - Non-interactive output mode
- `--output-format stream-json` - Structured telemetry for parsing
- `--permission-mode` - Granular permission control
- `--no-session-persistence` - Prevent context pollution
- `--max-turns <N>` - Limit agentic turns

## Configuration Reference

### Core Configuration Schema

```yaml
# Event loop settings
event_loop:
  completion_promise: "LOOP_COMPLETE"  # Output that signals completion
  max_iterations: 100                   # Maximum orchestration loops
  max_runtime_seconds: 14400            # 4 hours max runtime
  idle_timeout_secs: 1800               # 30 min idle timeout
  starting_event: "task.start"          # First event published
  prompt_file: "PROMPT.md"              # Optional: prompt injection file
  checkpoint_interval: 5                # Checkpoint every N iterations

# CLI backend settings
cli:
  backend: "claude"                     # claude, kiro, gemini, codex, amp, custom
  prompt_mode: "arg"                    # arg (CLI argument) or stdin

# Core behaviors (always injected into prompts)
core:
  scratchpad: ".agent/scratchpad.md"    # Shared memory across iterations
  specs_dir: "./specs/"                 # Directory for specifications
  guardrails:                           # Rules injected into every prompt
    - "Fresh context each iteration - scratchpad is memory"
    - "Don't assume 'not implemented' - search first"
    - "Backpressure is law - tests/typecheck/lint must pass"

# Memories - persistent learning across sessions
memories:
  enabled: true                         # Set false to disable
  inject: auto                          # auto, manual, or none
  budget: 2000                          # Max tokens to inject (0 = unlimited)
  filter:
    types: []                           # Filter by type: pattern, decision, fix, context
    tags: []                            # Filter by tags
    recent: 0                           # Only memories from last N days (0 = no limit)

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

### Memory Configuration

| Setting | Values | Purpose |
|---------|--------|---------|
| `enabled` | `true`/`false` | Enable/disable memory system |
| `inject` | `auto`, `manual`, `none` | How memories enter context |
| `budget` | Number (0=unlimited) | Token limit for memory injection |
| `filter.types` | Array of types | Filter: `pattern`, `decision`, `fix`, `context` |
| `filter.tags` | Array of tags | Filter by tag names |
| `filter.recent` | Days (0=no limit) | Only recent memories |

**Memory Types:**
| Type | Purpose | Example |
|------|---------|---------|
| `pattern` | Recurring code patterns | "shortcut: used X instead of Y because..." |
| `decision` | Architectural decisions | "assumption: API returns sorted results" |
| `fix` | Bug fixes and solutions | "uncertainty: not sure if edge case Z is handled" |
| `context` | Project-specific context | "convention: always use snake_case for DB columns" |

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

## Build Output Management

When hats execute builds or tests, manage output efficiently for validation and debugging.

### Output Capture Pattern

```bash
# Basic pattern
[build-command] > build_output.log 2>&1

# Example
cargo test > test_output.log 2>&1
npm run build > build_output.log 2>&1
```

### Validation Commands

```bash
# Check for success patterns
grep -E "test.*pass|build.*success|PASSED" build_output.log

# Check for failure patterns
grep -E "error|fail|FAILED" build_output.log

# Count test results
grep -c "PASSED" build_output.log
grep -c "FAILED" build_output.log
```

### Exit Code Interpretation

| Exit Code | Meaning | Action |
|-----------|---------|--------|
| 0 | Success | Continue workflow |
| 1-125 | Command failed | Apply backpressure, fix issues |
| 124 | Timeout | Command hung, investigate |
| 126 | Command not found | Check environment setup |
| 127 | Command not found | Check PATH, installation |

## TUI State Interpretation

### Header Components (Top 3 lines)

| Component | Format | Meaning |
|-----------|--------|---------|
| **Iteration counter** | `[iter N]` or `[iter N/M]` | Current iteration / max iterations |
| **Elapsed time** | `MM:SS` | Time since workflow start |
| **Hat indicator** | `🎩 Hat Name` | Currently active hat |
| **Mode indicator** | `▶ auto` / `⏸ paused` | Loop is running or paused |
| **Idle countdown** | `idle: Ns` | Seconds until idle timeout |

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
| Activity stuck on `◉ active` for long time | Workflow may be hung |
| `■ done` without completion | Check for orphan events |

## Critical Rules

- Investigate if needed → Choose workflow approach → Implement with quality standards → Run loops
- Always start with preset - never from scratch
- Use long-running configuration - Ralph excels at autonomous processing
- Trust Fresh Context - re-reading is reliability, not inefficiency
- Enforce quality gates - backpressure prevents bad work

## Troubleshooting

### Orphaned Loops
**Diagnosis**: Ralph waits for an event that no hat handles.
**Fix**: Ensure hats publish events matching subsequent hat triggers.

### Hang Diagnosis
If workflow hangs:
1. Check `ralph events` for event history
2. Verify trigger/publish event names match
3. Ensure no hat is waiting for an event that never comes

### Backpressure Rejection
**Diagnosis**: Quality gates (tests/lint/typecheck) failed.
**Fix**: Fix the actual code quality issues. Don't work around backpressure.
