# Contributing Guide

## Project Overview

TheCatToolkit v3 is a CLAUDE.md plugin toolkit with MCP (Model Context Protocol) servers and Claude Code components.

## Available MCP Servers

| Server               | Location                           | Description                             |
| -------------------- | ---------------------------------- | --------------------------------------- |
| mcp-llm-orchestrator | `Custom_MCP/mcp-llm-orchestrator/` | Perplexity and Gemini LLM orchestration |
| simpleWebFetch       | `Custom_MCP/simpleWebFetch/`       | Web fetching and crawling               |

## Development Setup

### MCP Server: mcp-llm-orchestrator

```bash
cd Custom_MCP/mcp-llm-orchestrator

# Install dependencies
pnpm install

# Development
pnpm run dev          # Run with ts-node
pnpm run build        # Compile TypeScript
pnpm run start        # Run compiled JavaScript
pnpm run test         # Run test suite (bash script)
pnpm run test:e2e     # Run end-to-end tests
```

### MCP Server: simpleWebFetch

```bash
cd Custom_MCP/simpleWebFetch

# Install dependencies
pnpm install

# Development
pnpm run dev          # Run with tsx
pnpm run build        # Compile TypeScript
pnpm run start        # Run compiled JavaScript
pnpm run test         # Run server tests
pnpm run test:suite   # Run test suite
```

## CLAUDE.md Components

Located in `.claude/`:

| Component   | Purpose                                      |
| ----------- | -------------------------------------------- |
| `skills/`   | Domain knowledge with progressive disclosure |
| `commands/` | Intent aliases and shortcuts                 |
| `agents/`   | Autonomous workers                           |
| `rules/`    | Behavioral principles and architecture       |

## Component Structure

**Skill structure:**

```
.claude/skills/{skill-name}/
├── SKILL.md           # Full philosophy (Tier 2)
└── references/        # Ultra-situational lookup (Tier 3)
```

**Command structure:**

```
.claude/commands/{command}.md
```

## Testing

- **mcp-llm-orchestrator**: `bash scripts/test-tools.sh`
- **simpleWebFetch**: `tsx src/test-suite.ts`

## Build Commands

```bash
# Build MCP servers
cd Custom_MCP/mcp-llm-orchestrator && pnpm run build
cd Custom_MCP/simpleWebFetch && pnpm run build
```

## Adding New Components

Use `/create` command to scaffold new skills, commands, or agents.

---

**Reference**: See CLAUDE.md for complete project documentation.
