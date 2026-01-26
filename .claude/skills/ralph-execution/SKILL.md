---
name: ralph-execution
description: "Execute and monitor Ralph orchestrations using session recording, log-first validation, event-driven monitoring, and parallel loop management. Use for: creating PROMPT.md, running ralph with structured output, validating via log parsing, intelligent error detection, and auto-recovery loops. NOT for configuration design."
---

# Ralph Execution

Execute and monitor Ralph orchestrations using session recording, log-first validation, event-driven monitoring, and parallel loop management.

## State Directory Architecture

**Important:** Ralph uses two distinct state directories:

| Directory | Purpose | Contents |
|-----------|---------|----------|
| `.ralph/` | Ralph CLI runtime state | events.jsonl, session.jsonl, hats/ |
| `.agent/` | Orchestrator state | memories.md, tasks.jsonl, sandbox/ |

**Always reference:** `.ralph/session.jsonl` (if recording enabled) and `.ralph/events.jsonl` for runtime state inspection.

## Core Philosophy

**Old Way:** Shell scripts, `&` backgrounding, manual PID tracking, tee redirection.
**New Way:** Structured session recording + log-first validation + event-driven monitoring.

**Key Principle:** Never claim something worked without parsing the log. Session recording produces parseable evidence; event filtering enables phase-specific monitoring.

**Monitoring = Observation + Validation:**
- **Session recording:** Structured JSONL capture (no more manual tee)
- **Log-first validation:** Parse logs before making claims (prevent hallucination)
- **Event-driven monitoring:** Filter by topic/iteration for phase-specific debugging

## The Log-First Validation Principle

**CRITICAL:** Always parse logs before claiming anything worked. Never trust stdout or assumption.

### Why Log-First Matters

| What You Might Think | What Log Actually Shows |
|---------------------|------------------------|
| "The skill triggered" | `No such skill found` (never loaded) |
| "Tests passed" | `cargo test: error: not found` (never ran) |
| "Component validated" | `I don't have access to that path` (wrong dir) |

### Validation Hierarchy

```
1. Parse session.jsonl (PRIMARY SOURCE)
   ↓
2. Cross-reference events.jsonl
   ↓
3. Check task queue state
   ↓
4. Only THEN claim success/failure
```

### Parsing Commands

```bash
# Session recording output (structured telemetry)
cat .ralph/session.jsonl | jq -s 'map(select(.type == "message")) | .[0:5]'

# Event flow validation
ralph events --last 20 --format json | jq '.[] | select(.topic | contains("test"))'

# Component loading verification
grep -E "skill|command|agent" .ralph/session.jsonl | jq -r '.content' | head -5

# Tool usage evidence
cat .ralph/session.jsonl | jq -s 'map(select(.type == "tool_use")) | length'
```

## Decision Tree: Choose Monitoring Strategy

```
START: What workflow type are you running?
│
├─ Simple preset (feature-minimal, docs, simple refactor)
│  └─ → Session Recording + Real-Time Event Monitoring
│     - ralph run --record-session .ralph/session.jsonl
│     - ralph events --topic "<phase>" for phase tracking
│     - Parse session.jsonl for validation
│     - Stop on no progress for 90s
│
├─ Complex preset (confession-loop, adversarial-review, mob-programming)
│  └─ → Use Task tool to launch ralph-watchdog agent
│     - Subagent uses event filtering + state inspection
│     - Validates preset-specific invariants
│     - Reports every 2 minutes, escalates on pattern breaks
│
├─ Batch testing (multiple components)
│  └─ → Parallel Loop Management
│     - ralph run --no-auto-merge for worktree isolation
│     - ralph loops list to monitor all parallel runs
│     - ralph loops diff <ID> to review changes before merge
│
└─ Error detected during execution
   └─ → Kill immediately, parse log, fix, restart
      - Parse session.jsonl for root cause
      - Fix configuration/permissions/missing files
      - Restart with corrected setup
```

**Key decision factors:**
- **Workflow complexity:** Simple → session recording; complex → subagent; batch → parallel loops
- **Duration:** <30 min → direct; >30 min → subagent
- **Validation:** Always parse logs before claiming success

## Workflow 1: Session Recording (Standard)

Use this for most Ralph runs. Structured JSONL output replaces manual tee redirection.

### 1. Prepare PROMPT.md

Ensure the standard Ralph format (Requirements/Constraints/Success Criteria).

### 2. Execute with Session Recording

```bash
# Start Ralph with structured session recording
ralph run --record-session .ralph/session.jsonl --no-tui
```

**Session recording produces:**
- Structured JSONL (parseable with jq)
- Turn-by-turn telemetry
- Tool usage tracking
- Error event capture
- Timestamp metadata

### 3. Real-Time Monitoring (Critical)

Monitor Ralph's execution CONTINUOUSLY while it runs. Never wait until completion to check status.

**Event-Driven Monitoring (NEW):**

```bash
# Monitor specific workflow phases
ralph events --topic "workflow.start"    # Initial phase
ralph events --topic "design.tests"      # Test design phase
ralph events --topic "execution"         # Execution phase
ralph events --topic "confession"        # Validation phase

# Debug hat switching
ralph events --iteration 5               # What happened in iteration 5?
ralph events --last 10                   # Recent events only

# Export for analysis
ralph events --format json > events.json
```

**Process Deviation Detection:**
- After 30s: Should see Claude command spawn (parse session.jsonl)
- After 90s: Should see first hat activation (check events)
- After 3min: Should see iteration progression
- If no progress after 90s: Configuration issue, fix immediately

**Log-First Validation (CRITICAL):**

Before claiming anything worked, parse the session:

```bash
# 1. Check component loaded
cat .ralph/session.jsonl | jq -r '.content' | grep -E "skill|command|agent" | head -3

# 2. Check tools were used
cat .ralph/session.jsonl | jq -s 'map(select(.type == "tool_use")) | length'

# 3. Check for errors
cat .ralph/session.jsonl | jq -s 'map(select(.type == "error"))'

# 4. Only THEN claim success/failure
```

**Success Criteria (LOG-BASED):**
- Session shows component loaded (not just claimed)
- Tool count > 0 (actual tool usage)
- No error events in session
- Event flow shows completion

**Failure Criteria (LOG-BASED):**
- Session shows "No such skill/command/agent" (loading failure)
- Tool count = 0 (never executed)
- Error events present
- Event flow shows incomplete chain

### 4. Parse and Validate

After completion, always validate by parsing:

```bash
# Parse session for component loading
cat .ralph/session.jsonl | jq -s 'map(select(.type == "message")) | .[0:3]'

# Parse events for flow validation
ralph events --format json | jq '.[] | {topic, iteration}'

# Count iterations vs events (hat routing health)
grep -c "_meta.loop_start\|ITERATION" .ralph/events.jsonl
grep -c "bus.publish" .ralph/events.jsonl

# Expected: iterations ≈ events (one event per iteration)
# Bad sign: 2-3 iterations but 5+ events (same-iteration switching)
```

## Event-Driven Monitoring (NEW)

For complex hat-based workflows with many events, use topic/iteration filtering.

### Phase-Specific Monitoring

```bash
# Monitor design phase
ralph events --topic "design" --format json | jq '.[] | .data'

# Monitor execution phase
ralph events --topic "execution" --last 20

# Monitor validation issues
ralph events --topic "confession" --format json

# Monitor task completion
ralph events --topic "test.passed" --last 10
```

### Iteration-Level Debugging

```bash
# What happened in specific iteration?
ralph events --iteration 15

# Track hat switching over time
ralph events --format json | jq '.[] | {iteration, topic}'

# Find same-iteration switching (BAD)
# Pattern: multiple events with same iteration number
ralph events --format json | jq -r '.iteration' | sort | uniq -c | grep -v '^ *1'
```

### Event Flow Validation

```bash
# Check event chain completeness
ralph events --format json | jq -r '.topic' | sort -u

# Should show complete chain:
# workflow.start → design.tests → tests.designed → execution.ready → test.passed → WORKFLOW_COMPLETE

# Missing events indicate broken flow
```

## Workflow 2: Parallel Loop Management (Batch Workflows)

For workflows testing multiple components in parallel, use worktree isolation.

### 1. Start Parallel Execution

```bash
# Prevent auto-merge (manual review of each loop)
ralph run --no-auto-merge -p "test all components in batch"
```

Each loop spawns into its own worktree for true isolation.

### 2. Monitor All Loops

```bash
# List all loops (running/completed)
ralph loops list

# View specific loop output
ralph loops logs <LOOP_ID>

# Follow loop output in real-time
ralph loops logs <LOOP_ID> -f
```

### 3. Validate Before Merging

```bash
# Review changes from merge-base
ralph loops diff <LOOP_ID>

# Check event history for issues
ralph loops history <LOOP_ID> --json
```

### 4. Selective Merge

```bash
# Merge only successful loops
ralph loops merge <LOOP_ID>

# Discard failed loops (clean up worktree)
ralph loops discard <LOOP_ID> -y
```

### 5. Cleanup

```bash
# Clean up stale loops (crashed processes)
ralph loops prune

# Stop a runaway loop
ralph loops stop <LOOP_ID> --force
```

**Benefits of Parallel Loops:**
- True isolation (each component in separate worktree)
- Parallel execution (multiple tests run simultaneously)
- Selective merging (keep only what passes)
- Clean rollback (discard removes worktree entirely)

## Workflow 3: Subagent Delegation (Complex Workflows)

Use for tasks requiring deep reasoning during execution (>30 min) or preset-specific validation.

### 1. Delegate to ralph-watchdog Agent

**Use the Task tool to launch the ralph-watchdog agent:**

```text
Launch ralph-watchdog agent (subagent_type: general-purpose) with:
- Start "ralph run --record-session .ralph/session.jsonl"
- Monitor via event filtering: ralph events --topic "<phase>"
- Parse session.jsonl for validation (log-first)
- Perform auto-recovery via state injection if errors occur
- Report status every 2 minutes or on critical failure
```

**The ralph-watchdog agent** (`.claude/agents/ralph-watchdog.md`) handles:
- Event-driven monitoring (topic/iteration filtering)
- Log-first validation (parse session.jsonl before claiming)
- Diagnosing flow issues (deadlock, same-iteration switching)
- Preset-specific validation (confession-loop, adversarial-review)
- Injecting recovery tasks without killing process
- Structured reporting with session references

### 2. Main Agent Role

- Review watchdog's status updates every 2 minutes
- Intervene only if watchdog flags unresolvable issue

## Recovery Pattern: State Injection

**Principle:** Inject fixes into Ralph's task queue instead of killing and restarting.

**When to use:**
- Deadlock detected (no new events but iteration active)
- Hat stuck waiting for external condition
- Recoverable error (syntax, config)

**When to kill/restart:**
- Hat broken at instruction level
- Configuration error prevents startup
- No progress after 90 seconds

### State Injection Process

```bash
# 1. Diagnose via event filtering
ralph events --last 20 --topic "<current_phase>"

# 2. Parse session for root cause
cat .ralph/session.jsonl | jq -s 'map(select(.type == "error"))'

# 3. Identify stuck task
ralph tools task list

# 4. Inject fix task
ralph tools task add "Fix: [specific diagnosis from log]" -p 1 --blocked-by <stuck_task_id>

# 5. Ralph processes naturally (no restart needed)
```

**Benefits:**
- Zero downtime (no restart)
- Preserves orchestration state
- Utilizes Ralph's internal dependency resolution

## Confession Pattern Analysis (NEW)

For workflows using confession systems (validation with uncertainty tracking), use enhanced memory search.

### Search Confession Patterns

```bash
# Search all confession memories
ralph tools memory search --tags confession --format json

# Search by confession type
ralph tools memory search -t context --tags confession

# Search for specific issues
ralph tools memory search "structural_violation" --tags confession --format json
```

### Prime Context with Prior Confessions

```bash
# Inject prior confessions before new validation
ralph tools memory prime -t context --tags confession --budget 1000

# Prime specific confession types
ralph tools memory prime -t decision --tags confession --recent 7
```

### Export for Analysis

```bash
# Export confessions for pattern analysis
ralph tools memory search --tags confession --format json > confessions.json

# Analyze patterns
cat confessions.json | jq -r '.[] | .content' | sort -u
```

## Troubleshooting & Diagnostics

### Diagnosis via Log-First Validation

**CRITICAL:** Always parse logs before diagnosing. Never rely on stdout or assumption.

```bash
# 1. Parse session for errors (PRIMARY SOURCE)
cat .ralph/session.jsonl | jq -s 'map(select(.type == "error"))'

# 2. Check component loaded
cat .ralph/session.jsonl | jq -r '.content' | grep -E "skill|command|agent"

# 3. Verify tool usage
cat .ralph/session.jsonl | jq -s 'map(select(.type == "tool_use")) | length'

# 4. Cross-reference events
ralph events --last 20 --format json | jq '.[] | {topic, data}'

# 5. Check task queue
ralph tools task ready
```

### Common Failure Patterns (from logs)

| Log Pattern | Diagnosis | Fix |
|-------------|-----------|-----|
| "No such skill/command/agent" | Component not loaded | Check path, verify file exists |
| "I don't have access to..." | Permission/path issue | Check working directory |
| Tool count = 0 | Never executed | Check prompt/instructions |
| Same iteration, multiple events | Same-iteration switching | Check prompt has STOP instruction |
| Error events present | Actual failure | Parse error details |

### Session Replay for Debugging

```bash
# Record session for later analysis
ralph run --record-session .ralph/session.jsonl

# Replay for debugging (if supported)
ralph run --replay-session .ralph/session.jsonl

# Parse replay for validation
cat .ralph/session.jsonl | jq -s 'map(select(.type == "tool_use"))'
```

### Dry Run Mode

Validate Ralph configuration without executing:

```bash
# Preview what Ralph would do
ralph run --dry-run
```

**What dry-run shows:**
- Hat activation sequence
- Event routing (trigger → hat → publish)
- Configuration validation (missing fields, invalid events)
- Expected completion path

### Checkpoint Resume

Ralph handles internal checkpoints. To resume:

```bash
ralph run --continue --no-tui --record-session .ralph/session.jsonl
```

## Quick Reference: Modern Commands

| Intent | Prompt to Claude |
| :--- | :--- |
| **Start** | "Run `ralph run --record-session .ralph/session.jsonl` in background." |
| **Watch Events** | "Monitor events: `ralph events --topic <phase>` for phase tracking." |
| **Validate** | "Parse session.jsonl FIRST before claiming anything worked." |
| **Check State** | "Run `ralph events --last 20` and `ralph tools task ready`." |
| **Diagnose** | "Parse session.jsonl for errors, cross-reference events." |
| **Recover** | "Inject fix via `ralph tools task add` - don't kill unless necessary." |
| **Stop** | "Kill background task (only as last resort)." |
| **Parallel Loops** | "List: `ralph loops list`. View: `ralph loops logs <ID>`. Diff: `ralph loops diff <ID>`." |
| **Resume** | "Run `ralph run --continue --no-tui` to resume." |
| **Dry Run** | "Run `ralph run --dry-run` to validate." |
| **Confessions** | "Search: `ralph tools memory search --tags confession`." |

## Integration Notes

- **Session Recording:** Use `ralph run --record-session .ralph/session.jsonl` (replaces tee)
- **Log-First Validation:** ALWAYS parse session.jsonl before claiming success
- **Event Filtering:** Use `ralph events --topic <topic>` for phase-specific monitoring
- **Iteration Debugging:** Use `ralph events --iteration <N>` to debug hat switching
- **State Inspection:** Use `ralph events --last 20` and `ralph tools task ready` periodically
- **Output Formats:** Use `ralph events --format json` for programmatic access
- **Checkpoint Resume:** Use `ralph run --continue` to resume from scratchpad
- **Dry Run:** Use `ralph run --dry-run` to validate configuration
- **Autonomous Mode:** Use `ralph run --autonomous` for headless, non-interactive
- **Parallel Loops:** Use `ralph run --no-auto-merge` + `ralph loops` for batch workflows
- **Loop Management:** Use `ralph loops list/diff/merge/discard` for parallel execution
- **Confession Search:** Use `ralph tools memory search --tags confession --format json`
- **Merge Control:** Use `ralph run --no-auto-merge` for manual worktree review
- **Exclusive Execution:** Use `ralph run --exclusive` to wait for primary loop slot
- **Idle Timeout:** Ralph stops if no hat activates for idle_timeout (default: 30s TUI)
- **Timeouts:** Default foreground timeout is 2m. Always use background for Ralph runs.
- **Cleanup:** Claude Code auto-cleans background tasks, but archive `.ralph/` if needed.
- **Prune Stale Loops:** Use `ralph loops prune` to clean up crashed processes.
