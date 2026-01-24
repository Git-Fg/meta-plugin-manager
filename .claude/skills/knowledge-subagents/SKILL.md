---
name: knowledge-subagents
description: "Reference knowledge for subagents: agent types, frontmatter fields, context detection, coordination patterns. Use when understanding agents. No execution logic."
user-invocable: false
---

# Knowledge: Subagents

Reference knowledge for Claude Code subagents. Pure knowledge without execution logic.

## Quick Reference

**Official Subagents Docs**: https://code.claude.com/docs/en/sub-agents
**Plugin Architecture**: https://code.claude.com/docs/en/plugins

### Agent Types

| Type | Tools | Purpose | Use When |
|------|-------|---------|----------|
| **general-purpose** | All tools | Default, full capability | Most tasks |
| **bash** | Bash only | Command execution specialist | Shell workflows |
| **explore** | All except Task | Fast exploration | Quick navigation |
| **plan** | All except Task | Architecture design | Complex decisions |

## Context Types

| Context | Location | Scope | Use When |
|---------|----------|-------|----------|
| **Plugin** | `plugin/agents/` | Where plugin is enabled | Shared capabilities |
| **Project** | `.claude/agents/` | Current project only | Project-specific workflows |
| **User** | `~/.claude/agents/` | All projects on machine | Personal automation |

## Valid Frontmatter Fields

### Required Fields

```yaml
---
name: agent-name              # Required, unique identifier
description: Purpose          # Required, when to delegate
---
```

### Optional Fields

```yaml
tools:                        # Tool allowlist
  - Bash
  - Read
disallowedTools:              # Tool denylist
  - Write
  - Edit
model: sonnet                 # Model selection
permissionMode: default       # Permission handling
skills:                       # Inject skill content
  - skill-name
hooks:                        # Lifecycle hooks
  PostToolUse:
    - matcher: ...
```

### Invalid Fields (Don't Use)

- ❌ `context: fork` - This is for **skills**, not subagents
- ❌ `agent: Explore` - This field doesn't exist
- ❌ `user-invocable` - Subagents aren't user-invocable
- ❌ `disable-model-invocation` - Not a subagent field

## Model Selection

| Model | Use Case | Cost Factor | When to Specify |
|-------|----------|-------------|-----------------|
| **haiku** | Fast, straightforward tasks | 1x (baseline) | Simple analysis |
| **sonnet** | Default | 3x haiku | Most cases |
| **opus** | Complex reasoning | 10x haiku | Architecture design |

**Guidance**:
- Default to sonnet (inherited from parent)
- Use haiku for: Simple grep, basic file operations
- Use opus for: Architecture design, complex refactoring

## Tool Restrictions

### Allowlist (tools)

```yaml
---
name: read-only-agent
tools:
  - Read
  - Grep
  - Glob
---
```

### Denylist (disallowedTools)

```yaml
---
name: safe-agent
disallowedTools:
  - Write
  - Edit
  - Bash
---
```

## Context Detection

Automatic detection logic:

```python
if exists(".claude-plugin/plugin.json") or exists("plugin/agents/"):
    return "plugin"
elif exists(".claude/agents/"):
    return "project"
elif exists("~/.claude/agents/"):
    return "user"
else:
    return "undetermined"
```

## Coordination Patterns

### Pattern: Hub Skill → Subagent

Hub skill delegates to subagent with clear expectations:

```yaml
# Hub Skill
---
name: workflow-orchestrator
---

Call: toolkit-worker (subagent)
Input: [What to analyze]
Wait for: "## Analysis Report" marker
Extract: Quality score, findings, recommendations

# Continue workflow with results
```

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

## Quality Framework

### Scoring System (0-100 points)

| Dimension | Points | Focus |
|-----------|--------|-------|
| **1. Configuration Validity** | 20 | Valid YAML, required fields |
| **2. Frontmatter Correctness** | 15 | Valid fields only |
| **3. Context Appropriateness** | 15 | Correct directory |
| **4. Tool Restrictions** | 15 | Appropriate allow/deny |
| **5. Skills Integration** | 15 | Proper skill injection |
| **6. Documentation Quality** | 20 | Clear description |

### Quality Thresholds

- **A (90-100)**: Exemplary configuration
- **B (75-89)**: Good configuration with minor gaps
- **C (60-74)**: Adequate configuration, needs improvement
- **D (40-59)**: Poor configuration, significant issues
- **F (0-39)**: Failing configuration, critical errors

## Reference Files

Load these as needed for comprehensive guidance:

| File | Content | When to Read |
|------|---------|--------------|
| [configuration-guide.md](references/configuration-guide.md) | Valid frontmatter fields | Creating agents |
| [context-detection.md](references/context-detection.md) | Project vs plugin vs user | Choosing location |
| [coordination-patterns.md](references/coordination-patterns.md) | Multi-agent workflows | Coordinating agents |
| [coordination.md](references/coordination.md) | Agent coordination patterns | Complex workflows |
| [validation-framework.md](references/validation-framework.md) | 6-dimensional quality scoring | Validating agents |
| [when-to-use.md](references/when-to-use.md) | Guidelines for agent usage | Deciding to use agents |

## Common Patterns

### Project-Level Subagent

**Location**: `.claude/agents/<name>.md`

**Use When**: Project-specific workflow automation

```yaml
---
name: deploy-agent
description: "Automates deployment workflow for this project"
model: haiku
tools:
  - Bash
  - Read
permissionMode: default
---
```

### Plugin-Level Subagent

**Location**: `<plugin>/agents/<name>.md`

**Use When**: Shared across multiple projects

```yaml
---
name: code-review-agent
description: "Reviews code changes for quality"
model: sonnet
disallowedTools:
  - Write
  - Edit
hooks:
  PostToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./scripts/log-review.sh"
---
```

## Usage Pattern

```bash
# Load knowledge for understanding
Skill("knowledge-subagents")

# Then use factory for execution
Skill("create-subagent", args="name=my-agent description='Specialized task'")
```

## Knowledge Only

This skill contains NO execution logic. For creating agents, use the create-subagent factory skill.
