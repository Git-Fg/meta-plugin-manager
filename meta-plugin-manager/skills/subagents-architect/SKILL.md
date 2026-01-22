---
name: subagents-architect
description: "Context: fork router for isolation and parallelism patterns. Use for creating, auditing, or refining subagents with context: fork decisions. Routes to subagents-knowledge for coordination implementation. Do not use for simple tool execution or basic workflows."
disable-model-invocation: true
---

## 🚨 MANDATORY: Read BEFORE Routing

**CRITICAL**: You MUST read and understand these URLs:

### Primary Documentation (MUST READ)
- **[MUST READ] Plugin Architecture**: https://code.claude.com/docs/en/plugins
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Content**: Plugin structure, component organization
  - **Cache**: 15 minutes minimum

- **[MUST READ] Subagents Documentation**: https://code.claude.com/docs/en/sub-agents
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Content**: Context fork, isolation patterns
  - **Cache**: 15 minutes minimum

### ⚠️ BLOCKING RULES
- **DO NOT proceed** until you've fetched and reviewed Primary Documentation
- **MUST validate** all URLs are accessible before routing
- **REQUIRED** to understand subagents architecture before routing

---

# Subagents Architect

Domain router for subagent development with isolation and parallelism focus.

## Actions

### create
**Creates new subagents** for specialized autonomous work

**Router Logic**:
1. Load: subagents-knowledge
2. Determine pattern:
   - Pipeline - Sequential processing
   - Router + Worker - Task distribution
   - Handoff - Coordination
3. Generate subagent with:
   - Clear autonomy definition
   - Coordination pattern
   - Output contracts
4. Validate: Context fork usage, isolation benefits

**Output Contract**:
```
## Subagent Created: {agent_name}

### Pattern: {pattern}
- Purpose: {purpose}
- Autonomy: {autonomy_level}
- Coordination: {coordination_type}

### Context Fork Usage
- Isolation needed: ✅/❌
- High-volume output: ✅/❌
- Noise prevention: ✅/❌

### Output Contract
{contract_definition}
```

### audit
**Audits subagents** for appropriate usage and effectiveness

**Router Logic**:
1. Load: subagents-knowledge
2. Check:
   - Context fork appropriateness
   - Autonomy definition clarity
   - Coordination pattern fit
   - Isolation benefits
3. Generate audit with usage scoring

**Output Contract**:
```
## Subagent Audit: {agent_name}

### Context Fork Assessment
- Appropriate usage: ✅/❌
- Isolation justified: ✅/❌
- High-volume work: ✅/❌

### Autonomy
- Definition clarity: {score}/10
- Independence level: {level}
- Coordination needs: {needs}

### Pattern Fit
- Current: {pattern}
- Appropriateness: {score}/10
- Alternatives: {alternatives}

### Issues
- {issue_1}
- {issue_2}
```

### refine
**Improves subagents** based on audit findings

**Router Logic**:
1. Load: subagents-knowledge
2. Enhance:
   - Context fork optimization
   - Autonomy definition
   - Coordination patterns
   - Output contracts
3. Validate improvements

**Output Contract**:
```
## Subagent Refined: {agent_name}

### Context Fork Optimization
- {optimization_1}
- {optimization_2}

### Autonomy Improvements
- {improvement_1}
- {improvement_2}

### Pattern Enhancement
- {enhancement_1}
- {enhancement_2}

### Effectiveness Score: {old_score} → {new_score}/10
```

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

## Coordination Patterns

**Pipeline Pattern**:
- Sequential processing stages
- Data flows through stages
- Each stage transforms data

**Router + Worker Pattern**:
- Task distribution and execution
- Router delegates to workers
- Workers return results

**Handoff Pattern**:
- Coordination between specialized agents
- State transfer between contexts
- Seamless information flow

## Knowledge Routing

See [Subagents Knowledge](references/subagents-knowledge.md) for context: fork criteria and coordination patterns.

## Routing Criteria

**Route to subagents-knowledge** when:
- Context fork decisions
- Isolation justification
- Usage appropriateness
- Pattern selection
- Coordination implementation
- State management
