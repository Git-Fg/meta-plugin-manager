---
description: "Perform three-way meta-critic review (Request vs Delivery vs Standards) for commands. Use when validating quality or detecting drift."
argument-hint: [command-path or "auto" for conversation context]
---

# Critique Command

<mission_control>
<objective>Perform three-way meta-critic review for command quality validation and drift detection</objective>
<success_criteria>Three-way comparison completed with specific findings, standards citations, and actionable recommendations</success_criteria>
</mission_control>

## Context Inference

### Auto-Detection Priority

1. **Recent command creation or modification?**
   - Detect recent .md operations in commands/
   - Identify the command involved
   - Auto-target for review

2. **User providing feedback?**
   - Analyze conversation for dissatisfaction
   - "This doesn't feel right"
   - "Something's off"
   - Trigger critique to diagnose

3. **Explicit invocation?**
   - $ARGUMENTS = path → Target that command
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
   - Load `invocable-development` skill for standards
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
/toolkit:critique:command
[Detects recent command, performs review]
```

**Explicit path:**

```
/toolkit:critique:command commands/build/fix.md
```

**Context analysis:**

```
/toolkit:critique:command auto
[Analyzes conversation for what to review]
```

**User feedback trigger:**

```
User: "This doesn't feel right"
AI: [Suggests] /toolkit:critique:command
```

## Success Criteria

- Three-way comparison completed
- Specific file:line references provided
- Standards cited from invocable-development
- Actionable recommendations formulated
- User understands issues and next steps

<critical_constraint>
MANDATORY: Load meta-critic skill for three-way comparison
MANDATORY: Auto-detect context from conversation when possible
MANDATORY: Cite specific standards from invocable-development
No exceptions. Critique validates alignment between request, delivery, and standards.
</critical_constraint>
