---
description: Extract reusable patterns from current context for component creation
argument-hint: [pattern-name]
---

Extract reusable patterns from the current conversation and codebase.

## Core Principle: Commands vs Skills

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

## Phase 1: Context Scan

Gather context from:

- Recent conversation history
- Modified/created files in git status
- Active work-in-progress patterns

## Phase 2: Pattern Identification

For each pattern found:

### Pattern: [Name]

**Type:** command | skill | reject
**Confidence:** high | medium | low
**Evidence:**

- [Specific evidence from context]
- [Concrete usage observed]

## Phase 3: Component Specification

**Choose COMMAND when:**

- Single file is sufficient
- Folder nesting provides useful categorization
- Content fits in one file (~500-1500 words)
- Quick access via `/category:command` naming is valuable
- Example: `/plan:create-plan` - quick intent invocation

**Choose SKILL when:**

- Content benefits from multiple files
- Progressive disclosure needed (core + detailed references)
- Multiple workflow files provide better organization
- Examples or scripts should be bundled
- Example: `skill/tdd-workflow` - comprehensive methodology

**ALWAYS load the relevant development skill first:**

- For commands: Load `invocable-development` skill
- For skills: Load `invocable-development` skill

### Description Template

Third person, specific and concise:

```
[Action] [object/target] [constraints]
Use when [trigger phrase]
```

Examples:

- "Create implementation plan with milestones. Use when starting a new feature."
- "Deploy application to production. Use when ready to deploy."
- "Process PDF files to extract text. Use when parsing PDF documents."

## Phase 4: Output

Provide structured findings:

```
## Extracted Patterns

### Pattern 1: [name]
**Type:** command/skill/reject
**Confidence:** high/medium/low
**Evidence:** [2-3 lines]
**Specification:**
- Name: [proposed name]
- Description: [what it does + use when trigger]
- Category: [command (single file, nested) or skill (folder with workflows/references)]
```

<critical_constraint>
MANDATORY: Before extracting any pattern, load the relevant development skill

MANDATORY: Commands are single-file with folder nesting for /category:command naming

MANDATORY: Skills use folder structure with SKILL.md + optional workflows/ and references/

MANDATORY: Both are invocable by AI and users based on description and context

MANDATORY: Description should state what it does in third person, concise and specific

MANDATORY: No component references another component by name in description (portability violation)

No exceptions. The choice is structural (single file vs folder), not functional.
</critical_constraint>
