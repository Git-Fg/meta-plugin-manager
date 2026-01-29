---
name: ops:drift
description: "Detect and fix context drift - knowledge scattered across files, duplicate documentation, or skills referencing external files. Uses TodoWrite for issue tracking. Use when auditing project health."
context: fork
---

# Detect Context Drift

**Uses TodoWrite for issue tracking**

## Quick Context

Centralize all instructions and knowledge in their correct locations.

## Workflow

### 1. Detect

Gather context:

- `Glob: .claude/rules/*.md` → Rules files
- `Glob: CLAUDE.md` → Project config
- `Glob: .claude/skills/*/SKILL.md` → All skills

### 2. Ask

If drift detection finds issues, use recognition-based questions:

- "Which issues should be fixed first?"
- "Should these be consolidated or moved?"

### 3. Execute

**Architecture Checks:**

| Check                  | Pattern                        | Tool               |
| ---------------------- | ------------------------------ | ------------------ | --------------- |
| Single source of truth | `Grep: "(pattern               | concept)._\n._\1"` | Find duplicates |
| Self-contained skills  | `Grep: "external\|dependency"` | Find external refs |
| Progressive disclosure | File line count                | Tier 2 ≠ Tier 3    |
| Path independence      | `Grep: "^/\|^\."`              | Portable paths     |

**Drift Patterns to Flag:**

- CLAUDE.md mentions specific file paths
- Multiple files document same pattern
- Knowledge in wrong tier (Tier 2 vs Tier 3)
- Skills reference external files

**Do NOT Flag (Intentional Duplication):**

- Philosophy in both rules/ and meta-skills (Layer A vs Layer B)
- Progressive Disclosure explained in both
- Delta Standard in both locations

### 4. Verify

1. **TodoWrite**: Create task entries for each drift issue
2. **TaskUpdate**: Mark issues as fixed after refactoring

## Core Distribution

**.claude/rules/ - Universal Philosophy**

- How to build meta-skills
- Global philosophy applicable to any component
- Cross-project behavioral standards

**CLAUDE.md - Project-Specific**

- Local project configuration
- How THIS project implements the rules
- Architecture decisions unique to this project

**Skills - Component Expertise**

- invocable-development: How commands and skills work
- [component]-development: How [component] works

## Quality Checklist

**After any refactoring:**

- `Glob: CLAUDE.md` → `Grep: "\.claude/"` - No file paths in CLAUDE.md
- `Grep: "(pattern|concept).*\n.*\1"` - Each concept has exactly one source
- `Grep: "external\|dependency" skills/*/SKILL.md` - Skills reference nothing external
- `Bash: wc -l skills/*/SKILL.md` - Tier 2 ≠ Tier 3 content
- `Grep: "^/\|^\."` - All cross-references use portable paths

**Key question:** "Would this component survive being moved to a fresh project?" → If no, fix context drift.

---

<critical_constraint>
MANDATORY: Each concept has exactly one home - flag duplicates
MANDATORY: Skills reference nothing external - must be self-contained
MANDATORY: Tier 2 ≠ Tier 3 - progressive disclosure must be maintained
MANDATORY: Flag file paths in CLAUDE.md as portability issues
MANDATORY: Use TodoWrite for tracking drift issues
No exceptions. Context drift creates maintenance burden and inconsistency.
</critical_constraint>
