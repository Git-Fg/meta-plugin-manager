# MCP Integration Decision Guide

## Table of Contents

- [🚨 MANDATORY: Read BEFORE Proceeding](#mandatory-read-before-proceeding)
- [When to Use MCP](#when-to-use-mcp)
- [Quick Decision Matrix](#quick-decision-matrix)
- [MCP Primitives Overview](#mcp-primitives-overview)
- [Transport Mechanisms](#transport-mechanisms)
- [Implementation Path](#implementation-path)
- [Official MCP Servers](#official-mcp-servers)
- [Key Takeaways](#key-takeaways)

Determine when Model Context Protocol (MCP) is the right choice for your integration needs.

## RECOMMENDED: Context Validation

Read these URLs when accuracy matters for MCP integration work:

### Primary Documentation
- **Official MCP Guide**: https://code.claude.com/docs/en/mcp
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: MCP integration patterns, tools, resources, prompts

- **MCP Specification**: https://modelcontextprotocol.io/
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Protocol definition, transport mechanisms, primitives

### When to Fetch vs Skip
**Fetch when**:
- Documentation may have changed since last read
- User requests verification of MCP patterns
- Starting new MCP server integration
- Uncertain about protocol compliance

**Skip when**:
- Simple MCP configuration based on known patterns
- Local-only work without external dependencies
- Working offline
- Recently read and documentation is stable

**Trust your judgment**: You know when validation is needed for accurate MCP integration.

## When to Use MCP

### ✅ Use MCP For
- External service integration (APIs, databases, services)
- Custom tool creation and sharing
- Resource and data access
- Predefined workflow automation
- Protocol-standardized tool exchange
- Multi-client compatibility needed
- Complex integrations requiring type safety

### ❌ Don't Use MCP For
- Simple API calls (use skills with direct HTTP)
- One-off operations
- Basic file operations (use native tools)
- Single-project only functionality
- Temporary or experimental features

## Quick Decision Matrix

| Need                        | Use MCP? | Alternative     |
| --------------------------- | -------- | --------------- |
| Share tools across projects | ✅ Yes    | No              |
| Integrate external API      | ✅ Yes    | Skill with HTTP |
| Simple file read/write      | ❌ No     | Native tools    |
| Custom workflow automation  | ✅ Yes    | Command/Skill   |
| Database query interface    | ✅ Yes    | Skill with SQL  |
| Local script execution      | ❌ No     | Bash/Command    |

## MCP Primitives Overview

### 1. Tools
Callable functions exposed by MCP servers
- Named functions with input/output schemas
- Invoked by Claude Code as needed
- Format: `ServerName:tool_name`

### 2. Resources
Read-only data accessible via MCP servers
- URI-based identification
- Content retrieval on demand
- Cached by Claude Code

### 3. Prompts
Predefined workflows from MCP servers
- Reusable prompt templates
- Parameterized workflows
- Shared across sessions

## Transport Mechanisms

### stdio
Local process execution via standard input/output
- Use for: Local MCP server implementation
- Best for: Development, testing, single-user scenarios

### Streamable HTTP
Hosted services with bidirectional streaming
- Use for: Cloud-based servers, production deployments
- Best for: Multi-user, shared instances, high availability

## Implementation Path

### Step 1: Choose Pattern
- **Tool-based**: Exposing callable functions
- **Resource-based**: Providing data access
- **Prompt-based**: Predefined workflows
- **Full Integration**: All three primitives

### Step 2: Select Transport
- **stdio**: Local development, testing
- **Streamable HTTP**: Production, cloud hosting

### Step 3: Implementation
See related guides:
- **[servers.md](servers.md)** - Server configuration and setup
- **[tools.md](tools.md)** - Tool development and schemas
- **[resources.md](resources.md)** - Resources and prompts

## Official MCP Servers

Consider official servers before building custom:
- **Context7**: Knowledge base integration
- **DeepWiki**: Documentation analysis
- **DuckDuckGo**: Web search (privacy-focused)

See **[servers.md](servers.md)** for configuration details.

## Key Takeaways

1. **Use MCP** for shareable, protocol-standardized integrations
2. **Use skills** for project-specific, direct integrations
3. **Use native tools** for basic file operations
4. **Choose transport** based on deployment needs
5. **Start with official servers** before building custom

See **[servers.md](servers.md)** to configure your first MCP integration.
