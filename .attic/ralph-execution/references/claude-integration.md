# Claude Integration Patterns (Modernized)

Integrate Ralph orchestrations into Claude Code using native background tasks and intelligent monitoring.

## Critical: Real-Time Monitoring Protocol

**Before using any pattern, understand this:**

Real-time log streaming is NON-NEGOTIABLE for Ralph execution. State inspection complements log streaming; it never replaces watching the process as it runs.

**Why real-time monitoring matters:**
- Catch configuration errors immediately (missing hats, invalid ralph.yml)
- Detect permission issues before they cascade
- Identify stuck loops within 90 seconds, not after 10 minutes
- Enable kill-diagnose-fix-restart instead of waiting for timeout

**Minimum monitoring standard:**
```bash
# Start Ralph
ralph run --max-iterations 30 --no-tui --verbose 2>&1 | tee .ralph/latest.log &

# IMMEDIATELY stream logs (non-blocking)
tail -f .ralph/latest.log &

# Check checkpoints
# 30s: Claude command should spawn
# 90s: First hat should activate
# 3min: Iterations should progress
```

**If ANY checkpoint fails:**
1. Kill the process
2. Read the log to diagnose
3. Fix the root cause
4. Restart Ralph

---

## Pattern 1: Native Background Execution

**Standard Pattern:** Leverage Claude Code's `run_in_background` capability with real-time monitoring.

**Prompt to Claude:**
```text
Start a Ralph execution in the background:
1. Ensure .ralph/ directory exists.
2. Run: ralph run --max-iterations 30 --no-tui --verbose 2>&1 | tee .ralph/latest.log
3. IMMEDIATELY begin real-time monitoring: tail -f .ralph/latest.log
4. Every 30 seconds, check for:
   - Tool errors (claude not found, permission denied)
   - Hat activation failures
   - Progress indicators (iteration count advancing)
5. If no progress after 90 seconds: Kill, diagnose, fix, restart
6. Stop immediately on any ERROR
```

**Under the Hood:**
- Claude uses `Bash(command, run_in_background: true)`.
- Output is captured in Claude's context via `TaskOutput`.
- Real-time log streaming catches early failures.
- No manual PID management (`$!`) is required.

## Pattern 2: Real-Time Watchdog Loop

**For:** Auto-fixing common errors with immediate intervention capability.

**Prompt to Claude:**
```text
Run Ralph in the background and act as a real-time watchdog:

1. Start Ralph and IMMEDIATELY stream logs: tail -f .ralph/latest.log
2. Time checkpoints (check process health):
   - 30s: Should see Claude command spawn
   - 90s: Should see first hat activation
   - 3min: Should see iteration progression
3. State inspection (every 60 seconds):
   * "ralph events list | tail -20" for event flow
   * "ralph tools task ready" for pending work
4. If deviation detected at any checkpoint:
   - Kill the background process immediately
   - Diagnose from the real-time log
   - Fix the root cause
   - Restart Ralph
5. Invariants for healthy execution:
   1. Event progression: New events appear periodically
   2. Flow validation: iterations ≈ events (not iterations << events)
   3. No deadlock: Active iteration but no new events for >5 minutes
```

## Pattern 3: Subagent Delegation (Real-Time Monitoring)

**For:** Complex, long-running tasks (hours) requiring continuous monitoring.

**Prompt to Claude:**
```text
Delegate to a subagent:
"You are a Ralph Orchestrator. Start `ralph run` in the background.
CRITICAL: Monitor in real-time using tail -f .ralph/latest.log.
Check time checkpoints: 30s (command spawn), 90s (first hat), 3min (progression).
Every 10 minutes, report status using:
  - ralph events list (event flow and hat transitions)
  - ralph tools task ready (pending work queue)
If ANY deviation detected (no progress at checkpoints, errors, stuck):
  - Kill process immediately
  - Diagnose from log
  - Attempt fix via state injection
  - Restart or escalate to me
Report back to me only on completion or critical failure."
```

**Benefits:**
- Main agent context remains uncluttered.
- Subagent monitors in real-time (catches early failures).
- Enables intelligent recovery without losing orchestration state.

## Pattern 4: Parallel Orchestration

**For:** Running multiple independent Ralph workflows.

**Prompt to Claude:**
```text
Start two background tasks simultaneously:
1. Ralph run for Task A -> logs to .ralph/task-a.log
2. Ralph run for Task B -> logs to .ralph/task-b.log

Monitor both. If Task A fails, pause Task B and alert me.
```

## Modern Monitoring Protocol (Real-Time + State-Based)

**Principle:** Real-time log streaming catches early failures; state inspection validates orchestration health.

**Real-Time Monitoring (Immediate):**
```bash
# Stream logs as process runs
tail -f .ralph/latest.log
```

**State Inspection (Periodic, Complementary):**
```bash
# Flow Check: Verify event progression
ralph events list | tail -20

# Task Check: Query ready tasks
ralph tools task ready

# Iteration Check: Compare iterations to events
grep -c "_meta.loop_start\|ITERATION" .ralph/events.jsonl
grep -c "bus.publish" .ralph/events.jsonl
```

**Deadlock Detection:**
- If iteration counter active but `ralph events list` shows no new events for >5 minutes
- Expected: iterations ≈ events published (one event per iteration)
- Bad sign: 2-3 iterations but 5+ events (same-iteration switching)

**State Inspection Commands:**
```bash
# Flow Check: Verify event progression
ralph events list | tail -20

# Task Check: Query ready tasks
ralph tools task ready

# Iteration Check: Compare iterations to events
grep -c "_meta.loop_start\|ITERATION" .ralph/events.jsonl
grep -c "bus.publish" .ralph/events.jsonl
```

**Deadlock Detection:**
- If iteration counter active but `ralph events list` shows no new events for >5 minutes
- Expected: iterations ≈ events published (one event per iteration)
- Bad sign: 2-3 iterations but 5+ events (same-iteration switching)

## Robust Execution Standard (JSON Telemetry)

**For:** Programmatic monitoring and automated event flow validation.

**Standard Pattern:**
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

**Parsing JSON Events:**
```bash
# Monitor for event publishes
jq 'select(.type == "bus.publish")' raw_log.json

# Check for errors
jq 'select(.type == "error")' raw_log.json

# Extract tool usage
jq 'select(.type == "tool_use")' raw_log.json
```

**Key Benefits:**
- Structured telemetry instead of text parsing
- Reliable event detection (`type == "bus.publish"`)
- Programmatic monitoring without regex
- Auditable execution trail

## Comparison: Shell-Based vs Modern (Real-Time + State-Based)

| Feature | Shell-Based Pattern | Modern Pattern |
| :--- | :--- | :--- |
| **Process Tracking** | Manual PID files (`$!`) | Claude Code background tasks |
| **Health Check** | Parse stdout/stderr | Real-time log streaming + `ralph events list` |
| **Task Status** | External process monitors | `ralph tools task ready` |
| **Flow Validation** | `grep` log files | Count iterations vs events |
| **Early Detection** | After completion (too late) | Within 90 seconds (time checkpoints) |
| **Recovery** | Kill and restart | Kill-diagnose-fix-restart (state injection) |

## Integration Checklist

**Pre-Execution:**
- [ ] `PROMPT.md` follows Requirements/Constraints/Success format.
- [ ] `.ralph/` directory exists.
- [ ] `ralph.yml` is valid (`ralph validate`).

**Execution (Real-Time Monitoring):**
- [ ] Ralph started with `tee` logging to `.ralph/latest.log`.
- [ ] Real-time log streaming started immediately: `tail -f .ralph/latest.log`
- [ ] Time checkpoints defined: 30s, 90s, 3min.
- [ ] State inspection scheduled: every 30-60 seconds.
- [ ] Kill-diagnose-fix-restart plan ready.

**Post-Execution:**
- [ ] Kill background task if manual stop required.
- [ ] Review `.ralph/latest.log` for audit trail.
- [ ] Verify event flow: `ralph events list | tail -20`
- [ ] Check task state: `ralph tools task ready`
