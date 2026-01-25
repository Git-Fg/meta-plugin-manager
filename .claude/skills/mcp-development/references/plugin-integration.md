# Plugin MCP Integration

Complete guide for bundling MCP servers with Claude Code plugins.

---

## Overview

Plugins can bundle MCP servers for automatic tool and service integration. When a plugin is enabled, its MCP servers start automatically and tools become available.

**Benefits:**
- Bundled distribution: Tools and servers packaged together
- Automatic setup: No manual MCP configuration needed
- Team consistency: Everyone gets the same tools
- ${CLAUDE_PLUGIN_ROOT}: Portable paths across installations

---

## Configuration Methods

### Method 1: Dedicated .mcp.json (Recommended)

Create `.mcp.json` at plugin root:

```json
{
  "database-tools": {
    "command": "${CLAUDE_PLUGIN_ROOT}/servers/db-server",
    "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
    "env": {
      "DB_URL": "${DB_URL}"
    }
  }
}
```

**Benefits:**
- Clear separation of concerns
- Easier to maintain
- Better for multiple servers
- Standard MCP configuration format

### Method 2: Inline in plugin.json

Add `mcpServers` field to `plugin.json`:

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "mcpServers": {
    "plugin-api": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/api-server",
      "args": ["--port", "8080"]
    }
  }
}
```

**Benefits:**
- Single configuration file
- Good for simple single-server plugins
- Tighter coupling with plugin metadata

---

## Plugin Directory Structure

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json          # Plugin metadata
├── .mcp.json                # MCP server config (recommended)
├── servers/                 # MCP server implementations
│   ├── api-server
│   ├── db-server
│   └── config.json
└── skills/                  # Plugin skills
    └── my-skill/
```

**Alternative (inline):**

```
my-plugin/
├── .claude-plugin/
│   └── plugin.json          # Includes mcpServers
├── servers/                 # MCP server implementations
│   └── api-server
└── skills/                  # Plugin skills
    └── my-skill/
```

---

## Environment Variables

### ${CLAUDE_PLUGIN_ROOT}

**Purpose:** Plugin directory path for portable references.

**Usage:**
```json
{
  "command": "${CLAUDE_PLUGIN_ROOT}/servers/my-server",
  "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
  "env": {
    "PLUGIN_DIR": "${CLAUDE_PLUGIN_ROOT}"
  }
}
```

**Benefits:**
- Portable across installations
- Works in any directory
- No absolute paths needed

### User Environment Variables

Plugins access user's environment variables:

```json
{
  "env": {
    "API_KEY": "${API_KEY}",
    "DATABASE_URL": "${DATABASE_URL}",
    "LOG_LEVEL": "debug"
  }
}
```

**Documentation:** Always document required environment variables in README:

```markdown
## Environment Variables

Set these before using the plugin:

```bash
export API_KEY="your-api-key"
export DATABASE_URL="postgresql://localhost/mydb"
```
```

---

## Tool Naming

### Format

Plugin MCP tools are prefixed with:

```
mcp__plugin_<plugin-name>_<server-name>__<tool-name>
```

### Examples

**Plugin:** `asana`, **Server:** `asana`, **Tool:** `create_task`

```
Full name: mcp__plugin_asana_asana__asana_create_task
```

**Plugin:** `my-plugin`, **Server:** `api`, **Tool:** `search`

```
Full name: mcp__plugin_my-plugin_api__search
```

### Discovering Tool Names

Use `/mcp` within Claude Code to see all available tools and their full names.

---

## Using MCP Tools in Commands

### Pre-Allowing Tools

Specify MCP tools in command frontmatter:

```markdown
---
allowed-tools: [
  "mcp__plugin_asana_asana__asana_create_task",
  "mcp__plugin_asana_asana__asana_search_tasks"
]
---
```

### Multiple Tools

```markdown
---
allowed-tools: [
  "mcp__plugin_asana_asana__asana_create_task",
  "mcp__plugin_asana_asana__asana_search_tasks",
  "mcp__plugin_asana_asana__asana_get_project"
]
---
```

### Wildcard (Use Sparingly)

```markdown
---
allowed-tools: ["mcp__plugin_asana_asana__*"]
---
```

**Caution:** Only use wildcards if the command truly needs access to all tools from a server.

### Example Command

```markdown
---
description: Create Asana tasks
allowed-tools: [
  "mcp__plugin_asana_asana__asana_create_task"
]
---

# Create Task

1. Gather task details from user
2. Use mcp__plugin_asana_asana__asana_create_task
3. Confirm creation
```

---

## Plugin MCP Lifecycle

### Startup

1. Plugin loaded
2. MCP configuration parsed (.mcp.json or plugin.json)
3. Server process started (stdio) or connection established (HTTP)
4. Tools discovered and registered
5. Tools available with `mcp__plugin_...__...` prefix

### Runtime

- Tools available during plugin session
- Pre-allowed tools work without permission prompts
- Changes require Claude Code restart

### Shutdown

- Server process terminated
- Connections closed
- Tools unregistered

---

## Configuration Examples

### HTTP Server with OAuth

```json
{
  "github": {
    "type": "http",
    "url": "https://api.githubcopilot.com/mcp/"
  }
}
```

**Note:** OAuth handled automatically by Claude Code.

### stdio Server with Environment

```json
{
  "database": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-postgres", "${DATABASE_URL}"],
    "env": {
      "DATABASE_URL": "${DATABASE_URL}",
      "LOG_LEVEL": "info"
    }
  }
}
```

### Custom Server

```json
{
  "api-tools": {
    "command": "${CLAUDE_PLUGIN_ROOT}/servers/api-server",
    "args": [
      "--config", "${CLAUDE_PLUGIN_ROOT}/config.json",
      "--verbose"
    ],
    "env": {
      "API_KEY": "${API_KEY}",
      "API_ENDPOINT": "${API_ENDPOINT:-https://api.example.com}"
    }
  }
}
```

### Multiple Servers

```json
{
  "github": {
    "type": "http",
    "url": "https://api.githubcopilot.com/mcp/"
  },
  "filesystem": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-filesystem", "${CLAUDE_PLUGIN_ROOT}/data"]
  },
  "database": {
    "command": "python",
    "args": ["-m", "mcp_server_db"],
    "env": {
      "DATABASE_URL": "${DATABASE_URL}"
    }
  }
}
```

---

## Integration Patterns

### Pattern 1: Simple Tool Wrapper

Commands use MCP tools with user interaction:

```markdown
# Command: create-item.md
---
allowed-tools: ["mcp__plugin_name_server__create_item"]
---

Steps:
1. Gather item details from user
2. Use mcp__plugin_name_server__create_item
3. Confirm creation
```

### Pattern 2: Autonomous Agent

Agents use MCP tools autonomously (no pre-approval needed):

```markdown
# Agent: data-analyzer.md

Process:
1. Query data via mcp__plugin_db_server__query
2. Analyze results
3. Generate report
```

### Pattern 3: Multi-Server Plugin

Integrate multiple MCP servers:

```json
{
  "github": {"type": "http", "url": "https://api.githubcopilot.com/mcp/"},
  "jira": {"type": "http", "url": "https://mcp.jira.com/mcp"}
}
```

---

## Best Practices

### DO

✅ Use ${CLAUDE_PLUGIN_ROOT} for portable paths

```json
{
  "command": "${CLAUDE_PLUGIN_ROOT}/servers/server"
}
```

✅ Document required environment variables

✅ Use HTTPS for HTTP servers

✅ Test MCP servers before publishing

✅ Pre-allow specific tools in commands

✅ Handle errors gracefully

### DON'T

❌ Hardcode absolute paths

```json
{
  "command": "/Users/username/servers/server"  // NO!
}
```

❌ Commit credentials to git

❌ Use HTTP instead of HTTPS

❌ Pre-allow all tools with wildcards

❌ Skip error handling

❌ Forget to document setup

---

## Testing Plugin MCP

### Local Testing

1. **Install plugin locally** (`.claude-plugin/`)
2. **Enable plugin**
3. **Run `/mcp`** to verify servers appear
4. **Test tool calls** in commands
5. **Check `claude --debug`** logs for issues

### Validation Checklist

- [ ] MCP configuration is valid JSON
- [ ] Server URL/command is correct
- [ ] Required environment variables documented
- [ ] Tools appear in `/mcp` output
- [ ] Authentication works (OAuth or tokens)
- [ ] Tool calls succeed from commands
- [ ] Error cases handled gracefully

### Debugging

**Server not connecting:**
- Check URL/command is correct
- Verify server is executable (stdio)
- Review `claude --debug` logs
- Test server independently

**Tools not available:**
- Verify server connected successfully
- Check tool names match exactly
- Run `/mcp` to see available tools
- Restart Claude Code after config changes

---

## Example Plugin

### Directory Structure

```
asana-plugin/
├── .claude-plugin/
│   └── plugin.json
├── .mcp.json
├── README.md
├── skills/
│   └── task-manager/
│       └── SKILL.md
└── commands/
    ├── create-task.md
    └── list-tasks.md
```

### .claude-plugin/plugin.json

```json
{
  "name": "asana",
  "version": "1.0.0",
  "description": "Asana integration for Claude Code",
  "author": "Your Name"
}
```

### .mcp.json

```json
{
  "asana": {
    "type": "http",
    "url": "https://mcp.asana.com/mcp"
  }
}
```

### commands/create-task.md

```markdown
---
description: Create Asana task
allowed-tools: ["mcp__plugin_asana_asana__asana_create_task"]
---

# Create Task

1. Ask user for task details (title, description, assignee)
2. Use mcp__plugin_asana_asana__asana_create_task
3. Display confirmation with task link
```

### README.md

```markdown
# Asana Plugin

Integrate Claude Code with Asana for task management.

## Setup

1. Enable the plugin
2. Use `/mcp` to authenticate with Asana
3. Create tasks with `/create-task` command

## Environment Variables

None required - uses OAuth authentication.

## Usage

- `/create-task` - Create a new Asana task
- `/list-tasks` - List your assigned tasks
```

---

## Additional Resources

- **[SKILL.md](../SKILL.md)** - MCP development overview
- **[references/transports.md](transports.md)** - HTTP and stdio transports
- **[references/authentication.md](authentication.md)** - OAuth, tokens, env vars
- **[references/primitives.md](primitives.md)** - Tools, Resources, Prompts
- **[Plugin Docs](https://code.claude.com/docs/en/plugins)** - Plugin development guide
