---
description: "Create portable one-file commands for intent/state definition. Use when defining WHAT should happen, organized in nested folders."
argument-hint: [command description or requirements]
---

# Build Command

<mission_control>
<objective>Create portable one-file commands that define intent and state with maximum autonomy</objective>
<success_criteria>Command created with valid frontmatter, clear description, proper folder structure, and genetic code injection</success_criteria>
</mission_control>

## Context Inference

When invoked, analyze conversation:

**Detection:**

- `Glob: commands/**/*.md` (check for recent creation)
- `Grep: invocable-development` (check for skill usage)
- `Read: last modified .md in commands/` (identify target path)

**Inference:**

- `Extract: $ARGUMENTS` for command description
- `Infer: command category from context`
- `Determine: folder structure from description`

**Verification:**

- `Glob: commands/**/*.md` (check if file exists)
- `Bash: ls -la commands/*/` (verify folder structure)
- `Read: commands/*/*.md` (assess completeness)

## Creation Workflow

### Phase 1: Intake & Inference

If $ARGUMENTS empty and no recent command creation:

- Ask for command purpose using AskUserQuestion
- Provide 2-4 recognition-based options (user selects, no typing)
- Prefer inference over generation

**L'Entonnoir pattern:** Ask → User selects → Explore → Ask (narrower) → Execute

If $ARGUMENTS present:

- Proceed to creation with provided requirements

If command just created:

- Offer to enhance or validate

### Phase 2: Command Generation

Use `invocable-development` skill via Skill tool:

- `Skill: invocable-development` with inferred requirements
- `Trust: skill handles architectural decisions`
- `Apply: structural guidance from skill output`

### Phase 3: Validation

Verify:

- `Edit: frontmatter.yaml` - valid name/description
- `Glob: commands/*/` - proper folder structure
- `Extract: description pattern` - What-When-Not format
- `Grep: skill.*reference|command.*reference` - no name references

### Phase 4: Genetic Injection

Inject condensed Seed System principles:

1. `Read: invocable-development/references/genetic-code-template.md`
2. `Edit: .claude/commands/*/*.md` + Genetic Code before `<critical_constraint>`
3. `Verify: grep -c "\.claude/rules" commands/*/*.md == 0`

```markdown
## Genetic Code

This component carries essential Seed System principles for context: fork isolation:

[...injected from genetic-code-template.md...]
```

**Note**: Commands have shorter injection (core constraints only) vs skills (full template).

## Usage Patterns

**Direct creation:**

```
/toolkit:build:command Create a command for deployment workflow
```

**Context-aware (after creation):**

```
/toolkit:build:command
[Detects recent command, offers enhancement]
```

**In the void:**

```
/toolkit:build:command
[Asks what to build using recognition-based questions]
```

## Success Criteria

- Command created with proper structure
- Valid frontmatter (name, description)
- Folder nesting produces /category:command pattern
- Description follows What-When-Not format
- High autonomy (1-2 AskUserQuestion rounds with recognition-based options)

<critical_constraint>
MANDATORY: Delegate structural guidance to invocable-development skill
MANDATORY: Trust AI intelligence - no syntax examples needed
MANDATORY: Prefer context inference over asking questions
MANDATORY: Commands are auto-invocable, same as skills (structural difference only)
MANDATORY: Inject genetic code template before final constraint (Phase 4)
MANDATORY: Verify portability - command must work with zero .claude/rules dependencies
No exceptions. Skills and commands are the same system with different organization.
</critical_constraint>
