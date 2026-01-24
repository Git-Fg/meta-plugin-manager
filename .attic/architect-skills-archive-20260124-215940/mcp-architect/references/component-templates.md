# Component Templates

Copy-paste templates for MCP components.

---

## Tool Template

```json
{
  "name": "tool-name",
  "description": "Clear description of what it does",
  "inputSchema": {
    "type": "object",
    "properties": {
      "param1": {
        "type": "string",
        "description": "Parameter description"
      }
    },
    "required": ["param1"]
  }
}
```

---

## Resource Template

```json
{
  "name": "resource-name",
  "description": "What data it provides",
  "mimeType": "application/json"
}
```

---

## Prompt Template

```json
{
  "name": "prompt-name",
  "description": "When to use this prompt",
  "arguments": [
    {
      "name": "arg-name",
      "required": false,
      "description": "Argument description"
    }
  ]
}
```

---

## Complete Server Example

```json
{
  "name": "my-server",
  "description": "What this server provides",
  "transport": {
    "type": "http",
    "url": "https://api.example.com/mcp"
  },
  "tools": {...},
  "resources": {...},
  "prompts": {...}
}
```

See also: protocol-guide.md, transport-mechanisms.md, compliance-framework.md
