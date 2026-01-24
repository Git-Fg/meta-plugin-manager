# MCP Protocol Guide

Essential MCP protocol concepts for proper integration.

---

## MCP Primitives

### Tools
**Purpose**: Callable functions
**Schema**:
```json
{
  "name": "tool-name",
  "description": "What it does",
  "inputSchema": {
    "type": "object",
    "properties": {...}
  }
}
```

### Resources
**Purpose**: Read-only data access
**Schema**:
```json
{
  "name": "resource-name",
  "description": "What it provides",
  "mimeType": "application/json"
}
```

### Prompts
**Purpose**: Reusable workflows
**Schema**:
```json
{
  "name": "prompt-name",
  "description": "When to use",
  "arguments": [...]
}
```

## Protocol Compliance Checklist

- [ ] Valid JSON structure
- [ ] Proper MIME types
- [ ] Required fields present
- [ ] Schema validation passes
- [ ] Transport configured correctly

See also: transport-mechanisms.md, component-templates.md, compliance-framework.md
