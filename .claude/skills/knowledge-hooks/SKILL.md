---
name: knowledge-hooks
description: "Reference knowledge for hooks: events (PreToolUse/PostToolUse/Stop), security patterns, exit codes, configuration types. Use when understanding hooks. No execution logic."
user-invocable: false
---

# Knowledge: Hooks

Reference knowledge for Claude Code hooks. Pure knowledge without execution logic.

## Quick Reference

**Official Hooks Docs**: https://code.claude.com/docs/en/hooks

### Hook Events

| Event | When | Use For |
|-------|------|---------|
| **PreToolUse** | Before tool execution | Validation, security checks |
| **PostToolUse** | After tool succeeds | Logging, cleanup |
| **Stop** | Claude finishes response | Final validation |

### Lifecycle Events

| Event | When | Use For |
|-------|------|---------|
| **SessionStart** | Session begins | Environment setup |
| **SessionEnd** | Session terminates | Cleanup |
| **UserPromptSubmit** | User submits prompt | Input validation |

## Exit Codes

| Code | Meaning | Action |
|------|---------|--------|
| `0` | Success | Operation allowed |
| `1` | Warning | Operation allowed |
| `2` | Blocking error | Operation denied |

## Configuration Types

### Project Settings (Recommended)

**Location**: `.claude/settings.json`

**Best For**:
- Team-wide automation and policies
- Project-specific security guardrails
- Shared configurations across collaborators

**Configuration**:
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "./.claude/scripts/validate-file.sh"
      }]
    }]
  }
}
```

### Component-Scoped Hooks (Auto-Cleanup)

**Location**: YAML frontmatter in skills/commands/agents

**Best For**:
- Skills/Commands: Preprocessing, validation, one-time setup
- Agents: Scoped event handling, automatic cleanup

**Features**:
- ✅ Auto-cleanup when component finishes
- ✅ Skills/Commands: Support `once: true` for one-time setup
- ❌ Agents: Do NOT support `once` option

**Example**:
```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./.claude/scripts/security-check.sh"
          once: true
```

### Legacy Global Hooks

**Location**: `.claude/hooks.json`

**Note**: Deprecated format. Use `settings.json` instead.

## Matchers

Target specific tools or patterns:

| Matcher | Description |
|---------|-------------|
| `"Write"` | Exact match |
| `"Write|Edit"` | Multiple tools |
| `"Bash"` | Shell commands |
| `"*.env*"` | File patterns |

## Hook Types

| Type | Use When | Output |
|------|----------|--------|
| `command` | Bash script execution | Exit code (0/1/2) |
| `prompt` | LLM-based evaluation | Text response |

## Configuration Structure

```json
{
  "hooks": {
    "EventName": [{
      "matcher": "ToolPattern",
      "hooks": [{
        "type": "command",
        "command": "your-script.sh"
      }]
    }]
  }
}
```

## Security Patterns

### Common Guardrails

| Pattern | Purpose | Implementation |
|---------|---------|----------------|
| **Path Safety** | Prevent path traversal | Validate file paths |
| **Command Validation** | Block dangerous commands | Check allow/deny lists |
| **Environment Protection** | Protect .env files | Block .env modifications |
| **Output Sanitization** | Prevent data leakage | Filter sensitive data |

### Script Validation

**Input Sanitization**:
```bash
# Validate file path
if [[ "$FILE" == *"../"* ]]; then
    echo "ERROR: Path traversal detected"
    exit 2
fi
```

**Output Filtering**:
```bash
# Redact sensitive data
sed 's/KEY=[^ ]*/KEY=***REJECTED***/' output.txt
```

## Reference Files

Load these as needed for comprehensive guidance:

| File | Content | When to Read |
|------|---------|--------------|
| [events.md](references/events.md) | Event types, lifecycle | Understanding hooks |
| [security-patterns.md](references/security-patterns.md) | Security guardrails | Adding validation |
| [hook-types.md](references/hook-types.md) | Configuration types | Choosing scope |
| [hook-patterns.md](references/hook-patterns.md) | Hook implementation patterns | Common patterns |
| [implementation-patterns.md](references/implementation-patterns.md) | Implementation details | Building hooks |
| [script-templates.md](references/script-templates.md) | Validation script patterns | Writing scripts |
| [compliance-framework.md](references/compliance-framework.md) | Quality scoring | Validating hooks |

## Quality Framework

### Scoring System (0-100 points)

| Dimension | Points | Focus |
|-----------|--------|-------|
| **1. Security Coverage** | 25 | Hooks protect critical operations |
| **2. Validation Patterns** | 20 | Input validation and sanitization |
| **3. Exit Code Usage** | 15 | Correct exit codes (0/1/2) |
| **4. Script Quality** | 20 | Well-written, maintainable scripts |
| **5. Configuration Hierarchy** | 20 | Modern configuration approach |

### Quality Thresholds

- **A (90-100)**: Exemplary security posture
- **B (75-89)**: Good security with minor gaps
- **C (60-74)**: Adequate security, needs improvement
- **D (40-59)**: Poor security, significant issues
- **F (0-39)**: Failing security, critical vulnerabilities

## Environment Variables

Use `CLAUDE_PROJECT_DIR` for portable scripts:

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/scripts/validate.sh"
      }]
    }]
  }
}
```

## Performance Considerations

- Keep scripts fast (<100ms)
- Use specific matchers, not broad patterns
- Avoid expensive operations in hooks

## Usage Pattern

```bash
# Load knowledge for understanding
Skill("knowledge-hooks")

# Then use factory for execution
Skill("create-hook", args="event=PreToolUse matcher=Write type=command")
```

## Knowledge Only

This skill contains NO execution logic. For adding hooks, use the create-hook factory skill.
