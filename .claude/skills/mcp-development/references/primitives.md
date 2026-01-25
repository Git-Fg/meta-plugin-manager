# MCP Primitives

Complete reference for MCP primitives: Tools, Resources, and Prompts.

---

## Overview

MCP servers expose three types of capabilities:

| Primitive | Purpose | Access Pattern | Use When |
|-----------|---------|----------------|----------|
| **Tools** | Callable functions | Direct invocation | Expose operations or actions |
| **Resources** | Read-only data | `@server:protocol://path` | Provide data access |
| **Prompts** | Reusable workflows | `/mcp__servername__promptname` | Predefined command templates |

---

## Tools

### Purpose

Callable functions that perform operations or actions. Tools are the primary way MCP servers expose capabilities to Claude Code.

### Schema

```json
{
  "name": "tool_name",
  "description": "Clear description of what this tool does",
  "inputSchema": {
    "type": "object",
    "properties": {
      "parameter_name": {
        "type": "string",
        "description": "Parameter description",
        "minLength": 1,
        "maxLength": 200
      }
    },
    "required": ["parameter_name"]
  }
}
```

### Parameter Types

- `string`: Text data
- `number`: Numeric values (integers, floats)
- `boolean`: True/false values
- `array`: Lists of items
- `object`: Nested objects

### Annotations

Annotations provide hints about tool behavior:

```json
{
  "name": "delete_file",
  "description": "Delete a file from the system",
  "inputSchema": { ... },
  "annotations": {
    "readOnlyHint": false,
    "destructiveHint": true,
    "idempotentHint": false,
    "openWorldHint": false
  }
}
```

**Available annotations:**
- `readOnlyHint`: Tool doesn't modify state
- `destructiveHint`: Tool performs destructive operations (delete, drop)
- `idempotentHint`: Multiple calls have same effect
- `openWorldHint`: Tool accesses external systems

### Tool Examples

**Search tool:**
```json
{
  "name": "search_web",
  "description": "Search the web for information",
  "inputSchema": {
    "type": "object",
    "properties": {
      "query": {
        "type": "string",
        "description": "Search query string",
        "minLength": 1,
        "maxLength": 200
      },
      "limit": {
        "type": "number",
        "description": "Maximum number of results",
        "minimum": 1,
        "maximum": 50,
        "default": 10
      }
    },
    "required": ["query"]
  }
}
```

**Database query tool:**
```json
{
  "name": "query_database",
  "description": "Execute SQL query",
  "inputSchema": {
    "type": "object",
    "properties": {
      "query": {
        "type": "string",
        "description": "SQL query string"
      },
      "params": {
        "type": "array",
        "description": "Query parameters"
      }
    },
    "required": ["query"]
  }
}
```

**CRUD tool:**
```json
{
  "name": "create_item",
  "description": "Create a new item",
  "inputSchema": {
    "type": "object",
    "properties": {
      "title": {
        "type": "string",
        "description": "Item title"
      },
      "description": {
        "type": "string",
        "description": "Item description"
      },
      "tags": {
        "type": "array",
        "items": {"type": "string"},
        "description": "Item tags"
      }
    },
    "required": ["title"]
  },
  "annotations": {
    "destructiveHint": false,
    "idempotentHint": false
  }
}
```

### Best Practices

1. **Use specific types**, not `any`
2. **Include descriptions** for all fields
3. **Set appropriate constraints** (min/max length, values)
4. **Mark required fields clearly**
5. **Provide examples** in descriptions
6. **Use annotations** for better UX
7. **Validate all inputs** in server implementation

See [references/tool-development.md](tool-development.md) for implementation details.

---

## Resources

### Purpose

Read-only data that can be referenced using @-mention syntax. Resources provide data access without exposing operations.

### Access Format

```
@server:protocol://resource/path
```

### Discovery

Type `@` in your prompt to see available resources from all connected MCP servers. Resources appear alongside files in the autocomplete menu.

### Examples

**GitHub issue:**
```
@github:issue://123
```

**Database schema:**
```
@postgres:schema://users
```

**Documentation file:**
```
@docs:file://api/authentication
```

**Multiple references:**
```
Compare @postgres:schema://users with @docs:file://database/user-model
```

### Resource Schema

Resources are defined by the MCP server:

```json
{
  "uri": "file:///project/config.json",
  "name": "project-config",
  "description": "Project configuration",
  "mimeType": "application/json"
}
```

### Features

- **Automatic fetching**: Resources fetched and included as attachments when referenced
- **Fuzzy search**: Resource paths are fuzzy-searchable in @-mention autocomplete
- **Any content type**: Text, JSON, structured data, etc.
- **Read-only**: Resources cannot be modified, only read

### Use Cases

- Configuration files
- Database schemas
- API documentation
- Code references
- Design documents
- Test fixtures

### Best Practices

1. **Use clear, descriptive URIs**
2. **Provide meaningful descriptions**
3. **Set correct MIME types**
4. **Keep resources up-to-date**
5. **Use consistent naming conventions**

See [references/2026-features.md](2026-features.md) for resource usage examples.

---

## Prompts

### Purpose

Reusable workflows exposed as slash commands. Prompts provide predefined templates for common operations.

### Command Format

```
/mcp__servername__promptname [arguments...]
```

### Discovery

Type `/` to see all available commands, including those from MCP servers. MCP prompts appear with the format `/mcp__servername__promptname`.

### Examples

**Execute without arguments:**
```bash
/mcp__github__list_prs
```

**Execute with single argument:**
```bash
/mcp__github__pr_review 456
```

**Execute with multiple arguments:**
```bash
/mcp__jira__create_issue "Bug in login flow" high
```

### Prompt Schema

Prompts are defined by the MCP server:

```json
{
  "name": "summarize_code",
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

### Argument Parsing

Arguments are space-separated and parsed based on the prompt's defined parameters:

```bash
# Prompt definition: create_issue(title, priority, assignee)
/mcp__jira__create_issue "Fix authentication bug" critical "john.doe"

# Parsed as:
# title = "Fix authentication bug"
# priority = "critical"
# assignee = "john.doe"
```

### Prompt Results

Prompt results are injected directly into the conversation, just like command output.

### Use Cases

- Common workflows (create issue, review PR)
- Standardized queries (list tasks, get status)
- Template operations (generate report, summarize)
- Multi-step procedures (deploy, rollback)

### Best Practices

1. **Use descriptive prompt names**
2. **Document argument purposes**
3. **Provide clear descriptions**
4. **Handle optional arguments gracefully**
5. **Return formatted results**
6. **Normalize names** (spaces become underscores)

See [references/2026-features.md](2026-features.md) for prompt usage examples.

---

## Primitive Comparison

| Feature | Tools | Resources | Prompts |
|---------|-------|-----------|---------|
| **Access** | Direct invocation | @-mentions | / commands |
| **Purpose** | Operations/actions | Data access | Workflows |
| **Input** | Structured parameters | URI reference | Arguments |
| **Output** | Tool results | File content | Injected text |
| **State** | May modify | Read-only | May trigger |
| **Discovery** | /mcp or @ | @ autocomplete | / autocomplete |

---

## Usage Patterns

### Tool-Only

Expose operations without data access:
```json
{
  "tools": ["create", "update", "delete"],
  "resources": [],
  "prompts": []
}
```

### Resource-Only

Provide data access without operations:
```json
{
  "tools": [],
  "resources": ["config", "schema", "docs"],
  "prompts": []
}
```

### Mixed

Provide comprehensive access:
```json
{
  "tools": ["query", "execute"],
  "resources": ["schema", "tables"],
  "prompts": ["list_tables", "describe_table"]
}
```

---

## Implementation Workflow

### For Tools

1. Define tool schema with name, description, inputSchema
2. Implement tool handler in server code
3. Validate inputs against schema
4. Return structured results
5. Add annotations for better UX

### For Resources

1. Define resource URI pattern
2. Implement resource list handler
3. Implement resource read handler
4. Set correct MIME types
5. Provide meaningful descriptions

### For Prompts

1. Define prompt with name, description, arguments
2. Implement prompt handler
3. Parse arguments according to schema
4. Generate formatted output
5. Inject into conversation

---

## Complete Example

### Server Definition

```json
{
  "tools": [
    {
      "name": "search_issues",
      "description": "Search for issues",
      "inputSchema": {
        "type": "object",
        "properties": {
          "query": {"type": "string"},
          "status": {"type": "string"}
        },
        "required": ["query"]
      }
    },
    {
      "name": "create_issue",
      "description": "Create a new issue",
      "inputSchema": {
        "type": "object",
        "properties": {
          "title": {"type": "string"},
          "description": {"type": "string"}
        },
        "required": ["title"]
      }
    }
  ],
  "resources": [
    {
      "uri": "issue://123",
      "name": "issue-123",
      "description": "Issue #123 details",
      "mimeType": "application/json"
    }
  ],
  "prompts": [
    {
      "name": "list_my_issues",
      "description": "List issues assigned to me",
      "arguments": []
    },
    {
      "name": "create_bug_report",
      "description": "Create bug report from description",
      "arguments": [
        {"name": "description", "required": true}
      ]
    }
  ]
}
```

### Usage

**Use tools:**
```
Search for bugs: search_issues(query="bug", status="open")
Create issue: create_issue(title="Fix crash", description="...")
```

**Use resources:**
```
Review issue: @tracker:issue://123
```

**Use prompts:**
```
List issues: /mcp__tracker__list_my_issues
Report bug: /mcp__tracker__create_bug_report "App crashes on login"
```

---

## Additional Resources

- **[references/tool-development.md](tool-development.md)** - Building MCP tools (Python/TypeScript)
- **[references/2026-features.md](2026-features.md)** - Resources and Prompts usage
- **[MCP Specification](https://modelcontextprotocol.io/)** - Official protocol docs
- **[MCP Inspector](https://modelcontextprotocol.io/inspector)** - Test MCP servers
