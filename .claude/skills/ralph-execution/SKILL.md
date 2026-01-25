---
name: ralph-execution
description: "Execute and monitor Ralph orchestrations: prompt file creation, run commands, verbose output monitoring, iteration tracking. Use when: executing ralph workflows, creating PROMPT.md files, monitoring long-running orchestrations, troubleshooting ralph runs. Must NOT be used for Ralph configuration design (use ralph-claude-expertise instead)."
---

# Ralph Execution

Practical guide for running Ralph orchestrations—prompt creation, execution commands, and monitoring.

---

## Creating the Prompt File

Ralph reads your task from `PROMPT.md` in the project root.

### Basic Format

```markdown
# Task Title

Brief description of what needs to be accomplished.

## Requirements
- Specific requirement 1
- Specific requirement 2

## Constraints
- Any limitations or boundaries

## Success Criteria
- How to know the task is complete
```

### Effective Prompt Tips

| Do | Don't |
|----|-------|
| Be specific about outcomes | Leave success ambiguous |
| Include file paths when relevant | Assume Ralph knows your project |
| State constraints upfront | Bury important restrictions |
| Define completion criteria | Let Ralph decide when done |

### Example: Feature Implementation

```markdown
# Add User Authentication

Implement JWT-based authentication for the API.

## Requirements
- Login endpoint at POST /auth/login
- Token refresh at POST /auth/refresh  
- Protected route middleware
- User model with email/password

## Constraints
- Use existing database schema
- No breaking changes to public API

## Success Criteria
- All tests pass
- Can obtain and use tokens via curl
```

---

## Running Ralph
 
 ### Production Grade Execution (Best Practice)
 
 Always use `--no-tui` and pipe output to a persistent log file for maximum reliability and debugging capability.
 
 ```bash
 # 1. Prepare log directory
 mkdir -p .ralph/logs/
 LOG_FILE=".ralph/logs/run_$(date +%Y%m%d_%H%M%S).log"
 
 # 2. Run with pipe (no TUI)
 echo "Monitor specific log: tail -f $LOG_FILE"
 ralph run --no-tui --verbose 2>&1 | tee "$LOG_FILE"
 ```
 
 ### Why --no-tui?
 - **Clean Logging**: Text-based UI control characters don't pollute your log files
 - **Pipe Compatibility**: Allows standard Unix tools (`grep`, `tee`, `awk`) to work
 - **Searchable**: You can grep through the history of the run
 
 ### Monitoring
 
 Since the main window is piping to a file, use a second terminal to watch:
 
 ```bash
 # Watch real-time
 tail -f .ralph/logs/run_LATEST.log
 ```
 
 ### Basic Execution (Interactive)
 
 ```bash
 # Standard TUI run (only for simple, short tasks)
 ralph run --max-iterations 20
 ```

### Continue Previous Session

```bash
# Resume from last checkpoint
ralph run --continue --verbose 2>&1
```

---

## Monitoring Output

### Key Indicators to Watch

| Output Pattern | Meaning |
|----------------|---------|
| `[iter N]` | Current iteration number |
| `🎩 Hat Name` | Active hat processing |
| `publish: event.name` | Event emitted, triggering next hat |
| `LOOP_COMPLETE` | Orchestration finished successfully |
| `idle timeout` | No activity, possible stuck state |

### Verbose Output Structure

```
[iter 1] 🎩 Planner - Starting task analysis
         Reading PROMPT.md
         Publishing: planning.done
         
[iter 2] 🎩 Builder - Implementing solution
         Creating src/auth/login.ts
         Running tests...
         Publishing: build.done
```

### Capturing Logs

Always capture output for debugging:

```bash
# Full log capture with timestamps
ralph run --max-iterations 20 --verbose 2>&1 | \
  while IFS= read -r line; do echo "$(date +%H:%M:%S) $line"; done | \
  tee ralph_$(date +%Y%m%d_%H%M%S).log
```

---

## Iteration Management

### Choosing Max Iterations

| Task Complexity | Recommended | Rationale |
|-----------------|-------------|-----------|
| Simple fix | 10-15 | Few hat transitions |
| Feature work | 20-30 | Planning + implementation + review |
| Complex refactor | 40-50 | Multiple cycles of analysis/change |
| Full TDD cycle | 50-75 | Red-green-refactor iterations |

### Preventing Runaway Loops

```bash
# Conservative limit for unknown tasks
ralph run --max-iterations 20 --verbose 2>&1

# Watch for repeating patterns indicating loops
# If same event publishes 3+ times, investigate
```

---

## Troubleshooting

### Common Issues

**No Progress / Idle Timeout**
- Check PROMPT.md is readable
- Verify ralph.yml has valid configuration
- Look for events that no hat triggers on

**Same Hat Activates Repeatedly**
- Event loop: hat publishing event that triggers itself
- Check `triggers` and `publishes` in ralph.yml

**Unexpected Completion**
- Verify completion_promise matches expected event
- Check if a hat published LOOP_COMPLETE too early

### Quick Diagnostics

```bash
# Check configuration is valid
ralph validate

# Dry run to see event routing
ralph run --dry-run --verbose
```

---

## Execution Patterns

### Pattern: Test-Monitor-Adjust

```bash
# 1. Short test run
ralph run --max-iterations 3 --verbose 2>&1

# 2. If looks good, full run with cap
ralph run --max-iterations 30 --verbose 2>&1

# 3. If stuck, continue after fixing
# (edit PROMPT.md or ralph.yml)
ralph run --continue --verbose 2>&1
```

---

## Integration with Claude

For programmatic execution within Claude workflows:

```bash
# Non-interactive with full capture
ralph run --max-iterations 20 --verbose 2>&1 | tee output.log
```

---

## Quick Reference

| Command | Purpose |
|---------|---------|
| `ralph run --verbose 2>&1` | Standard execution with monitoring |
| `ralph run --continue` | Resume from checkpoint |
| `ralph run --max-iterations N` | Cap total iterations |
| `ralph validate` | Check configuration |
| `ralph run --dry-run` | Preview event routing |
