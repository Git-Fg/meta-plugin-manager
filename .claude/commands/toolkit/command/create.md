---
description: "Create simple one-file commands for intent/state definition. Use when defining WHAT should happen, organized in nested folders."
argument-hint: [command description or requirements]
---

# Command Creation

<mission_control>
<objective>Create portable one-file commands that define intent and state with maximum autonomy</objective>
<success_criteria>Command created with valid frontmatter, clear description, and proper folder structure</success_criteria>
</mission_control>

## Context Inference

When invoked, analyze conversation:

1. **Was a command just created?**
   - Check for recent .md file creation in commands/
   - Look for invocable-development skill usage
   - Identify target command path

2. **What should be created?**
   - Parse $ARGUMENTS for command description
   - Infer command category from context
   - Determine folder structure

3. **What's already done?**
   - Check if command file exists
   - Verify folder structure
   - Assess completeness

## Creation Workflow

### Phase 1: Intake & Inference

If $ARGUMENTS empty and no recent command creation:

- Ask for command purpose using AskUserQuestion
- Provide recognition-based options when possible
- Prefer inference over generation

If $ARGUMENTS present:

- Proceed to creation with provided requirements

If command just created:

- Offer to enhance or validate

### Phase 2: Command Generation

Use `invocable-development` skill via Skill tool:

- Pass inferred requirements and context
- Let skill handle architectural decisions
- Skill provides structural guidance and patterns

### Phase 3: Validation

Verify:

- Valid frontmatter (name, description)
- Proper folder structure for nesting
- What-When-Not description format
- No command/skill name references in description

## Usage Patterns

**Direct creation:**

```
/toolkit:command:create Create a command for deployment workflow
```

**Context-aware (after creation):**

```
/toolkit:command:create
[Detects recent command, offers enhancement]
```

**In the void:**

```
/toolkit:command:create
[Asks what to build using recognition-based questions]
```

## Success Criteria

- Command created with proper structure
- Valid frontmatter (name, description)
- Folder nesting produces /category:command pattern
- Description follows What-When-Not format
- High autonomy (0-2 AskUserQuestion rounds)

<critical_constraint>
MANDATORY: Delegate structural guidance to invocable-development skill
MANDATORY: Trust AI intelligence - no syntax examples needed
MANDATORY: Prefer context inference over asking questions
MANDATORY: Commands are auto-invocable, same as skills (structural difference only)
No exceptions. Skills and commands are the same system with different organization.
</critical_constraint>
