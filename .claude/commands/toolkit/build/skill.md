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

When invoked, analyze conversation:

**Detection:**

- `Glob: skills/**/*.md` (check for recent SKILL.md)
- `Grep: invocable-development` (check for skill usage)
- Invoke skill and read SKILL.md from its folder (identify target path)

**Inference:**

- `Extract: $ARGUMENTS` for skill description
- `Infer: skill type from context`
- `Detect: domain and complexity level`

**Verification:**

- `Bash: ls -la skills/*/` (check directory exists)
- `Glob: skills/*/SKILL.md` (verify presence)
- Invoke skill and read SKILL.md from its folder (assess completeness)

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

- `Skill: invocable-development` with inferred requirements
- `Trust: skill handles architectural decisions`
- `Apply: structural guidance from skill output`

### Phase 3: Validation

Verify:

- `Grep: "\.claude/rules\|external.*dependency"` - zero external dependencies
- `Grep: "mission_control\|trigger\|critical_constraint"` - UHP compliance
- `Bash: wc -w skills/*/SKILL.md` - appropriate size
- `Verify: autonomy targets 80-95%`

### Phase 4: Genetic Injection

Inject condensed Seed System principles:

1. Invoke invocable-development skill and read genetic-code-template.md from references folder
2. Invoke skill and edit SKILL.md + Genetic Code before `<critical_constraint>`
3. `Verify: grep -c "\.claude/rules" skills/*/SKILL.md == 0`

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
