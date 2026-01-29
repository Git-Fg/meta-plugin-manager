---
name: skill-authoring
description: "Create portable skills with SKILL.md, YAML frontmatter, and progressive disclosure. Use when building new components, writing descriptions with trigger phrases, structuring references folders, or creating navigation tables. Includes template patterns, What-When-Not-Includes format, directory conventions, and greppable headers (PATTERN, ANTI-PATTERN, EDGE). Not for auditing existing skills or creating commands."
---

## Quick Start

**If you need to create a new skill:** Create the directory structure first, then write SKILL.md with proper frontmatter.

**If you need to add deep patterns:** Create a references/ folder and add markdown files with navigation tables.

**If you need to understand frontmatter:** Read ## REFERENCE: YAML Frontmatter for complete syntax.

**If you need progressive disclosure:** Structure content in tiers—Tier 2 (core) in SKILL.md, Tier 3 (deep) in references/.

## Navigation

| If you need...         | Read this section...             |
| :--------------------- | :------------------------------- |
| Frontmatter syntax     | ## REFERENCE: YAML Frontmatter   |
| Directory structure    | ## REFERENCE: Directory Layout   |
| Progressive disclosure | ## REFERENCE: Tier Structure     |
| Reference navigation   | ## REFERENCE: Reference Files    |
| Anti-patterns to avoid | ## ANTI-PATTERN: Common Mistakes |

## REFERENCE: YAML Frontmatter

Every skill MUST begin with YAML frontmatter. This serves as the auto-discovery trigger for the skill system.

### Required Structure

```yaml
---
name: skill-name
description: "Verb + object. Use when [condition]. Includes [features]. Not for [exclusions]."
---
```

### All Four Elements

| Element       | Purpose                     | Required? |
| :------------ | :-------------------------- | :-------- |
| `name`        | Identifier for the skill    | Yes       |
| `description` | Discovery trigger           | Yes       |
| `Use when`    | Triggers in description     | Yes       |
| `Includes`    | Key features in description | Yes       |
| `Not for`     | Exclusions in description   | Yes       |

### Description Field Format

The description field MUST use What-When-Includes-Not format with infinitive voice.

```
"Verb + object. Use when [triggers]. Includes [features]. Not for [exclusions]."
```

### Example Breakdown

```yaml
description: "Create portable skills with SKILL.md and references.
Use when building new skills, defining frontmatter with What-When-Not-Includes,
structuring directories with references/, or writing progressive disclosure content.
Includes template patterns, YAML frontmatter syntax, directory structure conventions,
and reference file navigation tables.
Not for auditing, critiquing, or commands."
```

### Description Rules

| Rule                           | Example                                           |
| :----------------------------- | :------------------------------------------------ |
| Start with infinitive verb     | "Create portable skills", not "You should create" |
| "Use when" introduces triggers | "Use when building new skills"                    |
| "Includes" lists key features  | "Includes template patterns..."                   |
| "Not for" states exclusions    | "Not for auditing..."                             |
| No skill name references       | Don't say "Use skill-X"                           |

### Third-Person Voice

Write descriptions in **third person**, specific with key terms:

| Good                          | Bad                                      |
| :---------------------------- | :--------------------------------------- |
| "Extract text from PDFs..."   | "Helps with documents" (vague)           |
| "Use when user mentions..."   | "I/You can..." (first/second person)     |

### Frontmatter Fields Reference

| Field | Type | Description |
| :---- | :--- | :--------- |
| `name` | String | Slash command name (lowercase, ≤64 chars; defaults to directory name) |
| `description` | String | When/what to use it for (auto-triggering; max 1024 chars) |
| `argument-hint` | String | Autocomplete hint, e.g., `[filename]` |
| `disable-model-invocation` | Bool | `true` prevents auto-invocation (manual |
| `user only)-invocable` | Bool | `false` hides from `/` menu (Claude only) |

> **Note:** `allowed-tools`, `model`, `context`, and `agent` are for advanced use cases. Add during **iteration** if issues arise.

### Name Field

The name field identifies the skill in the system. Use gerund form (verb + -ing) for descriptive action.

```yaml
✅ Correct:
name: skill-authoring
name: command-authoring
name: mcp-development

❌ Incorrect:
name: skill_authoring (snake_case)
name: SA (abbreviation)
name: skills/authoring (nested)
```

### Naming Conventions

| Rule                           | Example                          |
| :----------------------------- | :------------------------------- |
| Gerund form                    | `processing-pdfs`, `analyzing`   |
| kebab-case only                | `skill-authoring`                |
| Max 64 characters              | `my-very-long-skill-name-xyz`    |
| Letters and hyphens only       | No numbers, underscores, dots    |
| No reserved words              | No "anthropic", "claude"         |

### File Naming

| Element    | Pattern           | Example          |
| :--------- | :---------------- | :--------------- |
| Core file  | `SKILL.md`        | `SKILL.md`       |
| References | Descriptive `.md` | `frontmatter.md` |

---

## REFERENCE: Directory Layout

Skills use a flat directory structure with optional references/ folder.

### Standard Layout

```
.claude/skills/skill-name/
├── SKILL.md              # Required: Core content
└── references/           # Optional: Lookup tables
    ├── reference-1.md
    └── reference-2.md
```

### Minimal Skill (No References)

```
.claude/skills/simple/
└── SKILL.md
```

### 5-Level Skill Architecture

| Level | Pattern | Use Case | Example |
| :---- | :------ | :------- | :------- |
| **1** | Basic Router | Enforce standards | Git commit formatter |
| **2** | Static References | Templates, boilerplate | License header adder |
| **3** | Few-Shot Examples | Input/output guidance | JSON to Pydantic converter |
| **4** | Procedural Logic | Scripted validation | Database schema validator |
| **5** | Complex Orchestration | Scripts + templates + examples | ADK tool scaffold |

### Folder Naming

| Rule        | Example                    |
| :---------- | :------------------------- |
| kebab-case  | `skill-authoring`          |
| Descriptive | `skill-authoring` not `sa` |
| Flat only   | No nested folders          |

### File Naming

| Element    | Pattern           | Example          |
| :--------- | :---------------- | :--------------- |
| Core file  | `SKILL.md`        | `SKILL.md`       |
| References | Descriptive `.md` | `frontmatter.md` |

---

## REFERENCE: Tier Structure

Progressive disclosure manages cognitive load through layered information:

| Tier       | Content        | Tokens        | Purpose            |
| :--------- | :------------- | :------------ | :----------------- |
| **Tier 1** | YAML metadata  | ~100          | Discovery trigger  |
| **Tier 2** | Core workflows | 1.5k-2k words | Primary invocation |
| **Tier 3** | Deep patterns  | Unlimited     | Lookup reference   |

### Invocation Controls

| Frontmatter combo | User invoke | Model invoke | Context loading |
| :---------------- | :---------- | :------------ | :-------------- |
| Default | Yes | Yes | Desc. always |
| `disable-model-invocation: true` | Yes | No | On manual only |
| `user-invocable: false` | No | Yes | Desc. always |

### Tier 2 Structure

```markdown
## Quick Start

**If you need X:** Do Y → Result

## Navigation

| If you need... | Read... |

## PATTERN: Core Pattern

[Main content with examples]

## ANTI-PATTERN: Common Mistakes

[What to avoid]

## Recognition Questions

[Self-check questions]

## See Also

[Reference links]
```

### Tier 3 Structure (References)

Reference files contain ONLY lookup content:

```markdown
# Reference Title

## Navigation

| If you need... | Read... |
| :------------- | :------ |

## PATTERN: Core Pattern

[Content]

## EDGE: Edge Cases

[Special conditions]

## ANTI-PATTERN: Common Mistakes

[What to avoid]

---

## Constraints

<critical_constraint>
[Non-negotiable rules]
</critical_constraint>
```

---

## REFERENCE: Reference Files

Reference files MUST have navigation tables for agent discovery:

```markdown
# Reference Title

## Navigation

| If you need... | Read this section... |
| :------------- | :------------------- |
| Topic A        | ## PATTERN: Core A   |
| Topic B        | ## PATTERN: Core B   |
| Edge case      | ## EDGE: Edge Cases  |
| Common mistake | ## ANTI-PATTERN: X   |

## PATTERN: Core Pattern

[Main content]

## EDGE: Edge Cases

[Special handling]

## ANTI-PATTERN: Common Mistakes

[What to avoid]

---

## Constraints

<critical_constraint>
[Footer for recency]
</critical_constraint>
```

### Navigation Table Requirements

- Must be immediately after frontmatter
- Must use "If you need... Read..." format
- Must cover all major sections
- Must not contain spoilers (don't summarize content)

---

## REFERENCE: Navigation Patterns

Navigation tables enable agent discovery through recognition-based lookup.

### SKILL.md Navigation Table

```markdown
## Navigation

| If you need...         | Read this section...           |
| :--------------------- | :----------------------------- |
| Frontmatter syntax     | ## REFERENCE: YAML Frontmatter |
| Directory structure    | ## REFERENCE: Directory Layout |
| Progressive disclosure | ## REFERENCE: Tier Structure   |
```

### Reference File Navigation Table

```markdown
## Navigation

| If you need...         | Read this section...            |
| :--------------------- | :------------------------------ |
| Complete syntax        | ## REFERENCE: YAML Frontmatter  |
| Description formatting | ## REFERENCE: Description Field |
| Common mistakes        | ## ANTI-PATTERN: Errors         |
```

### Navigation Table Rules

| Rule                       | Example                               |
| :------------------------- | :------------------------------------ |
| Place after Quick Start    | ## Navigation follows ## Quick Start  |
| Use "If you need..."       | "If you need frontmatter syntax"      |
| Use "Read this section..." | "Read ## REFERENCE: YAML Frontmatter" |
| Cover all major sections   | Ensure every section is referenced    |

### Link to Reference Files

```markdown
## See Also

| Reference                   | Purpose               |
| :-------------------------- | :-------------------- |
| `references/frontmatter.md` | YAML syntax           |
| `references/structure.md`   | Directory conventions |
```

### Link Within References

Use section references within the same file:

```markdown
**For frontmatter syntax,** see ## REFERENCE: YAML Frontmatter above.

**For common mistakes,** skip to ## ANTI-PATTERN: Errors.
```

---

## ANTI-PATTERN: Common Mistakes

### Anti-Pattern: Duplicate Trigger Sections

Creating a "## When to Use" section that duplicates frontmatter:

```markdown
❌ Wrong:

## When to Use This Skill

Use when building new skills.

✅ Correct: (remove duplicate, frontmatter is sufficient)

## description: "Create skills. Use when building new skills."

## Quick Start

**If you need to create a new skill:** [action]
```

**Fix:** Frontmatter IS the trigger mechanism. Remove duplicate sections.

### Anti-Pattern: Spoiler Navigation

Summarizing reference content in navigation:

```markdown
❌ Wrong:
| If you need... | Read... |
| :------------- | :------ |
| Frontmatter | See references/frontmatter.md for the YAML syntax with name, description, triggers |

✅ Correct:
| If you need... | Read... |
| :------------- | :------ |
| Frontmatter syntax | ## REFERENCE: YAML Frontmatter |
```

**Fix:** Use blind pointers only. Point to sections, don't summarize them.

### Anti-Pattern: XML Overload

Using XML tags for content that should be Markdown:

```markdown
❌ Wrong:
<quick_start>

## Scenario 1

Content
</quick_start>

✅ Correct:

## Quick Start

**If you need X:** Do Y
```

**Fix:** Use Markdown sections. Only use XML for `<mission_control>` and `<critical_constraint>`.

### Anti-Pattern: Non-Greppable Headers

Using generic section headers:

```markdown
❌ Wrong:

## How to Write Frontmatter

## Common Errors

## Tips and Tricks

✅ Correct:

## REFERENCE: YAML Frontmatter

## ANTI-PATTERN: Common Mistakes

## EDGE: Edge Cases
```

**Fix:** Use greppable headers (## PATTERN:, ## ANTI-PATTERN:, ## EDGE:).

### Anti-Pattern: Skill Name in Description

Referencing other skills by name:

```markdown
❌ Wrong:
description: "...Use skill-authoring for creating skills and skill-refine for auditing..."

✅ Correct:
description: "...Use when creating portable skills or refining existing ones..."
```

**Fix:** Describe behavior, don't reference skills by name.

### Anti-Pattern: Nested Structure

```
❌ Wrong:
.claude/skills/skill-authoring/
├── core/
│   └── SKILL.md
└── advanced/
    └── patterns.md

✅ Correct:
.claude/skills/skill-authoring/
├── SKILL.md
└── references/
    └── patterns.md
```

### Anti-Pattern: Wrong File Names

```
❌ Wrong:
.claude/skills/skill-authoring/
├── skill.md (lowercase)
└── Frontmatter.md (wrong case)

✅ Correct:
.claude/skills/skill-authoring/
├── SKILL.md
└── references/
    └── frontmatter.md
```

### Anti-Pattern: Missing SKILL.md

```
❌ Wrong:
.claude/skills/skill-authoring/
├── README.md
└── content.md

✅ Correct:
.claude/skills/skill-authoring/
├── SKILL.md
└── references/
    └── ...
```

---

## EDGE: Special Cases

### Edge Case: Single-Reference Skills

Skills with only one reference file should still use the references/ folder:

```
.claude/skills/example/
├── SKILL.md
└── references/
    └── template.md
```

### Edge Case: No References Needed

Simple skills that fit entirely in SKILL.md don't need references/ folder:

```
.claude/skills/simple/
└── SKILL.md
```

### Edge Case: Long Descriptions

Descriptions can span multiple lines in YAML:

```yaml
description: |
  Create portable skills with SKILL.md and references.
  Use when building new skills or documenting patterns.
  Includes frontmatter syntax, directory conventions.
  Not for commands or agents.
```

### Edge Case: Special Characters

Avoid double quotes inside the description. Use single quotes or rephrase:

```yaml
❌ Wrong:
description: "Create skills. Use when "building" new skills."

✅ Correct:
description: "Create skills. Use when building new skills."
```

### Edge Case: Empty "Not for"

If truly no exclusions exist, use a general statement:

```yaml
description: "Create skills. Use when building new skills. Includes all features. Not for command-only workflows."
```

### Edge Case: Many Reference Files

Group related references by purpose:

```
.claude/skills/complex/
├── SKILL.md
└── references/
    ├── frontmatter.md
    ├── structure.md
    ├── navigation.md
    ├── examples.md
    └── anti-patterns.md
```

### Edge Case: Reference File Order

List references in logical reading order:

```
references/
├── 01-frontmatter.md  # First, understand frontmatter
├── 02-structure.md    # Then, structure
└── 03-navigation.md   # Finally, navigation
```

---

## Recognition Questions

| Question                                         | Answer Should Be...                                  |
| :----------------------------------------------- | :--------------------------------------------------- |
| Does frontmatter use infinitive voice?           | Yes: "Create skills", not "You should create skills" |
| Does frontmatter include What-When-Includes-Not? | All four elements present                            |
| Does skill open with ## Quick Start?             | Scenario-based opening section exists                |
| Do reference files have navigation tables?       | Navigation immediately after frontmatter             |
| Are section headers greppable?                   | PATTERN:, ANTI-PATTERN:, EDGE: used                  |
| Is Tier 2 lean with Tier 3 deep?                 | Core content in SKILL.md, details in references/     |
| Are navigation tables blind pointers?            | No spoilers, just point to references                |
| Is XML used minimally?                           | Only mission_control and critical_constraint         |

---

## REFERENCE: Validation Command

Use `skills-ref validate ./my-skill` from the reference library to check frontmatter and naming.

---

<critical_constraint>
**Portability Invariant:**

Every skill MUST work in a vacuum (zero external dependencies):

1. All content needed for execution MUST be in the skill's SKILL.md or references/
2. No references to global rules, CLAUDE.md, or other components
3. Self-contained genetic code for fork isolation

Frontmatter MUST be the first content in every skill file.

Description MUST trigger auto-discovery through "Use when" phrases.

Name MUST be unique and use kebab-case.

Every skill MUST have SKILL.md as the core file.

Folder name MUST use kebab-case.

References folder (if exists) MUST contain only .md files.

Reference files MUST have navigation table immediately after frontmatter.

Navigation tables MUST use "If you need... Read this section..." format.

Navigation MUST NOT contain spoilers (blind pointers only).
</critical_constraint>
