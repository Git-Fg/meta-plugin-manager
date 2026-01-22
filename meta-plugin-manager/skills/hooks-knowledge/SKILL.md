---
name: hooks-knowledge
description: "Create event-driven automation hooks for project-scoped configuration. Use when implementing .claude/hooks.json, component-scoped validation, or infrastructure integration. Do not use for plugin-level hook configuration without project context."
user-invocable: true
---

# Hooks Knowledge Base

Create, audit, and refine Claude Code hooks for project-scoped event-driven automation and infrastructure integration using official documentation.

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

## Project-Scoped Hook Configuration

**Two Levels**:

### 1. Global Hooks (`.claude/hooks.json`)
**Target**: `${CLAUDE_PROJECT_DIR}/.claude/hooks.json`

Use for project-wide automation and infrastructure:
```json
{
  "hooks": {
    "SessionStart": [{
      "matcher": "startup",
      "hooks": [{
        "type": "command",
        "command": "./scripts/init.sh"
      }]
    }]
  }
}
```

### 2. Component-Scoped Hooks (Skill/Agent Frontmatter)
**Target**: `hooks:` block in YAML frontmatter

Use for skill-specific validation and logging:
```yaml
---
name: my-skill
description: "Does something"
hooks:
  PreToolUse:
    - matcher: "Write"
      hooks:
        - type: "command"
          command: "validate-write.sh"
---
```

**Best Practice**: Prefer component-scoped hooks to avoid "always-on" noise.

**Configuration**: `.claude/hooks.json` (global) or inline frontmatter (component-scoped)

**Events**: PreToolUse, PostToolUse, PostToolUseFailure, Stop, SubagentStop, SubagentStart, SessionStart, SessionEnd, PermissionRequest, Notification, PreCompact, Setup, UserPromptSubmit

## Hook Events

### Complete Event List (12 Events)

| Event | Trigger | Best For |
|-------|---------|----------|
| `SessionStart` | Session begins/resumes | Session initialization, environment setup |
| `UserPromptSubmit` | User submits prompt | Prompt validation, logging |
| `PreToolUse` | Before tool execution | Validation, security checks |
| `PermissionRequest` | Permission dialog appears | Custom permission logic |
| `PostToolUse` | After tool succeeds | Logging, cleanup, metrics |
| `PostToolUseFailure` | After tool fails | Error handling, recovery |
| `SubagentStart` | Spawning subagent | Subagent configuration |
| `SubagentStop` | Subagent finishes | Cleanup, result processing |
| `Stop` | Claude finishes responding | Final validation, state save |
| `PreCompact` | Before context compaction | State persistence |
| `Setup` | Repository setup/maintenance | One-time initialization |
| `SessionEnd` | Session terminates | Session cleanup |
| `Notification` | Claude Code sends notifications | Notification filtering |

---

### 1. SessionStart
**Trigger**: Session begins or resumes (matchers: startup, resume, clear, compact)

**Use For**:
- Session initialization
- Environment variable persistence via `CLAUDE_ENV_FILE`
- Context setup
- Resource allocation

**Example**:
```json
{
  "SessionStart": [{
    "matcher": "startup|resume",
    "hooks": [{
      "type": "command",
      "command": "setup-session.sh"
    }]
  }]
}
```

### 2. UserPromptSubmit
**Trigger**: User submits a prompt

**Use For**:
- Prompt validation
- User intent logging
- Prompt preprocessing

**Example**:
```json
{
  "UserPromptSubmit": [{
    "hooks": [{
      "type": "command",
      "command": "validate-prompt.sh \"$PROMPT\""
    }]
  }]
}
```

### 3. PreToolUse
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

### 4. PermissionRequest
**Trigger**: Permission dialog appears

**Use For**:
- Custom permission logic
- Security validation
- Access control
- Compliance checks

**Example**:
```json
{
  "PermissionRequest": [{
    "matcher": "Bash",
    "hooks": [{
      "type": "prompt",
      "prompt": "Evaluate if this command should be allowed."
    }]
  }]
}
```

### 5. PostToolUse
**Trigger**: After tool succeeds

**Use For**:
- Logging successful operations
- Cleanup after execution
- Metrics collection
- Result validation

**Example**:
```json
{
  "PostToolUse": [{
    "matcher": "Write|Edit",
    "hooks": [{
      "type": "command",
      "command": "log-success.sh $TOOL_NAME"
    }]
  }]
}
```

### 6. PostToolUseFailure
**Trigger**: After tool fails

**Use For**:
- Error logging
- Recovery actions
- Fallback mechanisms
- Error notifications

**Example**:
```json
{
  "PostToolUseFailure": [{
    "matcher": "*",
    "hooks": [{
      "type": "command",
      "command": "handle-error.sh $ERROR_TYPE"
    }]
  }]
}
```

### 7. SubagentStart
**Trigger**: When spawning a subagent

**Use For**:
- Subagent configuration
- Context injection
- Subagent-specific setup

**Example**:
```json
{
  "SubagentStart": [{
    "hooks": [{
      "type": "command",
      "command": "configure-subagent.sh $SUBAGENT_NAME"
    }]
  }]
}
```

### 8. SubagentStop
**Trigger**: When subagent finishes

**Use For**:
- Subagent cleanup
- Result processing
- Output collection

**Example**:
```json
{
  "SubagentStop": [{
    "hooks": [{
      "type": "prompt",
      "prompt": "Review subagent output for quality."
    }]
  }]
}
```

### 9. Stop
**Trigger**: Claude finishes responding

**Use For**:
- Final validation
- State persistence (use with PreCompact)
- Resource release
- Quality checks

**Example**:
```json
{
  "Stop": [{
    "hooks": [{
      "type": "prompt",
      "prompt": "Review the response for quality and completeness."
    }]
  }]
}
```

### 10. PreCompact
**Trigger**: Before context compaction

**Use For**:
- State persistence before compaction
- Memory optimization
- Critical data save

**Matchers**: `manual` (user-initiated), `auto` (system-triggered)

**Example**:
```json
{
  "PreCompact": [{
    "matcher": "auto",
    "hooks": [{
      "type": "command",
      "command": "save-state.sh"
    }]
  }]
}
```

### 11. Setup
**Trigger**: Repository setup/maintenance

**Use For**:
- One-time initialization
- Dependency installation
- Configuration setup

**Note**: Distinct from SessionStart - Setup runs once, SessionStart runs every session.

**Example**:
```json
{
  "Setup": [{
    "hooks": [{
      "type": "command",
      "command": "install-dependencies.sh"
    }]
  }]
}
```

### 12. SessionEnd
**Trigger**: Session terminates

**Use For**:
- Session cleanup
- Resource deallocation
- Session summary

**Anti-Pattern**: Don't use for state save (use Stop + PreCompact instead).

**Example**:
```json
{
  "SessionEnd": [{
    "hooks": [{
      "type": "command",
      "command": "cleanup-session.sh"
    }]
  }]
}
```

### 13. Notification
**Trigger**: Claude Code sends notifications

**Use For**:
- Notification filtering
- Custom notification handling
- Alert routing

**Type Matchers**: `permission_prompt`, `idle_prompt`, `auth_success`, `elicitation_dialog`

**Example**:
```json
{
  "Notification": [{
    "matcher": "permission_prompt",
    "hooks": [{
      "type": "command",
      "command": "handle-permission.sh"
    }]
  }]
}
```

## Hook Types

### Prompt Hooks (LLM-Based)
**Use For**: Stop, SubagentStop events only

Prompt hooks use Haiku (fast LLM) for LLM-based evaluation. The model evaluates the prompt and makes decisions.

**Best For**:
- Quality validation (Stop/SubagentStop)
- Content review
- Decision-making requiring judgment

**Example**:
```json
{
  "Stop": [{
    "hooks": [{
      "type": "prompt",
      "prompt": "Review this response for quality, clarity, and completeness. Flag any issues."
    }]
  }]
}
```

**⚠️ Important**: Prompt hooks ONLY work for Stop and SubagentStop events. For all other events, use command hooks.

### Command Hooks (Bash-Based)
**Use For**: All events (faster, deterministic)

Command hooks execute external bash commands/scripts. They're fast, deterministic, and work with every event type.

**Best For**:
- Validation rules
- Security checks
- Logging
- State persistence
- File operations

**Example**:
```json
{
  "PreToolUse": [{
    "matcher": "Write|Edit",
    "hooks": [{
      "type": "command",
      "command": "validate-file.sh \"$FILE_PATH\""
    }]
  }]
}
```

**Exit Codes**:
- `0`: Success (stdout shown in verbose mode, except UserPromptSubmit/SessionStart where it's added to context)
- `1`: Non-blocking error (logged but doesn't block operation)
- `2`: Blocking error (stderr shown to Claude, operation blocked)

**Security**: Always quote variables: `"$VAR"` not `$VAR`

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

## Component-Scoped Hooks

**Overview**: Skills and agents can define hooks in their frontmatter (YAML header). These hooks are only active during that component's execution.

**Best For**: Component-specific validation, logging, or behavior modification

**Supported Events**: PreToolUse, PostToolUse, Stop

**Example (Skill Frontmatter)**:
```yaml
---
name: my-skill
description: "Does something"
user-invocable: true
hooks:
  PreToolUse:
    - matcher: "Write"
      hooks:
        - type: "command"
          command: "${CLAUDE_PLUGIN_ROOT}/scripts/validate-write.sh"
  Stop:
    - hooks:
        - type: "prompt"
          prompt: "Review the quality of this response."
---
```

**Example (Agent Frontmatter)**:
```yaml
---
name: my-agent
description: "Specialized agent"
hooks:
  PostToolUse:
    - matcher: "Bash"
      hooks:
        - type: "command"
          command: "log-command.sh $COMMAND"
---
```

**Scoping Hierarchy** (precedence order):
1. **Component-scoped** (highest): Active only during component execution, auto-cleanup
2. **Plugin-level**: Always active when plugin enabled
3. **Project/User-level** (lowest): Organizational policies

**Best Practice**: Prefer component-scoped hooks to avoid "always-on" noise. Use plugin-level hooks sparingly for infrastructure needs.

**Anti-Pattern**: SessionStart hooks that only echo/print without functional behavior (cosmetic noise).

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

## Session Persistence Pattern

**Purpose**: Memory persistence for plugin development decisions

**State File**: `${CLAUDE_PROJECT_DIR}/.claude/PLUGIN_STATE.md`

**Use When**: Implementing hooks that save/load plugin development state (manifest decisions, naming conventions, validation issues)

**Implementation**: See [session-persistence.md](references/session-persistence.md) for:
- State schema specification
- Hook configuration (SessionStart/Stop/PreCompact)
- State extraction logic from transcripts
- Integration patterns with plugin-architect

## Additional Resources

- **Hooks Guide**: https://code.claude.com/docs/en/hooks
- **Security Guide**: https://code.claude.com/docs/en/security
- **Plugin Structure**: https://code.claude.com/docs/en/plugins
