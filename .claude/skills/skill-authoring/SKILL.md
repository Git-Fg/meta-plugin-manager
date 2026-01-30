---
name: skill-authoring
description: "Create portable skills with SKILL.md. Use when building new skills or documenting patterns. Includes frontmatter syntax, directory conventions, quality standards. Not for commands or agents."
---

<mission_control>
<objective>Create portable skills with SKILL.md that follow gold standard patterns: YAML frontmatter, progressive disclosure, and self-contained philosophy</objective>
<success_criteria>Skill created with valid frontmatter, Quick Start section, navigation tables, and critical_constraint footer</success_criteria>
</mission_control>

## Quick Start

**If you need to create a new skill:** Create the directory structure first, then write SKILL.md with proper frontmatter.

**If you need to understand frontmatter:** MUST READ ## FRONTMATTER PATTERN first—ALL skill creation depends on this.

**If you need directory structure:** Read ## DIRECTORY PATTERN after frontmatter.

**If you need quality standards:** Read ## QUALITY PATTERN last—before claiming completion.

## Navigation

| If you need...                  | Read this section...              |
| :------------------------------ | :-------------------------------- |
| YAML frontmatter syntax         | ## FRONTMATTER PATTERN (MUST)     |
| Directory layout                | ## DIRECTORY PATTERN              |
| Progressive disclosure tiers    | ## TIER PATTERN                   |
| Navigation tables               | ## NAVIGATION PATTERN             |
| Anti-patterns to avoid          | ## ANTI-PATTERN: Common Mistakes  |
| Quality verification            | ## QUALITY PATTERN (MUST)         |

## FRONTMATTER PATTERN

Every skill MUST begin with YAML frontmatter. This serves as the auto-discovery trigger for the skill system.

### Required Structure

```yaml
---
name: skill-name
description: "Brief description. Use when [condition]. Keywords: [trigger words]."
---
```

### Description Elements

| Element     | Purpose                          | Required? |
| :---------- | :------------------------------- | :-------- |
| `name`      | Identifier for the skill         | Yes       |
| `description` | Discovery trigger                | Yes       |
| `Use when`  | Trigger conditions               | Yes       |
| `Keywords`  | User phrases that trigger skill  | Yes       |
| `Not for`   | Exclusions (optional)            | No        |

### Description Format

```
"Brief action. Use when [condition]. Keywords: [phrase1], [phrase2], [phrase3]."
```

### Example Breakdown

```yaml
description: "Create portable skills with SKILL.md and YAML frontmatter.
Use when building new skills or writing trigger phrases.
Keywords: create skill, write SKILL.md, new skill, make a skill, build skill."
```

### Description Rules

| Rule                         | Example                                            |
| :--------------------------- | :------------------------------------------------- |
| Brief description (1 sentence) | "Create portable skills..."                      |
| "Use when" introduces triggers | "Use when building new skills"                  |
| "Keywords:" lists user phrases | "Keywords: create skill, make a skill"          |
| No spoilers                  | Don't describe what's in the body                 |
| No skill name references     | Don't say "Use skill-X"                          |

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

## DIRECTORY PATTERN

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

## TIER PATTERN

Progressive disclosure manages cognitive load through layered information:

| Tier       | Content        | Tokens         | Purpose            |
| :--------- | :------------- | :------------- | :----------------- |
| **Tier 1** | YAML metadata  | ~100           | Discovery trigger  |
| **Tier 2** | Core workflows | ~1.5k-2k words | Primary invocation |
| **Tier 3** | Deep patterns  | Unlimited      | Lookup reference   |

**500 lines is a virtual limit—losing knowledge is worse than verbose SKILL.md.**

Tier 2 (SKILL.md) MUST contain all guardrails, patterns, and anti-patterns that are directly or indirectly relevant when the skill is activated. Agents skip references/—core knowledge must be visible in the main file.

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

## NAVIGATION PATTERN

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

## NAVIGATION PATTERN (continued)

Navigation tables enable agent discovery through recognition-based lookup.

### SKILL.md Navigation Table

```markdown
## Navigation

| If you need...         | Read this section...      |
| :--------------------- | :------------------------ |
| Frontmatter syntax     | ## FRONTMATTER PATTERN    |
| Directory structure    | ## DIRECTORY PATTERN      |
| Progressive disclosure | ## TIER PATTERN           |
```

### Reference File Navigation Table

```markdown
## Navigation

| If you need...         | Read this section...       |
| :--------------------- | :------------------------- |
| Complete syntax        | ## PATTERN: YAML Frontmatter |
| Description formatting | ## PATTERN: Description    |
| Common mistakes        | ## ANTI-PATTERN: Errors    |
```

### Navigation Table Rules

| Rule                       | Example                               |
| :------------------------- | :------------------------------------ |
| Place after Quick Start    | ## Navigation follows ## Quick Start  |
| Use "If you need..."       | "If you need frontmatter syntax"      |
| Use "Read this section..." | "Read ## FRONTMATTER PATTERN"         |
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
**For frontmatter syntax,** see ## PATTERN: YAML Frontmatter above.

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
| Frontmatter syntax | ## PATTERN: YAML Frontmatter |
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

## PATTERN: YAML Frontmatter

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

### Anti-Pattern: Time-Sensitive Information

Including information that becomes outdated over time:

```markdown
❌ Wrong:

If you're doing this before August 2026, use the old API.
After August 2026, use the new API.
```

**Fix:** Use an "Old Patterns" section with `<details>` for historical context:

```markdown
✅ Correct:

## Current Method

Use the v2 API endpoint: `api.example.com/v2/messages`

## Old Patterns

<details>
<summary>Legacy v1 API (deprecated 2026-08)</summary>

The v1 API used: `api.example.com/v1/messages`
This endpoint is no longer supported.

</details>
```

**Why:** Old patterns provide historical context without cluttering main content. Main content stays current; deprecated approaches are hidden but accessible.

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

If no exclusions exist, omit the "Not for" clause entirely:

```yaml
✅ Correct:
description: "Create skills. Use when building new skills. Keywords: create skill, make skill."
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

## QUALITY PATTERN

**references/ folder is RESERVED for:**
- Large API specifications (OpenAPI, MCP Protocol spec)
- Vast amounts of few-shot examples (20+ code snippets)
- Documentation intended for the user to read, not just the agent
- Precise workflow files (phases, steps) that MUST be read before specific tasks

**All core knowledge goes in SKILL.md:**
- 500 lines is a virtual limit, not a hard constraint
- Losing knowledge is worse than having a longer file
- Guardrails, patterns, and anti-patterns belong in the main file
- Agents skip references/—core knowledge must be in SKILL.md

Skills run in a code execution environment with platform-specific limitations:

| Platform | Network Access | Package Installation | Source Access |
| :------- | :------------- | :------------------- | :------------ |
| claude.ai | Yes | npm, PyPI, GitHub | Pull from repos |
| Anthropic API | No | None | Pre-bundled only |

### Document Required Packages

Always list dependencies explicitly:

```markdown
## Required Packages

Install before using this skill:

```bash
pip install pdfplumber
```

For scanned PDFs requiring OCR:

```bash
pip install pdf2image pytesseract
```

## Dependency Reference

| Package | Purpose | Install Command |
| :------ | :------- | :-------------- |
| pdfplumber | Text extraction from PDFs | `pip install pdfplumber` |
| pdf2image | PDF to image conversion | `pip install pdf2image` |
| pytesseract | OCR for scanned PDFs | `pip install pytesseract` |
```

### Verification Checklist

Before claiming dependency packaging complete:

- [ ] All required packages listed with install commands
- [ ] Package availability verified for target platforms
- [ ] Version constraints specified if needed
- [ ] Alternative packages mentioned for different use cases

---

## EXTERNAL REFERENCES PATTERN

For high-density information that exists elsewhere, use external references with clear context:

### When to Use External References

| Use When | Don't Use When |
| :------- | :------------- |
| Official API documentation with examples | Information needed for core functionality |
| Library documentation (upstream maintained) | Patterns specific to this skill |
| Comprehensive specifications (100+ pages) | Information that changes frequently |
| Tool-specific guides (vendor maintained) | Content that should be self-contained |

### External Reference Format

```markdown
## External Resources

For complete API documentation, see:
- [Library Name](https://docs.example.com/api): Official API reference with all methods
- [Tool Documentation](https://tool.example.com/docs): Usage guide and examples

## Quick Reference

| Method | Purpose | Link |
| :----- | :------- | :--- |
| `method_a()` | Create resources | [API Docs](https://docs.example.com/a) |
| `method_b()` | Update resources | [API Docs](https://docs.example.com/b) |

### Key Patterns (External)

**Authentication**: See [Official Docs - Auth](https://docs.example.com/auth)

```python
# From official documentation
client = Client(api_key="key")
```

**Error Handling**: See [Official Docs - Errors](https://docs.example.com/errors)

```python
# From official documentation
try:
    result = client.request()
except ApiError as e:
    handle_error(e)
```

### External Reference Rules

| Rule | Example |
| :--- | :------- |
| Always cite official source | [pandas Documentation](https://pandas.pydata.org/docs) |
| Provide context for link | "For complete API details, see..." |
| Include key patterns locally | Copy essential examples, link for more |
| Use stable URLs | Avoid version-specific URLs when possible |

### Anti-Pattern: Missing Context

```markdown
❌ Wrong:

See https://docs.example.com for more info.
```

**Fix:** Provide context and purpose:

```markdown
✅ Correct:

## External Resources

**Official Documentation**: [Library Name](https://docs.example.com)

This skill assumes familiarity with the core concepts documented above.
Focuses on skill-specific patterns and conventions.
```

---

## Recognition Questions

| Question                                         | Answer Should Be...                                  |
| :----------------------------------------------- | :--------------------------------------------------- |
| Does frontmatter use infinitive voice?           | Yes: "Create skills", not "You should create skills" |
| Does frontmatter use What-When-Keywords format?  | Brief description, Use when, Keywords present        |
| Is description non-spoiling?                     | Doesn't describe body content                       |
| Does skill open with ## Quick Start?             | Scenario-based opening section exists                |
| Do reference files have navigation tables?       | Navigation immediately after frontmatter             |
| Are section headers greppable?                   | PATTERN:, ANTI-PATTERN:, EDGE: used                  |
| Is core knowledge in SKILL.md?                   | All essential knowledge in main file                 |
| Are references reserved for vast content?        | Only for specs, many examples, or user docs          |

---

## Common Mistakes to Avoid

### Mistake 1: Duplicate "When to Use" Section

❌ **Wrong:**
```markdown
description: "Create skills. Use when building skills."

## When to Use This Skill
Use when building new skills.
```

✅ **Correct:**
```markdown
description: "Create skills. Use when building new skills."

## Quick Start
**If you need to create a new skill:** [action]
```

### Mistake 2: Spoiler Navigation Table

❌ **Wrong:**
```markdown
| Frontmatter | See references/frontmatter.md for YAML syntax with name, description, triggers, and examples |
```

✅ **Correct:**
```markdown
| Frontmatter syntax | ## PATTERN: YAML Frontmatter |
```

### Mistake 3: XML Overload

❌ **Wrong:**
```markdown
<quick_start>
## Scenario 1
Content
</quick_start>
```

✅ **Correct:**
```markdown
## Quick Start
**If you need X:** Do Y
```

### Mistake 4: Non-Greppable Headers

❌ **Wrong:**
```markdown
## How to Write Frontmatter
## Common Errors
## Tips and Tricks
```

✅ **Correct:**
```markdown
## PATTERN: YAML Frontmatter
## ANTI-PATTERN: Common Mistakes
## EDGE: Edge Cases
```

### Mistake 5: Skill Name in Description

❌ **Wrong:**
```yaml
description: "...Use skill-authoring for creating skills..."
```

✅ **Correct:**
```yaml
description: "...Use when creating portable skills..."
```

### Mistake 6: Nested Directory Structure

❌ **Wrong:**
```text
.claude/skills/skill-authoring/
├── core/
│   └── SKILL.md
└── advanced/
    └── patterns.md
```

✅ **Correct:**
```text
.claude/skills/skill-authoring/
├── SKILL.md
└── references/
    └── patterns.md
```

---

## Validation Checklist

Before claiming skill creation complete:

**Frontmatter:**
- [ ] YAML frontmatter at file top
- [ ] `name` field uses kebab-case, gerund form
- [ ] `description` uses What-When-Keywords format (brief, non-spoiling)
- [ ] Description uses infinitive voice (third person)
- [ ] Keywords list user phrases that trigger the skill

**Structure:**
- [ ] Skill opens with ## Quick Start section
- [ ] Navigation table follows Quick Start
- [ ] Navigation uses "If you need... Read..." format
- [ ] SKILL.md is the core file (not README.md or other names)

**References:**
- [ ] references/ folder (if exists) contains only .md files
- [ ] Reference files have navigation tables immediately after frontmatter
- [ ] Navigation tables are blind pointers (no spoilers)

**Content:**
- [ ] Greppable headers used (PATTERN:, ANTI-PATTERN:, EDGE:)
- [ ] Tier 2 (SKILL.md) is lean
- [ ] Tier 3 (references/) contains deep patterns
- [ ] XML tags used only for mission_control and critical_constraint
- [ ] No time-sensitive information (or in "Old Patterns" section)
- [ ] Dependencies listed with install commands
- [ ] External references include context and purpose

**Footer:**
- [ ] critical_constraint footer present at file end
- [ ] Portability invariant stated

---

## Best Practices Summary

✅ **DO:**
- Use YAML frontmatter with What-When-Keywords format (brief, non-spoiling)
- Start description with infinitive verb ("Create", "Build", "Apply")
- Include Keywords: user phrases that trigger auto-discovery
- Open skill with ## Quick Start scenario-based section
- Put ALL core knowledge in SKILL.md (500 lines is soft limit)
- Use greppable headers: PATTERN:, ANTI-PATTERN:, EDGE:
- Add critical_constraint footer for recency bias
- Use MUST-READ language for mandatory references

❌ **DON'T:**
- Spoil body content in description or navigation
- Put core knowledge in references/ (causes skip behavior—500 lines is virtual limit, losing knowledge is worse)
- Use generic headers like "How to" or "Tips"
- Reference other skills by name in descriptions
- Create nested folder structures (flat only)
- Skip navigation tables in reference files
- Forget critical_constraint at file end
- Include time-sensitive information (use "Old Patterns" instead)
- Assume packages are installed (document dependencies)
- Link to external docs without context or key patterns

---

## VALIDATION COMMAND

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
