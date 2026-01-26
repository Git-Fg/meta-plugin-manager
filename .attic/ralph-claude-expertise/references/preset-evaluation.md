# Preset Evaluation & Testing

Systematically test Ralph presets for correctness and performance.

## Quick Reference

```bash
# Test single preset
./tools/evaluate-preset.sh tdd-red-green claude

# Test all presets
./tools/evaluate-all-presets.sh claude
```

## Output Structure

```
.eval/
├── logs/<preset>/<timestamp>/
│   ├── output.log          # Full stdout/stderr
│   ├── session.jsonl       # Recorded session
│   ├── metrics.json        # Extracted metrics
│   ├── environment.json    # Runtime environment
│   └── merged-config.yml   # Config used
└── results/<suite-id>/
    ├── SUMMARY.md          # Markdown report
    └── <preset>.json       # Per-preset metrics
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success (LOOP_COMPLETE reached) |
| 124 | Timeout (preset hung) |
| Other | Failure (check output.log) |

## Hat Routing Validation

### Critical: Fresh Context Per Iteration

Each hat should execute in **one iteration**:

```
Iter 1: Ralph → publishes starting event → STOPS
Iter 2: Hat A → does work → publishes next event → STOPS
Iter 3: Hat B → does work → publishes next event → STOPS
Iter 4: Hat C → does work → LOOP_COMPLETE
```

### Red Flags

**Same-iteration switching (BAD):**
```
Iter 2: Ralph does Blue Team + Red Team + Fixer work
        ^^^ All in one bloated context!
```

### Diagnostic Commands

```bash
# Count iterations vs events
grep -c "ITERATION" .eval/logs/<preset>/latest/output.log
grep -c "bus.publish" .eval/logs/<preset>/latest/session.jsonl

# Expected: iterations ≈ events published
# Bad: 2-3 iterations but 5+ events

# Check for same-iteration hat switching
grep -E "ITERATION|Now I need to perform|Let me put on" \
    .eval/logs/<preset>/latest/output.log

# Red flag: Hat-switching phrases WITHOUT ITERATION separator

# Check event timestamps
cat .eval/logs/<preset>/latest/session.jsonl | jq -r '.ts'

# Red flag: Multiple events with identical timestamps
```

## Performance Triage

| Pattern | Diagnosis | Action |
|---------|-----------|--------|
| iterations ≈ events | ✅ Good | Hat routing working |
| iterations << events | ⚠️ Same-iteration switching | Check prompt has STOP instruction |
| iterations >> events | ⚠️ Recovery loops | Agent not publishing required events |
| 0 events | ❌ Broken | Events not being read from JSONL |

## Root Cause Checklist

If hat routing is broken:

1. **Check workflow prompt:**
   - Does it say "CRITICAL: STOP after publishing"?
   - Is DELEGATE section clear about yielding control?

2. **Check hat instructions propagation:**
   - Does `HatInfo` include `instructions` field?
   - Are instructions rendered in `## HATS` section?

3. **Check events context:**
   - Is `build_prompt(context)` using context parameter?
   - Does prompt include `## PENDING EVENTS` section?

## Autonomous Fix Workflow

After evaluation:

### Step 1: Triage
Read `.eval/results/latest/SUMMARY.md`:
- `❌ FAIL` → Create fix tasks
- `⏱️ TIMEOUT` → Investigate infinite loops
- `⚠️ PARTIAL` → Check edge cases

### Step 2: Create Tasks
For each issue:
```bash
ralph task  # Creates .code-task.md for the fix
```

### Step 3: Implement
```bash
ralph run -P tasks/<fix-task>.code-task.md
```

### Step 4: Re-evaluate
```bash
./tools/evaluate-preset.sh <fixed-preset> claude
```

## Metrics in metrics.json

| Field | Meaning |
|-------|---------|
| `iterations` | Event loop cycles |
| `hats_activated` | Which hats triggered |
| `events_published` | Total events emitted |
| `completed` | Whether completion promise reached |
