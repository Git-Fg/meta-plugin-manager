# MCP Transport Types

Complete reference for HTTP and stdio MCP server transports.

---

## HTTP Transport (Recommended for Remote)

### Overview

HTTP is the recommended transport for connecting to remote MCP servers. This is the most widely supported transport for cloud-based services and APIs.

### Configuration

**Basic:**
```json
{
  "mcpServers": {
    "notion": {
      "type": "http",
      "url": "https://mcp.notion.com/mcp"
    }
  }
}
```

**With Bearer token:**
```json
{
  "mcpServers": {
    "api": {
      "type": "http",
      "url": "https://api.example.com/mcp",
      "headers": {
        "Authorization": "Bearer ${API_TOKEN}"
      }
    }
  }
}
```

**With multiple headers:**
```json
{
  "mcpServers": {
    "service": {
      "type": "http",
      "url": "https://api.example.com/mcp",
      "headers": {
        "Authorization": "Bearer ${API_TOKEN}",
        "Content-Type": "application/json",
        "X-API-Version": "2024-01-01",
        "X-Custom-Header": "value"
      }
    }
  }
}
```

### Request/Response Flow

1. **Tool Discovery**: GET to discover available tools
2. **Tool Invocation**: POST with tool name and parameters
3. **Response**: JSON response with results or errors
4. **Stateless**: Each request independent

### Use Cases

- REST API backends
- Cloud services with OAuth
- Internal services
- Microservices
- Serverless functions
- SaaS integrations

### Best Practices

1. **Always use HTTPS**, never HTTP
2. **Store tokens in environment variables**
3. **Implement retry logic** for transient failures
4. **Handle rate limiting**
5. **Set appropriate timeouts**
6. **Use OAuth when service supports it**

### Troubleshooting

**HTTP errors:**
- 401: Check authentication headers
- 403: Verify permissions
- 429: Implement rate limiting
- 500: Check server logs

**Timeout issues:**
- Increase timeout if needed
- Check server performance
- Optimize tool implementations

**Connection failures:**
- Verify URL is correct and accessible
- Check HTTPS certificate is valid
- Review network connectivity
- Check firewall settings

### Comparison with SSE

**HTTP is preferred over SSE because:**
- Wider compatibility
- Simpler authentication (Bearer tokens)
- Better tool discovery
- More widely supported
- Actively maintained

**SSE is deprecated:** Use HTTP instead when available.

---

## stdio Transport (Local Processes)

### Overview

Execute local MCP servers as child processes with communication via stdin/stdout. Best choice for local tools, custom servers, and NPM packages.

### Configuration

**Basic:**
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/allowed/path"]
    }
  }
}
```

**With environment:**
```json
{
  "mcpServers": {
    "my-server": {
      "command": "${CLAUDE_PLUGIN_ROOT}/servers/custom-server",
      "args": ["--config", "${CLAUDE_PLUGIN_ROOT}/config.json"],
      "env": {
        "API_KEY": "${MY_API_KEY}",
        "LOG_LEVEL": "debug",
        "DATABASE_URL": "${DB_URL}"
      }
    }
  }
}
```

**Python server:**
```json
{
  "mcpServers": {
    "python-server": {
      "command": "python",
      "args": ["-m", "my_mcp_server"],
      "env": {
        "PYTHONUNBUFFERED": "1"
      }
    }
  }
}
```

### Process Lifecycle

1. **Startup**: Claude Code spawns process with `command` and `args`
2. **Communication**: JSON-RPC messages via stdin/stdout
3. **Lifecycle**: Process runs for entire Claude Code session
4. **Shutdown**: Process terminated when Claude Code exits

### Use Cases

**NPM Packages:**
```json
{
  "filesystem": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path"]
  }
}
```

**Custom Scripts:**
```json
{
  "custom": {
    "command": "${CLAUDE_PLUGIN_ROOT}/servers/my-server.js",
    "args": ["--verbose"]
  }
}
```

**Python Servers:**
```json
{
  "python-server": {
    "command": "python",
    "args": ["-m", "my_mcp_server"],
    "env": {
      "PYTHONUNBUFFERED": "1"
    }
  }
}
```

### Best Practices

1. **Use absolute paths or ${CLAUDE_PLUGIN_ROOT}**
2. **Set PYTHONUNBUFFERED for Python servers**
3. **Pass configuration via args or env, not stdin**
4. **Handle server crashes gracefully**
5. **Log to stderr, not stdout** (stdout is for MCP protocol)
6. **Use npx -y** for NPM packages to auto-confirm

### Troubleshooting

**Server won't start:**
- Check command exists and is executable
- Verify file paths are correct
- Check permissions
- Review `claude --debug` logs

**Communication fails:**
- Ensure server uses stdin/stdout correctly
- Check for stray print/console.log statements
- Verify JSON-RPC format
- Check for buffering issues (Python: set PYTHONUNBUFFERED)

---

## SSE Transport (Deprecated)

### Deprecation Notice

**SSE (Server-Sent Events) transport is deprecated.** Use HTTP transport instead.

### Migration

**Before (SSE):**
```json
{
  "asana": {
    "type": "sse",
    "url": "https://mcp.asana.com/sse"
  }
}
```

**After (HTTP):**
```json
{
  "asana": {
    "type": "http",
    "url": "https://mcp.asana.com/mcp"
  }
}
```

### Why HTTP is Better

| Feature | SSE | HTTP |
|---------|-----|------|
| **Status** | Deprecated | Recommended |
| **Compatibility** | Limited | Widespread |
| **Authentication** | Complex | Simple (Bearer) |
| **Tool Discovery** | Manual | Built-in |
| **Maintenance** | Deprecated | Active |

---

## Transport Comparison Matrix

| Feature | HTTP | stdio |
|---------|------|-------|
| **Transport** | HTTP/HTTPS | Process (stdin/stdout) |
| **Direction** | Request/Response | Bidirectional |
| **State** | Stateless | Stateful |
| **Auth** | OAuth, Headers | Environment variables |
| **Use Case** | Remote services | Local tools |
| **Latency** | Medium | Lowest |
| **Setup** | Easy | Easy |
| **Best For** | Cloud APIs | Local resources |

---

## Choosing the Right Transport

**Use HTTP when:**
- Connecting to cloud services or APIs
- Need OAuth authentication
- Using token-based auth
- Simple request/response pattern
- Remote server access

**Use stdio when:**
- Running local tools or custom servers
- Need lowest latency
- Working with file systems or local databases
- Distributing server with plugin
- Direct system access required

---

## Advanced Configuration

### Multiple Servers

Combine different transports:

```json
{
  "mcpServers": {
    "local-db": {
      "command": "npx",
      "args": ["-y", "mcp-server-sqlite", "./data.db"]
    },
    "cloud-api": {
      "type": "http",
      "url": "https://mcp.example.com/mcp"
    },
    "internal-service": {
      "type": "http",
      "url": "https://api.example.com/mcp",
      "headers": {
        "Authorization": "Bearer ${API_TOKEN}"
      }
    }
  }
}
```

### Conditional Configuration

Use environment variables to switch servers:

```json
{
  "api": {
    "type": "http",
    "url": "${API_URL}",
    "headers": {
      "Authorization": "Bearer ${API_TOKEN}"
    }
  }
}
```

Set different values for dev/prod:
- Dev: `API_URL=http://localhost:8080/mcp`
- Prod: `API_URL=https://api.production.com/mcp`

---

## Security Considerations

### HTTP Security

- Always use HTTPS, never HTTP
- Validate SSL certificates
- Don't skip certificate verification
- Use secure token storage
- Implement token rotation

### stdio Security

- Validate command paths
- Don't execute user-provided commands
- Limit environment variable access
- Restrict file system access
- Sanitize inputs

### Token Management

- Never hardcode tokens
- Use environment variables
- Rotate tokens regularly
- Implement token refresh
- Document scopes required

---

## Performance Optimization

### Connection Pooling

HTTP servers benefit from connection pooling (automatic in Claude Code).

### Batching

Batch similar requests when possible:

```python
# Good: Single query with filters
tasks = search_tasks(project="X", assignee="me", limit=50)

# Avoid: Many individual queries
for id in task_ids:
    task = get_task(id)
```

### Caching

stdio servers can implement caching for frequently accessed data.

---

## Testing

### HTTP Testing

```bash
# Test HTTP endpoint
curl -H "Authorization: Bearer $API_TOKEN" \
     https://api.example.com/mcp/health

# Should return 200 OK
```

### stdio Testing

```bash
# Test server directly
node server.js

# Verify tool discovery
# Check tool schemas
# Test error handling
```

### MCP Inspector

```bash
npx @modelcontextprotocol/inspector
```

Test MCP servers independently of Claude Code.
