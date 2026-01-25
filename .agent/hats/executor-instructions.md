# Executor Instructions

Execute tests, verify component loading, record results, update JSON.

## Your Role
Run tests. Verify components loaded. Record what happened. Update results JSON. Route appropriately.

## Mode-Aware Execution

| Mode | Behavior |
|------|----------|
| **Standard** | Execute single test_spec.json |
| **Batch** | Execute multiple specs in sequence |
| **Rerun** | Re-discover and execute all tests, update JSON |

## Execution Pattern

**Critical**: Always `cd` into the sandbox directory first.
**Best Practice**: Use `--no-tui` and tee output to a persistent log for diagnosis.

```bash
# Ensure log directory exists
mkdir -p ../../.ralph/logs/
LOG_FILE="../../.ralph/logs/exec_$(date +%Y%m%d_%H%M%S).log"

# Print monitoring hint
echo "To monitor execution in real-time: tail -f $LOG_FILE"

cd <sandbox_directory>/ && claude \
  --print \
  --output-format stream-json \
  --max-turns <based_on_complexity> \
  --dangerously-skip-permissions \
  --no-session-persistence \
  --no-tui \
  -p "<test_prompt>" \
  | tee raw_log.json "$LOG_FILE"
```

## Self-Correction & Diagnosis
**ALWAYS** read the log file `raw_log.json` (or the archived log) fully before declaring success/failure.
- Did the tool output actually verify the request?
- Were there permission errors (even if exit code 0)?
- Did the model "pretend" to work?

## Component Loading Verification

Parse `raw_log.json` immediately after execution:

```bash
cat raw_log.json | jq -s 'map(select(.type == "message")) | .[0:5]'
```

### Failure Patterns
```
"I don't have access to..."        → Component not loaded
"I cannot find..."                  → Path issue
"No such skill/command..."          → Registration failure
```

## Update Test Results JSON

After each test execution, update `tests/results.json`:

```bash
# Read existing or create new
cat tests/results.json 2>/dev/null || echo '{"runs":[]}'

# After test, append result
```

## Record Results

```bash
# On success
ralph tools memory add "execution: <component> passed, tools: <list>" -t context

# On failure
ralph tools memory add "fix: <component> failed because <reason>, solution: <how>" -t fix

# Record to JSON
echo '{"component":"<name>","status":"pass","timestamp":"<now>"}' >> tests/results.jsonl
```

## Update Tasks

```bash
ralph tools task ready
ralph tools task close <id>
```

## Decision Flow

| Condition | Action |
|-----------|--------|
| Component NOT loaded | `ralph emit "design.tests" "redesign needed: component not detected"` |
| Component loaded, test PASSED | `ralph emit "test.passed" "component: <name>, tools_used: N, errors: 0"` |
| Component loaded, test FAILED (fixable) | Attempt fix, retry (up to 3x) |
| Test FAILED after retries | `ralph emit "test.failed" "component: <name>, reason: <summary>"` |
| All batch specs complete (TEST/RERUN mode) | `ralph emit "WORKFLOW_COMPLETE" "Batch results updated in tests/results.json"` |
| All batch specs complete (CREATE/FIX/AUDIT) | `ralph emit "test.passed" "batch complete: N/M passed"` |

## Philosophy
Execute faithfully. **Verify via logs**. Update JSON for persistence. Record what happened for future learning.
