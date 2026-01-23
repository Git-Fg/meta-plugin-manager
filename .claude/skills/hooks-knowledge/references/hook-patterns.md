# Hook Patterns Reference

## Event Types

| Event | Trigger | Use Case |
|-------|---------|----------|
| `SessionStart` | Session begins | Environment setup |
| `UserPromptSubmit` | User submits prompt | Prompt validation |
| `PreToolUse` | Before tool execution | Validation, security |
| `PostToolUse` | After tool succeeds | Logging, cleanup |
| `PostToolUseFailure` | After tool fails | Error handling |
| `Stop` | Claude finishes | Final validation |

## Hook Locations

### Component-Scoped (Preferred)
**Location**: Skill/command/agent YAML frontmatter

**Best For**:
- Component-specific automation
- Auto-cleanup on completion
- Skills/commands: Support `once: true`

**Example**:
```yaml
---
name: my-skill
description: "My skill"
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "validate.sh"
          once: true
---
```

### Settings-Based (Project-Wide)
**Location**: `.claude/settings.json` or `settings.local.json`

**Best For**:
- Cross-component preprocessing
- Team-wide automation
- Project-wide policies

**Example**:
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "WebFetch",
      "hooks": [{
        "type": "command",
        "command": "./cache-content.sh"
      }]
    }]
  }
}
```

## Pattern Examples

### One-Time Setup
```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "npm install"
          once: true  # Skills/commands only
```

### Post-Edit Validation
```yaml
hooks:
  PostToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: "lint-and-format.sh"
```

### Security Guardrail
```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "check-permissions.sh"
          # Block if fails
```

### Cleanup on Stop
```yaml
hooks:
  Stop:
    - matcher: "Read|Grep"
      hooks:
        - type: command
          command: "cleanup-temp.sh"
```

## Matcher Patterns

**Single tool**: `"Bash"`
**Multiple tools**: `"Write|Edit"`
**All tools**: `"*"`
**Negation**: `"!Read"` (all except Read)

## Hook Types

**Command**: Execute shell command
**Prompt**: Modify Claude's prompt
**Function**: Execute JavaScript function (advanced)

## Best Practices

1. Prefer component-scoped for auto-cleanup
2. Use `once: true` for one-time setup (skills/commands only)
3. Match specific events, not all events
4. Keep commands fast and reliable
5. Use settings-based for project-wide preprocessing
