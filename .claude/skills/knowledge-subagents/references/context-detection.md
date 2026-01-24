# Context Detection Guide

Automatically detect and route to appropriate subagent directories based on project structure.

---

## Context Types

### 1. Project-Level Context
**Location**: `${CLAUDE_PROJECT_DIR}/.claude/agents/`
**Detection**: `.claude/agents/` exists
**Use Case**: Project-specific automation
**Example**: `/.claude/agents/deploy-agent.md`

### 2. Plugin-Level Context
**Location**: `<plugin>/agents/`
**Detection**: `.claude-plugin/plugin.json` or `plugin/agents/` exists
**Use Case**: Shared across multiple projects
**Example**: `my-plugin/agents/code-review-agent.md`

### 3. User-Level Context
**Location**: `~/.claude/agents/`
**Detection**: Home directory agents exist
**Use Case**: Personal automation
**Example**: `~/.claude/agents/personal-assistant.md`

## Detection Logic

```python
def detect_context(project_state):
    if exists(".claude-plugin/plugin.json"):
        return "plugin"
    elif exists(".claude/agents/"):
        return "project"
    elif exists("~/.claude/agents/"):
        return "user"
    else:
        return "undetermined"
```

## Routing Guidelines

**"Need agent for THIS project"** → Project context
**"Need agent for MULTIPLE projects"** → Plugin context
**"Need personal agent"** → User context

See also: coordination-patterns.md, validation-framework.md
