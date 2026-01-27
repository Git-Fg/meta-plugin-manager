---
name: mcp-development
description: "Create portable MCP servers. Use when: You need to provide external tools, resources, or prompts to Claude via standard protocol. Not for: Internal logic reuse (use skill-development) or simple scripts."
---

# MCP Development

MCP (Model Context Protocol) servers provide structured integration between Claude and external systems. They define tools, resources, and prompts that Claude can access through standardized protocols.

**Core principle**: MCP servers must be portable, self-configuring, and provide clear tool definitions for Claude interaction.

---

## What MCPs Are

MCP servers provide:

- **Tool definitions**: Structured capabilities Claude can invoke
- **Resource access**: Shared data and context
- **Prompt templates**: Reusable interaction patterns
- **Transport mechanisms**: Communication protocols
- **Portability**: Work across different environments

### MCP Architecture

**Server-Based**: MCPs run as separate servers that Claude connects to

**Three Component Types**:

1. **Tools**: Invocable functions with parameters
2. **Resources**: Data sources and context providers
3. **Prompts**: Template-based interaction patterns

---

## Core Structure

### Server Configuration

```typescript
{
  "name": "mcp-server-name",
  "version": "1.0.0",
  "description": "Server description",
  "transport": {
    "type": "stdio" | "http"
  },
  "capabilities": {
    "tools": {},
    "resources": {},
    "prompts": {}
  }
}
```

### Tool Definition

```typescript
{
  "name": "tool-name",
  "description": "What this tool does",
  "inputSchema": {
    "type": "object",
    "properties": {
      "param": {
        "type": "string",
        "description": "Parameter description"
      }
    }
  }
}
```

### MCP Body

- **Transport setup**: How Claude connects
- **Tool definitions**: Available capabilities
- **Resource schemas**: Data structures
- **Error handling**: Protocol compliance
- **Portability config**: Environment adaptation

---

## Best Practices

### Tool Design

- Clear, specific tool names
- Descriptive parameter schemas
- Proper error handling
- Idempotent operations where possible

### Transport Selection

**stdio**:

- For local development
- Simple subprocess communication
- Direct Claude integration

**http**:

- For remote servers
- Network-based communication
- Scalable deployment

### Portability

- Environment variable configuration
- No hardcoded paths
- Graceful degradation
- Self-contained dependencies

### Schema Design

- Use standard JSON Schema types
- Provide clear descriptions
- Validate input thoroughly
- Include examples in descriptions

### Error Handling

- Standardized error responses
- Meaningful error messages
- Proper status codes
- Recovery suggestions

### Quality

- Test tool invocations thoroughly
- Validate schemas against examples
- Document all capabilities clearly
- Provide usage examples

---

## Navigation

| If you need...       | Reference                                   |
| -------------------- | ------------------------------------------- |
| Tool development     | MANDATORY: `references/tool-development.md` |
| Transport mechanisms | `references/transports.md`                  |
| Primitives overview  | `references/primitives.md`                  |
| Authentication       | `references/authentication.md`              |
| Plugin integration   | `references/plugin-integration.md`          |
| 2026 features        | `references/2026-features.md`               |
