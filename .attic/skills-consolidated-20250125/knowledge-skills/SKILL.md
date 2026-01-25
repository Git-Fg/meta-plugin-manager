---
name: knowledge-skills
description: "This skill should be used when the user asks to 'understand skills', 'learn skill structure', 'review skill quality', 'check skill best practices', or needs reference knowledge for the Agent Skills standard. Provides YAML format specifications, Progressive Disclosure tiers, quality dimensions, and anti-patterns. Pure reference—no execution logic."
---

# Knowledge: Skills

Reference knowledge for the Agent Skills standard. Load this skill to understand concepts, then use factory skills for execution.

## Core Principle: Context Window Stewardship

The context window is a shared resource. Challenge each piece of information: "Does Claude really need this?" Default assumption: Claude is already very smart—only add context Claude doesn't already have.

**Delta Standard:** Good Customization = Expert-only Knowledge − What Claude Already Knows

## Quick Reference

**Agent Skills Specification:** https://agentskills.io/specification
**Official Documentation:** https://code.claude.com/docs/en/skills

## Skill Structure

### Required Frontmatter

```yaml
---
name: skill-name              # Required, kebab-case
description: "This skill should be used when the user asks to '[trigger 1]', '[trigger 2]'. [What it does]."
user-invocable: true          # Optional: true (default) or false
context: fork                 # Optional: for isolated execution
agent: Explore                # Optional: when context: fork
model: sonnet                 # Optional: for subagents
---
```

### Description Format

Write descriptions in third-person with explicit trigger phrases:

**Pattern:**
```yaml
description: "This skill should be used when the user asks to '[action 1]', '[action 2]'. [Brief purpose]."
```

**Good:**
```yaml
description: "This skill should be used when the user asks to 'create a hook', 'add a PreToolUse hook', 'validate tool use'. Provides comprehensive hooks API guidance."
```

**Bad:**
```yaml
description: "Use when working with hooks."  # Wrong person, vague
description: "Provides hook guidance."        # No trigger phrases
```

### Three Skill Types

| Type | Called By | Purpose | Win Conditions |
|------|-----------|---------|----------------|
| **Regular Skills** | User | Domain expertise, workflows | Not required |
| **Knowledge Skills** | User/Architect | Implementation guidance | Not required |
| **Transitive Skills** | Other Skills | Workflow steps | Required |

## Progressive Disclosure

Skills use a three-level loading system:

| Tier | When Loaded | Purpose | Size Target |
|------|-------------|---------|-------------|
| **1: Metadata** | Always | Discovery & relevance | ~100 tokens (YAML frontmatter) |
| **2: Body** | On invocation | Core implementation | <500 lines, 1,500-2,000 words |
| **3: References** | On demand | Deep details | Unlimited per file |

### What Goes Where

**SKILL.md Body (always loaded when skill triggers):**
- Core concepts and overview
- Essential procedures and workflows
- Quick reference tables
- Pointers to references/scripts
- Most common use cases

**references/ (loaded as needed):**
- Detailed patterns and advanced techniques
- Comprehensive API documentation
- Migration guides and edge cases
- Extensive examples and walkthroughs

### Disclosure Patterns

See [progressive-disclosure.md](references/progressive-disclosure.md) for:
- High-level guide with references pattern
- Domain-specific organization pattern
- Conditional details pattern

## Quality Assessment

### Essential Checklist (All Must Pass)

- [ ] Description uses third-person with trigger phrases
- [ ] Completes without asking user questions (80-95% autonomy)
- [ ] SKILL.md body under 500 lines
- [ ] Self-contained (no external dependencies)

### Autonomy Scoring

| Score | Questions | Rating |
|-------|-----------|--------|
| 95% | 0-1 | Excellent |
| 85% | 2-3 | Good |
| 80% | 4-5 | Acceptable |
| <80% | 6+ | Fail |

See [quality-framework.md](references/quality-framework.md) for complete practical checklist.

## Writing Style

### Imperative/Infinitive Form

Write using verb-first instructions, not second person:

**Correct:**
```markdown
Parse the configuration file.
Validate input before processing.
Extract fields with grep.
```

**Incorrect:**
```markdown
You should parse the configuration file.
You need to validate input.
You can extract fields with grep.
```

### Third-Person in Description

The frontmatter description must use third person:

**Correct:**
```yaml
description: "This skill should be used when the user asks to 'create X', 'configure Y'..."
```

**Incorrect:**
```yaml
description: "Use this skill when you want to create X..."
```

## Resource Taxonomy

| Type | Purpose | When to Use |
|------|---------|-------------|
| **scripts/** | Deterministic execution | Complex operations >3-5 lines |
| **references/** | On-demand knowledge | Domain-specific details |
| **assets/** | Output artifacts | Templates, images |

## Architecture Patterns

### Context Fork Skills

**Use For:**
- High-volume output (extensive grep, repo traversal)
- Noisy exploration that clutters conversation
- Tasks requiring separate context window

**Avoid For:**
- Simple, direct tasks
- User interaction workflows
- Low output volume operations

### Hub-and-Spoke Orchestration

**When:** Multi-step workflows (>3 steps) with high-volume intermediate output

**Problem:** Linear skill chains accumulate "context rot"

**Solution:** Hub skill orchestrates, worker skills (context: fork) execute in isolation

See [orchestration-patterns.md](references/orchestration-patterns.md) for implementation details.

## Anti-Patterns

### Command Wrapper

**Problem:** Skill exists only to invoke a single command
**Recognition:** "Could the description alone suffice?"
**Fix:** Remove the skill—let Claude run commands directly

### Non-Self-Sufficient

**Problem:** Skill requires constant user hand-holding
**Recognition:** "Can this work standalone?"
**Fix:** Add examples, context detection, decision trees

### Context Fork Misuse

**Problem:** Simple task uses isolation unnecessarily
**Recognition:** "Is the overhead justified?"
**Fix:** Remove `context: fork` for simple tasks

### Tier 2 Bloat

**Problem:** SKILL.md exceeds 500 lines
**Recognition:** "Could this be a reference file?"
**Fix:** Move detailed content to references/

See [anti-patterns.md](references/anti-patterns.md) for complete catalog.

## What NOT to Include

Do NOT create extraneous files:
- README.md
- INSTALLATION_GUIDE.md
- QUICK_REFERENCE.md
- CHANGELOG.md

The skill should only contain information needed for an AI agent to execute the task.

## Reference Files

Load these as needed for comprehensive guidance:

| File | Content | When to Read |
|------|---------|--------------|
| [quality-framework.md](references/quality-framework.md) | Practical quality checklist | Assessing skill quality |
| [progressive-disclosure.md](references/progressive-disclosure.md) | Tier 1/2/3 structure, decision trees | Designing skill structure |
| [description-guidelines.md](references/description-guidelines.md) | What-When-Not framework | Writing skill descriptions |
| [autonomy-design.md](references/autonomy-design.md) | 80-95% completion patterns | Improving skill autonomy |
| [orchestration-patterns.md](references/orchestration-patterns.md) | Hub-and-spoke, context fork | Multi-skill workflows |
| [anti-patterns.md](references/anti-patterns.md) | Complete anti-pattern catalog | Troubleshooting |

## Usage Pattern

1. Load this knowledge skill to understand Agent Skills standards
2. Use the create-skill factory skill for scaffolding new skills
3. Consult reference files for detailed implementation guidance

## Knowledge Only

This skill contains NO execution logic. For scaffolding skills, use the create-skill factory skill.
