---
name: claude-md-development
description: "Manage CLAUDE.md documentation as the project's single source of truth. Use when updating seed system documentation, project overview, or synchronizing with .claude/rules/. Includes CLAUDE.md structure, evergreen content principles, and cross-reference maintenance. Not for creating specific skills, commands, or agent configurations."
---

# Claude.md Development

<mission_control>
<objective>Maintain CLAUDE.md as the project's single source of truth for session behavior and component architecture</objective>
<success_criteria>CLAUDE.md remains concise, evergreen, and synchronized with .claude/rules/ and component meta-skills</success_criteria>
</mission_control>

---

## Quick Start

**Archive learning:** `/learning:archive` → Capture session discoveries to CLAUDE.md

**Full audit:** `/claude-md-management:claude-md-improver` → Comprehensive review and update

**Refine rules:** `/learning:refine-rules` → Synchronize with `.claude/rules/`

**Why:** CLAUDE.md is single source of truth—maintains session behavior and component architecture.

## Navigation

| If you need...          | Read...                                                     |
| :---------------------- | :---------------------------------------------------------- |
| Archive learning        | ## Quick Start → `/learning:archive`                        |
| Full CLAUDE.md audit    | ## Quick Start → `/claude-md-management:claude-md-improver` |
| Refine rules            | ## Quick Start → `/learning:refine-rules`                   |
| Update rules            | ## Quick Start → ### Updating Rules?                        |
| Implementation patterns | ## Implementation Patterns                                  |

### Updating Rules?

1. **Refine Existing Rules** → Use `/learning:refine-rules`
2. **Check Consistency** → Manual review with `.claude/rules/` files
3. **Add New Rule** → Add to appropriate rules file + sync CLAUDE.md

## Operational Patterns

This skill follows these behavioral patterns:

- **Discovery**: Locate files matching patterns and search file contents for documentation context
- **Delegation**: Delegate exploration to specialized workers for research
- **Tracking**: Maintain a visible task list for documentation updates

Trust native tools to fulfill these patterns. The System Prompt selects the correct implementation.

---

## Implementation Patterns

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
4. Update `.claude/rules/` if architectural change

**Maintaining progressive disclosure**:

```markdown
## High-Level Topic

Brief overview (2-3 sentences).

| If you need... | Read...                        |
| -------------- | ------------------------------ |
| Deep dive      | `references/detailed-topic.md` |
| Examples       | `references/examples.md`       |
```

---

## Troubleshooting

**Issue**: CLAUDE.md exceeds 500 lines

- **Symptom**: File feels unwieldy, hard to navigate
- **Solution**: Move detailed content to references/; keep core in main file

**Issue**: Links to skills/commands broken

- **Symptom**: 404 errors or missing references
- **Solution**: Verify skill location; check command naming convention

**Issue**: Out of sync with .claude/rules/

- **Symptom**: Contradictory guidance between files
- **Solution**: Run `/claude-md-management:claude-md-improver` for audit

**Issue**: Meta-skill table stale

- **Symptom**: Missing or duplicate entries
- **Solution**: Update table when adding/removing meta-skills

---

## What CLAUDE.md Contains

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

## Update Protocol

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

## Content Synchronization

### Critical Synchronization Points

**CLAUDE.md ↔ .claude/rules/**

| CLAUDE.md Section | Rules File      | Sync Action                                |
| ----------------- | --------------- | ------------------------------------------ |
| Philosophy table  | principles.md   | Update table when principles change        |
| Key Meta-Skills   | All meta-skills | Add/remove entries when meta-skills change |
| Navigation        | patterns.md     | Ensure consistent terminology              |

**CLAUDE.md ↔ Meta-Skills**

| CLAUDE.md Reference | Meta-Skill                  | Sync Action                                    |
| ------------------- | --------------------------- | ---------------------------------------------- |
| Component Guidance  | invocable-development, etc. | Update links when meta-skill structure changes |
| Quality Standards   | quality-standards           | Align Success Criteria descriptions            |

---

## Best Practices

### Structure

- **Keep it concise**: CLAUDE.md should be ~300-500 lines max
- **Evergreen content**: Avoid transient information
- **Single source of truth**: Each concept documented once
- **Progressive disclosure**: High-level in CLAUDE.md, details in references/

### Navigation

- Use tables for structured references
- Include both file paths and descriptions
- Mark mandatory references clearly
- Cross-link to docs/ directory for extended content

### Quality

- Validate all links actually exist
- Ensure consistency with .claude/rules/
- Keep meta-skill table current
- Sync Success Criteria with quality-standards

---

## Common CLAUDE.md Patterns

### Philosophy Table Format

```markdown
| File          | Layer    | Content                                        |
| ------------- | -------- | ---------------------------------------------- |
| principles.md | **Both** | Dual-layer architecture, Portability Invariant |
| patterns.md   | **Both** | Implementation patterns, Degrees of Freedom    |
```

### Meta-Skill Table Format

```markdown
| Meta-Skill                | Purpose                  | Transformation                   |
| ------------------------- | ------------------------ | -------------------------------- |
| **invocable-development** | Creating portable skills | Tutorial → Architectural refiner |
```

### Component Guidance Format

```markdown
## Component-Specific Guidance

For detailed guidance on creating portable components, consult the appropriate meta-skill:

| Component | Meta-Skill            | Output Traits             |
| --------- | --------------------- | ------------------------- |
| Skills    | invocable-development | Portable, self-sufficient |
```

---

## Anti-Patterns

### DON'T: Include Generic Content

❌ "How to write Markdown"
❌ "What is YAML"
❌ "Introduction to Git"

### DON'T: Duplicate Content

❌ Repeating rules from .claude/rules/
❌ Copying meta-skill content into CLAUDE.md
❌ Duplicating philosophy explanations

### DON'T: Make It Transient

❌ Including session-specific notes
❌ Temporary workarounds
❌ "TODO" items for future work

---

## Navigation

For hybrid format standards (Markdown + XML), see the **hybrid-format rule**.

For architectural philosophy, see: `docs/philosophy/deep-dives.md`

For development guidance, see: `invocable-development` skill

---

<guiding_principles>

## The Path to High-Quality CLAUDE.md Maintenance

### 1. Progressive Disclosure Keeps CLAUDE.md Readable

Keeping CLAUDE.md under 500 lines through progressive disclosure (references/ for details) ensures the main file stays scannable and actionable.

### 2. Link Validation Prevents Broken References

Validating all links before committing catches broken references early, maintaining documentation trustworthiness.

### 3. Meta-Skill Table Synchronization Maintains Discoverability

When adding or removing meta-skills, syncing the meta-skill table keeps the component index accurate and discoverable.

### 4. Evergreen Content Excludes Transient Notes

CLAUDE.md is evergreen documentation, not a scratchpad. Transient or TODO content belongs in planning files, not in the project documentation.

</guiding_principles>

<critical_constraint>
**System Physics:**

1. Zero external dependencies for portable components
2. CLAUDE.md is project documentation, not portable component
   </critical_constraint>
