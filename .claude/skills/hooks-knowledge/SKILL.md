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

## Core Philosophy: Project-First Hooks

**This skill teaches the "Project Scaffolding & Guardrails" approach:**

1. **Zero Active Hooks in Toolkit**: The toolkit contains NO active hooks for users
2. **Templates, Not Execution**: Provides templates and patterns, not active configuration
3. **Project-Local Configuration**: All hooks belong in user's `.claude/` directory
4. **Component-Scoped First**: Prefer hooks in skill/agent frontmatter over global hooks
5. **Fail Fast Principle**: Use command hooks with `exit 2` for immediate blocking
6. **User Empowerment**: Users create their own guardrails, toolkit guides them

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
- **Local Configuration**: All hooks in your `.claude/hooks.json`
- **Component-Scoped**: Hooks in skill/agent frontmatter (preferred)
- **Fail Fast**: Use `exit 2` to block dangerous operations
- **Templates**: Use provided templates, customize for your project

## Project-Scoped Hook Configuration

**Two Levels for Your Local Project**:

### 1. Global Hooks (`.claude/hooks.json`)
**Target**: `${CLAUDE_PROJECT_DIR}/.claude/hooks.json`

Use for project-wide automation and infrastructure guardrails:

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

### 2. Component-Scoped Hooks (Skill/Agent Frontmatter)
**Target**: `hooks:` block in YAML frontmatter

Use for skill-specific validation and security:

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

**Best Practice**: Prefer component-scoped hooks to avoid "always-on" noise. Only use global hooks for project-wide guardrails.

**Configuration Location**: Your project's `.claude/hooks.json` (global) or inline frontmatter (component-scoped)

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

## Additional Resources

- **Hooks Guide**: https://code.claude.com/docs/en/hooks
- **Security Guide**: https://code.claude.com/docs/en/security
- **Plugin Structure**: https://code.claude.com/docs/en/plugins

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
