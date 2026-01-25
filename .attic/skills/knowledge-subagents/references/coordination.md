# Subagent Coordination Patterns

Multi-agent orchestration patterns and state management.

## Pattern Summary

| Pattern | Use Case | State | Complexity |
|---------|----------|-------|------------|
| **Hub-and-Spoke** | Central coordinator delegates to specialists | Shared | Medium |
| **Pipeline** | Sequential processing (A → B → C) | Message chain | Low |
| **Parallel** | Independent concurrent tasks | Minimal | Medium |
| **Handoff** | Context transfer to specialist | Transfer | Low |

## Pattern 1: Hub-and-Spoke

Central coordinator delegates to specialists.

```
[Hub Agent]
  ├── Specialist Agent 1
  ├── Specialist Agent 2
  └── Specialist Agent 3
```

**Example**: Deployment orchestrator delegates to build, test, deploy agents.

## Pattern 2: Pipeline

Sequential data transformation.

```
[Agent A] → [Agent B] → [Agent C] → Result
```

**Example**: Code review: scan → analyze → report.

## Pattern 3: Parallel

Independent concurrent execution.

```
[Agent 1] ←→ [Coordinator]
[Agent 2] ←→ [Coordinator]
[Agent 3] ←→ [Coordinator]
        ↓
    [Combine]
```

**Example**: Analyze frontend, backend, database simultaneously.

## Pattern 4: Handoff

Context transfer to specialist.

1. Prepare context
2. Handoff to specialist
3. Receive results
4. Continue workflow

## Context: Fork Mechanism

**CRITICAL**: In `context: fork`, the Skill's SKILL.md becomes the task prompt. If using a custom subagent with `skills:` configured, those skills are injected alongside (additive, not replacement).

```yaml
---
name: codebase-audit
description: "Comprehensive codebase audit"
context: fork
agent: Explore
---
# SKILL.md content becomes task prompt
```

## State Management

| Strategy | When to Use |
|----------|-------------|
| **Shared State** | Central coordination, multiple agents update single store |
| **Message Chain** | Linear workflows, output feeds next stage |
| **Hybrid** | Complex workflows with shared config + sequential processing |

## Performance Guidelines

| Do ✅ | Don't ❌ |
|-------|---------|
| Limit parallel spawns | Over-coordinate simple tasks |
| Batch similar operations | Share unnecessary state |
| Send structured summaries | Ignore failure modes |
| Implement error handling | Spawn excessive subagents |

## TaskList Integration

For multi-agent workflows spanning sessions:
- Use TaskList tools to create coordination tasks
- Track parallel execution state
- Manage agent handoff persistence

**Architecture**: TaskList (Layer 1) orchestrates subagents (Layer 2).
