# Hooks Knowledge Reference

## Hooks Routing

The hooks-architect skill provides event handling patterns, security best practices, and infrastructure integration guidance. Currently, this knowledge is embedded in CLAUDE.md documentation.

## Hook Types

### Session Hooks
- **SessionStart**: Initialize session state
- **SessionEnd**: Cleanup resources

### Tool Hooks
- **PreToolUse**: Validate before execution
- **PostToolUse**: Process results

### Validation Hooks
- **PreWrite**: Validate file operations
- **PreEdit**: Validate modifications

### Infrastructure Hooks
- MCP configuration
- LSP setup
- Environment preparation

## Security Best Practices

- Input validation and sanitization
- Event pattern matching safety
- Error handling and recovery
- Performance impact monitoring

## Implementation Status

Hooks knowledge is **conceptually organized** in the hooks-architect hub. For detailed implementation patterns, refer to:
- CLAUDE.md Hooks section
- Official Hooks documentation
- Hook examples with event automation

## Usage Pattern

```markdown
When routing from hooks-architect hub:
→ See CLAUDE.md for event handling patterns
→ Refer to official hooks documentation for security
```
