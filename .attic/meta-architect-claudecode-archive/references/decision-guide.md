# Layer Decision Guide

## Quick Decision Tree

```
Need persistent norms? → CLAUDE.md rules
Need domain expertise? → Skill
  Simple task? → Skill (regular)
  Complex workflow? → Skill (context: fork)
Need explicit workflow? → Command
Need isolation/parallelism? → Subagent
```

## Layer Comparison

| Layer | Purpose | Trigger | Scope |
|-------|---------|---------|-------|
| **Rules** | Persistent norms | Always active | Project-wide |
| **Skills** | Domain expertise | Auto-discovered | Specific domain |
| **Commands** | Explicit control | Manual /trigger | User-controlled |
| **Subagents** | Isolation/parallelism | Code execution | Noisy tasks |

## Rules Guidelines

**Use for**:
- Coding standards
- Safety boundaries
- Project conventions
- Architecture principles

**File locations**:
- `~/.claude/CLAUDE.md` - Global (universal only)
- `{project}/CLAUDE.md` - Project-specific
- `{project}/.claude/rules/*.md` - Modular sets

**Structure**:
- Specific, actionable rules
- Include context/why
- Clear safety boundaries
- <500 lines ideal

## Skills Guidelines

**Use for**:
- Domain expertise to discover
- Rich workflows with files
- Progressive disclosure

**Types**:
- Auto-discoverable (default)
- User-triggered (disable-model-invocation: true)
- Background context (user-invocable: false)

**Structure**:
- SKILL.md <500 lines
- References on-demand
- Commander's Intent, not instruction manuals

## Commands Guidelines

**Use for**:
- Explicit user control
- Strict tool constraints
- Destructive operations
- Costly/long operations

**Creation criteria** (at least one):
- User control required (deployments, releases)
- Tool constraints strict (read-only review)
- Stable entrypoint needed ("Run tests")
- Operation is costly/long

**Best practice**: Thin wrapper activating a Skill

## Subagents Guidelines

**Use for**:
- High-volume output
- Strict tool isolation
- Cheaper model routing (Haiku)
- Parallel execution
- Context rot prevention

**Types**:
- Explore - Fast exploration, read-only
- Plan - Architecture planning
- general-purpose - Multi-step tasks
- Bash - Shell operations only

**Best practice**: Minimize spawns, pass context explicitly

## Anti-Patterns

### Rules
- Vague rules ("write clean code")
- Global capture (project rules in global)
- Style over-prescription

### Skills
- Tutorial content (explaining basics)
- Over-engineering (too many files)
- Missing progressive disclosure

### Commands
- Creating when skill suffices
- Vague descriptions
- Over-constraining tools

### Subagents
- Over-isolation (simple tasks)
- Context starvation (no context passed)
- Orchestration complexity
