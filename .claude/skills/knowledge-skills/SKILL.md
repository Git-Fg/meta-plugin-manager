---
name: knowledge-skills
description: "Reference knowledge for Agent Skills standard: YAML format, Progressive Disclosure tiers, quality dimensions. Use when creating, evaluating, or understanding skills. No execution logic - pure reference."
---

# Knowledge: Skills

Reference knowledge for Agent Skills standard. This skill provides pure knowledge without execution logic.

## Quick Reference

**Agent Skills Specification**: https://agentskills.io/specification
**Official Documentation**: https://code.claude.com/docs/en/skills

### Core Concepts

**Delta Standard**: Good Customization = Expert-only Knowledge − What Claude Already Knows

**Progressive Disclosure**: Tier 1 (metadata) → Tier 2 (SKILL.md <500 lines) → Tier 3 (references/)

**Quality Framework**: Practical checklist for skill quality assessment

**What-When-Not Framework**: Skill descriptions must signal WHAT (core function), WHEN (triggers), NOT (boundaries)

## Skill Structure

### Required Frontmatter Fields

```yaml
---
name: skill-name              # Required, kebab-case
description: "Action object. Use when triggers. Not for anti-triggers."
user-invocable: true          # Optional: true (default) or false
context: fork                 # Optional: for isolated execution
agent: Explore                # Optional: when context: fork
model: sonnet                 # Optional: for subagents
---
```

### Three Skill Types

| Type | Called By | Purpose | Win Conditions |
|------|-----------|---------|----------------|
| **Regular Skills** | User | Domain expertise, workflows | Not required |
| **Knowledge Skills** | User/Architect | Implementation guidance | Not required |
| **Transitive Skills** | Other Skills | Workflow steps | Required |

### Progressive Disclosure Tiers

| Tier | When Loaded | Purpose | Size Target |
|------|-------------|---------|-------------|
| **1** | Always | Discovery & relevance | ~100 tokens (YAML frontmatter) |
| **2** | On invocation | Core implementation | <500 lines |
| **3** | On demand | Deep details | Unlimited |

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

## Quick Assessment Checklist

**Essential (All Must Pass)**:
- [ ] Description clearly describes WHAT/WHEN/NOT
- [ ] Can complete without asking user questions (80-95% autonomy)
- [ ] SKILL.md under 500 lines
- [ ] Self-contained (no external dependencies)

See [quality-framework.md](references/quality-framework.md) for complete checklist.

| File | Content | When to Read |
|------|---------|--------------|
| [progressive-disclosure.md](references/progressive-disclosure.md) | Tier 1/2/3 structure, decision trees | Designing skill structure |
| [quality-framework.md](references/quality-framework.md) | Practical quality checklist | Assessing skill quality |
| [description-guidelines.md](references/description-guidelines.md) | What-When-Not framework | Writing skill descriptions |
| [autonomy-design.md](references/autonomy-design.md) | 80-95% completion patterns | Improving skill autonomy |
| [orchestration-patterns.md](references/orchestration-patterns.md) | Hub-and-spoke, context fork | Multi-skill workflows |
| [anti-patterns.md](references/anti-patterns.md) | Complete anti-pattern catalog | Troubleshooting |

## Quality Dimensions

See [quality-framework.md](references/quality-framework.md) for complete practical checklist covering:
- Knowledge Delta (expert-only vs Claude-obvious)
- Autonomy (80-95% completion without questions)
- Discoverability (clear WHAT/WHEN/NOT triggers)
- Progressive Disclosure (proper tier structure)
- Clarity, Completeness, Standards Compliance, Security, Performance, Maintainability

### Autonomy Scoring

- **95% (Excellent)**: 0-1 questions
- **85% (Good)**: 2-3 questions
- **80% (Acceptable)**: 4-5 questions
- **<80% (Fail)**: 6+ questions

## Architectural Patterns

### Context: Fork Skills

**Use For**:
- High-volume output (extensive grep, repo traversal)
- Noisy exploration that clutters conversation
- Tasks requiring separate context window

**Don't Use For**:
- Simple, direct tasks
- User interaction workflows
- Low output volume operations

### Hub-and-Spoke Orchestration

**When**: Multi-step workflows (>3 steps) with high-volume intermediate output

**Problem**: Linear skill chains accumulate "context rot"

**Solution**: Hub skill orchestrates, worker skills (context: fork) execute in isolation

**Benefits**:
- Prevents context rot
- Enables parallelism
- Error isolation

### Resource Taxonomy

| Type | Purpose | When to Use |
|------|---------|-------------|
| **scripts/** | Deterministic execution | Complex operations >3-5 lines |
| **references/** | On-demand knowledge | Domain-specific details |
| **assets/** | Output artifacts | Templates, images |

## Anti-Patterns

### Command Wrapper Anti-Pattern

**Problem**: Skill exists only to invoke a single command

**Recognition**: "Could the description alone suffice?"

**Fix**: Remove the skill - let Claude run commands directly

### Non-Self-Sufficient Anti-Pattern

**Problem**: Skill requires constant user hand-holding

**Recognition**: "Can this work standalone?"

**Fix**: Add examples, context detection, decision trees

### Context Fork Misuse

**Problem**: Simple task uses isolation unnecessarily

**Recognition**: "Is the overhead justified?"

**Fix**: Remove `context: fork` for simple tasks

### Tier 2 Bloat

**Problem**: SKILL.md exceeds 500 lines

**Recognition**: "Could this be a reference file?"

**Fix**: Move detailed content to Tier 3 (references/)

## Usage Pattern

Load this knowledge skill to understand Agent Skills standards, then use the create-skill factory skill for scaffolding new skills.

## Knowledge Only

This skill contains NO execution logic. For scaffolding skills, use the create-skill factory skill.
