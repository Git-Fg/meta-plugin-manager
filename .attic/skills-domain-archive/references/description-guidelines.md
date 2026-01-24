# Skill Description Guidelines

**Purpose**: Ensure skill descriptions enable auto-discovery without over-specifying implementation.

---

## The What-When-Not Framework

Skill descriptions must answer three questions:

| Element | Purpose | Example |
|---------|---------|---------|
| **WHAT** | What the skill does | "Create self-sufficient skills" |
| **WHEN** | When to use it | "Use when building autonomous capabilities" |
| **NOT** | When NOT to use it | "Do not use for general programming" |

**What descriptions should NOT include**: Implementation details ("how").

---

## Why "How" in Descriptions is an Anti-Pattern

### 1. Progressive Disclosure Violation

The description field (Tier 1) is **always loaded** — it's part of the auto-discovery metadata. Every time Claude lists available skills, it processes ALL descriptions. Putting "how" here wastes token budget on details only needed when the skill is actually invoked.

```
Tier 1 (always loaded):  name + description + metadata (~100 tokens)
Tier 2 (on invocation):  SKILL.md with workflows
Tier 3 (on-demand):      references/ for deep details
```

### 2. Trust vs. Micro-Management

Claude is an intelligent agent. When you specify "how" in the description, you're treating Claude like a script executor that needs explicit instructions, rather than an intelligent system that can read context and determine the best approach.

**The "Commander's Intent" Principle**: Military doctrine teaches that you tell commanders WHAT you want accomplished and WHY it matters, but not HOW to achieve it. This allows intelligent adaptation to circumstances.

### 3. Rigidity & Brittleness

Over-specified descriptions create rigid skills that can't adapt to:
- Different project contexts
- Edge cases not anticipated by the author
- Evolving best practices

The "how" should live in SKILL.md where it can be comprehensive and context-aware. The description should be a **signal**, not a **manual**.

### 4. Discoverability Suffers

When descriptions are verbose:

```
❌ "This skill analyzes code by first reading all files, then running grep patterns,
    then formatting output with markdown headers, and finally saves to a report..."

✅ "Analyze code patterns across a codebase and generate structured reports"
```

The first example forces Claude (and users) to parse implementation noise to understand the purpose. The second immediately conveys **what** and **when**.

### 5. Maintenance Nightmare

Implementation changes require updating:
- The actual logic
- The SKILL.md
- The description (if "how" is embedded)

This creates drift. When description focuses on **what/when**, it remains stable even as implementation evolves.

### 6. Token Efficiency

Every character in the description is processed during skill discovery. Verbose descriptions bloat the always-loaded context with details that are rarely needed at decision time.

---

## Description Structure

### Required Elements

```yaml
---
name: skill-name              # 2-4 words, kebab-case
description: "WHAT. Use WHEN. NOT for EXCLUSION."
---
```

### Length Guidelines

| Context | Maximum | Rationale |
|---------|---------|-----------|
| Description | ~200 characters | Auto-discovery efficiency |
| Description | ~30 words | Readability threshold |

### Template

```
"[ACTION-OBJECT]. Use when [CONTEXT/TRIGGER]. Not for [EXCLUSION]."
```

---

## Examples

### Good Descriptions

| Skill | Description | Why It Works |
|-------|-------------|--------------|
| `skills-architect` | "Create self-sufficient skills following Agent Skills standard. Use when building autonomous capabilities with progressive disclosure." | WHAT: Create skills. WHEN: Building capabilities. Keywords: Agent Skills, progressive disclosure |
| `code-pattern-analyzer` | "Analyze code patterns and generate reports. Use when investigating architecture, finding usage patterns, or auditing code quality." | WHAT: Analyze patterns, generate reports. WHEN: Multiple clear triggers |
| `deploy-skill` | "Deploy application with validation. Use for production deployments only. Not for development testing." | WHAT: Deploy with validation. WHEN: Production only. NOT: Development |

### Official skill-creator Description

```yaml
name: skill-creator
description: Guide for creating effective skills. This skill should be used when users want to create a new skill (or update an existing skill) that extends Claude's capabilities with specialized knowledge, workflows, or tool integrations.
```

**Analysis**: Official includes "how" language ("guide for creating", "extends capabilities") which provides helpful behavioral context. While the What-When-Not framework optimizes for discoverability, the official approach shows that minimal contextual "how" language can shape behavior beneficially.

**Balanced approach**: Include what/when/not for discoverability, plus minimal behavioral guidance that doesn't over-specify implementation.

### Bad Descriptions

| Description | Problem |
|-------------|---------|
| "Use when creating skills" | Too generic, no clear purpose |
| "This skill analyzes code by reading files, running grep, formatting output, and saving reports" | Includes "how" (implementation details) |
| "A helpful skill for various code-related tasks" | Vague, no clear triggers |
| "The best way to create skills with all the features" | Subjective, no specific purpose |

---

## Trigger Words for Auto-Discovery

Claude auto-discovers skills by matching user queries against description keywords.

### Effective Trigger Patterns

| Domain | Trigger Words |
|--------|---------------|
| Skill Creation | "create skills", "build capabilities", "Agent Skills", "progressive disclosure" |
| Code Analysis | "analyze patterns", "investigate architecture", "audit code", "find usage" |
| Testing | "test skills", "validate patterns", "autonomy testing" |
| Documentation | "update CLAUDE.md", "project memory", "documentation" |

### Context-Aware Triggers

Include domain-specific terminology:
- **Domain-specific**: "React components", "Kubernetes deployment", "API design"
- **Role-specific**: "DevOps workflow", "frontend architecture", "data pipeline"

Avoid generic terms that match everything: "helpful", "useful", "tool".

---

## Integration with Quality Framework

The **Discoverability** dimension (15 points) scores descriptions based on:

| Score | Criteria |
|-------|----------|
| 13-15 | Clear WHAT/WHEN/NOT, discoverable, concise |
| 10-12 | Good triggers, minor verbosity |
| 7-9 | Adequate triggers, some ambiguity |
| 4-6 | Unclear triggers, verbose |
| 0-3 | No clear triggers, or includes "how" |

**Minimum for production**: ≥12/15

---

## Quick Checklist

Before finalizing a description:

- [ ] Describes WHAT the skill does (action + object)
- [ ] Describes WHEN to use it (context/triggers)
- [ ] Describes when NOT to use it (exclusion)
- [ ] Under ~200 characters
- [ ] Under ~30 words
- [ ] No implementation details ("how")
- [ ] Includes discoverable keywords
- [ ] Specific to the skill's purpose

---

## See Also

- [quality-framework.md](quality-framework.md) - Discoverability dimension scoring
- [progressive-disclosure.md](progressive-disclosure.md) - Tier 1/2/3 structure
- SKILL.md Common Anti-Patterns section - Skill over-engineering patterns
