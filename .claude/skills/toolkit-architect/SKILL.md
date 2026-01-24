---
name: toolkit-architect
description: "Project scaffolding router for .claude/ configuration and local-first customization. Use when enhancing current project with skills, MCP, hooks, or subagents. Routes to specialized domain architects and toolkit-worker for analysis. Do not use for standalone plugin publishing."
user-invocable: false
---

## RECOMMENDED: Context Validation

Read these URLs when accuracy matters for your workflow:

### Primary Documentation
- **Project Customization Guide**: https://code.claude.com/docs/en/skills
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Project-scoped skills, .claude/ directory structure

- **Local-First Configuration**: https://code.claude.com/docs/en/plugins
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: .claude/ configuration patterns

### When to Fetch vs Skip
**Fetch when**:
- Documentation may have changed since last read
- Haven't read these docs recently
- User requests verification of current practices
- Starting a new project configuration

**Skip when**:
- Local-only work without external dependencies
- Working offline
- Documentation is known-stable and recently read
- Simple routing decisions that don't require current docs

**Trust your judgment**: You know when validation is needed for accurate work.

---

# Toolkit Architect

Project scaffolding router for .claude/ configuration using skills-first architecture.

## Actions

### create
**Creates project-scoped components** in .claude/

**Target Directory**: `${CLAUDE_PROJECT_DIR}/.claude/`

**Exploration Before Questions**:
1. Verify `.claude/` exists in current project
2. Scan existing structure: `ls -la .claude/` to see what components exist
3. Check for existing components in skills/, agents/, settings.json, settings.local.json, hooks.json, .mcp.json
4. Identify user's intent from request keywords (skill, MCP, hook, agent)

**Router Logic**:
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

**Output Clarification Requirements**:
- **Delegate to Knowledge Skills**: Summarize key points with attribution, maintain voice separation
- **Fork to toolkit-worker**: Parse results, present as subagent findings, acknowledge isolation
- **Quality Validation**: Lead with scores, separate critical vs. recommendations

## TaskList Routing

**Route to task-architect when**:
- "Multi-session project"
- "Context window spanning"
- "Project persistence"
- "Complex multi-step workflow"
- "Indefinitely long project"

**Route to task-knowledge when**:
- "Task management guidance"
- "Agent type selection"
- "Model selection for tasks"
- "Context spanning patterns"
- "Multi-session collaboration"
- "Task JSON file management"

**Route to subagents-knowledge when**:
- "Agent type selection for subagents"
- "Subagent coordination patterns"
- "Agent model selection"

**Autonomy Pattern**: Smart defaults based on exploration
- No .claude/ exists → Create .claude/ directory structure first
- Empty .claude/ → Infer from request keywords (skill/MCP/hook/agent/CLAUDE.md) in Router Logic
- Has skills/ → Suggest skill enhancements or new skills
- Has .mcp.json → Suggest additional MCP servers
- Has messy/outdated CLAUDE.md → Suggest claude-md-manager for refactoring
- No CLAUDE.md exists → Suggest claude-md-manager for creation

**Output Contract**:
```
## Component Created: {component_type}

### Location
- Path: .claude/{component_path}/

### Quality Score: {score}/10
Continue only if score ≥ 8/10
```

### audit
**Audits .claude/ configuration** for quality and compliance

**Target**: `${CLAUDE_PROJECT_DIR}/.claude/`

**Router Logic**:
1. Load: toolkit-quality-validator
2. **Assess output volume**:
   - Large .claude/ or full audit? → **Use the meta-plugin-manager:toolkit-worker subagent**
   - Simple validation? → Load directly
3. **Parse explicit output**:
   - Look for "## Audit Results:"
   - Check "Quality Score: {score}/10"
4. **Handle failures explicitly**:
   - On ERROR: Log issue and report to user
   - On FAIL (< 8/10): Continue with recommendations
   - On PASS (≥ 8/10): Report compliance status
5. Generate recommendations

**Fork Decision Matrix**:
| .claude/ Size | Component Count | Use Fork? | Worker |
|---------------|-----------------|-----------|--------|
| Small (<5 skills) | <10 components | No | Direct load |
| Medium (5-20 skills) | 10-50 components | Yes | toolkit-worker |
| Large (>20 skills) | >50 components | Yes | toolkit-worker |

**Worker Output Parsing**:
```markdown
# Parse toolkit-worker output for:
Completion marker: "## .claude/ Analysis Report"
Quality score: Extract from "Quality Score: {score}/10"
Status classification:
  - score ≥ 8 → Continue with recommendations
  - score 5-7 → Report issues, suggest refinement
  - score < 5 → Major rework required

# If worker returns ERROR:
1. Parse error context
2. Log and report error to user with recovery options
3. Do NOT continue or retry without explicit direction

# Output Clarification Requirements:
## Present toolkit-worker results as:
- Mark source: "The toolkit-worker subagent reports..."
- Parse findings: Extract insights from noisy analysis
- Acknowledge isolation: "In isolated context, the worker found..."
- Present scores: Lead with quality score and dimensional breakdown
- Prioritize actions: Critical → High → Medium → Low
```

**Output Contract**:
```
## .claude/ Audit Results

### Quality Score: {score}/10

### Structural Compliance
- ✅/❌ Skills-first architecture
- ✅/❌ .claude/ directory structure
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
**Improves .claude/ configuration** based on audit findings

**Target**: `${CLAUDE_PROJECT_DIR}/.claude/`

**Router Logic**:
1. Load: toolkit-quality-validator, relevant knowledge skills
2. Review current .claude/ structure
3. Identify improvements by domain:
   - Skills issues → Route to skills-architect
   - Hook issues → Route to hooks-architect
   - MCP issues → Route to mcp-architect
   - Subagent issues → Route to subagents-architect
4. Apply improvements to .claude/
5. Validate: toolkit-quality-validator

**Output Contract**:
```
## .claude/ Refinement Complete

### Changes Applied
- {change_1}
- {change_2}
- {change_3}

### Quality Improvement: {old_score} → {new_score}/10

### Next Steps
- {recommendation_1}
- {recommendation_2}
```

## When to Use the Subagent

**Use the toolkit-worker subagent** when:
- High-volume output (extensive grep, repo traversal)
- Noisy exploration that clutters conversation
- Full .claude/ directory audits
- Pattern discovery across multiple files

**Don't use context: fork** when:
- Simple task creation
- Direct skill instantiation
- Straightforward routing decisions

## Knowledge Skills

Delegates to:
- **toolkit-architect** - Project scaffolding guidance
- **skills-knowledge** - Skill development best practices
- **meta-architect-claudecode** - Layer selection decisions
- **toolkit-quality-validator** - Standards enforcement
- **toolkit-worker** - Noisy/high-volume analysis
- **claude-md-manager** - CLAUDE.md creation, audit, and refactoring

## Integration Points

- **skills-architect** - Skills domain expertise
- **hooks-architect** - Hooks domain expertise
- **mcp-architect** - MCP domain expertise
- **subagents-architect** - Subagents domain expertise
- **task-architect** - Multi-step workflow coordination with TaskList
- **claude-md-manager** - CLAUDE.md management
- **toolkit-worker** - Isolated analysis worker

## Output Clarification Patterns

When skills delegate to other skills or subagents, follow these patterns for clear output handling:

### Pattern 1: Delegation to Knowledge Skills
**When**: Architect skill delegates to knowledge skill (e.g., toolkit-architect → skills-knowledge)

**Clarification Requirements**:
1. **Source Attribution**: Always mark the source clearly
2. **Context Bridge**: Explain how knowledge applies to current request
3. **Summarize Key Points**: Extract actionable insights, don't dump full reference
4. **Maintain Voice Separation**: Keep architect's voice distinct from knowledge skill's voice

**Response Template**:
```markdown
## [Action] Complete

Based on [knowledge-skill-name] implementation guidance:

**Key Points Applied:**
1. [Point 1] - Applied to: [specific context]
2. [Point 2] - Applied to: [specific context]

**Recommendations for Your Project:**
- [Specific actionable item 1]
- [Specific actionable item 2]
```

### Pattern 2: Forked Worker Results (Subagent)
**When**: toolkit-worker completes noisy/high-volume analysis

**Clarification Requirements**:
1. **Mark as Subagent Output**: Clearly identify as subagent result
2. **Parse and Summarize**: Extract insights from noisy output
3. **Present Key Findings First**: Lead with scores and critical issues
4. **Acknowledge Isolation**: Note this is from isolated context

**Response Template**:
```markdown
## .claude/ Analysis Complete

**Quality Score: X.X/10** (from toolkit-worker subagent analysis)

**Key Findings:**
- Structural: X/30 - [Status and implications]
- Components: X/50 - [Specific issues found]
- Standards: X/20 - [Compliance status]

**Priority Actions:**
1. [Action 1] - [Expected time/effort]
2. [Action 2] - [Expected time/effort]
```

### Pattern 3: Quality Validation Results
**When**: toolkit-quality-validator audits .claude/ setup

**Clarification Requirements**:
1. **Lead with Score**: Present overall score prominently
2. **Break Down Components**: Show dimensional scores
3. **Separate Critical vs. Recommendations**: Distinguish blocking issues
4. **Link to Improvement Path**: Show how to reach ≥8.0/10

**Response Template**:
```markdown
## Quality Validation Results

**Overall Score: X.X/10** (Target: ≥8.0)

**Breakdown:**
✅ Structural Compliance: X/30 - [What passed]
❌ Component Quality: X/50 - [What failed and why]
⚠️ Standards: X/20 - [Partial compliance]

**Critical Issues (blocking production):**
- [Issue 1] - Requires immediate attention
- [Issue 2] - Blocking deployment

**Recommended Improvements:**
1. [Action] → Expected improvement: [specific score gain]
2. [Action] → Expected improvement: [specific score gain]
```

### Pattern 4: Sequential Skill Chains
**When**: Multiple skills work in sequence (architect → validator → refiner)

**Clarification Requirements**:
1. **Show Workflow Progression**: Stage 1 → Stage 2 → Stage 3
2. **Highlight Changes**: What improved between stages
3. **Final State Focus**: Current quality and status
4. **Chain Completion**: Demonstrate successful workflow

**Response Template**:
```markdown
## Workflow Complete

**Stage 1: Initial Assessment**
- Score: X.X/10
- Issues Identified: [List]

**Stage 2: Quality Validation**
- Validator Confirmed: [Key findings]
- No Critical Blocking Issues: [Status]

**Stage 3: Applied Refinements**
- [Action 1]: [Before] → [After]
- [Action 2]: [Before] → [After]
- **Final Score: X.X/10** ✅
```

### Progressive Disclosure for Nested Results

**Tier 1 (Summary)**: Quick overview of key findings and scores
**Tier 2 (Details)**: Specific recommendations and dimensional breakdown
**Tier 3 (Deep Dive)**: Available on request

**Implementation**:
- Always provide Tier 1 in initial response
- Include Tier 2 for action-oriented details
- Offer Tier 3 only when explicitly requested

---

## Task-Integrated Audit Workflow

For complex .claude/ audits requiring visual progress tracking and dependency enforcement, use TaskList integration:

**When to use**:
- Multi-component validation (skills + subagents + hooks + MCP)
- Need to enforce scan completion before component validation
- Want visual progress tracking (Ctrl+T)
- Quality tracking across audit iterations

**Workflow description**:

Use TaskCreate to establish a .claude/ structure scan task first. Then use TaskCreate to set up parallel component validation tasks for skills (15 points), subagents (10 points), hooks (10 points), and MCP (5 points) — configure these to depend on the scan completion. Use TaskCreate to establish a standards compliance check task (20 points) that depends on all component validations completing. Finally use TaskCreate to establish a final audit report generation task. Use TaskUpdate to mark tasks complete as each phase finishes, and use TaskList to check overall progress and identify any blocked tasks.

**Critical dependency**: Component validation tasks must be configured to depend on the structure scan task completing. The standards check task must depend on all component validation tasks. This ensures comprehensive evaluation before scoring and a complete picture before final reporting.

**Task tracking provides**:
- Visual progression through audit phases (visible in Ctrl+T)
- Dependency enforcement (tasks block until dependencies complete)
- Persistent quality tracking across audit iterations
- Clear phase completion markers

## TOOLKIT_ARCHITECT_COMPLETE
