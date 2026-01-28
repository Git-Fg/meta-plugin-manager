---
description: "Audit skills for quality, portability, and best practices compliance. Use when validating skills or after skill creation."
argument-hint: [skill-path or "auto" for recent]
---

# Audit Skill

<mission_control>
<objective>Audit skills for comprehensive quality validation with context-aware target detection</objective>
<success_criteria>Skill audit completes with findings, severity classification, and actionable recommendations</success_criteria>
</mission_control>

## Context Inference

### Auto-Detection Priority

1. **Was a skill just created?**
   - Check conversation for recent file operations
   - Look for SKILL.md creation in last 10 turns
   - If found → Auto-target that skill

2. **Is $ARGUMENTS provided?**
   - If path → Target that skill
   - If "auto" → Search for most recently modified skill
   - If empty → Use recent creation detection

3. **Search strategy** (when needed):
   - Use Glob to find all SKILL.md files
   - Sort by modification time
   - Target most recent

## Audit Workflow

### Phase 1: Target Identification

Apply context inference rules in priority order:

- Auto-detect when possible (don't ask)
- Confirm with user only if ambiguous
- Proceed with confidence when clear

### Phase 2: Audit Execution

Invoke skill-auditor subagent:

- Pass target skill path
- Subagent performs comprehensive evaluation
- Loads reference documentation independently

### Phase 3: Results Presentation

Present findings with:

- Severity classification (Critical/High/Medium/Low)
- Specific file:line locations
- Actionable recommendations
- Auto-fix options when applicable

## Intelligence Rules

**Trust user context:**

- If user just created skill → Audit that skill (don't ask)
- If user provides path → Audit that path (don't ask)
- If user invokes "in void" → Search recent, then ask if needed

**Minimize questions:**

- Auto-detect when possible
- Ask only when genuinely ambiguous
- Prefer confirmation over generation

## Usage Patterns

**Auto-detect (after creation):**

```
/toolkit:audit:skill
[Detects recent skill, audits automatically]
```

**Explicit path:**

```
/toolkit:audit:skill .claude/skills/my-skill
```

**Auto-search:**

```
/toolkit:audit:skill auto
[Finds most recently modified skill]
```

## Success Criteria

- Correct skill targeted without user input (when possible)
- Comprehensive audit completed
- Findings presented with severity classification
- User cognitive load minimized

<critical_constraint>
MANDATORY: Auto-detect target from context when possible
MANDATORY: Invoke skill-auditor subagent for evaluation
MANDATORY: Minimize questions - trust AI inference
No exceptions. Context awareness is the primary feature.
</critical_constraint>
