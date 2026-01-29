# Runbook

## MCP Server Deployment

### mcp-llm-orchestrator

**Build:**

```bash
cd Custom_MCP/mcp-llm-orchestrator
pnpm run build
```

**Start:**

```bash
pnpm run start
```

**Location:** `Custom_MCP/mcp-llm-orchestrator/dist/index.js`

### simpleWebFetch

**Build:**

```bash
cd Custom_MCP/simpleWebFetch
pnpm run build
```

**Start:**

```bash
pnpm run start
```

**Location:** `Custom_MCP/simpleWebFetch/dist/server.js`

## CLAUDE.md Integration

CLAUDE.md components are loaded at session start:

- `.claude/rules/` - Behavioral principles
- `.claude/skills/` - Domain knowledge
- `.claude/commands/` - Intent shortcuts
- `.claude/agents/` - Autonomous workers

## Common Issues

### MCP Server Not Connecting

**Symptom**: Tools from MCP server unavailable

**Fix**:

1. Check `.mcp.json` configuration
2. Verify server is running (`pnpm run start`)
3. Restart Claude Code session

### TypeScript Compilation Errors

**Symptom**: Build fails with TypeScript errors

**Fix**:

1. Run `pnpm run build` to see errors
2. Check `tsconfig.json` for strict mode settings
3. Ensure dependencies installed (`pnpm install`)

### Port Conflicts

**Symptom**: "Address already in use" error

**Fix**:

1. Kill existing Node processes: `pkill -f "node.*server"`
2. Use different port if configurable
3. Check for stale processes: `lsof -i :PORT`

## Rollback Procedures

### Revert MCP Server

```bash
# Find working commit
git log --oneline -10

# Revert if needed
git revert <commit-hash>
git push
```

### Revert CLAUDE.md Components

```bash
# Restore from git
git checkout HEAD -- .claude/
```

## Monitoring

- Check server logs in `dist/` directory
- Claude Code session output for tool execution
- `.ralph/` directory for session history

---

**Reference**: See CLAUDE.md for complete project documentation.
