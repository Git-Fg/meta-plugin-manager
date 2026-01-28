# Validation & Dry Run Protocol

**For:** Testing event flows, verifying state inspection commands, and preparing real-time monitoring before production runs.

## Real-Time Monitoring Preparation

Before any production run, prepare your real-time monitoring setup:

**Monitoring Setup:**
```bash
# Terminal 1: Run Ralph in background
ralph run --max-iterations 30 --no-tui --verbose 2>&1 | tee .ralph/latest.log &

# Terminal 2: Stream logs in real-time (NON-NEGOTIABLE)
tail -f .ralph/latest.log

# Time checkpoints to watch for:
30s  → Claude command should spawn
90s  → First hat should activate
3min → Iterations should progress
```

**Checkpoint Validation:**
- At 30s: Should see `[DEBUG] Built CLI command` in log
- At 90s: Should see hat activation in events
- At 3min: Should see iteration counter incrementing

**If checkpoint fails:** Kill process, diagnose from log, fix, restart

## Dry Run Testing

Validate Ralph workflows without actual execution using `--dry-run`:

```bash
# Test the event flow structure
ralph run --dry-run --no-tui

# Output shows:
# - Which hats would activate
# - Event publishing sequence
# - Expected iteration flow
# - Potential deadlock points
```

### What Dry Run Reveals

| Check | Dry Run Output | Action if Failed |
|-------|---------------|------------------|
| **Event flow** | Hat activation sequence | Fix event names in triggers/publishes |
| **Orphan events** | Events with no handling hat | Add hat or fix trigger |
| **Completion path** | Reaches LOOP_COMPLETE | Ensure event chain connects |
| **Cycles** | Repeating event loops | Validate intentional or fix |

### Dry Run Checklist

Before any production run:

```bash
# 1. Validate configuration
ralph validate

# 2. Test event flow (dry run)
ralph run --dry-run --no-tui

# 3. Check for warnings
# - Orphan events?
# - Unreachable hats?
# - Missing completion promise?

# 4. Only if dry run passes, prepare real-time monitoring:
#    - Start Ralph with tee logging
#    - Immediately begin: tail -f .ralph/latest.log
#    - Set checkpoints: 30s, 90s, 3min
```

## State Inspection Validation

Verify that state inspection commands return valid data before relying on them for automated monitoring.

### Test Commands

```bash
# Test: Event list command
ralph events list

# Expected: List of recent events with timestamps
# If empty: Run has not started or events not being captured
# If error: Check .ralph/events.jsonl exists and is readable

# Test: Task queue command
ralph tools task ready

# Expected: List of unblocked tasks (may be empty)
# If error: Check tasks.enabled in ralph.yml

# Test: Event count comparison
echo "Iterations: $(grep -c "_meta.loop_start\|ITERATION" .ralph/events.jsonl)"
echo "Events: $(grep -c "bus.publish" .ralph/events.jsonl)"

# Expected: iterations ≈ events (one event per iteration)
# If iterations << events: Same-iteration switching (bad)
# If iterations >> events: Recovery loops (check for stuck hats)
```

### Validation Checklist

Before deploying automated monitoring:

- [ ] `ralph events list` returns structured event data
- [ ] `ralph tools task ready` executes without error
- [ ] Event file exists: `.ralph/events.jsonl`
- [ ] Can count iterations vs events successfully
- [ ] Dry run shows proper event flow
- [ ] No orphan events in dry run output

## Automated Validation Script

Create a validation script for pre-flight checks:

```bash
#!/bin/bash
# validate-ralph-state.sh

echo "=== Ralph State Validation ==="

# 1. Configuration check
echo "1. Validating ralph.yml..."
ralph validate || exit 1

# 2. Dry run
echo "2. Running dry run..."
ralph run --dry-run --no-tui > /tmp/ralph-dryrun.log 2>&1
if grep -qi "orphan\|warning" /tmp/ralph-dryrun.log; then
  echo "⚠️  Dry run found issues:"
  cat /tmp/ralph-dryrun.log
  read -p "Continue anyway? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# 3. State inspection readiness
echo "3. Testing state inspection commands..."
ralph events list > /dev/null 2>&1 && echo "✓ events list works" || echo "✗ events list failed"
ralph tools task ready > /dev/null 2>&1 && echo "✓ task ready works" || echo "✗ task ready failed"

# 4. File permissions
echo "4. Checking file structure..."
touch .ralph/events.jsonl && echo "✓ Can write events file" || echo "✗ Cannot write events file"

echo "=== Validation Complete ==="
```

## Integration Checklist

**Before Production Run:**

- [ ] Dry run completes without warnings
- [ ] State inspection commands verified
- [ ] Real-time monitoring prepared (tail -f ready)
- [ ] Time checkpoints defined: 30s, 90s, 3min
- [ ] Monitoring strategy selected (simple → direct, complex → subagent)
- [ ] Recovery pattern understood (kill-diagnose-fix-restart)
- [ ] Invariants defined for preset type
- [ ] Log file configured (`tee .ralph/latest.log`)

**During Run:**

- [ ] Real-time log streaming active (tail -f .ralph/latest.log)
- [ ] Time checkpoints passing (30s, 90s, 3min)
- [ ] State inspections returning valid data
- [ ] Event flow progressing (iterations ≈ events)
- [ ] No deadlock (active iteration, no new events >5 min)
- [ ] Invariants passing (preset-specific rules)

**After Run:**

- [ ] Event flow complete (LOOP_COMPLETE reached)
- [ ] All invariants validated
- [ ] Recovery tasks (if any) processed
- [ ] Logs archived for audit trail

## Troubleshooting Validation Failures

### Dry Run Shows Orphan Events

**Diagnosis:** Event published but no hat triggers on it.

**Fix:**
1. Identify orphan event from dry run output
2. Find hat that should handle it
3. Add event to hat's `triggers:` list
4. Re-run dry run

### State Commands Return Errors

**Diagnosis:** Ralph state files not accessible or not initialized.

**Fix:**
1. Check `.ralph/` directory exists
2. Verify `events.jsonl` is writable
3. Check `tasks.enabled: true` in ralph.yml
4. Run at least one actual run (not dry run) to initialize state

### Iteration Count Mismatch

**Diagnosis:** iterations << events indicates same-iteration switching.

**Fix:**
1. Check hat instructions for missing "STOP" directive
2. Ensure hats publish events then stop (not continue work)
3. Re-run dry run to verify fix

### Cannot Reach LOOP_COMPLETE

**Diagnosis:** Event chain doesn't connect to completion.

**Fix:**
1. Trace event flow from dry run output
2. Find final event in chain
3. Ensure it triggers LOOP_COMPLETE
4. Add missing hat or fix event sequence
