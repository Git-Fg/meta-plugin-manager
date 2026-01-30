# MCP Authentication Patterns

## Navigation

| If you need... | Read this section... |
| :------------- | :------------------- |
| OAuth setup | ## OAuth (Automatic) |
| Environment tokens | ## Environment Token Authentication |
| Bearer tokens | ## Bearer Token Authentication |
| Best practices | ## PATTERN: Authentication Best Practices |
| Common mistakes | ## ANTI-PATTERN: Authentication Mistakes |

---

## Overview

MCP servers support multiple authentication methods depending on the server type and service requirements. Choose the method that best matches your use case and security requirements.

---

## OAuth (Automatic)

### How It Works

Claude Code automatically handles the complete OAuth 2.0 flow for HTTP servers:

1. User attempts to use MCP tool
2. Claude Code detects authentication needed
3. Opens browser for OAuth consent
4. User authorizes in browser
5. Tokens stored securely by Claude Code
6. Automatic token refresh

### Configuration

```json
{
  "mcpServers": {
    "service": {
      "type": "http",
      "url": "https://mcp.example.com/mcp"
    }
  }
}
```

No additional auth configuration needed! Claude Code handles everything.

Use `/mcp` within Claude Code to authenticate when needed.

### Supported Services

**Known OAuth-enabled MCP servers:**
- Sentry: `https://mcp.sentry.dev/mcp`
- GitHub: `https://api.githubcopilot.com/mcp/`
- Asana: `https://mcp.asana.com/mcp`
- Notion: `https://mcp.notion.com/mcp`
- Other cloud services with OAuth

### OAuth Scopes

OAuth scopes are determined by the MCP server. Users see required scopes during the consent flow.

**Document required scopes in your README:**
```markdown
## Authentication

This plugin requires the following permissions:
- Read tasks and projects
- Create and update tasks
- Access workspace data
```

### Token Storage

Tokens are stored securely by Claude Code:
- Not accessible to plugins
- Encrypted at rest
- Automatic refresh
- Cleared on sign-out

### Troubleshooting OAuth

**Authentication loop:**
- Clear cached tokens (sign out and sign in)
- Check OAuth redirect URLs
- Verify server OAuth configuration

**Scope issues:**
- User may need to re-authorize for new scopes
- Check server documentation for required scopes

**Token expiration:**
- Claude Code auto-refreshes
- If refresh fails, prompts re-authentication

---

## Token-Based Authentication

### Bearer Tokens

Most common for HTTP servers.

**Configuration:**
```json
{
  "mcpServers": {
    "api": {
      "type": "http",
      "url": "https://api.example.com/mcp",
      "headers": {
        "Authorization": "Bearer ${API_TOKEN}"
      }
    }
  }
}
```

**Environment variable:**
```bash
export API_TOKEN="your-secret-token-here"
```

### API Keys

Alternative to Bearer tokens, often in custom headers.

**Configuration:**
```json
{
  "mcpServers": {
    "api": {
      "type": "http",
      "url": "https://api.example.com/mcp",
      "headers": {
        "X-API-Key": "${API_KEY}",
        "X-API-Secret": "${API_SECRET}"
      }
    }
  }
}
```

### Custom Headers

Services may use custom authentication headers.

**Configuration:**
```json
{
  "mcpServers": {
    "service": {
      "type": "http",
      "url": "https://mcp.example.com/mcp",
      "headers": {
        "X-Auth-Token": "${AUTH_TOKEN}",
        "X-User-ID": "${USER_ID}",
        "X-Tenant-ID": "${TENANT_ID}"
      }
    }
  }
}
```

### Documenting Token Requirements

Always document in your README:

```markdown
## Setup

### Required Environment Variables

Set these environment variables before using the plugin:

```bash
export API_TOKEN="your-token-here"
export API_SECRET="your-secret-here"
```

### Obtaining Tokens

1. Visit https://api.example.com/tokens
2. Create a new API token
3. Copy the token and secret
4. Set environment variables as shown above

### Token Permissions

The API token needs the following permissions:
- Read access to resources
- Write access for creating items
- Delete access (optional, for cleanup operations)
```

---

## Environment Variable Authentication (stdio)

### Passing Credentials to Server

For stdio servers, pass credentials via environment variables:

**Configuration:**
```json
{
  "mcpServers": {
    "database": {
      "command": "python",
      "args": ["-m", "mcp_server_db"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}",
        "DB_USER": "${DB_USER}",
        "DB_PASSWORD": "${DB_PASSWORD}"
      }
    }
  }
}
```

### User Environment Variables

```bash
# User sets these in their shell
export DATABASE_URL="postgresql://localhost/mydb"
export DB_USER="myuser"
export DB_PASSWORD="mypassword"
```

### Documentation Template

```markdown
## Database Configuration

Set these environment variables:

```bash
export DATABASE_URL="postgresql://host:port/database"
export DB_USER="username"
export DB_PASSWORD="password"
```

Or create a `.env` file (add to `.gitignore`):

```env
DATABASE_URL=postgresql://localhost:5432/mydb
DB_USER=myuser
DB_PASSWORD=mypassword
```

Load with: `source .env` or `export $(cat .env | xargs)`
```

---

## Multi-Tenancy Patterns

### Workspace/Tenant Selection

**Via environment variable:**
```json
{
  "mcpServers": {
    "api": {
      "type": "http",
      "url": "https://api.example.com/mcp",
      "headers": {
        "Authorization": "Bearer ${API_TOKEN}",
        "X-Workspace-ID": "${WORKSPACE_ID}"
      }
    }
  }
}
```

**Via URL:**
```json
{
  "mcpServers": {
    "api": {
      "type": "http",
      "url": "https://${TENANT_ID}.api.example.com/mcp"
    }
  }
}
```

### Per-User Configuration

Users set their own workspace:

```bash
export WORKSPACE_ID="my-workspace-123"
export TENANT_ID="my-company"
```

---

## Advanced Authentication

### JWT Tokens

Generate JWT tokens dynamically with headers helper:

```bash
#!/bin/bash
# generate-jwt.sh

# Generate JWT (using library or API call)
JWT=$(generate-jwt-token)

echo "{\"Authorization\": \"Bearer $JWT\"}"
```

**Note:** Claude Code does not currently support headersHelper scripts. Use static tokens or OAuth.

### HMAC Signatures

For APIs requiring request signing, implement signing in the MCP server itself rather than in configuration.

---

## PATTERN: Authentication Best Practices

### DO

✅ **Use environment variables:**
```json
{
  "headers": {
    "Authorization": "Bearer ${API_TOKEN}"
  }
}
```

✅ **Document required variables in README**

✅ **Use HTTPS always**

✅ **Implement token rotation**

✅ **Store tokens securely (env vars, not files)**

✅ **Let OAuth handle authentication when available**

✅ **Use .env files (gitignored) for development**

❌ **DON'T:**

❌ **Hardcode tokens:**
```json
{
  "headers": {
    "Authorization": "Bearer sk-abc123..."  // NEVER!
  }
}
```

❌ **Commit tokens to git**

❌ **Share tokens in documentation**

❌ **Use HTTP instead of HTTPS**

❌ **Store tokens in plugin files**

❌ **Log tokens or sensitive headers**

❌ **Use .env files in production (git commits)**

---

## Authentication Troubleshooting

### Common Issues

**401 Unauthorized:**
- Check token is set correctly
- Verify token hasn't expired
- Check token has required permissions
- Ensure header format is correct

**403 Forbidden:**
- Token valid but lacks permissions
- Check scope/permissions
- Verify workspace/tenant ID
- May need admin approval

**Token not found:**
```bash
# Check environment variable is set
echo $API_TOKEN

# If empty, set it
export API_TOKEN="your-token"
```

**Token in wrong format:**
```json
// Correct
"Authorization": "Bearer sk-abc123"

// Wrong
"Authorization": "sk-abc123"
```

### Debugging Authentication

**Enable debug mode:**
```bash
claude --debug
```

Look for:
- Authentication header values (sanitized)
- OAuth flow progress
- Token refresh attempts
- Authentication errors

**Test authentication separately:**
```bash
# Test HTTP endpoint
curl -H "Authorization: Bearer $API_TOKEN" \
     https://api.example.com/mcp/health

# Should return 200 OK
```

---

## Migration Patterns

### From Hardcoded to Environment Variables

**Before:**
```json
{
  "headers": {
    "Authorization": "Bearer sk-hardcoded-token"
  }
}
```

**After:**
```json
{
  "headers": {
    "Authorization": "Bearer ${API_TOKEN}"
  }
}
```

**Migration steps:**
1. Add environment variable to plugin README
2. Update configuration to use ${VAR}
3. Test with variable set
4. Remove hardcoded value
5. Commit changes

### From SSE to HTTP

**Before:**
```json
{
  "type": "sse",
  "url": "https://mcp.example.com/sse"
}
```

**After:**
```json
{
  "type": "http",
  "url": "https://mcp.example.com/mcp"
}
```

**Benefits:**
- Better security
- Simpler authentication
- Wider compatibility
- Active development

---

## Managed MCP Authentication

For organizations, Claude Code supports managed MCP configuration with allowlists and denylists.

**Allowlist configuration:**
```json
{
  "allowedMcpServers": [
    { "serverName": "github" },
    { "serverUrl": "https://mcp.company.com/*" },
    { "serverCommand": ["npx", "-y", "approved-package"] }
  ]
}
```

See [references/2026-features.md](2026-features.md) for managed MCP details.

---

## Best Practices Summary

### For Plugin Developers

1. **Prefer OAuth** when service supports it
2. **Use environment variables** for tokens
3. **Document all required variables** in README
4. **Provide setup instructions** with examples
5. **Never commit credentials**
6. **Use HTTPS only**
7. **Test authentication thoroughly**

### For Plugin Users

1. **Set environment variables** before using plugin
2. **Keep tokens secure** and private
3. **Rotate tokens regularly**
4. **Use different tokens** for dev/prod
5. **Don't commit .env files** to git
6. **Review OAuth scopes** before authorizing
7. **Clear authentication** when done (`/mcp` → Clear authentication)

---

## Conclusion

Choose the authentication method that matches your MCP server's requirements:
- **OAuth** for cloud services (easiest for users)
- **Bearer tokens** for API services
- **Environment variables** for stdio servers
- **Custom headers** for complex auth flows

Always prioritize security and provide clear setup documentation for users.
