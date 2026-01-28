# Quality Framework

Practical checklist for skill quality assessment and production readiness.

---

## Quick Assessment Checklist

Before deploying a skill, run through these practical checks:

### Essential (All Must Pass)

**Description Quality**:

- [ ] Clearly describes WHAT the skill does
- [ ] Specifies WHEN to use it (concrete triggers)
- [ ] Defines boundaries (NOT for X)
- [ ] No "Use to CREATE/REFACTOR" language

**Autonomy**:

- [ ] Can complete without asking user questions
- [ ] Has clear completion marker
- [ ] Self-contained (no external dependencies assumed)
- [ ] Trusts AI intelligence (no micromanagement)

**Structure**:

- [ ] YAML frontmatter valid (name, description)
- [ ] SKILL.md ~500 lines (flexible for contextualization and readability)
- [ ] Progressive disclosure: Tier 1 (metadata) → Tier 2 (full philosophy) → Tier 3 (ultra-situational)
- [ ] No extraneous files (README.md, INSTALLATION_GUIDE.md, etc.)

### Important (Apply When Relevant)

**Content Quality**:

- [ ] Expert-only knowledge (no Claude-obvious explanations)
- [ ] Principles over prescriptions (teaches WHY, not just HOW)
- [ ] Practical examples when style matters
- [ ] Conversational tone (trusts intelligence)

**Trust AI Intelligence**:

- [ ] No "Step 1, Step 2, Step 3" for obvious operations
- [ ] No "You must", "You shall", "Required" for non-critical things
- [ ] "Consider X" rather than "Do X" (allows judgment)
- [ ] Focuses on domain expertise, not basic programming

### Nice to Have

**Innovation**: Provides unique capability not easily replicated
**Performance**: Token-efficient workflows
**Maintainability**: Well-organized, easy to update

---

## Quality Dimensions

### Knowledge Delta

**CRITICAL: Expert-only vs Claude-obvious**

**Recognition Questions**:

- Would Claude know this without being told?
- Is this expert-only or generic information?
- Does this justify its token cost?

**High Quality Indicators**:

- 100% project-specific
- No generic tutorials
- Expert patterns only
- Non-obvious insights

**Low Quality Indicators**:

- Generic programming concepts
- Tutorial-style content
- Information Claude already knows

### Autonomy

**80-95% completion without questions**

**Recognition**: Count questions in test output. 0-1 questions = 95%, 2-3 = 85-90%, 6+ = <80%

**High Quality Indicators**:

- 0-2 questions asked
- Completes tasks independently
- Clear decision criteria
- Concrete patterns provided

**Low Quality Indicators**:

- 6+ questions needed
- Requires constant guidance
- Vague instructions

### Discoverability

**Clear description with triggers (What-When-Not framework)**

**High Quality Example**:

```yaml
---
name: api-conventions
description: "API design patterns for this codebase. Use when writing endpoints, modifying existing endpoints, or reviewing API changes."
---
```

**Low Quality Example**:

```yaml
---
name: helper
description: "A helpful skill for development"
---
```

### Progressive Disclosure

**Tier 1/2/3 properly organized**

**CRITICAL**: SKILL.md should contain FULL philosophy and patterns, not summaries. References/ are ONLY for ultra-situational lookup material.

**Targets**:

- Tier 1: ~100 tokens (metadata)
- Tier 2: ~500 lines SKILL.md (flexible for context - full philosophy, patterns, workflows)
- Tier 3: 2-3 reference files (rule of thumb - ultra-situational: API specs, code snippets, troubleshooting)

**High Quality Indicators**:

- Tier 1: ~100 token description (What-When-Not)
- Tier 2: Complete philosophy in SKILL.md (delegation patterns, TDD, domain knowledge)
- Tier 3: Ultra-situational only (API specs, lookup tables, edge cases)
- Each reference has clear "Use when" context without spoiling content

**Low Quality Indicators**:

- Philosophy in references/ (should be in SKILL.md)
- SKILL.md as summary only with links to references for content
- Missing "Use when" context in reference files
- Arbitrary 500-line enforcement against contextualization

---

## Common Quality Issues

### Issue 1: Generic Knowledge (Low Delta)

**Problem**:

```markdown
# API Skill

APIs are how applications communicate...

REST uses HTTP methods:
GET - Read data
POST - Create data
...
```

**Fix**:

```markdown
# API Conventions

## Our Pattern

- Base: `/api/v1/{resource}`
- Response: `{ data, error, meta }`

## Why This Matters

Plural routes support HATEOAS. Separate error field prevents data pollution.
```

### Issue 2: Low Autonomy

**Problem**:

```markdown
# File Organizer

Organize files.
```

Questions: "How?" "What criteria?" "Where?"

**Fix**:

```markdown
# File Organizer

Organize by type:

- Code: _.js, _.ts → src/
- Tests: _.test._ → tests/
- Docs: \*.md → docs/

Output: List of moves.
```

Questions: 0

### Issue 3: Poor Discoverability

**Problem**:

```yaml
---
name: helper
description: "A helpful skill for development"
---
```

**Fix**:

```yaml
---
name: api-standards
description: "API design standards for this project. Use when creating, modifying, or reviewing endpoints."
---
```

### Issue 4: Missing Progressive Disclosure

**Problem**:

```markdown
# API Skill (800 lines)

Everything: basics, advanced, examples, troubleshooting, error handling, testing, deployment...
```

**Fix**:

```markdown
# API Skill (400 lines with full philosophy)

## Delegation Philosophy

[Complete patterns, not summaries...]

## TDD Requirements

[Full TDD methodology, not just "see references"...]

## Key Patterns

[All important patterns inline...]

## Navigation

**Local References**:

| If you need...       | Read...                     |
| -------------------- | --------------------------- |
| API endpoint details | references/api-reference.md |

Note: SKILL.md contains full philosophy and patterns. References/ are for ultra-situational lookup only.
```

**Recognition**: The goal is NOT to minimize lines, but to put full philosophy in SKILL.md and use references/ for lookup material.

---

## Rationalization Prevention

Common excuses for skipping quality checks, and reality:

| Rationalization (Stop)       | Reality                                   |
| ---------------------------- | ----------------------------------------- |
| "This is just a quick skill" | Quality shortcuts create maintenance debt |
| "I'll clean it up later"     | "Later" never comes                       |
| "It's obvious how to use"    | Clear descriptions prevent confusion      |
| "They can figure it out"     | Self-documenting code is a myth           |
| "Generic content is fine"    | Claude already knows this                 |
| "More details can't hurt"    | Every token costs context                 |
| "Questions are OK"           | Autonomy requires minimal questions       |
| "Tier structure is overkill" | Progressive disclosure prevents overwhelm |
| "I know what I'm doing"      | Subjective quality leads to inconsistency |
| "Tests will catch issues"    | Quality prevents issues, tests find them  |

## Recognition Questions

Use these questions to assess quality:

**Knowledge Delta**:

- "Would Claude know this without being told?"
- "Is this expert-only or generic?"
- "Does this justify its token cost?"

**Autonomy**:

- "How many questions does this skill ask?"
- "Can it complete tasks independently?"
- "Are concrete patterns provided?"

**Discoverability**:

- "Does description signal WHAT/WHEN/NOT?"
- "Are triggers specific and clear?"
- "Can Claude tell when to use this?"

**Progressive Disclosure**:

- "Is SKILL.md ~500 lines with full philosophy (not just summaries)?"
- "Are references/ only for ultra-situational lookup (API specs, code snippets)?"
- "Does each reference have clear 'Use when' context?"
- "Is the 500-line target applied flexibly for contextualization?"

---

## Success Criteria

**Production Ready**: Pass all Essential checks + most Important checks

**Minimum for Production**:

- Knowledge Delta: Expert-only (no generic content)
- Autonomy: 80%+ (0-5 questions per session)
- Discoverability: Clear WHAT/WHEN/NOT triggers
- Progressive Disclosure: Proper tier structure

---

## Summary

**Quality is about**:

1. **Value**: Expert knowledge Claude can't get elsewhere
2. **Autonomy**: Completes tasks independently
3. **Clarity**: Easy to understand and apply
4. **Structure**: Well-organized and maintainable

**Recognition over prescription**: Use these questions as guideposts, not rigid rules. Context matters.
