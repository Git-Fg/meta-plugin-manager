# Hook Events Reference

Complete documentation of all 13 hook events with triggers, use cases, and examples.

---

## 1. SessionStart

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

---

## 2. UserPromptSubmit

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

---

## 3. PreToolUse

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

---

## 4. PermissionRequest

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

---

## 5. PostToolUse

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

---

## 6. PostToolUseFailure

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

---

## 7. SubagentStart

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

---

## 8. SubagentStop

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

---

## 9. Stop

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

---

## 10. PreCompact

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

---

## 11. Setup

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

---

## 12. SessionEnd

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

---

## 13. Notification

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

---

## Event Type Comparison

| Event | Can Use Prompt Hook | Can Use Command Hook | Best Use Case |
|-------|-------------------|---------------------|---------------|
| SessionStart | ❌ | ✅ | Session initialization |
| UserPromptSubmit | ❌ | ✅ | Prompt validation |
| PreToolUse | ❌ | ✅ | Validation, security |
| PermissionRequest | ❌ | ✅ | Permission logic |
| PostToolUse | ❌ | ✅ | Logging, cleanup |
| PostToolUseFailure | ❌ | ✅ | Error handling |
| SubagentStart | ❌ | ✅ | Subagent config |
| SubagentStop | ✅ | ✅ | Result processing |
| Stop | ✅ | ✅ | Quality validation |
| PreCompact | ❌ | ✅ | State persistence |
| Setup | ❌ | ✅ | One-time setup |
| SessionEnd | ❌ | ✅ | Session cleanup |
| Notification | ❌ | ✅ | Notification handling |

**Key Rule**: Only Stop and SubagentStop support prompt hooks. All other events must use command hooks.
