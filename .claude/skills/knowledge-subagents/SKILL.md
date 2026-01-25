---
name: knowledge-subagents
description: Reference for Agent Types, Contexts, and Coordination. Use to understand subagent architecture before creating them. For execution, use create-subagent.
user-invocable: false
---

# Knowledge: Subagents

Reference knowledge for Claude Code subagents. **For execution (creating agents), use `create-subagent`**.

## 1. Core Concepts

### Agent Types

| Type | Use Case |
|------|----------|
| **general-purpose** | Default. Full toolkit access. |
| **bash** | Shell/Script execution specialist. |
| **explore** | Fast navigation (ReadOnly). |
| **plan** | Architecture & complex reasoning (Opus). |

### Context & Location

| Context | Path | Use When |
|---------|------|----------|
| **Project** | `.claude/agents/` | Logic specific to THIS project. |
| **Plugin** | `plugin/agents/` | Logic shared across multiple projects. |
| **User** | `~/.claude/agents/` | Personal automation. |

## 2. Configuration & Reference

**Detailed Guides:**

- **Configuration**: [configuration-guide.md](references/configuration-guide.md) (Full Frontmatter API)
- **Validation**: [validation-framework.md](references/validation-framework.md) (Quality Scoring >80%)
- **When to Use**: [when-to-use.md](references/when-to-use.md) (Decision Matrix)

### Critical Rules

1. **Never** use `context: fork` in subagents (Skills only).
2. **Never** use `user-invocable` (Subagents are tools).
3. **Always** define explicit `tools` (Allowlist) or `disallowedTools` (Denylist).

### Frontmatter Quick Reference

```yaml
---
name: agent-name              # Required
description: Purpose          # Required
model: sonnet                 # Optional: haiku | sonnet | opus
tools:                        # Optional: Allowlist
  - Bash
  - Read
disallowedTools:              # Optional: Denylist
  - Write
  - Edit
permissionMode: default       # Optional
skills:                       # Optional: Inject skill content
  - skill-name
---
```

## 3. Coordination Patterns

**Full Patterns**: [coordination-patterns.md](references/coordination-patterns.md) | [coordination.md](references/coordination.md)

| Pattern | Description |
|---------|-------------|
| **Hub-and-Spoke** | Main agent delegates to specialized workers. |
| **Sequential** | Chain: Architect → Coder → Reviewer. |
| **Parallel** | Multiple isolated agents for speed. |

## 4. Context Detection

Automatic detection based on file location. See [context-detection.md](references/context-detection.md).

```
.claude-plugin/plugin.json exists → Plugin context
.claude/agents/ exists           → Project context
~/.claude/agents/ exists         → User context
```
