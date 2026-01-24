# Comprehensive Refactoring Plan

**Date**: 2026-01-24
**Goal**: Align codebase with skill-creator best practices while preserving unique value
**Approach**: Plan → Estimate → Execute

---

## Executive Summary

This plan addresses 15 identified issues across 4 categories: Foundation, Skills, References, and Anti-Patterns. The refactoring follows the principle of **teaching through philosophy and trust, not prescription and mandates**.

**Key Decisions Made**:
1. Keep architect-knowledge split but consolidate -knowledge into -architect references/
2. Keep specialized skills: ralph-orchestrator, test-runner, claude-md-manager
3. Merge skills-architect + skills-knowledge into unified skills-domain
4. Move meta-architect-claudecode content to CLAUDE.md rules
5. Create philosophy.md and teaching.md in .claude/rules/
6. Change MANDATORY URL fetching to RECOMMENDED
7. Accept test-runner at 748 lines (infrastructure justifies size)

---

## Phase 1: Foundation (Rules & Philosophy)

### 1.1 Create `.claude/rules/philosophy.md`

**Purpose**: Teach core principles before process
**Effort**: 2-3 hours

**Content**:
- "Context window is a public good" principle
- Degrees of Freedom framework (High/Medium/Low specificity)
- "Claude is already smart" - trust AI intelligence
- Local project autonomy
- Delta Standard explanation
- Progressive disclosure as cognitive load management

**Template Structure**:
```markdown
# Philosophy

## Context Window as Public Good

## Degrees of Freedom Framework

## Trust AI Intelligence

## Local Project Autonomy

## The Delta Standard

## Progressive Disclosure Philosophy
```

### 1.2 Create `.claude/rules/teaching.md`

**Purpose**: Teach HOW to teach skills effectively
**Effort**: 2-3 hours

**Content**:
- When to use examples vs principles
- What-When-Not framework for descriptions
- Progressive disclosure patterns (from skill-creator)
- Skill evolution guidance
- Learning path design
- How to recognize over-prescription

**Template Structure**:
```markdown
# Teaching Skills Effectively

## What-When-Not Framework

## Progressive Disclosure Patterns

## Example vs Principle Balance

## Recognition: Over-Prescription

## Skill Evolution Guidance
```

### 1.3 Restructure CLAUDE.md

**Purpose**: Philosophy-first foundation
**Effort**: 1-2 hours

**Changes**:
- Start with philosophy principles (link to philosophy.md)
- Then "Critical Actions" as applications of principles
- Keep "TO KNOW WHEN" as recognition patterns
- Move meta-architect layer selection content here

### 1.4 Update `.claude/rules/` Files

**Purpose**: Apply teaching principles to existing rules
**Effort**: 3-4 hours

**Files to Update**:
- `anti-patterns.md`: Add skill documentation anti-patterns (README.md, etc.)
- `architecture.md`: Emphasize philosophy before patterns
- `quality-framework.md`: Add philosophy context to scoring
- `quick-reference.md`: Reduce prescription, increase principle guidance

---

## Phase 2: URL Fetching Refactor (21 Files)

### 2.1 Change MANDATORY to RECOMMENDED

**Purpose**: Reduce friction, trust AI judgment
**Effort**: 4-6 hours

**Affected Files** (21 total):
```
.claude/skills/toolkit-architect/SKILL.md
.claude/skills/meta-architect-claudecode/SKILL.md
.claude/skills/hooks-architect/SKILL.md
.claude/skills/mcp-architect/SKILL.md
.claude/skills/subagents-architect/SKILL.md
.claude/skills/skills-architect/SKILL.md
.claude/skills/task-architect/SKILL.md
.claude/skills/ralph-orchestrator-expert/SKILL.md
... (13 more files with URL fetching sections)
```

**Pattern to Apply**:
```markdown
## BEFORE (Anti-pattern)
### 🚨 MANDATORY: Read BEFORE Proceeding
**CRITICAL**: You MUST read and understand these URLs:
- **BLOCKING RULES**: DO NOT proceed until you've fetched...

## AFTER (Best practice)
### RECOMMENDED: Context Validation
Read these URLs when accuracy matters:
- **When to fetch**: Docs may have changed, haven't read recently, user requests verification
- **When to skip**: Local-only work, offline, known-stable documentation
- **Trust your judgment**: You know when validation is needed
```

**Decision Tree for Each File**:
1. Is this core documentation that changes often? → Keep RECOMMENDED
2. Is this rarely-changing stable reference? → Make OPTIONAL
3. Is this architectural foundation? → Keep RECOMMENDED with context
4. Is this edge case? → Remove entirely

---

## Phase 3: Skill Consolidation

### 3.1 Merge skills-architect + skills-knowledge

**Purpose**: Unified skills-domain skill with progressive disclosure
**Effort**: 6-8 hours

**New Structure**:
```
.claude/skills/skills-domain/
├── SKILL.md (<400 lines)
│   ├── Frontmatter: description (What-When-Not)
│   ├── Overview
│   ├── Workflow Detection (ASSESS/CREATE/EVALUATE/ENHANCE)
│   ├── Quick Reference
│   └── Link to references/
└── references/
    ├── creation.md (from skills-knowledge)
    ├── quality-framework.md (merged)
    ├── autonomy-design.md (from skills-architect)
    ├── extraction-methods.md (from skills-architect)
    ├── progressive-disclosure.md (from skills-architect)
    └── workflow-examples.md (from skills-architect)
```

**Migration Steps**:
1. Create new skills-domain directory
2. Merge frontmatter (combine descriptions)
3. Keep SKILL.md under 400 lines (core workflows only)
4. Move detailed content to references/
5. Remove skills-architect and skills-knowledge directories
6. Update all references to these skills

### 3.2 Merge subagents-architect + subagents-knowledge

**Purpose**: Unified subagents-domain skill
**Effort**: 4-5 hours

**Pattern**: Same as skills-architect merge above
- SKILL.md: workflows + quick reference
- references/: detailed implementation guides

### 3.3 Merge hooks-architect + hooks-knowledge

**Purpose**: Unified hooks-domain skill
**Effort**: 4-5 hours

**Pattern**: Same as skills-architect merge

### 3.4 Merge mcp-architect + mcp-knowledge

**Purpose**: Unified mcp-domain skill
**Effort**: 3-4 hours

**Pattern**: Same as skills-architect merge

### 3.5 Consolidate task-architect into task-knowledge

**Purpose**: TaskList is infrastructure, not domain routing
**Effort**: 2-3 hours

**Approach**: Keep task-knowledge as the primary skill, integrate task-architect workflows into it

### 3.6 Deprecate meta-architect-claudecode (Move to Rules)

**Purpose**: Layer selection is foundational, not a skill
**Effort**: 2-3 hours

**Migration**:
1. Move layer selection decision tree to quick-reference.md
2. Move orchestration patterns to architecture.md
3. Move core values to philosophy.md
4. Archive meta-architect-claudecode to .attic/ with usage note

---

## Phase 4: Reference File Optimization

### 4.1 Large Reference File Splitting

**Purpose**: Progressive disclosure compliance
**Effort**: 4-5 hours

**Files to Split** (>500 lines):
```
hooks-architect/references/hook-types.md (991 lines)
  → Split into: basics.md, events.md, configuration.md

skills-architect/references/docs-comparison.md (708 lines)
  → Extract core patterns, archive full comparison

ralph-orchestrator-expert/references/prompt-engineering.md (1075 lines)
  → Split into: patterns.md, examples.md, anti-patterns.md
```

### 4.2 Duplicate Reference Consolidation

**Purpose**: Single source of truth for common patterns
**Effort**: 3-4 hours

**Create Shared References**:
```
.claude/skills/shared-references/
├── script-best-practices.md (consolidated)
├── quality-framework-common.md (consolidated)
├── workflow-patterns.md (consolidated)
└── tasklist-integration.md (centralized)
```

**Update All Skills**: Reference shared-references/ instead of duplicating

---

## Phase 5: Anti-Pattern Removal

### 5.1 Remove Prescriptive "How" Language

**Purpose**: Trust AI intelligence over step-by-step instructions
**Effort**: 3-4 hours

**Files to Update** (found with "Step X", "How to"):
```
meta-architect-claudecode/references/autonomy-decision-tree.md
toolkit-architect/references/component-patterns.md
toolkit-architect/references/validation-checklist.md
```

**Pattern to Apply**:
```markdown
## BEFORE (Anti-pattern)
### How to Create a Skill
1. Create directory
2. Write SKILL.md
3. Add references/

## AFTER (Best practice)
### Skill Creation Principles
- **Location**: .claude/skills/{name}/
- **Core**: SKILL.md with What-When-Not description
- **Optional**: references/ for detailed content
- **Trust**: You know the structure, adapt as needed
```

### 5.2 Remove Extraneous Documentation References

**Purpose**: Skill-creator explicitly teaches against these
**Effort**: 1-2 hours

**Remove mentions of**:
- README.md
- INSTALLATION_GUIDE.md
- QUICK_REFERENCE.md
- CHANGELOG.md
- Any auxiliary documentation files

**Files Affected**:
```
toolkit-architect/references/troubleshooting.md
ralph-orchestrator-expert/references/prompt-engineering.md
```

### 5.3 Standardize Completion Markers

**Purpose**: Consistent output patterns
**Effort**: 1-2 hours

**Standard Format**:
```markdown
## {SKILL_NAME}_COMPLETE

Workflow: [mode]
Result: [summary]
Next: [recommendation]
```

**Apply to All Skills**: Ensure consistent marker format

### 5.4 Standardize Context Fork Usage

**Purpose**: Predictable -knowledge skill behavior
**Effort**: 1-2 hours

**Rule**: All -knowledge skills use `context: fork` for isolation

**Apply to**:
- skills-knowledge → skills-domain references loaded separately
- subagents-knowledge → subagents-domain references loaded separately
- hooks-knowledge → hooks-domain references loaded separately
- mcp-knowledge → mcp-domain references loaded separately
- task-knowledge → keep as standalone (no context: fork needed)

---

## Phase 6: Cleanup & Validation

### 6.1 Remove Deprecated Skills

**Purpose**: Clean consolidation artifacts
**Effort**: 1-2 hours

**Remove** (after consolidation):
```
.claude/skills/skills-architect/
.claude/skills/skills-knowledge/
.claude/skills/subagents-architect/
.claude/skills/subagents-knowledge/
.claude/skills/hooks-architect/
.claude/skills/hooks-knowledge/
.claude/skills/mcp-architect/
.claude/skills/mcp-knowledge/
.claude/skills/task-architect/
.claude/skills/meta-architect-claudecode/ → .attic/
```

### 6.2 Update reference-index.md

**Purpose**: Reflect new structure
**Effort**: 1-2 hours

**New Structure**:
```
## Domain Skills
- skills-domain (merged skills-architect + skills-knowledge)
- subagents-domain (merged subagents-architect + subagents-knowledge)
- hooks-domain (merged hooks-architect + hooks-knowledge)
- mcp-domain (merged mcp-architect + mcp-knowledge)
- task-domain (merged task-architect + task-knowledge)

## Specialized Skills
- ralph-orchestrator-expert
- test-runner
- claude-md-manager
- toolkit-architect
- toolkit-quality-validator
- skill-metacritic

## Shared References
- script-best-practices.md
- quality-framework-common.md
- workflow-patterns.md
- tasklist-integration.md
```

### 6.3 Update CLAUDE.md References

**Purpose**: Sync documentation with new structure
**Effort**: 1-2 hours

**Updates**:
- Update skill references
- Update routing descriptions
- Add philosophy.md and teaching.md links
- Remove deprecated skill references

---

## Effort Estimation Summary

| Phase | Tasks | Estimated Time |
|-------|-------|----------------|
| Phase 1: Foundation | 4 tasks | 8-12 hours |
| Phase 2: URL Fetching | 1 task (21 files) | 4-6 hours |
| Phase 3: Skill Consolidation | 6 merges | 21-25 hours |
| Phase 4: Reference Optimization | 2 tasks | 7-9 hours |
| Phase 5: Anti-Pattern Removal | 4 tasks | 6-10 hours |
| Phase 6: Cleanup & Validation | 3 tasks | 3-6 hours |
| **Total** | **20 tasks** | **49-68 hours** |

**Suggested Phasing**:
- **Iteration 1** (High Priority): Phase 1 + Phase 2 (12-18 hours)
- **Iteration 2** (Core Consolidation): Phase 3 (21-25 hours)
- **Iteration 3** (Optimization): Phase 4 + Phase 5 (13-19 hours)
- **Iteration 4** (Finalization): Phase 6 (3-6 hours)

---

## Success Criteria

### Quantitative
- [ ] Reduce skill count from 18 to ~10
- [ ] All SKILL.md files under 500 lines (except test-runner)
- [ ] Zero "MANDATORY" URL fetching blocks
- [ ] philosophy.md and teaching.md created
- [ ] All duplicate references consolidated

### Qualitative
- [ ] Philosophy taught before process in all rules
- [ ] "Trust AI Intelligence" principle embodied throughout
- [ ] What-When-Not framework applied to all skill descriptions
- [ ] Progressive disclosure properly implemented
- [ ] Zero over-prescriptive "how" language in references

---

## Risk Mitigation

### Risk 1: Breaking Existing Workflows
**Mitigation**: Keep toolkit-architect routing intact until all consolidations complete

### Risk 2: Losing Valuable Content
**Mitigation**: Move deprecated skills to .attic/ before deletion

### Risk 3: Reference Link Breakage
**Mitigation**: Update reference-index.md first, track all link updates

### Risk 4: Scope Creep
**Mitigation**: This plan is the boundary - any new issues go to backlog

---

## Next Steps

1. **Review this plan** for completeness and accuracy
2. **Confirm scope**: Full comprehensive or high-priority only?
3. **Begin with Phase 1** (Foundation) if approved
4. **Track progress** with TaskList if multi-session work

---

## Appendix: Issue Mapping

| Issue ID | Description | Phase | Status |
|----------|-------------|-------|--------|
| F1 | Missing philosophy.md | 1.1 | Pending |
| F2 | Missing teaching.md | 1.2 | Pending |
| F3 | CLAUDE.md needs restructuring | 1.3 | Pending |
| F4 | Existing rules need update | 1.4 | Pending |
| U1 | Mandatory URL fetching (21 files) | 2.1 | Pending |
| S1 | skills-architect + skills-knowledge overlap | 3.1 | Pending |
| S2 | subagents-architect + subagents-knowledge overlap | 3.2 | Pending |
| S3 | hooks-architect + hooks-knowledge overlap | 3.3 | Pending |
| S4 | mcp-architect + mcp-knowledge overlap | 3.4 | Pending |
| S5 | task-architect integration | 3.5 | Pending |
| S6 | meta-architect-claudecode to rules | 3.6 | Pending |
| R1 | Large reference files | 4.1 | Pending |
| R2 | Duplicate references | 4.2 | Pending |
| A1 | Prescriptive "how" language | 5.1 | Pending |
| A2 | Extraneous doc references | 5.2 | Pending |
| A3 | Inconsistent completion markers | 5.3 | Pending |
| A4 | Context fork inconsistencies | 5.4 | Pending |
| C1 | Deprecated skill removal | 6.1 | Pending |
| C2 | reference-index.md update | 6.2 | Pending |
| C3 | CLAUDE.md sync | 6.3 | Pending |
