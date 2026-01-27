# Implementation Patterns

**Generic patterns applicable across all components. Component-specific patterns live in their respective meta-skills.**

These patterns help you create clear, self-contained components. Use them as guidance, not rigid rules.

---

## Core Patterns

### Pattern 1: Progressive Disclosure

**Keep the main content focused on what's needed most of the time.**

**Principle**: Not everything belongs in the main content. Core content for most users; details for specific cases.

**Recognition**: "Is this information required for the standard 80% use case?" Keep in main. "Is this for specific scenarios?" Move to references/.

**For implementation**: See component-specific meta-skills for detailed tier structures.

### Pattern 2: Self-Containment

**Components should work without depending on external files.**

**Principle**: Include everything needed directly. Don't reference external files or directories.

**Recognition**: "Would this component work in a project with zero rules dependencies?"

**For implementation**: See component-specific meta-skills for self-containment patterns.

### Pattern 3: Clear Examples

**Show, don't just tell.**

**Principle**: Users recognize patterns faster than they generate them from scratch. Include concrete examples.

**Recognition**: "Can users copy this example and use it immediately?"

### Pattern 4: Degrees of Freedom

**Match specificity to how fragile the task is.**

**Principle**: Multiple valid approaches → high freedom. Fragile operations → low freedom.

**Recognition**: "What breaks if Claude chooses differently?" The more that breaks, the lower the freedom.

**For implementation**: See component-specific meta-skills for freedom level guidance.

---

## Writing Style

### Imperative Form

**Use imperative form for instructions.**

**Principle**: "Execute the task" not "You should execute the task." Clear and efficient.

**Recognition**: Are you using "you/your"? Switch to imperative form.

**For implementation**: See component-specific meta-skills for writing style examples.

### Clear Examples

**Show, don't just tell.**

**Principle**: Include concrete examples that users can copy and use immediately.

**Recognition**: "Can users copy this example and use it immediately?"

**For implementation**: See component-specific meta-skills for example patterns.

---

## Content Organization

### Single Source of Truth

**Each concept should be documented once:**

- Component-specific patterns → component's meta-skill
- Generic patterns → `.claude/rules/patterns.md`
- CLAUDE.md → references both

**Question**: Is this concept already documented elsewhere? Cross-reference instead of duplicating.

### Reference Files

**Keep references clean:**

Tier 2 (SKILL.md) - Navigation:
```markdown
| If you are... | Read... |
|---------------|---------|
| Creating commands | `references/executable-examples.md` |
| Configuring frontmatter | `references/frontmatter-reference.md` |
```

Tier 3 (reference file):
```markdown
# Reference Title

[Content only - no meta-instructions about when to read]
```

**Question**: Does this reference explain why to read it? Remove meta-instructions.

---

## Recognition Questions

### Writing Style
- "Am I using 'you/your'?" → Switch to imperative form
- "Is this instructions or messages?" → Write FOR Claude, not TO user

### Content Organization
- "Is this concept documented elsewhere?" → Cross-reference instead
- "Is this component-specific?" → Move to relevant meta-skill
- "Is this generic?" → Keep in rules/

### Progressive Disclosure
- "Is SKILL.md approaching 450 lines?" → Move content to references/
- "Do I have working examples?" → Add examples/ directory
- "Is this telling readers when to read what they're already reading?" → Remove meta-instructions

---

## Summary

**Core principles:**

- **Teaching > Prescribing**: Patterns enable intelligent adaptation
- **Trust > Control**: Claude is smart. Provide principles, not recipes
- **Less > More**: Context is expensive. Every pattern must earn its place

**Good patterns:**
- Clear examples users can copy
- Self-contained components
- Progressive disclosure (80/20 rule)
- Single source of truth

**Bad patterns:**
- Forced structures
- Bureaucratic checklists
- External dependencies
- Duplicated content

For principles, see [`principles.md`](principles.md). For anti-patterns, see [`anti-patterns.md`](anti-patterns.md).
