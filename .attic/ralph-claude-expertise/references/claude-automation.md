# Programmatic Claude Execution for Ralph

When hats need to execute Claude autonomously (external testing, CI/CD), follow strict isolation and verification protocols.

---

## ❌ Anti-Patterns

```bash
# BAD: No isolation, no telemetry
claude -p "Do the task"

# BAD: Trusts stdout, no verification
claude --dangerously-skip-permissions -p "Fix the bug" && echo "Success!"

# BAD: No structured output for parsing
claude -p "Generate code" > output.txt
```

---

## ✅ Robust Pattern (Recommended)

**Absolute constraints:**
1. `cd` into target directory first (working directory isolation)
2. Use `--print` for non-interactive output
3. Use `--output-format stream-json` for structured telemetry
4. Use `--dangerously-skip-permissions` OR `--permission-mode` for autonomy
5. Capture raw telemetry for verification
6. Parse and verify results, don't trust stdout

```bash
cd <target_directory>/

claude \
  --print \
  --verbose \
  --output-format stream-json \
  --dangerously-skip-permissions \
  --no-session-persistence \
  -p "Execute the autonomous workflow..." \
  | tee raw_log.json
```

---

## Critical Flags for Ralph Automation

| Flag | Purpose | When Required |
|------|---------|---------------|
| `--print` (`-p`) | Non-interactive output mode | Always for automation |
| `--output-format stream-json` | Structured streaming JSON | Always for parsing |
| `--verbose` | Include debugging context | Recommended for troubleshooting |
| `--dangerously-skip-permissions` | Bypass all permission checks | Sandboxes, trusted dirs |
| `--permission-mode <mode>` | Granular permission control | Production, security-needed |
| `--no-session-persistence` | Prevent context pollution | Isolation required |
| `--max-budget-usd <amount>` | Cost cap for safety | Financial limits needed |
| `--max-turns <N>` | Limit agentic turns | Complexity-based limits |
| `--model <alias>` | Specify model (sonnet, opus, haiku) | Model selection needed |
| `--tools <list>` | Restrict available tools | Principle of least privilege |
| `--allowed-tools <list>` | Whitelist specific tools | Tool restriction needed |
| `--disallowed-tools <list>` | Blacklist specific tools | Tool exclusion needed |

---

## Permission Modes

Use `--permission-mode` instead of `--dangerously-skip-permissions` for granular control:

| Mode | Behavior | Use Case |
|------|----------|----------|
| `bypassPermissions` | Bypass all permissions | Trusted sandboxes only |
| `acceptEdits` | Auto-accept file edits | Safe for code generation |
| `plan` | Planning mode only | Read-only operations |

```bash
# Example: Auto-accept edits but require other permissions
claude --print --permission-mode acceptEdits -p "Generate code"
```

---

## Output Formats

Choose based on use case:

| Format | Description | Use Case |
|--------|-------------|----------|
| `text` | Plain text output | Simple logging |
| `json` | Single JSON result | Final result extraction |
| `stream-json` | Real-time streaming JSON | Monitoring, parsing |

```bash
# JSON output (single result at end)
claude --print --output-format json -p "Task" | jq '.result'

# Stream JSON (real-time events)
claude --print --output-format stream-json -p "Task" | tee log.jsonl
```

---

## Telemetry Verification Protocol

**Trust code, not talk.** Parse `raw_log.json` to verify actual execution.

### Parse Stream JSON Output

```bash
# Extract summary from stream-json
cat raw_log.json | jq -s 'map(select(.type == "summary")) | last'

# Check for errors
cat raw_log.json | jq -s 'map(select(.type == "error"))'

# Extract tool usage
cat raw_log.json | jq -s 'map(select(.type == "tool_use")) | length'
```

### Verification Checklist

| Check | Command | Fail Condition |
|-------|---------|----------------|
| Ran tools | `jq 'map(select(.type=="tool_use"))'` | Empty array |
| No errors | `jq 'map(select(.type=="error"))'` | Non-empty |
| Has result | `jq 'map(select(.type=="summary"))'` | Empty |
| Exit code | `echo $?` | Non-zero |

### Example Verification Function

```bash
verify_claude_run() {
  local log_file="$1"

  # Check for errors
  if jq -e 'map(select(.type == "error")) | length > 0' "$log_file" >/dev/null 2>&1; then
    echo "ERROR: Claude execution had errors"
    return 1
  fi

  # Check for tool usage
  local tool_count=$(jq -r 'map(select(.type == "tool_use")) | length' "$log_file")
  if [ "$tool_count" -eq 0 ]; then
    echo "WARNING: Claude used no tools (possible hallucination)"
    return 2
  fi

  # Check for completion
  if ! jq -e 'map(select(.type == "summary")) | length > 0' "$log_file" >/dev/null 2>&1; then
    echo "ERROR: Claude execution incomplete"
    return 3
  fi

  echo "OK: Claude executed $tool_count tools successfully"
  return 0
}
```

---

## Turn Limits for Ralph Complexity

Allocate turns based on task complexity:

```bash
# Simple tests/commands: 5-10 turns
claude --print --max-turns 10 -p "Simple test"

# Standard workflows: 10-15 turns
claude --print --max-turns 15 -p "Standard workflow"

# Complex orchestration: 15-25 turns
claude --print --max-turns 25 -p "Complex task"

# E2E test suites: 25-30 turns
claude --print --max-turns 30 -p "E2E suite"
```

---

## Tool Restriction (Principle of Least Privilege)

Restrict available tools for security and predictability:

```bash
# Allow only Read tool (read-only analysis)
claude --print --tools Read -p "Analyze this codebase"

# Allow specific tools with patterns
claude --print --allowed-tools "Bash(git:*) Read Write" -p "Task"

# Disallow dangerous tools
claude --print --disallowed-tools "Bash(rm:*) Bash(curl:*)" -p "Task"
```

### Permission Rule Syntax

The `:*` suffix enables prefix matching:

```bash
# Allow any git diff command
claude -p "Review changes" \
  --allowedTools "Bash(git diff:*),Bash(git log:*),Bash(git status:*)"

# Allow Read tool but restrict paths
claude -p "Analyze code" \
  --allowedTools "Read(src/*:tests/*)"
```

---

## Cost Control

Prevent runaway spending:

```bash
# Set budget cap
claude --print --max-budget-usd 1.50 -p "Expensive task"

# Use cheaper model for simple tasks
claude --print --model haiku -p "Simple classification"

# Fallback to cheaper model if overloaded
claude --print --fallback-model haiku -p "Task with fallback"
```

---

## Complete Examples

### Example 1: External Test Runner

```bash
#!/bin/bash
set -e

TARGET_DIR="$1"
cd "$TARGET_DIR"

claude \
  --print \
  --output-format stream-json \
  --permission-mode acceptEdits \
  --verbose \
  --no-session-persistence \
  -p "Run all tests and report results" \
  | tee test_run.jsonl

# Verify execution
verify_claude_run test_run.jsonl || exit 1

# Extract results
jq -r 'map(select(.type == "message")) | last[].content.text' test_run.jsonl
```

### Example 2: CI/CD Pipeline

```bash
#!/bin/bash
# .github/workflows/ai-review.yml

claude \
  --print \
  --output-format json \
  --permission-mode acceptEdits \
  --max-budget-usd 5.00 \
  --disallowed-tools "Bash(rm:*) Bash(sudo:*)" \
  -p "Review this PR for security issues" \
  | tee review.json

# Parse review
review_status=$(jq -r '.result.status' review.json)
if [ "$review_status" != "approved" ]; then
  echo "Review failed: $review_status"
  exit 1
fi
```

### Example 3: Batch Processing

```bash
#!/bin/bash

for dir in projects/*/; do
  echo "Processing $dir"
  cd "$dir"

  claude \
    --print \
    --output-format stream-json \
    --permission-mode bypassPermissions \
    --no-session-persistence \
    -p "Update dependencies and run tests" \
    | tee "${dir}/claude_run.jsonl"

  verify_claude_run "${dir}/claude_run.jsonl" || echo "Failed: $dir"
done
```

---

## Security Best Practices

1. **Never use `--dangerously-skip-permissions` with untrusted input**
2. **Restrict tools** to minimum required set
3. **Use `--max-budget-usd`** to prevent runaway costs
4. **Parse structured output** instead of trusting stdout
5. **Run in isolated directories** to prevent file access issues
6. **Use `--no-session-persistence`** to avoid context pollution
7. **Verify exit codes and parse errors** from JSON output
8. **Never pipe untrusted input directly into prompts**

---

## Anti-Pattern Recognition

| Pattern | Why Bad | Fix |
|---------|---------|-----|
| `claude -p "$user_input"` | Injection risk | Validate/sanitize input |
| `claude --dangerously-skip-permissions` | No safety | Use `--permission-mode` |
| Trusting stdout | Can hallucinate | Parse JSON telemetry |
| No working directory | File access issues | Always `cd` first |
| No budget limit | Runaway costs | Add `--max-budget-usd` |

---

## System Prompt Customization

### Append to Default Prompt

Use `--append-system-prompt` to add instructions while keeping Claude Code's default behavior:

```bash
gh pr diff "$1" | claude -p \
  --append-system-prompt "Act as a security engineer. Review for vulnerabilities." \
  --output-format json
```

### Replace System Prompt

Use `--system-prompt` to fully replace the default prompt:

```bash
claude \
  --system-prompt "Act as a code reviewer. Focus on readability and maintainability." \
  -p "Review this file"
```

### System Prompt Flags Comparison

| Flag | Behavior | Modes | Use Case |
|------|----------|-------|----------|
| `--system-prompt` | **Replaces** entire default prompt | Interactive + Print | Complete control over behavior |
| `--system-prompt-file` | **Replaces** with file contents | Print only | Load prompts from files |
| `--append-system-prompt` | **Appends** to default prompt | Interactive + Print | Add instructions, keep defaults |
| `--append-system-prompt-file` | **Appends** file contents to default prompt | Print only | Load additions from files |
