# MCP Tool Development

**For complete MCP tool development, fetch the official documentation:**

```bash
curl -s https://code.claude.com/docs/en/mcp.md
```

This reference contains only unique implementation patterns not covered in official docs.

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
