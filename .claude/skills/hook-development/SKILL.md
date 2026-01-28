---
name: hook-development
description: "Create, validate, and audit event-driven hooks for intercepting events, enforcing security patterns, and automating interventions. Use when building or reviewing hooks and event handlers. Not for manual actions or passive knowledge."
---

<mission_control>
<objective>Create event-driven hooks that intercept operations and enforce security patterns</objective>
<success_criteria>Generated hook has valid matcher, action type, and timeout configuration</success_criteria>
<standards_gate>
MANDATORY: Load hook-development references BEFORE creating hooks:

- Security patterns → references/patterns.md
- Quality guidelines → references/quality.md
- Advanced techniques → references/advanced.md
  </standards_gate>
  </mission_control>

<interaction_schema>
event_analysis → matcher_design → action_definition → security_review → output</interaction_schema>

# Hook Development

Hooks are event-driven automation that intercept operations before execution. They provide safety mechanisms, enforce patterns, and enable automated intervention based on event matching.

**Core principle**: Hooks must be event-specific, security-conscious, and provide clear intervention logic.

---

## What Hooks Are

Hooks provide:

- **Event interception**: Pre-execution validation and control
- **Safety mechanisms**: Prevent destructive operations
- **Pattern enforcement**: Ensure compliance with standards
- **Automated intervention**: Proactive issue prevention
- **Security controls**: Authentication and authorization checks

### Hook Architecture

**Event-Driven**: Hooks respond to specific events (Bash commands, tool usage, file operations)

**Two-Phase Operation**:

1. **Matcher**: Identifies target events
2. **Action**: Executes intervention logic

---

## Core Structure

### Hook Configuration

```json
{
  "hooks": {
    "[EventName]": [
      {
        "matcher": "Event matching criteria",
        "hooks": [
          {
            "type": "prompt" | "command",
            "prompt": "Intervention message or validation",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### Hook Body

- **Event identification**: What events to intercept
- **Matching logic**: How to identify target operations
- **Intervention strategy**: What action to take
- **Security implications**: Safety and risk considerations
- **Timeout handling**: Prevention of blocking operations

---

## Best Practices

### Event Matching

- Use precise matching criteria
- Avoid overly broad patterns
- Consider false positives
- Test with various command patterns

### Intervention Patterns

**Prompt hooks**: Interactive user confirmation

```json
{
  "matcher": "tool == \"Bash\" && tool_input.command matches \"rm -rf\"",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "Destructive operation detected. Confirm to proceed.",
      "timeout": 30
    }
  ]
}
```

**Command hooks**: Automated blocking

```json
{
  "matcher": "tool == \"Bash\" && tool_input.command matches \"sudo\"",
  "hooks": [
    {
      "type": "command",
      "command": "BLOCKED: Use sudo with explicit confirmation only"
    }
  ]
}
```

### Security Patterns

- **PreToolUse**: Validate before execution
- **PostToolUse**: Audit after execution
- **Sensitive operations**: Always require confirmation
- **Pattern matching**: Use regex for precision

### Safety Mechanisms

- Always include timeout values
- Provide clear blocking messages
- Log decisions for audit trail
- Prevent deadlocks and infinite loops

### Quality

- Test hook matching thoroughly
- Document intervention rationale
- Include escape hatches for emergencies
- Monitor for false positives

---

## Navigation

| If you need...      | Reference                          |
| ------------------- | ---------------------------------- |
| Security patterns   | `references/patterns.md`           |
| Quality guidelines  | MANDATORY: `references/quality.md` |
| Advanced techniques | `references/advanced.md`           |
| Migration guide     | `references/migration.md`          |

---


<critical_constraint>
MANDATORY: Hooks must have timeout values to prevent blocking operations

MANDATORY: Use prompt hooks for destructive operations requiring user confirmation

MANDATORY: Use command hooks only for clear blocking scenarios

MANDATORY: Test matcher patterns thoroughly before deployment

MANDATORY: Include escape hatches for emergency overrides

No exceptions. Hooks are security mechanisms—they must be safe, timeout-protected, and non-blocking.
</critical_constraint>
