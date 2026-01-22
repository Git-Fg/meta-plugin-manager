---
name: skills-architect
description: "Progressive disclosure router for skills autonomy and SKILL.md structure. Use for creating, auditing, or refining skills with tier-based organization. Routes to skills-knowledge for implementation details. Do not use for simple documentation or basic markdown editing."
disable-model-invocation: true
---

# Skills Architect

Domain router for skills development with progressive disclosure and autonomy-first design.

## Actions

### create
**Creates new skills** with self-sufficient architecture

**Router Logic**:
1. See: [skills-knowledge](references/skills-knowledge.md)
2. Determine tier structure:
   - Tier 1: Metadata (~100 tokens)
   - Tier 2: SKILL.md (<35,000 chars)
   - Tier 3: references/ (on-demand)
3. Generate skill with:
   - YAML frontmatter (name, description, disable-model-invocation)
   - Progressive disclosure structure
   - Auto-discovery optimization
4. Validate: URL fetching sections, triggers

**Output Contract**:
```
## Skill Created: {skill_name}

### Tier Structure
- Tier 1: Metadata loaded
- Tier 2: SKILL.md ({size} chars)
- Tier 3: references/ ({count} files)

### Autonomy Score: {score}/10
Target: 80-95% completion without questions

### Progressive Disclosure
- Tier 1: ✅
- Tier 2: ✅
- Tier 3: ✅
```

### audit
**Audits skills** for quality and autonomy

**Router Logic**:
1. See: [skills-knowledge](references/skills-knowledge.md)
2. Check:
   - YAML frontmatter completeness
   - Progressive disclosure implementation
   - Autonomy score (80-95% completion)
   - Auto-discovery optimization
   - URL fetching sections
3. Generate audit with scoring

**Output Contract**:
```
## Skill Audit: {skill_name}

### Autonomy Assessment
- Completion without questions: {score}%
- Target: 80-95%

### Progressive Disclosure
- Tier 1 (Metadata): ✅/❌
- Tier 2 (SKILL.md): ✅/❌
- Tier 3 (references): ✅/❌

### Quality Issues
- {issue_1}
- {issue_2}

### Recommendations
- {recommendation_1}
- {recommendation_2}
```

### refine
**Improves skills** based on audit findings

**Router Logic**:
1. See: [skills-knowledge](references/skills-knowledge.md)
2. Review progressive disclosure
3. Enhance:
   - Metadata clarity
   - SKILL.md structure
   - references/ organization
   - Autonomy optimization
4. Validate improvements

**Output Contract**:
```
## Skill Refined: {skill_name}

### Improvements Applied
- {improvement_1}
- {improvement_2}

### Autonomy Improvement: {old_score}% → {new_score}%

### Progressive Disclosure Enhanced
- {enhancement_1}
- {enhancement_2}
```

## Core Principles

**Self-Sufficient Building Blocks**:
- Standalone invocation
- Command orchestration
- Subagent integration
- Skill chaining

**Progressive Disclosure**:
- Tier 1: Always loaded (metadata)
- Tier 2: Loaded on activation (SKILL.md)
- Tier 3: On-demand (references/)

**Autonomy-First**:
- 80-95% completion without questions
- Clear triggers and preconditions
- Deterministic execution

## Knowledge Base

**[Skills Knowledge](references/skills-knowledge.md)** - Best practices, patterns, and implementation details for skill development.

## Routing Criteria

**[Route to skills-knowledge](references/skills-knowledge.md)** when:
- Creating new skills
- Auditing existing skills
- Refining skill architecture
- Progressive disclosure questions

**Direct action** when:
- Simple skill instantiation
- Clear pattern application
- Standard structure generation
