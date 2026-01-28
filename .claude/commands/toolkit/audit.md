---
description: "Universal auditor for commands and skills. Auto-detects target from context and routes to appropriate reference based on file extension. Use for quality validation, portability checks, and best practices compliance."
argument-hint: [target-path or "auto" for context detection]
---

# Universal Auditor

<mission_control>
<objective>Audit invocable components (commands/skills) with automatic routing based on file extension</objective>
<success_criteria>Audit completes with findings, severity classification, and actionable recommendations</success_criteria>
</mission_control>

## Context Inference

### Auto-Detection Priority

1. **Recent creation detection:**
   - `Grep: "\.md\|\.SKILL" conversation history` - Check for recent .md operations
   - `Glob: commands/*.md` (last 10 turns) - Look for creation in commands/
   - `Glob: skills/*/SKILL.md` - Look for SKILL.md operations
   - If found → Auto-target that component

2. **Argument handling:**
   - `Extract: $ARGUMENTS` - If path → Target that path
   - If "auto" → `Glob: commands/*.md skills/*/SKILL.md` → Sort by mtime → Target most recent
   - If empty → Use recent creation detection

3. **Search strategy** (when needed):
   - `Glob: commands/**/*.md` and `skills/*/SKILL.md`
   - `Bash: ls -lt | head -10` - Sort by modification time
   - Target most recent

## Auto-Reference Router

<router>
<extension_detect>
<rule>.md file in commands/ → Invoke invocable-development skill and read frontmatter-reference.md and executable-examples.md from references folder</rule>
<rule>SKILL.md in skills/ → Invoke invocable-development skill and read quality-framework.md and workflows-audit.md from references folder</rule>
<rule>Unknown extension → Use default invocable-development patterns</rule>
</extension_detect>

<auto_load>
<pattern name="command_reference">
<match>.md in commands/</match>
<files>

- references/frontmatter-reference.md
- references/executable-examples.md
- references/quality-framework.md
  </files>
  </pattern>
  <pattern name="skill_reference">
  <match>SKILL.md</match>
  <files>
- references/quality-framework.md
- references/workflows-audit.md
- references/progressive-disclosure.md
  </files>
  </pattern>
  </auto_load>
  </router>

## Audit Workflow

### Phase 1: Target Identification

Apply context inference rules:

- `Auto-detect: when possible` (don't ask)
- `AskUserQuestion: only if ambiguous`
- `Proceed: with confidence when clear`

### Phase 2: Reference Routing

Based on target file extension:

| Extension            | Action                                                                                                                 |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| `.md` (commands/)    | Invoke invocable-development skill and read frontmatter-reference.md and executable-examples.md from references folder |
| `SKILL.md` (skills/) | Invoke invocable-development skill and read quality-framework.md and workflows-audit.md from references folder         |
| Unknown              | Apply general invocable-development patterns                                                                           |

### Phase 3: Audit Execution

Evaluate component for:

- **Structure**: Frontmatter compliance, folder organization
- **Content**: What-When-Not description, Delta Standard
- **Quality**: Autonomy, discoverability, portability
- **References**: Progressive disclosure, reference file usage

### Phase 4: Results Presentation

Present findings with:

- Severity classification (Critical/High/Medium/Low)
- Specific file:line locations
- Actionable recommendations
- Auto-fix options when applicable

## Intelligence Rules

**Trust user context:**

- If user just created component → Audit that component (don't ask)
- If user provides path → Audit that path (don't ask)
- If user invokes "in void" → Search recent, then ask if needed

**Minimize questions:**

- Auto-detect when possible
- Ask only when genuinely ambiguous
- Prefer confirmation over generation

## Usage Patterns

**Auto-detect (after creation):**

```
/toolkit:audit
[Detects recent component, audits automatically]
```

**Explicit path:**

```
/toolkit:audit commands/build/fix.md
/toolkit:audit .claude/skills/my-skill
```

**Auto-search:**

```
/toolkit:audit auto
[Finds most recently modified component]
```

## Success Criteria

- Correct component targeted without user input (when possible)
- Automatic reference loading based on file extension
- Comprehensive audit completed
- Findings presented with severity classification
- User cognitive load minimized

---

<critical_constraint>
MANDATORY: Auto-detect target from context when possible
MANDATORY: Route to appropriate references based on file extension
MANDATORY: Evaluate frontmatter, description format, and portability
MANDATORY: Minimize questions - trust AI inference
No exceptions. Router enables single command for all invocable component audits.
</critical_constraint>
