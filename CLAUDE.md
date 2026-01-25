# CLAUDE.md: The Seed System

Meta-toolkit for Claude Code focused on .claude/ configuration with dual-role architecture: **health maintenance** + **portable component factory**.

**For philosophical foundation**, see [`.claude/rules/`](.claude/rules/)

---

# Project Overview: The Seed System

This project is a **meta-meta system**—a toolkit for building toolkits. It serves **two distinct roles**:

## Role 1: Health Maintenance (Current Session)

The Seed System governs its own internal health:
- Maintains consistency across rules, skills, and documentation
- Ensures high autonomy (80-95% target: 0-5 questions per session)
- Enforces quality standards and progressive disclosure
- Validates component structure and portability

## Role 2: Portable Component Factory (Building Offspring)

The Seed System builds portable, self-sufficient components:
- Generates Skills/Commands/Agents/Hooks/MCPs that bundle their own philosophy
- Ensures components work in isolation (zero .claude/rules dependency)
- Embeds Success Criteria for self-validation
- Creates components with intentional redundancy (condensed philosophy included)

**Key Innovation**: Components carry their own "genetic code"—they don't depend on the Seed System to function.

---

# Dual-Layer Architecture

The Seed System uses a **two-layer architecture** to achieve both roles:

## Layer A: Behavioral Rules (Session-Only)
**Purpose**: Guide agent behavior in the current session
**Scope**: Session-only, not embedded in components
**Audience**: The agent operating NOW

## Layer B: Construction Standards (For Building Components)
**Purpose**: Meta-rules for creating portable components
**Scope**: Embedded in generated components as "genetic code"
**Audience**: The component's own intelligence

**Key Insight**: The agent's "soul" (Layer A) teaches it to embed its "brain" (Layer B) into every component it builds.

---

# Knowledge-Factory Architecture

This project demonstrates the **Knowledge-Factory architecture**:

### Knowledge Layer (Understanding)
- **Knowledge Skills** (passive reference): skill-development, command-development, hook-development, agent-development, mcp-development
- Provides concepts, patterns, and philosophy
- Teaches the "why" behind component creation

### Factory Layer (Execution)
- **Factory Skills**: Transform knowledge into portable components
- Apply architectural patterns to ensure component traits
- Bundle condensed philosophy into outputs

### Quality Layer (Validation)
- **Meta-Critic**: Quality validation and alignment checking
- Success Criteria Invariant for self-validation

**Usage pattern**: Load knowledge skills to understand concepts, then use factory skills to generate portable components.

---

# Core Seed System Principles

**For complete philosophy**, see [`.claude/rules/principles.md`](.claude/rules/principles.md)

## The Portability Invariant

**Every component MUST be self-contained and work in a project with ZERO .claude/rules.**

This is the **defining characteristic** of the Seed System. Unlike traditional toolkits that create project-dependent components, the Seed System creates portable "organisms" that survive being moved to any environment.

## The Delta Standard

> **Good Component = Expert-only Knowledge − What Claude Already Knows**

Only include information with a knowledge delta—the gap between what Claude knows and what the component needs.

## Portability Principle

Components should work without depending on external documentation or files.

---

# Navigation Decision Tree

## For Health Maintenance (Current Session)

```
Need to maintain project health?
│
├─ Update rules → Check .claude/rules/ for consistency
├─ Audit quality → Use meta-critic skill
├─ Fix autonomy issues → Review AskUserQuestion patterns
└─ Validate structure → Check progressive disclosure tiers
```

## For Component Factory (Building Components)

```
Need to build a portable component?
│
├─ Create a skill → skill-development
├─ Add command → command-development
├─ Create agent → agent-development
├─ Add hook → hook-development
├─ Add MCP server → mcp-development
└─ Refine prompt → refine-prompts
```

---

# Seed System vs Traditional Toolkits

| Feature | Traditional Toolkit | Seed System |
|---------|-------------------|-------------|
| **Philosophy Location** | External documentation | Bundled in component |
| **Dependencies** | Requires toolkit context | Zero external dependencies |
| **Self-Validation** | Needs external tools | Success Criteria included |
| **Portability** | Project-dependent | Works anywhere |
| **Philosophy** | Referenced | Intentional redundancy |
| **Quality** | External validation | Self-validation + external |

**Key Difference**: Traditional toolkits create **project-dependent tools**. Seed System creates **portable organisms**.

---

# Project Structure: The Genetic Code

```
.claude/
├── rules/                          # The Agent's "Soul" (Layer A)
│   ├── principles.md              # Dual-layer architecture
│   ├── patterns.md                # Architectural patterns
│   ├── anti-patterns.md           # Recognition-based anti-patterns
│   ├── voice-and-freedom.md       # Voice + Freedom guidance
│   └── askuserquestion-best-practices.md # Question strategies
│
├── skills/                         # Knowledge-Factory Components
│   ├── skill-development/          # Skill creation (architectural)
│   ├── command-development/        # Command creation (architectural)
│   ├── agent-development/          # Agent creation (architectural)
│   ├── hook-development/           # Hook creation (architectural)
│   ├── mcp-development/            # MCP creation (architectural)
│   └── meta-critic/               # Quality validation
│
├── agents/                         # Context fork isolation
├── hooks/                          # Event automation
├── commands/                       # Slash commands
└── settings.json                   # Project configuration
```

---

# Component-Specific Guidance

For detailed guidance on creating portable components, consult the appropriate meta-skill:

| Component | Meta-Skill | Output Traits |
|-----------|------------|--------------|
| Skills | skill-development | Portable, self-sufficient, progressive disclosure |
| Commands | command-development | Self-contained, mandatory references, Success Criteria |
| Agents | agent-development | Autonomous, isolated context, bundled philosophy |
| Hooks | hook-development | Event-driven, security patterns, self-validating |
| MCPs | mcp-development | Server configuration, transport mechanisms, portable |

Each meta-skill demonstrates clear guidance for component creation:
- Component-specific patterns
- Best practices for portability
- Progressive disclosure structure
- Self-contained examples

**Each meta-skill is the single source of truth for its domain—and for portable component generation.**

---

# Philosophy Deep Dives

The Seed System philosophy is distributed across `.claude/rules/`:

| File | Layer | Content |
|------|-------|---------|
| [`principles.md`](.claude/rules/principles.md) | **Both** | Dual-layer architecture, Portability Invariant, Success Criteria |
| [`patterns.md`](.claude/rules/patterns.md) | **Both** | Implementation patterns, Degrees of Freedom |
| [`anti-patterns.md`](.claude/rules/anti-patterns.md) | Behavioral | Recognition-based anti-patterns, quality validation |
| [`voice-and-freedom.md`](.claude/rules/voice-and-freedom.md) | **Both** | Voice guidance, Freedom matrix, Teaching patterns |
| [`askuserquestion-best-practices.md`](.claude/rules/askuserquestion-best-practices.md) | Behavioral | Recognition over Generation, question strategies |

**Philosophy is universal**—Layer A guides the agent, Layer B is embedded in components.

---

# Key Meta-Skills Reference

| Meta-Skill | Purpose | Transformation |
|------------|---------|----------------|
| **skill-development** | Creating portable skills | Tutorial → Architectural refiner |
| **command-development** | Creating portable commands | Tutorial → Architectural refiner |
| **agent-development** | Creating portable agents | Tutorial → Architectural refiner |
| **hook-development** | Creating portable hooks | Tutorial → Architectural refiner |
| **mcp-development** | Creating portable MCPs | Tutorial → Architectural refiner |
| **meta-critic** | Quality validation | Validation framework |
| **refine-prompts** | L1/L2/L3/L4 refinement | Prompt optimization |

**Transformation**: All meta-skills converted from prescriptive tutorials to architectural refiners.

---

# Quality Standards

All components created by the Seed System must achieve:

### Portability (Seed System Defining Feature)
- **Zero external dependencies**: Works in isolation
- **Self-contained**: Includes all necessary context
- **Progressive disclosure**: Right content at right tier

### Autonomy
- **80-95% autonomy**: 0-5 questions per session
- **Clear triggering**: Specific description with exact phrases
- **Progressive disclosure**: Right content at right tier

### Quality
- **Imperative form**: No "you/your" in instructions
- **Clear examples**: Concrete examples users can copy
- **Single source of truth**: No duplication across files

### Structure
- **Tier 1**: Metadata (~100 tokens)
- **Tier 2**: Component body (~400-450 lines)
- **Tier 3**: References/ (on-demand)

---

# Development Workflow

## When Contributing to the Seed System

1. **Understand dual-layer architecture**: Layer A (behavioral) vs Layer B (construction)
2. **Check philosophy**: Consult `.claude/rules/principles.md` for guidance
3. **Apply patterns**: Use `.claude/rules/patterns.md` for architectural enforcement
4. **Avoid duplication**: Each concept has single source of truth
5. **Enforce portability**: Every component must work in isolation
6. **Test thoroughly**: Use `claude --dangerously-skip-permissions` for testing

## When Building Components with the Seed System

1. **Load knowledge**: Understand concepts via meta-skills
2. **Apply guidance**: Use meta-skills to generate components
3. **Check portability**: Ensure component works in isolation
4. **Test thoroughly**: Verify component works without external dependencies

---

# The Seed System Philosophy

### Teaching > Prescribing
Philosophy enables intelligent adaptation. Process prescriptions create brittle systems.

### Trust > Control
Claude is smart. Provide principles, not recipes.

### Less > More
Context is expensive. Every token must earn its place.

### Intentional Redundancy
Philosophy must be duplicated where needed for portability. Components carry their own genetic code.

### Recognition over Generation
Users recognize faster than they generate. Structure interactions for validation, not brainstorming.

---

**The Seed System creates portable "organisms," not project-dependent tools. Every component bundles its own philosophy and self-validation logic.**
