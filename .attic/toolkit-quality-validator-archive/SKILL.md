---
name: toolkit-quality-validator
description: "Validate .claude/ configuration quality and compliance with 2026 best practices. Use when auditing project setup, checking skills/mcp/hooks compliance, or validating local-first configuration. Do not use for standalone plugin validation without project context."
user-invocable: true
---

# Toolkit Quality Validator

## WIN CONDITION

**Called by**: toolkit-architect, skills-architect, hooks-architect, mcp-architect
**Purpose**: Validate .claude/ configuration quality and compliance

**Output**: Must output completion marker with quality score

```markdown
## QUALITY_VALIDATION_COMPLETE

Quality Score: X.X/10
Structural: X/30
Components: X/50
Standards: X/20
Status: [PASS|FAIL]
Issues: [List]
```

**Completion Marker**: `## QUALITY_VALIDATION_COMPLETE`

Validate .claude/ configuration quality and compliance with skills-first architecture and 2026 best practices.

## RECOMMENDED: Context Validation

Read these URLs when accuracy matters for quality validation work:

### Primary Documentation
- **Skills Guide**: https://code.claude.com/docs/en/skills
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Skills-first architecture, progressive disclosure

- **Plugin Architecture**: https://code.claude.com/docs/en/plugins
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Plugin structure, component organization

### When to Fetch vs Skip
**Fetch when**:
- Documentation may have changed since last read
- User requests verification of quality standards
- Starting new quality audit
- Uncertain about current best practices

**Skip when**:
- Simple validation based on known patterns
- Local-only work without external dependencies
- Working offline
- Recently read and documentation is stable

**Trust your judgment**: You know when validation is needed for accurate quality assessment.

## Core Responsibilities

This validator checks:

1. **Skills-first architecture** - Are skills the primary building blocks?
2. **Plugin manifest** - Is plugin.json correct and complete?
3. **Component compliance** - Skills, subagents, hooks, MCP
4. **2026 standards** - Progressive disclosure, autonomy, context: fork
5. **Quality scoring** - 0-10 scale with detailed breakdown
6. **Best practices** - URL currency, modern patterns
7. **Actionable recommendations** - Specific improvement guidance

## Quality Framework (0-10 Scale)

### Structural (30% - 30 points)
- **Skills-first architecture** (10 pts)
  - ✅ Skills are primary building blocks
  - ✅ Subagents used only for isolation/parallelism
  - ✅ No command-first patterns

- **Directory structure** (10 pts)
  - ✅ Skills directory present
  - ✅ Standard organization
  - ✅ Clear component separation

- **Progressive disclosure** (10 pts)
  - ✅ Tier 1: Metadata (~100 tokens)
  - ✅ Tier 2: SKILL.md (<35,000 chars)
  - ✅ Tier 3: References (on-demand)

### Components (50% - 50 points)
- **Skill quality** (15 pts)
  - ✅ YAML frontmatter valid
  - ✅ Clear description with triggers
  - ✅ Autonomous execution
  - ✅ Progressive disclosure

- **Subagent quality** (10 pts)
  - ✅ Context: fork usage appropriate
  - ✅ Dynamic context injection
  - ✅ Clear coordination patterns

- **Hook quality** (10 pts)
  - ✅ Proper configuration
  - ✅ Security best practices
  - ✅ Appropriate event matching

- **MCP quality** (5 pts)
  - ✅ Valid configuration
  - ✅ Proper transport (2026)
  - ✅ Security considerations

- **Architecture compliance** (10 pts)
  - ✅ Skills-first patterns
  - ✅ No anti-patterns
  - ✅ Modern orchestration

### Standards (20% - 20 points)
- **URL currency** (10 pts)
  - ✅ Documentation links current (2026)
  - ✅ Mandatory URL fetching sections
  - ✅ Strong language (MUST/REQUIRED)

- **Best practices** (10 pts)
  - ✅ Model-agnostic code
  - ✅ Cost optimization
  - ✅ Autonomy-first design

### Context & Tool Management (5 points)

**MCP Configuration Hygiene:**
- ✅ MCP servers organized by purpose (authoring/research/validation)
- ✅ Documentation references proper enable/disable patterns
- ✅ No "always-on" heavy MCPs without justification

**Session Management Guidance:**
- ✅ Clear task-to-MCP mapping documented
- ✅ Phase-based enable/disable instructions present
- ✅ Warning about "too many tools active" included

## Validation Process

### Step 1: Fetch Documentation
```bash
# Read primary documentation
simpleWebFetch https://code.claude.com/docs/en/skills
simpleWebFetch https://code.claude.com/docs/en/plugins
```

### Step 2: Structural Check
1. **Locate plugin root**
   - Check for `.claude-plugin/plugin.json`
   - Verify directory structure

2. **Validate manifest**
   - JSON syntax correct
   - Required fields present
   - Name format valid

3. **Check directory structure**
   - Skills directory present
   - Standard locations used
   - Auto-discovery working

### Step 3: Component Validation

**Skills Validation**:
- YAML frontmatter valid (name, description)
- Size <35,000 characters
- Progressive disclosure implemented
- Autonomy score (80-95% target)
- URL fetching sections present

**Subagents Validation**:
- Context: fork used appropriately
- Dynamic context injection present
- Coordination patterns clear
- Specialization appropriate

**Hooks Validation**:
- Valid JSON syntax
- Event matching appropriate
- Security best practices
- Configuration complete

**MCP Validation**:
- Valid configuration
- Transport type (stdio/streamable-http)
- Resources/prompts proper
- Security considerations

**Context Management Validation**:
- [ ] Check if MCPs are properly categorized by purpose
- [ ] Verify documentation explains enable/disable strategy
- [ ] Confirm no unnecessary MCPs are marked as always-on
- [ ] Validate tool count recommendations are present

### Step 4: Standards Check

**2026 Compliance**:
- Progressive disclosure (Tier 1/2/3)
- Autonomy-first design
- Model-agnostic code
- Cost optimization (<$50/rotation)

**URL Currency**:
- All documentation links current
- Mandatory URL sections
- Strong language used

### Step 5: Generate Report

## Validation Report Format

```markdown
## Quality Score: {score}/10

### Structural Compliance ({structural_score}/30)
- ✅ Skills-first architecture
- ✅ Directory structure
- ✅ Progressive disclosure

### Component Quality ({component_score}/50)
- Skills: {skill_score}/15
- Subagents: {subagent_score}/10
- Hooks: {hook_score}/10
- MCP: {mcp_score}/5
- Architecture: {arch_score}/10

### Standards Adherence ({standards_score}/20)
- URL currency: {url_score}/10
- Best practices: {bp_score}/10

### Context & Tool Management ({context_score}/5)
- MCP configuration: {mcp_config_score}/3
- Session management: {session_mgmt_score}/2

### Critical Issues
- {issue_1}
- {issue_2}

### Recommendations
1. {rec_1}
2. {rec_2}
3. {rec_3}

### Overall Assessment
**Status**: {PASS/FAIL}
**Priority**: {High/Medium/Low}
```

## Anti-Patterns Detected

❌ **Command wrapper anti-pattern**
- Skills wrapped by commands
- Violates skills-first principle

❌ **Non-self-sufficient skills**
- Skills requiring external orchestration
- Violates autonomy principle

❌ **Context: fork misuse**
- Simple tasks using context: fork
- Missing dynamic context injection

❌ **Linear chain brittleness** ( workflows >3 steps with decision points)
- Deep skill chains for reasoning tasks
- Single point of failure in chain
- **Recommendation**: Use Hub-and-Spoke or forked workers for complex workflows
- **Exception**: Linear chains are acceptable for deterministic utility workflows (e.g., validate → format → commit)

❌ **Missing URL fetching**
- Skills without mandatory documentation
- No URL currency validation

❌ **Architecture violations**
- Non-skills-first patterns
- Legacy command-first structure

## Integration Points

This validator is designed to work with:

- **toolkit-architect** - Complete .claude/ lifecycle validation
- **skills-architect** - Skills-specific validation
- **hooks-architect** - Hooks-specific validation
- **mcp-architect** - MCP-specific validation
- **subagents-architect** - Subagents-specific validation
- **toolkit-worker** - Parallel validation

## Usage

### Standalone Validation
```bash
# Validate entire plugin
/toolkit-quality-validator /path/to/project
```

### Integrated Validation
```yaml
# In orchestrator workflows
Load toolkit-quality-validator

Validate:
- Quality score: {score}/10
- Standards compliance: {status}
- Blocking issues: {count}

Continue only if score ≥ 8/10
```

## Quality Gates

**Minimum Score: 8/10** for production readiness

- **9-10**: Excellent - Production ready, all best practices
- **7-8**: Good - Minor improvements needed
- **5-6**: Fair - Significant improvements recommended
- **3-4**: Poor - Major rework required
- **0-2**: Failing - Complete rebuild recommended

---

## Task-Integrated Quality Validation

For complex quality audits requiring visual progress tracking and dependency enforcement, use TaskList integration:

**When to use**:
- Multi-component validation (skills + subagents + hooks + MCP)
- Need to enforce scan completion before validation
- Want visual progress tracking (Ctrl+T)
- Quality tracking across audit iterations

**Workflow description**:

Use TaskList to create a multi-phase validation workflow. First use TaskCreate to establish the structure scan task that identifies all .claude/ components. Then use TaskCreate to set up parallel component validation tasks for skills (15 points), subagents (10 points), hooks (10 points), and MCP (5 points) — configure these with dependencies so they wait for the structure scan to complete. Use TaskCreate to establish the standards compliance check (20 points) with dependencies on all component validations. Finally use TaskCreate to create the final report generation task that depends on the standards check. Use TaskUpdate to mark tasks as completed as each phase finishes, and use TaskList to check overall progress.

**Critical dependency**: Component validation tasks must be configured to wait for the structure scan task to complete. The standards check task must wait for all component validation tasks. This ensures comprehensive evaluation before scoring begins and a complete picture before final scoring.

**Task tracking provides**:
- Visual progression through validation phases (visible in Ctrl+T)
- Dependency enforcement (tasks block until dependencies complete)
- Persistent quality tracking across audit iterations
- Clear phase completion markers
