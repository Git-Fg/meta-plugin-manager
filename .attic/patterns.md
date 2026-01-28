# Implementation Patterns

**Generic patterns applicable across all components. Component-specific patterns live in their respective meta-skills.**

These patterns help you create clear, self-contained components. Use them as guidance, not rigid rules.

---

<mission_control>
<objective>Provide generic implementation patterns for all component types</objective>
<success_criteria>Patterns understood and applicable to skills, commands, agents</success_criteria>
</mission_control>

## Core Patterns

<rule_category name="core_patterns">

<pattern name="progressive_disclosure">
  <principle>Reveal complexity progressively. Core content for most users; details for specific cases.</principle>

  <recognition>
    Question: "Is this information required for the standard 80% use case?"
  </recognition>

  <instructions>
    - Keep in main content: Core content used 80% of the time
    - Move to references/: Specific case content used 20% of the time
  </instructions>

  <example type="positive">
    <description>Mandatory reference with clear navigation</description>
    <content>
      MANDATORY READ: references/advanced.md for edge cases
    </content>
  </example>

  <example type="negative">
    <description>Pasting entire reference in main content</description>
    <content>
      [Pastes 500 lines of reference content directly in main document]
    </content>
  </example>

  <implementation>
    See component-specific meta-skills for detailed tier structures.
  </implementation>
</pattern>

---

<pattern name="self_containment">
  <principle>Components should work without depending on external files.</principle>

  <recognition>
    Question: "Would this component work in a project with zero rules dependencies?"
  </recognition>

  <instructions>
    - Include everything needed directly
    - Don't reference external files or directories
    - Bundle philosophy with component
  </instructions>

  <example type="positive">
    <description>Self-contained skill with bundled philosophy</description>
    <content>
      Skill includes condensed principles in metadata section
    </content>
  </example>

  <example type="negative">
    <description>Component that depends on external rules</description>
    <content>
      "See .claude/rules/principles.md for guidance"
    </content>
  </example>

  <implementation>
    See component-specific meta-skills for self-containment patterns.
  </implementation>
</pattern>

---

<pattern name="clear_examples">
  <principle>Show, don't just tell. Users recognize patterns faster than they generate them from scratch.</principle>

  <recognition>
    Question: "Can users copy this example and use it immediately?"
  </recognition>

  <instructions>
    - Include concrete examples that users can copy
    - Show both positive and negative examples when helpful
    - Use real code, not pseudocode
  </instructions>

  <example type="positive">
    <description>Working example with context</description>
    <content>
      ## Example: Progressive Disclosure

      MANDATORY READ: references/advanced.md for edge cases
    </content>

  </example>

  <example type="negative">
    <description>Verbose explanation without example</description>
    <content>
      You should implement progressive disclosure by putting important information
      in the main content and moving details to references...
    </content>
  </example>
</pattern>

---

<pattern name="degrees_of_freedom">
  <principle>Match specificity to how fragile the task is. Multiple valid approaches → high freedom. Fragile operations → low freedom.</principle>

  <recognition>
    Question: "What breaks if Claude chooses differently?" The more that breaks, the lower the freedom.
  </recognition>

<freedom_matrix>
| Freedom | When to Use | Voice Strength | Example |
| -------- | ----------- | -------------- | ------- |
| High | Multiple valid approaches | Standard | "Consider using immutable data structures" |
| Medium | Some guidance needed | Standard | "Use this pattern, adapting as needed" |
| Low | Fragile/error-prone | Strong | "Execute steps 1-3 precisely" |
</freedom_matrix>

  <example type="positive">
    <description>High freedom for non-critical task</description>
    <content>
      Consider using immutable data structures for state management.
    </content>
  </example>

  <example type="negative">
    <description>Low freedom for critical workflow</description>
    <content>
      MANDATORY: RED → GREEN → REFACTOR (never skip phases)
    </content>
  </example>

  <implementation>
    See component-specific meta-skills for freedom level guidance.
  </implementation>
</pattern>

</rule_category>

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
- Generic patterns → this file

**Question**: Is this concept already documented elsewhere? Cross-reference instead of duplicating.

### Reference Files

**Keep references clean:**

Tier 2 (SKILL.md) - Navigation:

```markdown
| If you are...           | Read...                               |
| ----------------------- | ------------------------------------- |
| Creating commands       | `references/executable-examples.md`   |
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

---

<critical_constraint>
MANDATORY: Provide working examples users can copy
MANDATORY: Keep patterns generic and reusable
MANDATORY: Single source of truth per concept
No exceptions. Patterns must enable intelligent adaptation.
</critical_constraint>
