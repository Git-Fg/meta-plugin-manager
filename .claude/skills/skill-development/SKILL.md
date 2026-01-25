---
name: skill-development
description: This skill should be used when the user wants to "create a skill", "add a skill to plugin", "write a new skill", "improve skill description", "organize skill content", or needs guidance on skill structure, progressive disclosure, or skill development best practices for Claude Code plugins.
---

# Skill Development: Architectural Refiner

**Role**: Transform intent into portable, self-sufficient skills
**Mode**: Architectural pattern application (ensure output has specific traits)

---

## Architectural Pattern Application

When building a skill, apply this process:

1. **Analyze Intent** - What type of skill and what traits needed?
2. **Apply Teaching Formula** - Bundle condensed philosophy into output
3. **Enforce Portability Invariant** - Ensure works in isolation
4. **Verify Traits** - Check portability, self-containment, progressive disclosure

---

## Core Understanding: What Skills Are

**Metaphor**: Skills are "genetic code packages"—they carry their own DNA and can survive being moved to any environment.

**Definition**: Skills are modular, self-contained packages that extend Claude's capabilities by providing specialized knowledge, workflows, and tools. They transform Claude from a general-purpose agent into a specialized agent equipped with procedural knowledge that no model can fully possess.

**Key insight**: Skills bundle their own philosophy. They don't depend on external documentation to function.

✅ Good: Skill includes condensed Delta Standard with examples
❌ Bad: Skill references .claude/rules/ for philosophy
Why good: Skills must work in isolation

Recognition: "Would this skill work if copied to a project with no rules?" If no, bundle the philosophy.

---

## Skill Traits: What Portable Skills Must Have

### Trait 1: Portability (MANDATORY)

**Requirement**: Skill works in isolation without external dependencies

**Enforcement**:
- Bundle condensed Seed System philosophy (Delta Standard, Progressive Disclosure, Teaching Formula)
- Include Success Criteria for self-validation
- Use "You MUST" language for mandatory references
- Never reference .claude/rules/ files

**Example**:
```
## Core Philosophy

Think of context like a shared refrigerator: everything you put in takes space others could use.

✅ Good: Keep SKILL.md lean (1,500-2,000 words)
❌ Bad: Put everything in SKILL.md (8,000+ words)
Why good: Progressive disclosure manages cognitive load

Recognition: "Is this information critical for skill function?" If yes, include it. If detailed, move to references/.
```

### Trait 2: Teaching Formula Integration

**Requirement**: Every skill must teach through metaphor, contrast, and recognition

**Enforcement**: Include all three elements:
1. **1 Metaphor** - For understanding (e.g., "Think of X like a Y")
2. **2 Contrast Examples** - Good vs Bad with rationale
3. **3 Recognition Questions** - Binary self-checks

**Template**:
```
Metaphor: [Understanding aid]

✅ Good: [Concrete example]
❌ Bad: [Concrete example]
Why good: [Reason]

Recognition: "[Question]?" → [Action]
Recognition: "[Question]?" → [Action]
Recognition: "[Question]?" → [Action]
```

### Trait 3: Self-Containment

**Requirement**: Skill owns all its content

**Enforcement**:
- Inline all examples directly in SKILL.md
- Never reference other skills or external files
- Include all resources (scripts, references, examples)
- Bundle necessary philosophy

✅ Good: Examples embedded directly in SKILL.md
❌ Bad: "See examples/ directory for samples"
Why good: Self-contained skills work without external references

Recognition: "Does skill reference files outside itself?" If yes, inline the content.

### Trait 4: Progressive Disclosure Structure

**Requirement**: Three-tier loading for cognitive load management

**Enforcement**:
- **Tier 1**: Metadata (~100 tokens, always loaded)
- **Tier 2**: SKILL.md body (~400-450 lines, loaded on activation)
- **Tier 3**: References/ (on-demand, loaded when needed)

**Recognition**: "Is detailed content moved to Tier 3?" If Tier 2 approaches 450 lines, split to references/.

### Trait 5: Success Criteria Invariant

**Requirement**: Skill includes self-validation logic

**Template**:
```
## Success Criteria

This skill is complete when:
- [ ] SKILL.md has valid YAML frontmatter with name and description
- [ ] Description uses third-person with specific trigger phrases
- [ ] Body uses imperative/infinitive form, no second person
- [ ] Progressive disclosure: Tier 2 ~400-450 lines, Tier 3 on-demand
- [ ] Teaching Formula: 1 Metaphor + 2 Contrasts + 3 Recognition Questions
- [ ] Portability: Works in isolation, bundled philosophy, no external refs
- [ ] Self-containment: All content inlined, examples complete

Self-validation: Verify each criterion without external dependencies. If all checked, skill meets Seed System standards.
```

**Recognition**: "Could a user validate this skill using only its content?" If no, add Success Criteria.

---

## Anatomical Requirements

### Required: SKILL.md File

**Structure**:
```markdown
---
name: skill-name
description: This skill should be used when [specific triggers]. [What it provides].
---

# Skill Name

[Content with Teaching Formula integrated]
```

**Quality requirements**:
- **Frontmatter**: Valid YAML with `name` and `description`
- **Description**: Third-person format with specific trigger phrases
- **Body**: Imperative form, Teaching Formula integrated

### Optional: Bundled Resources

**Scripts** (`scripts/`):
- Executable code for deterministic reliability
- Validation utilities
- Automation scripts

**References** (`references/`):
- Documentation for on-demand loading
- Detailed patterns and techniques
- API references and schemas

**Assets** (`assets/`):
- Templates, icons, fonts
- Boilerplate code
- Files used in output

**Examples** (`examples/`):
- Complete, runnable code
- Working implementations
- Copy-paste ready samples

**Recognition**: "Does skill have complete, working examples?" If not, add examples/ directory.

---

## Pattern Application Framework

### Step 1: Analyze Intent

**Question**: What type of skill and what traits needed?

**Analysis**:
- Simple knowledge skill? → Focus on progressive disclosure
- Complex workflow skill? → Include scripts and utilities
- Domain-specific skill? → Bundle domain philosophy
- Reusable utility skill? → Add validation scripts

**Example**:
```
Intent: Build skill for rotating PDFs
Analysis:
- Simple deterministic task → Need scripts/rotate_pdf.py
- Repeated operation → Bundle philosophy on automation
- Technical domain → Include API reference in references/
Output traits: Portability + Teaching Formula + Success Criteria
```

### Step 2: Apply Teaching Formula

**Requirement**: Bundle condensed Seed System philosophy

**Elements to include**:
1. **Metaphor**: "Skills are genetic code packages..."
2. **Delta Standard**: Good Component = Expert Knowledge - What Claude Knows
3. **Progressive Disclosure**: Three-tier loading explained
4. **2 Contrast Examples**: Good vs Bad skill descriptions
5. **3 Recognition Questions**: Binary self-checks for quality

**Template integration**:
```markdown
## Core Philosophy

Metaphor: "Think of skills like [metaphor]..."

✅ Good: description: "This skill should be used when user asks to 'create X'"
❌ Bad: description: "Use this skill when you want to create X"
Why good: Specific trigger phrases enable pattern matching

Recognition: "Does description include specific user queries?" → If no, add concrete phrases
Recognition: "Is SKILL.md approaching 450 lines?" → If yes, move content to references/
Recognition: "Could this work in a project with no rules?" → If no, bundle philosophy
```

### Step 3: Enforce Portability Invariant

**Requirement**: Ensure skill works in isolation

**Checklist**:
- [ ] Condensed philosophy bundled (Delta Standard, Progressive Disclosure, Teaching Formula)
- [ ] Success Criteria included
- [ ] References mandatory with "You MUST" language
- [ ] No external .claude/rules/ references
- [ ] Examples complete and self-contained

**Verification**: "Could this skill survive being moved to a fresh project with no .claude/rules?" If no, fix portability issues.

### Step 4: Verify Traits

**Requirement**: Check all mandatory traits present

**Verification**:
- Portability Invariant ✓
- Teaching Formula (1 Metaphor + 2 Contrasts + 3 Recognition) ✓
- Self-Containment ✓
- Progressive Disclosure (Tier 1/2/3) ✓
- Success Criteria Invariant ✓

**Recognition**: "Does skill meet all five traits?" If any missing, add them.

---

## Architecture Patterns

### Pattern 1: Progressive Disclosure Management

**Trait**: Cognitive load managed through tiered loading

**Application**:
- Keep Tier 2 (SKILL.md) ~400-450 lines
- Move detailed content to Tier 3 (references/)
- Use navigation tables to point to references

**Example navigation**:
```markdown
## Navigation

| If you are... | You MUST read... |
|---------------|-----------------|
| Understanding anatomy | references/anatomy.md |
| Learning patterns | references/patterns.md |
| Advanced techniques | references/advanced.md |

**Critical**: References contain validation rules and detailed techniques. Skipping references leads to incomplete understanding.
```

### Pattern 2: Mandatory References

**Trait**: References contain critical validation rules

**Application**: Use "You MUST" language for mandatory references

**Example**:
```
You MUST read references/frontmatter-reference.md before configuring any command frontmatter.

Invalid frontmatter causes silent failures. The reference contains:
- Required fields and validation rules
- Common error patterns and fixes
- Testing strategies for frontmatter
```

### Pattern 3: Self-Validation

**Trait**: Success Criteria enable self-validation

**Application**: Include Success Criteria section at end of skill

**Example**:
```markdown
## Success Criteria

This skill is complete when:
- [ ] All traits verified (see above)
- [ ] Examples are complete and working
- [ ] References are properly referenced
- [ ] Scripts are executable

Self-validation: Check each criterion using only skill content. No external dependencies required.
```

---

## Common Transformations

### Transform Tutorial → Architectural

**Before** (tutorial):
```
Step 1: Understand examples
Step 2: Plan contents
Step 3: Create structure
...
```

**After** (architectural):
```
Analyze Intent → Apply Teaching Formula → Enforce Portability → Verify Traits
```

**Why**: Architectural patterns ensure output has required traits, not just follows steps.

### Transform Reference → Bundle

**Before** (referenced):
```
"See .claude/rules/principles.md for philosophy"
```

**After** (bundled):
```
## Core Philosophy

Bundle condensed principles directly in skill:

Think of context like a shared refrigerator...

✅ Good: [example]
❌ Bad: [example]
Why good: [reason]
```

**Why**: Skills must work in isolation.

---

## Quality Validation

### Portability Test

**Question**: "Could this skill work if moved to a project with zero .claude/rules?"

**If NO**:
- Bundle condensed philosophy
- Add Success Criteria
- Remove external references
- Inline examples

### Teaching Formula Test

**Checklist**:
- [ ] 1 Metaphor present
- [ ] 2 Contrast Examples (good/bad) with rationale
- [ ] 3 Recognition Questions (binary self-checks)

**If any missing**: Add them using Teaching Formula Arsenal

### Self-Containment Test

**Question**: "Does skill reference files outside itself?"

**If YES**:
- Inline the content
- Bundle necessary philosophy
- Remove external dependencies

### Progressive Disclosure Test

**Question**: "Is Tier 2 approaching 450 lines?"

**If YES**: Move detailed content to Tier 3 (references/)

---

## Success Criteria

This skill-development guidance is complete when:

- [ ] Architectural pattern clearly defined (Analyze → Apply → Enforce → Verify)
- [ ] Teaching Formula integrated (1 Metaphor + 2 Contrasts + 3 Recognition)
- [ ] Portability Invariant explained with enforcement checklist
- [ ] All five traits defined (Portability, Teaching Formula, Self-Containment, Progressive Disclosure, Success Criteria)
- [ ] Pattern application framework provided
- [ ] Quality validation tests included
- [ ] Examples demonstrate architectural approach
- [ ] Success Criteria present for self-validation

Self-validation: Verify skill-development meets Seed System standards using only this content. No external dependencies required.

---

## Reference: The Five Mandatory Traits

Every skill must have:

1. **Portability** - Works in isolation
2. **Teaching Formula** - 1 Metaphor + 2 Contrasts + 3 Recognition
3. **Self-Containment** - Owns all content
4. **Progressive Disclosure** - Three-tier structure
5. **Success Criteria** - Self-validation logic

**Recognition**: "Does this skill have all five traits?" If any missing, add them.

---

**Remember**: Skills are genetic code packages. They carry their own DNA and can survive being moved to any environment. Bundle the philosophy. Enforce the invariants. Verify the traits.
