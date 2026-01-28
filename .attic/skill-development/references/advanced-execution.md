# Advanced Execution Patterns

Reference for advanced skill patterns. Load when refining, auditing, or creating complex skills.

## Advanced Frontmatter Fields

Beyond `name` and `description`, skills support execution control:

```yaml
---
name: code-audit
description: "This skill should be used when..."

# Invocation Control
disable-model-invocation: false  # true = manual-only (/command required)
user-invocable: true             # false = hide from menu, Claude-only

# Execution Context
context: fork                    # Run in isolated subagent (default: inline)
agent: Explore                   # Agent type when forked: Explore, Plan
model: sonnet                    # Override model: sonnet, opus, haiku

# Tool Restrictions
allowed-tools: Read, Grep, Glob  # Limit available tools

# Arguments
argument-hint: "[file-path]"     # Show hint in menu
---
```

### Field Reference

| Field | Default | Use Case |
|-------|---------|----------|
| `disable-model-invocation` | `false` | `true` for safety-critical ops (deploy, delete) |
| `user-invocable` | `true` | `false` for internal/reference skills |
| `context` | `inline` | `fork` for isolation, verbose output |
| `agent` | - | `Explore` (read-only), `Plan` (structured) when forked |
| `model` | inherit | `haiku` for speed, `opus` for complex |
| `allowed-tools` | all | Restrict to `Read, Grep` for audits |

---

## Forked Execution

When a skill produces verbose output or needs isolation:

```yaml
---
name: deep-research
description: "Research codebase patterns thoroughly"
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob
---
```

### When to Fork

- Task produces >500 tokens of output
- Exploratory work that shouldn't clutter main conversation
- Tool restrictions needed (read-only audit)
- Different model for cost optimization

### Execution Flow

1. Subagent spawns with skill content
2. Subagent executes in isolation
3. Summary returned to main conversation
4. Main context stays clean

---

## Dynamic Context Injection

Inject live data using `!`command"` syntax:

```markdown
## Current Context

- **Branch**: !`git rev-parse --abbrev-ref HEAD`
- **Recent commits**: !`git log -3 --oneline`
- **Changed files**: !`git diff --name-only HEAD~1`
```

The command executes before Claude sees content, replacing placeholder with actual output.

**Use for**: Git info, environment state, file listings, API status.

---

## Production Patterns

### Pattern 1: Reference Skill (Auto-Applied Knowledge)

```yaml
---
name: typescript-conventions
description: "TypeScript conventions for this team. Use when writing TypeScript."
user-invocable: false
---
```

Claude auto-applies when relevant, not shown in menu.

### Pattern 2: Safety-Critical Skill (Manual-Only)

```yaml
---
name: deploy-production
description: "Deploy to production"
disable-model-invocation: true
context: fork
---
```

User must explicitly invoke `/deploy-production`.

### Pattern 3: Audit Skill (Read-Only Isolation)

```yaml
---
name: security-audit
description: "Audit code for security issues"
context: fork
agent: Explore
allowed-tools: Read, Grep, Glob, Bash(git:*)
---
```

Isolated, read-only, returns summary.

### Pattern 4: Cost-Optimized Skill

```yaml
---
name: file-organizer
description: "Organize project files"
model: haiku
---
```

Uses cheaper model for simple tasks.

---

## When to Apply These Patterns

| Situation | Pattern |
|-----------|---------|
| Creating basic skill | Use only `name` + `description` |
| Skill triggers incorrectly | Improve description specificity |
| Skill needs isolation | Add `context: fork` |
| Dangerous operation | Add `disable-model-invocation: true` |
| Too many tokens consumed | Add `model: haiku` or fork |
| Skill should be read-only | Add `allowed-tools: Read, Grep, Glob` |
| Need live git/env data | Use `!`command"` injection |

---

## See Also

- [orchestration-patterns.md](orchestration-patterns.md) - Hub-and-spoke, multi-skill workflows
- [anti-patterns.md](anti-patterns.md) - Common mistakes to avoid
