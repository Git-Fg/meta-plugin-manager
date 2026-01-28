---
description: "Perform three-way meta-critic review (Request vs Delivery vs Standards) for any invocable component. Auto-detects target and loads meta-critic skill for quality validation and drift detection."
argument-hint: [target-path or "auto" for conversation context]
---

# Universal Critique

<mission_control>
<objective>Perform three-way meta-critic review for quality validation and drift detection</objective>
<success_criteria>Three-way comparison completed with specific findings, standards citations, and actionable recommendations</success_criteria>
</mission_control>

## Context Inference

### Auto-Detection Priority

1. **Recent component creation or modification?**
   - Detect recent .md or SKILL.md operations
   - Identify the component involved
   - Auto-target for review

2. **User providing feedback?**
   - Analyze conversation for dissatisfaction
   - "This doesn't feel right"
   - "Something's off"
   - "Not what I asked for"
   - Trigger critique to diagnose

3. **Explicit invocation?**
   - $ARGUMENTS = path → Target that component
   - $ARGUMENTS = "auto" → Analyze conversation for context
   - $ARGUMENTS empty → Use recent work

## Auto-Reference Router

<router>
<extension_detect>
<rule>.md file in commands/ → Load `invocable-development` for standards comparison</rule>
<rule>SKILL.md in skills/ → Load `meta-critic` skill and `invocable-development` for standards</rule>
<rule>Unknown extension → Use meta-critic skill for three-way analysis</rule>
</extension_detect>
</router>

## Critique Workflow

### Phase 1: Target and Reference Setup

- Auto-detect target component
- Route to appropriate references based on file extension
- Load `meta-critic` skill for three-way comparison

### Phase 2: Three-Way Analysis

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
   - Load invocable-development skill for standards
   - Compare delivery against standards
   - Identify gaps and violations

### Phase 3: Findings Formulation

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

### Phase 4: Resolution

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
/toolkit:critique
[Detects recent component, performs review]
```

**Explicit path:**

```
/toolkit:critique commands/build/fix.md
/toolkit:critique .claude/skills/my-skill
```

**Context analysis:**

```
/toolkit:critique auto
[Analyzes conversation for what to review]
```

**User feedback trigger:**

```
User: "This doesn't feel right"
AI: [Suggests] /toolkit:critique
```

## Success Criteria

- Three-way comparison completed
- Specific file:line references provided
- Standards cited from invocable-development
- Actionable recommendations formulated
- User understands issues and next steps

---

<critical_constraint>
MANDATORY: Load meta-critic skill for three-way comparison
MANDATORY: Auto-detect context from conversation when possible
MANDATORY: Cite specific standards from invocable-development
MANDATORY: Route to appropriate references based on file extension
No exceptions. Critique validates alignment between request, delivery, and standards.
</critical_constraint>
