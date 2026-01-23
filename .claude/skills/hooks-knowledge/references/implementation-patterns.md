# Hooks Implementation Patterns

Detailed implementation patterns and templates for hooks configuration.

## Hook Events Reference

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

**For complete event documentation**: See [events.md](references/events.md) for all 13 hook events with triggers, use cases, and examples.

## Common Guardrail Patterns

### Protection Hook (Fail Fast)
**Block dangerous file operations:**

```json
{
  "PreToolUse": [{
    "matcher": "Write",
    "hooks": [{
      "type": "command",
      "command": "guard-env-files.sh"
    }]
  }]
}
```

**Script Example** (`guard-env-files.sh`):
```bash
#!/bin/bash
FILE_PATH="$1"
if [[ "$FILE_PATH" == *".env"* ]]; then
  echo "❌ BLOCKED: Writing to .env files requires explicit approval"
  exit 2
fi
exit 0
```

### Quality Gate Hook
**Validate code before deployment:**

```yaml
---
name: deploy-skill
description: "Deploys application"
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: "command"
          command: "run-tests.sh"
---
```

### Session Persistence Hook
**Remember development decisions:**

```json
{
  "Stop": [{
    "hooks": [{
      "type": "command",
      "command": "save-decisions.sh"
    }]
  }]
}
```

**Reference**: [Session Persistence Pattern](references/session-persistence.md)

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

## Configuration Patterns

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

## Component-Scoped Hooks (Recommended)

**Overview**: Skills and agents can define hooks in their frontmatter (YAML header). These hooks are only active during that component's execution.

**Best For**: Component-specific validation, security checks, and quality gates

**Supported Events**: PreToolUse, PostToolUse, Stop

**Example (Skill Frontmatter)**:
```yaml
---
name: deploy-skill
description: "Deploys application to production"
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: "command"
          command: "run-tests.sh"
  Stop:
    - hooks:
        - type: "prompt"
          prompt: "Review deployment quality and rollback plan."
---
```

**Example (Agent Frontmatter)**:
```yaml
---
name: code-auditor
description: "Audits code for security issues"
hooks:
  PostToolUse:
    - matcher: "Grep"
      hooks:
        - type: "command"
          command: "validate-findings.sh"
---
```

**Scoping Hierarchy** (precedence order):
1. **Component-scoped** (highest): Active only during component execution, auto-cleanup
2. **Project-level** (recommended): Global hooks in `.claude/hooks.json`
3. **User-level** (lowest): Organizational policies

**Best Practice**:
- ✅ **Prefer component-scoped hooks** to avoid "always-on" noise
- ✅ Use for skill-specific validation and security
- ✅ Block dangerous operations with `exit 2`
- ❌ **Avoid** plugin-level hooks (not project-scoped)

**Anti-Pattern**: SessionStart hooks that only echo/print without functional behavior (cosmetic noise).

## Security Guardrails

### Path Safety (Fail Fast)
**Block dangerous file operations in your project:**

```json
{
  "PreToolUse": [{
    "matcher": "Write",
    "hooks": [{
      "type": "command",
      "command": "guard-sensitive-paths.sh"
    }]
  }]
}
```

**Script Template** (`guard-sensitive-paths.sh`):
```bash
#!/bin/bash
FILE_PATH="$1"

# Block sensitive files
if [[ "$FILE_PATH" =~ \.env$ ]] || [[ "$FILE_PATH" =~ \.aws/credentials$ ]]; then
  echo "❌ BLOCKED: Sensitive file modification requires explicit approval"
  exit 2
fi

# Block deletion of important directories
if [[ "$FILE_PATH" =~ node_modules/ ]] || [[ "$FILE_PATH" =~ .git/ ]]; then
  echo "❌ BLOCKED: Protected directory modification"
  exit 2
fi

exit 0
```

### Input Validation (Quality Gates)
**Validate operations before execution:**

```json
{
  "PreToolUse": [{
    "matcher": "Bash",
    "hooks": [{
      "type": "command",
      "command": "validate-command.sh"
    }]
  }]
}
```

**Script Template** (`validate-command.sh`):
```bash
#!/bin/bash
COMMAND="$1"

# Block dangerous commands
if [[ "$COMMAND" =~ rm[[:space:]]+-rf ]] || [[ "$COMMAND" =~ sudo.*rm ]]; then
  echo "❌ BLOCKED: Dangerous deletion command"
  exit 2
fi

exit 0
```

## Session Persistence Pattern

**Purpose**: Memory persistence for plugin development decisions

**State File**: `${CLAUDE_PROJECT_DIR}/.claude/TOOLKIT_STATE.md`

**Use When**: Implementing hooks that save/load plugin development state (manifest decisions, naming conventions, validation issues)

**Implementation**: See [session-persistence.md](references/session-persistence.md) for:
- State schema specification
- Hook configuration (SessionStart/Stop/PreCompact)
- State extraction logic from transcripts
- Integration patterns with toolkit-architect

## Delegation Handling Patterns

### For Hook Configuration Delegations

**When responding to hooks-architect delegations**:

```markdown
## Hook Configuration Guidance

**Guardrail Pattern**: [Pattern name]
**Scope**: [Component-scoped|preferred|Global]

**Security Assessment:**
- Input validation: [Score]/10
- Path safety: [Score]/10
- Command validation: [Score]/10
- Exit code handling: [Score]/10

**Implementation Details:**
- Event type: [Event Name]
- Hook type: [prompt|command]
- Script location: [.claude/scripts/script.sh]
- Blocking behavior: [exit 2 for blocking]

**Best Practices Applied:**
- [Practice 1]: [Implementation]
- [Practice 2]: [Implementation]
```

### For Component-Scoped Hooks

When adding hooks to skill/agent frontmatter:

```markdown
**Component-Scoped Hook Configuration:**

**Target**: [Skill/Agent name]
**Scope**: Active only during component execution
**Auto-cleanup**: [Yes - hooks removed when component done]

**Hook Configuration:**
- Event: [PreToolUse|PostToolUse|Stop]
- Matcher: [Tool pattern]
- Script: [Validation command]
- Exit strategy: [0=success|1=warning|2=blocking]

**Benefits:**
- No "always-on" noise ✅
- Component-specific validation ✅
- Automatic lifecycle management ✅
```

### For Global Hooks

When configuring project-level hooks in .claude/hooks.json:

```markdown
**Global Hook Configuration:**

**Target**: [.claude/hooks.json]
**Scope**: Active for entire project session
**Persistence**: [Across all components]

**Hook Chain:**
- Event: [Event Name]
- Hook 1: [Script - Purpose]
- Hook 2: [Script - Purpose]
- Hook N: [Script - Purpose]

**Execution Order:**
1. [Script 1] - [Triggers when]
2. [Script 2] - [Triggers when]
3. [Script N] - [Triggers when]

**Global Considerations:**
- Performance impact: [Assessment]
- Security coverage: [Scope]
- Maintenance overhead: [Level]
```
