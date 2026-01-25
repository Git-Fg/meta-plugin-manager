Centralize all instructions and knowledge in their correct locations. Think of this as a health check for your codebase's knowledge architecture.

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

**Pattern Check:**
- ✅ Good: "Knowledge on frontmatter lives in command-development"
- ❌ Bad: "See the frontmatter section in CLAUDE.md"
- Why good: Single source of truth, no path dependencies

## The Architecture Rules

**Single Source of Truth:**
```
❌ Bad: Pattern documented in skill-dev AND command-dev AND patterns.md
✅ Good: Pattern in patterns.md, referenced from meta-skills
```

**Self-Contained Skills:**
```
❌ Bad: "See .claude/rules/principles.md for context"
✅ Good: Inline principles directly OR fully rewrite them in-skill
```

**Progressive Disclosure:**
```
❌ Bad: Same content in Tier 2 AND Tier 3
✅ Good: Tier 2 = overview, Tier 3 = deep dive (different content)
```

**Path Independence:**
```
❌ Bad: "Navigate to .claude/skills/skill-name/"
✅ Good: Use portable paths: ${CLAUDE_PROJECT_DIR}/skills/skill-name/
```

## Context Fork Exception

When skills NEED project rules:
- Fully integrate the knowledge (don't reference)
- Rewrite rules specifically for the skill's context
- Make the skill self-contained

**Example:**
```
❌ Bad context fork: "This skill requires reading principles.md"
✅ Good context fork: Inline the 3 key principles with examples
```

## Quality Checklist

**After any refactoring:**
- [ ] No file paths in CLAUDE.md
- [ ] Each concept has exactly one source
- [ ] Skills reference nothing external
- [ ] Tier 2 ≠ Tier 3 content
- [ ] All cross-references use portable paths
