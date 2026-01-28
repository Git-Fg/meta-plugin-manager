---
description: "Create complete invocable packages with command, workflows, skill, references, examples, and scripts. Use when building comprehensive capability packages with multiple entry points."
argument-hint: [package name and description]
---

# Build Package

<mission_control>
<objective>Create complete invocable packages with multiple interaction modes and comprehensive documentation</objective>
<success_criteria>Full package structure created with command, skill, workflows, references, and optional examples/scripts</success_criteria>
</mission_control>

## What is a Package?

A **package** (rooter archetype) is a complete capability package with multiple entry points:

```
my-package/
├── command.md              → Quick intent-based invocation
├── skill/
│   └── SKILL.md            → Domain logic and patterns
├── workflows/
│   ├── workflow-1.md       → Guided step-by-step processes
│   └── workflow-2.md
├── references/             → Detailed documentation
├── examples/               (optional) → Working demonstrations
└── scripts/                (optional) → Automation scripts
```

### Why Use This Pattern?

**Multiple interaction modes:**

- **Command**: Quick intent invocation (`/my-package`)
- **Workflows**: Guided multi-step processes
- **Skill**: Comprehensive domain knowledge
- **Examples**: Learn by observation
- **Scripts**: Automation and batch operations

**Self-contained capability:**

- Everything needed in one package
- Progressive disclosure (command → workflows → skill → references)
- Works in isolation

---

## Context Inference

When invoked, analyze conversation:

1. **What capability are you building?**
   - Parse $ARGUMENTS for component description
   - Infer domain and complexity
   - Determine what interaction modes are needed

2. **What structure is needed?**
   - Command only? (simple)
   - Command + Skill? (moderate)
   - Full package with workflows/examples? (complex)

3. **What's already done?**
   - Check if component structure exists
   - Verify what pieces are missing
   - Assess completeness

---

## Creation Workflow

### Phase 1: Intake & Requirements

If $ARGUMENTS empty:

- Ask for component purpose using AskUserQuestion
- Determine complexity level
- Identify required interaction modes

If $ARGUMENTS present:

- Proceed with provided requirements

### Phase 2: Structure Creation

Create package directory structure:

**Simple:**

```
my-package/
├── command.md
└── skill/
    └── SKILL.md
```

**Moderate:**

```
my-package/
├── command.md
├── skill/
│   └── SKILL.md
└── workflows/
    └── workflow.md
```

**Complete:**

```
my-package/
├── command.md
├── skill/
│   └── SKILL.md
├── workflows/
│   ├── workflow-1.md
│   └── workflow-2.md
├── references/
│   └── topic.md
├── examples/
│   └── example.md
└── scripts/
    └── script.sh
```

### Phase 3: Component Generation

**1. Create Command**

- Uses `invocable-development` skill
- Defines intent and entry point
- Orchestrates the overall capability

**2. Create Skill**

- Uses `invocable-development` skill
- Contains domain logic and patterns
- Progressive disclosure with references

**3. Create Workflows** (if needed)

- Step-by-step guided processes
- Can be invoked independently or via command
- Multi-step procedures with checkpoints

**4. Create References** (if needed)

- Detailed documentation
- Pattern libraries
- Best practices

**5. Create Examples/Scripts** (optional)

- Working demonstrations
- Automation scripts
- Integration patterns

### Phase 4: Integration & Validation

Verify:

- Command can invoke skill/workflows
- Workflows can reference skill
- Skill is portable (no command references)
- Examples demonstrate usage
- Scripts automate correctly

---

## Usage Patterns

**Complete package:**

```
/toolkit:build:package Create a Docker deployment package
[Creates command + skill + workflows + examples + scripts]
```

**Command + Skill only:**

```
/toolkit:build:package Create API rate limiting
[Creates command + skill]
```

**With workflows:**

```
/toolkit:build:package Create incident response workflow
[Creates command + skill + multiple workflows]
```

---

## Architecture

```
User Request
     │
     ▼
┌─────────────────────────────────────────────────────────────┐
│                    COMMAND (Entry Point)                   │
│  - Quick intent invocation                                  │
│  - Routes to appropriate workflow or skill                 │
│  - User interaction via AskUserQuestion                    │
└─────────────────────────────────────────────────────────────┘
     │
     ├──→ Workflow 1 (Guided Process)
     │          │
     │          └──→ Skill (Domain Logic)
     │
     ├──→ Workflow 2 (Alternative Process)
     │          │
     │          └──→ Skill (Domain Logic)
     │
     └──→ Skill (Direct Access)
```

---

## Critical Constraints

<critical_constraint>
MANDATORY: Skill MUST NOT reference command (portability invariant)

MANDATORY: Workflows can reference skill, not command

MANDATORY: Command can reference skill and workflows

MANDATORY: Each piece independently useful

MANDATORY: Examples must be working, not pseudo-code

No exceptions. Package is a complete capability, not a monolith.
</critical_constraint>

## Success Criteria

- Appropriate structure created for complexity level
- Command provides clear entry point
- Skill contains domain logic (portable)
- Workflows provide guided processes
- Examples demonstrate usage
- Scripts automate correctly
- High autonomy (0-3 AskUserQuestion rounds)
