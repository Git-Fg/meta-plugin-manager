# Hub-and-Spoke Architecture Knowledge Analysis

## Sources
- `.claude/rules/architecture.md` - Lines 24-30
- `.claude/rules/anti-patterns.md` - Lines 31-47
- `.claude/skills/toolkit-architect/SKILL.md` - Lines 33-63
- `.claude/skills/skills-architect/SKILL.md` - Lines 8-11
- `.claude/skills/hooks-architect/SKILL.md` - Lines 8-12
- `.claude/skills/mcp-architect/SKILL.md` - Lines 9-12

## Extracted Hub-and-Spoke Patterns

### 1. Hub-and-Spoke Rules (from architecture.md)

**Source**: `architecture.md:24-30`
```
Hub-and-Spoke Pattern

Hub Skills (routers with disable-model-invocation: true) delegate to knowledge skills. Prevents context rot.

CRITICAL: For hub to aggregate results, ALL delegate skills MUST use `context: fork`. Regular skill handoffs are one-way only.

See: CLAUDE.md for complete hub-and-spoke pattern documentation and test validation results.
```

### 2. Anti-Patterns (from anti-patterns.md)

**Source**: `anti-patterns.md:31-47`
```
❌ Regular skill chains expecting return - Regular→Regular is one-way handoff
- skill-a calls skill-b → skill-b becomes final output
- skill-a NEVER resumes

❌ Context-dependent forks - Don't fork if you need caller context
- Forked skills cannot access caller's conversation history
- Parameters via args ARE the proper data transfer method

❌ Linear chain brittleness - Use hub-and-spoke instead
- Hub Skills delegate to knowledge skills
- For aggregation, ALL workers MUST use `context: fork`
```

### 3. Hub Implementation: toolkit-architect

**Hub Pattern** (Lines 33-63):
```yaml
---
name: toolkit-architect
description: "Project scaffolding router for .claude/ configuration and local-first customization. Use when enhancing current project with skills, MCP, hooks, or subagents. Routes to specialized domain architects and toolkit-worker for analysis. Do not use for standalone plugin publishing."
user-invocable: false
---

# Toolkit Architect

## Actions

### create
Router Logic:
1. Validate: User's project has .claude/ directory
2. Determine component type:
   - "I need a skill" → Route to skills-architect
   - "I want web search" → Route to mcp-architect
   - "I need a PR reviewer" → Route to skills-architect or subagents-architect
   - "I want automation" → Route to hooks-architect
   - "I need CLAUDE.md" or "memory management" → Route to claude-md-manager
   - "refactor CLAUDE.md" or "improve CLAUDE.md" → Route to claude-md-manager
   - "workflow spanning sessions" or "multi-stage project setup" → Route to task-architect
3. Load: appropriate knowledge skill
4. Generate in .claude/ (not standalone plugin)
5. Validate: toolkit-quality-validator
```

**MISSING**: ❌ toolkit-architect does NOT use `disable-model-invocation: true`

**ROUTING PATTERN**: ✅ Routes to multiple specialists

**COMPLIANCE**: ⚠️ PARTIAL - Routes correctly but missing disable-model-invocation

### 4. Worker Implementation

#### skills-architect

**Called by** (Lines 8-11):
```
Called by: toolkit-architect
Purpose: Route skill development to appropriate knowledge and create skills
```

**CONTEXT FORK**: Lines 10-58 show skills-architect calls skills-knowledge with `context: fork`

**COMPLIANCE**: ✅ Uses context: fork for delegation

#### hooks-architect

**Called by** (Lines 8-12):
```
Called by: toolkit-architect
Purpose: Configure guardrails and hooks in your local project
```

**ROUTING**: Routes to hooks-knowledge for patterns and templates

**CONTEXT FORK**: Not explicitly shown in first 392 lines, needs verification

**COMPLIANCE**: ⚠️ UNKNOWN - Needs deeper reading

#### mcp-architect

**Called by** (Lines 9-12):
```
Called by: toolkit-architect
Purpose: Configure MCP servers and integrations in .mcp.json
```

**ROUTING**: Routes to mcp-knowledge for configuration details

**CONTEXT FORK**: Not explicitly shown in first 439 lines, needs verification

**COMPLIANCE**: ⚠️ UNKNOWN - Needs deeper reading

### 5. Hub-and-Spoke Knowledge Elements

**Pattern 1: Hub Skill Definition**
- Router with `disable-model-invocation: true`
- Routes to knowledge skills
- Does NOT do the work itself
- Aggregates results from workers

**Pattern 2: Worker Skills**
- Use `context: fork` when called by hub
- Contain domain expertise
- May route to other knowledge skills
- Execute in isolated context

**Pattern 3: Result Aggregation**
- Hub collects results from all workers
- Formats unified output
- Returns to caller
- Maintains voice separation

**Pattern 4: Context Isolation**
- Forked skills cannot access caller context
- Parameters via args are proper transfer method
- Prevents context rot
- Enables parallel execution

**Pattern 5: Routing Logic**
- Deterministic routing based on keywords
- Context-aware decisions
- Fallback routing
- No user questions for routing

### 6. Compliance Assessment

| Component | disable-model-invocation | context: fork usage | Routing Pattern | Compliance |
|-----------|--------------------------|---------------------|----------------|------------|
| toolkit-architect | ❌ NOT SET | N/A | Routes to 7 specialists | ⚠️ PARTIAL |
| skills-architect | N/A | ✅ YES | Routes to skills-knowledge | ✅ FULL |
| hooks-architect | N/A | ⚠️ UNKNOWN | Routes to hooks-knowledge | ⚠️ UNKNOWN |
| mcp-architect | N/A | ⚠️ UNKNOWN | Routes to mcp-knowledge | ⚠️ UNKNOWN |

### 7. Critical Violations

**VIOLATION 1: toolkit-architect Missing disable-model-invocation**
- **Rule**: "Hub Skills (routers with disable-model-invocation: true)"
- **Implementation**: toolkit-architect does NOT have disable-model-invocation
- **Severity**: CRITICAL
- **Impact**: May execute instead of just routing

**VIOLATION 2: Unverified context: fork in Workers**
- hooks-architect and mcp-architect may not use context: fork
- Rule states: "ALL delegate skills MUST use `context: fork`"
- **Severity**: CRITICAL if violated
- **Impact**: No result aggregation, one-way handoff only

### 8. Knowledge Consistency

**CONSISTENT**:
- All components understand hub-and-spoke concept
- Routing logic is clear and deterministic
- Workers route to knowledge skills

**INCONSISTENT**:
- toolkit-architect missing disable-model-invocation (critical)
- Unknown if workers use context: fork

### 9. Additional Findings

**ROUTING COVERAGE**:
```
toolkit-architect routes to:
1. skills-architect (skill creation)
2. mcp-architect (MCP integration)
3. hooks-architect (hooks configuration)
4. subagents-architect (subagent creation)
5. claude-md-manager (CLAUDE.md management)
6. task-architect (multi-step workflows)
7. toolkit-worker (isolated analysis)
```

**ROUTER LOGIC QUALITY**: ✅ Comprehensive and well-designed

### 10. Gaps and Violations

**CRITICAL VIOLATIONS**:
1. ❌ toolkit-architect: Missing disable-model-invocation: true
2. ⚠️ hooks-architect: context: fork usage unverified
3. ⚠️ mcp-architect: context: fork usage unverified

**COMPLIANCE RATE**: 33% (1/3 verified compliant)

### 11. Impact Analysis

**Without disable-model-invocation**:
- toolkit-architect may execute instead of just routing
- Violates hub pattern (hubs should route, not execute)
- Could lead to context rot

**Without context: fork in workers**:
- No result aggregation
- One-way handoff only
- Cannot parallelize
- Violates hub-and-spoke aggregation

## Summary

**Total Hub-and-Spoke Patterns Extracted**: 5
**Compliance Rate**: 33%
**Critical Violations**: 1 confirmed, 2 suspected
**Missing Elements**: disable-model-invocation in hub

Hub-and-spoke architecture is partially understood and implemented. Critical violation: toolkit-architect (hub) lacks disable-model-invocation. Workers' context: fork usage needs verification.
