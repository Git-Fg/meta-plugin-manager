---
name: hooks-knowledge
description: "Create event-driven automation and validation hooks in .claude/ configuration. Use for file validation, security guardrails, pre-tool checks, and project automation. Templates for PreToolUse, PostToolUse, and component-scoped hooks. Triggers: 'add validation hook', 'file security', 'prevent dangerous operations', 'automated checks', 'PreToolUse validation', 'guardrails setup'."
user-invocable: true
---

# Hooks Knowledge Base

## WIN CONDITION

**Called by**: hooks-architect
**Purpose**: Provide implementation guidance for hooks architecture

**Output**: Must output completion marker after providing guidance

```markdown
## HOOKS_KNOWLEDGE_COMPLETE

Guidance: [Implementation patterns provided]
References: [List of reference files]
Recommendations: [List]
```

**Completion Marker**: `## HOOKS_KNOWLEDGE_COMPLETE`

Reference library for creating project-scoped hooks automation and guardrails in `.claude/` configuration. Contains templates, security patterns, and best practices for protecting and automating your local project.

## 🚨 MANDATORY: Read BEFORE Creating Hooks

**CRITICAL**: You MUST read and understand these URLs:

### Primary Documentation (MUST READ)
- **[MUST READ] Hooks Guide**: https://code.claude.com/docs/en/hooks
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Content**: Hook events, lifecycle, configuration patterns
  - **Cache**: 15 minutes minimum

- **[MUST READ] Security Guide**: https://code.claude.com/docs/en/security
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Content**: Security validation patterns, guardrails
  - **Cache**: 15 minutes minimum

- **[MUST READ] Plugin Structure**: https://code.claude.com/docs/en/plugins
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Content**: Component-scoped hooks in plugin structure
  - **Cache**: 15 minutes minimum

### ⚠️ BLOCKING RULES
- **DO NOT proceed** without understanding hook events and types
- **MUST validate** security requirements before implementation
- **REQUIRED** to understand event-driven automation patterns

## Core Philosophy: Project-First Hooks

**This skill teaches the "Project Scaffolding & Guardrails" approach:**

1. **Zero Active Hooks in Toolkit**: The toolkit contains NO active hooks for users
2. **Templates, Not Execution**: Provides templates and patterns, not active configuration
3. **Project-Local Configuration**: All hooks belong in user's `.claude/` directory (settings.json, settings.local.json, or hooks.json)
4. **Component-Scoped First**: Prefer hooks in skill/agent frontmatter over global hooks
5. **Settings Files**: Modern approach using `.claude/settings.json` or `.claude/settings.local.json`
6. **Fail Fast Principle**: Use command hooks with `exit 2` for immediate blocking
7. **User Empowerment**: Users create their own guardrails, toolkit guides them

## Quick Reference

**Hooks** automate your local project through event-driven guardrails and validation.

**Use Hooks For**:
- **Guardrails**: Prevent dangerous operations (e.g., `.env` modification)
- **Validation**: Validate file operations before execution
- **Project Automation**: Initialize development environment
- **Quality Gates**: Ensure code meets project standards
- **Session Management**: Persist development decisions
- **Security**: Block unauthorized actions

**Project-First Approach**:
- **Local Configuration**: Hooks in your `.claude/settings.json`, `.claude/settings.local.json`, or `.claude/hooks.json`
- **Component-Scoped**: Hooks in skill/agent frontmatter (preferred for auto-cleanup)
  - ✅ Skills/Commands: Support `once: true` for one-time setup
  - ❌ Agents: Do NOT support `once` option
- **Settings Files**: Modern JSON format for better team collaboration
- **Fail Fast**: Use `exit 2` to block dangerous operations
- **Templates**: Use provided templates, customize for your project

**Component-Scoped vs Settings-Based**:
- **Component-Scoped**: Use for skill-specific validation, one-time setup (`once: true`), auto-cleanup
- **Settings-Based**: Use for project-wide preprocessing, team automation, cross-component policies

## Project-Scoped Hook Configuration

**Three Configuration Levels for Your Local Project**:

### 1. Project Settings (Recommended)
**Target**: `${CLAUDE_PROJECT_DIR}/.claude/settings.json` or `${CLAUDE_PROJECT_DIR}/.claude/settings.local.json`

Use for project-wide automation and infrastructure guardrails:

**settings.json** (team-shared, committed to git):
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "validate-write.sh"
      }]
    }]
  }
}
```

**settings.local.json** (local only, gitignored):
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "validate-file.sh"
      }]
    }]
  }
}
```

**Create in your project:**
```bash
mkdir -p .claude
cat > .claude/settings.json << 'EOF'
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "validate-file.sh"
      }]
    }]
  }
}
EOF
```

### 2. Legacy Global Hooks (`.claude/hooks.json`)
**Target**: `${CLAUDE_PROJECT_DIR}/.claude/hooks.json`

**Note**: This is the legacy format. `settings.json` is the modern replacement.

```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "validate-write.sh"
      }]
    }]
  }
}
```

**Create in your project:**
```bash
mkdir -p .claude
cat > .claude/hooks.json << 'EOF'
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write|Edit",
      "hooks": [{
        "type": "command",
        "command": "validate-file.sh"
      }]
    }]
  }
}
EOF
```

### 3. Component-Scoped Hooks (Skill/Command/Agent Frontmatter)
**Target**: `hooks:` block in YAML frontmatter

Use for skill-specific validation, security, and component automation:

```yaml
---
name: deploy-skill
description: "Deploys application with validation"
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: "command"
          command: "run-tests.sh"
          once: true  # Only runs once per session
  PostToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: "command"
          command: "format-code.sh"
---
```

**Key Features**:
- ✅ Auto-cleanup when component finishes
- ✅ Skills/Commands: Support `once: true` for one-time setup
- ❌ Agents: Do NOT support `once` option
- ✅ Supports all events: PreToolUse, PostToolUse, Stop

**Best Practice**: Prefer component-scoped hooks to avoid "always-on" noise. Use settings.json for project-wide guardrails. Use settings.local.json for personal overrides.

**Configuration Location**:
- `.claude/settings.json` (team-shared project settings)
- `.claude/settings.local.json` (local personal settings)
- `.claude/hooks.json` (legacy global hooks)
- Component-scoped: inline frontmatter in skills/commands/agents

## Hook Configuration Quick Decision Guide

### Use Component-Scoped Hooks When:
- ✅ Hook applies to specific skill/command/agent
- ✅ Need `once: true` for one-time setup
- ✅ Want auto-cleanup when component finishes
- ✅ Skill-specific validation needed

### Use Settings-Based Hooks When:
- ✅ Need preprocessing across multiple components
- ✅ Team-wide automation required
- ✅ Project-wide policies needed
- ✅ General automation (NOT component-specific)

### Examples by Use Case:

**One-Time Setup (Component-Scoped)**:
```yaml
# Skill with once: true
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "install-deps.sh"
          once: true
```

**Project-Wide Preprocessing (Settings-Based)**:
```json
// settings.json - filters logs across all skills
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "filter-logs.sh"
      }]
    }]
  }
}
```

**Post-Edit Validation (Component-Scoped)**:
```yaml
# Skill with PostToolUse validation
hooks:
  PostToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: "validate-syntax.sh"
```

## Hook Events Quick Reference

### Complete Event List (13 Events)

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

**For detailed documentation**: See [events.md](references/events.md)

## Hook Types

### Key Distinction
- **Prompt Hooks** (LLM-based): Only for Stop, SubagentStop events
- **Command Hooks** (bash-based): All events, fast and deterministic

### Quick Examples

**Prompt Hook Example**:
```json
{
  "Stop": [{
    "hooks": [{
      "type": "prompt",
      "prompt": "Review this response for quality, clarity, and completeness."
    }]
  }]
}
```

**Command Hook Example**:
```json
{
  "PreToolUse": [{
    "matcher": "Write",
    "hooks": [{
      "type": "command",
      "command": "validate-file.sh"
    }]
  }]
}
```

**Exit Codes**:
- `0`: Success
- `1`: Non-blocking error
- `2`: Blocking error

**For detailed patterns and examples**: [implementation-patterns.md](references/implementation-patterns.md)
- Complete guardrail patterns
- Security templates
- Configuration examples
- Component-scoped patterns
- Delegation handling

## Implementation Guidance

### For complete examples and templates**: [examples.md](references/examples.md)
- Step-by-step process
- Configuration templates
- Best practices checklist
- Troubleshooting guide

### For session persistence**: [session-persistence.md](references/session-persistence.md)
- State management patterns
- Hook configuration examples
- Integration patterns

### For advanced patterns**: [implementation-patterns.md](references/implementation-patterns.md)
- Multi-hook chains
- Conditional hooks
- Error handling strategies
- Performance optimization

## When to Use Hooks

**Use Hooks When**:
- ✅ Need to prevent dangerous operations
- ✅ Want automated validation before actions
- ✅ Need to persist development decisions
- ✅ Want project-specific security guardrails

**Don't Use Hooks When**:
- ❌ Need user interaction (use skills instead)
- ❌ Complex logic (use skills instead)
- ❌ Temporary needs (use commands instead)

## Delegation Patterns

**When responding to hooks-architect delegations**: [implementation-patterns.md](references/implementation-patterns.md)
- Hook configuration guidance
- Security assessment patterns
- Component-scoped patterns
- Global hook patterns
