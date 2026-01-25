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

### 1. Create your Prompt File (Required)

Ralph **always** reads instructions from `PROMPT.md` in the project root.
Refer to `PROMPT_example.txt` (in project root) for high-quality templates.

1. Edit `PROMPT.md`:
   ```markdown
   # My Task Title
   
   Detailed description...
   ```

2. Save the file.

### 2. Execute

**Best Practice (AI Agents & Headless):**
Use `--no-tui` for clean output.

```bash
# Standard execution (reads from PROMPT.md)
ralph run --no-tui --verbose 2>&1
```

**Interactive Mode:**
```bash
ralph run --max-iterations 20
```

### 3. Monitoring

| Output Pattern | Meaning |
|----------------|---------|
| `[iter N]` | Current iteration number |
| `🎩 Hat Name` | Active hat processing |
| `publish: ...` | Event emitted |

---

## Iteration Management

### Choosing Max Iterations

| Task Complexity | Recommended |
|-----------------|-------------|
| Simple fix | 10-15 |
| Feature work | 20-30 |
| Complex refactor | 40-50 |

### Preventing Runaway Loops

```bash
# Cap iterations to prevent infinite loops
ralph run --max-iterations 20 --no-tui --verbose 2>&1
```

---

## Troubleshooting

### Common Issues

**No Progress / Idle Timeout**
- Check `PROMPT.md` exists and is readable.
- Verify `ralph.yml` has valid hat triggers.

**Same Hat Activates Repeatedly**
- Check for event loops in `ralph.yml`.

### Quick Diagnostics

```bash
# Validate config
ralph validate

# Dry run event routing (reads PROMPT.md)
ralph run --dry-run --verbose
```

---

## Integration with Claude

For programmatic execution, simply run the command. Ensure `PROMPT.md` is populated first.

```bash
# Prepare prompt
echo "# Task..." > PROMPT.md

# Run
ralph run --no-tui --verbose 2>&1
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
