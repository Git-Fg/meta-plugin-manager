---
name: context-fundamentals
description: Foundational understanding of context engineering for AI agent systems. Apply when designing components, optimizing context usage, or managing attention mechanics.
---

# Context Engineering Fundamentals

Context is the complete state available to a language model at inference time: system prompts, tool definitions, retrieved documents, message history, and tool outputs. Understanding context fundamentals is essential for building efficient, portable components.

## Core Principles

### Context as Finite Resource

Context windows are constrained by **attention mechanics**, not just token capacity. Models exhibit predictable degradation patterns:
- "Lost-in-the-middle" effect
- U-shaped attention curves
- Context poisoning from irrelevant information

**Key Insight**: Treat context as a finite resource with diminishing marginal returns. Every token depletes the attention budget.

### Context Anatomy

Context comprises five distinct components:

**1. System Prompts**
- Establish agent identity, constraints, behavioral guidelines
- Loaded once at session start, persist throughout
- Use clear sections: background, instructions, tool guidance, output description
- Right altitude: specific enough to guide, flexible enough for heuristics

**2. Tool Definitions**
- Specify actions an agent can take
- Include name, description, parameters, return format
- Tool descriptions collectively steer behavior
- Consolidation principle: if engineer can't say which tool to use, agent can't either

**3. Retrieved Documents**
- Domain-specific knowledge, reference materials
- Use just-in-time loading (RAG pattern)
- Store lightweight identifiers (file paths, queries)
- Load dynamically based on relevance

**4. Message History**
- Conversation between user and agent
- Grows to dominate context in long tasks
- Serves as scratchpad memory
- Requires active management for long-horizon tasks

**5. Tool Outputs**
- Results of agent actions: files, search, commands, API responses
- Comprise majority of tokens (up to 83.9% in research)
- Consume context whether relevant or not
- Create pressure for masking, compaction, selective retention

### Progressive Disclosure

Load information only as needed to manage attention budget:

**Level 1**: Skill names and descriptions (discovery)
**Level 2**: Full instructions (activation)
**Level 3**: References, scripts, data (execution)

This keeps agents fast while providing access to more context on demand.

### Context Quality Over Quantity

**Guiding Principle**: Find the smallest high-signal token set that maximizes desired outcomes.

Evidence from BrowseComp evaluation (95% performance variance explained by):
- Token usage (80% of variance)
- Number of tool calls (~10%)
- Model choice (~5%)

**Implication**: Model upgrades beat token increases. Better models multiply efficiency.

## Practical Application

### For Component Design

**Apply Progressive Disclosure**:
```
Level 1 (auto-loaded): Component overview, trigger phrases
Level 2 (on-demand): Full instructions, examples
Level 3 (as-needed): References, scripts, detailed docs
```

**Context Budgeting**:
- Design with explicit context limits
- Monitor usage during development
- Implement compaction at 70-80% utilization
- Place critical info at attention-favored positions (beginning/end)

**Organize Prompts**:
```markdown
<BACKGROUND>
You are a [role] for [domain]
Current project: [context]
</BACKGROUND>

<INSTRUCTIONS>
- Guideline 1
- Guideline 2
- Guideline 3
</INSTRUCTIONS>

<TOOL_GUIDANCE>
Use [tool] for [purpose]
</TOOL_GUIDANCE>

<OUTPUT>
Provide [format] with [requirements]
</OUTPUT>
```

### For Filesystem-Based Access

**Filesystem-as-Memory Pattern**:
- Store reference materials externally
- Load files only when needed using filesystem operations
- File sizes suggest complexity
- Naming conventions hint at purpose
- Timestamps serve as relevance proxies

**Dynamic Context Discovery**:
```
Step 1: Load summary (lightweight)
docs/api_summary.md

Step 2: Load specific section (as needed)
docs/api/endpoints.md (only when API calls needed)
docs/api/auth.md (only when auth context needed)
```

### Hybrid Strategies

**Pre-load for Speed**:
- CLAUDE.md files
- Project rules
- Critical context

**Enable Autonomous Exploration**:
- Just-in-time loading
- Filesystem navigation
- Search-based discovery

## Context Engineering Patterns

### Pattern 1: Observation Masking

**Problem**: Tool outputs bloat context (83.9% of tokens)

**Solution**: Write large outputs to files, return summaries
```python
if len(output) > threshold:
    write_file(f"scratch/{tool}_{timestamp}.txt", output)
    return f"[Output: {file}] Summary: {extract_summary(output)}"
```

### Pattern 2: Plan Persistence

**Problem**: Long-horizon plans fall out of attention

**Solution**: Write plans to filesystem, re-read as needed
```yaml
# current_plan.yaml
objective: "Refactor authentication"
status: in_progress
steps:
  - id: 1
    description: "Audit auth endpoints"
    status: completed
```

### Pattern 3: Dynamic Skill Loading

**Problem**: Many skills, most irrelevant to current task

**Solution**: Store skills as files, load on-demand
```
Available skills (load with read_file when relevant):
- database-optimization: Query tuning strategies
- api-design: REST/GraphQL best practices
- testing-strategies: Unit/integration/e2e patterns
```

## Guidelines

1. **Treat context as finite resource** with diminishing returns
2. **Place critical information** at attention-favored positions (beginning/end)
3. **Use progressive disclosure** to defer loading until needed
4. **Organize prompts** with clear section boundaries
5. **Monitor context usage** during development
6. **Implement compaction triggers** at 70-80% utilization
7. **Design for context degradation** rather than hoping to avoid it
8. **Prefer smaller high-signal context** over larger low-signal context

## Context Engineering Checklist

When designing components:

- [ ] Identified context budget for component
- [ ] Applied progressive disclosure (3 levels)
- [ ] Organized prompts with clear sections
- [ ] Placed critical info at attention boundaries
- [ ] Implemented observation masking for large outputs
- [ ] Designed filesystem-based context discovery
- [ ] Planned compaction triggers (70-80%)
- [ ] Tested at different context sizes

## Integration

This foundational skill enhances all meta-skills:
- **skill-development**: Progressive disclosure in skill structure
- **command-development**: Context budgeting in command design
- **agent-development**: Multi-agent context isolation
- **Ralph**: Filesystem-based validation artifacts

## References

**Related Skills**:
- `evaluation` - Multi-dimensional quality assessment
- `filesystem-context` - Filesystem-as-memory patterns
- `multi-agent-patterns` - Context isolation architectures

**Key Research**:
- BrowseComp evaluation on performance drivers
- Attention mechanism constraints
- Position encoding interpolation effects

**Remember**: Context engineering is iterative discipline, not one-time prompt writing. Curate context each time you decide what to pass to the model.
