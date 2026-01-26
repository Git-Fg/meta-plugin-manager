# Subagent Monitoring Protocol

**For:** Complex, long-running Ralph orchestrations requiring intelligent supervision.

## Role: Orchestration Auditor

The monitoring subagent acts as an independent auditor that watches Ralph's event flow to verify logical patterns—not just parse logs for errors.

## Subagent Responsibilities

### 1. Event Flow Validation

Monitor the logical integrity of hat transitions and event publishing.

```text
Watch for:
- Proper hat activation sequence (A → B → C, not A → A → A)
- Event publishing rhythm (one event per iteration expected)
- State transitions (not stuck in same hat repeatedly)
- Logical completion (orchestration reaches LOOP_COMPLETE)
```

### 2. Pattern-Specific Validation

Different presets require different validation logic:

**Confession Loop:**
- Verify confession events contain confidence scores
- Check that confidence < 80 triggers Handler review
- Ensure low confidence doesn't silently pass through

**Adversarial Review:**
- Verify Red Team actually attempts attacks (not just "looks good")
- Check for vulnerability.found OR security.approved (not neither)
- Ensure Red Team doesn't approve immediately without scrutiny

**Mob Programming:**
- Verify rotation through all perspectives
- Check that each voice contributes meaningfully
- Ensure no single perspective dominates

### 3. State Inspection (Not Log Parsing)

Use Ralph's state commands for monitoring:

```bash
# Event flow check
ralph events list | tail -20

# Task queue check
ralph tools task ready

# Iteration vs event count
grep -c "_meta.loop_start" .ralph/events.jsonl
grep -c "bus.publish" .ralph/events.jsonl
```

### 4. Escalation Conditions

Alert the Main Agent only when patterns break:

| Pattern | Break Condition | Escalation Action |
|---------|-----------------|-------------------|
| **Same-iteration switching** | iterations << events (5+ events, 2-3 iterations) | Prompt has missing STOP instruction |
| **Deadlock** | Active iteration, no new events for >5 min | Hat stuck waiting for condition |
| **Confession bypass** | confidence < 80 without Handler intervention | Inject review task |
| **Adversarial collapse** | Red Team approves without finding issues | Prompt deeper scrutiny |
| **Hat starvation** | Same hat active >10 consecutive iterations | Check event routing |

## Subagent Prompt Template

```text
You are an Orchestration Auditor for Ralph. Monitor this workflow:

1. Start: ralph run --no-tui --verbose 2>&1 | tee .ralph/latest.log
2. Monitor state every 5 minutes using:
   - ralph events list (event flow)
   - ralph tools task ready (pending work)
3. Validate pattern integrity for [PRESET_NAME]:
   - [Pattern-specific checks]
4. If a pattern breaks:
   - Diagnose using state inspection
   - Inject recovery via: ralph tools task add "Fix: [diagnosis]" -p 1
   - Resume monitoring
5. Report status every 10 minutes or on pattern break.
```

## Benefits Over Simple Monitoring

| Simple Monitoring | Subagent Monitoring |
|-------------------|---------------------|
| Parses logs for "ERROR" | Validates logical patterns |
| Checks if process running | Verifies event flow integrity |
| Binary (alive/dead) | Qualitative (healthy/degraded/broken) |
| Reactive (error发生后) | Proactive (pattern detection) |
| No context awareness | Preset-aware validation |

## Integration with ralph-execution

When Complex Monitoring Mode is triggered, the ralph-execution skill delegates to the **ralph-watchdog agent** (`.claude/agents/ralph-watchdog.md`).

The watchdog agent:
1. Detects multi-hat preset selection
2. Performs preset-specific validation automatically
3. Reports every 2 minutes or on immediate escalation
4. Returns structured reports with log file references

**Subagent Prompt Template:**

The ralph-watchdog agent embodies this template:
```text
Monitor Ralph orchestration:
1. Start: ralph run --no-tui --verbose 2>&1 | tee .ralph/latest.log
2. Monitor state every 30-60 seconds using:
   - ralph events list (event flow)
   - ralph tools task ready (pending work)
3. Validate pattern integrity for [PRESET_NAME]:
   - [Pattern-specific checks]
4. If a pattern breaks:
   - Diagnose using state inspection
   - Inject recovery via: ralph tools task add "Fix: [diagnosis]" -p 1
   - Resume monitoring
5. Report status every 2 minutes or on pattern break.
```

## Example: Monitoring Adversarial Review

```text
Launch subagent to monitor adversarial-review preset:

Validation rules:
1. Red Team must publish either vulnerability.found OR security.approved
2. If neither within 10 minutes of Red Team activation: escalate
3. Verify vulnerability.found contains actual findings (not "looks fine")
4. Check that Red Team doesn't approve immediately (<2 minutes)

Report:
- Red Team activations and findings
- Time between activation and decision
- Any premature approvals
- Final security posture
```
