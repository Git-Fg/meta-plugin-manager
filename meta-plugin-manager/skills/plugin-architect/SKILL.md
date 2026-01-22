---
name: plugin-architect
description: "Single router for complete plugin lifecycle. Use for creating, auditing, or refining plugins with skills-first architecture. Routes to specialized knowledge skills and plugin-worker for analysis."
disable-model-invocation: true
---

# Plugin Architect

Single domain router for complete plugin lifecycle management using skills-first architecture.

## Actions

### create
**Creates new plugins** with skills-first architecture

**Router Logic**:
1. Load: plugin-structure, skills-knowledge, meta-architect-claudecode
2. If needs isolation → Delegate to plugin-worker with context: fork
3. If simple skill → Create directly using skills-knowledge
4. If needs MCP → Route to mcp-architect
5. Validate: plugin-quality-validator

**Output Contract**:
```
## Plugin Created: {plugin_name}

### Structure
- skills/: {skill_list}
- agents/: {agent_list}
- hooks/: {hook_list}
- mcp/: {mcp_list}

### Quality Score: {score}/10
Continue only if score ≥ 8/10
```

### audit
**Audits existing plugins** for quality and compliance

**Router Logic**:
1. Load: plugin-quality-validator
2. Delegate to plugin-worker for noisy analysis (context: fork)
3. Integrate results with quality scoring
4. Generate recommendations

**Output Contract**:
```
## Audit Results: {plugin_name}

### Quality Score: {score}/10

### Structural Compliance
- ✅/❌ Skills-first architecture
- ✅/❌ Directory structure
- ✅/❌ Progressive disclosure

### Component Quality
- Skills: {score}/15
- Subagents: {score}/10
- Hooks: {score}/10
- MCP: {score}/5

### Standards Adherence
- URL currency: {score}/10
- Best practices: {score}/10

### Priority Actions
- High: {high_priority}
- Medium: {medium_priority}
- Low: {low_priority}
```

### refine
**Improves plugins** based on audit findings

**Router Logic**:
1. Load: plugin-quality-validator, relevant knowledge skills
2. Review current state
3. Identify improvements by domain:
   - Skills issues → Route to skills-architect
   - Hook issues → Route to hooks-architect
   - MCP issues → Route to mcp-architect
   - Subagent issues → Route to subagents-architect
4. Apply improvements
5. Validate: plugin-quality-validator

**Output Contract**:
```
## Refinement Complete: {plugin_name}

### Changes Applied
- {change_1}
- {change_2}
- {change_3}

### Quality Improvement: {old_score} → {new_score}/10

### Next Steps
- {recommendation_1}
- {recommendation_2}
```

## When to Use Context: Fork

**Use plugin-worker (context: fork)** when:
- High-volume output (extensive grep, repo traversal)
- Noisy exploration that clutters conversation
- Full codebase audits
- Pattern discovery across multiple files

**Don't use context: fork** when:
- Simple task creation
- Direct skill instantiation
- Straightforward routing decisions

## Knowledge Skills

Delegates to:
- **plugin-structure** - Skills-first architecture guidance
- **skills-knowledge** - Skill development best practices
- **meta-architect-claudecode** - Layer selection decisions
- **plugin-quality-validator** - Standards enforcement
- **plugin-worker** - Noisy/high-volume analysis

## Integration Points

- **skills-architect** - Skills domain expertise
- **hooks-architect** - Hooks domain expertise
- **mcp-architect** - MCP domain expertise
- **subagents-architect** - Subagents domain expertise
- **plugin-worker** - Isolated analysis worker
