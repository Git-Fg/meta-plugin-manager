---
name: skill-authoring
description: "Create portable skills with SKILL.md. Use when building new skills or documenting patterns. Includes frontmatter syntax, directory conventions, quality standards. Not for commands or agents."
---

<mission_control>
<objective>Create portable skills that follow gold standard patterns: YAML frontmatter, progressive disclosure, and self-contained philosophy</objective>
<success_criteria>Skill created with valid frontmatter, Quick Start, navigation table, and critical_constraint footer</success_criteria>
</mission_control>

## Quick Start

**If you need to create a new skill:** Create directory, write SKILL.md with proper frontmatter.

**If you need frontmatter syntax:** Read ## PATTERN: Frontmatter (MUST).

**If you need directory structure:** Read ## PATTERN: Directory after frontmatter.

**If you need quality standards:** Read ## PATTERN: Quality last—before claiming completion.

## Navigation

| If you need... | Read this section... |
| :------------- | :------------------- |
| YAML frontmatter syntax | ## PATTERN: Frontmatter (MUST) |
| Directory layout | ## PATTERN: Directory |
| Progressive disclosure | ## PATTERN: Tiers |
| Navigation tables | ## PATTERN: Navigation |
| Anti-patterns to avoid | ## ANTI-PATTERN: Common Mistakes |
| Quality verification | ## PATTERN: Quality (MUST) |
| Description examples | ## PATTERN: Description Examples |

## PATTERN: Frontmatter

Every skill MUST begin with YAML frontmatter.

### Required Structure

```yaml
---
name: skill-name
description: "Brief description. Use when [condition]. Keywords: [auto-discovery phrases]."
---
```

### Description Elements

| Element | Purpose | Required? |
| :------ | :------- | :-------- |
| `name` | Identifier for the skill | Yes |
| `description` | Auto-discovery mechanism | Yes |
| `Use when` | Activation conditions | Yes |
| `Keywords` | User phrases for auto-discovery | Yes |
| `Not for` | Exclusions (optional) | No |

### Description Rules

| Rule | Example |
| :--- | :------- |
| Brief description (1 sentence) | "Create portable skills..." |
| "Use when" introduces conditions | "Use when building new skills" |
| "Keywords:" lists user phrases | "Keywords: create skill, make skill" |
| No spoilers | Don't describe body content |
| No skill name references | Don't say "Use skill-X" |

### Third-Person Voice

Write in **third person** with specific key terms:

| Good | Bad |
| :--- | :--- |
| "Extract text from PDFs..." | "Helps with documents" (vague) |
| "Use when user mentions..." | "I/You can..." (first/second person) |

## PATTERN: Description Examples

Descriptions vary by complexity. Here are examples at different levels:

### Basic (Simple Action)

```yaml
description: "Extract text from PDFs. Use when processing documents or need text extraction. Keywords: pdf, extract, document."
```

### Intermediate (Includes Scope)

```yaml
description: "Convert JSON to Pydantic models. Use when defining data schemas or validating JSON input. Includes type inference and field validation. Not for XML or YAML."
```

### Advanced (Gold Standard - Proactive)

```yaml
description: "Autonomously correct project rules when negative feedback occurs. Use PROACTIVELY when user says 'no', 'wrong', 'wait', 'not that', or 'actually'. Identifies the root cause in commands, agents, skills, or documentation and rewrites the offending instruction to prevent recurrence."
```

**Why this works:**
- **Proactive stance**: "Autonomously correct" sets autonomous behavior expectation
- **Specific triggers**: Lists exact phrases that activate the skill
- **Scope coverage**: "commands, agents, skills, or documentation" defines boundaries
- **Outcome**: "rewrites... to prevent recurrence" promises measurable improvement

### When to Use Each Level

| Level | Use When |
| :---- | :-------- |
| Basic | Single, well-understood action |
| Intermediate | Action has clear scope or exclusions |
| Gold Standard | Complex behavior requiring proactive triggers |

## PATTERN: Directory

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

### Folder Naming

| Rule | Example |
| :--- | :------- |
| kebab-case | `skill-authoring` |
| Descriptive | `skill-authoring` not `sa` |
| Flat only | No nested folders |

### File Naming

| Element | Pattern | Example |
| :------ | :------- | :------- |
| Core file | `SKILL.md` | `SKILL.md` |
| References | Descriptive `.md` | `frontmatter.md` |

### 5-Level Architecture

| Level | Pattern | Use Case |
| :---- | :------ | :------- |
| 1 | Basic Router | Enforce standards |
| 2 | Static References | Templates, boilerplate |
| 3 | Few-Shot Examples | Input/output guidance |
| 4 | Procedural Logic | Scripted validation |
| 5 | Complex Orchestration | Scripts + templates + examples |

### Invocation Controls

| Frontmatter combo | User invoke | Model invoke |
| :---------------- | :---------- | :------------ |
| Default | Yes | Yes |
| `disable-model-invocation: true` | Yes | No |
| `user-invocable: false` | No | Yes |

## PATTERN: Tiers

Progressive disclosure manages cognitive load:

| Tier | Content | Tokens | Purpose |
| :--- | :------- | :------- | :------- |
| **1** | YAML metadata | ~100 | Auto-discovery |
| **2** | Core workflows | ~1.5k-2k words | Primary invocation |
| **3** | Deep patterns | Unlimited | Lookup reference |

**500 lines is a virtual limit—losing knowledge is worse than verbose SKILL.md.**

Tier 2 (SKILL.md) MUST contain all guardrails, patterns, and anti-patterns. Agents skip references/—core knowledge must be visible in the main file.

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
```

### Tier 3 Structure (References)

```markdown
# Reference Title

## Navigation

| If you need... | Read... |

## PATTERN: Core Pattern

[Content]

## EDGE: Edge Cases

[Special conditions]

## ANTI-PATTERN: Common Mistakes

[What to avoid]

---

<critical_constraint>
[Non-negotiable rules]
</critical_constraint>
```

## PATTERN: Navigation

Navigation tables enable recognition-based lookup:

```markdown
## Navigation

| If you need... | Read this section... |
| :------------- | :------------------- |
| Topic A | ## PATTERN: Core A |
| Topic B | ## PATTERN: Core B |
| Edge case | ## EDGE: Edge Cases |
| Common mistake | ## ANTI-PATTERN: X |
```

### Navigation Requirements

- Must be immediately after Quick Start
- Must use "If you need... Read this section..." format
- Must cover all major sections
- Must NOT contain spoilers (blind pointers only)

## ANTI-PATTERN: Common Mistakes

✅ **DO:**
- Use greppable headers: PATTERN:, ANTI-PATTERN:, EDGE:
- Keep navigation blind (point to sections, don't summarize)
- Place constraints at file bottom (recency bias)
- Put core knowledge in SKILL.md (not references/)
- Use multi-line YAML for long descriptions

❌ **DON'T:**
- Duplicate frontmatter in body ("When to Use This Skill")
- Create nested folder structures (core/, advanced/)
- Use wrong file names (skill.md lowercase, README.md)
- Spoil content in navigation tables
- Use XML except for mission_control and critical_constraint
- Reference other skills by name in descriptions
- Include time-sensitive info (use "Old Patterns" with `<details>`)

### EDGE Cases

| Case | Solution |
| :--- | :------- |
| Single reference file | Still use references/ folder |
| No references needed | SKILL.md only is fine |
| Long description | Use multi-line YAML (`description: |`) |
| Many reference files | Order logically (01-frontmatter.md, 02-structure.md) |
| Empty "Not for" | Omit entirely |

### Section Selection Guide

Use greppable headers to structure content. Choose based on purpose:

| Header | Use When | Example |
| :----- | :------- | :------- |
| `## PATTERN:` | Core workflow, standard approach | `## PATTERN: Frontmatter` |
| `## ANTI-PATTERN:` | What to avoid, common mistakes | `## ANTI-PATTERN: Common Mistakes` |
| `## EDGE:` | Special cases, unusual conditions | `## EDGE: Special Characters` |
| `## Recognition Questions:` | Self-check before claiming done | `## Recognition Questions` |

### High Autonomy Default

**Default to freedom.** Constraints are technical invariants, not behavioral instructions.

| Constraint Type | Example | When to Use |
| :-------------- | :------- | :---------- |
| **Structural** | "SKILL.md MUST be first content" | Always - file won't work otherwise |
| **Format** | "Navigation tables MUST use 'If you need...'" | Interop requirements |
| **Behavioral** | "ALWAYS validate before save" | Avoid - over-constrains model |

**Iterate, Don't Pre-constrain:**

- Add constraints only after a real mistake occurs
- Use `<critical_constraint>` for non-negotiables (portability, structure)
- Trust the model to handle edge cases unless proven wrong
- Let anti-patterns emerge from experience, not prediction

### Examples

**Non-greppable headers:**
```markdown
❌ Wrong:
## How to Write Frontmatter
## Common Errors
## Tips and Tricks

✅ Correct:
## PATTERN: YAML Frontmatter
## ANTI-PATTERN: Common Mistakes
## EDGE: Edge Cases
```

**Spoiler navigation:**
```markdown
❌ Wrong:
| Frontmatter | See references/frontmatter.md for YAML syntax with name, description, triggers |

✅ Correct:
| Frontmatter syntax | ## PATTERN: Frontmatter |
```

**Skill name in description:**
```markdown
❌ Wrong:
description: "...Use skill-authoring for creating skills..."

✅ Correct:
description: "...Use when creating portable skills..."
```

**Wrong file names:**
```markdown
❌ Wrong:
.claude/skills/example/
├── skill.md (lowercase)
└── Frontmatter.md (wrong case)

✅ Correct:
.claude/skills/example/
├── SKILL.md
└── references/
    └── frontmatter.md
```

**Nested structure:**
```markdown
❌ Wrong:
.claude/skills/example/
├── core/
│   └── SKILL.md
└── advanced/
    └── patterns.md

✅ Correct:
.claude/skills/example/
├── SKILL.md
└── references/
    └── patterns.md
```

## PATTERN: Quality

**references/ folder is RESERVED for:**
- Large API specifications (OpenAPI, MCP Protocol spec)
- Vast amounts of few-shot examples (20+ code snippets)
- Documentation intended for the user to read, not just the agent

**All core knowledge goes in SKILL.md:**
- 500 lines is a virtual limit, not a hard constraint
- Losing knowledge is worse than having a longer file
- Guardrails and patterns belong in the main file

## Recognition Questions

| Question | Check |
| :------- | :---- |
| Frontmatter uses What-When-Keywords? | Brief, non-spoiling |
| Opens with ## Quick Start? | Scenario-based |
| Navigation table after Quick Start? | "If you need... Read..." |
| Section headers greppable? | PATTERN:, ANTI-PATTERN:, EDGE: |
| Core knowledge in SKILL.md? | Not hidden in references/ |
| critical_constraint footer present? | Non-negotiable rules at end |

---

<critical_constraint>
**Portability Invariant:**

Every skill MUST work in a vacuum (zero external dependencies):

1. All content needed for execution MUST be in the skill's SKILL.md or references/
2. No references to global rules, CLAUDE.md, or other components
3. Self-contained genetic code for fork isolation

**Gold Standards:**

- Frontmatter MUST be first content
- Description enables auto-discovery through "Use when" phrases
- Name MUST use kebab-case, gerund form
- Every skill MUST have SKILL.md as core file
- Folder name MUST use kebab-case
- References folder MUST contain only .md files
- Reference files MUST have navigation immediately after frontmatter
- Navigation tables MUST use "If you need... Read this section..."
- Navigation MUST NOT contain spoilers
</critical_constraint>
