---
name: mcp-development
description: "Create, validate, and audit MCP servers for Claude integration. Use when building MCP servers, tools, resources, or prompts. Includes stdio/http transport, tool schemas, authentication, and validation frameworks. Not for manual tool configuration or non-MCP integrations."
---

# MCP Development

<mission_control>
<objective>Create portable MCP servers with strict tool schema definitions, clear transport logic, and prompt-engineered descriptions that guide agent behavior</objective>
<success_criteria>Generated MCP server has valid JSON Schema for tools, prompt-engineered descriptions, and proper transport configuration</success_criteria>
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

**Core principle**: Treat every MCP tool like a tiny, well-written prompt for the agent. The descriptions and schemas you write directly influence how well Claude understands and uses your tools.

---

<pattern name="prompt_engineering_principle">
<principle>Tool descriptions and schemas are prompts to the agent. Write them as if explaining to a new hire—make implicit context explicit.</principle>
</pattern>

## Prompt Engineering for Tool Descriptions

<description_pattern>
<purpose>Structure tool descriptions to maximize agent understanding</purpose>

<template_formula>

**Tool description formula:**

```
Tool to <verb> <resource>. Use when <trigger condition>. Constraints: <key limits>.
```

<examples>
<example type="simple">

```json
{
  "name": "create_channel",
  "description": "Tool to create a new Slack channel. Use when the user asks to create a new channel."
}
```

</example>
<example type="with_constraint">

```json
{
  "name": "create_contact",
  "description": "Tool to create a new Salesforce contact. Use when the user wants to create a contact. Required workflow: call discover_required_fields('Contact') first to identify mandatory fields and prevent creation errors."
}
```

</example>
<example type="with_alternative">

```json
{
  "name": "get_calls",
  "description": "Tool to list all calls in a date range. Use when the user asks for calls across a workspace without user/workspace filtering. Constraint: this tool does not support user or workspace filters; for filtered calls, use search_calls_extensive instead."
}
```

</example>
</examples>

<structure_rules>

1. **Start with action**: Verb + resource (what the tool does)
2. **Add trigger condition**: When to use this tool
3. **Front-load constraints**: Required workflows, hard limits, alternatives

</structure_rules>

<length_guidance>

- Keep descriptions 1-2 sentences
- Under 1024 characters in practice
- Avoid marketing fluff

</length_guidance>

</description_pattern>

## Schema-Level Prompt Engineering

<schema_pattern>
<purpose>Use schemas not just for validation, but as prompts to the agent</purpose>

<parameter_level_guidance>

<property_pattern name="enum_preference">

**Use enums instead of free text when:**

- Finite set of values (status: ["pending", "approved", "rejected"])
- Predefined options (unit: ["celsius", "fahrenheit"])
- Boolean-like choices (severity: ["low", "medium", "high", "critical"])

**Why**: Enums remove ambiguity and act as strong constraints at the schema level.

</property_pattern>

<property_pattern name="format_constraints">

**Use format constraints:**

```json
"email": {
  "type": "string",
  "format": "email",
  "description": "User's email address"
}
```

**Common formats**: email, date, date-time, uri, uuid

</property_pattern>

<property_pattern name="conditional_requirements">

**State mutual exclusivity or requirements in descriptions:**

```json
"agent_id": {
  "type": "string",
  "description": "Unique identifier for agent. At least one of agent_id, user_id, app_id, or run_id must be provided."
}
```

</property_pattern>

</parameter_level_guidance>

<output_schema>

**Define outputSchema for complex responses:**

```json
{
  "name": "get_weather",
  "description": "Get weather conditions for a city",
  "inputSchema": {
    "type": "object",
    "properties": {
      "location": {
        "type": "string",
        "enum": ["New York", "Chicago", "Los Angeles"],
        "description": "Choose city"
      }
    }
  },
  "outputSchema": {
    "type": "object",
    "properties": {
      "temperature": {
        "type": "number",
        "description": "Temperature in Fahrenheit"
      },
      "conditions": { "type": "string", "description": "Weather conditions" },
      "humidity": { "type": "number", "description": "Humidity percentage" }
    }
  }
}
```

**Why**: outputSchema guides the agent about what shape to expect, improving reasoning about downstream tools.

</output_schema>

</schema_pattern>

## When and How to Use Strong Language

<strong_language>
<purpose>Directive language (must, always, never, required) for agent guidance</purpose>

<where_to_use>

<location type="safety">

**Safety and guardrails:**

```json
"description": "Tool to delete a user record. Use only when the user has confirmed deletion and has appropriate permissions. Never allow deletion without explicit user consent."
```

</location>

<location type="preconditions">

**Preconditions and ordering:**

```json
"description": "Tool to create a contact. Required workflow: call discover_required_fields('Contact') first to identify mandatory fields."
```

</location>

<location type="constraints">

**Format and cardinality constraints:**

```json
"title": {
  "type": "string",
  "description": "Title must be between 5 and 120 characters"
}
```

</location>

<location type="error_recovery">

**Error messages for agent recovery:**

```
"Invalid date_range: date_from is after date_to. Please ensure date_from is earlier than date_to and try again."
```

</location>

</where_to_use>

<guidance>

**Use strong language for:**

- Safety requirements (never expose credentials)
- Required workflows (must call X first)
- Non-negotiable constraints (must be <= 100)
- Error recovery instructions

**Avoid overusing strong language for:**

- General behavior descriptions
- Optional features
- Documentation-level details (put these in schema)

**Trade-off**: Too much strong language causes token bloat and over-constraint. Use sparingly where it matters most.

</guidance>

</strong_language>

## Guiding Agents with Errors

<error_guidance>
<purpose>Error messages are micro-prompts that guide agents to self-correct</purpose>

<pattern>

**Error message formula:**

```
<Problem>. <Why>. <Fix>.
```

<examples>

<example type="validation">

```
"Invalid date_from: date_from must be earlier than date_to. Please adjust date_from to a value before date_to and retry."
```

</example>

<example type="missing_inputs">

```
"Missing required parameter: repo_path is required. Please provide the path to the Git repository and retry."
```

</example>

<example type="permissions">

```
"Access denied: token lacks write scope. Ask the user to grant write permissions or use a read-only tool."
```

</example>

<example type="truncation">

```
"Result truncated: returned first 500 of 3,000 rows. To reduce truncation, specify a narrower date range or use filters (user_id, event_type)."
```

</example>

</examples>

<rules>

- Return structured errors with isError flag
- Use natural language, not stack traces
- Include concrete examples of correct parameters
- Suggest recovery actions explicitly

</rules>

</error_guidance>

## Balancing Power vs Complexity

<complexity_management>
<purpose>Achieve maximum capability with minimum cognitive load</purpose>

<per_tool_targets>

- **One clear, atomic action** per tool
- **1-3 required parameters**, small number of optional (total < 6-7)
- **Short descriptions** (1-2 sentences, < 1024 chars)
- **Narrow scope**: Don't create "manage" tools; prefer "create", "delete", "list", "search"

</per_tool_targets>

<per_server_targets>

- **Coherent domain**: Group related tools by service (git*\*, slack*\_, jira\_\_)
- **Small surface**: Each server should do one thing well
- **Consolidate chains**: Merge tools that are almost always called together

</per_server_targets>

<annotations>

**Use MCP annotations for client guidance:**

- `readOnlyHint`: tool doesn't modify state
- `destructiveHint`: may cause destructive changes (triggers confirmations)
- `idempotentHint`: repeating the call is safe

</annotations>

</complexity_management>

## Community Patterns and Examples

<community_examples>
<purpose>Reference patterns from official MCP servers and community implementations</purpose>

<pattern name="naming">

**Consistent snake_case with namespace prefixes:**

```json
{
  "git_status": "Shows working tree status",
  "git_diff_unstaged": "Shows unstaged changes",
  "git_commit": "Records changes to the repository"
}
```

</pattern>

<pattern name="description">

**Concise descriptions following the formula:**

```json
{
  "name": "get-structured-content",
  "description": "Returns structured content along with an output schema for client data validation"
}
```

</pattern>

<pattern name="schema">

**Strong typing with enums and descriptions:**

```json
{
  "location": {
    "type": "string",
    "enum": ["New York", "Chicago", "Los Angeles"],
    "description": "Choose city"
  }
}
```

</pattern>

<pattern name="server_description">

**One dense description for server capability (not individual tools):**

```json
{
  "description": "Integrates with Slack Lists to enable creation, retrieval, filtering, and management of list items with support for bulk operations, data export to JSON/CSV formats"
}
```

</pattern>

</community_examples>

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
  "description": "{{PROMPT_ENGINEERED_DESCRIPTION}}",
  "inputSchema": {
    "type": "object",
    "properties": {
      {{PARAMETER_DEFINITIONS}}
    },
    "required": [{{REQUIRED_PARAMS}}],
    "additionalProperties": false
  },
  "outputSchema": {{OUTPUT_SCHEMA}}
}
```

</tool_definition_template>

<parameter_template>

```json
"{{PARAM_NAME}}": {
  "type": "{{PARAM_TYPE}}",
  "description": "{{PARAM_DESCRIPTION}}",
  "enum": [{{ENUM_VALUES}}],
  "format": "{{FORMAT}}",
  "default": "{{DEFAULT_VALUE}}"
}
```

</parameter_template>

<validation_rules>

- name MUST be kebab-case with namespace prefix (e.g., service_action)
- description MUST follow formula: "Tool to <verb> <resource>. Use when <condition>. Constraints: <limits>."
- inputSchema MUST be valid JSON Schema
- properties MUST have descriptions explaining parameter meaning and constraints
- required MUST list all non-optional parameters
- additionalProperties SHOULD be false for strict validation
- Use enums for finite value sets
- Use format constraints where applicable (email, date, etc.)

</validation_rules>

<common_types>

- string - Text values
- number - Numeric values (int or float)
- boolean - true/false
- array - Lists of items
- object - Nested structures
- enum - Fixed set of values

</common_types>

<common_formats>

- email - Valid email address
- date - ISO date (YYYY-MM-DD)
- date-time - ISO datetime
- uri - Valid URI
- uuid - Valid UUID

</common_formats>

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

## Relevance Heuristic

<freshness_gate>
<purpose>Validate URL freshness before trusting documentation</purpose>

<rule>

**Freshness Gate:** Before trusting any code snippets from a URL:

1. Fetch the URL and check for last-updated metadata (Last-Modified header, date in content, or commit history)
2. If content is > 6 months old, search for a more recent version before using the code
3. Prefer recent commits over branch files for SDK documentation
4. Document the freshness check result in the session

</rule>

<exception>

Skip freshness check when:

- Checking npm/GitHub version info (timestamp is the version)
- The URL is clearly versioned (e.g., /v1/, /2026/)
- Official SDK changelog confirms stability

</exception>

<freshness_check>

```bash
# Check GitHub file last commit date
gh api repos/modelcontextprotocol/specification/commits?path=specification.md --jq '.[0].commit.author.date'

# Or fetch and parse for dates
curl -sI https://github.com/modelcontextprotocol/specification | grep -i last-modified
```

</freshness_check>

</freshness_gate>

**Protocol: Check Principles → Freshness Gate → Fetch Instance → Extract Delta → Dispose**

Before fetching MCP specification URLs:

1. **Check Principles** - This skill covers tool schema design, transport selection, error guidance, and prompt engineering. The patterns here are stable.

2. **Freshness Gate** - Verify URL is < 6 months old. If older, search for updated version or use npm package version instead.

3. **Fetch Instance Only When**:
   - MCP SDK version has breaking changes
   - Transport mechanism differs from documented patterns
   - New primitive types not covered
   - Authentication flow has changed

4. **Extract Delta** - Keep only what this skill doesn't cover:
   - SDK-specific initialization changes
   - New transport options
   - Updated security requirements
   - Protocol version differences

5. **Dispose Context** - Remove fetched content after extracting delta

**NEVER copy documentation from URLs.** Instead: fetch the URL, identify the current tool-calling syntax, apply it directly to the local file. Do not store documentation in the session.

**When NOT to fetch:**

- Tool description formula (covered in skill)
- Schema patterns (covered with templates)
- Transport selection criteria (covered in tables)
- Error guidance (covered with examples)
- Strong language usage (covered in patterns)

**Instance Resources** (fetch only when needed, after freshness gate):

| Trigger           | URL                                                                                                     |
| ----------------- | ------------------------------------------------------------------------------------------------------- |
| SDK changes       | https://github.com/modelcontextprotocol/specification                                                   |
| Transport specs   | https://github.com/modelcontextprotocol/specification/blob/main/docs/specification/server/transports.md |
| Latest primitives | https://github.com/modelcontextprotocol/specification/blob/main/specification.md                        |

**Workflow:** Freshness check → Verify npm package version → Consult skill patterns → Fetch spec only if behavior differs → Extract delta → Dispose

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
**MANDATORY: Prompt-engineer tool descriptions**

- Use formula: "Tool to <verb> <resource>. Use when <condition>. Constraints: <limits>."
- Front-load critical constraints and required workflows
- Keep 1-2 sentences, under 1024 characters

**MANDATORY: Use `<tool_schema>` tags for tool definitions**

- Follow tool definition template exactly
- name MUST be kebab-case with namespace prefix
- description MUST be prompt-engineered
- inputSchema MUST be valid JSON Schema
- properties MUST have descriptions
- required MUST list all non-optional parameters
- Use enums for finite value sets
- Use format constraints where applicable

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

**MANDATORY: Error messages must guide agent recovery**

- Use pattern: "<Problem>. <Why>. <Fix>."
- Never return raw stack traces
- Include concrete recovery suggestions

**MANDATORY: Read mandatory reference**

MANDATORY READ: `references/tool-development.md` before creating tools
This reference contains critical patterns for tool definition.

**MANDATORY: URL Mastery - Never store documentation in session**

- NEVER copy documentation from URLs into the session context
- Fetch URL → Identify current syntax → Apply directly to local file → Dispose
- Use Freshness Gate: Check last-updated date. If > 6 months old, search for updated version
- Prefer npm package version checks over URL content for SDK docs

**No exceptions. MCP servers require strict schema compliance and prompt-engineered descriptions for protocol correctness.**
</critical_constraint>

---

