---
name: hooks-knowledge
context: fork
description: "Create event-driven automation and validation hooks in your local project. Use for file validation, security guardrails, pre-tool checks, and project automation. Templates for PreToolUse, PostToolUse, and component-scoped hooks. Triggers: 'add validation hook', 'file security', 'prevent dangerous operations', 'automated checks', 'PreToolUse validation', 'guardrails setup'."
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

Reference library for creating project-scoped hooks automation and guardrails in your local `.claude/` directory.

## Core Philosophy: Local Project Autonomy

**This skill teaches the "Project-First Hooks" approach:**

1. **Local Project Default**: Always create hooks in your project's `.claude/` directory
2. **Trust AI Intelligence**: Provide concepts, let AI make intelligent decisions
3. **Autonomous Execution**: Skills work without user interaction
4. **Minimal Prescriptiveness**: Focus on principles, not rigid templates
5. **Clean Architecture**: No deprecated patterns or legacy knowledge

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
- **Local Configuration**: Hooks in your project's `.claude/` directory
- **Component-Scoped**: Hooks in skill/agent frontmatter (preferred for auto-cleanup)
- **Settings Files**: Use `.claude/settings.json` for team collaboration
- **Fail Fast**: Use `exit 2` to block dangerous operations
- **Trust AI**: Provide concepts, AI handles implementation details

## Project Configuration

### Local Project Settings (Default)
Create hooks in your project directory:

**Configuration**: `.claude/settings.json`
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
For skill-specific automation:

```yaml
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./.claude/scripts/security-check.sh"
          once: true
```

## Hook Events Overview

### Essential Events
- **PreToolUse**: Before tool execution (validation, security)
- **PostToolUse**: After tool succeeds (logging, cleanup)
- **Stop**: Claude finishes responding (final validation)

### Lifecycle Events
- **SessionStart**: Session begins (environment setup)
- **SessionEnd**: Session terminates (cleanup)
- **UserPromptSubmit**: User submits prompt (validation)

## Implementation Guidance

### Configuration Structure
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

### Key Concepts

**Matchers**: Target specific tools or patterns
- `"Write"` - Exact match
- `"Write|Edit"` - Multiple tools
- `"Bash"` - Shell commands
- `"*.env*"` - File patterns

**Hook Types**:
- `command`: Bash script execution
- `prompt`: LLM-based evaluation (for Stop/SubagentStop)

**Exit Codes**:
- `0`: Success, operation allowed
- `1`: Warning, operation allowed
- `2`: Blocking error, operation denied

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

## Best Practices

### Trust AI Intelligence
- Provide concepts and examples
- Let AI make implementation decisions
- Focus on principles, not prescriptive patterns

### Local Project Approach
- Create hooks in your project directory
- Use component-scoped hooks for auto-cleanup
- Trust AI to choose appropriate scope

### Performance Considerations
- Keep scripts fast (<100ms)
- Use specific matchers, not broad patterns
- Avoid expensive operations in hooks

## For Complete Implementation Patterns

See [implementation-patterns.md](references/implementation-patterns.md):
- Core validation patterns
- Security guardrails
- Configuration examples
- Testing approaches

## TaskList Coordination for Complex Hook Workflows

For multi-hook validation projects requiring task tracking, see **task-knowledge**:

- Multi-session hook validation workflows
- Complex remediation coordination with dependencies
- Parallel security validation across components
- Session-persistent hook development tracking

**When to use TaskList for hooks**:
- Multi-hook validation pipelines (5+ hooks to validate)
- Complex validation workflows with dependencies
- Session-spanning hook configuration projects
- Multi-phase validation requiring coordination

**Integration Pattern**:
Use TaskCreate to establish validation tasks, then configure parallel validation phases that depend on scan completion, followed by report generation tasks that wait for all validations to complete.

See **[task-architect](task-architect/)** for complete TaskList orchestration patterns and **[hooks-architect](hooks-architect/)** for hook-specific workflow implementations.

## Delegation Patterns

**When responding to hooks-architect delegations**:
- Provide implementation guidance based on project context
- Focus on local project autonomy
- Trust AI to make intelligent configuration decisions
- Emphasize concepts over prescriptive patterns
