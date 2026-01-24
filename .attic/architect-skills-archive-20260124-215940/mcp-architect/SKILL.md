---
name: mcp-architect
description: "Integrate external APIs and tools via Model Context Protocol (MCP). Automatically detects DISCOVER/INTEGRATE/VALIDATE/OPTIMIZE workflows. Configure MCP servers in .mcp.json for tools, resources, and prompts."
user-invocable: false
---

# MCP Domain

## WIN CONDITION

**Called by**: User directly (no intermediate router needed)
**Purpose**: Configure and validate MCP server integration with quality validation

**Output**: Must output completion marker

```markdown
## MCP_DOMAIN_COMPLETE

Workflow: [DISCOVER|INTEGRATE|VALIDATE|OPTIMIZE]
Compliance Score: XX/100
Servers: [Count] configured
Protocol: [Version]
Tools: [Count] available
```

**Completion Marker**: `## MCP_DOMAIN_COMPLETE`

## Dependencies

This skill is self-contained and does not depend on other skills for execution. It includes all necessary knowledge for MCP server configuration, quality validation, and protocol compliance.

**May be called by**:
- User requests for MCP integration, validation, or optimization
- Other skills seeking MCP configuration guidance

**Does not call other skills** - all functionality is self-contained.

## RECOMMENDED: Context Validation

Read these URLs when accuracy matters for MCP integration work:

### Reference Files (read as needed):
1. `references/integration.md` - Decision guide for MCP usage
2. `references/servers.md` - Server configuration and deployment
3. `references/tools.md` - Tool development and schemas
4. `references/resources.md` - Resources and prompts implementation

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

## Routing Guidance

**Use this skill when**:
- "I want web search" or "Add MCP"
- "Configure MCP servers"
- "Integrate external APIs via MCP"
- Setting up tools, resources, and prompts

**Do not use for**:
- Skill creation (use skills-domain)
- Hook setup (use hooks-domain)
- Subagent creation (use subagents-domain)
- General project configuration

## Quality Integration

Apply quality framework during MCP work:

**Validate MCP configuration**:
- Protocol compliance (version, transport)
- Server configuration and security
- Tool schemas and resources
- Transport mechanisms (stdio/streamable-http)

**Check for anti-patterns**:
- Missing security considerations
- Improper transport configuration
- Missing validation
- Over-complex server setup

**Report quality in completion**:
```markdown
## MCP_DOMAIN_COMPLETE

Workflow: [DISCOVER|INTEGRATE|VALIDATE|OPTIMIZE]
Compliance Score: XX/100
Servers: [Count] configured
Protocol: [Version]
Tools: [Count] available
```

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
- Critical integration decisions

## Multi-Workflow Detection Engine

Automatically detects and executes appropriate workflow:

```python
def detect_mcp_workflow(project_state, user_request):
    has_mcp = exists(".mcp.json")
    user_lower = user_request.lower()

    # Explicit requests
    if "integrate" in user_lower or "add server" in user_lower:
        return "INTEGRATE"
    if "validate" in user_lower or "check compliance" in user_lower:
        return "VALIDATE"
    if "optimize" in user_lower or "improve" in user_lower:
        return "OPTIMIZE"

    # Context-based
    if not has_mcp and "mcp" in user_lower:
        return "DISCOVER"

    # Default
    return "DISCOVER"
```

**Detection Logic**:
1. **Explicit "integrate"/"add server"** → **INTEGRATE mode** (add new server)
2. **Explicit "validate"/"check compliance"** → **VALIDATE mode** (check existing)
3. **Explicit "optimize"/"improve"** → **OPTIMIZE mode** (fix issues)
4. **No .mcp.json exists** → **DISCOVER mode** (analyze needs)
5. **Default** → **DISCOVER mode** (analyze current state)

## Core Philosophy

**Project-Scoped MCP Configuration**:
- Target File: `${CLAUDE_PROJECT_DIR}/.mcp.json`
- Use for: Project-specific integrations, local development
- Safety: Always merge new servers into existing `.mcp.json`

**Layer Selection Decision**:
```
Need external service integration?
├─ Yes → Use MCP
│  ├─ Decision guide → [integration.md](references/integration.md)
│  ├─ Configure servers → [servers.md](references/servers.md)
│  ├─ Build tools → [tools.md](references/tools.md)
│  └─ Create resources → [resources.md](references/resources.md)
└─ No → Use skills or native tools
```

## MCP Primitives Quick Reference

| Primitive | Purpose | Use When |
| --------- | ------- | -------- |
| **Tools** | Callable functions | Need to expose operations or actions |
| **Resources** | Read-only data | Need to provide data access |
| **Prompts** | Reusable workflows | Need predefined prompt templates |

## Transport Mechanisms

### stdio
Local process execution via standard input/output
- Use for: Local MCP server implementation
- Best for: Development, testing, single-user scenarios

### Streamable HTTP
Hosted services with bidirectional streaming
- Use for: Cloud-based servers, production deployments
- Best for: Multi-user, shared instances, high availability

## Four Workflows

### DISCOVER Workflow - Analyze MCP Needs

**Use When:**
- Unclear what MCP servers are needed
- Project analysis phase
- Before adding any MCP servers
- Understanding current integration landscape

**Why:**
- Identifies integration opportunities
- Maps existing MCP configuration
- Suggests appropriate server types
- Prevents unnecessary complexity

**Process:**
1. Scan project structure for integration needs
2. Check existing .mcp.json configuration
3. Identify service integration opportunities
4. Suggest appropriate primitives (tools/resources/prompts)
5. Generate recommendation report

### INTEGRATE Workflow - Add New MCP Server

**Use When:**
- Explicit integration request
- No .mcp.json exists
- New service integration needed
- User asks to add MCP server

**Why:**
- Adds properly configured MCP servers
- Follows protocol standards
- Validates configuration
- Ensures safe merge strategy

**Process:**
1. Check existing .mcp.json structure
2. Validate server configuration
3. Merge into existing config (safe strategy)
4. Validate protocol compliance
5. Test connectivity

**Configuration Example**:
```json
{
  "mcpServers": {
    "my-server": {
      "transport": {
        "type": "stdio",
        "command": "node",
        "args": ["path/to/server.js"]
      }
    }
  }
}
```

**Safety**: Always merge new servers into existing `.mcp.json` to preserve current configuration.

### VALIDATE Workflow - Protocol Compliance Check

**Use When:**
- Audit or validation requested
- Protocol compliance check needed
- Before production deployment
- After server configuration changes

**Why:**
- Ensures protocol compliance
- Validates configuration structure
- Checks for best practices
- Provides compliance score

**Process:**
1. Scan .mcp.json structure
2. Validate server configurations
3. Check protocol adherence
4. Verify transport mechanisms
5. Generate compliance report

**Score-Based Actions**:
- 90-100 (A): Excellent compliance, no changes needed
- 75-89 (B): Good compliance, minor improvements
- 60-74 (C): Adequate compliance, OPTIMIZE recommended
- <60 (D/F): Poor compliance, OPTIMIZE required

### OPTIMIZE Workflow - Performance Improvements

**Use When:**
- VALIDATE found issues (score <75)
- Performance problems detected
- Configuration optimization needed
- Best practices not followed

**Why:**
- Fixes compliance issues
- Improves performance
- Enhances maintainability
- Ensures protocol standards

**Process:**
1. Review validation findings
2. Prioritize issues by severity
3. Fix configuration problems
4. Optimize transport mechanisms
5. Re-validate improvements

## Quality Framework

Scoring system (0-100 points):

| Dimension | Points | Focus |
|-----------|--------|-------|
| **1. Protocol Compliance** | 25 | Valid MCP specification |
| **2. Server Configuration** | 20 | Correct transport and settings |
| **3. Tool Validation** | 15 | Valid tool schemas |
| **4. Resource Access** | 15 | Proper resource configuration |
| **5. Transport Optimization** | 15 | Appropriate transport choice |
| **6. Security** | 10 | Secure configuration |

**Quality Thresholds**:
- **A (90-100)**: Exemplary MCP configuration
- **B (75-89)**: Good configuration with minor gaps
- **C (60-74)**: Adequate configuration, needs improvement
- **D (40-59)**: Poor configuration, significant issues
- **F (0-39)**: Failing configuration, critical errors

## Key Takeaways

1. **Use MCP** for shareable, protocol-standardized integrations
2. **Use skills** for project-specific, direct integrations
3. **Use native tools** for basic file operations
4. **Choose transport** based on deployment needs
5. **Start with official servers** before building custom

## TaskList Integration for Complex MCP Workflows

For multi-server MCP projects requiring task tracking across sessions:

**When to use TaskList**:
- Multi-server setup (3+ servers to configure)
- Server dependency chains (server B requires server A)
- Complex validation workflow (test → validate → optimize)
- Need visual progress tracking across server setup
- Session-spanning MCP configuration projects

**Multi-Server Setup Workflow**:

Use TaskCreate to validate the .mcp.json structure first. Then use TaskCreate to establish parallel server configuration tasks for primary (web search), secondary (database), and specialized (custom API) servers — configure these to depend on the structure validation. Use TaskCreate to establish a connectivity testing task that depends on all server configurations completing. Use TaskCreate to establish a tool availability validation task that depends on connectivity testing. Finally use TaskCreate to establish a configuration report generation task.

**Benefits**:
- .mcp.json validation prevents invalid configuration
- Parallel server configuration saves time
- Connectivity testing waits for all servers
- Validation runs only after successful connectivity

## Workflow Selection Quick Guide

**"I need MCP integration"** → INTEGRATE
**"Check my MCP configuration"** → VALIDATE
**"Fix MCP issues"** → OPTIMIZE
**"What MCP servers do I need?"** → DISCOVER

## Output Contracts

### DISCOVER Output
```markdown
## MCP Analysis Complete

### Existing Servers: [count]
### Recommendations: [count]

### Suggested Servers
1. [Name]: [Purpose] - Type: [Tools|Resources|Prompts]
2. [Name]: [Purpose] - Type: [Tools|Resources|Prompts]

### Integration Opportunities
- [Pattern 1]: Suitable for MCP
- [Pattern 2]: Suitable for MCP
```

### INTEGRATE Output
```markdown
## MCP Server Integrated: {server_name}

### Configuration
- Transport: {stdio|http}
- Protocol: MCP v{version}
- Tools: [count] available
- Resources: [count] configured

### Compliance Score: 85/100
### Status: Connected ✅
```

### VALIDATE Output
```markdown
## MCP Validation Complete

### Compliance Score: 85/100 (Grade: B)

### Breakdown
- Protocol Compliance: XX/25
- Server Configuration: XX/20
- Tool Validation: XX/15
- Resource Access: XX/15
- Transport Optimization: XX/15
- Security: XX/10

### Issues
- [Count] critical issues
- [Count] warnings
- [Count] recommendations

### Recommendations
1. [Action] → Expected improvement: [+XX points]
2. [Action] → Expected improvement: [+XX points]
```

### OPTIMIZE Output
```markdown
## MCP Optimized: {server_name}

### Compliance Score: 65 → 90/100 (+25 points)

### Improvements Applied
- {improvement_1}: [Before] → [After]
- {improvement_2}: [Before] → [After]

### Status: [Production Ready|Needs More Work]
```

## Common Anti-Patterns

**Configuration Anti-Patterns:**
- ❌ Not validating .mcp.json structure before adding servers
- ❌ Overwriting existing configuration instead of merging
- ❌ Using inappropriate transport mechanisms
- ❌ Missing protocol compliance validation

**Integration Anti-Patterns:**
- ❌ Adding MCP when skills would suffice
- ❌ Building custom servers when official servers exist
- ❌ Complex multi-server setups without TaskList coordination

**Protocol Anti-Patterns:**
- ❌ Invalid tool schemas
- ❌ Missing resource validation
- ❌ Ignoring transport optimization
- ❌ No security considerations

## Handling MCP Delegations

When responding to MCP configuration requests:

### For MCP Configuration Delegations

```markdown
## MCP Integration Guidance

**Protocol Pattern**: [Pattern name]
**Transport**: [stdio|http|sse]

**Component Assessment:**
- Tools: [X] tools - [Validation status]
- Resources: [X] resources - [Validation status]
- Prompts: [X] prompts - [Validation status]
- Security: [Score]/10

**Integration Status:**
- Protocol adherence: [Version and compliance]
- Transport optimization: [stdio for local|http for cloud]
- Component validity: [All valid/Issues found]

**Deployment Recommendation:**
- Local development: [Configuration]
- Production deployment: [Configuration]
- Multi-user scenario: [Configuration]
```

### For Server Integration

```markdown
**Server Integration Pattern:**

**Configuration Safety:**
- Existing servers: [Preserved ✅]
- Merge strategy: [Safe JSON merge]
- Validation: [Protocol compliance check]
- Rollback: [Available via git]

**Server Characteristics:**
- Tools: [Count and types]
- Resources: [Data access patterns]
- Prompts: [Workflow templates]
- Transport: [stdio recommended for local]

**Integration Benefits:**
- Protocol standardization: [Yes/No]
- Tool discoverability: [Enhanced via auto-discovery]
- Context management: [Tool search when >10% context]
```
