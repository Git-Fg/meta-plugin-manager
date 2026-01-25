---
name: knowledge-subagents
description: "Subagent architecture knowledge: types, frontmatter fields, context detection, coordination patterns. Use when understanding agents or designing workflows. For creating agents, use create-subagent factory."
user-invocable: false
---

# Knowledge: Subagents

Subagents are **isolated workers** that execute tasks in a separate context window. They exist to prevent conversation pollution when tasks produce high-volume output or require dedicated focus.

**Think of subagents as specialist consultants** - you bring them in when their specific expertise is needed, and they work in their own dedicated space.

**For creating agents**: Use the `create-subagent` factory skill.

## Core Principle: The Clutter Test

> **"Would this task clutter the conversation?"**

- **Yes** → Spawn a subagent
- **No** → Use native tools (Read, Grep, Bash)

**Why it matters**: Subagent overhead (new context + initialization) is only justified when isolation provides value. If a task won't clutter the conversation, the overhead isn't worth it.

## When to Use Subagents

**Use subagents for**:
- High-volume output (extensive grep, repo traversal)
- Noisy exploration that clutters conversation
- Tasks requiring separate context window
- Specialized expertise (analysis, review, testing)

**Don't use subagents for**:
- Simple tasks (use native tools directly)
- Tasks that need conversation history
- Low-volume operations

## Anatomy of a Subagent

Subagents are `.md` files with YAML frontmatter:

```yaml
---
name: code-analyzer                    # Required: unique identifier
description: "Analyze code when..."    # Required: when to delegate
model: haiku                           # Optional: haiku | sonnet | opus
disallowedTools:                       # Optional: restrict capabilities
  - Write
  - Edit
---

# Body: Instructions for the subagent
Analyze the codebase for patterns...
```

**Location determines scope:**

| Path | Scope |
|------|-------|
| `.claude/agents/` | This project only |
| `plugin/agents/` | All projects using this plugin |
| `~/.claude/agents/` | Personal (all projects) |

## Agent Types

| Type | Tools | Use When |
|------|-------|----------|
| **general-purpose** | All | Default, no specialization needed |
| **explore** | Read-only | Fast search, codebase navigation |
| **plan** | All except Task | Architecture design, complex reasoning |
| **bash** | Bash only | Shell workflows, git operations |

## Configuration Essentials

### Required Fields

```yaml
name: unique-hyphenated-name
description: "Purpose when situation. Use for specific tasks."
```

### Tool Restriction (Choose ONE)

```yaml
# Allowlist: ONLY these tools
tools:
  - Read
  - Grep

# OR Denylist: ALL tools EXCEPT these
disallowedTools:
  - Write
  - Edit
```

### Critical Rules

1. **Never** use `context: fork` (Skills only)
2. **Never** use `user-invocable` (Subagents aren't user-invocable)
3. **Always** restrict tools appropriately

**Full API**: See [configuration-guide.md](references/configuration-guide.md)

## Coordination Patterns

When orchestrating multiple subagents:

| Pattern | Use When |
|---------|----------|
| **Hub-and-Spoke** | Central coordinator delegates to specialists |
| **Pipeline** | Sequential: A → B → C |
| **Parallel** | Independent tasks, combine results |

**Full Patterns**: See [coordination.md](references/coordination.md)

## Quality Gate

Subagents should score ≥80/100 on validation. Key dimensions:

- Configuration validity (valid YAML, required fields)
- Tool restrictions (appropriate allow/deny)
- Documentation quality (clear description with trigger)

**Validation Details**: See [validation-framework.md](references/validation-framework.md)
