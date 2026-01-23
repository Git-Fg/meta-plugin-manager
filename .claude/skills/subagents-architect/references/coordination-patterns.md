# Subagent Coordination Patterns

Multi-agent orchestration patterns for effective subagent coordination.

---

## Pattern 1: Hub and Spoke

**Use Case**: Central coordinator delegates to specialists

```
[Hub Agent]
  ├── Specialist Agent 1
  ├── Specialist Agent 2
  └── Specialist Agent 3
```

**Example**: Deployment orchestrator delegates to build, test, and deploy agents

---

## Pattern 2: Pipeline

**Use Case**: Sequential task processing

```
[Agent A] → [Agent B] → [Agent C]
```

**Example**: Code review pipeline: scan → analyze → report

---

## Pattern 3: Parallel Execution

**Use Case**: Independent tasks run simultaneously

```
[Agent 1] ←→ [Coordinator]
[Agent 2] ←→ [Coordinator]
[Agent 3] ←→ [Coordinator]
```

**Example**: Log analysis: multiple agents analyze different log types

---

## DETECT Workflow

**Purpose**: Identify automation opportunities

**Process**:
1. Scan project for repetitive tasks
2. Identify patterns suitable for agents
3. Suggest optimal configurations
4. Recommend context-appropriate locations

---

## OPTIMIZATION Patterns

**Performance**:
- Use `haiku` for simple tasks
- Restrict tools appropriately
- Minimize skill injection
- Use component-scoped hooks

**Safety**:
- Set `permissionMode: safe`
- Use `disallowedTools` for read-only
- Add validation hooks
- Monitor agent execution

See also: configuration-guide.md, context-detection.md, validation-framework.md
