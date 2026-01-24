---
name: create-subagent
description: "Create subagent files in .claude/agents/. Use when adding specialized agents. Arguments: name, description, type, tools."
user-invocable: true
---

# Create Subagent

Creates subagent configuration files with proper frontmatter.

## Usage

```bash
Skill("create-subagent", args="name=my-agent description='Specialized task' type=general-purpose tools=Bash,Read")
```

### Arguments

| Argument | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `name` | string | Yes | - | Agent name (kebab-case) |
| `description` | string | Yes | - | Agent purpose |
| `type` | string | No | general-purpose | Agent type: general-purpose/bash/explore/plan |
| `model` | string | No | sonnet | Model: haiku/sonnet/opus |
| `tools` | string | No | - | Comma-separated tool allowlist |
| `disallowedTools` | string | No | - | Comma-separated tool denylist |
| `context` | string | No | auto | Context: project/plugin/user/auto |

## Agent Types

| Type | Tools | Purpose | Use When |
|------|-------|---------|----------|
| **general-purpose** | All tools | Default, full capability | Most tasks |
| **bash** | Bash only | Command execution | Shell workflows |
| **explore** | All except Task | Fast exploration | Quick navigation |
| **plan** | All except Task | Architecture design | Complex decisions |

## Context Types

| Context | Location | Scope |
|---------|----------|-------|
| **project** | `.claude/agents/` | Current project only |
| **plugin** | `plugin/agents/` | Where plugin is enabled |
| **user** | `~/.claude/agents/` | All projects |
| **auto** | Auto-detected | Based on directory structure |

## Output

Creates `.claude/agents/<name>.md` with:
- Valid YAML frontmatter
- Only valid fields (no `context: fork` or `agent:` for subagents)
- Proper tool restrictions
- Template system prompt

## Scripts

- **create_agent.sh**: Create agent file
- **validate_agent.sh**: Validate frontmatter
- **detect_context.sh**: Detect project/plugin/user context

## Completion Marker

## CREATE_SUBAGENT_COMPLETE
