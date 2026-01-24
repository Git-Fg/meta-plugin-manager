---
name: knowledge-mcp
description: "Reference knowledge for Model Context Protocol: transports (stdio/http), primitives (tools/resources/prompts), integration patterns. Use when understanding MCP. No execution logic."
user-invocable: false
---

# Knowledge: MCP

Reference knowledge for Model Context Protocol (MCP). Pure knowledge without execution logic.

## Quick Reference

**Official MCP Docs**: https://modelcontextprotocol.io/
**Official MCP Guide**: https://code.claude.com/docs/en/mcp

### MCP Primitives

| Primitive | Purpose | Use When |
|-----------|---------|----------|
| **Tools** | Callable functions | Need to expose operations or actions |
| **Resources** | Read-only data | Need to provide data access |
| **Prompts** | Reusable workflows | Need predefined prompt templates |

### Transports

| Transport | Use For | Configuration |
|-----------|---------|---------------|
| **stdio** | Local development | Local MCP server implementation |
| **Streamable HTTP** | Cloud/production | Hosted services, high availability |

## .mcp.json Structure

```json
{
  "mcpServers": {
    "server-name": {
      "transport": {
        "type": "stdio",
        "command": "executable",
        "args": ["arg1", "arg2"]
      },
      "disabled": false,
      "autoApprove": ["tool1", "tool2"]
    }
  }
}
```

### Transport Configuration

**stdio (Local)**:
```json
{
  "transport": {
    "type": "stdio",
    "command": "node",
    "args": ["dist/server.js"]
  }
}
```

**Streamable HTTP (Cloud)**:
```json
{
  "transport": {
    "type": "streamable-http",
    "url": "https://api.example.com/mcp"
  }
}
```

## Tool Schema

Tools define callable functions with input validation:

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

## Resource Definition

Resources provide read-only data access:

```json
{
  "uri": "file:///project/config.json",
  "name": "project-config",
  "description": "Project configuration",
  "mimeType": "application/json"
}
```

## Prompt Template

Prompts define reusable workflows:

```json
{
  "name": "summarize-code",
  "description": "Summarize code changes",
  "arguments": [
    {
      "name": "file",
      "description": "File to summarize",
      "required": true
    }
  ]
}
```

## Reference Files

Load these as needed for comprehensive guidance:

| File | Content | When to Read |
|------|---------|--------------|
| [protocol-guide.md](references/protocol-guide.md) | MCP specification | Understanding protocol |
| [transport-mechanisms.md](references/transport-mechanisms.md) | Transport types | Choosing transport |
| [tools.md](references/tools.md) | Tool development and schemas | Building tools |
| [resources.md](references/resources.md) | Resources and prompts | Providing data access |
| [integration.md](references/integration.md) | Decision guide for MCP usage | Adding MCP to projects |
| [servers.md](references/servers.md) | Server configuration | Setting up servers |
| [compliance-framework.md](references/compliance-framework.md) | Quality scoring (0-100) | Validating configuration |
| [component-templates.md](references/component-templates.md) | Tool/Resource/Prompt templates | Implementing primitives |
| [output-contracts.md](references/output-contracts.md) | Workflow output formats | Understanding outputs |
| [tasklist-compliance.md](references/tasklist-compliance.md) | TaskList integration patterns | Complex MCP workflows |

## Quality Framework

### Scoring System (0-100 points)

| Dimension | Points | Focus |
|-----------|--------|-------|
| **1. Protocol Compliance** | 25 | Valid MCP specification |
| **2. Server Configuration** | 20 | Correct transport and settings |
| **3. Tool Validation** | 15 | Valid tool schemas |
| **4. Resource Access** | 15 | Proper resource configuration |
| **5. Transport Optimization** | 15 | Appropriate transport choice |
| **6. Security** | 10 | Secure configuration |

### Quality Thresholds

- **A (90-100)**: Exemplary MCP configuration
- **B (75-89)**: Good configuration with minor gaps
- **C (60-74)**: Adequate configuration, needs improvement
- **D (40-59)**: Poor configuration, significant issues
- **F (0-39)**: Failing configuration, critical errors

## Integration Decision Guide

```
Need external service integration?
├─ Yes → Use MCP
│  ├─ Decision guide → [integration.md](references/integration.md)
│  ├─ Configure servers → [servers.md](references/servers.md)
│  ├─ Build tools → [tools.md](references/tools.md)
│  └─ Create resources → [resources.md](references/resources.md)
└─ No → Use skills or native tools
```

## Usage Pattern

Load this knowledge skill to understand MCP protocol and configuration patterns, then use the create-mcp-server factory skill for adding servers to .mcp.json.

## Knowledge Only

This skill contains NO execution logic. For adding MCP servers, use the create-mcp-server factory skill.
