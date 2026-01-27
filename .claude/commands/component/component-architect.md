---
name: component-architect
description: Intelligently analyze context and route to the optimal development skill for creating components
---

# Component Architect

Analyze user requests and determine the most suitable component type to create, then route to the appropriate development workflow.

## How It Works

Provide end-to-end orchestration for component creation:

1. **Analysis** - Determine optimal component type using `/component-architect:which`
2. **Verification** - Deep verification when needed using component documentation
3. **Orchestration** - Build the component using `/component-architect:build`
4. **Delivery** - Receive completed component following best practices

## Nested Commands

### `/component-architect:which`
Analyze the request and determine which component type best fits the user's needs:
- Examines intent keywords and scope indicators
- Maps request to optimal component type (Command/Skill/Agent/Hook/MCP)
- Provides routing rationale and deep verification when needed
- Returns: Component type recommendation with full context

**Usage:**
```bash
/component-architect:which [describe what you want to build]
```

### `/component-architect:build`
Orchestrate the development of the component using the appropriate xxx-development skill:
- Invokes the correct xxx-development skill based on analysis
- Passes full context and rationale
- Trusts the skill's architectural expertise
- Delivers completed component

**Usage:**
```bash
/component-architect:build [component type] [original request]
```

## Complete Workflow

```
User: /component-architect I want to create a deploy command

→ Phase 1 - Analysis:
  /component-architect:which deploy command
  → Returns: Component type = Command, rationale = high-stakes operation

→ Phase 2 - Build:
  /component-architect:build Command deploy command
  → Invokes: skill: "command-development"
  → Creates: /deploy command

→ Result: Completed /deploy command ready to use
```

## Component Types

| Type | Description | Examples |
|------|-------------|----------|
| **Command** | User-invoked orchestrators with human confirmation | `/deploy`, `/commit`, `/audit` |
| **Skill** | Model-first capabilities for AI use | `tdd-workflow`, `security-checklist` |
| **Agent** | Isolated context with autonomous operation | Web scraper, background processor |
| **Hook** | Event-driven automation and triggers | Pre-commit validation, file change hooks |
| **MCP** | Service providers and API interfaces | Database query interface, API gateway |

## Efficiency Benefits

**Without Orchestration:**
```
User → Figures out component type → Finds right skill → Creates component
```

**With Component Architect:**
```
User → /component-architect:which [request] → /component-architect:build [type] [request] → Done
```

Eliminate cognitive overhead through intelligent analysis and automated orchestration, reducing user effort by 80%.
