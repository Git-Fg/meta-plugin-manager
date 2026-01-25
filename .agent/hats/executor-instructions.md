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

```bash
# Print monitoring hint
echo "To monitor execution in real-time: tail -f $(pwd)/<sandbox_directory>/raw_log.json"

cd <sandbox_directory>/ && claude \
  --print \
  --output-format stream-json \
  --max-turns <based_on_complexity> \
  --dangerously-skip-permissions \
  --no-session-persistence \
  -p "<test_prompt>" \
  | tee raw_log.json
```

### Turn Allocation
| Complexity | Turns |
|------------|-------|
| Simple | 5-10 |
| Standard | 10-15 |
| Complex | 15-25 |
| E2E | 25-30 |

## For Rerun Mode: Test Discovery

```bash
# Discover all test specs
find tests/ -name "test_spec.json" -type f

# Parse and execute each
for spec in $(find tests/ -name "test_spec.json"); do
  # Execute tests from this spec
  # Record results
done
```

## Update Test Results JSON

After each test execution, update `tests/results.json`:

```bash
# Read existing or create new
cat tests/results.json 2>/dev/null || echo '{"runs":[]}'

# After test, append result
```

Results JSON format:
```json
{
  "last_run": "2026-01-25T21:50:00Z",
  "summary": {
    "total": 15,
    "passed": 12,
    "failed": 2,
    "skipped": 1
  },
  "runs": [
    {
      "timestamp": "2026-01-25T21:50:00Z",
      "component": "skill-name",
      "tests": [
        {
          "name": "Test name",
          "status": "pass|fail|skip",
          "duration_ms": 1234,
          "error": null
        }
      ]
    }
  ],
  "status_changes": [
    {
      "component": "skill-name",
      "test": "Test name", 
      "was": "pass",
      "now": "fail",
      "since": "2026-01-25T21:50:00Z"
    }
  ]
}
```

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

## Batch Execution

For batch mode, execute specs in order:

1. Interdependent groups first (they may have cascading failures)
2. Standalone components in parallel (if possible) or sequence
3. Aggregate results into single `tests/results.json`
4. Report batch summary

```bash
ralph emit "test.passed" "batch: 15/18 passed, 2 failed (skill-X, hook-Y), 1 skipped"
```

## Philosophy
Execute faithfully. Verify before passing forward. Update JSON for persistence. Record what happened for future learning.
