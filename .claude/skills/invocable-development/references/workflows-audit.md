# Skill Audit Workflow

This workflow details the process of auditing skills for quality, portability, and best practices compliance.

---

## Phase 1: Preparation

Load reference documentation:

1. **invocable-development/SKILL.md** (overview)
2. **invocable-development/references/** (all references)
3. **Understand evaluation framework**

### Evaluation Framework

Audit assesses skills across multiple dimensions:

| Dimension                  | What It Checks                    | Why It Matters              |
| -------------------------- | --------------------------------- | --------------------------- |
| **YAML Frontmatter**       | Required fields, valid syntax     | Silent failures if invalid  |
| **XML Structure**          | Proper tag usage, closure         | UHP compliance              |
| **Progressive Disclosure** | Tier organization, content depth  | Cognitive load management   |
| **Content Quality**        | Conciseness, clarity, specificity | Usability and effectiveness |
| **Anti-Patterns**          | Recognition questions applied     | Quality assurance           |
| **Portability**            | Zero external dependencies        | Works in isolation          |
| **Autonomy**               | 80-95% completion rate            | Minimizes questions         |

---

## Phase 2: Evaluation

### Step 1: Frontmatter Compliance

Check frontmatter fields:

```yaml
---
name: skill-name
description: "Clear description with What-When-Not format"
---
```

**What to verify:**

- [ ] `name` present, valid format
- [ ] `description` present, follows What-When-Not
- [ ] No skill/command names in description
- [ ] Third-person voice
- [ ] Clear and actionable

**Common issues:**

- Missing or empty description
- References to other skills/commands
- First-person or second-person voice
- Vague or generic descriptions

### Step 2: UHP Structure

Verify UHP-compliant structure:

**Header (top of file):**

- [ ] `<mission_control>` with `<objective>` and `<success_criteria>`
- [ ] `<trigger>` defining when to use
- [ ] `<interaction_schema>` for reasoning tasks

**Footer (bottom of file):**

- [ ] `<critical_constraint>` with non-negotiable rules
- [ ] Placed at very end (recency bias)
- [ ] Uses MANDATORY/NEVER/ALWAYS appropriately

**Common issues:**

- Missing mission_control or success_criteria
- Critical constraints not at bottom
- Missing interaction_schema for reasoning tasks
- Weak language for non-negotiables

### Step 3: Progressive Disclosure

Check content organization:

**SKILL.md size:**

- [ ] Under 2000 words (if possible)
- [ ] Core content only
- [ ] Detailed content in references/

**Navigation:**

- [ ] References/ navigation table present
- [ ] Clear structure for accessing details

**Common issues:**

- SKILL.md too verbose (>2500 words)
- No references/ folder but content needs it
- Missing navigation to references

### Step 4: Content Quality

Evaluate content effectiveness:

**Voice and style:**

- [ ] Imperative form (no "you/your")
- [ ] Natural teaching language
- [ ] Clear instructions

**Examples:**

- [ ] Working examples (not pseudo-code)
- [ ] Can be copied and used directly
- [ ] Both positive and negative when helpful

**Specificity:**

- [ ] Concrete patterns and criteria
- [ ] Decision trees provided
- [ ] Clear "when to use" guidance

**Common issues:**

- "You should" language
- Pseudocode examples
- Vague instructions without concrete patterns

### Step 5: Anti-Patterns

Apply recognition questions from anti-patterns reference:

**Key anti-patterns to check:**

- Command wrapper (skill just invokes one command)
- Non-self-sufficient (requires constant hand-holding)
- Empty scaffolding (directories with no content)
- Zero/negative delta (Claude-obvious content)
- Skill name in description

**For each potential issue:**

- Ask recognition question
- Verify if issue exists
- Provide specific fix

### Step 6: Portability

Verify portability invariant:

**Zero dependencies:**

- [ ] No references to .claude/rules
- [ ] No references to external skills by name
- [ ] Self-contained patterns

**Works in isolation:**

- [ ] All necessary context included
- [ ] Philosophy bundled with skill
- [ ] No "see X for details" to external files

**Common issues:**

- References to .claude/rules/ files
- "See invocable-development for details"
- External dependencies not documented

### Step 7: Autonomy

Measure autonomy level:

**Autonomy targets:**

- **Excellent**: 0-1 questions (95-100%)
- **Good**: 2-3 questions (85-95%)
- **Acceptable**: 4-5 questions (80-85%)
- **Fail**: 6+ questions (<80%)

**What enables autonomy:**

- Clear instructions with decision criteria
- Concrete patterns and examples
- Comprehensive coverage of domain
- Recognition questions for edge cases

**Common issues:**

- Vague instructions requiring clarification
- Missing decision criteria
- Incomplete coverage

---

## Phase 3: Findings

Generate audit report with:

### Structure

```markdown
## Skill Audit: [skill-name]

### Critical Issues (Blocking)

Issues that prevent skill from working:

- [ ] Issue with file:line reference
- [ ] Fix recommendation

### High Priority Issues

Significant quality or portability concerns:

- [ ] Issue with file:line reference
- [ ] Fix recommendation

### Medium Priority Issues

Improvements for effectiveness:

- [ ] Issue with file:line reference
- [ ] Improvement suggestion

### Low Priority Issues

Minor optimizations or nice-to-haves:

- [ ] Issue with file:line reference
- [ ] Optimization suggestion
```

### Severity Guidelines

| Severity     | When to Use                     | Examples                                           |
| ------------ | ------------------------------- | -------------------------------------------------- |
| **Critical** | Skill broken or non-functional  | Missing frontmatter, invalid YAML                  |
| **High**     | Major quality/portability issue | External dependencies, missing critical_constraint |
| **Medium**   | Significant improvement needed  | Poor autonomy, weak description                    |
| **Low**      | Minor polish needed             | Style inconsistencies, verbose content             |

---

## Phase 4: Resolution

Present findings with:

1. **Clear summary** of issues by severity
2. **Specific locations** (file:line) for each issue
3. **Actionable recommendations** with examples
4. **Auto-fix options** when applicable

Ask user:

- Apply fixes automatically?
- Manual fix guidance?
- Proceed to implementation?

---

## Success Criteria

- All evaluation dimensions assessed
- Findings include specific file:line locations
- Recommendations are actionable
- User understands issues and next steps
