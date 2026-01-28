---
description: "Perform quality audit (Request vs Delivery vs Standards + six-phase gates) for any invocable component. Auto-detects target and loads quality-standards skill for validation and drift detection."
argument-hint: [target-path or "auto" for conversation context]
---

# Universal Critique

<mission_control>
<objective>Perform quality audit with three-way comparison and six-phase gates for validation and drift detection</objective>
<success_criteria>Three-way comparison completed + six-phase gates passed with specific findings, standards citations, and actionable recommendations</success_criteria>
</mission_control>

## Context Inference

### Auto-Detection Priority

1. **Recent component detection:**
   - `Grep: "\.md\|SKILL" conversation history` - Detect recent operations
   - `Identify: component involved` - Extract target path
   - `Auto-target: for review` - Proceed without asking

2. **User feedback trigger:**
   - `Grep: "not.*right\|not.*what\|feel.*off" conversation` - Analyze dissatisfaction
   - If found → Trigger critique to diagnose

3. **Explicit invocation:**
   - `Extract: $ARGUMENTS` - If path → Target that component
   - If "auto" → `Analyze: conversation` for context
   - If empty → `Use: recent work`

## Auto-Reference Router

<router>
<extension_detect>
<rule>.md file in commands/ → Load `invocable-development` for standards comparison</rule>
<rule>SKILL.md in skills/ → Load `quality-standards` skill and `invocable-development` for standards</rule>
<rule>Unknown extension → Use quality-standards skill for three-way analysis + gates</rule>
</extension_detect>
</router>

## Critique Workflow

### Phase 1: Target and Reference Setup

- `Auto-detect: target component`
- `Route: based on file extension`
- `Skill: quality-standards` for three-way comparison + gates

### Phase 2: Six-Phase Gate Execution

quality-standards executes gates in sequence:

| Phase | Gate     | Check                | Evidence Required |
| ----- | -------- | -------------------- | ----------------- |
| 1     | BUILD    | Compilation succeeds | Exit code 0       |
| 2     | TYPE     | Type safety          | 0 type errors     |
| 3     | LINT     | Code style           | 0 errors          |
| 4     | TEST     | Tests pass           | All pass, ≥80%    |
| 5     | SECURITY | No secrets/vulns     | 0 issues          |
| 6     | DIFF     | Clean changes        | Clean diff        |

### Phase 3: Three-Way Analysis

quality-standards performs:

1. **Request Extraction**
   - `Read: conversation history` - What did user ask for?
   - `Extract: constraints specified`
   - `Identify: goals implied`

2. **Delivery Analysis**
   - `Read: implementation` - What was implemented?
   - `Trace: execution path` - How was it executed?
   - `Compare: against request` - What deviations occurred?

3. **Standards Comparison**
   - `Skill: invocable-development` - Load standards
   - `Compare: delivery against standards`
   - `Identify: gaps and violations`

### Phase 4: Findings Formulation

quality-standards generates structured report:

```markdown
## Quality Audit Review

### Six-Phase Gate Results

| Phase | Gate  | Result |
| ----- | ----- | ------ |
| 1     | BUILD | PASS   |
| 2     | TYPE  | PASS   |
| ...   | ...   | ...    |

### Critical Issues (Blocking)

[Specific issues with exact locations and fixes]

### High Priority Issues

[Specific issues with actionable recommendations]

### Medium Priority Issues

[Specific issues with improvement suggestions]

### Low Priority Issues

[Minor improvements or optimizations]
```

### Phase 5: Resolution

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
- Run verification commands

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

- Six-phase gates completed in sequence
- Three-way comparison completed
- Specific file:line references provided
- Standards cited from invocable-development
- Actionable recommendations formulated
- User understands issues and next steps

---

<critical_constraint>
MANDATORY: Load quality-standards skill for three-way comparison + gates
MANDATORY: Run all six phases before claiming verification complete
MANDATORY: Auto-detect context from conversation when possible
MANDATORY: Cite specific standards from invocable-development
MANDATORY: Route to appropriate references based on file extension
No exceptions. Critique validates alignment between request, delivery, and standards.
</critical_constraint>
