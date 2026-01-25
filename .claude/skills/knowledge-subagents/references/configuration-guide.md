# Subagent Configuration Guide

Complete frontmatter reference with examples and anti-patterns.

## Required Fields

```yaml
---
name: agent-name              # Unique, hyphenated, descriptive
description: "Purpose when situation. Use for specific tasks."
---
```

## Optional Fields

```yaml
model: sonnet                 # haiku | sonnet | opus | inherit
tools:                        # Allowlist (use ONE of tools/disallowedTools)
  - Read
  - Grep
  - Bash
disallowedTools:              # Denylist
  - Write
  - Edit
permissionMode: default       # default | safe
skills:                       # Inject skill content
  - skill-name
hooks:                        # Lifecycle hooks
  PreToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./scripts/validate.sh"
```

## Invalid Fields (Don't Use)

| Field | Why Invalid |
|-------|-------------|
| `context: fork` | Skills only, not subagents |
| `agent: Explore` | Field doesn't exist |
| `user-invocable` | Subagents aren't user-invocable |
| `disable-model-invocation` | Not a subagent field |

## Complete Examples

### Read-Only Analyzer

```yaml
---
name: code-analyzer
description: "Analyzes code for patterns when code review requested. Read-only analysis without modifications."
model: haiku
disallowedTools:
  - Write
  - Edit
  - Bash
permissionMode: safe
---
```

### Deployment Agent

```yaml
---
name: deploy-automation
description: "Automates deployment when deploying to production. Handles build, test, deploy sequence."
model: haiku
tools:
  - Bash
  - Read
  - Grep
permissionMode: safe
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./scripts/validate-env.sh"
---
```

### Complex Orchestrator

```yaml
---
name: workflow-orchestrator
description: "Orchestrates multi-agent workflows when complex coordination needed."
model: sonnet
tools:
  - Read
  - Grep
  - Bash
permissionMode: safe
skills:
  - knowledge-subagents
hooks:
  PreToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./scripts/validate.sh"
---
```

## Anti-Patterns

### ❌ No Tool Restrictions

```yaml
# BAD: No restrictions
---
name: powerful-agent
description: "Can do everything"
---

# GOOD: Restrict appropriately
---
name: code-analyzer
disallowedTools:
  - Write
  - Edit
---
```

### ❌ Vague Description

```yaml
# BAD: Not actionable
---
name: helper
description: "Helps with things"
---

# GOOD: Specific trigger
---
name: deploy-verifier
description: "Verifies deployment readiness when deploying to production"
---
```

### ❌ Wrong Model Choice

```yaml
# BAD: Overpowered for simple task
---
name: log-reader
model: opus
---

# GOOD: Appropriate model
---
name: log-reader
model: haiku
---
```

## Validation Checklist

- [ ] `name` unique and descriptive
- [ ] `description` states when to use
- [ ] `model` appropriate for complexity
- [ ] `tools` or `disallowedTools` restricts appropriately
- [ ] No invalid fields
- [ ] YAML syntax valid
