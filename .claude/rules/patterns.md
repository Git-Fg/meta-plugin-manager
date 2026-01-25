# Implementation Patterns: Architectural Guide

**Generic patterns applicable across all components. Component-specific patterns live in their respective meta-skills.**

These patterns ensure components have specific traits, not prescribe specific steps. The agent analyzes intent, applies patterns, and outputs self-sufficient components.

---

## From Instructional to Architectural

**Instructional patterns** (old):
```
"Do X, then Y, then Z"
Prescriptive steps
Process recipes
```

**Architectural patterns** (new):
```
"Analyze intent → Apply pattern → Output component with trait Y"
Trait enforcement
Quality guarantees
```

**Key shift**: From telling HOW to build to ensuring output HAS specific properties.

---

## Architectural Pattern System

### Pattern Application Formula

When building any component, apply this process:

1. **Analyze Intent** - What type of component and what traits needed?
2. **Select Pattern** - Which pattern ensures those traits?
3. **Apply Template** - Use pattern to generate output
4. **Verify Traits** - Does output have required traits?

**Example**:
```
Intent: Build portable skill
Pattern: Portability Invariant (Layer B standard)
Template: Bundle philosophy + Success Criteria + Mandatory references
Verify: Works in zero-.claude/rules environment
```

---

## Core Architectural Patterns

### Pattern 1: Portability Enforcement

**Trait**: Component works in isolation without external dependencies

**Application**:
- Bundle condensed philosophy into component
- Include Success Criteria (no external validation)
- Mark critical references as mandatory with imperative language
- Never reference .claude/rules/ files

**Verification**: "Could this work if moved to a project with no rules?"

### Pattern 2: Happy Path Protocol

**Trait**: Essential logic stays in SKILL.md, edge cases move to references/

**The Refrigerator Metaphor**: Think of SKILL.md like a kitchen counter (essentials for the current meal) and references/ like the pantry (bulk items and specialized spices).

**Application**:
- **Happy Path (80%)**: If information is required for standard execution flow → Keep in SKILL.md
- **Edge Cases (20%)**: If information is only for troubleshooting, quirks, or large datasets → Move to references/

**Recognition Test**: "Is this knowledge required for the 'Happy Path'?" → Keep in SKILL.md. "Is this a lookup table for edge cases?" → Move to references/.

**Verification**: "Can the user execute the standard workflow without opening references/?"

### Pattern 3: Self-Containment

**Trait**: Component owns all its content

**Application**:
- Inline examples directly
- Never reference other components
- Bundle necessary philosophy
- Include all resources (scripts, references, examples)

**Verification**: "Does component reference external files?"

### Pattern 4: Teaching Formula Integration

**Trait**: Component teaches through metaphor, contrast, and recognition

**Application** (every component must include):
1. **1 Metaphor** - For understanding
2. **2 Contrast Examples** - Good vs Bad with rationale
3. **3 Recognition Questions** - Binary self-checks

**Template**:
```
Metaphor: "Think of X like a Y..."

✅ Good: [Concrete example]
❌ Bad: [Concrete example]
Why good: [Reason]

Recognition: "[Question]?" → [Action]
```

**Verification**: "Does component include Teaching Formula?"

---

## Teaching Formula Arsenal

**Adapted from refactor-elegant-teaching, integrated into patterns.**

### Arsenal Category 1: High-Trust Language

**Tool A: The Imperative Shift**
- **Logic**: Remove subject, convert to bare infinitive
- **Template**: `[Imperative Verb] [Object]. Remember that [Context].`
- **Example**: "Validate input. Remember that this prevents errors."

**Tool B: The Permission Shift**
- **Logic**: Convert commands to suggestions where autonomy matters
- **Template**: `Consider [Action]` or `Avoid [Action] when [Condition].`
- **Example**: "Log errors. Consider verbosity levels for production."

### Arsenal Category 2: Recognition-Based Structure

**Tool C: The Recognition Test**
- **Logic**: Turn advice into binary self-check question
- **Template**: `Recognition: "[Question]?" → [Action]`
- **Example**: "Recognition: 'Can user copy/paste example?' → If no, add concrete details."

**Tool D: The Pattern Match**
- **Logic**: Identify pattern user should spot
- **Template**: `Look for: [Pattern].`
- **Example**: "Look for: SKILL.md requiring references/ for standard workflow."

### Arsenal Category 3: Metaphors & Contrast

**Tool E: The Analogy Map**
- **Logic**: Map intangible constraints to physical objects
- **Templates**:
  - Resource: "Think of [Concept] like a [Container]: [Explanation]."
  - Navigation: "Think of [Concept] like a [Path]: [Explanation]."
- **Example**: "Think of context like a shared refrigerator: everything you put in takes space others could use."

**Tool F: The Contrast Pair**
- **Logic**: Explicitly show wrong way vs right way
- **Template**:
  ```
  ✅ Good: [Concrete Example]
  ❌ Bad: [Concrete Example]
  Why good: [Reason]
  ```
- **Example**:
  ```
  ✅ Good: description: "Use when user asks to 'create a hook'"
  ❌ Bad: description: "Use when you want to create hooks"
  Why good: Specific trigger phrases enable pattern matching.
  ```

### Arsenal Category 4: Scannable Formatting

**Tool G: The 5-Second Break**
- **Logic**: Split text at first period or conjunction, use bullets
- **Template**:
  ```
  **[Header]:**
  - [Point 1]
  - [Point 2]
  ```
- **Example**:
  ```
  **Key constraints:**
  - Size
  - Speed
  - Cost
  ```

---

## Degrees of Freedom Matrix

Match specificity to task fragility. Think of Claude as exploring a path: a narrow bridge with cliffs needs specific guardrails (low freedom), while an open field allows many routes (high freedom).

| Freedom Level | When to Use | Approach | Risk Tolerance |
|---------------|-------------|----------|----------------|
| **High** | Multiple valid approaches, context-dependent decisions | Text-based principles, "consider X when Y" | Trust judgment |
| **Medium** | Preferred pattern exists, some variation acceptable | Pseudocode or scripts with parameters | Moderate risk |
| **Low** | Fragile/error-prone operations, consistency critical | Specific scripts, few parameters, exact steps | Zero risk tolerance |

### Freedom Assignment Framework

**Ask**: "What breaks if Claude chooses differently?"

- **Everything breaks** → Low freedom (exact steps)
- **Some things break** → Medium freedom (guided structure)
- **Nothing breaks** → High freedom (principles only)

### Freedom in Construction Standards

**Component generation** should use:
- **High freedom** for architecture (trust agent intelligence)
- **Medium freedom** for structure (provide templates)
- **Low freedom** for invariants (mandatory traits)

**Example**:
```
Architecture (High): "Analyze intent, apply Teaching Formula"
Structure (Medium): "Use Pattern X template with parameter Y"
Invariant (Low): "Must include Success Criteria" (non-negotiable)
```

---

## Writing Style Patterns

### Imperative/Infinitive Form (Enforced)

**Trait**: Content uses strict imperative/infinitive form with NO second person.

**Pattern**:
```
✅ Correct:
- Execute before any tool runs
- Parse the YAML frontmatter using sed
- Configure the MCP server with authentication

❌ Incorrect:
- You should create a hook
- You need to validate settings
- You can use the grep tool
```

**Recognition**: If writing "you/your", switch to imperative form.

**Why it matters**: Imperative form reduces token count while maintaining clarity.

---

## Happy Path Protocol

### Conditional Relevance Structure

**Trait**: Essential logic stays in SKILL.md, edge cases move to references/

**The Refrigerator Metaphor**: Think of SKILL.md like a kitchen counter (essentials for the current meal) and references/ like the pantry (bulk items and specialized spices).

**Application**:
- **Tier 1: Metadata** (~100 tokens, always loaded)
  - Frontmatter: `name`, `description`, specific trigger phrases
  - Purpose: Trigger discovery, convey WHAT/WHEN/NOT

- **Tier 2: SKILL.md Body** (Happy Path - 80% use cases)
  - Standard execution flow, core workflows, essential examples
  - Purpose: Enable task completion without external references

- **Tier 3: References/** (Edge Cases - 20% use cases)
  - Troubleshooting, lookup tables, comprehensive guides
  - Purpose: On-demand details for specific scenarios

**Recognition Test**: "Would the user need this information for the standard 80% use case?" → If yes, keep in SKILL.md. If no only for specific scenarios, move to references/.

---

## Reference File Structure

### Mandatory References Pattern

**Trait**: References contain critical validation rules

**Pattern** (Tier 2 - Component body):
```markdown
## Navigation

| If you are... | Read... |
|---------------|---------|
| Creating commands | `references/executable-examples.md` |
| Configuring frontmatter | `references/frontmatter-reference.md` |

Remember that references contain validation rules preventing common errors.
```

**Pattern** (Tier 3 - Reference file):
```markdown
# Reference Title

[Content only - no meta-instructions about when to read]
```

**Anti-pattern**: Reference files starting with "Load this when..." (Tier 3 already loaded, circular logic)

**Recognition**: "Does this reference explain why to read it?" Remove meta-instructions.

---

## Content Organization Patterns

### Single Source of Truth

**Trait**: Each concept documented once with cross-references

**Pattern**:
- Component-specific patterns → component's meta-skill
- Generic patterns → `.claude/rules/patterns.md`
- CLAUDE.md → references both

**Anti-pattern**: Same concept in multiple files without cross-reference

**Recognition**: "Is this concept already documented elsewhere?" Cross-reference instead.

### Intentional Redundancy

**Trait**: Philosophy duplicated where needed for portability

**Pattern**:
- Core philosophy → `.claude/rules/` (agent's soul)
- Condensed philosophy → components (component's brain)
- Success Criteria → components (self-validation)

**Why intentional**: Components must work in isolation

**Recognition**: "Would component lose critical knowledge if moved?" Bundle it.

---

## Recognition Questions Framework

### For Architectural Patterns

**Pattern Application**:
- "Does output have required trait?" → Verify with trait checklist
- "Is this prescriptive or architectural?" → Architectural ensures traits
- "Would this work in isolation?" → Test Portability Invariant

### For Teaching Formula

**Pattern Integration**:
- "Does component include 1 metaphor?" → Check Teaching Formula
- "Does component include 2 contrast examples?" → Verify with examples
- "Does component include 3 recognition questions?" → Count recognition tests

### For Happy Path Protocol

**Pattern Verification**:
- "Is this required for the standard workflow?" → Keep in SKILL.md
- "Is this an edge case or lookup?" → Move to references/
- "Would user need references/ for 80% of tasks?" → If yes, bring content back to SKILL.md

### For Self-Containment

**Pattern Validation**:
- "Does component reference external files?" → Inline content
- "Would this break without project rules?" → Bundle philosophy
- "Is Success Criteria present?" → Add self-validation

---

## Pattern Application Checklist

When generating any component, verify:

### Portability
- [ ] Condensed philosophy bundled
- [ ] Success Criteria included
- [ ] Critical references marked as mandatory
- [ ] No external .claude/rules/ references

### Teaching Formula
- [ ] 1 Metaphor included
- [ ] 2 Contrast examples present
- [ ] 3 Recognition questions defined
- [ ] Examples are concrete and copyable

### Happy Path Protocol
- [ ] Tier 1: Metadata concise (~100 tokens)
- [ ] Tier 2: SKILL.md contains Happy Path (80% use cases)
- [ ] Tier 3: references/ contains edge cases (20% use cases)
- [ ] Standard workflow executes without opening references/

### Self-Containment
- [ ] All content inlined
- [ ] No external file references
- [ ] Examples complete and working
- [ ] Scripts executable and documented

**Recognition**: "Could this component survive being moved to a fresh project?" If no, fix it.

---

**Core Philosophy**:

**Teaching > Prescribing**: Patterns enable intelligent adaptation. Process prescriptions create brittle systems.

**Trust > Control**: Claude is smart. Provide principles, not recipes.

**Less > More**: Context is expensive. Every pattern must earn its place.

For behavioral rules, see [`principles.md`](principles.md). For anti-patterns, see [`anti-patterns.md`](anti-patterns.md).
