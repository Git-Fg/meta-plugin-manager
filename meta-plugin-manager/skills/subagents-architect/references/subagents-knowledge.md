# Subagents Knowledge Reference

## Subagent Routing

The subagents-architect skill provides context: fork decision criteria and coordination patterns. Currently, this knowledge is embedded in CLAUDE.md documentation.

## Coordination Patterns

### Pipeline Pattern
- Sequential processing stages
- Data flows through stages
- Each stage transforms data
- Use for: multi-step transformations

### Router + Worker Pattern
- Task distribution and execution
- Router delegates to workers
- Workers return results
- Use for: parallel task execution

### Handoff Pattern
- Coordination between specialized agents
- State transfer between contexts
- Seamless information flow
- Use for: specialized domain handoffs

## Context Fork Criteria

**Use context: fork when**:
- High-volume output (extensive analysis)
- Noisy exploration (clutters conversation)
- Isolated execution needed
- Prevents context pollution

**Don't use context: fork when**:
- Simple task execution
- Direct tool usage
- Straightforward operations
- Low complexity work

## Implementation Status

Subagent knowledge is **conceptually organized** in the subagents-architect hub. For detailed implementation patterns, refer to:
- CLAUDE.md Subagents section
- Official Subagents documentation
- Agent examples with context: fork

## Usage Pattern

```markdown
When routing from subagents-architect hub:
→ See CLAUDE.md for context: fork criteria
→ Refer to official subagents documentation for patterns
```
