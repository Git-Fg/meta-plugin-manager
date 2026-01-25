# Core Principles: Seed System Architecture

This document defines the **dual-layer architecture** for the Seed System—a meta-meta system where rules govern agent behavior while ensuring built components are portable and self-sufficient.

## Two-Layer Architecture

### Layer A: Behavioral Rules (Session-Only)
**Purpose:** Guide the agent's behavior in the current session
**Audience:** The agent operating NOW
**Scope:** Session-only, not embedded in components

### Layer B: Construction Standards (For Building Components)
**Purpose:** Meta-rules for creating portable, self-sufficient components
**Audience:** Embedded in generated Skills/Commands/Agents
**Scope:** Component genetic code (bundled philosophy)

**Key Insight:** The agent's "soul" (Layer A rules) teaches the agent to embed its "brain" (Layer B standards) into every component it builds.

---

# Layer A: Behavioral Rules (Session-Only)

*These rules govern how you operate in the current session. They are NOT embedded in components.*

---

## Behavioral Rule 1: Challenge Context Window Usage

**In this session**: Act as a context window steward. Every token competes for space—make each one earn its place.

**Think of it like**: A shared refrigerator. Everything you put in takes space others could use. Be a good roommate.

**Application for current work**:
- Prefer concise examples over verbose explanations
- Remove Claude-obvious content (what training already covers)
- Keep descriptions concise with exact trigger phrases
- Challenge: "Would Claude know this without being told?"

---

## Behavioral Rule 2: Trust Your Intelligence

**In this session**: Assume Claude is smart. Only add context Claude doesn't already have.

**Think of it like**: Talking to a senior engineer who joined your team. You don't explain basic programming—you explain what makes THIS project unique.

**What this means for current session**:
- Don't explain basic programming concepts
- Don't prescribe obvious workflows
- Don't provide exhaustive examples for simple patterns
- DO provide expert-only knowledge
- DO document project-specific decisions
- DO explain non-obvious trade-offs

**Recognition**: Would you explain this to a senior engineer on your team? If no, remove it.

---

## Behavioral Rule 3: Default to High Autonomy

**In this session**: Trust Claude's intelligence. Start with highest freedom unless there's a clear reason not to.

**Think of it like**: Claude is exploring a path. A narrow bridge with cliffs needs guardrails (low freedom). An open field allows many routes (high freedom).

**Reduce freedom only when**:
- Operations are destructive (irreversible)
- Safety-critical systems
- External system requirements
- Error consequences are severe

**Ask**: "What breaks if Claude chooses differently?" More breaks = lower freedom.

---

## Behavioral Rule 4: Progressive Disclosure is Cognitive Load Management

**In this session**: Reveal complexity progressively, not all at once.

**Three-tier loading**:
1. **Tier 1: Metadata** (~100 tokens) - Always loaded
2. **Tier 2: SKILL.md** (~400-450 lines) - Loaded on activation
3. **Tier 3: References/** - On-demand

**Recognition**: If Tier 2 approaches 450 lines, move content to Tier 3.

---

## Behavioral Rule 5: Local Project Autonomy

**In this session**: Start with local project configuration. Expand scope only when needed.

**Hierarchy** (from most local to most global):
1. **Project directory** (`.claude/`): Default for project-specific skills
2. **Project local overrides** (`.claude/settings.local.json`): Personal customization
3. **User-wide settings** (`~/.claude/settings.json`): Cross-project standards
4. **Legacy global hooks** (`.claude/hooks.json`): Deprecated, avoid

**Recognition**: If configuration applies only to this project, keep it in `.claude/`. If it's a personal preference, use `settings.local.json`. If it's a universal standard, consider user-wide settings.

---

# Layer B: Construction Standards (For Building Components)

*These meta-rules must be embedded in every generated Skill/Command/Agent/Hook/MCP. They are the component's "genetic code."*

---

## Portability Invariant (MANDATORY)

**Every component must be self-contained and work in a project with ZERO .claude/rules.**

**Why it matters**: Components must survive being moved to any project, including ones without the Seed System rules.

**Enforcement**:
1. Bundle condensed philosophy into each component
2. Include Success Criteria for self-validation (no external dependencies)
3. Mark references as mandatory with imperative language
4. Never reference external .claude/rules/ files

**Recognition**: "Could this component work if copied to a fresh project with no rules?" If no, fix it.

---

## The Delta Standard for Components

> **Good Component = Expert-only Knowledge − What Claude Already Knows**

**Embedded rule**: Every component must only include information with a knowledge delta.

**Positive Delta** (component must include):
- Project-specific architecture decisions
- Domain expertise not in general training
- Business logic and constraints
- Non-obvious bug workarounds
- Team-specific conventions

**Zero/Negative Delta** (component must exclude):
- General programming concepts
- Standard library documentation
- Common patterns Claude already knows
- Generic tutorials

**Recognition**: For each piece of content, ask "Would Claude know this without this component being told?" If yes, exclude it.

---

## Progressive Disclosure in Components

**Embedded rule**: Use three-tier loading to manage cognitive load in components.

**Tier 1: Metadata** (~100 tokens, always loaded)
- Frontmatter: `name`, `description`, specific trigger phrases
- Purpose: Trigger discovery, convey WHAT/WHEN/NOT

**Tier 2: Component Body** (~400-450 lines, loaded on activation)
- Core implementation with workflows and examples
- Purpose: Enable task completion

**Tier 3: References/** (on-demand, loaded when needed)
- Deep details, troubleshooting, comprehensive guides
- Purpose: Specific use cases without cluttering Tier 2

**Recognition**: If Tier 2 approaches 450 lines, move content to Tier 3.

---

## Teaching Formula (MANDATORY)

**Every generated component must include the Teaching Formula:**

1. **1 Metaphor** - For understanding (e.g., "Think of X like a Y")
2. **2 Contrast Examples** - Good vs Bad with rationale
3. **3 Recognition Questions** - Binary self-checks

**Example pattern**:
```
Metaphor: "Think of context like a shared refrigerator..."

✅ Good: "Run the test" (imperative)
❌ Bad: "You should run the test" (second person)
Why good: Zero latency, clear action

Recognition: "Can the user copy/paste this example?" → If no, add concrete details.
```

---

## Self-Containment Principle (Components)

**Embedded rule**: Components must be completely autonomous. Never reference external files, directories, or other components.

**Enforcement**:
- Inline all examples directly within component
- Never reference other components as "see X component"
- Each component owns all its content completely
- Bundle necessary philosophy (don't reference .claude/rules/)

**Recognition**: "Does this component reference files outside itself?" If yes, inline the content.

---

## Success Criteria Invariant (MANDATORY)

**Every component must include self-validation logic that works without external dependencies.**

**Purpose**: Enable components to self-validate completion without relying on project-specific tools (meta-critic, external skills).

**Template**:
```
## Success Criteria

This component is complete when:
- [ ] Criterion 1 (specific, measurable)
- [ ] Criterion 2 (specific, measurable)
- [ ] Criterion 3 (specific, measurable)

Self-validation: [How to verify completion without external dependencies]
```

**Recognition**: "Could a user validate this component's completion using only its internal content?" If no, add Success Criteria.

---

**Core Philosophy**:

**Teaching > Prescribing**: Philosophy enables intelligent adaptation. Process prescriptions create brittle systems.

**Trust > Control**: Claude is smart. Provide principles, not recipes.

**Less > More**: Context is expensive. Every token must earn its place.

For implementation patterns, see [`patterns.md`](patterns.md). For anti-patterns, see [`anti-patterns.md`](anti-patterns.md). For project-specific guidance, see [`CLAUDE.md`](../CLAUDE.md).
