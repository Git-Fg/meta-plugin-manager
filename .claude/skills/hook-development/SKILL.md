---
name: hook-development
description: This skill should be used when the user asks to "create a hook", "add a PreToolUse/PostToolUse/Stop hook", "validate tool use", "implement prompt-based hooks", "set up event-driven automation", "block dangerous commands", or mentions hook events (PreToolUse, PostToolUse, PostToolUseFailure, PermissionRequest, Stop, SubagentStop, SubagentStart, SessionStart, SessionEnd, UserPromptSubmit, PreCompact, Setup, Notification). Provides comprehensive guidance for creating and implementing hooks in local .claude/ configuration with focus on project-level automation and security.
---

# Hook Development Guide

**Purpose**: Help you create event-driven automation that validates operations and enforces policies

---

## What Hooks Are

Hooks are event-driven automation scripts that execute in response to Claude Code events. They validate operations, enforce policies, and integrate external tools into workflows.

**Key point**: Good hooks work independently and don't need external documentation to validate events.

✅ Good: Hook includes specific event handlers with validation logic
❌ Bad: Hook references external documentation for event logic
Why good: Hooks must self-validate without external dependencies

**Question**: Would this hook work if moved to a project with no rules? If no, include the necessary validation directly.

---

## Philosophy Foundation

Hooks follow these core principles for event-driven automation and security.

### Progressive Disclosure for Hooks

Hooks use targeted disclosure (event-specific validation):

**Tier 1: Event Selection** (choose the right event)
- **PreToolUse**: Validate before tool execution
- **PostToolUse**: React to tool results
- **Stop**: Enforce completion standards
- **PermissionRequest**: Validate permission requests
- **SessionStart/End**: Load/cleanup context

**Tier 2: Validation Logic** (complete in hook)
- Event-specific patterns
- Response format requirements
- Error handling
- Purpose: Enable reliable validation

**Why targeted?** Hooks execute synchronously during events. They must be complete and fast.

**Recognition**: "Does this hook handle all cases for its event type?"

### The Delta Standard for Hooks

> Good hook = Event-specific validation knowledge − Generic hook concepts

Include in hooks (Positive Delta):
- Event-specific patterns (PreToolUse vs PostToolUse)
- Validation logic for the event
- Response format requirements
- Security considerations for the operation
- Error handling patterns

Exclude from hooks (Zero/Negative Delta):
- General "hooks are event-driven" explanations
- Obvious JSON structure
- Generic validation concepts

**Recognition**: "Is this validation logic specific to this event type?"

### Voice and Freedom for Hooks

**Voice**: Imperative validation instructions

Use imperative form in hook prompts:
- "Validate file write safety. Respond with JSON: `{\"ok\": true}`"
- "Check if this operation is safe. Block with reason if not."
- Direct: "Allow if X, block if Y"

**Freedom**: Low for most hooks (security requires consistency)

| Freedom Level | When to Use | Hook Examples |
|---------------|-------------|---------------|
| **Medium** | Flexible validation | Style checks, formatting hooks |
| **Low** | Security/safety operations | File write validation, deployment blocks, permission checks |

**Recognition**: "What breaks if this hook allows an unsafe operation?"

### Self-Containment for Hooks

**Hooks must work without external scripts or dependencies.**

Never reference external files:
- ❌ "See validation-scripts/ for checks"
- ❌ "Use patterns from .claude/rules/"

Always include directly:
- ✅ Complete validation logic
- ✅ Response format specification
- ✅ Error handling instructions
- ✅ All necessary context

**Why**: Hooks execute synchronously during events. External references cause failures.

**Recognition**: "Could this hook execute without external files?"

---

## What Good Hooks Have

### 1. Specific Event Targeting

**Good hooks respond to specific events with clear validation logic.**

Choose the right event type:
- **PreToolUse** - Validate before tool execution
- **PostToolUse** - React to tool results
- **Stop** - Enforce completion standards
- **PermissionRequest** - Validate permission requests
- **SessionStart/End** - Load/cleanup context

**Example**:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Validate file write safety. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block."
          }
        ]
      }
    ]
  }
}
```

✅ Good: Specific event type with clear validation logic
❌ Bad: Generic event handlers without concrete patterns
Why good: Specific events enable targeted enforcement

### 2. Complete Validation Logic

**Good hooks include all necessary validation in the hook itself.**

For prompt-based hooks:
- Define validation criteria
- Specify response format
- Include timeout for execution

**Example**:
```json
{
  "type": "prompt",
  "prompt": "Evaluate if this operation is appropriate: $ARGUMENTS. Check for: system paths, credentials, destructive operations. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block.",
  "timeout": 30
}
```

### 3. Proper Response Format

**Good hooks return structured responses.**

For prompt hooks:
```json
{ "ok": true, "reason": "validation passed" }
// or
{ "ok": false, "reason": "blocked for security reasons" }
```

For Stop hooks:
```json
{ "decision": "allow", "reason": "validation passed" }
// or
{ "decision": "block", "reason": "tests must be run" }
```

### 4. No External Dependencies

**Good hooks work in isolation.**

- Don't reference .claude/rules/ files
- Don't link to external scripts
- Include all validation logic directly
- Bundle necessary security patterns

✅ Good: Complete validation logic included in hook
❌ Bad: "See external scripts for validation"
Why good: Self-contained hooks work anywhere

**Question**: Does this hook assume external files? If yes, include that logic directly.

---

## How to Structure Hooks

### Hook Configuration

Hooks live in `.claude/settings.json` (team-wide) or `.claude/settings.local.json` (personal):

```json
{
  "hooks": {
    "EventType": [
      {
        "matcher": "ToolName|*",
        "hooks": [
          {
            "type": "prompt|command",
            "prompt|command": "[validation logic]",
            "timeout": 30
          }
        ]
      }
    ]
  }
}
```

### Hook Types

**Prompt-Based Hooks** (recommended):
- Use LLM for validation decisions
- Context-aware and flexible
- Return JSON responses

**Command Hooks**:
- Execute bash commands
- Fast, deterministic checks
- Good for external tools

### Common Event Types

**PreToolUse** - Validate before tools run
```json
{
  "matcher": "Write",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "Validate file write safety...",
      "timeout": 30
    }
  ]
}
```

**Stop** - Enforce completion standards
```json
{
  "matcher": "*",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "If code changed, verify tests ran...",
      "timeout": 30
    }
  ]
}
```

**PermissionRequest** - Validate permissions
```json
{
  "matcher": "Bash",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "Validate bash command safety...",
      "timeout": 30
    }
  ]
}
```

**Question**: Which event matches your validation need? Choose the most specific event for targeted enforcement.

---

## Common Patterns

### Prompt-Based Validation

Use prompt hooks for complex, context-aware decisions:

```json
{
  "type": "prompt",
  "prompt": "Evaluate if this operation is appropriate: $ARGUMENTS. Check for security risks. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block.",
  "timeout": 30
}
```

Response format: `{ "ok": true|false, "reason": "explanation" }`

### Command Hooks

Use command hooks for fast, deterministic checks:

```json
{
  "type": "command",
  "command": "bash .claude/scripts/validate.sh",
  "timeout": 60
}
```

**Good for**: File checks, external tools, performance-critical validation

### Multiple Hooks

Stack multiple hooks for layered validation:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {"type": "command", "command": ".claude/scripts/check1.sh"},
          {"type": "prompt", "prompt": "Final validation check..."}
        ]
      }
    ]
  }
}
```

**Remember**: Hooks run independently and don't see each other's output.

---

## Security Examples

### File Write Validation

Prevent unsafe file operations:

```json
{
  "matcher": "Write|Edit",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "Validate file write safety. Check: system paths, credentials, path traversal. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block."
    }
  ]
}
```

### Completion Enforcement

Ensure tests run after code changes:

```json
{
  "matcher": "*",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "If code was modified, verify tests were run. If not, respond with JSON: {\"decision\": \"block\", \"reason\": \"Tests must be run after code changes\"}. Otherwise respond: {\"decision\": \"allow\"}."
    }
  ]
}
```

### Bash Command Safety

Validate dangerous operations:

```json
{
  "matcher": "Bash",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "Validate bash command safety. Check: destructive operations, system commands, credential access. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block."
    }
  ]
}
```

---

## Common Mistakes

### Mistake 1: Vague Event Matching

❌ Bad:
```json
{
  "matcher": "*",
  "hooks": [
    {"type": "prompt", "prompt": "Check this..."}
  ]
}
```

✅ Good:
```json
{
  "matcher": "Write|Edit",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "Validate file write safety...",
      "timeout": 30
    }
  ]
}
```

**Why**: Specific matching enables targeted validation.

### Mistake 2: Incomplete Validation Logic

❌ Bad:
```json
{
  "type": "prompt",
  "prompt": "Check if this is okay"
}
```

✅ Good:
```json
{
  "type": "prompt",
  "prompt": "Evaluate if this operation is appropriate: $ARGUMENTS. Check for security risks, destructive operations, system paths. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block.",
  "timeout": 30
}
```

**Why**: Complete logic enables autonomous decisions.

### Mistake 3: Missing Response Format

❌ Bad:
```json
{
  "type": "prompt",
  "prompt": "Check this and respond"
}
```

✅ Good:
```json
{
  "type": "prompt",
  "prompt": "Validate operation. Respond with JSON: {\"ok\": true} to allow, or {\"ok\": false, \"reason\": \"explanation\"} to block.",
  "timeout": 30
}
```

**Why**: Structured responses enable proper handling.

### Mistake 4: External Dependencies

❌ Bad:
```json
{
  "type": "command",
  "command": "bash .claude/scripts/validate.sh"
}
```

✅ Good:
```json
{
  "type": "prompt",
  "prompt": "Validate operation using these criteria...",
  "timeout": 30
}
```

**Why**: Self-contained hooks work anywhere.

---

## Hook Anti-Patterns

Recognition-based patterns to avoid when creating hooks.

### Anti-Pattern 1: Vague Event Matching

**❌ Generic matchers that catch too many operations**

❌ Bad: `"matcher": "*"` (catches all tools)
✅ Good: `"matcher": "Write|Edit"` (specific tools)

**Recognition**: "Does this matcher target specific operations or everything?"

**Why**: Broad matchers create performance issues and unexpected blocking.

### Anti-Pattern 2: Incomplete Validation Logic

**❌ Hooks that don't specify response format or handle all cases**

❌ Bad: "Check if this is safe" (no format specified)
✅ Good: "Validate file write safety. Respond with JSON: `{\"ok\": true}` to allow, or `{\"ok\": false, \"reason\": \"...\"}` to block."

**Recognition**: "Does the hook specify exact response format?"

**Why**: Hooks need clear response formats to integrate properly with the event system.

### Anti-Pattern 3: Missing Response Format

**❌ Hooks that don't specify what to return**

❌ Bad: "Block dangerous operations"
✅ Good: "To block: Return `{\"ok\": false, \"reason\": \"explanation\"}`. To allow: Return `{\"ok\": true}`."

**Recognition**: "Does the hook specify the JSON structure for responses?"

**Why**: Incorrect response formats cause silent failures or system errors.

### Anti-Pattern 4: External Dependencies

**❌ Hooks that reference external scripts or files**

❌ Bad: `"command": "bash validation-scripts/check.sh"`
✅ Good: Include validation logic directly in the hook prompt.

**Recognition**: "Could this hook execute without external files?"

**Why**: Hooks execute synchronously. External dependencies cause failures.

### Anti-Pattern 5: Security Issues

**❌ Hooks that allow unsafe operations without proper validation**

❌ Bad: File write hook that doesn't check file paths
✅ Good: File write hook that validates: no ~/.claude/ modification, no absolute paths outside project

**Recognition**: "Does this hook properly validate security-sensitive operations?"

**Why**: Hooks are security controls. Weak validation enables dangerous operations.

---

## Quality Checklist

A good hook:

- [ ] Uses specific event types (not generic "*")
- [ ] Has clear validation logic in the prompt/command
- [ ] Returns structured JSON responses
- [ ] Includes timeout values
- [ ] Works without external dependencies
- [ ] Has no references to .claude/rules/ files

**Self-check**: Could this hook work in a fresh project? If not, it needs more context.

---

## Summary

Hooks are event-driven automation that validates operations and enforces policies. Good hooks:

- **Target specifically** - Use the right event for the job
- **Validate clearly** - Include all logic in the hook
- **Respond properly** - Return structured JSON
- **Work anywhere** - No external dependencies

Keep the focus on:
- Clarity over complexity
- Specificity over generality
- Self-contained over dependent
- Security over convenience

**Question**: Is your hook clear enough that it would validate events correctly without external documentation?

---

**Final tip**: The best hook is one that enforces security without requiring external setup. Focus on that.
