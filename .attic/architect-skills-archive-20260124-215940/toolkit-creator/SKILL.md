---
name: toolkit-creator
description: "Create new project capabilities (skills, MCP servers, hooks, subagents). Use when you need to ADD functionality. Defaults to standard templates. Focused on getting to 'Hello World' fast."
user-invocable: true
---

# Toolkit Creator

## Core Purpose
**Create NEW capabilities** (Skills, MCP Servers, Hooks, Subagents) with intelligent defaults. This skill consolidates creation logic for all toolkit components.

## Capabilities

### 1. Create Skill
**Trigger**: "Create a skill for...", "New skill..."
**Action**: Create `.claude/skills/<name>/SKILL.md`.

**Standard Template**:
```yaml
---
name: <kebab-case-name>
description: "<Action> <Object>. Use when <Trigger>. Do not use for <Anti-Trigger>."
user-invocable: true
---

# <Human Readable Name>

## Core Purpose
[Brief description of what this skill achieves]

## Capabilities
[List of functions/actions this skill performs]

## Examples
[1-2 concrete examples]
```

**Key Defaults**:
- Directories: `.claude/skills/<name>/`
- Context: Default (no fork unless requested)
- Visibility: `user-invocable: true`

### 2. Create MCP Server
**Trigger**: "Add MCP server...", "Integrate <tool>..."
**Action**: Update `.mcp.json`.

**Standard Process**:
1.  **Check**: Does `.mcp.json` exist? If not, create `{ "mcpServers": {} }`.
2.  **Configure**: Create server entry.
3.  **Merge**: Add to `mcpServers` object (NEVER overwrite).

**Template**:
```json
"<server-name>": {
  "command": "<executable>",
  "args": ["<arg1>"],
  "disabled": false,
  "autoApprove": []
}
```

### 3. Create Hook
**Trigger**: "Add a hook...", "Guard execution..."
**Action**: Update `.claude/settings.json` (or component frontmatter).

**Standard Process**:
1.  **Check**: Does `.claude/settings.json` exist?
2.  **Configure**: Add to `hooks` object.
3.  **Script**: If type is `command`, scaffold the script in `.claude/scripts/`.

**Template (settings.json)**:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "<ToolName>",
        "hooks": [
          {
            "type": "command",
            "command": "./.claude/scripts/<script-name>.sh"
          }
        ]
      }
    ]
  }
}
```

### 4. Create Subagent
**Trigger**: "Create a subagent...", "New agent..."
**Action**: Create `.claude/agents/<name>.md`.

**Standard Template**:
```markdown
---
name: <Agent Name>
description: <Purpose>
type: <general|planner|critic>
model: <claude-3-5-sonnet-latest>
---

# <Agent Name> System Prompt

Your role is...
```

## Universal Rules
1.  **Defaults First**: Don't ask for configuration if a sensible default exists.
2.  **Project Autonomy**: Always target `.claude/` in the *current* project root.
3.  **Self-Correction**: If a directory is missing, create it (`mkdir -p`).
4.  **No Overwrite**: If file exists, ask before overwriting (unless explicitly "force").

## Workflow
1.  **Identify Artifact**: Skill, MCP, Hook, or Subagent?
2.  **Scaffold**: Generate the file content.
3.  **Write**: Save to disk.
4.  **Register**: Update any necessary manifests (e.g., `.mcp.json`).
5.  **Report**: Output `## TOOLKIT_CREATOR_COMPLETE` with path of created artifact.
