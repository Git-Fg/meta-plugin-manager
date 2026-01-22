---
name: mcp-architect
description: ".mcp.json router for external tools and service integrations. Use for creating, auditing, or refining MCP servers with external API access. Routes to mcp-knowledge for configuration details. Do not use for internal plugin development or simple file operations."
disable-model-invocation: true
---

# MCP Architect

Domain router for Model Context Protocol (MCP) integrations with external service access focus.

## Actions

### create
**Creates new MCP integrations** for external services

**Router Logic**:
1. Determine MCP component:
   - Tools - API wrappers
   - Resources - Data access
   - Prompts - Templates
   - Servers - Full integration
2. Route to appropriate knowledge:
   - mcp-tools → Tool creation
   - mcp-resources-prompts → Resource/prompt creation
   - mcp-servers → Server configuration
   - mcp-integration → Integration patterns
3. Generate with protocol compliance

**Output Contract**:
```
## MCP Component Created: {component_name}

### Type: {type}
- Tools: {count}
- Resources: {count}
- Prompts: {count}

### Transport: {transport}
- Configuration: ✅
- Validation: ✅

### Integration Scope
- {integration_1}
- {integration_2}
```

### audit
**Audits MCP integrations** for protocol compliance

**Router Logic**:
1. Load: mcp-integration
2. Check:
   - Protocol adherence
   - Transport configuration
   - Tool/resource/prompt validity
   - Security considerations
3. Generate audit with compliance scoring

**Output Contract**:
```
## MCP Audit: {component_name}

### Protocol Compliance
- Specification: {version}
- Adherence: {score}/10

### Components
- Tools: {tool_count} ({valid_count} valid)
- Resources: {resource_count} ({valid_count} valid)
- Prompts: {prompt_count} ({valid_count} valid)

### Transport
- Type: {transport}
- Configuration: ✅/❌

### Issues
- {issue_1}
- {issue_2}
```

### refine
**Improves MCP integrations** based on audit findings

**Router Logic**:
1. Load: mcp-integration, relevant mcp-* skill
2. Enhance:
   - Protocol compliance
   - Transport optimization
   - Component validation
   - Security hardening
3. Validate improvements

**Output Contract**:
```
## MCP Refined: {component_name}

### Protocol Improvements
- {improvement_1}
- {improvement_2}

### Component Enhancements
- {enhancement_1}
- {enhancement_2}

### Compliance Score: {old_score} → {new_score}/10
```

## MCP Components

**Tools**:
- External API wrappers
- Service integrations
- Data transformation

**Resources**:
- Data access patterns
- File system access
- Network resources

**Prompts**:
- Template management
- Dynamic generation
- Context injection

**Servers**:
- Full MCP server implementation
- Multi-component integration
- Transport management

## Knowledge Routing

See [MCP Knowledge](references/mcp-knowledge.md) for component patterns and implementation details.

**Component Overview**:
- **mcp-tools** - Tool creation and API wrappers
- **mcp-resources-prompts** - Resource and prompt patterns
- **mcp-servers** - Server configuration and transport
- **mcp-integration** - Integration best practices

## Routing Criteria

**Route to mcp-tools** when:
- Creating API wrappers
- Tool pattern questions
- Service integration

**Route to mcp-resources-prompts** when:
- Resource access patterns
- Prompt template management
- Context injection

**Route to mcp-servers** when:
- Server configuration
- Transport setup
- Protocol implementation

**Route to mcp-integration** when:
- Integration patterns
- Best practices
- Architecture questions
