# Architect Skills Archive - v4 Migration

**Archive Date**: 2026-01-24
**Archive ID**: architect-skills-archive-20260124-215940

## Migration Mapping

This archive contains the original v3 "architect skills" that have been separated into:

| Archived Skill | Knowledge Component | Factory Component |
|----------------|---------------------|-------------------|
| skill-architect | knowledge-skills | create-skill |
| mcp-architect | knowledge-mcp | create-mcp-server |
| hooks-architect | knowledge-hooks | create-hook |
| subagents-architect | knowledge-subagents | create-subagent |
| toolkit-creator | (distributed) | create-*, create-mcp-server |

## Contents

### skill-architect
**Original Purpose**: Build self-sufficient skills following Agent Skills standard
**Knowledge Extracted**: Delta Standard, Progressive Disclosure, Quality Framework, Anti-patterns
**Execution Logic Moved to**: create-skill factory skill

### mcp-architect
**Original Purpose**: Integrate external APIs via Model Context Protocol
**Knowledge Extracted**: MCP protocol, transports, primitives, integration patterns
**Execution Logic Moved to**: create-mcp-server factory skill

### hooks-architect
**Original Purpose**: Configure project guardrails in .claude/ configuration
**Knowledge Extracted**: Hook events, security patterns, exit codes, configuration types
**Execution Logic Moved to**: create-hook factory skill

### subagents-architect
**Original Purpose**: Creates, audits, and refines subagent files
**Knowledge Extracted**: Agent types, frontmatter fields, context detection, coordination patterns
**Execution Logic Moved to**: create-subagent factory skill

### toolkit-creator
**Original Purpose**: Create new project capabilities (skills, MCP servers, hooks, subagents)
**Status**: Replaced by dedicated factory skills with script-based execution

## Reference Only

**Do not modify** this archive. Use the new v4 skills instead:
- `knowledge-skills`, `knowledge-mcp`, `knowledge-hooks`, `knowledge-subagents`
- `create-skill`, `create-mcp-server`, `create-hook`, `create-subagent`

## Recovery

If you need to reference the original implementation:
- Knowledge content is available in the `references/` subdirectories
- SKILL.md files contain the original combined approach
- Use this for understanding the migration decisions, not for active development
