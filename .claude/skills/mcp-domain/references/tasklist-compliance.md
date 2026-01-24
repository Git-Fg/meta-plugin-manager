# Task-Integrated Compliance Workflow

For complex MCP validation requiring visual progress tracking and dependency enforcement, use TaskList integration:

## When to Use

- Multi-server validation (3+ servers to validate)
- VALIDATE workflow with dependency tracking
- OPTIMIZE workflow dependent on VALIDATE completion
- Need visual progress tracking (Ctrl+T)
- Protocol compliance tracking across iterations

## VALIDATE Workflow

Use TaskCreate to establish an .mcp.json configuration scan task. Then use TaskCreate to set up parallel validation tasks for server protocols, tool schemas, and resource access — configure these to depend on the scan completion. Use TaskCreate to establish a validation report generation task that depends on all validation phases completing. Use TaskUpdate to mark tasks complete as each phase finishes, and use TaskList to check overall progress.

## OPTIMIZE Workflow (depends on VALIDATE)

After the validation report task completes, use TaskCreate to establish a findings review task that depends on the validation report. Then use TaskCreate to set up optimization prioritization, server optimization, and re-validation tasks in sequence, each depending on the previous. Use TaskList to track optimization progress and use TaskUpdate to mark tasks complete.

## Critical Dependency

Optimization tasks must be configured to depend on the validation report task completing, ensuring fixes are based on actual performance findings.

## Task Tracking Provides

- Visual compliance validation progression (visible in Ctrl+T)
- Dependency enforcement (optimization tasks blocked by validation)
- Persistent protocol compliance tracking across cycles
- Clear phase completion markers

## 2026 MCP Features

- **Tool Search**: Auto-enabled when tools exceed 10% of context
- **MCP Resources**: Referenced via `@server:protocol://resource/path` syntax
- **MCP Prompts**: Available as `/mcp__servername__promptname` commands
- **Plugin MCP**: Plugins bundle MCP servers via `.mcp.json` or `plugin.json`
- **Dynamic Tool Updates**: Supports `list_changed` notifications
- **MCP Output Limits**: Default 25,000 tokens, configurable via `MAX_MCP_OUTPUT_TOKENS`
- **Environment Variables**: `${CLAUDE_PLUGIN_ROOT}` for plugin paths
