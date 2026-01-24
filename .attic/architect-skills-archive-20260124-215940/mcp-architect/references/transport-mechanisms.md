# Transport Mechanisms

MCP transport configuration patterns.

---

## stdio Transport

**Use Case**: Local development, testing

**Configuration**:
```json
{
  "transport": {
    "type": "stdio",
    "command": "node",
    "args": ["server.js"]
  }
}
```

**Pros**:
- Simple setup
- No network required
- Fast for local development

**Cons**:
- Single user only
- No remote access

---

## http Transport

**Use Case**: Production, multi-user, cloud

**Configuration**:
```json
{
  "transport": {
    "type": "http",
    "url": "https://api.example.com/mcp"
  }
}
```

**Pros**:
- Remote access
- Multi-user support
- Scalable

**Cons**:
- Network required
- More complex setup

---

## Selection Guide

**"Local development"** → stdio
**"Production deployment"** → http
**"Team sharing"** → http
**"Single user"** → stdio

See also: protocol-guide.md, component-templates.md, compliance-framework.md
