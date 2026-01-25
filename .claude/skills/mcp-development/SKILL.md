---
name: mcp-development
description: This skill should be used when the user asks to "add MCP server", "integrate MCP", "configure MCP", "build MCP tool", "use .mcp.json", mentions Model Context Protocol, or needs guidance on MCP transports (HTTP, stdio), primitives (tools/resources/prompts), plugin integration, or 2026 features (Tool Search, Resources, Prompts).
---

# MCP Development Guide

**Purpose**: Help you create Model Context Protocol servers that connect Claude to external systems

---

## What MCP Servers Are

MCP (Model Context Protocol) servers are connectors that give Claude access to external systems, databases, APIs, and data sources through standardized primitives.

**Key point**: Good MCP servers work independently and don't need external documentation to configure properly.

✅ Good: MCP server includes complete transport configuration with authentication
❌ Bad: MCP server references external documentation for configuration
Why good: MCP servers must self-configure without external dependencies

**Question**: Would this MCP server work if moved to a project with no rules? If no, include the necessary configuration directly.

---

## What Good MCP Servers Have

### 1. Complete Transport Configuration

**Good MCP servers define specific transport with all necessary details.**

Choose the right transport type:
- **HTTP** - For remote/cloud services
- **stdio** - For local processes

**HTTP Example**:
```json
{
  "mcpServers": {
    "service-name": {
      "type": "http",
      "url": "https://api.example.com/mcp",
      "headers": {
        "Authorization": "Bearer ${API_TOKEN}"
      }
    }
  }
}
```

**stdio Example**:
```json
{
  "mcpServers": {
    "local-server": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/allowed/path"],
      "env": {
        "LOG_LEVEL": "debug"
      }
    }
  }
}
```

✅ Good: Complete transport configuration with URL/command and auth
❌ Bad: Vague transport setup without specific details
Why good: Complete configuration enables reliable connection

### 2. Proper Authentication

**Good MCP servers include authentication patterns.**

For HTTP:
- Use HTTPS always
- Include Authorization headers
- Store tokens in environment variables

```json
{
  "type": "http",
  "url": "https://api.example.com/mcp",
  "headers": {
    "Authorization": "Bearer ${API_TOKEN}"
  }
}
```

For stdio:
- Use environment variables
- Set process-specific env vars

```json
{
  "command": "server",
  "env": {
    "API_TOKEN": "${API_TOKEN}"
  }
}
```

### 3. Defined Primitives

**Good MCP servers define specific primitives for integration.**

**Tools** - Callable functions:
```json
{
  "name": "get_weather",
  "description": "Get current weather for a location",
  "inputSchema": {
    "type": "object",
    "properties": {
      "location": {
        "type": "string",
        "description": "City name"
      }
    },
    "required": ["location"]
  }
}
```

**Resources** - Read-only data via @-mentions
**Prompts** - Reusable workflow templates

### 4. No External Dependencies

**Good MCP servers work in isolation.**

- Don't reference .claude/rules/ files
- Don't link to external documentation
- Include all configuration directly
- Bundle necessary patterns

✅ Good: Self-contained with all configuration included
❌ Bad: References external files for critical setup
Why good: Self-contained servers work anywhere

**Question**: Does this server assume external documentation? If yes, include that configuration directly.

---

## How to Structure MCP Servers

### Configuration Location

MCP servers configure in `.mcp.json` or `settings.json`:

```json
{
  "mcpServers": {
    "server-name": {
      "type": "http|stdio",
      "url|command": "[configuration]",
      "headers|env": "[auth configuration]"
    }
  }
}
```

### Transport Types

**HTTP Transport** - For remote services:
- Use for cloud APIs and remote services
- Include proper authentication
- Always use HTTPS

**stdio Transport** - For local processes:
- Use for local file system access
- Good for custom MCP servers
- Use environment variables for auth

### MCP Primitives

**Tools** - Callable functions with input validation
**Resources** - Read-only data via @-mentions
**Prompts** - Reusable workflow templates

**Question**: Which primitive matches your integration need? Choose the specific primitive for your use case.

---

## Common Patterns

### HTTP Transport for Remote APIs

Use HTTP for cloud services and remote APIs:

```json
{
  "mcpServers": {
    "remote-api": {
      "type": "http",
      "url": "https://api.example.com/mcp",
      "headers": {
        "Authorization": "Bearer ${API_TOKEN}"
      }
    }
  }
}
```

**Best practices**:
- Always use HTTPS
- Store tokens in environment variables
- Include proper headers

### stdio Transport for Local Servers

Use stdio for local file system and custom servers:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/allowed/path"],
      "env": {
        "LOG_LEVEL": "debug"
      }
    }
  }
}
```

**Best practices**:
- Use `${CLAUDE_PROJECT_DIR}` for portable paths
- Use `${CLAUDE_PLUGIN_ROOT}` for plugin distribution
- Log to stderr, not stdout

### Defining MCP Tools

Tools are callable functions with validation:

```json
{
  "name": "query_database",
  "description": "Query the database for records",
  "inputSchema": {
    "type": "object",
    "properties": {
      "table": {
        "type": "string",
        "description": "Table name to query"
      },
      "filter": {
        "type": "string",
        "description": "SQL WHERE clause"
      }
    },
    "required": ["table"]
  }
}
```

**Required fields**:
- `name` - Function identifier
- `description` - What it does
- `inputSchema` - Validation rules

---

## Common Mistakes

### Mistake 1: Incomplete Transport Configuration

❌ Bad:
```json
{
  "mcpServers": {
    "server": {
      "type": "http"
    }
  }
}
```

✅ Good:
```json
{
  "mcpServers": {
    "server": {
      "type": "http",
      "url": "https://api.example.com/mcp",
      "headers": {
        "Authorization": "Bearer ${API_TOKEN}"
      }
    }
  }
}
```

**Why**: Complete configuration enables reliable connection.

### Mistake 2: Missing Authentication

❌ Bad:
```json
{
  "type": "http",
  "url": "https://api.example.com/mcp"
}
```

✅ Good:
```json
{
  "type": "http",
  "url": "https://api.example.com/mcp",
  "headers": {
    "Authorization": "Bearer ${API_TOKEN}"
  }
}
```

**Why**: Authentication is required for secure access.

### Mistake 3: Hardcoded Credentials

❌ Bad:
```json
{
  "headers": {
    "Authorization": "Bearer abc123secret"
  }
}
```

✅ Good:
```json
{
  "headers": {
    "Authorization": "Bearer ${API_TOKEN}"
  }
}
```

**Why**: Environment variables keep credentials secure.

### Mistake 4: Vague Tool Definitions

❌ Bad:
```json
{
  "name": "tool",
  "description": "Does something"
}
```

✅ Good:
```json
{
  "name": "get_user_data",
  "description": "Get user profile information by ID",
  "inputSchema": {
    "type": "object",
    "properties": {
      "userId": {
        "type": "string",
        "description": "User ID to retrieve"
      }
    },
    "required": ["userId"]
  }
}
```

**Why**: Clear definitions enable proper validation.

---

## Quality Checklist

A good MCP server:

- [ ] Has complete transport configuration (HTTP or stdio)
- [ ] Includes proper authentication
- [ ] Uses environment variables for credentials
- [ ] Defines primitives clearly (Tools, Resources, Prompts)
- [ ] Works without external dependencies
- [ ] Has no references to .claude/rules/ files

**Self-check**: Could this server work in a fresh project? If not, it needs more configuration.

---

## Summary

MCP servers are connectors that give Claude access to external systems. Good servers:

- **Connect properly** - Complete transport configuration
- **Authenticate securely** - Use environment variables
- **Define clearly** - Specific primitives with validation
- **Work anywhere** - No external dependencies

Keep the focus on:
- Completeness over minimalism
- Security over convenience
- Clarity over complexity
- Self-contained over dependent

**Question**: Is your MCP server clear enough that it would configure correctly without external documentation?

---

**Final tip**: The best MCP server is one that connects reliably without requiring external setup. Focus on that.
