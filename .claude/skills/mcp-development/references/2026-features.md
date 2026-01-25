# MCP 2026 Features

Complete guide to new MCP features in Claude Code 2026.

---

## Overview

Claude Code 2026 introduces several new MCP capabilities:
- **MCP Tool Search** - Dynamic tool loading
- **MCP Resources** - @-mentionable data
- **MCP Prompts** - Slash command workflows
- **Managed MCP** - Enterprise control
- **Output limits** - Configurable token limits

---

## MCP Tool Search

### Purpose

Dynamically load MCP tools on-demand instead of preloading all tools. Reduces context window usage when many MCP servers are configured.

### How It Works

**Automatic activation:**
- Activates when tool descriptions exceed 10% of context window
- MCP tools deferred rather than loaded upfront
- Claude uses search tool to discover relevant tools when needed
- Only needed tools loaded into context

**User experience:**
- MCP tools work exactly as before
- No configuration needed for most users
- Automatic based on context usage

### Configuration

**Environment variable:** `ENABLE_TOOL_SEARCH`

| Value | Behavior |
|------|----------|
| `auto` | Activates when tools exceed 10% of context (default) |
| `auto:<N>` | Activates at custom threshold (percentage) |
| `true` | Always enabled |
| `false` | Disabled, all tools loaded upfront |

**Examples:**
```bash
# Default mode
ENABLE_TOOL_SEARCH=auto claude

# Custom 5% threshold
ENABLE_TOOL_SEARCH=auto:5 claude

# Always enabled
ENABLE_TOOL_SEARCH=true claude

# Disabled
ENABLE_TOOL_SEARCH=false claude
```

**Via settings.json:**
```json
{
  "env": {
    "ENABLE_TOOL_SEARCH": "auto:5"
  }
}
```

**Disabling MCPSearch tool:**
```json
{
  "permissions": {
    "deny": ["MCPSearch"]
  }
}
```

### Model Requirements

**Requires:** Models that support `tool_reference` blocks
- Sonnet 4 and later
- Opus 4 and later
- Haiku models do NOT support tool search

### For Server Authors

Tool Search makes server instructions more important. Add clear, descriptive server instructions that explain:
- What category of tasks your tools handle
- When Claude should search for your tools
- Key capabilities your server provides

**Example server instructions:**
```
This server provides GitHub integration tools for:
- Creating and managing pull requests
- Reading and reviewing code
- Managing issues and projects

Search for these tools when working with GitHub repositories,
code reviews, or issue tracking.
```

### Benefits

- **Reduced context usage:** Only relevant tools loaded
- **Better scalability:** Support many more MCP servers
- **Faster startup:** Less initial tool loading
- **Improved performance:** Smaller context windows

---

## MCP Resources

### Purpose

Read-only data accessible via @-mentions, similar to file references.

### Access Format

```
@server:protocol://resource/path
```

### Discovery

Type `@` in your prompt to see available resources from all connected MCP servers. Resources appear alongside files in the autocomplete menu.

### Examples

**GitHub issue:**
```
Can you analyze @github:issue://123 and suggest a fix?
```

**Database schema:**
```
Compare @postgres:schema://users with @docs:file://database/user-model
```

**Documentation:**
```
Please review the API documentation at @docs:file://api/authentication
```

**Multiple references:**
```
Compare the designs in @figma:file://design/v2 with @docs:file://requirements
```

### Features

- **Automatic fetching:** Resources fetched and included as attachments
- **Fuzzy search:** Resource paths fuzzy-searchable in autocomplete
- **Any content type:** Text, JSON, structured data, etc.
- **Read-only:** Resources cannot be modified

### Resource Schema

Resources defined by MCP server:

```json
{
  "uri": "issue://123",
  "name": "issue-123",
  "description": "Issue #123: Fix authentication bug",
  "mimeType": "application/json"
}
```

### Use Cases

- **Configuration files:** `@config:file://settings`
- **Database schemas:** `@db:schema://users`
- **API documentation:** `@docs:file://api/endpoint`
- **Code references:** `@repo:file://src/main.ts`
- **Test fixtures:** `@fixtures:file://test-data.json`

### Best Practices

1. **Use descriptive URIs** - Clear resource paths
2. **Provide meaningful descriptions** - Help users understand content
3. **Set correct MIME types** - Enable proper formatting
4. **Keep resources updated** - Ensure data freshness

---

## MCP Prompts

### Purpose

Reusable workflows exposed as slash commands. Prompts provide predefined templates for common operations.

### Command Format

```
/mcp__servername__promptname [arguments...]
```

### Discovery

Type `/` to see all available commands, including MCP prompts. MCP prompts appear with the format `/mcp__servername__promptname`.

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

**In conversation:**
```
> /mcp__github__list_prs

[Prompt results injected]

> Now review the first one
```

### Argument Parsing

Arguments are space-separated and parsed based on prompt's defined parameters.

**Example prompt definition:**
```json
{
  "name": "create_issue",
  "arguments": [
    {"name": "title", "required": true},
    {"name": "priority", "required": false},
    {"name": "assignee", "required": false}
  ]
}
```

**Usage:**
```bash
/mcp__tracker__create_issue "Fix crash" critical "john.doe"
```

**Parsed as:**
- `title` = "Fix crash"
- `priority` = "critical"
- `assignee` = "john.doe"

### Prompt Results

Results injected directly into conversation, just like command output.

### Prompt Schema

Prompts defined by MCP server:

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

### Use Cases

- **Common workflows:** Create issue, review PR, deploy
- **Standardized queries:** List tasks, get status
- **Template operations:** Generate report, summarize
- **Multi-step procedures:** Analyze, test, document

### Best Practices

1. **Use descriptive prompt names** - Clear purpose
2. **Document argument purposes** - Help users understand
3. **Handle optional arguments** - Provide defaults
4. **Return formatted results** - Readable output
5. **Normalize names** - Spaces become underscores

---

## Output Limits

### Purpose

Manage token usage when MCP tools produce large outputs.

### Limits

| Setting | Default | Description |
|---------|---------|-------------|
| **Warning threshold** | 10,000 tokens | Display warning when exceeded |
| **Maximum limit** | 25,000 tokens | Default maximum output |

### Configuration

**Environment variable:** `MAX_MCP_OUTPUT_TOKENS`

```bash
# Set higher limit
export MAX_MCP_OUTPUT_TOKENS=50000
claude
```

**Via settings.json:**
```json
{
  "env": {
    "MAX_MCP_OUTPUT_TOKENS": "50000"
  }
}
```

### Use Cases

**Large dataset queries:**
- Database queries returning many rows
- Log file analysis
- Report generation

**Documentation:**
- API documentation fetching
- Code analysis results
- Test output

### Best Practices

1. **Increase limit only when needed** - Prevents bloat
2. **Implement pagination in tools** - Reduce output size
3. **Filter results at source** - Don't fetch everything
4. **Use tool search** - Load only needed tools

---

## Managed MCP

### Purpose

Enterprise control over which MCP servers users can configure.

### Configuration Options

**Option 1: Exclusive control (managed-mcp.json)**
- Deploy fixed set of MCP servers
- Users cannot add/modify/remove servers

**Option 2: Allowlists/denylists**
- Users can add servers within policy
- Restrict which servers permitted

### Option 1: managed-mcp.json

**File locations:**
- macOS: `/Library/Application Support/ClaudeCode/managed-mcp.json`
- Linux/WSL: `/etc/claude-code/managed-mcp.json`
- Windows: `C:\Program Files\ClaudeCode\managed-mcp.json`

**Format:**
```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/"
    },
    "sentry": {
      "type": "http",
      "url": "https://mcp.sentry.dev/mcp"
    },
    "company-internal": {
      "type": "stdio",
      "command": "/usr/local/bin/company-mcp-server",
      "args": ["--config", "/etc/company/mcp-config.json"]
    }
  }
}
```

**Effect:**
- Only listed servers available
- Users cannot add servers
- Users cannot modify .mcp.json

### Option 2: Allowlists/Denylists

**Configuration file:** Managed settings file

**Restriction types:**
1. **By server name** (`serverName`)
2. **By command** (`serverCommand`) - exact match
3. **By URL pattern** (`serverUrl`) - wildcards supported

**Example:**
```json
{
  "allowedMcpServers": [
    {"serverName": "github"},
    {"serverName": "sentry"},
    {"serverCommand": ["npx", "-y", "@modelcontextprotocol/server-filesystem"]},
    {"serverUrl": "https://mcp.company.com/*"},
    {"serverUrl": "https://*.internal.corp/*"}
  ],
  "deniedMcpServers": [
    {"serverName": "dangerous-server"},
    {"serverCommand": ["npx", "-y", "unapproved-package"]},
    {"serverUrl": "https://*.untrusted.com/*"}
  ]
}
```

### Restriction Behavior

**By server name:**
```json
{"serverName": "github"}
```
- Matches: Any server named "github"
- Applies to: All transport types

**By command (stdio only):**
```json
{"serverCommand": ["npx", "-y", "approved-package"]}
```
- Matches: Exact command and arguments
- Order matters
- Applies to: stdio servers only

**By URL pattern (HTTP only):**
```json
{"serverUrl": "https://mcp.company.com/*"}
```
- Matches: URL pattern with wildcards
- `*` matches any sequence
- Applies to: HTTP servers

### Allowlist Behavior

| Value | Behavior |
|-------|----------|
| `undefined` | No restrictions |
| `[]` | Complete lockdown |
| List of entries | Only matching servers allowed |

### Denylist Behavior

| Value | Behavior |
|-------|----------|
| `undefined` | No servers blocked |
| `[]` | No servers blocked |
| List of entries | Specified servers blocked |

### Precedence

**Denylist takes absolute precedence**
- If server matches denylist, blocked even if on allowlist
- Override mechanism for security

**Matching rules:**
- Server passes if matches name OR command OR URL
- Unless blocked by denylist

---

## Dynamic Tool Updates

### list_changed Notification

MCP servers can send `list_changed` notifications to indicate their tools, prompts, or resources have changed.

**Behavior:**
- Claude Code automatically refreshes capabilities
- No disconnect/reconnect required
- Seamless update experience

**Use cases:**
- Server adds new tools
- Server updates tool schemas
- Server removes deprecated capabilities

---

## Environment Variables Summary

| Variable | Purpose | Default |
|----------|---------|---------|
| `ENABLE_TOOL_SEARCH` | Tool search behavior | `auto` |
| `MAX_MCP_OUTPUT_TOKENS` | Maximum MCP output | `25000` |
| `MCP_TIMEOUT` | Server startup timeout (ms) | System default |

---

## Feature Compatibility

| Feature | Sonnet 4+ | Opus 4+ | Haiku |
|---------|-----------|---------|-------|
| Tool Search | ✅ | ✅ | ❌ |
| Resources (@) | ✅ | ✅ | ✅ |
| Prompts (/) | ✅ | ✅ | ✅ |
| Managed MCP | ✅ | ✅ | ✅ |
| Output limits | ✅ | ✅ | ✅ |

---

## Migration Guide

### From Static Tool Loading

**Before:** All tools loaded at startup
**After:** Tools loaded on-demand (when ENABLE_TOOL_SEARCH=auto)

**No changes needed** - automatic behavior

### Enabling Tool Search

```bash
# Check current tool count
/mcp

# If many tools, enable tool search
export ENABLE_TOOL_SEARCH=auto:5
claude
```

### Setting Output Limits

```bash
# Check for warnings
# If MCP output warnings appear:

export MAX_MCP_OUTPUT_TOKENS=50000
claude
```

---

## Additional Resources

- **[SKILL.md](../SKILL.md)** - MCP development overview
- **[references/primitives.md](primitives.md)** - Tools, Resources, Prompts
- **[references/transports.md](transports.md)** - HTTP and stdio transports
- **[Claude Code MCP Docs](https://code.claude.com/docs/en/mcp)** - Official documentation
