---
description: "Centralize knowledge scattered across files, duplicate documentation, or skills referencing external files. Not for well-organized projects with clear single source of truth."
context: fork
---

<mission_control>
<objective>Identify and fix context drift - knowledge in wrong locations</objective>
<success_criteria>Each concept has single source of truth, skills self-contained, progressive disclosure maintained</success_criteria>
</mission_control>

# Context Drift

Centralize all instructions and knowledge in their correct locations.

## Core Distribution

**.claude/rules/ - Universal Philosophy**

- How to build meta-skills
- Global philosophy applicable to any component
- Cross-project behavioral standards

**CLAUDE.md - Project-Specific**

- Local project configuration
- How THIS project implements the rules
- Architecture decisions unique to this project

**Meta-Skills - Component Expertise**

- invocable-development: How commands and skills work
- [component]-development: How [component] works

## Recognition Tests

**Look for context drift when:**

- CLAUDE.md mentions specific file paths
- Multiple files document the same pattern
- Knowledge lives in wrong tier (Tier 2 vs Tier 3)
- Skills reference external files instead of being self-contained

**Binary test:** "Is concept documented in multiple places?" → Centralize to single source.

## The Architecture Rules

### Single Source of Truth

**Rule**: Each concept has exactly one home.

**Binary test:** "Can you point to multiple locations for same concept?" → Fix to single source.

### Self-Contained Skills

**Rule**: Skills reference nothing external.

**Binary test:** "Does skill reference external files?" → Inline or rewrite.

### Progressive Disclosure

**Rule**: Tier 2 ≠ Tier 3 content.

**Binary test:** "Is this exact same content in both tiers?" → Differentiate or consolidate.

### Path Independence

**Rule**: Use portable paths, not project-specific.

**Binary test:** "Do paths assume specific project structure?" → Make them portable.

## Dual-Layer Architecture Exception

**Critical:** Philosophy duplication between `.claude/rules/` (Layer A) and meta-skills (Layer B) is INTENTIONAL, not context drift.

**Recognition test:** "Is it knowledge that is globally useful for all skills, projects and global philosophy to contextualize?"

- **If YES** → Belongs in `.claude/rules/` (Layer A: universal philosophy)
- **If NO** (component-specific, needs portability) → Belongs in the skill itself (Layer B: genetic code)

**Why this distinction:**

- Layer A guides the agent during current session (not embedded in components)
- Layer B provides portable "genetic code" for components (must work in isolation)
- Components must survive being moved to projects with ZERO `.claude/rules/`

**Do NOT flag as drift:**

- Progressive Disclosure explained in both rules/ and meta-skills
- Delta Standard documented in both locations
- Self-containment taught in both layers
- Portability Invariant present in both

**Flag as drift only when:**

- Philosophy duplicated within the SAME layer (rules/ or skills/)
- Specific file paths used in CLAUDE.md
- Skills reference external files instead of containing knowledge

## Context Fork Exception

**When skills NEED project rules:**

- Fully integrate the knowledge (don't reference)
- Rewrite rules specifically for the skill's context
- Make the skill self-contained

**Binary test:** "Does fork context require external knowledge?" → Inline and rewrite.

## Quality Checklist

**After any refactoring:**

- [ ] No file paths in CLAUDE.md
- [ ] Each concept has exactly one source
- [ ] Skills reference nothing external
- [ ] Tier 2 ≠ Tier 3 content
- [ ] All cross-references use portable paths

**Binary test:** "Does architecture follow single source of truth?" → Check all five criteria.

**Key question:** "Would this component survive being moved to a fresh project?" → If no, fix context drift.

---

<critical_constraint>
MANDATORY: Each concept has exactly one home - flag duplicates
MANDATORY: Skills reference nothing external - must be self-contained
MANDATORY: Tier 2 ≠ Tier 3 - progressive disclosure must be maintained
MANDATORY: Flag file paths in CLAUDE.md as portability issues
No exceptions. Context drift creates maintenance burden and inconsistency.
</critical_constraint>
