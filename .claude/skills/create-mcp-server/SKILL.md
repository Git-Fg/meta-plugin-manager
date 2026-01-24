---
name: create-mcp-server
description: "Register MCP servers in .mcp.json with safe merge. Use when adding external APIs via MCP. Arguments: name, transport, command, args."
user-invocable: true
---

# Create MCP Server

Adds MCP server configuration to .mcp.json with safe merge strategy.

## Usage

```bash
Skill("create-mcp-server", args="name=my-server transport=stdio command=node args='dist/server.js'")
```

### Arguments

| Argument | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `name` | string | Yes | - | Server name (kebab-case) |
| `transport` | string | Yes | - | Transport type: stdio or streamable-http |
| `command` | string | No* | - | Command to execute (for stdio) |
| `args` | string | No* | - | Command arguments (JSON array) |
| `url` | string | No* | - | Server URL (for streamable-http) |

*Required depending on transport type

## Transport Types

### stdio (Local Development)

```bash
Skill("create-mcp-server", args="name=my-server transport=stdio command=node args='dist/server.js'")
```

### streamable-http (Cloud/Production)

```bash
Skill("create-mcp-server", args="name=my-server transport=streamable-http url='https://api.example.com/mcp'")
```

## Output

Creates or updates `.mcp.json` with new server entry:
- Creates `.mcp.json` if doesn't exist
- Safely merges new server (never overwrites existing)
- Validates JSON structure

## Scripts

- **add_server.sh**: Add server to .mcp.json
- **validate_mcp.sh**: Validate MCP configuration
- **merge_config.py**: Safe JSON merge logic

## Completion Marker

## CREATE_MCP_SERVER_COMPLETE
