# Implementation Patterns

**Generic patterns applicable across all components. Component-specific patterns live in their respective meta-skills.**

These patterns help you create clear, self-contained components. Use them as guidance, not rigid rules.

---

## Core Patterns

### Pattern 1: Progressive Disclosure

**Keep the main content focused on what's needed most of the time.**

Think of SKILL.md like a kitchen counter (essentials for the current meal) and references/ like a pantry (bulk items and specialized tools).

**Structure**:
- **Tier 1: Metadata** (~100 tokens, always loaded)
  - Frontmatter: `name`, `description`, specific trigger phrases
  - Purpose: Trigger discovery, convey WHAT/WHEN/NOT

- **Tier 2: SKILL.md Body** (Happy Path - 80% use cases)
  - Standard execution flow, core workflows, essential examples
  - Purpose: Enable task completion without external references

- **Tier 3: References/** (Edge Cases - 20% use cases)
  - Troubleshooting, lookup tables, comprehensive guides
  - Purpose: On-demand details for specific scenarios

**Question**: Is this information required for the standard 80% use case? Keep in SKILL.md. If only for specific scenarios, move to references/.

### Pattern 2: Self-Containment

**Components should work without depending on external files.**

**Application**:
- Include examples directly
- Don't reference other components
- Bundle necessary context
- Include all resources (scripts, references, examples)

✅ Good: Complete examples with full context
❌ Bad: "See external documentation for examples"

**Question**: Would this component work if moved to a project with no rules? If not, include the necessary context directly.

### Pattern 3: Clear Examples

**Show, don't just tell.**

✅ Good: Include concrete examples that users can copy
❌ Bad: Abstract advice without examples

**Why**: Users recognize patterns faster than they generate them from scratch.

**Example**:
```yaml
# Good
description: "Use when user asks to 'create a hook'"

# Bad
description: "Use for hook creation tasks"
```

### Pattern 4: Degrees of Freedom

Match specificity to how fragile the task is.

Think of it like walking: a narrow bridge with cliffs needs specific steps (low freedom), while an open field allows many routes (high freedom).

| Freedom Level | When to Use | Approach | Risk |
|---------------|-------------|----------|------|
| **High** | Multiple valid approaches | Text-based principles | Trust judgment |
| **Medium** | Preferred pattern exists | Templates with parameters | Moderate |
| **Low** | Fragile operations | Specific scripts, exact steps | Zero |

**Question**: What breaks if Claude chooses differently? The more that breaks, the lower the freedom.

---

## Writing Style

### Imperative Form

**Use imperative form for instructions:**

✅ Good:
- Execute before any tool runs
- Parse the YAML frontmatter
- Configure the MCP server

❌ Bad:
- You should create a hook
- You need to validate settings
- You can use the grep tool

**Why**: Imperative form is clear and efficient.

**Question**: Are you using "you/your"? Switch to imperative form.

### Clear Examples

**Show concrete examples:**

✅ Good:
```yaml
description: "Use when user asks to 'create a hook'"

<example>
Context: User wants automation
user: "Create a validation hook"
assistant: "I'll create a hook that validates operations"
</example>
```

❌ Bad:
```yaml
description: "Use for hook creation tasks"
```

**Why**: Users need to see what good looks like.

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

## Common Patterns

### Cross-Reference Patterns

**Project Portability:**

Skills can reference other skills using project-relative paths.

For local projects: Use paths relative to project root or `${CLAUDE_PROJECT_DIR}`

For plugins/distribution: Use `${CLAUDE_PLUGIN_ROOT}` for portability

**Dual-mode pattern** (works in both contexts):
```bash
BASE_DIR="${CLAUDE_PLUGIN_ROOT:-${CLAUDE_PROJECT_DIR:-$(pwd)}}"
```

```markdown
See [plugin-dev skills](../../../official_example_skills/) for complete examples.
```

**Question**: Will this work in both local and plugin contexts?

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
