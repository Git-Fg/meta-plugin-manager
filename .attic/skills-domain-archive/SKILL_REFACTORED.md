---
name: skills-domain
description: "Create and improve skills with progressive disclosure and autonomy-first design. Intelligently applies the right approach based on context - whether creating new skills, evaluating existing ones, or enhancing quality."
---

# Skills Domain

## Core Philosophy

### The Delta Standard

> **Good Customization = Expert-only Knowledge − What Claude Already Knows**

You understand how to build things well. This skill provides high-value patterns from successful implementations, not rigid rules.

**Trust your intelligence**: You know how to structure projects, write clear descriptions, and design for autonomy. Focus on what's specific to skills, not generic instructions.

## What This Does

Skills extend Claude's capabilities with specialized knowledge and workflows. Think of them as "onboarding guides" for specific domains—they transform Claude from general-purpose to specialized.

**Skills provide**:
- Specialized workflows for specific domains
- Tool integration patterns
- Domain expertise and conventions
- Bundled resources (scripts, references, templates)

## When to Use

Use this skill when:
- **Creating skills** - Building new capabilities
- **Evaluating skills** - Checking quality and effectiveness
- **Enhancing skills** - Improving existing skills

## How It Works

Intelligently apply the right pattern based on what you're doing:

### Creating a Skill

Start with the essentials:
1. **Clear purpose** - What does this skill do?
2. **Discoverable** - Will Claude know when to use it?
3. **Self-sufficient** - Can it work autonomously?
4. **Well-structured** - Organized for clarity

**Quality target**: Aim for skills that complete 80-95% of their intended task without questions.

### Evaluating a Skill

Check these fundamentals:
- **Knowledge Delta** - Is this expert-only or obvious?
- **Autonomy** - Does it work independently?
- **Discoverability** - Is the description clear?
- **Structure** - Is it organized logically?

### Improving a Skill

Focus on what matters most:
- **Missing context** - What would help Claude work better?
- **Unclear instructions** - Where is ambiguity causing issues?
- **Poor structure** - How can organization improve?
- **Low autonomy** - What could be known upfront?

## Quick Start

### Step 1: Understand What You're Building

A skill needs:
- **SKILL.md** (required) - Core implementation
- **references/** (optional) - Detailed content when needed
- **scripts/** (optional) - When deterministic execution matters

### Step 2: Choose Your Approach

**Creating something new?** → Start with clear purpose and structure
**Checking quality?** → Evaluate autonomy, clarity, discoverability
**Improving existing?** → Identify gaps and optimize

### Step 3: Apply Patterns

Keep skills:
- **Focused** - Single, clear purpose
- **Discoverable** - Clear when to use
- **Autonomous** - Work well independently
- **Well-structured** - Logical organization

## Progressive Disclosure

Skills load in three tiers to manage context efficiently:

**Tier 1: Metadata** (~100 tokens, always loaded)
- YAML frontmatter: name, description
- Purpose: Trigger discovery

**Tier 2: SKILL.md** (<500 lines, when invoked)
- Core implementation and guidance
- Purpose: Enable task completion

**Tier 3: References** (on-demand, as needed)
- Detailed documentation and examples
- Purpose: Deep details without clutter

**Rule**: Keep SKILL.md lean. Move detailed content to references/ when approaching 500 lines.

## Skill Types

### Auto-Discoverable (Default)

Claude uses these when relevant. User can invoke via `/name`.

```yaml
---
name: api-conventions
description: "API design patterns for this codebase. Use when writing API endpoints, modifying existing endpoints, or reviewing API changes."
---
```

### User-Triggered Workflows

Only user can invoke. Use for side-effects, timing-critical, or destructive actions.

```yaml
---
name: deploy
description: "Deploy application to production"
disable-model-invocation: true
argument-hint: [environment]
---
```

### Background Context

Only Claude uses. Hidden from `/` menu. Use for context that enhances understanding.

```yaml
---
name: legacy-system-context
description: "Explains the legacy authentication architecture"
user-invocable: false
---
```

## Context: Fork Skills

**Context: fork** enables skills to run in isolated subagents with separate context windows.

**Use for**:
- High-volume output (extensive grep, repo traversal)
- Noisy exploration that would clutter conversation
- Tasks requiring separate context window

**Don't use for**:
- Simple, direct tasks
- User interaction workflows
- Low output volume operations

## Quality Standards

Good skills are:
- **Useful** - Provide real value, not obvious knowledge
- **Autonomous** - Work well without constant questions (80-95% target)
- **Clear** - Easy to understand and use
- **Well-structured** - Organized logically
- **Discoverable** - Clear when to trigger

### Description Formula

**What** - What the skill does (core function)
**When** - When to use it (specific triggers)
**Not** - What it doesn't do (boundaries)

**Good example**:
```yaml
description: "API design patterns for this codebase. Use when writing API endpoints, modifying existing endpoints, or reviewing API changes."
```

**Avoid** (prescribes implementation):
```yaml
description: "Use to CREATE APIs by following these steps..."
```

## Common Issues

Skills can go wrong in predictable ways:

- **Over-engineering** - Adding complexity that isn't needed
- **Missing context** - Not providing enough information
- **Too rigid** - Prescribing exact steps when flexibility works better
- **Too vague** - Not giving enough guidance
- **Non-self-sufficient** - Requires constant hand-holding

Most issues come from not adapting to the specific situation.

## Reference Files

Detailed guidance is available when you need it:

**Core References** (Essential):
- **[creation.md](references/creation.md)** - Complete creation guide
- **[quality.md](references/quality.md)** - Quality standards and validation
- **[structure.md](references/structure.md)** - Directory patterns and organization
- **[examples.md](references/examples.md)** - Common examples and patterns

**Advanced References** (Specialized):
- **[inference.md](references/inference.md)** - Smart workflow detection patterns
- **[anti-patterns.md](references/anti-patterns.md)** - Common mistakes to avoid
- **[orchestration.md](references/orchestration.md)** - Complex workflows with TaskList
- **[scripts.md](references/scripts.md)** - When and how to use scripts

## Trust Your Intelligence

You understand:
- How to structure projects
- When to use progressive disclosure
- How to write clear descriptions
- When isolation (context: fork) helps
- How to design for autonomy

**Focus on**: Expert knowledge specific to skills, not generic instructions.

## SKILLS_DOMAIN_COMPLETE

**What was accomplished**:
- Skill guidance provided
- Quality standards clarified
- Patterns demonstrated
- Examples referenced

**Your turn**: Apply these patterns intelligently to create, evaluate, or enhance skills.
