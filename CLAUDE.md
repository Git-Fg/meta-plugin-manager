# CLAUDE.md: The Seed System

Meta-toolkit for Claude Code focused on .claude/ configuration with dual-role architecture: **health maintenance** + **portable component factory**.

**For philosophical foundation**, see the project rules directory

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
- **Ralph Orchestrator**: TDD-based component validation with staged deployment

**Usage pattern**: Load knowledge skills to understand concepts, then use factory skills to generate portable components.

---

# Ralph: Staged Validation Workflow

Ralph is the component development orchestrator that implements **Test-Driven Development + Confession Loop** for building portable components.

## The Staging Architecture

**Ralph creates validation artifacts in `ralph_validated/` rather than deploying directly to `.claude/`.** This creates a safer, auditable workflow.

```
ralph_validated/
├── YYYY-MM-DD_HHMM-task-name/          # Unique Run Container
│   ├── artifacts/                      # The validated component(s)
│   │   └── .claude/skills/my-skill/
│   ├── evidence/                       # Proof of work
│   │   ├── blueprint.yaml              # Architectural contract
│   │   ├── test_spec.json              # Test specification
│   │   └── raw_execution.log           # Execution telemetry
│   ├── REPORT.md                       # Validation certificate
│   └── _INDEX.txt                      # Navigation guide
```

## Workflow

### 1. Create
```bash
ralph run -p "create a skill for X"
```
- Ralph generates blueprint in `specs/`
- Tests designed and executed
- Validation report generated
- Artifacts staged to `ralph_validated/<timestamp>/`

### 2. Review
```bash
cat ralph_validated/<timestamp>/REPORT.md
```
- Read validation results
- Check confidence score (must be >= 80)
- Review gap analysis and recommendations

### 3. Approve (or Reject)
```bash
# If satisfied: move to production
mv ralph_validated/<timestamp>/artifacts/.claude/* .claude/

# If unsatisfied: delete, no changes made
rm -rf ralph_validated/<timestamp>/
```

## The Hat Architecture

Ralph uses specialized "hats" for each workflow phase:

| Hat | Responsibility | Output |
|-----|---------------|--------|
| **Coordinator** | Mode detection, Run ID generation, Blueprint creation | `specs/blueprint.yaml` |
| **Test Designer** | Test specification, security test generation | `test_spec.json` |
| **Executor** | Test execution, log capture | `raw_execution.log` |
| **Validator** | Evidence analysis, report generation | `VALIDATION_REPORT.md` |
| **Confession Handler** | Staging sequence, workflow completion | `ralph_validated/<RUN_ID>/` |

## Validation Report Structure

Each `REPORT.md` includes:
1. **Executive Summary**: Component name, type, result, confidence score
2. **Verification Matrix**: Blueprint compliance, test results, portability checks
3. **Execution Telemetry**: Tools used, steps taken, autonomy score
4. **Gap Analysis**: What works, what needs improvement, deviations
5. **Recommendations**: Before production, future enhancements
6. **Evidence References**: Links to all supporting files

## Safety Features

- **No direct deployment**: All changes staged to isolated directory first
- **Full audit trail**: Every run preserves blueprint, specs, logs, and report
- **Manual approval**: User explicitly moves artifacts to production
- **Atomic operations**: Either full success or no changes
- **Rollback safety**: Delete staging directory if unsatisfied

---

# Core Seed System Principles

**For complete philosophy**, see the project rules directory

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
├─ Update rules → Check project rules directory for consistency
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

# Skills vs Commands: Project Core Practice

*Note: This distinction is a **project-specific architectural best practice** intended to provide structure, not a hard technical constraint.*

### The Technical Reality
Under the hood, **Skills** and **Custom Slash Commands** are virtually identical (merged into the same `Skill` tool mechanism), while **Built-in Commands** (like `/init`) remain separate. By default, both are **Human and AI activated** (configurable via frontmatter), meaning the boundaries between them are flexible and depend on how you configure `disable-model-invocation`.

### Heuristics: Intent & Role

While the mechanism is shared, distinguishing them by **default behavior** helps keep your project organized:

*   **Commands** → **User-Invoked Orchestrators (`/command`)**
    *   **Preferred Intent**: Explicit human control over "high-stakes" or time-sensitive operations (e.g., `/deploy`, `/commit`).
    *   **Role**: Typically serve as top-level entry points. While they often orchestrate underlying capabilities, they are best used when you want the "Human in the Loop" to be the trigger.
    *   **Examples**: `/deploy`, `/commit`, `/code-review`, `/plan`.

*   **Skills** → **Model-First Capabilities**
    *   **Preferred Intent**: Contextual "know-how" that Claude can leverage automatically or recursively.
    *   **Role**: Serve as reusable logic blocks. While often "atomic" (e.g., specific coding standards), **Skills can also act as complex orchestrators** that chain Commands or other Skills for ultra-specific, multi-stage workflows (e.g., a "Legacy Migration" Skill that might invoke `/audit` and `/plan` as steps).
    *   **Examples**: `tdd-workflow`, `security-checklist`, `api-schema-reference`.

### Decision Matrix & Standards

Adopted from *Everything Claude Code* standards:

| Feature | **Commands** (`/command`) | **Skills** (`Context`) |
| :--- | :--- | :--- |
| **Typical Trigger** | **Human** (Explicit Intent) | **Model** (Contextual Need) |
| **Best For** | "Quick Actions" & Process Gates | "Deep Knowledge" & Recurring Workflows |
| **Scope** | Project-specific tasks | Domain-specific capabilities |
| **Activation** | User runs `/command` (Auto-available if allowed) | Auto-activated or `/skill-name` |
| **UX Pattern** | **Imperative**: "Do this now" | **Declarative**: "Here is how to do X" |

#### When to use what?

**Prefer a Command when:**
*   You need a reliable "Button" to trigger a process that usually requires human confirmation (e.g., `deploy`, `audit`).
*   The workflow acts as a strict gate or checkpoint in your development cycle.
*   You want to alias a complex, frequently used prompt into a convenient shortcut.

**Prefer a Skill when:**
*   You are encoding "How we do things" (e.g., "Our TDD process," "Security constraints").
*   The logic is reusable across different contexts or should be available to the model without you explicitly asking for it every time.
*   You want to define a sophisticated workflow that the model can manage autonomously (potentially calling other Commands as sub-steps).

---

# Philosophy Deep Dives

The Seed System philosophy is distributed across the project rules directory:

| File | Layer | Content |
|------|-------|---------|
| principles.md | **Both** | Dual-layer architecture, Portability Invariant, Success Criteria |
| patterns.md | **Both** | Implementation patterns, Degrees of Freedom |
| anti-patterns.md | Behavioral | Recognition-based anti-patterns, quality validation |
| voice-and-freedom.md | **Both** | Voice guidance, Freedom matrix, Teaching patterns |
| askuserquestion-best-practices.md | Behavioral | Recognition over Generation, question strategies |

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
- **Tier 2**: Component body (~1,500-2,000 words)
- **Tier 3**: References/ (on-demand)

---

# Development Workflow

## When Contributing to the Seed System

1. **Understand dual-layer architecture**: Layer A (behavioral) vs Layer B (construction)
2. **Check philosophy**: Consult project rules for guidance
3. **Apply patterns**: Use project rules for architectural enforcement
4. **Enforce portability**: Every component must work in isolation
5. **Test thoroughly**: Use `claude --dangerously-skip-permissions` for testing

## When Building Components with the Seed System

1. **Load knowledge**: Understand concepts via meta-skills
2. **Apply guidance**: Use meta-skills to generate components
3. **Check portability**: Ensure component works in isolation
4. **Test thoroughly**: Verify component works without external dependencies

---

# Personal Project Rules: Permissions and Security

**Note**: These rules apply specifically to this personal project environment and are not intended as general-purpose security guidelines for professional or team settings.

## Context: Personal Project Environment

This is a **personal development project**, not a professional or enterprise deployment. While permission fields like `allowed-tools` and `disable-model-invocation` are critical for security in multi-user or production environments, in this personal context they serve a different purpose: **improving tool behavior and performance**.

## When to Use Permission Constraints

Use permission settings **reactively**, not proactively. The default should be maximum freedom—only add constraints when specific issues arise.

### Reactive-First Principle

**Don't add permission constraints "just in case."** Only add them when:
1. A specific misbehavior has been observed
2. The constraint directly solves the identified problem
3. The alternative (no constraint) causes repeated failures

## Practical Use Cases

### For Agents: Solving Misbehavior

When an agent repeatedly calls inappropriate tools or ignores its intended scope, constrain its permissions:

```yaml
# agent/.claude/frontmatter
allowed-tools:
  - Read
  - Write
  - Bash
  # Exclude Task to prevent unwanted subagent spawning
```

**Use when**: Agent spawns unnecessary subagents or calls tools outside its domain.

### For Skills/Commands: Performance Improvement

Permission constraints can guide skills toward correct tool usage patterns.

**Example: Teaching a skill to invoke other skills**

A skill might fail to understand it should use the `Skill` tool to invoke another command/skill. Instead, it might attempt to spawn subagents via `Task` or use other inappropriate methods.

**Solution**: Constrain permissions to guide behavior:

```yaml
# .claude/skills/my-skill/SKILL.md
---
allowed-tools:
  - Skill(subskill-name)
  - Read
  - Write
---
```

**Why this works**:
- Restricts the skill to specific tools
- Prevents random subagent spawning
- Forces use of the `Skill` tool for delegation
- Reduces cognitive overhead (fewer options to consider)

**When to apply**:
- ✅ After observing the skill repeatedly calling wrong tools
- ✅ When a skill delegates to subagents instead of using Skill tool
- ❌ NOT as a default pattern
- ❌ NOT before observing issues

## Key Guidelines

1. **No proactive complexity**: Default to maximum permissions. Add constraints only when needed.
2. **Solve observed problems**: Each constraint should address a specific, repeated issue.
3. **Performance over security**: In this personal context, permissions guide behavior, not enforce security boundaries.
4. **Document the reason**: When adding constraints, explain what problem they solve.

## Anti-Patterns to Avoid

**❌ Don't** add permission constraints as a default pattern
**❌ Don't** constrain permissions "for safety" in a personal project
**❌ Don't** add permissions that haven't been tested against a real problem
**❌ Don't** copy permission constraints from other contexts without understanding the reason

**✅ Do** start with no constraints
**✅ Do** add constraints only after observing specific issues
**✅ Do** use constraints to teach correct tool usage patterns
**✅ Do** remove constraints if they no longer serve a purpose

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

# Intentional Redundancy: Why Duplication Is Correct

**This is the defining feature that makes Seed System components portable.**

## The Architecture

The Seed System uses **dual-layer architecture** with intentional redundancy:

| Layer | Location | Purpose | Audience |
|-------|----------|---------|----------|
| **Layer A** | `.claude/rules/` | Session guidance | Agent working NOW |
| **Layer B** | Meta-skills | Component "genetic code" | Component's intelligence |

## Why Philosophy Appears in Both Places

**This is NOT context drift—this is intentional architectural design.**

1. **Layer A (rules/)**: Guides the agent during current session. Not embedded in components.
2. **Layer B (meta-skills)**: Each meta-skill bundles its own philosophy. Portable to any project.

**The duplication is required** because:
- Components must work in isolation (zero `.claude/rules` dependency)
- Each component carries its own "genetic code"
- This enables true portability across projects

## What This Means

**Correct behavior:**
- ✅ Philosophy appears in both rules/ AND meta-skills
- ✅ Meta-skills are self-contained (no external references)
- ✅ Components work when copied to projects with zero rules

**Incorrect behavior:**
- ❌ Meta-skills reference `.claude/rules/` for philosophy
- ❌ Components depend on external documentation
- ❌ CLAUDE.md contains specific file paths (not portable)

## Single Source of Truth Applies Differently

**Within each layer**, single source of truth applies:
- In rules/: Each concept documented once
- In meta-skills: Each concept documented once

**Across layers**, intentional redundancy is required:
- Layer A: Session guidance (not portable)
- Layer B: Component genetic code (portable)

**The Seed System creates portable "organisms," not project-dependent tools. Every component bundles its own philosophy and self-validation logic.**
