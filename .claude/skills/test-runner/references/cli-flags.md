# CLI Flags Reference

Complete reference for Claude Code CLI flags used in testing.

## Essential Testing Flags

```bash
# Limit execution (safety)
--max-turns 10           # Maximum conversation rounds
--max-budget-usd 2.00    # Cost limit

# Output control
--output-format json     # Parseable output
--verbose                # Detailed logs

# Session control
--no-session-persistence # No history between tests
--session-id "test-001"  # Reproducible test ID
```

## Debug Mode (MANDATORY for Autonomous Testing)

> [!IMPORTANT]
> The `--debug` flag is **MANDATORY** when running autonomous tests through non-interactive CLI. Debug output is essential for diagnosing test failures, understanding execution flow, and validating skill behavior.

### Basic Usage

```bash
--debug                  # Enable debug mode (all categories)
--debug "category"       # Filter to specific category
--debug "cat1,cat2"      # Multiple categories (comma-separated)
--debug "!category"      # Exclude specific category
--debug "!cat1,!cat2"    # Exclude multiple categories
```

### Available Debug Categories

| Category | Description |
|----------|-------------|
| `api` | API calls and responses |
| `mcp` | MCP server interactions |
| `tools` | Tool execution and results |
| `hooks` | Hook system events |
| `statsig` | Feature flag evaluations |
| `file` | File system operations |

### Debug Filtering Examples

```bash
# Focus on API and MCP interactions
claude -p "test" --debug "api,mcp"

# All debug output except statsig noise
claude -p "test" --debug "!statsig"

# Tool execution and hooks only
claude -p "test" --debug "tools,hooks"

# API and MCP, excluding file operations
claude -p "test" --debug "api,mcp,!file"

# Minimal noise: exclude common verbose categories
claude -p "test" --debug "!statsig,!file"
```

### Recommended Debug Patterns for Testing

| Test Type | Recommended Debug | Why |
|-----------|------------------|-----|
| All Autonomous Tests | `--debug` | Full visibility into execution |
| Skill Autonomy | `--debug` | Track skill decisions and tool usage |
| MCP/Agent Testing | `--debug` | Monitor agent communication |
| Hook Validation | `--debug` | Verify hook triggers |

## Session Persistence (MANDATORY: Disable for Print Mode)

> [!IMPORTANT]
> The `--no-session-persistence` flag is **MANDATORY** when running autonomous tests through print mode (`-p`). This ensures sessions are not saved to disk and cannot be resumed, keeping tests isolated and reproducible.

### Why Disable Session Persistence?

| Reason | Impact |
|--------|--------|
| **Test Isolation** | Each test run starts fresh, no contamination from previous runs |
| **Disk Hygiene** | No session files accumulate in `~/.claude/sessions/` |
| **Reproducibility** | Same test input = same test conditions every time |
| **Security** | Sensitive test data not persisted to disk |

### Usage

```bash
--no-session-persistence   # Disable session saving (print mode only)
```

### Combining with Session ID

For reproducible debugging, combine with `--session-id`:

```bash
# Isolated but identifiable test session
claude -p "test query" --no-session-persistence --session-id "test-skill-001"
```

> [!NOTE]
> `--session-id` with `--no-session-persistence` creates a logical session ID for logging/debugging purposes without persisting to disk.

## Permission Skipping (MANDATORY for Autonomous Testing)

> [!IMPORTANT]
> The `--dangerously-skip-permissions` flag is **MANDATORY** when running autonomous tests. Without it, tests will hang indefinitely waiting for permission prompts that cannot be answered in non-interactive mode.

### Why Skip Permissions?

| Reason | Impact |
|--------|--------|
| **Non-Interactive** | Print mode cannot display or respond to permission prompts |
| **Test Continuity** | Tests complete without human intervention |
| **Automation** | Required for CI/CD pipelines and scripted testing |

### Usage

```bash
--dangerously-skip-permissions   # Skip all permission prompts
```

> [!CAUTION]
> This flag allows Claude to execute any tool without confirmation. Only use in:
> - Isolated test directories
> - Disposable environments
> - Directories with no sensitive data
> 
> **Never use on production codebases or directories with important files.**

### Safe Test Environment Pattern

```bash
# Create isolated test directory, then run with permissions skipped
mkdir test-isolated && cd test-isolated
claude --dangerously-skip-permissions -p "test query" --debug "api,tools" --no-session-persistence
```

## Tool Restrictions

```bash
--tools "Bash,Read"      # Allow only specific tools
--disallowedTools "Write" # Block specific tools
```

## Piped Input

Pipe file content directly into Claude for processing:

```bash
# Process file content
cat logs.txt | claude -p "analyze these logs"

# Process command output
git diff | claude -p "review this diff"

# Chain with other tools
grep "ERROR" app.log | claude -p "explain these errors"
```

## Output Logging (MANDATORY for Iterative Testing)

> [!IMPORTANT]
> **ALWAYS redirect output to a single log file** when running iterative tests. This log file:
> - Must be **read after each iteration** to assess results
> - Must be **overwritten (not appended)** on each new test to avoid stale data
> - Must be **cleaned up at the end** of the testing session

### Standard Pattern

```bash
# Single NDJSON file, overwritten on each test (3 lines: init, message, result)
claude --dangerously-skip-permissions -p "test query" --output-format stream-json --verbose --debug --no-session-persistence > test-output.json 2>&1

# Read logs after execution
cat test-output.json

# Cleanup after all tests complete
rm test-output.json
```

### Iterative Testing Workflow

```bash
# Test iteration 1
claude --dangerously-skip-permissions -p "first test" --output-format stream-json --verbose --debug --no-session-persistence > test-output.json 2>&1
cat test-output.json  # Analyze results (check line 1 for system init, line 3 for metrics)

# Test iteration 2 (overwrites previous log)
claude --dangerously-skip-permissions -p "second test" --output-format stream-json --verbose --debug --no-session-persistence > test-output.json 2>&1
cat test-output.json  # Analyze results

# Final cleanup
rm test-output.json
```

### Combining Piped Input with Output Logging

```bash
# Pipe input + capture output
cat context.txt | claude --dangerously-skip-permissions -p "analyze this" --output-format stream-json --verbose --debug --no-session-persistence > test-output.json 2>&1
```

## Usage Examples

```bash
# Complete autonomous test command (all mandatory flags)
claude --dangerously-skip-permissions -p "test query" --output-format stream-json --verbose --debug --no-session-persistence --max-turns 10 > test-output.json 2>&1

# Stream JSON output (NDJSON: 3 lines with system init, message, result)
claude -p "test query" --output-format stream-json --verbose > result.json

# Piped input with full isolation
cat input.txt | claude --dangerously-skip-permissions -p "process this" --output-format stream-json --verbose --debug --no-session-persistence > test-output.json 2>&1
```
