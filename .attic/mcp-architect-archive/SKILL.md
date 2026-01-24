---
name: mcp-architect
description: "Project-scoped .mcp.json router with multi-workflow orchestration. Automatically detects DISCOVER/INTEGRATE/VALIDATE/OPTIMIZE workflows. Routes to mcp-knowledge for configuration details."
---

# MCP Architect

## WIN CONDITION

**Called by**: toolkit-architect
**Purpose**: Configure MCP servers and integrations in .mcp.json

**Output**: Must output completion marker

```markdown
## MCP_ARCHITECT_COMPLETE

Workflow: [DISCOVER|INTEGRATE|VALIDATE|OPTIMIZE]
Quality Score: XX/100
Protocol Compliance: XX/100
Servers: [count] configured
Context Applied: [Summary]
```

**Completion Marker**: `## MCP_ARCHITECT_COMPLETE`

## RECOMMENDED: Context Validation

Read these URLs when accuracy matters for MCP integration work:

### Reference Files (read as needed):
1. `references/protocol-guide.md` - MCP specification and primitives
2. `references/transport-mechanisms.md` - stdio vs http patterns
3. `references/component-templates.md` - Tools, resources, prompts
4. `references/compliance-framework.md` - Protocol adherence scoring

### Primary Documentation
- **Official MCP Guide**: https://code.claude.com/docs/en/mcp
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: MCP integration patterns, tools, resources, prompts

- **MCP Specification**: https://modelcontextprotocol.io/
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Protocol definition, JSON-RPC 2.0, security principles

### When to Fetch vs Skip
**Fetch when**:
- Documentation may have changed since last read
- User requests verification of MCP patterns
- Starting new MCP server integration
- Uncertain about protocol compliance

**Skip when**:
- Simple server configuration following known patterns
- Local-only work without external dependencies
- Working offline
- Recently read and documentation is stable

**Trust your judgment**: You know when validation is needed for accurate MCP work.

## URL Validation Pattern

**For MCP integration with external references:**

When integrating MCP servers that reference external documentation:
```markdown
## RECOMMENDED: Context Validation

Read these URLs when accuracy matters for MCP integration work:

### Primary Documentation
- **Official MCP Guide**: https://code.claude.com/docs/en/mcp
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: MCP integration patterns, tools, resources, prompts

### When to Fetch vs Skip
**Fetch when**: Documentation may have changed, user requests verification, starting new integration
**Skip when**: Simple configuration based on known patterns, local-only work, recently read

**Trust your judgment**: You know when validation is needed for accurate MCP work.
```

**Implementation**:
1. Use RECOMMENDED pattern with clear decision criteria
2. Trust AI judgment on when to fetch vs skip
3. Focus on principles, not blocking rules

## Model Selection for MCP Workflows

When orchestrating MCP server configuration with TaskList, select model based on task complexity:

**Simple MCP Tasks (haiku)**:
- Single server validation
- Basic transport configuration checks
- Simple tool schema validation
- Quick compliance scans
- Cost-sensitive validation

**Default MCP Tasks (sonnet)**:
- Multi-server setup and validation
- Standard compliance validation
- Typical integration workflows
- Protocol adherence checking
- Balanced performance for most MCP work

**Complex MCP Tasks (opus)**:
- Multi-server architecture design
- Complex protocol compliance remediation
- Multi-phase optimization workflows
- Cross-server dependency management
- Critical security decisions

**Cost Optimization**: Use haiku for quick validation scans, escalate to opus only for complex architecture decisions.

**See task-knowledge**: [model-selection.md](task-knowledge/references/model-selection.md) for detailed cost optimization strategies.

## Multi-Workflow Detection Engine

Automatically detects and executes appropriate workflow:

```python
def detect_mcp_workflow(project_state, user_request):
    mcp_exists = exists(".mcp.json")
    project_type = analyze_project_type(project_state)
    integration_requested = "add" in user_request.lower() or "integrate" in user_request.lower()
    validation_requested = "audit" in user_request.lower() or "validate" in user_request.lower()

    if integration_requested:
        return "INTEGRATE"  # Add new MCP server
    elif validation_requested:
        return "VALIDATE"  # Check protocol compliance
    elif mcp_exists and has_issues():
        return "OPTIMIZE"  # Fix configuration problems
    else:
        return "DISCOVER"  # Analyze needs and suggest
```

**Detection Logic**:
1. **Add/integrate requested** → **INTEGRATE mode** (add new server)
2. **Audit/validate requested** → **VALIDATE mode** (check compliance)
3. **Existing .mcp.json with issues** → **OPTIMIZE mode** (fix problems)
4. **Default analysis** → **DISCOVER mode** (analyze needs)

## Core Philosophy

**Trust in AI Reasoning**:
- Provides context and examples, trusts AI to make intelligent decisions
- Uses clear detection logic instead of asking questions upfront
- Relies on completion markers for workflow verification

**Component-Aware Routing**:
- Automatically detects MCP server needs
- Safely merges into existing .mcp.json
- Validates protocol compliance

## Four Workflows

### DISCOVER Workflow - Analyze MCP Needs

**Use When:**
- Unclear what MCP servers are needed
- Project analysis phase
- Before adding any integrations
- Understanding current MCP landscape

**Why:**
- Identifies integration opportunities
- Maps existing MCP servers
- Suggests appropriate components
- Prevents unnecessary integrations

**Process:**
1. Scan project structure for integration candidates
2. List existing MCP servers (if any)
3. Identify service integration needs
4. Suggest appropriate components
5. Generate recommendation report

**Required References:**
- `references/protocol-guide.md#discover-workflow` - Analysis patterns
- `references/component-templates.md` - Component selection

**Example:** Project with API integrations → DISCOVER suggests appropriate MCP servers

---

### INTEGRATE Workflow - Add New MCP Server

**Use When:**
- Explicit add/integrate request
- New service integration needed
- User asks for MCP configuration
- Missing integration capability

**Why:**
- Creates properly configured MCP servers
- Safely merges into existing .mcp.json
- Validates protocol compliance
- Preserves existing configurations

**Process:**
1. Determine MCP component needed:
   - Tools - API wrappers
   - Resources - Data access
   - Prompts - Templates
   - Servers - Full integration
2. **Safely merge** into existing .mcp.json:
   - Read existing configuration
   - Parse as JSON
   - Add/merge new server
   - Validate syntax
   - Write back
3. Validate protocol compliance

**Required References:**
- `references/protocol-guide.md#integrate-workflow` - Integration patterns
- `references/compliance-framework.md` - Protocol validation

**Example:** User asks "Add web search" → INTEGRATE adds DuckDuckGo MCP server

**Concrete Example**:
```bash
# User says: "I need web search in this project"
# Integration automatically:
# 1. Detects INTEGRATE workflow
# 2. Adds DuckDuckGo MCP server to .mcp.json:
{
  "mcpServers": {
    "duckduckgo": {
      "transport": {
        "type": "stdio",
        "command": "npx",
        "args": ["-y", "duckduckgo-search-mcp"]
      }
    }
  }
}
# 3. Validates protocol compliance
# 4. Reports success
```

---

### VALIDATE Workflow - Protocol Compliance Check

**Use When:**
- Audit or validation requested
- Before deployment to production
- After MCP configuration changes
- Regular compliance check

**Why:**
- Ensures protocol adherence
- Validates transport configuration
- Checks component validity
- Provides compliance score

**Process:**
1. Read and parse .mcp.json
2. Validate against MCP specification
3. Check transport configuration
4. Verify component schemas
5. Generate compliance report

**Required References:**
- `references/compliance-framework.md` - Scoring dimensions
- `references/transport-mechanisms.md` - Transport validation

**Score-Based Actions:**
- 90-100 (A): Excellent compliance, no changes needed
- 75-89 (B): Good compliance, minor improvements
- 60-74 (C): Adequate compliance, OPTIMIZE recommended
- <60 (D/F): Poor compliance, OPTIMIZE required

**Example:** User asks "Audit my MCP setup" → VALIDATE with detailed report

**Concrete Example**:
```bash
# User says: "Check if my MCP configuration is correct"
# Validation automatically:
# 1. Reads .mcp.json
# 2. Checks each server configuration
# 3. Validates against MCP specification
# 4. Generates report:
## MCP Validation Complete

### Compliance Score: 85/100 (Grade: B)

### Issues:
- Server 'my-server': Missing required transport config (-10 points)
- Transport 'stdio': Missing 'command' field (-5 points)

### Recommendations:
1. Add transport.command to stdio servers
2. Validate JSON syntax
3. Test connection

### Protocol Adherence:
✓ Valid JSON structure
✗ Missing required fields
```

---

### OPTIMIZE Workflow - Performance Improvements

**Use When:**
- VALIDATE found issues (score <75)
- Protocol compliance problems
- Transport optimization needed
- Best practices not followed

**Why:**
- Fixes protocol violations
- Optimizes transport configuration
- Improves component schemas
- Ensures best practices

**Process:**
1. Review validation findings
2. Prioritize issues by severity
3. Fix protocol violations
4. Optimize transport
5. Re-validate improvements

**Required References:**
- `references/compliance-framework.md#optimization` - Fix strategies
- `references/transport-mechanisms.md#optimization` - Performance patterns

**Example:** VALIDATE found score 45/100 → OPTIMIZE to reach ≥80/100

**Concrete Example**:
```bash
# VALIDATE found issues:
# - Missing transport.command
# - Invalid JSON structure
# - No error handling

# OPTIMIZE automatically:
# 1. Fixes JSON syntax errors
# 2. Adds missing transport.command fields
# 3. Adds error handling patterns
# 4. Re-validates configuration

## MCP Optimization Complete

### Quality Score: 45 → 88/100 (+43 points)

### Changes Applied:
✓ Fixed JSON syntax errors (3 issues)
✓ Added missing transport.command (2 servers)
✓ Added error handling patterns
✓ Optimized transport configuration

### Improvements:
- Protocol compliance: 40% → 95%
- Error handling: Added validation
- Transport optimization: stdio configured correctly
```

## Quality Framework (5 Dimensions)

Scoring system (0-100 points):

| Dimension | Points | Focus |
|-----------|--------|-------|
| **1. Protocol Compliance** | 25 | Adherence to MCP specification |
| **2. Transport Configuration** | 20 | stdio/http setup correctness |
| **3. Component Validity** | 20 | Tools/Resources/Prompts schemas |
| **4. Security Hardening** | 15 | Security best practices |
| **5. Maintainability** | 20 | Configuration clarity and structure |

**Quality Thresholds**:
- **A (90-100)**: Exemplary protocol compliance
- **B (75-89)**: Good compliance with minor gaps
- **C (60-74)**: Adequate compliance, needs improvement
- **D (40-59)**: Poor compliance, significant issues
- **F (0-39)**: Failing compliance, critical errors

## MCP Components

### Tools
**Purpose**: Callable functions for operations
**Use When**: Need to expose operations or actions

**Example**:
```json
{
  "name": "web-search",
  "tools": {
    "search": {
      "description": "Search the web for information",
      "inputSchema": {
        "type": "object",
        "properties": {
          "query": {"type": "string"}
        }
      }
    }
  }
}
```

### Resources
**Purpose**: Read-only data access
**Use When**: Need to provide data access

**Example**:
```json
{
  "name": "filesystem",
  "resources": {
    "file://{path}": {
      "description": "Access project files",
      "mimeType": "text/plain"
    }
  }
}
```

### Prompts
**Purpose**: Reusable workflow templates
**Use When**: Need predefined prompt templates

**Example**:
```json
{
  "name": "code-templates",
  "prompts": {
    "code-review": {
      "description": "Review code for issues",
      "arguments": [
        {"name": "language", "required": false}
      ]
    }
  }
}
```

### Servers
**Purpose**: Full MCP server implementation
**Use When**: Multi-component integration

## Transport Mechanisms

### stdio (Local)
- Local process execution via standard input/output
- Use for: Development, testing, single-user scenarios
- Configuration: `claude mcp add --transport stdio <name> -- <command> [args...]`

### http (Remote)
- Hosted services with bidirectional streaming
- Use for: Production deployments, multi-user, high availability
- Configuration: `claude mcp add --transport http <name> <url>`

## Workflow Selection Quick Guide

**"I need an MCP server"** → INTEGRATE
**"Check my MCP setup"** → VALIDATE
**"Fix MCP issues"** → OPTIMIZE
**"What MCP do I need?"** → DISCOVER

## Output Contracts

For complete output contract templates and examples for all workflows, see **[references/output-contracts.md](references/output-contracts.md)**.

## Task-Integrated Compliance Workflow

For complex MCP validation requiring visual progress tracking and dependency enforcement, use TaskList integration patterns.

For detailed TaskList workflow patterns and 2026 MCP features reference, see **[references/tasklist-compliance.md](references/tasklist-compliance.md)**.

