# Command Orchestration Pattern

**This is an optional orchestration archetype for building sophisticated workflow automation.**

---

## Overview

One component can orchestrate another for workflow automation.

**Both are auto-invocable tools** - the distinction is structural, not functional.

This pattern provides:

- Context-aware orchestration behavior
- High autonomy with progressive refinement
- Reusable component architecture
- Flexible workflow composition

---

## When to Use This Pattern

### Use this pattern when:

- Component needs to coordinate multiple steps or other components
- Context-aware behavior is valuable (auto-detection, progressive refinement)
- Complex orchestration with decision points
- Reusable orchestration logic

### Skip this pattern when:

- Simple component invocation suffices
- No orchestration needed
- Single invocation use case
- Direct workflow is clearer

---

## The Architecture

```
┌─────────────────────────────────────────────────────────────┐
│              ORCHESTRATING COMPONENT (Command/Skill)          │
│  - Analyzes context and determines next steps               │
│  - Manages interaction flow (AskUserQuestion, etc.)         │
│  - Coordinates multiple other components                     │
│  - Handles state transitions between phases                   │
└─────────────────────────────────────────────────────────────┘
                            │
                            │ invokes
                            ▼
┌─────────────────────────────────────────────────────────────┐
│              ORCHESTRATED COMPONENT (Skill/Command)           │
│  - Contains detailed knowledge, patterns, procedures          │
│  - Executes specific domain logic or workflow                │
│  - Self-contained and reusable across contexts                │
└─────────────────────────────────────────────────────────────┘
```

---

## Example: Skill Creation

### Command: `/toolkit:skill:create`

**Command orchestrates:**

```yaml
---
description: "Create portable, self-sufficient skills for reusable capabilities."
argument-hint: [skill description or requirements]
---

## Context Inference

When invoked, analyze conversation:

1. **Was a skill just created?** → Offer enhancement
2. **What should be created?** → Parse $ARGUMENTS or ask
3. **What's already done?** → Check existing files

## Creation Workflow

### Phase 1: Intake & Inference
- If $ARGUMENTS empty → Ask for skill purpose
- If $ARGUMENTS present → Proceed to creation
- If skill just created → Offer to validate

### Phase 2: Skill Generation
- Use `invocable-development` skill via Skill tool
- Pass inferred requirements and context
- Let skill handle architectural decisions

### Phase 3: Validation
- Verify portability standards
- Check UHP compliance
- Confirm autonomy targets
```

**Skill provides:**

```yaml
---
name: invocable-development
description: "Create portable invocable components for reusable capabilities."
---
## Phase 2: Skill Generation

### Requirements Gathering
Analyze to extract:
  - Skill type (workflow, knowledge, context)
  - Domain expertise needed
  - Complexity level
  - Integration requirements

### Structure Design
Create skill structure:
```

skill-name/
├── SKILL.md
├── workflows/
├── references/
└── scripts/

```

### Content Generation
Generate SKILL.md with:
- UHP header (mission_control, trigger, interaction_schema)
- Body content
- UHP footer (critical_constraint)

### Quality Validation
Verify portability, autonomy, progressive disclosure
```

---

## Critical Constraint: Portability

<portability_invariant>
**Skills MUST NOT reference the commands that invoke them.**
</portability_invariant>

### Why This Matters

If a skill references its command:

- **Portability violation**: Skill only works in projects with that command
- **Loophole risk**: Creates implicit dependency
- **Discovery anti-pattern**: Users can't find the command independently

### Correct Implementation

**Command (`toolkit:skill:create`):**

```markdown
## Phase 2: Skill Generation

Use `invocable-development` skill via Skill tool:

- Pass inferred requirements and context
- Let skill handle architectural decisions
```

**Skill (`invocable-development`):**

```markdown
## Navigation

| If you need...    | Reference                        |
| ----------------- | -------------------------------- |
| Creation workflow | `references/workflows-create.md` |
```

✅ **Skill is portable** - Works in any project, no command dependency

### Incorrect Implementation

**Skill (`skill-development` - WRONG):**

```markdown
## Navigation

| If you need... | Command                 |
| -------------- | ----------------------- |
| Create a skill | `/toolkit:skill:create` |
```

❌ **Portability violation** - Skill requires that specific command

---

## Intelligence Rules

### Commands: Trust User Context

**Auto-detect when possible:**

- If user just created skill → Audit that skill (don't ask)
- If user provides path → Audit that path (don't ask)
- If user invokes "in void" → Search recent, then ask if needed

**Minimize questions:**

- Auto-detect when possible
- Ask only when genuinely ambiguous
- Prefer confirmation over generation

### Skills: Self-Contained

**Work independently:**

- All necessary context included
- Philosophy bundled with skill
- No external command references

**Auto-invocable:**

- AI can invoke based on description
- No manual routing needed
- Works in any project

---

## Pattern Examples

### Example 1: Skill Creation with Auto-Detection

```
User: "I need a skill for Docker log analysis"
AI: [Invokes /toolkit:skill:create]
Command: Infers requirements, invokes invocable-development
Skill: Creates skill with proper architecture
```

### Example 2: Audit with Context Awareness

```
User: [Creates skill]
User: "/toolkit:skill:audit"
Command: Detects recent skill, audits automatically
Subagent: Performs comprehensive evaluation
```

### Example 3: Meta-Critic with Conversation Analysis

```
User: "This doesn't feel right"
AI: [Suggests] /toolkit:skill:metacritic
Command: Analyzes conversation, invokes meta-critic
Meta-critic: Three-way comparison (Request vs Delivery vs Standards)
```

---

## Implementation Checklist

### Command Development

- [ ] Clear intent definition (WHAT)
- [ ] Context inference logic
- [ ] Progressive refinement (start with inference, ask when necessary)
- [ ] Delegates domain logic to skill
- [ ] No hard-coded behavior (trust skill)

### Skill Development

- [ ] Domain logic (HOW)
- [ ] Self-contained (no command references)
- [ ] Portable (works in isolation)
- [ ] Progressive disclosure (workflows/, references/)
- [ ] High autonomy (80-95% target)

### Integration

- [ ] Command invokes skill via Skill tool
- [ ] Skill has no knowledge of invoking command
- [ ] Both are independently useful
- [ ] Portability invariant maintained

---

## Success Criteria

- Command defines intent and state (WHAT)
- Skill executes domain logic (HOW)
- Skill is portable (no command references)
- High autonomy achieved (0-5 AskUserQuestion rounds)
- Context inference works (auto-detection)
- Both independently useful

---

## Anti-Patterns

### Anti-Pattern 1: Skill References Command

**Description**: Skill mentions the command that invokes it

**Recognition**: Does skill navigation include command names?

**Fix**: Remove command references from skill. Keep skill self-contained.

### Anti-Pattern 2: Command Hardcodes Logic

**Description**: Command implements domain logic instead of delegating to skill

**Recognition**: Does command have detailed domain logic?

**Fix**: Move domain logic to skill. Command should orchestrate, not implement.

### Anti-Pattern 3: Tight Coupling

**Description**: Command and skill are interdependent

**Recognition**: Can skill work without command? Can command work without skill?

**Fix**: Ensure both are independently useful. Pattern is orchestration, not dependency.

---

## Summary

**The Command Orchestration Pattern** enables sophisticated workflow automation:

1. **Commands** orchestrate workflows (manage flow, coordinate components)
2. **Skills** contain domain knowledge and patterns (execute logic, provide guidance)
3. **Portability invariant** maintains independence
4. **High autonomy** through context inference

**This is optional.** Use when workflow orchestration provides value. Skip when simple invocation suffices.
