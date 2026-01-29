---
name: hook-development
description: "Create, validate, and audit event-driven hooks for intercepting events, enforcing security patterns, and automating interventions. Use when building or reviewing hooks, implementing event handlers, or adding safety guardrails. Includes matcher patterns, action types, timeout configuration, and security enforcement. Not for manual actions, passive knowledge, or non-event-driven automation."
---

<mission_control>
<objective>Create event-driven hooks that intercept operations and enforce security patterns</objective>
<success_criteria>Generated hook has valid matcher, action type, and timeout configuration</success_criteria>
</mission_control>

<interaction_schema>
event_analysis → matcher_design → action_definition → security_review → output</interaction_schema>

# Hook Development

**Skill Location**: This file

## Quick Start

**Create hook:** Follow matcher + action structure with timeout configuration

**Review hook:** Use `quality-standards` skill → Apply security patterns

**Test matcher:** Verify with `Bash` command before deployment

**Why:** Hooks intercept operations at runtime—prevention is more valuable than post-hoc correction.

## Critical Reference Loading

**Key Reference**: `references/pattern_advanced.md` contains critical event handling patterns. Read in full when implementing complex hooks—partial understanding leads to runtime errors.

## Navigation

| If you need...         | Read...                            |
| :--------------------- | :--------------------------------- |
| Create hook            | ## Implementation Patterns         |
| Review hook quality    | Use `quality-standards` skill      |
| Test matcher           | See Bash examples in this file     |
| Event matcher patterns | `references/pattern_advanced.md`   |
| Security anti-patterns | `references/lookup_quality.md`     |
| Migration guidance     | `references/workflow_migration.md` |

## System Requirements

- **Hook config**: JSON format with `matcher` + `hooks` array
- **Action types**: `prompt` (requires user confirmation) or `command` (silent blocking)
- **Timeout**: Required for `prompt` hooks (prevents blocking operations)
- **Matcher syntax**: `tool == "Bash" && tool_input.command matches "pattern"`
- **Portability**: Use project-relative paths, no hardcoded environment paths

## Operational Patterns

This skill follows these behavioral patterns:

- **Planning**: Switch to planning mode for architectural decisions
- **Discovery**: Locate files matching patterns and search file contents for hook integration points
- **Delegation**: Delegate planning and exploration to specialized workers
- **Tracking**: Maintain a visible task list for hook development

<critical_constraint>
Use native tools to fulfill these patterns. The System Prompt selects the correct implementation for semantic directives.
</critical_constraint>

## Implementation Patterns

### Pattern: Destructive Operation Block

```json
{
  "matcher": "tool == \"Bash\" && tool_input.command matches \"rm -rf\"",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "rm -rf detected. This cannot be undone. Type 'DELETE' to confirm.",
      "timeout": 30
    }
  ]
}
```

### Pattern: Sudo Confirmation

```json
{
  "matcher": "tool == \"Bash\" && tool_input.command matches \"sudo\"",
  "hooks": [
    {
      "type": "command",
      "command": "echo 'Sudo requires explicit confirmation.'"
    }
  ]
}
```

### Pattern: Protected File Guard

```bash
if [[ "$file_path" == *".env"* ]]; then
  echo '{"decision": "deny", "reason": "Protected file"}' >&2
  exit 2
fi
```

## Troubleshooting

| Issue                               | Symptom                             | Solution                                                |
| ----------------------------------- | ----------------------------------- | ------------------------------------------------------- |
| Broad match blocking all operations | Matcher `"*"` or overly generic     | Target specific tool + dangerous args                   |
| User confused why operation failed  | Silent block with no explanation    | Use `prompt` type with clear message                    |
| Hook blocking forever               | Missing timeout on prompt hook      | Add `timeout: 30` or similar                            |
| Hook failing on different machines  | Hardcoded paths like `/home/user/`  | Use project-relative paths with `${CLAUDE_PROJECT_DIR}` |
| Variable injection vulnerability    | Unquoted variables with spaces      | Always quote variables: `"$file_path"`                  |
| Security bypass                     | No confirmation for destructive ops | Add prompt hook with confirmation requirement           |

---

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

## Hook Anti-Patterns

Avoid these common vulnerabilities:

### 1. The Broad Match

```json
// BAD: Matcher catches everything
"matcher": "*"
```

This generates noise and blocks legitimate operations.

```json
// GOOD: Target specific tool and dangerous args
"matcher": "tool == \"Bash\" && tool_input.command matches \"rm -rf\""
```

### 2. The Silent Block

```json
// BAD: User has no idea why operation failed
"type": "command",
"command": "exit 1"
```

The user sees a generic failure with no guidance.

```json
// GOOD: Fail loudly with explanation
"type": "prompt",
"prompt": "Destructive rm -rf detected. This cannot be undone. Type 'DELETE' to confirm.",
"timeout": 30
```

### 3. The Missing Timeout

```json
// BAD: No timeout - hook could block forever
"type": "prompt"
```

Operations without timeouts can deadlock the system.

```json
// GOOD: Timeout prevents blocking
"type": "prompt",
"prompt": "Confirm destructive operation",
"timeout": 30
```

### 4. The Hardcoded Path

```json
// BAD: Not portable across environments
"command": "/home/user/scripts/validate.sh"
```

Fails when team members have different home directories.

```json
// GOOD: Use project-relative paths
"command": "bash ${CLAUDE_PROJECT_DIR}/.claude/scripts/validate.sh"
```

### 5. The Unquoted Variable

```bash
# BAD: Injection risk with spaces or special chars
rm -rf $file_path

# GOOD: Always quote variables
rm -rf "$file_path"
```

---

## Correct Patterns

**Prompt for destructive operations:**

```json
{
  "matcher": "tool == \"Bash\" && tool_input.command matches \"rm -rf\"",
  "hooks": [
    {
      "type": "prompt",
      "prompt": "rm -rf detected. This cannot be undone. Type 'DELETE' to confirm.",
      "timeout": 30
    }
  ]
}
```

**Block sudo with clear message:**

```json
{
  "matcher": "tool == \"Bash\" && tool_input.command matches \"sudo\"",
  "hooks": [
    {
      "type": "command",
      "command": "echo 'Sudo requires explicit confirmation. Remove this block if needed.'"
    }
  ]
}
```

**Protect sensitive files:**

```bash
# Check for .env before allowing operations
if [[ "$file_path" == *".env"* ]]; then
  echo '{"decision": "deny", "reason": "Protected file"}' >&2
  exit 2
fi
```

---

## Genetic Code

This component carries essential Seed System principles for context: fork isolation:

<critical_constraint>
All components work with zero .claude/rules dependencies (portability invariant).
Achieve 80-95% autonomy (0-5 AskUserQuestion rounds per session).
Use What-When-Not-Includes format in descriptions (third person).
Progressive disclosure: SKILL.md contains core philosophy; references/ contains detailed content.
Use XML for control (mission_control, critical_constraint), Markdown for data.
</critical_constraint>

**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows

**Recognition Questions**:

- "Would Claude know this without being told?" → Delete (zero delta)
- "Can this work standalone?" → Fix if no (non-self-sufficient)
- "Did I read the actual file, or just see it in grep?" → Verify before claiming

---

<guiding_principles>

## The Path to High-Quality Hooks

### 1. Precise Matcher Design

Hooks work reliably when matchers target specific operations rather than broad patterns.

- **Target specifically**: Match tool + dangerous args (e.g., `tool == "Bash" && command matches "rm -rf"`)
- **Avoid broad matches**: Generic `"*"` matchers block legitimate operations
- **Test thoroughly**: Verify matchers catch intended operations without false positives

### 2. Clear User Communication

Hooks succeed when users understand why operations are blocked.

- **Prompt type for confirmation**: Use `type: "prompt"` for destructive operations requiring user consent
- **Command type for clear blocks**: Use `type: "command"` with explanation messages
- **Explain clearly**: Describe what was detected and why it matters

### 3. Timeout Protection

Hooks prevent system blocking when timeout values are properly configured.

- **Always set timeouts**: `timeout: 30` or similar prevents indefinite waiting
- **Prevent deadlocks**: Operations without timeouts can hang the entire system
- **Reasonable defaults**: 30 seconds works for most confirmation prompts

### 4. Portability Through Relative Paths

Hooks work across environments when paths are project-relative.

- **Use `${CLAUDE_PROJECT_DIR}`**: Instead of hardcoded paths like `/home/user/`
- **Environment variables**: Externalize configuration for different machines
- **Team compatibility**: Project-relative paths work across different home directories

### 5. Variable Safety

Hooks prevent injection vulnerabilities when variables are properly quoted.

- **Always quote variables**: `"$file_path"` instead of `$file_path`
- **Prevent injection**: Unquoted variables with spaces cause security issues
- **Bash best practices**: Use `[[ ]]` for tests and quote all expansions

### 6. Security-First Design

Hooks protect systems when safety mechanisms are properly implemented.

- **Destructive operation confirmation**: `rm -rf`, `sudo`, and similar commands require explicit approval
- **Protected file guards**: `.env`, credentials, and config files need special handling
- **Escape hatches**: Provide emergency override mechanisms for legitimate operations
  </guiding_principles>

---

<critical_constraint>
**System Physics:**

1. Zero external dependencies (portability invariant)
2. Hooks require timeout values to prevent blocking operations
3. Prompt hooks for user confirmation, command hooks for clear blocking
4. Completion claims require verification evidence
   </critical_constraint>
