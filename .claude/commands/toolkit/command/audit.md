---
description: "Audit commands for quality, frontmatter compliance, and best practices. Use when validating commands or after command creation."
argument-hint: [command-path or "auto" for recent]
---

# Command Audit

<mission_control>
<objective>Audit commands for comprehensive quality validation with context-aware target detection</objective>
<success_criteria>Command audit completes with findings, severity classification, and actionable recommendations</success_criteria>
</mission_control>

## Context Inference

### Auto-Detection Priority

1. **Was a command just created?**
   - Check conversation for recent file operations
   - Look for .md creation in commands/ in last 10 turns
   - If found → Auto-target that command

2. **Is $ARGUMENTS provided?**
   - If path → Target that command
   - If "auto" → Search for most recently modified command
   - If empty → Use recent creation detection

3. **Search strategy** (when needed):
   - Use Glob to find all .md files in commands/
   - Sort by modification time
   - Target most recent

## Audit Workflow

### Phase 1: Target Identification

Apply context inference rules:

- Auto-detect when possible (don't ask)
- Confirm with user only if ambiguous
- Proceed with confidence when clear

### Phase 2: Audit Execution

Evaluate command for:

- Frontmatter compliance (name, description)
- What-When-Not description format
- No command/skill name references in description
- Folder structure appropriateness
- Content quality and clarity

### Phase 3: Results Presentation

Present findings with:

- Severity classification (Critical/High/Medium/Low)
- Specific file:line locations
- Actionable recommendations
- Auto-fix options when applicable

## Intelligence Rules

**Trust user context:**

- If user just created command → Audit that command (don't ask)
- If user provides path → Audit that path (don't ask)
- If user invokes "in void" → Search recent, then ask if needed

**Minimize questions:**

- Auto-detect when possible
- Ask only when genuinely ambiguous
- Prefer confirmation over generation

## Usage Patterns

**Auto-detect (after creation):**

```
/toolkit:command:audit
[Detects recent command, audits automatically]
```

**Explicit path:**

```
/toolkit:command:audit commands/build/fix.md
```

**Auto-search:**

```
/toolkit:command:audit auto
[Finds most recently modified command]
```

## Success Criteria

- Correct command targeted without user input (when possible)
- Comprehensive audit completed
- Findings presented with severity classification
- User cognitive load minimized

<critical_constraint>
MANDATORY: Auto-detect target from context when possible
MANDATORY: Evaluate frontmatter, description format, and portability
MANDATORY: Minimize questions - trust AI inference
No exceptions. Context awareness is the primary feature.
</critical_constraint>
