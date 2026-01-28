---
name: command-development
description: "Create simple one-file commands for quick invocation and categorization. Use when single-file structure with folder nesting (/category:command) is sufficient."
---

<mission_control>
<objective>Create portable one-file commands with clear structure and organization</objective>
<success_criteria>Generated command has valid frontmatter, clear description, and works standalone</success_criteria>
</mission_control>

# Command Development

**Commands and Skills are the same system** - both are auto-invocable tools. The difference is structural:

**Commands:**

- Single `.md` file
- Folder nesting produces `/folder:subfolder:command` patterns
- Useful for categorization and quick access
- Best when content fits in one file (~500-1500 words)

**Skills:**

- Folder with `SKILL.md` + optional `workflows/` and `references/`
- Progressive disclosure (main content + detailed references)
- Best when multiple files provide better organization
- Flat naming structure

Both are invocable by AI and users based on description and context.

---

## When to Use Commands

**Choose COMMAND when:**

- Single file is sufficient
- Folder nesting provides useful categorization
- Content fits in one file (~500-1500 words)
- Quick access via `/category:command` naming is valuable
- Example: `/learning:pattern-extractor` - quick intent invocation

**Choose SKILL when:**

- Content benefits from multiple files
- Progressive disclosure needed (core + detailed references)
- Multiple workflow files provide better organization
- Examples or scripts should be bundled

---

## Description Template

Third person, specific and concise:

```
[Action] [object/target] [constraints]
Use when [trigger phrase]
```

Examples:

- "Create implementation plan with milestones. Use when starting a new feature."
- "Deploy application to production. Use when ready to deploy."
- "Extract reusable patterns. Use when identifying reusable logic."

---

## Folder Nesting

Commands nest in folders within `commands/`:

```
commands/
├── learning/
│   └── pattern-extractor.md  → /learning:pattern-extractor
├── analysis/
│   └── diagnose.md           → /analysis:diagnose
└── planning/
    └── create-plan.md        → /planning:create-plan
```

---

<critical_constraint>
MANDATORY: Commands are single-file with folder nesting for /category:command naming

MANDATORY: Commands use same frontmatter and invocation as skills (both auto-invocable)

MANDATORY: Skills use folder structure with SKILL.md + optional workflows/ and references/

MANDATORY: Both are invocable by AI and users based on description and context

MANDATORY: Description should state what it does in third person, concise and specific

MANDATORY: No component references another component by name in description (portability violation)

No exceptions. The choice is structural (single file vs folder), not functional.
</critical_constraint>
