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
- [ ] SKILL.md under 500 lines (or split to references/)
- [ ] Progressive disclosure: Tier 1 (metadata) → Tier 2 (SKILL.md) → Tier 3 (references)
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

**Targets**:
- Tier 1: ~100 tokens (metadata)
- Tier 2: <500 lines (SKILL.md)
- Tier 3: Unlimited (references/)

**High Quality Indicators**:
- Tier 1: ~100 token description
- Tier 2: <500 lines core content
- Tier 3: references/ for deep details

**Low Quality Indicators**:
- Everything in one tier
- Missing references when needed
- Tier 2 too long (>500 lines)

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
- Code: *.js, *.ts → src/
- Tests: *.test.* → tests/
- Docs: *.md → docs/

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
# API Skill (200 lines)

Core patterns and examples.

See [advanced.md](references/advanced.md) for advanced scenarios.
See [troubleshooting.md](references/troubleshooting.md) for issues.
```

---

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
- "Is SKILL.md under 500 lines?"
- "Are details in references/ when needed?"
- "Is tier structure clear?"

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
