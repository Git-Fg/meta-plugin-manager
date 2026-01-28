---
description: "Perform three-way meta-critic review (Request vs Delivery vs Standards) for skills. Use when validating quality or detecting drift."
argument-hint: [skill-path or "auto" for conversation context]
---

# Critique Skill

<mission_control>
<objective>Perform three-way meta-critic review for quality validation and drift detection</objective>
<success_criteria>Three-way comparison completed with specific findings, standards citations, and actionable recommendations</success_criteria>
</mission_control>

## Context Inference

### Auto-Detection Priority

1. **Recent skill creation or modification?**
   - Detect recent SKILL.md operations
   - Identify the skill involved
   - Auto-target for review

2. **User providing feedback?**
   - Analyze conversation for dissatisfaction
   - "This doesn't feel right"
   - "Something's off"
   - "Not what I asked for"
   - Trigger critique to diagnose

3. **Explicit invocation?**
   - $ARGUMENTS = path → Target that skill
   - $ARGUMENTS = "auto" → Analyze conversation for context
   - $ARGUMENTS empty → Use recent work

## Critique Workflow

### Phase 1: Three-Way Analysis

Load `meta-critic` skill via Skill tool.

Meta-critic performs:

1. **Request Extraction**
   - What did user ask for?
   - What constraints specified?
   - What goals implied?

2. **Delivery Analysis**
   - What was implemented?
   - How was it executed?
   - What deviations occurred?

3. **Standards Comparison**
   - Load appropriate meta-development skill
   - Compare delivery against standards
   - Identify gaps and violations

### Phase 2: Findings Formulation

Meta-critic generates structured report:

```markdown
## Critique Review

### Critical Issues (Blocking)

[Specific issues with exact locations and fixes]

### High Priority Issues

[Specific issues with actionable recommendations]

### Medium Priority Issues

[Specific issues with improvement suggestions]

### Low Priority Issues

[Minor improvements or optimizations]
```

### Phase 3: Resolution

- Present findings with severity classification
- Offer to apply changes
- Verify corrections
- Confirm completion

## Intelligence Rules

**Autonomous investigation:**

- Scan conversation history
- Examine user requests
- Analyze agent actions
- Compare with standards

**Strategic questioning:**

- Ask when multiple interpretations exist
- Skip when investigation provides clarity
- Use AskUserQuestion for structured queries

## Usage Patterns

**Auto-detect (after creation):**

```
/toolkit:critique:skill
[Detects recent skill, performs review]
```

**Explicit path:**

```
/toolkit:critique:skill .claude/skills/my-skill
```

**Context analysis:**

```
/toolkit:critique:skill auto
[Analyzes conversation for what to review]
```

**User feedback trigger:**

```
User: "This doesn't feel right"
AI: [Suggests] /toolkit:critique:skill
```

## Success Criteria

- Three-way comparison completed
- Specific file:line references provided
- Standards cited from meta-development skills
- Actionable recommendations formulated
- User understands issues and next steps

<critical_constraint>
MANDATORY: Load meta-critic skill for three-way comparison
MANDATORY: Auto-detect context from conversation when possible
MANDATORY: Cite specific standards from meta-development skills
No exceptions. Critique validates alignment between request, delivery, and standards.
</critical_constraint>
