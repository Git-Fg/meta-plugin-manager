---
name: subagents-architect
description: "Router for subagents domain expertise. Use for creating, auditing, or refining subagents for isolation and parallelism. Routes to subagents-* knowledge skills."
disable-model-invocation: true
---

# Subagents Architect

Domain router for subagent development with isolation and parallelism focus.

## Actions

### create
**Creates new subagents** for specialized autonomous work

**Router Logic**:
1. Load: subagents-when, subagents-coordination
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
1. Load: subagents-when, subagents-coordination
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
1. Load: subagents-when, subagents-coordination
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

**subagents-when** - Context fork decision criteria
**subagents-coordination** - Pattern selection and implementation

## Routing Criteria

**Route to subagents-when** when:
- Context fork decisions
- Isolation justification
- Usage appropriateness

**Route to subagents-coordination** when:
- Pattern selection
- Coordination implementation
- State management
