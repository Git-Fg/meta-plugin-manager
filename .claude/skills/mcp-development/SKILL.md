---
name: mcp-development
description: "Create, validate, and audit MCP servers for Claude integration. Use when building MCP servers, tools, resources, or prompts. Includes stdio/http transport, tool schemas, authentication, and validation frameworks. Not for manual tool configuration or non-MCP integrations."
---

# MCP Development

<mission_control>
<objective>Create portable MCP servers with strict tool schema definitions and clear transport logic</objective>
<success_criteria>Generated MCP server has valid JSON Schema for tools and proper transport configuration</success_criteria>
<standards_gate>
MANDATORY: Load mcp-development references BEFORE creating MCP servers:

- Tool development → references/tool-development.md
- Transport mechanisms → references/transports.md
- Authentication → references/authentication.md
  </standards_gate>
  </mission_control>

<interaction_schema>
design → tool_schema_definition → transport_logic → validation → output</interaction_schema>

MCP (Model Context Protocol) servers provide structured integration between Claude and external systems. They define tools, resources, and prompts that Claude can access through standardized protocols.

**Core principle**: MCP servers must be portable, self-configuring, and provide clear tool definitions for Claude interaction.

---

<pattern name="tool_schema_enforcement">
<principle>Use `<tool_schema>` tags to ensure generated MCP servers have valid JSON Schema for tool parameters.</principle>
</pattern>

<tool_schema>
<purpose>Strict template for generating valid tool definitions</purpose>

<tool_definition_template>

```json
{
  "name": "{{TOOL_NAME}}",
  "description": "{{TOOL_DESCRIPTION}}",
  "inputSchema": {
    "type": "object",
    "properties": {
      {{PARAMETER_DEFINITIONS}}
    },
    "required": [{{REQUIRED_PARAMS}}],
    "additionalProperties": false
  }
}
```

</tool_definition_template>

<parameter_template>

```json
"{{PARAM_NAME}}": {
  "type": "{{PARAM_TYPE}}",
  "description": "{{PARAM_DESCRIPTION}}",
  "enum": [{{ENUM_VALUES}}],
  "default": "{{DEFAULT_VALUE}}"
}
```

</parameter_template>

<validation_rules>

- name MUST be kebab-case
- description MUST explain what tool does
- inputSchema MUST be valid JSON Schema
- properties MUST have descriptions
- required MUST list all non-optional parameters
- additionalProperties SHOULD be false for strict validation
  </validation_rules>

<common_types>

- string - Text values
- number - Numeric values (int or float)
- boolean - true/false
- array - Lists of items
- object - Nested structures
- enum - Fixed set of values
  </common_types>
  </tool_schema>

## Transport Logic

<transport_selection>
<purpose>Define when to use stdio vs http transport</purpose>

<transports>
<transport type="stdio">
<use_case>Local development, subprocess communication</use_case>
<advantages>
- Direct Claude integration
- Simple setup
- No network overhead
- Ideal for CLI tools
</advantages>
<disadvantages>
- Single client only
- Local only
</disadvantages>
<example>
```json
{
  "transport": {
    "type": "stdio",
    "command": "node",
    "args": ["server.js"]
  }
}
```
</example>
</transport>

<transport type="http">
<use_case>Remote servers, multi-client scenarios</use_case>
<advantages>
- Multiple clients
- Remote access
- Network transport
- Load balancing
</advantages>
<disadvantages>
- Requires server setup
- Network dependency
- Authentication needed
</disadvantages>
<example>
```json
{
  "transport": {
    "type": "http",
    "url": "http://localhost:3000",
    "authentication": {
      "type": "bearer",
      "token": "${API_TOKEN}"
    }
  }
}
```
</example>
</transport>
</transports>

<selection_criteria>

- Local tool → stdio
- Remote service → http
- Multi-user → http
- Development → stdio
- Production → http
  </selection_criteria>
  </transport_selection>

---

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

### Server Configuration (McpServer)

<critical_constraint>
**MANDATORY: Use `McpServer` from `@modelcontextprotocol/sdk/server/mcp.js` (NOT legacy `Server`)**
</critical_constraint>

```typescript
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { z } from "zod";

const server = new McpServer({
  name: "mcp-server-name",
  version: "1.0.0",
});

// Tool registration with Zod
server.tool(
  "tool-name",
  "Tool description",
  {
    param: z.string().describe("Parameter description"),
  },
  async ({ param }) => {
    // Implementation
    return { content: [{ type: "text", text: result }] };
  },
);

// Transport connection
const transport = new StdioServerTransport();
await server.connect(transport);
```

### Validation Framework

**MANDATORY: Verify logic with a programmatic test script (Inspector is flaky).**

```javascript
// test.mjs
import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import { z } from "zod";

// Import your server code here or mock it
// ...

// Validate registration
const tools = server._registeredTools; // Access internal registry
console.log("Tools found:", tools.length);

if (tools.some((t) => t.name === "tool-name")) {
  console.log("✅ Tool registered");
} else {
  console.error("❌ Tool missing");
  process.exit(1);
}
```

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

---

## Absolute Constraints (Non-Negotiable)

<critical_constraint>
**MANDATORY: Use `<tool_schema>` tags for tool definitions**

- Follow tool definition template exactly
- name MUST be kebab-case
- description MUST explain what tool does
- inputSchema MUST be valid JSON Schema
- properties MUST have descriptions
- required MUST list all non-optional parameters

**MANDATORY: Choose appropriate transport type**

- stdio for local development, single client
- http for remote servers, multiple clients
- Define transport configuration clearly
- Handle authentication if http

**MANDATORY: Portability requirements**

- Environment variable configuration
- No hardcoded paths
- Self-contained dependencies
- Graceful degradation

**MANDATORY: Schema validation**

- Use standard JSON Schema types
- Provide clear descriptions
- Validate input thoroughly
- Include examples in descriptions

**MANDATORY: Read mandatory reference**

MANDATORY READ: `references/tool-development.md` before creating tools
This reference contains critical patterns for tool definition.

**No exceptions. MCP servers require strict schema compliance for protocol correctness.**
</critical_constraint>
