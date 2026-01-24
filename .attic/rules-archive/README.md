# Rules Archive (Historical)

This folder contains the original `.claude/rules/` documentation that was archived during the 2026 documentation refactoring.

## Critical Architecture Note

**CLAUDE.md is FOR SKILL CREATORS, not for skills to reference.**

When we say "patterns migrated to skills" - we mean the CONTENT was migrated and INCLUDED in the skills. The skills do NOT and MUST NOT reference CLAUDE.md or this archive.

**Why:**
- AI agents using your skills will NOT have access to CLAUDE.md
- AI agents will NOT have the same folder structure as this project
- Skills must be SELF-SUFFICIENT - they contain everything needed to function

**Correct pattern:**
- ✅ Skill contains anti-patterns IN ITS OWN SKILL.md
- ✅ Skill references its OWN references/ files
- ❌ Skill never references CLAUDE.md (skill users won't have it)

## Archive Date

2026-01-24

## Why This Was Archived

The `rules/` folder contained valuable patterns that were distributed across multiple files. As part of the documentation refactoring:

1. **CLAUDE.md** transformed into a "meta-teaching" guide
2. **positive-patterns.md** content merged into CLAUDE.md
3. **Specific patterns migrated** to their respective architect skills:
   - `skills-architect`: Skill creation anti-patterns
   - `subagents-architect`: Subagent configuration anti-patterns
   - `hooks-architect`: Hook configuration anti-patterns
   - `mcp-architect`: URL validation patterns
   - `task-knowledge`: TaskList management anti-patterns

## What Was Here

- **positive-patterns.md**: Proven patterns from official skills (now in CLAUDE.md)
- **anti-patterns.md**: Common mistakes to avoid (now in respective skills)
- **architecture.md**: Layer architecture and tool philosophy (now in CLAUDE.md)
- **quality-framework.md**: 11-dimensional quality scoring (in skills-architect)
- **quick-reference.md**: Commands, decision trees, patterns (distributed)

## New Documentation Structure

```
CLAUDE.md                    # Meta-teaching guide ("how to teach")
├── FOR DIRECT USE           # Critical principles
├── How to Teach             # Core frameworks
└── Component Guidance       # Links to individual skills

.claude/skills/
├── skills-architect/SKILL.md     # Skill creation + anti-patterns
├── subagents-architect/SKILL.md  # Subagent config + anti-patterns
├── hooks-architect/SKILL.md      # Hook setup + anti-patterns
├── mcp-architect/SKILL.md        # MCP integration + patterns
└── task-knowledge/SKILL.md       # TaskList patterns + anti-patterns
```

## Migration Notes

- All valuable content was preserved during migration
- Cross-references updated to point to new locations
- CLAUDE.md now serves as the "how to teach" meta-guide
- Individual skills contain their specific patterns and anti-patterns

## When to Reference This Archive

Only reference this archive for:
- Historical context on documentation evolution
- Understanding the refactoring rationale
- Comparing old vs new structure

For current patterns, always reference CLAUDE.md and individual skills.
