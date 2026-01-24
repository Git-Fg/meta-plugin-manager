# Quality Framework

Skills must score ≥80/100 on 11-dimensional framework before production.

**Philosophy Foundation**: Quality frameworks guide but don't replace intelligent decision-making. See @.claude/rules/philosophy.md for core principles that inform quality evaluation.

## When to Apply

**FOR DIRECT USE**: Apply this framework when:
- Creating new skills
- Auditing existing skills before production
- Evaluating skill quality for deployment
- Ensuring autonomous execution (80-95% without questions)

**TO KNOW WHEN**: Recognize that:
- Quality frameworks guide but don't replace intelligent decision-making
- Context matters - some dimensions may be more critical than others
- TaskList enables quality validation for complex multi-skill workflows
- Progressive disclosure affects what belongs in Tier 1 vs Tier 2/3

## 11-Dimensional Framework

1. **Knowledge Delta** - Expert-only vs Claude-obvious
2. **Autonomy** - 80-95% completion without questions
3. **Discoverability** - Clear description with triggers
4. **Progressive Disclosure** - Tier 1/2/3 properly organized
5. **Clarity** - Unambiguous instructions
6. **Completeness** - Covers all scenarios
7. **Standards Compliance** - Follows Agent Skills spec
8. **Security** - Validation, safe execution
9. **Performance** - Efficient workflows
10. **Maintainability** - Well-structured
11. **Innovation** - Unique value

## Autonomy Scoring (from skills/test-runner/references/autonomy-testing.md)

**From test-output.json, check line 3:**
```json
"permission_denials": [
  {
    "tool_name": "AskUserQuestion",
    "tool_input": { "questions": [...] }
  }
]
```

**Autonomy levels:**
- 95% (Excellent): 0-1 questions
- 85% (Good): 2-3 questions
- 80% (Acceptable): 4-5 questions
- <80% (Fail): 6+ questions

**What counts as a question:**
- ❌ "Which file should I modify?"
- ❌ "What should I name this variable?"
- ✅ Reading files for context
- ✅ Running bash commands as part of workflow

## Progressive Disclosure (from skills-architect/references/progressive-disclosure.md)

**Tier 1** (~100 tokens): YAML frontmatter - always loaded
- `name`, `description`, `user-invocable`

**Tier 2** (<500 lines): SKILL.md - loaded on activation
- Core implementation with workflows and examples

**Tier 3** (on-demand): references/ - loaded when needed
- Deep details, troubleshooting, examples

**Rule**: Create references/ only when SKILL.md + references >500 lines total.

---

## 2026 Validation Standards

Validate .claude/ configuration quality and compliance with skills-first architecture and 2026 best practices.

### Dimensional Scoring (0-10 Scale)

#### Structural (30% - 30 points)

**Skills-first architecture** (10 pts)
- ✅ Skills are primary building blocks
- ✅ Subagents used only for isolation/parallelism
- ✅ No command-first patterns

**Directory structure** (10 pts)
- ✅ Skills directory present
- ✅ Standard organization
- ✅ Clear component separation

**Progressive disclosure** (10 pts)
- ✅ Tier 1: Metadata (~100 tokens)
- ✅ Tier .md (<35,2: SKILL000 chars)
- ✅ Tier 3: References (on-demand)

#### Components (50% - 50 points)

**Skill quality** (15 pts)
- ✅ YAML frontmatter valid
- ✅ Clear description with triggers
- ✅ Autonomous execution
- ✅ Progressive disclosure

**Subagent quality** (10 pts)
- ✅ Context: fork usage appropriate
- ✅ Dynamic context injection
- ✅ Clear coordination patterns

**Hook quality** (10 pts)
- ✅ Proper configuration
- ✅ Security best practices
- ✅ Appropriate event matching

**MCP quality** (5 pts)
- ✅ Valid configuration
- ✅ Proper transport (2026)
- ✅ Security considerations

**Architecture compliance** (10 pts)
- ✅ Skills-first patterns
- ✅ No anti-patterns
- ✅ Modern orchestration

#### Standards (20% - 20 points)

**URL currency** (10 pts)
- ✅ Documentation links current (2026)
- ✅ Mandatory URL fetching sections
- ✅ Strong language (MUST/REQUIRED)

**Best practices** (10 pts)
- ✅ Model-agnostic code
- ✅ Cost optimization
- ✅ Autonomy-first design

### Anti-Pattern Detection

❌ **Command wrapper anti-pattern**
- Skills wrapped by commands
- Violates skills-first principle

❌ **Non-self-sufficient skills**
- Skills requiring external orchestration
- Violates autonomy principle

❌ **Context: fork misuse**
- Simple tasks using context: fork
- Missing dynamic context injection

❌ **Linear chain brittleness** (workflows >3 steps with decision points)
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

### Validation Process

#### Step 1: Fetch Documentation
```bash
# Read primary documentation
simpleWebFetch https://code.claude.com/docs/en/skills
simpleWebFetch https://code.claude.com/docs/en/plugins
```

#### Step 2: Structural Check
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

#### Step 3: Component Validation

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

#### Step 4: Standards Check

**2026 Compliance**:
- Progressive disclosure (Tier 1/2/3)
- Autonomy-first design
- Model-agnostic code
- Cost optimization (<$50/rotation)

**URL Currency**:
- All documentation links current
- Mandatory URL sections
- Strong language used

### Quality Gates

**Minimum Score: 8/10** for production readiness

- **9-10**: Excellent - Production ready, all best practices
- **7-8**: Good - Minor improvements needed
- **5-6**: Fair - Significant improvements recommended
- **3-4**: Poor - Major rework required
- **0-2**: Failing - Complete rebuild recommended

### Validation Report Format

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

### Context & Tool Management

**MCP Configuration Hygiene:**
- ✅ MCP servers organized by purpose (authoring/research/validation)
- ✅ Documentation references proper enable/disable patterns
- ✅ No "always-on" heavy MCPs without justification

**Session Management Guidance:**
- ✅ Clear task-to-MCP mapping documented
- ✅ Phase-based enable/disable instructions present
- ✅ Warning about "too many tools active" included
