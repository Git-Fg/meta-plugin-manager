# Architecture Philosophy

## Skills-First Architecture

Every capability should be a Skill first. Commands and Subagents are orchestrators, not creators.

**Reference**: [toolkit-architect/SKILL.md](skills/toolkit-architect/SKILL.md)

### Router Logic (from toolkit-architect/SKILL.md)
1. Validate: User's project has .claude/ directory
2. Determine component type:
   - "I need a skill" → Route to skills-architect
   - "I want web search" → Route to mcp-architect
   - "I need hooks" → Route to hooks-architect
3. Scan existing structure: `ls -la .claude/` to see what exists
4. Check for existing components in skills/, agents/, settings.json, hooks.json

## Hub-and-Spoke Pattern

Hub Skills (routers with disable-model-invocation: true) delegate to knowledge skills. Prevents context rot.

**CRITICAL**: For hub to aggregate results, ALL delegate skills MUST use `context: fork`. Regular skill handoffs are one-way only.

**See**: [CLAUDE.md](../../CLAUDE.md) for complete hub-and-spoke pattern documentation and test validation results.

## Progressive Disclosure

**See**: [CLAUDE.md](../../CLAUDE.md) for complete Progressive Disclosure documentation (Tier 1/2/3 structure, line count rules, implementation guidance).

## Prompt Efficiency

Minimize API call count ("prompts" = one request + all tool calls). Critical for subscription providers with limited prompts (e.g., 150 prompts/5h plans).

- Skills consume 1 prompt
- Subagents consume multiple prompts

**Prefer skills over subagents when both achieve the same result.**

## Component Patterns

**Reference**: [toolkit-architect/references/component-patterns.md](skills/toolkit-architect/references/component-patterns.md)

### Project Structure
```
.claude/
├── skills/                      # Skills are PRIMARY building blocks
│   └── skill-name/
│       ├── SKILL.md            # <500 lines (Tier 2)
│       └── references/          # On-demand (Tier 3)
├── agents/                      # Context fork isolation
├── hooks/                       # Event automation
├── commands/                     # Legacy: manual workflows
├── settings.json                # Project-wide hooks & configuration
├── settings.local.json          # Local overrides (gitignored)
└── .mcp.json                   # MCP server configuration
```

### Plugin Manifest (plugin.json)
Required fields:
```json
{
  "name": "plugin-name"  # kebab-case format
}
```

**Name requirements:**
- Use kebab-case format (lowercase with hyphens)
- Must be unique across installed plugins
- Example: `code-review-assistant`, `test-runner`
