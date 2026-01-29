# Architectural Refactor Plan: Technical Documentation → Success Framework

**Status:** COMPLETED
**Started:** 2026-01-29
**Completed:** 2026-01-29

## Decisions Locked

| Question    | Decision                                                                            |
| ----------- | ----------------------------------------------------------------------------------- |
| Skill split | 4 skills (flat): skill-authoring, skill-iterate, command-authoring, command-iterate |
| XML tags    | Keep 2: `<mission_control>` + `<critical_constraint>` (low-freedom only)            |
| Commands    | Keep /toolkit:build:\* routing, but use single AskUserQuestion flow → invoke skill  |

Refactor from XML-heavy technical documentation to an "Architectural Success Framework" inspired by the skill-creator pattern—high freedom, emoji anchors, example-driven, no unnecessary XML tags.

---

## Phase 1: Rules Refactor

### 1.1 XML Tag Simplification

**Current excessive XML usage:**

```
<mission_control>       ✓ Keep (low-freedom workflows only)
<critical_constraint>   ✓ Keep (non-negotiables)
<guiding_principles>    ✗ Remove → Convert to Markdown sections
<trigger>               ✗ Remove → Inline in prose
<philosophy_bundle>     ✗ Remove → Inline critical content only
<interaction_schema>    ✗ Remove → Use simple Markdown
<thinking>              ✗ Remove → Remove entirely
<execution_plan>        ✗ Remove → Use prose
<state_transition>      ✗ Remove → Remove entirely
<router>                ✗ Remove → Remove entirely
<rule_category>         ✗ Remove → Remove entirely
<injected_content>      ✓ Keep (command-only pattern)
<fetch_protocol>        ✗ Remove → Inline instructions
<anti_pattern>          ✗ Convert to ## ANTI-PATTERN: headers
<pattern>               ✗ Convert to ## PATTERN: headers
<edge>                  ✗ Convert to ## EDGE: headers
```

**New Rule Structure:**

```markdown
# Architecture: The Navigator's Map

## What This Provides

[Philosophy in prose - 2-3 sentences]

## Core Principles

### Principle 1: Name

**Why:** [rationale]

**How:** [guidance]

### Principle 2: Name

**Why:** [rationale]

**How:** [guidance]
```

### 1.2 Files to Refactor

| File                   | Changes                                                       |
| ---------------------- | ------------------------------------------------------------- |
| `architecture.md`      | Remove `<guiding_principles>`, `<router>`, inline `<trigger>` |
| `principles.md`        | Remove `<guiding_principles>`, `<philosophy_bundle>`          |
| `quality.md`           | Remove `<guiding_principles>`, inline content                 |
| `content-injection.md` | Keep minimal structure, convert excessive tags                |

### 1.3 New Rule Style Example

**Before (current):**

```xml
<guiding_principles>
## The Path to High-Autonomy Success

### 1. The Unified Neural Core

[content]
</guiding_principles>
```

**After (target):**

```markdown
## The Path to High-Autonomy Success

> **Key insight:** Keep core logic unified. Context switching fragments reasoning.

### 1. The Unified Neural Core

[content - no XML wrapper]
```

---

## Phase 2: Skills Refactor

### 2.1 invocable-development Split

**Current:** Single 1300+ line skill covering all invocable patterns

**Target:** 4 granular skills with clear boundaries

#### New Skill Structure

```
.claude/skills/
├── invocable-authoring/
│   ├── SKILL.md              # Create commands & skills
│   └── references/
│       ├── frontmatter.md    # Frontmatter syntax
│       ├── structure.md      # Directory patterns
│       └── examples.md       # Complete examples
├── invocable-iterate/
│   ├── SKILL.md              # Improve existing components
│   └── references/
│       ├── audit-checklist.md
│       └── critique-patterns.md
├── command-authoring/        # If distinct from skill-authoring
└── command-iterate/
```

#### Skill 1: invocable-authoring

**Description (optimized for discoverability):**

```yaml
---
name: invocable-authoring
description: "Create portable commands and skills with SKILL.md, frontmatter, and references. Use when building new components, defining frontmatter, structuring directories, or writing progressive disclosure content. Includes template patterns, What-When-Not-Includes format, and directory structure conventions. Not for auditing, critiquing, or iterating existing components."
---
```

#### Skill 2: invocable-iterate

**Description:**

```yaml
---
name: invocable-iterate
description: "Audit, critique, and improve existing commands and skills. Use when reviewing components for quality, checking frontmatter, validating references, or identifying improvements. Includes audit checklists, quality gates, and common anti-patterns. Not for creating new components or frontmatter syntax."
---
```

#### Skill 3: command-authoring (optional - if distinct enough)

**Description:**

```yaml
---
name: command-authoring
description: "Create single-file commands with dynamic content injection (@, !). Use when building commands that need filesystem access, git state, or runtime context. Includes content injection patterns, argument handling, and @path/!command syntax. Not for skills (use invocable-authoring)."
---
```

#### Skill 4: command-iterate (optional - if distinct enough)

**Description:**

```yaml
---
name: command-iterate
description: "Audit and improve commands with dynamic content injection. Use when reviewing commands for @/! patterns, validating argument handling, or improving dynamic context loading. Includes injection validation and error handling patterns."
---
```

### 2.2 Visual Patterns to Adopt

#### Emoji Anchor System (from skill-creator)

````markdown
## Validation Checklist

✅ **DO:**

- Use third-person in description
- Include specific trigger phrases

❌ **DON'T:**

- Use second person
- Have vague trigger conditions

## Good vs Bad Examples

✅ **Good:**

```yaml
description: "Create skills. Use when building components..."
```
````

❌ **Bad:**

```yaml
description: "Use this skill when creating skills..."
```

````

#### Navigation Tables

```markdown
| If you need... | Read... |
| :------------- | :------ |
| Quick start    | ## Quick Start |
| Patterns       | ## PATTERN: Command Structure |
| Examples       | ## EXAMPLE: Complete Skill |
| Troubleshooting| ## TROUBLESHOOTING |
````

#### Recognition Questions

```markdown
> **Recognition:** Is this a portable component or infrastructure?
```

---

## Phase 3: Component Refactor Template

### 3.1 New SKILL.md Template

````markdown
---
name: [component-name]
description: "Verb + object. Use when [specific cases]. Includes [features]. Not for [exclusions]."
---

# Component Name

## What This Does

[2-3 sentences on purpose]

## Quick Start

**For [use case 1]:** [Action] → [Result]

**For [use case 2]:** [Action] → [Result]

## PATTERN: [Name]

[Implementation guidance]

**Example:**

```[language]
[complete example]
```
````

## ANTI-PATTERN: [Name]

[What to avoid and why]

**Instead:**

```[language]
[correct example]
```

## TROUBLESHOOTING

| Issue     | Cause        | Solution |
| --------- | ------------ | -------- |
| [Problem] | [Root cause] | [Fix]    |

---

## Recognition Questions

- **"Is this for [domain]?"** → [Guidance]
- **"Does this require [condition]?"** → [What to do]

## See Also

- `[references/pattern-x.md]` - [Description]
- `[references/lookup-y.md]` - [Description]

````

### 3.2 Reference File Template

```markdown
# Reference Title

## Navigation

| If you need... | Read... |
| :------------- | :------ |
| [Topic A]      | ## Section A |
| [Topic B]      | ## Section B |

## TL;DR

[Executive summary - 2-3 lines]

## PATTERN: [Name]

[Content]

## ANTI-PATTERN: [Name]

[Content]

## EDGE: [Name]

[Content]

---

## Quick Reference

| Item | Value |
| ---- | ----- |
| [Key] | [Value] |
| [Key] | [Value] |
````

---

## Phase 4: Migration Order

### Step 1: Create New Skills (Phase 2)

1. Create `invocable-authoring/SKILL.md`
2. Create `invocable-authoring/references/*.md`
3. Create `invocable-iterate/SKILL.md`
4. Create `invocable-iterate/references/*.md`

### Step 2: Refactor Rules (Phase 1)

1. Refactor `architecture.md`
2. Refactor `principles.md`
3. Refactor `quality.md`
4. Refactor `content-injection.md`

### Step 3: Update Existing Skills

1. Reference new skills in CLAUDE.md
2. Update skill library index
3. Archive or update old invocable-development references

### Step 4: Validation

1. Run `/toolkit:audit` on all components
2. Verify discoverability via descriptions
3. Test reference navigation

---

## Success Metrics

| Metric                                 | Target                                         |
| -------------------------------------- | ---------------------------------------------- |
| XML tags per file                      | ≤3 (mission_control, critical_constraint only) |
| Skills with ✅/❌ markers              | All skills                                     |
| Reference files with navigation tables | All                                            |
| Frontmatter description length         | 50-100 words                                   |
| Skill body length                      | 1500-2500 words                                |
| Recognition questions per skill        | ≥3                                             |

---

## Key Inspirations from skill-creator

1. **✅/❌ visual anchors** - Immediate attention grabbing
2. **Third-person trigger phrases** - "This skill should be used when..."
3. **Example-driven teaching** - Concrete before abstract
4. **Recognition questions** - Anti-laziness pattern
5. **Validation checklist** - Quality gates
6. **Navigation tables** - Quick lookup
7. **Minimal XML** - Only when truly needed

---

## Open Questions

1. Should `command-authoring` and `command-iterate` be separate skills, or merged into `invocable-authoring/iterate` with command-specific sections?

2. Should the 4 skills use nested naming (`invocable/authoring`, `invocable/iterate`) or flat (`invocable-authoring`)?

3. Should `<mission_control>` be removed entirely, or kept for critical components?

4. How to handle backward compatibility for existing `/toolkit:build:*` commands?
