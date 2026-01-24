# CLAUDE.md Quality Framework

Scoring system for evaluating memory file quality.

---

## Scoring Dimensions

| # | Dimension | Points | Key Criteria |
|---|-----------|--------|--------------|
| 1 | **Delta Compliance** | 20 | Expert-only knowledge, no generic content |
| 2 | **Structure** | 20 | Logical organization, proper hierarchy |
| 3 | **Clarity** | 20 | Unambiguous instructions, actionable |
| 4 | **Completeness** | 20 | Covers all project-specific needs |
| 5 | **Maintainability** | 20 | Easy to update, no redundancy |

**Total**: 100 points

---

## Dimension Details

### 1. Delta Compliance (20 pts)

**What it measures**: Only includes knowledge Claude doesn't already have.

| Score | Criteria |
|-------|----------|
| 20 | Zero generic content, all expert-level |
| 15 | Minimal generic, mostly project-specific |
| 10 | Mixed generic and specific |
| 5 | Mostly generic tutorials |
| 0 | Kitchen sink, extensive tutorials |

**Check**: For each section, ask "Would a senior dev need to tell Claude this?"
- YES → Keep
- NO → Remove

---

### 2. Structure (20 pts)

**What it measures**: Logical organization and navigation.

| Score | Criteria |
|-------|----------|
| 20 | Clear hierarchy, @imports used, modular |
| 15 | Good sections, some could be extracted |
| 10 | Basic sections, no modularity |
| 5 | Flat structure, hard to navigate |
| 0 | No organization, wall of text |

**Check**:
- [ ] Clear section headers (##, ###)
- [ ] Related content grouped
- [ ] Modular rules in `.claude/rules/`
- [ ] @imports for reusable content
- [ ] Path-specific rules with frontmatter

---

### 3. Clarity (20 pts)

**What it measures**: How unambiguous and actionable instructions are.

| Score | Criteria |
|-------|----------|
| 20 | All instructions specific and actionable |
| 15 | Most clear, few vague statements |
| 10 | Some ambiguity, needs interpretation |
| 5 | Vague, open to interpretation |
| 0 | Contradictory or confusing |

**Check**:
- [ ] Uses "ALWAYS" / "NEVER" for absolutes
- [ ] Provides examples for complex patterns
- [ ] No "should consider" or "might want to"
- [ ] Commands are copy-pasteable

---

### 4. Completeness (20 pts)

**What it measures**: Covers all project-specific needs.

| Score | Criteria |
|-------|----------|
| 20 | Comprehensive coverage, handles edge cases |
| 15 | Core topics covered, minor gaps |
| 10 | Basic coverage, missing some areas |
| 5 | Significant gaps |
| 0 | Missing critical information |

**Essential Coverage**:
- [ ] Project overview / tech stack
- [ ] Code organization rules
- [ ] Testing patterns
- [ ] Security constraints
- [ ] Key commands
- [ ] Common patterns
- [ ] What NOT to do

---

### 5. Maintainability (20 pts)

**What it measures**: How easy it is to keep updated.

| Score | Criteria |
|-------|----------|
| 20 | Modular, no redundancy, versioned |
| 15 | Easy to update, minor redundancy |
| 10 | Some duplicate content to maintain |
| 5 | Hard to find what to update |
| 0 | Massive file, extensive duplication |

**Check**:
- [ ] Single source of truth for each topic
- [ ] No copy-paste between files
- [ ] Clear ownership of each section
- [ ] Version/date on changing sections
- [ ] Dead references cleaned up

---

## Grade Thresholds

| Grade | Score | Description |
|-------|-------|-------------|
| **A** | 90-100 | Exemplary - minimal refinement needed |
| **B** | 75-89 | Good - minor improvements possible |
| **C** | 60-74 | Adequate - noticeable issues |
| **D** | 40-59 | Poor - significant refactoring needed |
| **F** | 0-39 | Failing - major overhaul required |

---

## Common Failure Patterns

### Kitchen Sink (Delta: 0-5)

**Symptom**: File contains everything the author knows about the topic.

```markdown
## React Best Practices
React is a JavaScript library for building user interfaces. Components
are the building blocks of React applications. You can create components
using either classes or functions. Hooks were introduced in React 16.8...
[continues for 200 lines]
```

**Fix**: Remove all generic content, keep only project-specific decisions.

---

### Stale References (Maintainability: 0-10)

**Symptom**: Links to moved/deleted files, outdated commands.

```markdown
See [old-architecture.md](docs/old-architecture.md)  # File deleted
Run `npm run deprecated-script`                       # Command renamed
```

**Fix**: Regular audits, automated link checking.

---

### Instruction Drift (Clarity: 0-10)

**Symptom**: Rules no longer match actual codebase.

```markdown
## Styling
Use CSS Modules for all components.
# But codebase has switched to Tailwind
```

**Fix**: Quarterly audits, post-refactor reviews.

---

### Duplicate Content (Maintainability: 0-10)

**Symptom**: Same information in multiple places.

```markdown
# CLAUDE.md
Use ESLint with our .eslintrc config.

# .claude/rules/linting.md (same content)
Use ESLint with our .eslintrc config.
```

**Fix**: Single source, use @imports for references.

---

### Vague Instructions (Clarity: 0-10)

**Symptom**: Instructions open to interpretation.

```markdown
## Code Quality
- Try to write clean code
- Consider adding tests
- Think about performance
```

**Fix**: Make specific and actionable:

```markdown
## Code Quality
- Max 200 lines per file, extract if exceeded
- Unit test coverage > 80%, integration tests for APIs
- Use React.memo for expensive renders, profile before optimizing
```

---

## Quick Audit Checklist

### Pass/Fail Criteria

| Check | Pass | Fail |
|-------|------|------|
| Total lines | < 500 | > 500 |
| Generic content | < 10% | > 30% |
| Broken references | 0 | Any |
| Duplicate sections | 0 | Any |
| Vague instructions | < 5% | > 20% |
| Last audit | < 3 months | > 6 months |

### Scoring Shortcut

Quick mental scoring without detailed analysis:

1. **Skim for tutorials** → Each found: -5 Delta
2. **Count sections** → < 10 with clear hierarchy: +15 Structure
3. **Find "should" / "might"** → Each found: -2 Clarity
4. **Check for gaps** → Missing core topic: -10 Completeness
5. **Search for duplicates** → Each found: -5 Maintainability

---

## Report Template

```markdown
## CLAUDE.md Quality Audit

### File: {path}
**Date**: {date}
**Auditor**: Agent/Human

### Scores

| Dimension | Score | Notes |
|-----------|-------|-------|
| Delta Compliance | /20 | |
| Structure | /20 | |
| Clarity | /20 | |
| Completeness | /20 | |
| Maintainability | /20 | |
| **Total** | /100 | **Grade: X** |

### Priority Issues

1. [HIGH] {issue}
2. [MEDIUM] {issue}
3. [LOW] {issue}

### Recommendations

1. {action}
2. {action}

### Next Audit: {date + 3 months}
```
