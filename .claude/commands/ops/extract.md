---
description: "Extract reusable patterns from current conversation for component creation. Use when identifying new commands or skills from ongoing work."
argument-hint: [optional pattern name or leave empty]
---

# Extract Patterns

<mission_control>
<objective>Identify and document reusable patterns from current context for component creation</objective>
<success_criteria>Patterns extracted with type (command/skill/reject), confidence, and specification</success_criteria>
</mission_control>

## Core Principle: Commands vs Skills

**Commands and Skills are the same system** - both are auto-invocable tools. The difference is structural:

**Commands:**

- Single `.md` file
- Folder nesting produces `/folder:subfolder:command` patterns
- Useful for categorization and quick access
- Best when content fits in one file (~500-1500 words)

**Skills:**

- Folder with `SKILL.md` + optional `references/`
- Progressive disclosure (main content + detailed references)
- Best when multiple files provide better organization
- Flat naming structure
- SKILL.md contains full workflows (no separate workflows/ folder)

Both are invocable by AI and users based on description and context.

## Workflow

### 1. Detect

Gather context from:

- Recent conversation history
- Modified/created files in git status
- Active work-in-progress patterns
- Identify patterns suitable for extraction

### 2. Execute

For each pattern found, create component specification:

**Choose COMMAND when:**

- Single file is sufficient
- Folder nesting provides useful categorization
- Content fits in one file (~500-1500 words)
- Quick access via `/category:command` naming is valuable
- Example: `/ops:extract` - quick intent invocation

**Choose SKILL when:**

- Content benefits from multiple files
- Progressive disclosure needed (core + detailed references)
- Multiple workflows in SKILL.md provide better organization
- Examples or scripts should be bundled
- Example: `skill/engineering-lifecycle` - comprehensive methodology

**ALWAYS load the relevant development skill first:**

- For commands: Load `invocable-development` skill
- For skills: Load `invocable-development` skill

### 3. Verify

Confirm extracted patterns meet quality criteria:

- Type correctly identified (command/skill/reject)
- Confidence appropriately assessed (high/medium/low)
- Evidence substantiates the pattern
- Description follows third-person infinitive format

## Output

Provide structured findings:

```markdown
## Extracted Patterns

### Pattern 1: [name]

**Type:** command/skill/reject
**Confidence:** high/medium/low
**Evidence:** [2-3 lines]
**Specification:**

- Name: [proposed name]
- Description: [what it does + use when trigger]
- Category: [command (single file, nested) or skill (folder with SKILL.md + references/)]
```

---

<critical_constraint>
MANDATORY: Before extracting any pattern, load the relevant development skill

MANDATORY: Commands are single-file with folder nesting for /category:command naming

MANDATORY: Skills use folder structure with SKILL.md + optional references/ (no workflows/ folder)

MANDATORY: Both are invocable by AI and users based on description and context

MANDATORY: Description should state what it does in third person, concise and specific

MANDATORY: No component references another component by name in description (portability violation)

No exceptions. The choice is structural (single file vs folder), not functional.
</critical_constraint>
