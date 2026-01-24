---
name: create-hook
description: "Add hooks to settings.json or component frontmatter. Use when adding validation or automation. Arguments: event, matcher, type, command."
user-invocable: true
---

# Create Hook

Adds hooks for event-driven automation and validation in .claude/ configuration.

## Usage

```bash
Skill("create-hook", args="event=PreToolUse matcher=Write type=command command='./.claude/scripts/validate.sh'")
```

### Arguments

| Argument | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `event` | string | Yes | - | Event type: PreToolUse, PostToolUse, Stop |
| `matcher` | string | Yes | - | Tool pattern or name |
| `type` | string | Yes | - | Hook type: command or prompt |
| `command` | string | No* | - | Script path (for command type) |
| `scope` | string | No | settings | Scope: settings or component |

*Required for command type

## Event Types

| Event | When | Use For |
|-------|------|---------|
| **PreToolUse** | Before tool execution | Validation, security checks |
| **PostToolUse** | After tool succeeds | Logging, cleanup |
| **Stop** | Claude finishes response | Final validation |

## Scope Types

### settings (Recommended)

**Location**: `.claude/settings.json`

**Best For**: Team-wide automation, project-specific security

### component (Auto-Cleanup)

**Location**: Component frontmatter (skill/agent)

**Best For**: Component-specific validation, automatic cleanup

## Output

Creates or updates `.claude/settings.json` with new hook:
- Creates settings.json if doesn't exist
- Adds hook configuration to appropriate event
- Generates script template in .claude/scripts/

## Scripts

- **add_hook.sh**: Add hook to settings.json
- **scaffold_script.sh**: Generate hook script template
- **validate_hook.sh**: Validate hook configuration

## Completion Marker

## CREATE_HOOK_COMPLETE
