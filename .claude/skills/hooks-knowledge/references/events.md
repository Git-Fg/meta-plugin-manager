# Hook Events Reference

Hooks are triggered by specific events in the Claude Code execution lifecycle.

## Supported Events

### PreToolUse
**Triggered**: Before a tool is executed
**Use Cases**:
- Validate input before execution
- Check for dangerous operations
- Enforce security policies
- Initialize resources

**Example**:
```yaml
PreToolUse:
  - matcher: "Bash"
    hooks:
      - type: command
        command: "./scripts/validate-bash.sh"
```

### PostToolUse
**Triggered**: After a tool is executed
**Use Cases**:
- Format output
- Log execution details
- Trigger follow-up actions
- Cleanup resources

**Example**:
```yaml
PostToolUse:
  - matcher: "Write|Edit"
    hooks:
      - type: command
        command: "./scripts/format-files.sh"
```

### Stop
**Triggered**: When component completes
**Use Cases**:
- Generate summary reports
- Cleanup temporary files
- Send notifications
- Persist state

**Example**:
```yaml
Stop:
  - matcher: "*"
    hooks:
      - type: command
        command: "./scripts/cleanup.sh"
```

## Matcher Patterns

Use regular expressions to match event types:
- `"Bash"` - Match Bash tool
- `"Write|Edit"` - Match Write OR Edit tools
- `"*"` - Match all events
- `"Read.*"` - Match tools starting with "Read"

## Event Context

Each hook receives context about the event:
- Tool name
- Tool arguments
- Execution status
- Timestamp
- Component metadata
