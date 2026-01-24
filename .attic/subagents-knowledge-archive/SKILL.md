---
name: subagents-knowledge
context: fork
description: "Complete guide to subagents for project-scoped workers in Claude Code. Use when creating .claude/agents/*.md files or configuring subagent frontmatter. Do not use for standalone plugin agent development."
user-invocable: true
---

# Subagents Knowledge Base

## WIN CONDITION

**Called by**: subagents-architect
**Purpose**: Provide implementation guidance for subagent development

**Output**: Must output completion marker after providing guidance

```markdown
## SUBAGENTS_KNOWLEDGE_COMPLETE

Guidance: [Implementation patterns provided]
References: [List of reference files]
Recommendations: [List]
```

**Completion Marker**: `## SUBAGENTS_KNOWLEDGE_COMPLETE`

Complete subagents knowledge base for project-scoped Claude Code workers. Access comprehensive guidance on when to use subagents, how to create `.claude/agents/*.md` files, and coordinate multiple subagents effectively.

## RECOMMENDED: Context Validation

Read these URLs when accuracy matters for subagent development work:

### Primary Documentation
- **Official Subagents Guide**: https://code.claude.com/docs/en/sub-agents
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Agent coordination, state management, autonomy requirements

- **Task Tool Documentation**: https://code.claude.com/docs/en/cli-reference
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Task tool usage, subagent types, invocation patterns

### When to Fetch vs Skip
**Fetch when**:
- Documentation may have changed since last read
- User requests verification of subagent patterns
- Starting new subagent creation or audit
- Uncertain about cost implications or best practices

**Skip when**:
- Simple subagent configuration based on known patterns
- Local-only work without external dependencies
- Working offline
- Recently read and documentation is stable

**Trust your judgment**: You know when validation is needed for accurate subagent work.

## Progressive Disclosure Knowledge Base

This skill provides complete subagents knowledge through progressive disclosure:

### Tier 1: Quick Overview
This SKILL.md provides the decision framework and quick reference.

### Tier 2: Comprehensive Guides
Load full guides on demand:
- **[when-to-use.md](references/when-to-use.md)** - Decision guide for when to use subagents
- **[coordination.md](references/coordination.md)** - Coordination patterns and state management

### Tier 3: Deep Reference
Individual reference files provide complete implementation details.

## Quick Start

### New to Subagents?
Start with **[when-to-use.md](references/when-to-use.md)** to determine if subagents are right for your use case.

### Coordinating Multiple Subagents?
See **[coordination.md](references/coordination.md)** for coordination patterns and state management strategies.

## Subagent Types Quick Reference

| Agent Type | Purpose | When to Use |
| ---------- | ------- | ----------- |
| **Explore** | Fast codebase exploration | File searches, pattern discovery, code analysis |
| **Plan** | Architecture planning | Implementation strategy, breaking down tasks |
| **General-Purpose** | Full capabilities | Complex workflows, research + execution |
| **Bash** | Command execution | Git operations, terminal tasks |

## Agent Type Selection

Four agent types with specialized capabilities and different tool access:

### general-purpose (Default)
- **Tools**: All tools available
- **Use When**: Full capability needed, no specialization required
- **Performance**: Balanced for most tasks
- **Cost**: Inherits parent model (sonnet by default)

### bash
- **Tools**: Bash only
- **Use When**: Pure command execution, no file operations needed
- **Performance**: Optimized for shell workflows
- **Cost**: Lower overhead for command-focused tasks

### explore
- **Tools**: All tools except Task
- **Use When**: Fast codebase exploration, no nested TaskList needed
- **Performance**: Optimized for quick navigation
- **Constraint**: Cannot spawn additional TaskList workflows

### plan
- **Tools**: All tools except Task
- **Use When**: Software architecture design, complex decision-making
- **Performance**: Optimized for reasoning workflows
- **Constraint**: Cannot spawn additional TaskList workflows

## Agent Selection Decision Tree

```
Need command execution only?
└─ Yes → bash agent
└─ No
   └─ Need architecture design?
      └─ Yes → plan agent
      └─ No
         └─ Fast exploration without TaskList?
            └─ Yes → explore agent
            └─ No → general-purpose agent
```

## Model Selection for Subagents

Explicit model selection affects cost and performance:

| Model | Use Case | When to Specify | Cost Factor |
|-------|----------|-----------------|-------------|
| **haiku** | Fast, straightforward tasks | Simple analysis, quick operations | 1x (baseline) |
| **sonnet** | Default | Balanced performance, most cases | 3x haiku |
| **opus** | Complex reasoning | Architecture design, complex decisions | 10x haiku |

**Guidance**:
- Default to sonnet (inherited from parent)
- Use haiku for: Simple grep, basic file operations, quick validation
- Use opus for: Architecture design, complex refactoring, multi-stage planning

**Cost Optimization Strategy**:
1. Start with haiku for simple exploration
2. Escalate to sonnet for standard workflows
3. Use opus only when complex reasoning is critical

**See task-knowledge for detailed patterns**:
- [agent-types.md](task-knowledge/references/agent-types.md) - Complete agent type guide
- [model-selection.md](task-knowledge/references/model-selection.md) - Cost optimization strategies

## Context: Fork - Use Sparingly

**⚠️ WARNING**: Forked skills **lose global context**. This has **huge side effects**.

### When Forking is DANGEROUS

**DON'T FORK if you need**:
- Conversation history
- User preferences
- Project-specific decisions
- Previous workflow steps
- Main context decisions

**Example of Dangerous Fork**:
```yaml
# ❌ BAD - Makes decisions based on context
---
name: workflow-decider
description: "Makes workflow decisions based on project state"
context: fork  # LOSES PROJECT CONTEXT!
---

# This will fail - no access to main conversation context!
```

### When Forking is SAFE

**Fork ONLY if**:
- Isolated analysis work (no context needed)
- Noisy operations (want isolation from main conversation)
- Clear, self-contained tasks

**Example of Safe Fork**:
```yaml
# ✅ GOOD - Isolated analysis
---
name: log-analyzer
description: "Analyzes log files for patterns"
context: fork
agent: Explore
---

# WIN CONDITION:
## LOG_ANALYSIS_COMPLETE

{"patterns": [...], "anomalies": [...]}

# No context needed - just analyze files
```

### When to Consider Forking

Use `context: fork` **only when**:
- High-volume output would clutter main conversation
- Isolated analysis (no context dependency)
- Noisy operations (file scanning, pattern matching)
- Clear, bounded task with defined output

**Default**: Don't fork. Use regular context unless isolation is essential.

## Cost Considerations (2026)

### Budget Targets
- **Target**: <$50 per 5-hour session
- **Warning**: >$75 per 5-hour session
- **Critical**: >$100 per 5-hour session

### Optimization Strategies
1. Use native tools when possible
2. Limit parallel subagent spawns
3. Keep tasks focused and specific
4. Use context: fork judiciously

## Layer Selection Decision

```
Need specialized autonomous workers?
├─ Yes → Use subagents
│  ├─ Decision guide → [when-to-use.md](references/when-to-use.md)
│  └─ Coordination patterns → [coordination.md](references/coordination.md)
└─ No → Use skills or native tools
```

## Key Principles

### Use Subagents When
- Complex multi-step tasks requiring focus
- Need isolation from main conversation
- High-volume output (extensive grep, repo traversal)

## Project-Scoped Subagent Configuration

**Target Directory**: `${CLAUDE_PROJECT_DIR}/.claude/agents/`

**Two Approaches**:

### 1. Reusable Agent File (`.claude/agents/<name>.md`)
Use for specialized workers used across multiple skills:
```markdown
---
name: my-agent
description: "Does something specific"
tools:
  - Read
  - Grep
skills:
  - skills-knowledge
---
# My Agent

Agent instructions here...
```

### Valid Subagent Frontmatter Fields

| Field | Required | Description |
|-------|----------|-------------|
| `name` | ✅ | Unique identifier (lowercase, hyphens) |
| `description` | ✅ | When Claude should delegate to this subagent |
| `tools` | ❌ | Allowlist of tools (inherits all if omitted) |
| `disallowedTools` | ❌ | Denylist of tools |
| `model` | ❌ | sonnet, opus, haiku, or inherit |
| `permissionMode` | ❌ | default, acceptEdits, dontAsk, bypassPermissions, plan |
| `skills` | ❌ | Inject skill content at startup |
| `hooks` | ❌ | Lifecycle hooks scoped to this subagent |

### Common Configuration Examples

**Read-only analysis agent:**
```yaml
---
name: code-analyzer
description: "Analyze code patterns and suggest improvements"
tools:
  - Read
  - Grep
  - Glob
  - Bash
---
```

**Full-capabilities agent:**
```yaml
---
name: full-worker
description: "Complete workflow automation"
skills:
  - skills-knowledge
  - toolkit-quality-validator
tools: []  # Inherits all tools
---
```

**Agent with skill preloading:**
```yaml
---
name: domain-expert
description: "Domain-specific analysis with toolkit knowledge"
skills:
  - skills-knowledge
  - toolkit-architect
---
```

### 2. Plugin-Level Subagent
**Location**: `<plugin>/agents/<name>.md`
**Scope**: Shared across projects where plugin is enabled

### 3. User-Level Subagent
**Location**: `~/.claude/agents/<name>.md`
**Scope**: Available in all projects on the machine

### Don't Use Subagents For
- Simple file operations (use Read, Grep, Glob)
- Direct file reads (use Read tool)
- Basic searches (use Grep, Glob)
- Single-step operations
- Tasks requiring conversation context
- User interaction workflows
- Quick lookups

## Common Configuration Mistakes

### ❌ Wrong: Confusing Skills with Subagents

**Incorrect** (using skill fields on subagents):
```yaml
---
name: my-agent
description: "Does X"
context: fork      # ❌ WRONG - for skills, not subagents
agent: Explore     # ❌ WRONG - this field doesn't exist
user-invocable: true  # ❌ WRONG - subagents aren't skills
---
```

**Correct** (using proper subagent fields):
```yaml
---
name: my-agent
description: "Does X"
tools:
  - Read
  - Grep
---
```

### ⚠️ Important Distinction

- **Skills** use: `context: fork`, `agent:`, `disable-model-invocation`
- **Subagents** use: `name`, `description`, `tools`, `skills`, `hooks`

Subagents ARE forked contexts by definition - no need to specify `context: fork`.

### When to Use Skills with `context: fork`

**⚠️ DANGER**: Forked skills **lose all global context**.

**Skills can delegate TO subagents using `context: fork`**:

```yaml
---
name: delegator
description: "Delegates to a subagent for noisy work"
context: fork
agent: Explore
---

# WIN CONDITION: Must output completion marker
## DELEGATION_COMPLETE

[Results from subagent work]
```

**Use ONLY when**:
- ✅ Task is isolated (no context dependency)
- ✅ High-volume output would clutter main conversation
- ✅ Subagent work is self-contained

**DON'T use when**:
- ❌ Need conversation history
- ❌ Need user preferences
- ❌ Need project context
- ❌ Need previous workflow steps

**Default**: Don't fork. Isolation has huge side effects.

## Next Steps

Choose your path:

1. **[Determine if subagents are needed](references/when-to-use.md)** - Decision framework
2. **[Coordinate multiple subagents](references/coordination.md)** - Patterns and state management
3. **Review layer selection** - Consider if skills would be more appropriate

## When Skills Call Subagents

### Pattern: Hub Skill → Subagent

**When a skill delegates to a subagent**:

```yaml
# Hub Skill
---
name: workflow-orchestrator
description: "Orchestrates multi-step analysis"
---

# Delegate to subagent
Call: toolkit-worker (subagent)
Input: [What to analyze]
Wait for: "## .claude/ Analysis Report" marker
Extract: Quality score, findings, recommendations

# Continue workflow with results
Based on results:
  If score < 8.0: Recommend improvements
  Else: Report success
```

### Transitive Subagents Need Win Conditions

**If a subagent is called by other skills** (transitive):

```yaml
# Transitive Subagent
---
name: file-scanner
description: "Scans files for patterns"
tools:
  - Read
  - Grep
---

# WIN CONDITION: Must output completion marker
## FILE_SCAN_COMPLETE

{"patterns": [...], "count": X}

# Hub waits for this marker before continuing
```

### Subagents ARE Forked Contexts

**Important**: Subagents already run in forked contexts by definition.

- ✅ Subagent has isolated context
- ✅ No need to specify `context: fork` for subagents
- ✅ Skills use `context: fork` to spawn subagents
- ✅ Results must be structured for clean handoff

### Multi-Subagent Workflows

```yaml
# Hub Skill
---
name: multi-agent-workflow
---

# Parallel execution possible
Call: subagent-1 (isolated)
Call: subagent-2 (isolated)

Wait for both completion markers
Aggregate results
Make decision
```
