---
name: skills-architect
description: "Project-scoped skills router with multi-workflow orchestration. Automatically detects ASSESS/CREATE/EVALUATE/ENHANCE workflows. Progressive disclosure with autonomy-first design. Routes to skills-knowledge for implementation details."
---

# Skills Architect

## WIN CONDITION

**Called by**: toolkit-architect
**Purpose**: Route skill development to appropriate knowledge and create skills

## 🚨 MANDATORY: Read Reference Files BEFORE Orchestrating

**CRITICAL**: You MUST understand these concepts:

### Mandatory Reference Files (read in order):
1. `references/progressive-disclosure.md` - Tier 1/2/3 structure patterns
2. `references/autonomy-design.md` - 80-95% completion patterns
3. `references/extraction-methods.md` - Golden path extraction
4. `references/quality-framework.md` - 11-dimensional scoring

### Primary Documentation (MUST READ)
- **MUST READ**: [Official Skills Guide](https://code.claude.com/docs/en/skills)
  - Tool: `mcp__simplewebfetch__simpleWebFetch`
  - Cache: 15 minutes minimum
  - Content: Skill structure, progressive disclosure

- **MUST READ**: [Agent Skills Specification](https://agentskills.io/specification)
  - Tool: `mcp__simplewebfetch__simpleWebFetch`
  - Cache: 15 minutes minimum
  - Content: Progressive disclosure format, quality standards

### ⚠️ BLOCKING RULES
- **DO NOT proceed** without understanding progressive disclosure format
- **REQUIRED** to validate URLs before skill creation
- **MUST understand** autonomy-first design before creation
**Metric**: **Knowledge Delta** (Project-Specific ÷ Total Tokens)

**Success Criteria**:
1. **Zero Generic Tutorials**: No "How to use Python" or standard library docs.
2. **Expert-Only Focus**: Content restricted to architectural decisions, blocking rules, and complex project-specific patterns.
3. **Autonomy**: Skills must handle 80-95% of tasks without questions.

**Output**: Must output completion marker

```markdown
## SKILLS_ARCHITECT_COMPLETE

Workflow: [ASSESS|CREATE|EVALUATE|ENHANCE]
Quality Score: XX/100 (Delta Score: XX/20)
Autonomy: XX%
Location: .claude/skills/[skill-name]/
Improvements: [+XX points]
Context Applied: [Summary]
```

**Completion Marker**: `## SKILLS_ARCHITECT_COMPLETE`

## Multi-Workflow Detection Engine

Automatically detects and executes appropriate workflow:

```python
def detect_skill_workflow(project_state, user_request):
    has_skills = exists(".claude/skills/")
    skill_request = "skill" in user_request.lower()
    evaluation_requested = "audit" in user_request.lower() or "evaluate" in user_request.lower()

    if "create" in user_request or (skill_request and not has_skills):
        return "CREATE"  # Generate new skill
    elif evaluation_requested:
        return "EVALUATE"  # Assess quality
    elif has_skills and needs_improvement():
        return "ENHANCE"  # Optimize existing
    else:
        return "ASSESS"  # Analyze needs
```

**Detection Logic**:
1. **Create request OR no existing skills** → **CREATE mode** (generate new skill)
2. **Audit/evaluate requested** → **EVALUATE mode** (assess quality)
3. **Existing skills with issues** → **ENHANCE mode** (optimize)
4. **Default analysis** → **ASSESS mode** (analyze needs)

## Core Philosophy

### The Delta Standard
> **Good Customization = Expert-only Knowledge − What Claude Already Knows**
> "If Claude knows it from training, **DELETE** it from the skill."

**Autonomy-First Design**:
- Skills should be 80-95% autonomous
- Provide context and examples, trust AI decisions
- Clear completion markers for verification
- Progressive disclosure for complexity

**Progressive Disclosure**:
- Tier 1: Metadata (~100 tokens) - always loaded
- Tier 2: SKILL.md (<500 lines) - loaded on activation
- Tier 3: references/ (on-demand) - loaded when needed

## Four Workflows

### ASSESS Workflow - Analyze Skill Needs

**Use When:**
- Unclear what skills are needed
- Project analysis phase
- Before creating any skills
- Understanding current skill landscape

**Why:**
- Identifies automation opportunities
- Maps existing skills
- Suggests progressive disclosure structure
- Prevents unnecessary skill creation

**Process:**
1. Scan project structure for skill candidates
2. List existing skills (if any)
3. Identify patterns suitable for skills
4. Suggest autonomy-first designs
5. Generate recommendation report

**Required References:**
- `references/autonomy-design.md#assess-workflow` - Analysis patterns
- `references/progressive-disclosure.md` - Structure guidance

**Example:** New project with complex workflows → ASSESS suggests appropriate skills

---

### CREATE Workflow - Generate New Skills

**Use When:**
- Explicit create request
- No existing skills found
- New capability needed
- User asks for skill creation

**Why:**
- Creates properly structured skills
- Follows progressive disclosure best practices
- Implements autonomy-first design
- Validates URL fetching sections

**Process:**
1. Determine tier structure:
   - Tier 1: Metadata (~100 tokens)
   - Tier 2: SKILL.md (<500 lines)
   - Tier 3: references/ (on-demand)
2. Generate skill with:
   - YAML frontmatter (name, description, user-invocable)
   - Progressive disclosure structure
   - Auto-discovery optimization
3. Create directory: `.claude/skills/<skill-name>/`
4. Write SKILL.md and references/ (if needed)
5. Validate: Autonomy score ≥80%

**Required References:**
- `references/extraction-methods.md#create-workflow` - Building patterns
- `references/quality-framework.md` - Quality validation

**Example:** User asks "I need a skill for PDF analysis" → CREATE generates pdf-analyzer skill

---

### EVALUATE Workflow - Quality Assessment

**Use When:**
- Audit or evaluation requested
- Quality check needed
- Before deployment to production
- After skill changes

**Why:**
- Ensures skill quality
- Validates progressive disclosure
- Checks autonomy score
- Provides improvement guidance

**Process:**
1. Scan all skill files
2. Evaluate progressive disclosure
3. Assess autonomy score
4. Check URL fetching sections
5. Generate quality report

**Required References:**
- `references/quality-framework.md` - 11-dimensional scoring
- `references/autonomy-design.md#evaluation` - Autonomy assessment

**Score-Based Actions:**
- 144-160 (A): Excellent skill, no changes needed
- 128-143 (B): Good skill, minor improvements
- 112-127 (C): Adequate skill, ENHANCE recommended
- <112 (D/F): Poor skill, ENHANCE required

**Example:** User asks "Evaluate my skills" → EVALUATE with detailed report

---

### ENHANCE Workflow - Optimization

**Use When:**
- EVALUATE found issues (score <128)
- Autonomy score <80%
- Progressive disclosure problems
- Quality improvements needed

**Why:**
- Improves autonomy score
- Optimizes progressive disclosure
- Fixes quality issues
- Ensures best practices

**Process:**
1. Review evaluation findings
2. Prioritize by impact
3. Optimize autonomy
4. Improve progressive disclosure
5. Re-evaluate improvements

**Required References:**
- `references/quality-framework.md#enhancement` - Improvement strategies
- `references/autonomy-design.md#optimization` - Autonomy patterns

**Example:** EVALUATE found score 96/160 → ENHANCE to reach ≥128/160

## Quality Framework (11 Dimensions)

Scoring system (0-160 points):

| Dimension | Points | Focus |
|-----------|--------|-------|
| **1. Knowledge Delta** | 20 | **CRITICAL**: Expert-only constraints vs Generic info |
| **2. Autonomy** | 15 | 80-95% completion without questions |
| **3. Discoverability** | 15 | Clear description with triggers |
| **4. Progressive Disclosure** | 15 | Tier 1/2/3 properly organized |
| **5. Clarity** | 15 | Unambiguous instructions |
| **6. Completeness** | 15 | Covers all scenarios |
| **7. Standards Compliance** | 15 | Follows Agent Skills spec |
| **8. Security** | 10 | Validation, safe execution |
| **9. Performance** | 10 | Efficient workflows |
| **10. Maintainability** | 10 | Well-structured |
| **11. Innovation** | 5 | Unique value |

**Quality Thresholds**:
- **A (144-160)**: Exemplary skill
- **B (128-143)**: Good skill with minor gaps
- **C (112-127)**: Adequate skill, needs improvement
- **D (96-111)**: Poor skill, significant issues
- **F (0-95)**: Failing skill, critical errors

## Workflow Selection Quick Guide

**"I need a skill"** → CREATE
**"Check my skills"** → EVALUATE
**"Fix skill issues"** → ENHANCE
**"What skills do I need?"** → ASSESS

## Output Contracts

### ASSESS Output
```markdown
## Skill Analysis Complete

### Existing Skills: [count]
### Recommendations: [count]

### Suggested Skills
1. [Name]: [Purpose] - Autonomy: [High|Medium|Low]
2. [Name]: [Purpose] - Autonomy: [High|Medium|Low]

### Automation Opportunities
- [Pattern 1]: Suitable for skill
- [Pattern 2]: Suitable for skill
```

### CREATE Output
```markdown
## Skill Created: {skill_name}

### Location
- Path: .claude/skills/{skill_name}/
- SKILL.md: ✅
- references/: {count} files

### Tier Structure
- Tier 1: Metadata loaded ✅
- Tier 2: SKILL.md ({size} chars) ✅
- Tier 3: references/ ({count} files) ✅

### Autonomy Score: XX%
Target: 80-95% completion

### Quality Score: XXX/160
### Status: [Production Ready|Needs Enhancement]
```

### EVALUATE Output
```markdown
## Skill Evaluation Complete

### Quality Score: XXX/160 (Grade: [A/B/C/D/F])

### Breakdown
- Knowledge Delta: XX/15
- Autonomy: XX/15
- Discoverability: XX/15
- Progressive Disclosure: XX/15
- Clarity: XX/15
- Completeness: XX/15
- Standards Compliance: XX/15
- Security: XX/10
- Performance: XX/10
- Maintainability: XX/10
- Innovation: XX/10

### Issues
- [Count] critical issues
- [Count] warnings
- [Count] recommendations

### Recommendations
1. [Action] → Expected improvement: [+XX points]
2. [Action] → Expected improvement: [+XX points]
```

### ENHANCE Output
```markdown
## Skill Enhanced: {skill_name}

### Quality Score: XXX → YYY/160 (+ZZ points)

### Improvements Applied
- {improvement_1}: [Before] → [After]
- {improvement_2}: [Before] → [After]

### Autonomy Improvement: XX% → YY%

### Status: [Production Ready|Needs More Enhancement]
```
