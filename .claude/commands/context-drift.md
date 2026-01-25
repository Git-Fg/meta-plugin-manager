---
description: Centralize all instructions and knowledge in their correct locations
---

# Context Drift

Think of context drift as **organizing a library**—when knowledge is scattered across the wrong shelves, it becomes impossible to find what you need. This command centralizes instructions and knowledge in their correct locations, ensuring each concept has exactly one home.

## Recognition Patterns

**When to use context-drift:**
```
✅ Good: "Knowledge scattered across multiple files"
✅ Good: "Same pattern documented multiple places"
✅ Good: "Skills referencing external files"
✅ Good: "Tier 2 vs Tier 3 confusion"
❌ Bad: Well-organized knowledge architecture
❌ Bad: Single source of truth already maintained

Why good: Context drift fixes knowledge architecture before it becomes problematic.
```

**Pattern Match:**
- User mentions "organize knowledge", "centralize instructions", "fix scattered content"
- Multiple files document the same pattern
- Skills reference external files instead of being self-contained
- CLAUDE.md mentions specific file paths

**Recognition:** "Is knowledge scattered across wrong locations?" → Use context-drift.

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
- skill-development: How skills work
- command-development: How commands work
- [component]-development: How [component] works

## Recognition Tests

**Look for context drift when:**
- CLAUDE.md mentions specific file paths
- Multiple files document the same pattern
- Knowledge lives in wrong tier (Tier 2 vs Tier 3)
- Skills reference external files instead of being self-contained

**Recognition:** "Is this concept documented in multiple places?" → Centralize to single source.

## The Architecture Rules

### Single Source of Truth

**Rule**: Each concept has exactly one home.

**Pattern Check:**
```
❌ Bad: Pattern documented in skill-dev AND command-dev AND patterns.md
✅ Good: Pattern in patterns.md, referenced from meta-skills
```

**Why good**: Single source of truth prevents drift and inconsistency.

**Recognition:** "Can you point to multiple locations for the same concept?" → Fix to single source.

### Self-Contained Skills

**Rule**: Skills reference nothing external.

**Pattern Check:**
```
❌ Bad: "See .claude/rules/principles.md for context"
✅ Good: Inline principles directly OR fully rewrite them in-skill
```

**Why good**: Portability requires self-contained components.

**Recognition:** "Does this skill reference external files?" → Inline or rewrite.

### Progressive Disclosure

**Rule**: Tier 2 ≠ Tier 3 content.

**Pattern Check:**
```
❌ Bad: Same content in Tier 2 AND Tier 3
✅ Good: Tier 2 = overview, Tier 3 = deep dive (different content)
```

**Why good**: Avoids duplication while enabling conditional access.

**Recognition:** "Is this the exact same content in both tiers?" → Differentiate or consolidate.

### Path Independence

**Rule**: Use portable paths, not project-specific.

**Pattern Check:**
```
❌ Bad: "Navigate to .claude/skills/skill-name/"
✅ Good: Use portable paths: ${CLAUDE_PROJECT_DIR}/skills/skill-name/
```

**Why good**: Portable paths work across different project structures.

**Recognition:** "Do paths assume specific project structure?" → Make them portable.

## Context Fork Exception

**When skills NEED project rules:**
- Fully integrate the knowledge (don't reference)
- Rewrite rules specifically for the skill's context
- Make the skill self-contained

**Pattern Check:**
```
❌ Bad context fork: "This skill requires reading principles.md"
✅ Good context fork: Inline the 3 key principles with examples
```

**Why good**: Context fork still requires self-contained knowledge.

**Recognition:** "Does this fork context require external knowledge?" → Inline and rewrite.

## Contrast

```
✅ Good: Knowledge on frontmatter lives in command-development
❌ Bad: "See the frontmatter section in CLAUDE.md"

Why good: Single source of truth, no path dependencies.

✅ Good: Tier 2 overview + Tier 3 deep dive
❌ Bad: Same content in both tiers

Why good: Progressive disclosure without duplication.

✅ Good: Self-contained skills with bundled philosophy
❌ Bad: Skills referencing external .claude/rules/

Why good: Portability requires complete self-sufficiency.
```

## Quality Checklist

**After any refactoring:**
- [ ] No file paths in CLAUDE.md
- [ ] Each concept has exactly one source
- [ ] Skills reference nothing external
- [ ] Tier 2 ≠ Tier 3 content
- [ ] All cross-references use portable paths

**Recognition:** "Does this architecture follow single source of truth?" → Check all five criteria.

**Key Question**: "Would this component survive being moved to a fresh project?" If no, fix context drift.
