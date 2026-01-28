# Progressive Disclosure Refactoring Plan

**Objective**: Refactor skills to follow new progressive disclosure approach - SKILL.md contains full philosophy, references/ for ultra-situational only.

---

## Executive Summary

**Current State Analysis:**

- 53 skills total in `.claude/skills/`
- 14 skills have references/ directories
- Several skills exceed 600 lines in SKILL.md
- Many reference files lack "Use when" context

**Target State:**

- SKILL.md: ~400-600 lines with full philosophy, patterns, workflows
- references/: 2-3 files with "Use when" context, ultra-situational only
- No philosophy in references/, no summaries in SKILL.md

---

## Priority Classification

### Priority 1: High-Value Skills (Core Toolkit)

These skills are frequently used and should model best practices.

| Skill                   | Issue                                      | Action                                                    |
| ----------------------- | ------------------------------------------ | --------------------------------------------------------- |
| `invocable-development` | 20 reference files - consolidate to 8-10   | Review and consolidate references, add "Use when" context |
| `engineering-lifecycle` | 5 reference files - check organization     | Audit and add "Use when" context                          |
| `quality-standards`     | 3 reference files - already well-organized | Add "Use when" context if missing                         |

### Priority 2: Skills With Many References

| Skill                 | Files        | Action                                     |
| --------------------- | ------------ | ------------------------------------------ |
| `create-meta-prompts` | 9 references | Consolidate to 4-5, add "Use when" context |
| `manual-e2e-testing`  | 5 references | Audit, add "Use when" context              |
| `agent-development`   | 4 references | Add "Use when" context                     |

### Priority 3: Long SKILL.md Files (Review)

| Skill                 | Lines | Action                                                        |
| --------------------- | ----- | ------------------------------------------------------------- |
| `mcp-development`     | 888   | Review for content organization, may need references/         |
| `uv`                  | 696   | Review for opportunities to extract ultra-situational content |
| `create-meta-prompts` | 620   | Review after reference consolidation                          |

---

## Refactoring Workflow

### Phase 1: Audit (Per Skill)

For each skill, run this audit checklist:

```
1. Read SKILL.md
2. Check reference/ files:
   - Count: How many files?
   - Context: Does each have "Use when" at top?
   - Content: Is it ultra-situational (API specs, lookup) or philosophy?
3. Identify issues:
   - Philosophy in references/ → Move to SKILL.md
   - Missing "Use when" context → Add to each reference
   - Too many reference files → Consolidate related content
```

### Phase 2: Refactor (Per Skill)

**For SKILL.md:**

1. Ensure full philosophy is present (not summaries)
2. Add Navigation section with "If you need... Read..." table
3. Target ~500 lines (flexible for context)
4. Remove content that belongs in references/

**For references/:**

1. Add "Use when" context at top of each file
2. Ensure content is ultra-situational only
3. Remove philosophy/best practices (move to SKILL.md)
4. Target 2-3 files per skill

### Phase 3: Validation

```
1. Run `/toolkit:audit` on refactored skill
2. Verify: Full philosophy in SKILL.md
3. Verify: Each reference has "Use when" context
4. Verify: No duplication between SKILL.md and references/
```

---

## Detailed Skills Breakdown

### Skills Already Compliant ✓

| Skill              | Notes                                           |
| ------------------ | ----------------------------------------------- |
| `jules-api`        | 422 lines, 3 references with "Use when" context |
| `backend-patterns` | Has "If you need... Read..." navigation table   |

### Skills Needing "Use When" Context Added

| Skill                   | Reference Files | Missing Context              |
| ----------------------- | --------------- | ---------------------------- |
| `agent-development`     | 4 files         | All need "Use when" headers  |
| `create-meta-prompts`   | 9 files         | All start with "## Overview" |
| `engineering-lifecycle` | 5 files         | Check each file              |
| `manual-e2e-testing`    | 5 files         | Check each file              |
| `hook-development`      | 3 files         | Check each file              |
| `mcp-development`       | 4 files         | Check each file              |
| `perplexity-typescript` | 3 files         | Check each file              |
| `uv`                    | 2 files         | Check each file              |

### Skills Needing Reference Consolidation

| Skill                 | Current | Target    | Rationale                                                     |
| --------------------- | ------- | --------- | ------------------------------------------------------------- |
| `create-meta-prompts` | 9 files | 4-5 files | Group related patterns (questions, research, plans, metadata) |
| `manual-e2e-testing`  | 5 files | 3 files   | Consolidate related testing procedures                        |

### Skills Needing SKILL.md Review

| Skill                 | Lines | Potential Action                                |
| --------------------- | ----- | ----------------------------------------------- |
| `mcp-development`     | 888   | Extract tool development guide to reference/    |
| `uv`                  | 696   | Review for ultra-situational content to extract |
| `create-meta-prompts` | 620   | Will reduce after reference consolidation       |

---

## Implementation Order

### Batch 1: Quick Wins (Add "Use When" Context)

These skills just need "Use when" headers added to existing references:

1. `perplexity-typescript` (3 files)
2. `uv` (2 files)
3. `backend-patterns` (3 files) - verify and add if missing

**Estimated Time**: 30-45 minutes per skill

### Batch 2: Reference Consolidation

These skills need multiple reference files consolidated:

1. `create-meta-prompts` (9 → 4-5 files)
2. `manual-e2e-testing` (5 → 3 files)

**Estimated Time**: 2-3 hours per skill

### Batch 3: Complex Refactoring

These skills need both SKILL.md and references/ review:

1. `mcp-development` (888 lines + 4 references)
2. `agent-development` (add "Use when" context + review organization)

**Estimated Time**: 3-4 hours per skill

---

## Template for Reference Files

After refactoring, all reference files should follow this format:

```markdown
# Reference Title

Ultra-situational reference for X. Use when you need to look up Y.

---

## [Content starts immediately - no intro/overview]

[Detailed content, tables, code snippets...]
```

**Key principles:**

- First paragraph: "Use when you need..." (context, not summary)
- No "## Overview" section
- No philosophy or best practices (those go in SKILL.md)
- Content immediately after the context header

---

## Success Criteria

A skill is properly refactored when:

- [ ] SKILL.md contains full philosophy (delegation patterns, TDD, domain knowledge)
- [ ] SKILL.md has Navigation section with "If you need... Read..." table
- [ ] SKILL.md is ~400-600 lines (flexible for context)
- [ ] references/ has 2-3 files (rule of thumb)
- [ ] Each reference file has "Use when" context at top
- [ ] Reference content is ultra-situational only (no philosophy)
- [ ] No duplication between SKILL.md and references/
- [ ] `/toolkit:audit` passes with no critical findings

---

## Risk Mitigation

**Risk**: Breaking existing workflows during refactoring

**Mitigation**:

- Commit before each skill refactoring
- Test skill invocation after changes
- Keep backup of original structure

**Risk**: Over-consolidation losing useful context

**Mitigation**:

- Preserve ultra-situational content in references/
- Keep SKILL.md complete with full philosophy
- Audit after consolidation to verify nothing critical was removed

---

## Next Steps

1. **Pick a skill from Batch 1** (Quick Wins)
2. **Run audit**: Read SKILL.md and all reference files
3. **Add "Use when" context** to each reference file
4. **Update SKILL.md** Navigation section if needed
5. **Validate** with `/toolkit:audit`
6. **Move to next skill**

**Suggested starting order:**

1. `perplexity-typescript` - Simple, 3 files
2. `uv` - Simple, 2 files
3. `backend-patterns` - Already has navigation, just verify
4. `create-meta-prompts` - More complex, 9 files
5. `manual-e2e-testing` - 5 files
6. `mcp-development` - Complex, 888 lines + references
