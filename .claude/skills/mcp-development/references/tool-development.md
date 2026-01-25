# MCP Tool Development

Complete guide for building MCP tools with proper schemas, validation, and error handling.

---

## Overview

Tools are callable functions exposed by MCP servers with:
- Named functions with input/output schemas
- Type-safe parameter validation
- Structured error handling
- Clear descriptions for discovery

---

## Tool Schema Definition

### Input Schema Structure

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

| Type | Description | Example |
|------|-------------|---------|
| `string` | Text data | `"hello"`, `"user@example.com"` |
| `number` | Numeric values | `42`, `3.14`, `-10` |
| `boolean` | True/false | `true`, `false` |
| `array` | Lists of items | `["a", "b", "c"]` |
| `object` | Nested objects | `{"key": "value"}` |

### Constraints

| Constraint | Types | Description |
|------------|-------|-------------|
| `minLength` | string | Minimum string length |
| `maxLength` | string | Maximum string length |
| `minimum` | number | Minimum numeric value |
| `maximum` | number | Maximum numeric value |
| `enum` | any | Fixed set of values |
| `pattern` | string | Regex pattern |
| `format` | string | Format (email, uri, etc.) |

---

## Python Implementation

### Basic Server

```python
from mcp import Server
from mcp.types import Tool

server = Server("my-server")

@server.list_tools()
async def handle_list_tools():
    return [
        Tool(
            name="search_web",
            description="Search the web for information",
            inputSchema={
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
        )
    ]

@server.call_tool()
async def handle_call_tool(name, arguments):
    if name == "search_web":
        query = arguments["query"]
        limit = arguments.get("limit", 10)

        # Tool implementation
        results = await search(query, limit)

        return {
            "content": [
                {
                    "type": "text",
                    "text": f"Found {len(results)} results"
                }
            ]
        }
```

### Error Handling

```python
@server.call_tool()
async def handle_call_tool(name, arguments):
    try:
        result = await external_api.call(arguments)
        return {
            "content": [{"type": "text", "text": result}],
            "isError": False
        }
    except ValueError as e:
        return {
            "content": [{"type": "text", "text": f"Invalid input: {e}"}],
            "isError": True
        }
    except Exception as e:
        return {
            "content": [{"type": "text", "text": f"Error: {e}"}],
            "isError": True
        }
```

### Validation

```python
def validate_tool_input(name, args):
    """Validate tool name and arguments."""
    if not is_valid_tool_name(name):
        raise ValueError(f"Invalid tool name: {name}")

    tool_schema = get_tool_schema(name)
    validate_arguments(args, tool_schema)
    return True

@server.call_tool()
async def handle_call_tool(name, arguments):
    validate_tool_input(name, arguments)
    # Proceed with tool execution
```

### Advanced: Tool Composition

```python
@server.call_tool()
async def handle_call_tool(name, arguments):
    if name == "analyze_code":
        # Use multiple operations together
        ast = await parse_code(arguments["code"])
        issues = await analyze_ast(ast)
        suggestions = await generate_suggestions(issues)
        return format_result(suggestions)
```

---

## TypeScript Implementation

### Basic Server

```typescript
import { Server } from '@modelcontextprotocol/sdk/server/index.js';

const server = new Server('my-server', { version: '1.0.0' });

server.setRequestHandler('tools/list', async () => ({
  tools: [
    {
      name: 'search_web',
      description: 'Search the web for information',
      inputSchema: {
        type: 'object',
        properties: {
          query: {
            type: 'string',
            description: 'Search query string',
            minLength: 1,
            maxLength: 200
          },
          limit: {
            type: 'number',
            description: 'Maximum number of results',
            minimum: 1,
            maximum: 50,
            defaultValue: 10
          }
        },
        required: ['query']
      }
    }
  ]
}));

server.setRequestHandler('tools/call', async (request) => {
  const { name, arguments: args } = request.params;

  if (name === 'search_web') {
    const query = args.query as string;
    const limit = (args.limit as number) ?? 10;

    // Tool implementation
    const results = await search(query, limit);

    return {
      content: [
        {
          type: 'text',
          text: `Found ${results.length} results`
        }
      ]
    };
  }

  throw new Error(`Unknown tool: ${name}`);
});
```

### Error Handling

```typescript
server.setRequestHandler('tools/call', async (request) => {
  try {
    const result = await externalAPI.call(request.params.arguments);
    return {
      content: [{ type: 'text', text: result }],
      isError: false
    };
  } catch (error) {
    return {
      content: [{
        type: 'text',
        text: `Error: ${(error as Error).message}`
      }],
      isError: true
    };
  }
});
```

### Advanced: Pagination

```typescript
{
  name: 'list_items',
  description: 'List items with pagination',
  inputSchema: {
    type: 'object',
    properties: {
      page: {
        type: 'number',
        description: 'Page number (1-based)',
        minimum: 1,
        default: 1
      },
      limit: {
        type: 'number',
        description: 'Items per page',
        minimum: 1,
        maximum: 100,
        default: 20
      }
    }
  }
}
```

---

## Tool Patterns

### CRUD Operations

**Create:**
```json
{
  "name": "create_item",
  "description": "Create a new item",
  "inputSchema": {
    "properties": {
      "title": {"type": "string"},
      "description": {"type": "string"}
    },
    "required": ["title"]
  }
}
```

**Read:**
```json
{
  "name": "get_item",
  "description": "Get item by ID",
  "inputSchema": {
    "properties": {
      "id": {"type": "string"}
    },
    "required": ["id"]
  }
}
```

**Update:**
```json
{
  "name": "update_item",
  "description": "Update existing item",
  "inputSchema": {
    "properties": {
      "id": {"type": "string"},
      "title": {"type": "string"},
      "description": {"type": "string"}
    },
    "required": ["id"]
  }
}
```

**Delete:**
```json
{
  "name": "delete_item",
  "description": "Delete item by ID",
  "inputSchema": {
    "properties": {
      "id": {"type": "string"}
    },
    "required": ["id"]
  },
  "annotations": {
    "destructiveHint": true
  }
}
```

### Search and Filter

```json
{
  "name": "search_items",
  "description": "Search items with filters",
  "inputSchema": {
    "properties": {
      "query": {"type": "string"},
      "category": {"type": "string"},
      "status": {"type": "string", "enum": ["active", "archived"]},
      "limit": {"type": "number", "minimum": 1, "maximum": 100}
    }
  }
}
```

### Batch Operations

```json
{
  "name": "batch_update",
  "description": "Update multiple items",
  "inputSchema": {
    "properties": {
      "items": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "id": {"type": "string"},
            "changes": {"type": "object"}
          }
        }
      }
    },
    "required": ["items"]
  }
}
```

---

## Annotations

### Available Annotations

```json
{
  "annotations": {
    "readOnlyHint": false,
    "destructiveHint": false,
    "idempotentHint": false,
    "openWorldHint": false
  }
}
```

| Annotation | Meaning | Use For |
|------------|---------|---------|
| `readOnlyHint` | Tool doesn't modify state | Get, list, search operations |
| `destructiveHint` | Tool performs destructive operations | Delete, drop, remove operations |
| `idempotentHint` | Multiple calls have same effect | Retry-safe operations |
| `openWorldHint` | Tool accesses external systems | API calls, network requests |

### Examples

**Read-only:**
```json
{
  "name": "get_config",
  "annotations": {
    "readOnlyHint": true,
    "destructiveHint": false
  }
}
```

**Destructive:**
```json
{
  "name": "delete_database",
  "annotations": {
    "readOnlyHint": false,
    "destructiveHint": true
  }
}
```

**Idempotent:**
```json
{
  "name": "ensure_user_exists",
  "annotations": {
    "idempotentHint": true
  }
}
```

---

## Naming Conventions

### Tool Names

- Use descriptive, action-oriented names
- Use snake_case for multi-word names
- Keep names concise but clear
- Avoid abbreviations

**Good:**
- `search_issues`
- `create_pull_request`
- `get_user_profile`
- `analyze_code`

**Avoid:**
- `search` (too vague)
- `crud_pr` (unclear)
- `getUserProfile` (camelCase, not snake_case)

### Parameter Names

- Use camelCase for JSON compatibility
- Be descriptive but concise
- Match parameter purpose

**Good:**
- `searchQuery`
- `maxResults`
- `includeDeleted`

---

## Testing Tools

### MCP Inspector

```bash
npx @modelcontextprotocol/inspector
```

Test MCP servers independently of Claude Code.

### Manual Testing

```python
# Test server directly
python server.py

# Verify:
# - Tool discovery
# - Tool schemas
# - Error handling
# - Input validation
```

### Test Cases

**Successful calls:**
```python
# Test with valid input
result = await handle_call_tool("search", {"query": "test"})
assert result["isError"] == False
```

**Error cases:**
```python
# Test with missing required field
result = await handle_call_tool("search", {})
assert result["isError"] == True
assert "required" in result["content"][0]["text"].lower()
```

**Edge cases:**
```python
# Test with empty results
result = await handle_call_tool("search", {"query": "nonexistent"})
# Verify graceful handling

# Test with special characters
result = await handle_call_tool("search", {"query": "\"; DROP TABLE;"})
# Verify sanitization
```

---

## Performance Optimization

### Caching

```python
from functools import lru_cache

@lru_cache(maxsize=128)
async def get_cached_resource(key):
    return await fetch_resource(key)
```

### Pagination

```python
{
  "name": "list_all_items",
  "inputSchema": {
    "properties": {
      "page": {"type": "number", "default": 1},
      "limit": {"type": "number", "maximum": 100, "default": 20}
    }
  }
}
```

### Batching

```python
# Good: Single batch call
items = await batch_get_items(item_ids)

# Avoid: Many individual calls
for item_id in item_ids:
    item = await get_item(item_id)
```

---

## Security Best Practices

### DO

✅ Validate all inputs against schema
✅ Sanitize user input
✅ Use parameterized queries for databases
✅ Implement rate limiting
✅ Log security events
✅ Use HTTPS for external calls
✅ Implement proper error handling
✅ Mask sensitive data in logs

### DON'T

❌ Trust user input without validation
❌ Expose sensitive data in errors
❌ Use unencrypted HTTP
❌ Hardcode credentials
❌ Execute arbitrary code
❌ Ignore errors silently
❌ Expose internal APIs

---

## Common Patterns

### API Integration

```json
{
  "name": "api_call",
  "description": "Call external API endpoint",
  "inputSchema": {
    "properties": {
      "endpoint": {"type": "string", "format": "uri"},
      "method": {
        "type": "string",
        "enum": ["GET", "POST", "PUT", "DELETE"]
      },
      "body": {"type": "object"}
    }
  }
}
```

### Database Query

```json
{
  "name": "execute_query",
  "description": "Execute SQL query with parameters",
  "inputSchema": {
    "properties": {
      "query": {"type": "string"},
      "params": {
        "type": "array",
        "items": {"type": ["string", "number", "boolean"]}
      }
    },
    "required": ["query"]
  }
}
```

### File Operations

```json
{
  "name": "read_file",
  "description": "Read file contents",
  "inputSchema": {
    "properties": {
      "path": {"type": "string"},
      "encoding": {"type": "string", "default": "utf-8"}
    },
    "required": ["path"]
  },
  "annotations": {
    "readOnlyHint": true
  }
}
```

---

## Additional Resources

- **[MCP Specification](https://modelcontextprotocol.io/)** - Official protocol docs
- **[MCP SDK](https://modelcontextprotocol.io/quickstart/server)** - SDK documentation
- **[references/primitives.md](primitives.md)** - Tools, Resources, Prompts overview
- **[references/transports.md](transports.md)** - HTTP and stdio transports
