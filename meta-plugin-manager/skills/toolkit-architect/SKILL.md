---
name: toolkit-architect
description: "Project scaffolding router for .claude/ configuration and local-first customization. Use when enhancing current project with skills, MCP, hooks, or subagents. Routes to specialized domain architects and toolkit-worker for analysis. Do not use for standalone plugin publishing."
disable-model-invocation: true
---

## 🚨 MANDATORY: Read BEFORE Routing

**CRITICAL**: You MUST read and understand these URLs:

### Primary Documentation (MUST READ)
- **[MUST READ] Project Customization Guide**: https://code.claude.com/docs/en/skills
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Content**: Project-scoped skills, .claude/ directory structure
  - **Cache**: 15 minutes minimum

- **[MUST READ] Local-First Configuration**: https://code.claude.com/docs/en/plugins
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Content**: .claude/ configuration patterns
  - **Cache**: 15 minutes minimum

### ⚠️ BLOCKING RULES
- **DO NOT proceed** until you've fetched and reviewed Primary Documentation
- **MUST validate** all URLs are accessible before routing
- **REQUIRED** to understand project-scoped configuration before routing

---

# Toolkit Architect

Project scaffolding router for .claude/ configuration using skills-first architecture.

## Actions

### create
**Creates new plugins** with skills-first architecture

**Router Logic**:
1. Load: plugin-architect, skills-knowledge, meta-architect-claudecode
2. Initialize PLUGIN_STATE.md with template (if not exists)
3. If needs isolation → Delegate to plugin-worker with context: fork
4. If simple skill → Create directly using skills-knowledge
5. If needs MCP → Route to mcp-architect
6. Record manifest decisions to PLUGIN_STATE.md as they are made
7. Record naming decisions to PLUGIN_STATE.md as they are made
8. Validate: plugin-quality-validator

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
2. Load existing state from PLUGIN_STATE.md (if exists)
3. **Assess output volume**:
   - Large plugin or full audit? → Delegate to plugin-worker (context: fork)
   - Simple validation? → Load directly
4. **Parse explicit output**:
   - Look for "## Audit Results: {plugin_name}"
   - Check "Quality Score: {score}/10"
5. **Handle failures explicitly**:
   - On ERROR: Log issue and report to user
   - On FAIL (< 8/10): Continue with recommendations
   - On PASS (≥ 8/10): Report compliance status
6. Update PLUGIN_STATE.md with results
7. Generate recommendations

**Fork Decision Matrix**:
| Plugin Size | Component Count | Use Fork? | Worker |
|-------------|-----------------|-----------|--------|
| Small (<5 skills) | <10 components | No | Direct load |
| Medium (5-20 skills) | 10-50 components | Yes | plugin-worker |
| Large (>20 skills) | >50 components | Yes | plugin-worker |

**Worker Output Parsing**:
```markdown
# Parse plugin-worker output for:
Completion marker: "## Audit Results:"
Quality score: Extract from "Quality Score: {score}/10"
Status classification:
  - score ≥ 8 → Continue with recommendations
  - score 5-7 → Report issues, suggest refinement
  - score < 5 → Major rework required

# If worker returns ERROR:
1. Parse error context
2. Log to PLUGIN_STATE.md
3. Report error to user with recovery options
4. Do NOT continue or retry without explicit direction
```

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
2. Load existing state from PLUGIN_STATE.md
3. Review current state
4. Identify improvements by domain:
   - Skills issues → Route to skills-architect
   - Hook issues → Route to hooks-architect
   - MCP issues → Route to mcp-architect
   - Subagent issues → Route to subagents-architect
5. Apply improvements
6. Update architecture decisions in PLUGIN_STATE.md
7. Mark resolved validation issues in PLUGIN_STATE.md
8. Update quality metrics in PLUGIN_STATE.md
9. Validate: plugin-quality-validator

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
- **plugin-architect** - Skills-first architecture guidance
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
