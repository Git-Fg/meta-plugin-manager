---
name: run-in-sandbox
description: Execute isolated component validation in .agent/sandbox and monitor logs in real-time. Use when a component is ready for verification or when testing hooks that cannot be reactivated in the current session.
argument-hint: [component-name] [complexity: simple|standard|complex]
allowed-tools: ["Bash", "Read"]
---

# Isolated Sandbox Execution Protocol

You are tasked with running an autonomous validation loop for the component: **$1**.

## Phase 0: Preliminary Verification
You must first verify the .agent/sandbox directory exists and contains the component(s) to test.

## Phase 1: Complexity Analysis
Determine the `--max-turns` based on the provided complexity ($2):
- **simple**: 10 turns
- **standard**: 20 turns
- **complex**: 40 turns

## Phase 2: Transactional Execution
You MUST execute the following command precisely. Note the directory navigation hygiene (cd into sandbox, verify with pwd, execute, and pipe to the original project's test folder).

**Execution Command:**
```bash
# Ensure test directory exists
mkdir -p "tests/$1"

# Execute isolated session
(cd .agent/sandbox/ && pwd && claude \
    --print \
    --output-format stream-json \
    --max-turns [CALCULATED_TURNS] \
    --dangerously-skip-permissions \
    --no-session-persistence \
    --no-tui \
    -p "Read test_spec.json from current directory and execute tests") \
    | tee "tests/$1/raw_log.json"
```

**Instruction:** 
- Run the above command in the **background** using `run_in_background: true`.
- Record the task ID.

## Phase 3: The Monitoring Loop
Once the process is running in the background, you must monitor it every **30 seconds**.

### Monitoring Protocol:
1. **Read the Log**: Use `cat tests/$1/raw_log.json` to read the full stream.
2. **Verify Integrity**:
    - Check for `"type": "error"` in the JSON objects.
    - Verify progress (look for `tool_use` or `message` types).
    - Check if the stream has ended (process completion).
3. **Backpressure**:
    - If the log shows a "Permission Denied" outside of `.agent/sandbox/`, **STOP** the process immediately.
    - If the log shows the sub-agent is stuck in a loop, **STOP** the process.
4. **Handoff**:
    - While waiting for the 30s interval, do NOT remain idle if there are other tasks. 
    - If this is the only task, wait and re-check.

## Phase 4: Finalization
When the background process completes:
1. Read the final `raw_log.json`.
2. Summarize the result (PASS/FAIL).
3. If FAIL: Extract the specific errors to the main orchestrator for a fix iteration.
4. If PASS: Signal that the component is ready.

## Navigation Guard
**CRITICAL**: You must strictly follow the `(cd .agent/sandbox/ && ...)` pattern. Do not change the working directory of this main session. Always verify your current location with `pwd` if you are unsure.