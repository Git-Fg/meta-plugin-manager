# Hat Schema Design Reference

Complete reference for designing hat schemas in Ralph orchestrations.

## Hat Schema Fields

### Required Fields

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `name` | STRING | Display name with optional emoji | `"🔨 Builder"` |
| `description` | STRING | Short description of hat's purpose | `"Implements code changes and runs tests"` |
| `triggers` | ARRAY | Events that activate this hat | `["task.start", "plan.approved"]` |
| `publishes` | ARRAY | Events this hat can emit | `["build.done", "build.blocked"]` |
| `instructions` | MULTILINE | Role-specific prompt | See examples below |

### Optional Fields

| Field | Type | Default | Description |
|--------|------|---------|-------------|
| `default_publishes` | STRING | None | Fallback event if hat forgets to emit |
| `max_activations` | NUMBER | None | Cap on hat activations (prevents infinite loops) |
| `backend` | STRING OR OBJECT | Uses cli.backend | Backend override for this hat |

### Backend Configuration

Hat backends can be specified in three ways:

```yaml
# 1. String (simple backend override)
backend: "gemini"

# 2. Object with type (for Kiro)
backend:
  type: "kiro"
  agent: "researcher"

# 3. Not specified (uses default from cli.backend)
# No backend field = inherit from cli.backend
```

## Instruction Patterns

### Builder Pattern

```yaml
builder:
  name: "🔨 Builder"
  description: "Implements code changes"
  triggers: ["task.start"]
  publishes: ["build.done", "build.blocked"]
  default_publishes: "build.done"
  instructions: |
    ## Builder Phase

    Your job: Implement the task from PROMPT.md.

    ### Process
    1. Read PROMPT.md for requirements
    2. Pick a task from `ralph tools task ready`
    3. Implement the change
    4. Run tests to verify
    5. Publish result

    ### Quality Gates
    - Tests MUST pass
    - Lint MUST pass
    - Document shortcuts

    ### Event Format
    On success: `ralph emit "build.done"`
    On blocked: `ralph emit "build.blocked" "reason: ..."`
```

### Reviewer Pattern

```yaml
reviewer:
  name: "✅ Reviewer"
  description: "Reviews code for quality"
  triggers: ["build.done"]
  publishes: ["review.approved", "review.rejected"]
  default_publishes: "review.approved"
  instructions: |
    ## Reviewer Phase

    Review the changes made by Builder.

    ### Checklist
    - [ ] Tests pass
    - [ ] Code clean
    - [ ] No obvious bugs
    - [ ] Follows conventions

    ### Decision
    If all pass: `ralph emit "review.approved"`
    If issues: `ralph emit "review.rejected" "issue: ..."`
```

### Coordinator Pattern

```yaml
coordinator:
  name: "🎯 Coordinator"
  description: "Detects mode and routes to appropriate workflow"
  triggers: ["workflow.start"]
  publishes: ["design.tests", "execution.ready", "LOOP_COMPLETE"]
  default_publishes: "design.tests"
  instructions: |
    ## Coordinator Phase

    Detect operation mode and route appropriately.

    ### Mode Detection
    - "create", "build", "new" → CREATE mode
    - "test", "re-run", "update results" → TEST mode
    - "audit", "validate", "verify" → AUDIT mode

    ### Routing
    - CREATE/AUDIT → `ralph emit "design.tests"`
    - TEST → `ralph emit "execution.ready"`
    - Complete → `ralph emit "LOOP_COMPLETE"`

    ### STOP After Emitting
    Do not continue working after publishing the routing event.
```

### Confession Pattern

```yaml
validator:
  name: "🔍 Validator"
  description: "Validates with confidence tracking"
  triggers: ["test.passed"]
  publishes: ["confession.clean", "confession.issues_found"]
  default_publishes: "confession.clean"
  instructions: |
    ## Validator Phase

    Cross-reference execution logs against test specs.

    ### Confession Areas
    Be explicit about:
    - Assumptions made
    - Tests not run
    - Edge cases not covered
    - Suspected issues

    ### Confidence Threshold
    - Confidence ≥ 80: `ralph emit "confession.clean"`
    - Confidence < 80: `ralph emit "confession.issues_found"`

    ### Recording Confessions
    ```bash
    ralph tools memory add "confession: uncertainty X" -t context --tags confession
    ```

    ### Validation
    Parse logs before claiming:
    ```bash
    cat .ralph/session.jsonl | jq -s 'map(select(.type == "error"))'
    ```
```

## Event Flow Patterns

### Linear Pipeline

```
A → B → C → LOOP_COMPLETE
```

**Event chain:**
```yaml
hats:
  analyzer:
    triggers: ["workflow.start"]
    publishes: ["analysis.done"]
  builder:
    triggers: ["analysis.done"]
    publishes: ["build.done"]
  tester:
    triggers: ["build.done"]
    publishes: ["LOOP_COMPLETE"]
```

### Critic-Actor Loop

```
Actor → Critic → approved/rejected
                  ↓
       rejected → Actor (retry)
```

**Event chain:**
```yaml
hats:
  actor:
    triggers: ["workflow.start", "review.rejected"]
    publishes: ["work.done"]
  critic:
    triggers: ["work.done"]
    publishes: ["review.approved", "review.rejected"]
```

### Scientific Method

```
Observe → Hypothesize → Test → confirmed/rejected
                                      ↓
                           rejected → Observe
```

**Event chain:**
```yaml
hats:
  observer:
    triggers: ["workflow.start", "test.rejected"]
    publishes: ["observation.done"]
  hypothesizer:
    triggers: ["observation.done"]
    publishes: ["hypothesis.done"]
  tester:
    triggers: ["hypothesis.done"]
    publishes: ["test.confirmed", "test.rejected"]
```

### Supervisor-Worker

```
Supervisor → worker.task → Worker → work.done → Supervisor
```

**Event chain:**
```yaml
hats:
  supervisor:
    triggers: ["workflow.start", "work.done"]
    publishes: ["worker.task", "LOOP_COMPLETE"]
  worker:
    triggers: ["worker.task"]
    publishes: ["work.done"]
```

## Event Naming Conventions

### Phase Transitions
```
<phase>.ready / <phase>.done

Examples:
- design.ready → design.done
- execution.ready → execution.done
- validation.ready → validation.done
```

### Review Gates
```
<thing>.approved / <thing>.rejected

Examples:
- review.approved / review.rejected
- spec.approved / spec.rejected
- design.approved / design.rejected
```

### Discovery Events
```
<noun>.found / <noun>.missing

Examples:
- bug.found / bug.missing
- dependency.found / dependency.missing
- pattern.found / pattern.missing
```

### Request-Response
```
<action>.request / <action>.complete

Examples:
- analysis.request → analysis.complete
- build.request → build.complete
- review.request → review.complete
```

### Status Updates
```
<component>.blocked / <component>.ready / <component>.done

Examples:
- build.blocked (cannot proceed)
- execution.ready (ready to start)
- task.complete (finished successfully)
```

## Common Mistakes

### Mistake 1: Using Reserved Events

```yaml
# BAD: Using reserved events as triggers
hats:
  my_hat:
    triggers: ["task.start"]  # RESERVED - will cause issues

# GOOD: Using custom events
hats:
  my_hat:
    triggers: ["myworkflow.start"]
```

### Mistake 2: No default_publishes

```yaml
# BAD: No fallback for hats with multiple publishes
hats:
  reviewer:
    publishes: ["approved", "rejected"]  # Which one if hat forgets?

# GOOD: Always specify default_publishes for multiple options
hats:
  reviewer:
    publishes: ["approved", "rejected"]
    default_publishes: "approved"  # Assume approval if hat forgets
```

### Mistake 3: Missing STOP Instruction

```yaml
# BAD: No explicit STOP - hat may continue working
coordinator:
  instructions: |
    Route to appropriate workflow.
    Emit the routing event.

# GOOD: Explicit STOP after routing
coordinator:
  instructions: |
    Route to appropriate workflow.
    Emit the routing event.
    STOP - do not continue after emitting.
```

### Mistake 4: Orphan Events

```yaml
# BAD: Event that no hat handles
hats:
  hat_a:
    triggers: ["start"]
    publishes: ["orphan.event"]  # No hat triggers on this!

# GOOD: Complete event chain
hats:
  hat_a:
    triggers: ["start"]
    publishes: ["phase_a.done"]
  hat_b:
    triggers: ["phase_a.done"]
    publishes: ["LOOP_COMPLETE"]
```

### Mistake 5: Ambiguous Routing

```yaml
# BAD: Multiple hats trigger on same event
hats:
  hat_a:
    triggers: ["common.event"]  # Which one activates?
  hat_b:
    triggers: ["common.event"]  # Ambiguous!

# GOOD: Each event maps to exactly one hat
hats:
  hat_a:
    triggers: ["specific.event.a"]
  hat_b:
    triggers: ["specific.event.b"]
```

## Advanced Patterns

### Multi-Backend Setup

```yaml
cli:
  backend: "claude"

hats:
  coder:
    triggers: ["code.task"]
    backend: "claude"  # Best for coding

  researcher:
    triggers: ["research.task"]
    backend:
      type: "kiro"
      agent: "researcher"  # Kiro with MCP tools

  reviewer:
    triggers: ["review.task"]
    backend: "gemini"  # Fresh perspective
```

### Activation Capping

```yaml
hats:
  retry_handler:
    triggers: ["build.failed"]
    max_activations: 3  # Only retry 3 times
    publishes: ["build.done", "build.failed_final"]
    instructions: |
    ## Retry Handler

    Attempt to fix the build failure.
    Maximum 3 retries allowed.

    If fix succeeds: `ralph emit "build.done"`
    If all retries fail: `ralph emit "build.failed_final"`
```

### Conditional Backend Selection

```yaml
hats:
  simple_task:
    triggers: ["simple.request"]
    backend: "claude"  # Fast for simple tasks

  complex_task:
    triggers: ["complex.request"]
    backend: "gemini"  # Better for complex reasoning
```

## Validation Checklist

Before running your preset:

**Event Flow:**
- [ ] Each trigger maps to exactly ONE hat
- [ ] No hat uses `task.start` or `task.resume` as triggers
- [ ] Every hat has at least one publish
- [ ] Event chain can reach `LOOP_COMPLETE`
- [ ] No orphan events (warnings are OK)

**Hat Completeness:**
- [ ] Every hat has `name`, `description`, `triggers`, `publishes`, `instructions`
- [ ] Hats with multiple publishes have `default_publishes`
- [ ] Instructions include event format examples
- [ ] Quality gates are explicit

**Configuration:**
- [ ] `completion_promise` matches final event
- [ ] `max_iterations` is reasonable for workflow complexity
- [ ] `idle_timeout_secs` allows enough time for each hat
- [ ] Backend configuration is correct

**Test with dry-run:**
```bash
ralph run --dry-run
```
