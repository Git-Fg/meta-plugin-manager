---
name: mcp-development
description: This skill should be used when the user asks to "add MCP server", "integrate MCP", "configure MCP", "build MCP tool", "use .mcp.json", mentions Model Context Protocol, or needs guidance on MCP transports (HTTP, stdio), primitives (tools/resources/prompts), plugin integration, or 2026 features (Tool Search, Resources, Prompts).
---

# MCP Development: Architectural Refiner

**Role**: Transform intent into portable, integrated MCP servers
**Mode**: Architectural pattern application (ensure output has specific traits)

---

## Architectural Pattern Application

When building an MCP server, apply this process:

1. **Analyze Intent** - What type of MCP server and what traits needed?
2. **Apply Teaching Formula** - Bundle condensed philosophy into output
3. **Enforce Portability Invariant** - Ensure works in isolation
4. **Verify Traits** - Check transport mechanisms, server configuration, Success Criteria

---

## Core Understanding: What MCP Servers Are

**Metaphor**: MCP servers are "connection bridges"—they connect Claude to external systems, providing tools, resources, and prompts through standardized protocols.

**Definition**: MCP (Model Context Protocol) servers are open-source standard connectors that give Claude Code access to external systems, databases, APIs, and data sources through unified primitives.

**Key insight**: MCP servers bundle their own transport logic and server configuration. They don't depend on external documentation to integrate properly.

✅ Good: MCP server includes bundled transport configuration with authentication patterns
❌ Bad: MCP server references external documentation for configuration
Why good: MCP servers must self-configure without external dependencies

Recognition: "Would this MCP server work if moved to a project with no rules?" If no, bundle the configuration philosophy.

---

## MCP Server Traits: What Portable MCP Servers Must Have

### Trait 1: Portability (MANDATORY)

**Requirement**: MCP server works in isolation without external dependencies

**Enforcement**:
- Bundle condensed Seed System philosophy (Delta Standard, Transport Mechanisms, Teaching Formula)
- Include Success Criteria for self-validation
- Provide complete server configuration examples
- Never reference .claude/rules/ files

**Example**:
```
## Core Philosophy

Think of MCP servers like connection bridges: they connect Claude to external systems.

✅ Good: Include complete transport configuration with auth patterns
❌ Bad: Vague transport setup without specific examples
Why good: Complete configuration enables reliable integration

Recognition: "Could this MCP server configure itself without external documentation?" If no, add configuration patterns.
```

### Trait 2: Teaching Formula Integration

**Requirement**: Every MCP server must teach through metaphor, contrast, and recognition

**Enforcement**: Include all three elements:
1. **1 Metaphor** - For understanding (e.g., "Think of X like a Y")
2. **2 Contrast Examples** - Good vs Bad with rationale
3. **3 Recognition Questions** - Binary self-checks

**Template**:
```
Metaphor: [Understanding aid]

✅ Good: [Concrete example]
❌ Bad: [Concrete example]
Why good: [Reason]

Recognition: "[Question]?" → [Action]
Recognition: "[Question]?" → [Action]
Recognition: "[Question]?" → [Action]
```

### Trait 3: Self-Containment

**Requirement**: MCP server owns all its content

**Enforcement**:
- Include all configuration examples directly
- Provide complete .mcp.json setup
- Bundle necessary transport philosophy
- Never reference external files

✅ Good: Complete .mcp.json with embedded transport logic
❌ Bad: "See external documentation for configuration"
Why good: Self-contained servers work without external references

Recognition: "Does MCP server reference files outside itself?" If yes, inline the content.

### Trait 4: Transport Mechanisms

**Requirement**: MCP server defines specific transport with clear configuration

**Enforcement**:
- Specific transport type (HTTP, stdio)
- Complete configuration schema
- Authentication patterns included
- Best practices embedded

**Example**:
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

### Trait 5: Success Criteria Invariant

**Requirement**: MCP server includes self-validation logic

**Template**:
```
## Success Criteria

This MCP server is complete when:
- [ ] Valid .mcp.json configuration
- [ ] Specific transport type with complete configuration
- [ ] Teaching Formula: 1 Metaphor + 2 Contrasts + 3 Recognition
- [ ] Portability: Works in isolation, bundled philosophy, no external refs
- [ ] Transport: HTTP or stdio with auth patterns
- [ ] Primitives: Tools, Resources, or Prompts defined

Self-validation: Verify each criterion without external dependencies. If all checked, MCP server meets Seed System standards.
```

**Recognition**: "Could a user validate this MCP server using only its content?" If no, add Success Criteria.

---

## Anatomical Requirements

### Required: MCP Server Configuration

**Location:** `.mcp.json` or settings.json

**Structure**:
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

### Required: Transport Types

**HTTP** (recommended for remote):
- Remote/cloud services
- OAuth and Bearer token auth
- Stateless interactions

**stdio** (local processes):
- Local file system access
- Custom MCP servers
- Environment variable auth

### Required: MCP Primitives

**Tools**: Callable functions with input validation
**Resources**: Read-only data via @-mentions
**Prompts**: Reusable workflow templates

**Recognition**: "Which primitive matches the integration need?" Select specific primitive for targeted functionality.

---

## Pattern Application Framework

### Step 1: Analyze Intent

**Question**: What type of MCP server and what traits needed?

**Analysis**:
- Remote API integration? → HTTP transport with OAuth
- Local file access? → stdio transport with filesystem server
- Database connection? → HTTP transport with Bearer tokens
- Custom tools? → stdio transport with custom server

**Example**:
```
Intent: Build MCP server for remote API
Analysis:
- Remote service → Need HTTP transport
- API integration → Include Bearer token auth
- Stateless → Use HTTP with proper headers
Output traits: Portability + Teaching Formula + Transport + Success Criteria
```

### Step 2: Apply Teaching Formula

**Requirement**: Bundle condensed Seed System philosophy

**Elements to include**:
1. **Metaphor**: "MCP servers are connection bridges..."
2. **Delta Standard**: Good Component = Expert Knowledge - What Claude Knows
3. **Transport Mechanisms**: HTTP vs stdio explained
4. **2 Contrast Examples**: Good vs Bad server configuration
5. **3 Recognition Questions**: Binary self-checks for quality

**Template integration**:
```markdown
## Core Philosophy

Metaphor: "Think of MCP servers like [metaphor]..."

✅ Good: type: "http" with complete URL and auth
❌ Bad: type: "stdio" without command configuration
Why good: Complete configuration enables reliable connection

Recognition: "Does server include specific transport configuration?" → If no, add transport patterns
Recognition: "Is authentication properly configured?" → If no, include auth patterns
Recognition: "Could this work without external documentation?" → If no, bundle philosophy
```

### Step 3: Enforce Portability Invariant

**Requirement**: Ensure MCP server works in isolation

**Checklist**:
- [ ] Condensed philosophy bundled (Delta Standard, Transport, Teaching Formula)
- [ ] Success Criteria included
- [ ] Complete transport configuration
- [ ] No external .claude/rules/ references
- [ ] Authentication patterns embedded

**Verification**: "Could this MCP server survive being moved to a fresh project with no .claude/rules?" If no, fix portability issues.

### Step 4: Verify Traits

**Requirement**: Check all mandatory traits present

**Verification**:
- Portability Invariant ✓
- Teaching Formula (1 Metaphor + 2 Contrasts + 3 Recognition) ✓
- Self-Containment ✓
- Transport Mechanisms ✓
- Success Criteria Invariant ✓

**Recognition**: "Does MCP server meet all five traits?" If any missing, add them.

---

## Architecture Patterns

### Pattern 1: HTTP Transport Configuration

**Trait**: Remote service integration

**Application**: Use HTTP for cloud APIs and services

**Example**:
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

**Best practices**:
- Always use HTTPS
- Use OAuth when supported
- Store tokens in environment variables

### Pattern 2: stdio Transport Configuration

**Trait**: Local process integration

**Application**: Use stdio for local servers

**Example**:
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

**Best practices**:
- Use ${CLAUDE_PROJECT_DIR} for local paths
- Use ${CLAUDE_PLUGIN_ROOT} for plugin portability
- Set PYTHONUNBUFFERED for Python servers
- Log to stderr, not stdout

### Pattern 3: MCP Primitives Definition

**Trait**: Tools, Resources, and Prompts

**Application**: Define specific primitives for integration

**Tools example**:
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

---

## Common Transformations

### Transform Tutorial → Architectural

**Before** (tutorial):
```
Step 1: Understand MCP basics
Step 2: Configure transport
Step 3: Add primitives
...
```

**After** (architectural):
```
Analyze Intent → Apply Teaching Formula → Enforce Portability → Verify Traits
```

**Why**: Architectural patterns ensure output has required traits, not just follows steps.

### Transform Reference → Bundle

**Before** (referenced):
```
"See MCP documentation for configuration"
```

**After** (bundled):
```
## Core Philosophy

Bundle transport patterns directly in server:

Think of MCP servers like connection bridges...

✅ Good: [example]
❌ Bad: [example]
Why good: [reason]
```

**Why**: MCP servers must work in isolation.

---

## Quality Validation

### Portability Test

**Question**: "Could this MCP server work if moved to a project with zero .claude/rules?"

**If NO**:
- Bundle condensed philosophy
- Add Success Criteria
- Remove external references
- Include complete transport configuration

### Teaching Formula Test

**Checklist**:
- [ ] 1 Metaphor present
- [ ] 2 Contrast Examples (good/bad) with rationale
- [ ] 3 Recognition Questions (binary self-checks)

**If any missing**: Add them using Teaching Formula Arsenal

### Transport Configuration Test

**Question**: "Does server include complete transport configuration?"

**If NO**: Add specific transport patterns with auth

### Primitive Definition Test

**Question**: "Are MCP primitives properly defined?"

**If NO**: Include Tools, Resources, or Prompts schema

---

## Success Criteria

This MCP-development guidance is complete when:

- [ ] Architectural pattern clearly defined (Analyze → Apply → Enforce → Verify)
- [ ] Teaching Formula integrated (1 Metaphor + 2 Contrasts + 3 Recognition)
- [ ] Portability Invariant explained with enforcement checklist
- [ ] All five traits defined (Portability, Teaching Formula, Self-Containment, Transport Mechanisms, Success Criteria)
- [ ] Pattern application framework provided
- [ ] Transport configurations included
- [ ] Quality validation tests included
- [ ] Success Criteria present for self-validation

Self-validation: Verify MCP-development meets Seed System standards using only this content. No external dependencies required.

---

## Reference: The Five Mandatory Traits

Every MCP server must have:

1. **Portability** - Works in isolation
2. **Teaching Formula** - 1 Metaphor + 2 Contrasts + 3 Recognition
3. **Self-Containment** - Owns all content
4. **Transport Mechanisms** - HTTP or stdio configuration
5. **Success Criteria** - Self-validation logic

**Recognition**: "Does this MCP server have all five traits?" If any missing, add them.

---

**Remember**: MCP servers are connection bridges. They connect Claude to external systems through standardized protocols. Bundle the philosophy. Enforce the invariants. Verify the traits.
