# CLAUDE.md

Project scaffolding toolkit for Claude Code focused on .claude/ configuration with skills-first architecture and progressive disclosure.

## Critical Gotchas

⚠️ **Context Fork Brittleness**: Skill chains >2 levels accumulate noise. Use hub-and-spoke: hub routes to knowledge skills, never chain >2 deep.

⚠️ **Progressive Disclosure**: Create references/ only when SKILL.md + references >500 lines total. Under 500? Merge into single SKILL.md.

⚠️ **Global Hooks**: Plugin-level hooks stay active when enabled. Prefer component-scoped hooks in skill/agent frontmatter for auto-cleanup.

⚠️ **Quality Gate**: All skills must score ≥80/100 on 11-dimensional framework before production.

⚠️ **Empty Scaffolding**: Remove directories with no content immediately. Creates technical debt.

⚠️ **URL Staleness**: Documentation URLs change. Always verify with mcp__simplewebfetch__simpleWebFetch before implementation.

⚠️ **Delta Standard**: Remove Claude-obvious content. Keep only: working commands, non-obvious gotchas, architecture decisions, "NEVER do X because [specific reason]"

⚠️ **Auto-Discovery**: Claude auto-discovers skills via description keywords. No need for command wrappers.

⚠️ **Context Fork Requirements**: Always inject dynamic context for subagent execution. Forked contexts don't inherit conversation history.

⚠️ **URL Fetching**: Knowledge skills MUST include mandatory URL fetching sections with mcp__simplewebfetch__simpleWebFetch and 15-minute cache minimum.

## Subagent Configuration

**Subagents** (`.claude/agents/*.md`) are **different from skills with `context: fork`**. Common confusion leads to incorrect YAML fields.

### Correct Subagent Fields
```yaml
---
name: my-agent              # Required: unique ID
description: "Does X when Y" # Required: when to delegate
tools:                       # Optional: tool restrictions
  - Read
  - Grep
  - Glob
disallowedTools:             # Optional: denied tools
  - Write
  - Edit
model: inherit              # Optional: sonnet/opus/haiku/inherit
permissionMode: default      # Optional: permission handling
skills:                     # Optional: inject skill content
  - skills-knowledge
hooks:                      # Optional: lifecycle hooks
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate.sh"
---
```

### Invalid Fields (Don't Use)
- ❌ `context: fork` - This is for **skills**, not subagents
- ❌ `agent: Explore` - This field **doesn't exist** for subagents
- ❌ `user-invocable` - Subagents aren't skills
- ❌ `disable-model-invocation` - For skills, not subagents

### Context Detection
Determine subagent location based on scope:
- **Project-level**: `${CLAUDE_PROJECT_DIR}/.claude/agents/`
- **Plugin-level**: `<plugin>/agents/` (for distribution)
- **User-level**: `~/.claude/agents/` (all projects)

### Common Mistake
Using subagents-architect incorrectly suggested `agent:` and `context: fork` for subagents. These fields apply to **skills** that delegate TO subagents, not the subagents themselves.

## Skill Portability

**Default to portable skills**: Create skills usable across any Agent Skills-compatible product.

**Claude Code Extensions** (use ONLY in `.claude/skills/` or plugin contexts with `.claude-plugin`/`plugin.json`):
- `context: fork` - Runs skill in isolated subagent context
- `agent: <name>` - Specifies agent type for execution  
- `user-invocable: false` - Hides from slash command menu
- `hooks` in frontmatter - Lifecycle event bindings

⚠️ **`disable-model-invocation` Anti-Pattern**: Turns skills into "pure commands"—rigid, manually-triggered workflows. **Pure commands are an anti-pattern for skills.** A well-crafted description usually suffices. Reserve for genuinely destructive operations (deploy, delete, send) where user timing is critical.

## Project Structure

```
.claude/
├── skills/                      # Skills are PRIMARY building blocks
│   └── skill-name/
│       ├── SKILL.md            # <500 lines (Tier 2)
│       └── references/          # On-demand (Tier 3)
├── agents/                      # Context fork isolation
├── hooks/                       # Event automation (component-scoped preferred)
├── commands/                     # Legacy: manual workflows
└── .mcp.json                   # MCP server configuration
```

## Layer Selection

```
Need persistent norms? → CLAUDE.md rules
Need domain expertise? → Skill (user-invocable: true)
  Simple task? → Skill (regular)
  Complex workflow? → Skill (context: fork)
Need explicit workflow? → Command (disable-model-invocation: true)
Need isolation/parallelism? → Subagent
```

## Architecture Philosophy

**Skills-First**: Every capability should be a Skill first. Commands and Subagents are orchestrators, not creators.

**Hub-and-Spoke**: Hub Skills (routers with disable-model-invocation: true) delegate to knowledge skills. Prevents context rot.

**Progressive Disclosure**:
1. Tier 1 (~100 tokens): YAML frontmatter - always loaded
2. Tier 2 (<500 lines): SKILL.md - loaded on activation
3. Tier 3 (on-demand): references/ - loaded when needed

**Prompt Efficiency**: Minimize API call count ("prompts" = one request + all tool calls). Critical for subscription providers with limited prompts (e.g., 150 prompts/5h plans). Skills consume 1 prompt; subagents consume multiple. **Prefer skills over subagents when both achieve the same result.**

## 11-Dimensional Quality Framework

Skills must score ≥80/100:
1. Knowledge Delta (10) - Expert-only vs Claude-obvious
2. Autonomy (10) - 80-95% completion without questions
3. Discoverability (10) - Clear description with triggers
4. Progressive Disclosure (10) - Tier 1/2/3 properly organized
5. Clarity (10) - Unambiguous instructions
6. Completeness (10) - Covers all scenarios
7. Standards Compliance (10) - Follows Agent Skills spec
8. Security (10) - Validation, safe execution
9. Performance (10) - Efficient workflows
10. Maintainability (5) - Well-structured
11. Innovation (5) - Unique value

## Common Anti-Patterns

**Architectural**:
- Command wrapper (Skills that just invoke commands)
- Linear chain brittleness (long reasoning chains)
- Non-self-sufficient Skills
- Empty scaffolding

**Documentation**:
- Stale URLs
- Missing URL sections in knowledge skills
- Drift (same concept in multiple places)

**Operational**:
- Global hooks for component concerns
- Prompt hooks for PreToolUse (use command hooks)
- Missing quality gates

## When in Doubt

**Most customization needs** met by CLAUDE.md + one Skill.

**Build from skills up** - Every capability should be a Skill first. Commands and Subagents are orchestrators, not creators.

**Reference**: Official docs at https://agentskills.io/home
