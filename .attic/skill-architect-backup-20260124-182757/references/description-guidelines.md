# Description Guidelines

Write clear, actionable skill descriptions using the What-When-Not framework.

## What-When-Not Framework

### Components

**WHAT**: What the skill does (core function)
**WHEN**: When to use it (triggers, contexts)
**NOT**: What it doesn't do (boundaries)

### Good Description Structure

```yaml
---
name: skill-name
description: "WHAT. Use when: WHEN. Not for: NOT."
---
```

## Examples

### Example 1: Auto-Discoverable Skill

**Good**:
```yaml
---
name: api-conventions
description: "RESTful API design patterns for this codebase. Use when writing endpoints, modifying existing endpoints, or reviewing API changes. Not for GraphQL or RPC APIs."
---
```

**Components**:
- WHAT: RESTful API design patterns
- WHEN: Writing, modifying, or reviewing endpoints
- NOT: GraphQL or RPC APIs

### Example 2: User-Triggered Skill

**Good**:
```yaml
---
name: deploy
description: "Deploy application to production with zero-downtime. Use when releasing features or updates. Requires approval. Not for development environments."
disable-model-invocation: true
---
```

### Example 3: Background Context Skill

**Good**:
```yaml
---
name: legacy-auth-system
description: "Explains legacy authentication architecture and migration path. Use when maintaining old code or planning migration. Not for new features."
user-invocable: false
---
```

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

## Templates

### Knowledge Skill
```yaml
description: "[DOMAIN] patterns. Use when: [TRIGGERS]. Not for: [BOUNDARIES]."
```

### Workflow Skill
```yaml
description: "[ACTION] [WHAT]. Use when: [TRIGGERS]. [CONSTRAINTS]. Not for: [BOUNDARIES]."
```

### Context Skill
```yaml
description: "[WHAT] [CONTEXT]. Use when: [TRIGGERS]. Not for: [BOUNDARIES]."
```

## Quick Test

**Pass if**:
- ✓ Claude can decide relevance
- ✓ Specific triggers present
- ✓ Boundaries clear
- ✓ Scannable in 3 seconds
