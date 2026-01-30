---
name: claude-md-development
description: "Manage CLAUDE.md documentation as the project's single source of truth. Use when updating seed system documentation, project overview, or synchronizing with actual skills. Includes CLAUDE.md structure, evergreen content principles, and cross-reference maintenance. Not for creating specific skills, commands, or agent configurations."
keywords: claude-md, documentation, evergreen, cross-reference, synchronization
---

## Quick Start

**Full audit:** `/claude-md-management:claude-md-improver` → Comprehensive review and update

**Why:** CLAUDE.md is single source of truth—maintains session behavior and component architecture.

## Navigation

| If you need... | Read this section... |
| :------------- | :------------------- |
| Full audit | ## Quick Start → /claude-md-management:claude-md-improver |
| Implementation patterns | ## PATTERN: Implementation Patterns |
| Troubleshooting | ## EDGE: Troubleshooting |
| Common mistakes | ## ANTI-PATTERN: Common Mistakes |
| Self-check | ## Recognition Questions |

## PATTERN: Operational Patterns

<mission_control>
<objective>Maintain CLAUDE.md as the project's single source of truth for session behavior and component architecture</objective>
<success_criteria>CLAUDE.md remains concise, evergreen, and synchronized with actual skills</success_criteria>
</mission_control>

---

## Quick Start

**Full audit:** `/claude-md-management:claude-md-improver` → Comprehensive review and update

**Why:** CLAUDE.md is single source of truth—maintains session behavior and component architecture.

## Navigation

| If you need...          | Read...                                                     |
| :---------------------- | :---------------------------------------------------------- |
| Full CLAUDE.md audit    | ## Quick Start → `/claude-md-management:claude-md-improver` |
| Implementation patterns | ## PATTERN: Implementation Patterns                         |

## PATTERN: Operational Patterns

This skill follows these behavioral patterns:

- **Discovery**: Locate files matching patterns and search file contents for documentation context
- **Delegation**: Delegate exploration to specialized workers for research
- **Tracking**: Maintain a visible task list for documentation updates

Trust native tools to fulfill these patterns. The System Prompt selects the correct implementation.

---

## PATTERN: Implementation Patterns

**Adding a new section to CLAUDE.md**:

```markdown
## New Section Name

Brief description of what this section covers.

| Concept | Description |
| ------- | ----------- |
| Item 1  | Explanation |

**Key Points**:

- Point one
- Point two

For detailed guidance, see: `docs/detailed-guide.md`
```

**Syncing CLAUDE.md with new meta-skill**:

1. Add entry to Key Meta-Skills table
2. Add navigation entry in Quick Navigation section
3. Verify link points to correct skill location
4. Update CLAUDE.md directly for architectural changes

**Maintaining progressive disclosure**:

```markdown
## High-Level Topic

Brief overview (2-3 sentences).

| If you need... | Read...                        |
| -------------- | ------------------------------ |
| Deep dive      | ## Deep Patterns               |
| Examples       | ## EDGE: Examples              |
```

---

## EDGE: Troubleshooting

| Issue | Symptom | Solution |
| :--- | :--- | :--- |
| Exceeds 500 lines | File unwieldy, hard to navigate | Move to references/; keep core in main |
| Links broken | 404 errors, missing references | Verify skill location; check naming |
| Table stale | Missing/duplicate entries | Update when adding/removing meta-skills |

---

## PATTERN: What CLAUDE.md Contains

### Role 1: Health Maintenance (Session-Only)

- Project overview and architecture
- Core principles and philosophy
- Development workflow guidance
- Navigation to rules, skills, and docs

### Role 2: Component Factory Reference

- Key meta-skills reference table
- Component-specific guidance links
- Quality standards and Success Criteria
- Portability invariant enforcement

---

## PATTERN: Update Protocol

### When to Update CLAUDE.md

**Update required when:**

- Adding new meta-skills (invocable-development, etc.)
- Changing core architecture (Layer A/Layer B)
- Modifying project structure or navigation
- Adding new documentation directories
- Changing quality standards

**No update needed for:**

- Individual skill/command content changes
- Minor reference file updates
- Example additions
- Routine maintenance

---

## PATTERN: Common Patterns

### Meta-Skill Table Format

```markdown
| Meta-Skill                | Purpose                  | Transformation                   |
| ------------------------- | ------------------------ | -------------------------------- |
| **invocable-development** | Creating portable skills | Tutorial → Architectural refiner |
```

---

## PATTERN: The Path to High-Quality Maintenance

### 1. Progressive Disclosure Keeps CLAUDE.md Readable

Keeping CLAUDE.md under 500 lines through progressive disclosure (references/ for details) ensures the main file stays scannable and actionable.

### 2. Link Validation Prevents Broken References

Validating all links before committing catches broken references early, maintaining documentation trustworthiness.

### 3. Meta-Skill Table Synchronization Maintains Discoverability

When adding or removing meta-skills, syncing the meta-skill table keeps the component index accurate and discoverable.

### 4. Evergreen Content Excludes Transient Notes

CLAUDE.md is evergreen documentation, not a scratchpad. Transient or TODO content belongs in planning files, not in the project documentation.

## ANTI-PATTERN: Common Mistakes

### Mistake 1: Including Generic Content

❌ **Wrong:**
```markdown
"How to write Markdown"
"What is YAML"
"Introduction to Git"
```

✅ **Correct:**
```markdown
// Assume Claude knows Markdown/YAML/Git basics
// Focus on project-specific conventions only
```

### Mistake 2: Over-Archiving (Context Rot)

❌ **Wrong:**
```markdown
// Archiving every decision and working command
- npm install (standard dependency install)
- git commit (standard version control)
- "Remember to run tests" (obvious)
```

✅ **Correct:**
```markdown
// Only archive non-obvious decisions
- Why we chose PostgreSQL over MySQL (project-specific trade-off)
- Custom auth middleware pattern (non-obvious architecture)
- "Gotcha": API returns 200 on partial failure (historical bug)
```

### Mistake 3: Adding Transient Notes

❌ **Wrong:**
```markdown
// TODO: Fix this section later
// Session notes: user wanted X but we did Y
```

✅ **Correct:**
```markdown
// Remove transient content entirely
// Use planning files for work-in-progress notes
```

### Mistake 4: Skipping Link Validation

❌ **Wrong:**
```markdown
See: `docs/non-existent-file.md`
```

✅ **Correct:**
```markdown
// Always verify links exist before committing
// Use grep or glob to confirm file paths
```

## PATTERN: Negative Delta Rule

Claude already knows:
- Standard commands (npm install, pnpm dev, git commit, etc.)
- Basic Git operations (commit, push, branch, merge)
- Common patterns (REST APIs, CRUD operations, auth flows)
- Programming language basics and standard library

Only archive if non-obvious:
- Project-specific conventions not in training data
- Non-obvious trade-offs (why X over Y in THIS project)
- Architecture decisions with specific rationale
- "Gotchas" that caused bugs in the past
- Custom tooling or scripts unique to this project

**Rule of thumb:** If a new developer could figure this out by reading the code, don't archive it.

---

## Recognition Questions

| Question | Check |
| :--- | :--- |
| Links verified? | No 404s, references exist |
| Meta-skill table synced? | Matches actual skills |
| No transient content? | Evergreen only, no TODOs |
| Progressive disclosure? | Under 500 lines or references/ |
| Delta Standard applied? | Claude already knows this? |

---

## PATTERN: Best Practices Summary

✅ **DO:**
- Keep CLAUDE.md under 500 lines with progressive disclosure
- Use tables for structured references and navigation
- Sync meta-skill table when adding/removing skills
- Validate all links before committing
- Document project-specific conventions, not generic knowledge

❌ **DON'T:**
- Include generic Markdown/YAML/Git explanations
- Archive standard commands or obvious decisions
- Add transient session notes or TODO items
- Create broken links to non-existent files
- Make CLAUDE.md a scratchpad for work-in-progress

---

<critical_constraint>
**Portability Invariant**: Zero external dependencies. Works standalone.
**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows
</critical_constraint>
