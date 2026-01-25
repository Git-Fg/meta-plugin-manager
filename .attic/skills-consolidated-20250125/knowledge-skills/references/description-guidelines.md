# Description Guidelines

Write clear, actionable skill descriptions using the What-When-Not framework.

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

**The "Commander's Intent" Principle**: Tell Claude WHAT you want accomplished and WHY it matters, but not HOW to achieve it. This allows intelligent adaptation to circumstances.

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

The first example forces Claude to parse implementation noise to understand the purpose. The second immediately conveys **what** and **when**.

### 5. Maintenance Nightmare

Implementation changes require updating:
- The actual logic
- The SKILL.md
- The description (if "how" is embedded)

This creates drift. When description focuses on **what/when**, it remains stable even as implementation evolves.

---

## Description Structure

### Required Elements

```yaml
---
name: skill-name              # 2-4 words, kebab-case
description: "WHAT. Use when: WHEN. Not for: NOT."
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
| `skill-architect` | "Build self-sufficient skills following Agent Skills standard. Use when creating, evaluating, or enhancing skills with progressive disclosure." | WHAT: Build skills. WHEN: Creating/evaluating/enhancing. Keywords: Agent Skills, progressive disclosure |
| `code-pattern-analyzer` | "Analyze code patterns and generate reports. Use when investigating architecture, finding usage patterns, or auditing code quality." | WHAT: Analyze patterns, generate reports. WHEN: Multiple clear triggers |
| `deploy-skill` | "Deploy application with validation. Use for production deployments only. Not for development testing." | WHAT: Deploy with validation. WHEN: Production only. NOT: Development |

### Bad Descriptions

| Description | Problem |
|-------------|---------|
| "Use when creating skills" | Too generic, no clear purpose |
| "This skill analyzes code by reading files, running grep, formatting output, and saving reports" | Includes "how" (implementation details) |
| "A helpful skill for various code-related tasks" | Vague, no clear triggers |
| "The best way to create skills with all the features" | Subjective, no specific purpose |
| "Use to CREATE skills by following these steps..." | Contains "how" language |

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

**Avoid**: Generic terms that match everything: "helpful", "useful", "tool"

---

## Anti-Patterns

### Anti-Pattern 1: "Use to" Language

**Bad**:
```yaml
description: "Use to CREATE APIs by following best practices"
```

**Good**:
```yaml
description: "API design patterns following REST principles. Use when creating or modifying endpoints."
```

### Anti-Pattern 2: Vague Purpose

**Bad**:
```yaml
description: "A helpful skill for database work"
```

**Good**:
```yaml
description: "PostgreSQL query optimization patterns. Use when writing complex queries or optimizing performance."
```

### Anti-Pattern 3: Missing Triggers

**Bad**:
```yaml
description: "Security validation patterns"
```

**Good**:
```yaml
description: "Security validation patterns for web applications. Use when reviewing code or auditing security."
```

### Anti-Pattern 4: Over-Specified with "How"

**Bad**:
```yaml
description: "This skill validates YAML by checking syntax, verifying required fields, and testing structure"
```

**Good**:
```yaml
description: "Validate YAML structure and required fields. Use when testing skill quality or checking configuration files."
```

---

## Templates by Skill Type

### Knowledge Skill
```yaml
description: "[DOMAIN] patterns. Use when: [TRIGGERS]. Not for: [BOUNDARIES]."
```

**Example**:
```yaml
description: "RESTful API design patterns for this codebase. Use when writing endpoints, modifying endpoints, or reviewing API changes. Not for GraphQL or RPC APIs."
```

### Workflow Skill
```yaml
description: "[ACTION] [WHAT]. Use when: [TRIGGERS]. [CONSTRAINTS]. Not for: [BOUNDARIES]."
```

**Example**:
```yaml
description: "Deploy application to production with zero-downtime. Use when releasing features or updates. Requires approval. Not for development environments."
```

### Context Skill
```yaml
description: "[WHAT] [CONTEXT]. Use when: [TRIGGERS]. Not for: [BOUNDARIES]."
```

**Example**:
```yaml
description: "Explains legacy authentication architecture and migration path. Use when maintaining old code or planning migration. Not for new features."
```

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

## Quick Test

**Pass if**:
- ✓ Claude can decide relevance
- ✓ Specific triggers present
- ✓ Boundaries clear
- ✓ Scannable in 3 seconds

**See also**:
- [quality-framework.md](quality-framework.md) - Discoverability dimension scoring
- [progressive-disclosure.md](progressive-disclosure.md) - Tier 1/2/3 structure
- [anti-patterns.md](anti-patterns.md) - Complete anti-pattern catalog
