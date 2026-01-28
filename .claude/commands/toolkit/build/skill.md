---
description: "Create portable, self-sufficient skills for reusable capabilities or specialized domain expertise. Use when building new skills or when user expresses need for a skill."
argument-hint: [skill description or requirements]
---

# Build Skill

<mission_control>
<objective>Create portable, self-sufficient skills that follow Seed System architecture with maximum autonomy</objective>
<success_criteria>Skill created with UHP compliance, progressive disclosure, genetic code injection, and portability invariant maintained</success_criteria>
</mission_control>

## Context Inference

When invoked, analyze conversation to determine:

1. **Was a skill just created?**
   - Check for recent SKILL.md file operations
   - Look for invocable-development skill usage
   - Identify target skill path

2. **What should be created?**
   - Parse $ARGUMENTS for skill description
   - Infer skill type from context (workflow, knowledge, context)
   - Detect domain and complexity level

3. **What's already done?**
   - Check if skill directory exists
   - Verify SKILL.md presence
   - Assess completeness

## Creation Workflow

### Phase 1: Intake & Inference

If $ARGUMENTS empty and no recent skill creation:

- Ask for skill purpose using AskUserQuestion
- Provide 2-4 recognition-based options (user selects, no typing)
- Prefer inference over generation

**L'Entonnoir pattern:** Ask → User selects → Explore → Ask (narrower) → Execute

If $ARGUMENTS present:

- Proceed to creation with provided requirements

If skill just created:

- Offer to enhance or validate existing skill

### Phase 2: Skill Generation

Use `invocable-development` skill via Skill tool:

- Pass inferred requirements and context
- Let skill handle architectural decisions
- Skill provides structural guidance and patterns

### Phase 3: Validation

Verify:

- Skill meets portability standards (zero external dependencies)
- UHP compliance (mission_control, trigger, critical_constraint)
- Progressive disclosure (SKILL.md size appropriate)
- Autonomy targets (80-95% completion rate)

### Phase 4: Genetic Injection

Inject condensed Seed System principles for context: fork isolation:

1. **Load template**: Read `invocable-development/references/genetic-code-template.md`
2. **Inject before footer**: Add Genetic Code section before the final `<critical_constraint>`
3. **Verify portability**: Confirm component works with zero .claude/rules dependencies

```markdown
## Genetic Code

This component carries essential Seed System principles for context: fork isolation:

[...injected from genetic-code-template.md...]
```

**Why this matters**: Forked subagents lose access to `.claude/rules/`. The Genetic Code ensures they retain core philosophy.

## Usage Patterns

**Direct creation:**

```
/toolkit:build:skill Create a skill for Docker log analysis
```

**Context-aware (after creation):**

```
/toolkit:build:skill
[Detects recent skill, offers enhancement]
```

**In the void:**

```
/toolkit:build:skill
[Asks what to build using recognition-based questions]
```

## Success Criteria

- Skill created with proper structure
- SKILL.md includes UHP header/footer
- Progressive disclosure in place
- Portability invariant maintained
- High autonomy (1-2 AskUserQuestion rounds with recognition-based options)

<critical_constraint>
MANDATORY: Delegate structural guidance to invocable-development skill
MANDATORY: Trust AI intelligence - no syntax examples needed
MANDATORY: Prefer context inference over asking questions
MANDATORY: Skills are auto-invocable, same as commands (structural difference only)
MANDATORY: Inject genetic code template before final constraint (Phase 4)
MANDATORY: Verify portability - skill must work with zero .claude/rules dependencies
No exceptions. Skills and commands are the same system with different organization.
</critical_constraint>
