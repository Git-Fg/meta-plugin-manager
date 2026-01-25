# Subagent Decision Guide

When to use subagents vs native tools.

## Decision Matrix

| Need | Use Subagent? | Alternative |
|------|---------------|-------------|
| Complex codebase analysis | ✅ Yes | - |
| Simple file read | ❌ No | Read tool |
| High-volume grep | ✅ Yes | - |
| Single file operation | ❌ No | Native tools |
| Isolated context needed | ✅ Yes | - |
| User-interactive task | ❌ No | Regular workflow |

## Decision Tree

```
START: What do you need?
│
├─ Simple file operation?
│  └─→ Use native tools (Read, Grep, Glob)
│
├─ Complex multi-step task?
│  ├─ Need isolation?
│  │  └─→ Use subagent (context: fork)
│  └─ Inline OK?
│     └─→ Use skill
│
├─ High-volume output?
│  └─→ Use subagent (context: fork)
│
├─ Domain expertise?
│  └─→ Use skill
│
└─ User-triggered workflow?
   └─→ Use command or skill
```

## ✅ Use Subagents When

- Complex multi-step tasks requiring focus
- Need isolation from main conversation
- High-volume output (extensive grep, repo traversal)
- Noisy exploration that clutters conversation
- Parallel execution needed
- Long-running tasks

## ❌ Don't Use Subagents For

- Simple file operations → Use Read, Grep, Glob
- Single-step operations → Use native tools
- Tasks requiring conversation context
- User interaction workflows
- Quick lookups

## Agent Type Selection

| Type | Purpose | Use When |
|------|---------|----------|
| **Explore** | Fast codebase navigation | Quick search, read-only analysis |
| **Plan** | Architecture design | Complex reasoning, design decisions |
| **Bash** | Command execution | Shell workflows, git operations |
| **general-purpose** | Full capabilities | No specific specialization needed |

## Context: Fork Triggers

Use `context: fork` when:
- High-volume output (full codebase traversal)
- Noisy exploration (multi-file searches)
- Separate context window needed
- Clean result handoff required

## Cost Awareness

- Subagents consume tokens for new context + execution
- Use `haiku` for simple tasks
- Limit parallel spawns
- Prefer native tools when possible
