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

## Philosophy Foundation

MCP servers follow these core principles for secure external system integration.

### Progressive Disclosure for MCPs

MCPs use configuration disclosure (transport + primitives):

**Tier 1: Transport Configuration** (connection setup)
- **HTTP**: URL, headers, authentication
- **stdio**: Command, args, environment variables
- Purpose: Establish connection to external system

**Tier 2: Primitives Definition** (tools/resources/prompts)
- **Tools**: Actions Claude can execute
- **Resources**: Data Claude can read
- **Prompts**: Reusable prompt templates
- Purpose: Define Claude's capabilities with the external system

**Why configuration-focused?** MCPs are connectors. Configuration is the primary concern.

**Recognition**: "Does this MCP include complete transport and primitive definitions?"

### The Delta Standard for MCPs

> Good MCP = Transport/primitive knowledge − Generic connector concepts

Include in MCPs (Positive Delta):
- Transport-specific configuration (HTTP vs stdio)
- Authentication patterns (Bearer tokens, API keys)
- Tool definitions with schemas
- Resource URI patterns
- Error handling for the external system

Exclude from MCPs (Zero/Negative Delta):
- Generic "MCPs are connectors" explanations
- Obvious JSON structure
- General HTTP concepts
- Common authentication patterns (unless specific to the service)

**Recognition**: "Is this configuration specific to this external system?"

### Voice and Freedom for MCPs

**Voice**: Declarative configuration (not imperative)

MCPs use JSON configuration, not prompts:
- Define tools with schemas: `{"type": "object", "properties": {...}}`
- Specify transport parameters
- Set environment variables

**Freedom**: Low for security-critical configuration

| Freedom Level | When to Use | MCP Examples |
|---------------|-------------|--------------|
| **Medium** | Internal tools, dev environments | Local filesystem MCP, development database |
| **Low** | Production systems, external APIs | Cloud services, production databases, authentication required |

**Recognition**: "What's the security impact if this MCP is misconfigured?"

### Self-Containment for MCPs

**MCPs must work without external documentation.**

Never reference external files:
- ❌ "See API documentation for endpoint"
- ❌ "Check service docs for authentication"

Always include directly:
- ✅ Complete transport configuration
- ✅ All tool schemas
- ✅ Authentication requirements
- ✅ Error handling instructions

**Why**: MCP servers are self-contained connectors. External references create deployment failures.

**Recognition**: "Could someone configure this MCP without reading external documentation?"

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

## MCP Anti-Patterns

Recognition-based patterns to avoid when creating MCP servers.

### Anti-Pattern 1: Incomplete Transport Configuration

**❌ Missing critical connection details**

❌ Bad: HTTP MCP without URL or authentication
✅ Good: Complete HTTP config: `{"type": "http", "url": "https://api.example.com/mcp", "headers": {"Authorization": "Bearer ${API_TOKEN}"}}`

**Recognition**: "Does this MCP have everything needed to connect?"

**Why**: Incomplete configuration causes connection failures at runtime.

### Anti-Pattern 2: Missing Authentication

**❌ MCPs that access external systems without proper auth**

❌ Bad: Database MCP without credentials
✅ Good: Database MCP with: `{"env": {"DB_CONNECTION_STRING": "${DB_URL}"}}`

**Recognition**: "Does this MCP properly authenticate with the external system?"

**Why**: Unauthenticated MCPs create security vulnerabilities or connection failures.

### Anti-Pattern 3: Hardcoded Credentials

**❌ API keys or passwords embedded in configuration**

❌ Bad: `"headers": {"Authorization": "Bearer sk-1234567890"}`
✅ Good: `"headers": {"Authorization": "Bearer ${API_TOKEN}"}` (use environment variables)

**Recognition**: "Are credentials hardcoded or loaded from environment?"

**Why**: Hardcoded credentials commit secrets to version control.

### Anti-Pattern 4: Vague Tool Definitions

**❌ Tools without clear schemas or descriptions**

❌ Bad: `{"name": "query", "description": "Run a query"}`
✅ Good: `{"name": "query", "description": "Execute SQL query on database", "inputSchema": {"type": "object", "properties": {"sql": {"type": "string"}}}}`

**Recognition**: "Does each tool have a clear schema and description?"

**Why**: Vague definitions prevent Claude from using tools correctly.

### Anti-Pattern 5: External Dependencies

**❌ MCPs that reference external documentation for configuration**

❌ Bad: "See API docs for endpoint" or "Check service documentation"
✅ Good: Include complete configuration directly in .mcp.json

**Recognition**: "Could someone configure this MCP without external docs?"

**Why**: MCPs must be self-contained. External references create deployment friction.

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
