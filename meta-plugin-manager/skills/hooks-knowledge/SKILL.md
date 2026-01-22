---
name: hooks-knowledge
description: "Create event-driven automation hooks for Claude Code. Use when implementing validation hooks, infrastructure integration, or session lifecycle automation. Do not use for simple file operations or basic workflows."
user-invocable: true
---

# Hooks Knowledge Base

Create, audit, and refine Claude Code hooks for event-driven automation and infrastructure integration using official documentation.

## 🚨 MANDATORY: Read BEFORE Creating Hooks

**CRITICAL**: You MUST read and understand these URLs:

### Primary Documentation (MUST READ)
- **[MUST READ] Official Hooks Guide**: https://code.claude.com/docs/en/hooks
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **When to Read**: Before any hook creation or modification
  - **Content**: Hook events, configuration, prompt-based vs command hooks
  - **Cache**: 15 minutes minimum

- **[MUST READ] Security Guide**: https://code.claude.com/docs/en/security
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **When to Read**: Before implementing any hook with security implications
  - **Content**: Security best practices, input validation, path safety
  - **Cache**: 15 minutes minimum

### ⚠️ BLOCKING RULES
- **DO NOT proceed** without understanding hook events and types
- **MUST validate** security requirements before implementation
- **REQUIRED** to understand event-driven automation patterns

## Quick Reference

**Hooks** execute in response to Claude Code events for automation and infrastructure integration.

**Use Hooks For**:
- Event-driven automation
- Validation before tool execution
- Infrastructure integration
- MCP/LSP configuration
- Permission management
- Session lifecycle management

**Configuration**: `hooks/hooks.json` or inline in `plugin.json`

**Events**: PreToolUse, Stop/SubagentStop, SessionStart/End, PermissionRequest, Notification

## Hook Events

### 1. PreToolUse
**Trigger**: Before tool execution

**Use For**:
- Validation before execution
- Security checks
- Path safety verification
- Permission checks

**Example**:
```json
{
  "PreToolUse": [{
    "matcher": "Write|Edit",
    "hooks": [{
      "type": "prompt",
      "prompt": "Validate this file operation is safe."
    }]
  }]
}
```

### 2. Stop/SubagentStop
**Trigger**: When agent considers stopping

**Use For**:
- Cleanup operations
- Final validation
- State persistence
- Resource release

### 3. SessionStart/End
**Trigger**: Session boundaries

**Use For**:
- Session initialization
- Context setup
- Resource allocation
- Session cleanup

### 4. PermissionRequest
**Trigger**: Permission management

**Use For**:
- Custom permission logic
- Security validation
- Access control
- Compliance checks

### 5. Notification
**Trigger**: User notifications

**Use For**:
- Status updates
- Progress tracking
- Alert systems
- Communication

## Hook Types

### Prompt Hooks
Execute inline prompts

```json
{
  "PreToolUse": [{
    "matcher": "Write",
    "hooks": [{
      "type": "prompt",
      "prompt": "Validate this operation..."
    }]
  }]
}
```

### Command Hooks
Execute external commands/scripts

```json
{
  "PreToolUse": [{
    "matcher": "Bash",
    "hooks": [{
      "type": "command",
      "command": "validate.sh $TOOL_NAME"
    }]
  }]
}
```

## Configuration

### Create Hooks Directory
```bash
mkdir -p hooks
```

### Create hooks.json
```json
{
  "hooks": {
    "EventName": [{
      "matcher": "ToolName",
      "hooks": [{
        "type": "prompt|command",
        "prompt|command": "..."
      }]
    }]
  }
}
```

### Add to Plugin
```json
{
  "name": "my-plugin",
  "hooks": {
    "PreToolUse": [...]
  }
}
```

## Security Considerations

### Path Safety
```json
{
  "PreToolUse": [{
    "matcher": "Write",
    "hooks": [{
      "type": "command",
      "command": "validate-path.sh $FILE_PATH"
    }]
  }]
}
```

### Input Validation
```json
{
  "PermissionRequest": [{
    "matcher": "Bash",
    "hooks": [{
      "type": "prompt",
      "prompt": "Validate this command is safe."
    }]
  }]
}
```

## Implementation

### Step 1: Identify Event
Choose event based on trigger:
- PreToolUse: Before execution
- SessionStart/End: Session management
- PermissionRequest: Permission handling
- Notification: User notifications

### Step 2: Configure Hook
```json
{
  "PreToolUse": [{
    "matcher": "Write|Edit",
    "hooks": [{
      "type": "prompt",
      "prompt": "Validate operation..."
    }]
  }]
}
```

### Step 3: Test Hook
1. Trigger the event
2. Verify hook executes
3. Check expected behavior
4. Validate security

## Examples

### File Validation Hook
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "validate-file.sh $FILE_PATH"
      }]
    }]
  }
}
```

### Session Management Hook
```json
{
  "hooks": {
    "SessionStart": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "setup-session.sh"
      }]
    }],
    "SessionEnd": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "cleanup-session.sh"
      }]
    }]
  }
}
```

### Security Hook
```json
{
  "hooks": {
    "PermissionRequest": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "prompt",
        "prompt": "Check if user has permission."
      }]
    }]
  }
}
```

## Best Practices

### DO ✅
- Validate all inputs
- Use path safety checks
- Implement proper error handling
- Follow security guidelines
- Test thoroughly

### DON'T ❌
- Don't execute untrusted commands
- Don't skip validation
- Don't ignore security warnings
- Don't create conflicting hooks

## Troubleshooting

### Hook Not Triggering
1. Verify event name is correct
2. Check matcher syntax
3. Validate JSON format
4. Test with simple hook first

### Invalid JSON
1. Use JSON validator
2. Check for trailing commas
3. Verify quotes are proper
4. Test syntax

### Security Errors
1. Review path safety
2. Check input validation
3. Verify command restrictions
4. Update security policies

## Detailed Examples

Complete hook configurations:
- PreToolUse validation
- PostToolUse logging
- Error recovery patterns

Advanced patterns:
- Multi-hook chains
- Conditional hooks
- State management

Error handling strategies:
- Graceful degradation
- Retry logic
- User feedback

## Additional Resources

- **Hooks Guide**: https://code.claude.com/docs/en/hooks
- **Security Guide**: https://code.claude.com/docs/en/security
- **Plugin Structure**: https://code.claude.com/docs/en/plugins
