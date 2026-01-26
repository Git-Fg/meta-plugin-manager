# Auto-Recovery Loop

**For:** Understanding Ralph's autonomous recovery mechanism using state injection.

## Overview

The auto-recovery loop enables Ralph to detect issues and self-heal without human intervention or process restart. This preserves orchestration state and maintains context throughout long-running workflows.

## Real-Time Monitoring Checkpoints

**Critical:** Before relying on state inspection for recovery, you MUST monitor Ralph in real-time to catch early failures.

**Time Checkpoints:**
```bash
# Start Ralph with real-time monitoring
ralph run --max-iterations 30 --no-tui --verbose 2>&1 | tee .ralph/latest.log &
tail -f .ralph/latest.log &

# Check these checkpoints
30s  → Claude command should spawn
90s  → First hat should activate
3min → Iterations should progress
```

**If ANY checkpoint fails:**
1. Kill the background process immediately
2. Diagnose from the real-time log
3. Fix the root cause (config, permissions, missing files)
4. Restart Ralph

**Real-time monitoring catches what state inspection misses:**
- Configuration errors (invalid ralph.yml, missing hats)
- Permission issues (file access denied)
- Tool failures (claude not found, wrong version)
- Early infinite loops (same event repeating)

## Recovery Flow Diagram

```mermaid
flowchart TD
    START([Ralph Running]) --> STATE_INSPECT{State Inspection}
    STATE_INSPECT -->|ralph events list| EVENT_FLOW{Event Flow OK?}
    STATE_INSPECT -->|ralph tools task ready| TASK_QUEUE{Task Queue OK?}

    EVENT_FLOW -->|Yes| INVARIANT_CHECK{Invariants Pass?}
    EVENT_FLOW -->|No: Deadlock| DIAGNOSE1[Diagnose State]
    EVENT_FLOW -->|No: Broken Flow| DIAGNOSE1

    TASK_QUEUE -->|Yes| INVARIANT_CHECK
    TASK_QUEUE -->|No: Stuck| DIAGNOSE1

    INVARIANT_CHECK -->|Yes| CONTINUE([Continue Monitoring])
    INVARIANT_CHECK -->|No| DIAGNOSE1

    DIAGNOSE1 --> IDENTIFY[Identify Root Cause]
    IDENTIFY --> INJECT[Inject Fix via Task Add]

    INJECT -->|ralph tools task add<br/>"Fix: diagnosis" -p 1| PROCESS[Ralph Processes Fix]

    PROCESS --> SUCCESS{Fix Applied?}
    SUCCESS -->|Yes| STATE_INSPECT
    SUCCESS -->|No| ESCALATE[Escalate to Main Agent]

    CONTINUE --> STATE_INSPECT
    ESCALATE --> STOP([Manual Intervention Required])

    style STATE_INSPECT fill:#e1f5fe
    style INJECT fill:#c8e6c9
    style PROCESS fill:#fff9c4
    style ESCALATE fill:#ffccbc
    style CONTINUE fill:#e8f5e9
```

## State Inspection Phase

Monitor Ralph's internal state, not external symptoms:

```bash
# Event flow check
ralph events list | tail -20

# Task queue check
ralph tools task ready

# Iteration vs event count
grep -c "_meta.loop_start" .ralph/events.jsonl
grep -c "bus.publish" .ralph/events.jsonl
```

**What we're checking:**
- Event progression (new events appearing periodically)
- Flow integrity (iterations ≈ events, not iterations << events)
- Task queue processing (no stuck tasks)

## Invariant Validation

Preset-specific rules that catch logical errors:

| Preset | Invariant | Violation Detection |
|--------|-----------|---------------------|
| **TDD Red-Green** | Strict alternation | `test_written → test_written` (no passing) |
| **Confession Loop** | Confidence threshold | `confidence < 80` without Handler review |
| **Adversarial Review** | Output required | No `vulnerability.found` OR `security.approved` |
| **Mob Programming** | Perspective rotation | Same perspective >5 consecutive activations |

**Note:** Invariant definitions are preset-specific. See ralph-design skill for invariant patterns.

## State Injection (Recovery)

Instead of killing and restarting, inject fixes into Ralph's task queue:

```bash
# Diagnose
ralph events list | tail -20

# Identify stuck task from event flow
# Example: task.build is waiting for test results

# Inject fix
ralph tools task add "Fix: Run tests to unblock build" -p 1 --blocked-by task.build

# Ralph processes the fix naturally
# No state lost, no restart needed
```

## Recovery Scenarios

### Scenario 1: Deadlock (No New Events)

**Detection:**
```bash
# Iteration counter active but no new events for >5 minutes
tail -1 .ralph/events.jsonl  # Last event timestamp >5 min ago
```

**Diagnosis:** Hat stuck waiting for external condition or hung in infinite loop

**Recovery:**
```bash
# Inject task to unblock
ralph tools task add "Diagnose stuck hat: [hat_name]" -p 1
```

### Scenario 2: Same-Iteration Switching

**Detection:**
```bash
# 2-3 iterations but 5+ events published
iterations=$(grep -c "_meta.loop_start" .ralph/events.jsonl)
events=$(grep -c "bus.publish" .ralph/events.jsonl)
# iterations << events indicates problem
```

**Diagnosis:** Hats not stopping after publishing events

**Recovery:**
```bash
# Inject task to fix hat prompts
ralph tools task add "Add STOP instruction to hat instructions" -p 1
```

### Scenario 3: Invariant Violation

**Detection:**
```bash
# TDD: test written but previous test never passed
# Confession: confidence < 80 without Handler
# Adversarial: Red Team approved without findings
```

**Diagnosis:** Logic error in workflow, not execution error

**Recovery:**
```bash
# Inject task to correct workflow
ralph tools task add "Fix invariant violation: [specific issue]" -p 1
```

### Scenario 4: Task Queue Stuck

**Detection:**
```bash
# Task exists but never completes
ralph tools task list  # Shows status
ralph tools task ready  # Returns stuck task
```

**Diagnosis:** Circular dependency or impossible prerequisite

**Recovery:**
```bash
# Inject task to break cycle or clarify requirements
ralph tools task add "Resolve task dependency: [task_id]" -p 1
```

## When Recovery Fails

Escalate to Main Agent when:

1. **Three recovery attempts fail** - Same issue recurs after fix injection
2. **Conflicting diagnostics** - State inspection gives contradictory signals
3. **External dependency required** - Issue requires human intervention (API keys, permissions)
4. **State corruption detected** - Event file or task queue is corrupted

**Escalation prompt:**
```text
Auto-recovery failed after 3 attempts.
Issue: [diagnosis]
Attempts: [list of injected fixes]
Current state: [ralph events list output]
Manual intervention required.
```

## Comparison: Kill/Restart vs State Injection

| Aspect | Kill/Restart | State Injection |
|--------|--------------|-----------------|
| **State loss** | Complete (lose all context) | Zero (preserves everything) |
| **Downtime** | High (reinitialize entire workflow) | Minimal (process one task) |
| **Context awareness** | No (starts fresh) | Yes (uses current state) |
| **Intervention point** | After failure (reactive) | Before failure (proactive) |
| **Scalability** | Poor (restart cost grows with workflow) | Excellent (constant cost) |

## Implementation Checklist

**Before deploying auto-recovery:**

- [ ] State inspection commands verified working
- [ ] Invariants defined for preset type
- [ ] Monitoring strategy selected (simple → direct, complex → ralph-watchdog)
- [ ] Recovery task templates created
- [ ] Escalation conditions defined
- [ ] Dry run shows complete event flow

**During operation:**

- [ ] State inspections running periodically
- [ ] Invariants validating successfully
- [ ] Recovery tasks being processed
- [ ] No escalation loops (recovery failures escalating)

**After recovery:**

- [ ] Verify fix was applied correctly
- [ ] Check invariants now passing
- [ ] Confirm workflow progressing
- [ ] Log recovery action for audit trail

## References

- **State Inspection Commands:** `claude-integration.md`
- **Monitoring Agent:** ralph-watchdog agent
- **Validation:** `validation-dry-run.md`
- **Invariant Design:** ralph-design skill
