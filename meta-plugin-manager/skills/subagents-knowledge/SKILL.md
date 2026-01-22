---
name: subagents-knowledge
description: "Complete guide to subagents for specialized autonomous workers in Claude Code. Use when deciding when to use subagents or coordinating multiple subagents. Do not use for simple file operations or basic workflow tasks."
user-invocable: true
---

# Subagents Knowledge Base

Complete subagents knowledge base for Claude Code. Access comprehensive guidance on when to use subagents and how to coordinate multiple subagents effectively.

## 🚨 MANDATORY: Read BEFORE Using Subagents

**CRITICAL**: You MUST read and understand these URLs:

### Primary Documentation (MUST READ)
- **[MUST READ] Official Subagents Guide**: https://code.claude.com/docs/en/sub-agents
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **When to Read**: Before any subagent creation
  - **Content**: Agent coordination, state management, autonomy requirements
  - **Cache**: 15 minutes minimum

- **[MUST READ] Task Tool Documentation**: https://code.claude.com/docs/en/cli-reference
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **When to Read**: Before using Task tool to invoke subagents
  - **Content**: Task tool usage, subagent types, invocation patterns
  - **Cache**: 15 minutes minimum

### ⚠️ BLOCKING RULES
- **DO NOT proceed** without understanding when subagents are appropriate
- **MUST validate** need for isolation before using subagents
- **REQUIRED** to understand cost implications

## Progressive Disclosure Knowledge Base

This skill provides complete subagents knowledge through progressive disclosure:

### Tier 1: Quick Overview
This SKILL.md provides the decision framework and quick reference.

### Tier 2: Comprehensive Guides
Load full guides on demand:
- **[when-to-use.md](references/when-to-use.md)** - Decision guide for when to use subagents
- **[coordination.md](references/coordination.md)** - Coordination patterns and state management

### Tier 3: Deep Reference
Individual reference files provide complete implementation details.

## Quick Start

### New to Subagents?
Start with **[when-to-use.md](references/when-to-use.md)** to determine if subagents are right for your use case.

### Coordinating Multiple Subagents?
See **[coordination.md](references/coordination.md)** for coordination patterns and state management strategies.

## Subagent Types Quick Reference

| Agent Type | Purpose | When to Use |
| ---------- | ------- | ----------- |
| **Explore** | Fast codebase exploration | File searches, pattern discovery, code analysis |
| **Plan** | Architecture planning | Implementation strategy, breaking down tasks |
| **General-Purpose** | Full capabilities | Complex workflows, research + execution |
| **Bash** | Command execution | Git operations, terminal tasks |

## Context: Fork Scenarios (2026)

Use `context: fork` when:
- **High-volume output**: Extensive grep, repo traversal, large log analysis
- **Noisy exploration**: Multi-file searches, deep code analysis
- **Isolation benefits**: Separate context window, clean result handoff

## Cost Considerations (2026)

### Budget Targets
- **Target**: <$50 per 5-hour session
- **Warning**: >$75 per 5-hour session
- **Critical**: >$100 per 5-hour session

### Optimization Strategies
1. Use native tools when possible
2. Limit parallel subagent spawns
3. Keep tasks focused and specific
4. Use context: fork judiciously

## Layer Selection Decision

```
Need specialized autonomous workers?
├─ Yes → Use subagents
│  ├─ Decision guide → [when-to-use.md](references/when-to-use.md)
│  └─ Coordination patterns → [coordination.md](references/coordination.md)
└─ No → Use skills or native tools
```

## Key Principles

### Use Subagents When
- Complex multi-step tasks requiring focus
- Need isolation from main conversation
- High-volume output (extensive grep, repo traversal)
- Noisy exploration that would clutter conversation
- Parallel execution needed
- Long-running tasks
- Domain-specific expertise required

### Don't Use Subagents For
- Simple file operations (use Read, Grep, Glob)
- Direct file reads (use Read tool)
- Basic searches (use Grep, Glob)
- Single-step operations
- Tasks requiring conversation context
- User interaction workflows
- Quick lookups

## Next Steps

Choose your path:

1. **[Determine if subagents are needed](references/when-to-use.md)** - Decision framework
2. **[Coordinate multiple subagents](references/coordination.md)** - Patterns and state management
3. **Review layer selection** - Consider if skills would be more appropriate
