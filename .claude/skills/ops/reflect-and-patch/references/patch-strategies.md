# Patch Strategies

Strategies for updating rules and SKILL.md files to prevent recurrence of identified mistakes.

## Strategy Overview

| Strategy                 | Severity | Use When                             | Token Cost |
| ------------------------ | -------- | ------------------------------------ | ---------- |
| Add recognition question | Low      | Claude keeps making the same mistake | Minimal    |
| Add critical constraint  | High     | Claude is skipping a critical step   | Medium     |
| Strengthen reference     | Medium   | Claude is skipping a reference       | Low        |
| Add example              | Medium   | Claude doesn't understand pattern    | High       |
| Add anti-pattern         | Medium   | Claude is recognizing wrong pattern  | Medium     |

---

## Strategy A: Add Recognition Question

**When to use:** Claude keeps making the same mistake despite existing rules.

**What it does:** Adds a recognition question that Claude must answer before proceeding.

**How to apply:**

1. Identify the relevant section in the target file
2. Add a `<recognition_trigger>` or `**Recognition:**` question
3. Make it specific to the mistake pattern

**Example:**

Before:

```markdown
## Directory Structure

Create directories following the Seed System structure.
```

After:

```markdown
## Directory Structure

**Recognition:** Am I using the correct directory name (check for plural/singular)?

Create directories following the Seed System structure.
```

**Placement:** Add recognition questions to the relevant section's header or before the critical action.

---

## Strategy B: Add Critical Constraint

**When to use:** Claude is skipping a critical step that must never be skipped.

**What it does:** Adds a `<critical_constraint>` block with strong language.

**How to apply:**

1. Identify the relevant section
2. Add `<critical_constraint>` at the bottom of the section
3. Use ALWAY/NEVER/MUST for non-negotiable rules

**Example:**

Before:

```markdown
## Verification

Run tests to verify the implementation.
```

After:

```markdown
## Verification

<trigger>When completing a feature implementation</trigger>

<critical_constraint>
MANDATORY: Run verification loop before claiming completion
MANDATORY: Never skip the verification phase
No exceptions. Verification prevents false completion claims.
</critical_constraint>
```

**Placement:** At the bottom of the relevant section (recency bias).

---

## Strategy C: Strengthen Reference Language

**When to use:** Claude is skipping a required reference file.

**What it does:** Upgrades soft language to mandatory language.

**How to apply:**

1. Find the reference mention
2. Upgrade the language strength

**Language upgrade ladder:**

| From                            | To                                       |
| ------------------------------- | ---------------------------------------- |
| "See X for details"             | "Read X for patterns"                    |
| "Consider reading X"            | "MUST READ: X"                           |
| "MUST READ: X"                  | "MANDATORY READ BEFORE ANYTHING ELSE: X" |
| "READ COMPLETELY. DO NOT SKIP." | "READ COMPLETELY. DO NOT SKIP. NO TAIL." |

**Example:**

Before:

```markdown
For examples, see references/executable-examples.md
```

After:

```markdown
MANDATORY READ: references/executable-examples.md
READ COMPLETELY. DO NOT SKIP. DO NOT SKIM. NO TAIL.

For examples, see the reference file above.
```

---

## Strategy D: Add Example

**When to use:** Claude doesn't understand the pattern or produces incorrect output.

**What it does:** Adds concrete examples showing correct behavior.

**How to apply:**

1. Identify the pattern Claude got wrong
2. Add a positive example showing correct behavior
3. Add a negative example if helpful

**Example:**

Before:

```markdown
## Frontmatter Format

Skills require frontmatter with name and description.
```

After:

```markdown
## Frontmatter Format

Skills require frontmatter with name and description.

**Example (correct):**

```yaml
---
name: my-skill
description: "Brief description of what this skill does"
---
```
```

**Example (incorrect):**

```yaml
# Missing frontmatter - skill won't load
```

---

## Strategy E: Add Anti-Pattern

**When to use:** Claude is recognizing the wrong pattern or using an anti-pattern.

**What it does:** Documents the anti-pattern with recognition triggers.

**How to apply:**

1. Identify the anti-pattern Claude used
2. Add `<anti_pattern>` block to the relevant section
3. Include recognition trigger and fix

**Example:**

Before:

```markdown
## Skill Structure

Create skills following the Rooter pattern for complete packages.
```

After:

```markdown
## Skill Structure

<anti_pattern name="command_wrapper">
<definition>Creating skills that serve only as wrappers for single CLI commands.</definition>
<recognition_trigger>
Question: "Could the description alone suffice?"
</recognition_trigger>
<fix>
Delete the skill. Improve the command description instead.
</fix>
</anti_pattern>

Create skills following the Rooter pattern for complete packages.
```

---

## Decision Matrix

| Situation                      | Recommended Strategy              |
| ------------------------------ | --------------------------------- |
| Claude keeps making same error | Strategy A (Recognition Question) |
| Claude skips critical step     | Strategy B (Critical Constraint)  |
| Claude skips reference         | Strategy C (Strengthen Language)  |
| Claude misunderstands pattern  | Strategy D (Add Example)          |
| Claude uses wrong pattern      | Strategy E (Add Anti-Pattern)     |

---

## Patch Application Workflow

1. **Classify failure** using `correction-patterns.md`
2. **Select strategy** using decision matrix
3. **Locate target section** in the file
4. **Apply patch** following strategy instructions
5. **Verify change** - ensure no syntax errors
6. **Test applicability** - would this have prevented the mistake?

---

## Verification Checklist

After applying a patch:

- [ ] XML/Markdown syntax is valid
- [ ] Change is placed correctly (recency bias for constraints)
- [ ] Language strength matches severity
- [ ] Example code is correct and copyable
- [ ] Anti-pattern includes recognition trigger
- [ ] Patch would have prevented the original mistake
