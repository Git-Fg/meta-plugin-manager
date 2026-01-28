# Advanced Execution Patterns

Reference for advanced skill patterns. Load when refining, auditing, or creating complex skills.

## Advanced Frontmatter Fields

Beyond `name` and `description`, skills support execution control:

```yaml
---
name: code-audit
description: "This skill should be used when..."

# Invocation Control
disable-model-invocation: false # true = manual-only (/command required)
user-invocable: true # false = hide from menu, Claude-only

# Execution Context
context: fork # Run in isolated subagent (default: inline)
agent: Explore # Agent type when forked: Explore, Plan
model: sonnet # Override model: sonnet, opus, haiku

# Tool Restrictions
allowed-tools: Read, Grep, Glob # Limit available tools

# Arguments
argument-hint: "[file-path]" # Show hint in menu
---
```

### Field Reference

| Field                      | Default  | Use Case                                               |
| -------------------------- | -------- | ------------------------------------------------------ |
| `disable-model-invocation` | `false`  | `true` for safety-critical ops (deploy, delete)        |
| `user-invocable`           | `true`   | `false` for internal/reference skills                  |
| `context`                  | `inline` | `fork` for isolation, verbose output                   |
| `agent`                    | -        | `Explore` (read-only), `Plan` (structured) when forked |
| `model`                    | inherit  | `haiku` for speed, `opus` for complex                  |
| `allowed-tools`            | all      | Restrict to `Read, Grep` for audits                    |

---

## Forked Execution

<critical_constraint>
**PHILOSOPHY BUNDLE MANDATORY FOR context: fork**

When a skill uses `context: fork`, it runs in ISOLATION and loses access to `.claude/rules/`.

**The Conflict:**

- Layer A (principles.md): Skills must be 100% self-contained
- Layer B (orchestration): Worker skills MUST use `context: fork` for result aggregation
- Result: Forked skills lose Layer A rules and may "hallucinate" standards

**The Fix:**
Any skill with `context: fork` MUST include a `<philosophy_bundle>` section containing the essential rules it needs to function correctly in isolation.

See "Philosophy Bundles" section below for implementation.
</critical_constraint>

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
- **Hub-and-spoke worker: MUST use fork for result aggregation**

### Execution Flow

1. Subagent spawns with skill content ONLY (no .claude/rules access)
2. Subagent executes in isolation
3. Summary returned to main conversation
4. Main context stays clean

### Critical: Philosophy Bundles for Forked Skills

<rule_category name="philosophy_bundle_requirement">
<pattern name="philosophy_bundle_for_forked_skills">
<principle>Forked skills lose access to Layer A rules (.claude/rules/). To maintain quality standards in isolation, they must carry their own "genetic code."</principle>

<recognition>
Question: "Does this skill use context: fork? If yes, does it include all rules it needs to function correctly?"
</recognition>

<instructions>
When creating a skill with `context: fork`:

1. Identify which Layer A rules the skill implicitly relies on
2. Extract the CORE principles needed (not everything, just essentials)
3. Add a `<philosophy_bundle>` section to SKILL.md
4. Include only rules that affect BEHAVIOR, not style

**What belongs in philosophy_bundle:**

- Portability invariants (e.g., "no external dependencies")
- Critical constraints (e.g., "ALWAYS validate before save")
- Quality standards (e.g., "80-95% autonomy target")
- Anti-patterns the skill must avoid
- Safety/security requirements

**What does NOT belong:**

- Generic instructions Claude already knows
- Style preferences (tabs vs spaces, etc.)
- Project-specific conventions that don't affect behavior
- Tutorial content
  </instructions>

<example type="positive">
<description>Security audit skill with proper philosophy bundle</description>
<content>

## Philosophy Bundle (context: fork requires self-contained rules)

This skill runs in isolated context and carries essential quality standards:

<critical_constraint>
MANDATORY: Never modify code during audit - read-only analysis only
MANDATORY: Always provide file:line locations for findings
MANDATORY: Apply contextual judgment - distinguish security issues from style preferences
No exceptions. Security audits must be accurate and actionable.
</critical_constraint>

**Scope Limit:**

- Report findings, do not fix
- Identify actual vulnerabilities, not theoretical concerns
- Prioritize by severity (Critical > High > Medium > Low)

**What This Skill Does NOT Do:**

- Does not modify files
- Does not deploy changes
- Does not access external systems
  </content>
  </example>

<example type="negative">
<description>Audit skill without philosophy bundle - relies on external rules</description>
<content>

# Security Audit

## Process

1. Read files
2. Find security issues
3. Report findings

[Missing: Critical constraints, scope limits, behavioral standards]
[Result: When forked, skill may modify code or generate false positives]
</content>
</example>
</pattern>
</rule_category>

### Philosophy Bundle Template

For any skill using `context: fork`, include this section after the main content:

```markdown
## Philosophy Bundle

This skill runs in isolated context and carries essential quality standards:

<critical_constraint>
MANDATORY: [Critical behavioral rule 1]
MANDATORY: [Critical behavioral rule 2]
No exceptions. [Why this matters]
</critical_constraint>

**Scope:** [What the skill does and does NOT do]

**Standards Applied:**

- [Standard 1 that affects behavior]
- [Standard 2 that affects behavior]
```

### Verification Checklist

Before finalizing a `context: fork` skill:

- [ ] Does skill run in isolation? (yes, that's the point)
- [ ] Does skill include `<philosophy_bundle>` section?
- [ ] Does bundle contain critical behavioral rules?
- [ ] Would skill work correctly in a project with ZERO .claude/rules?
- [ ] Are rules focused on behavior, not style?

**If any answer is "no"**: The skill is NOT ready for `context: fork` deployment.

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

| Situation                  | Pattern                               |
| -------------------------- | ------------------------------------- |
| Creating basic skill       | Use only `name` + `description`       |
| Skill triggers incorrectly | Improve description specificity       |
| Skill needs isolation      | Add `context: fork`                   |
| Dangerous operation        | Add `disable-model-invocation: true`  |
| Too many tokens consumed   | Add `model: haiku` or fork            |
| Skill should be read-only  | Add `allowed-tools: Read, Grep, Glob` |
| Need live git/env data     | Use `!`command"` injection            |

---

## See Also

- [orchestration-patterns.md](orchestration-patterns.md) - Hub-and-spoke, multi-skill workflows
- [anti-patterns.md](anti-patterns.md) - Common mistakes to avoid
