---
description: Analyze user requests and determine the optimal component type for their needs
---

<mission_control>
<objective>Analyze user requests to determine optimal component type (Command/Skill/Agent/Hook/MCP)</objective>
<success_criteria>Component type identified with routing rationale and key indicators provided</success_criteria>
</mission_control>

# Component Analysis

Analyze user requests to determine the most suitable component type.

## How It Works

1. **Examine** user request for key indicators
2. **Determine** optimal component type(s)
3. **Identify** routing rationale
4. **Provide** deep verification when needed

## Usage

```
/component-architect:which [describe what you want to build]
```

**Example:**

```
User: /component-architect:which I need a deploy command

→ Analysis:
  Keywords: "deploy" + "command"
  Intent: High-stakes operation
  Component Type: Command
  Rationale: Deploy operations require human confirmation gates
```

## Primary Indicators

**If request contains:**

- "button", "gate", "checkpoint", "confirm", "review" → **Command**
- "reusable", "capability", "workflow", "process" → **Skill**
- "independently", "autonomous", "background", "isolated" → **Agent**
- "automatically", "on [event]", "trigger", "when [action]" → **Hook**
- "interface", "service", "expose to", "other tools" → **MCP**

## Intent Keywords

- **Deploy/Commit/Audit** → Command (high-stakes, human confirmation)
- **Analysis/Checklist/Reference** → Skill (model knowledge)
- **Monitor/Scraper/Process** → Agent (isolated operation)
- **Validate/Hook/Intercept** → Hook (event-driven)
- **API/Database/Gateway** → MCP (service provider)

## Scope Indicators

- "One-time task" → Command
- "Recurring use" → Skill
- "Long-running" → Agent
- "On every [event]" → Hook
- "For other components" → MCP

## Routing Logic

<decision_tree>
digraph SelectComponent {
Request -> Keywords;
Keywords -> Command [label="deploy, commit, audit"];
Keywords -> Agent [label="autonomous, loop, monitor"];
Keywords -> Hook [label="prevent, on-event"];
Keywords -> MCP [label="api, database"];
Keywords -> Skill [label="default / reusable logic"];
}
</decision_tree>

## Component Type Mapping

| Component Type | Development Skill       | When to Use                                                    | What It Creates                                        |
| -------------- | ----------------------- | -------------------------------------------------------------- | ------------------------------------------------------ |
| **Command**    | `invocable-development` | Workflow orchestration, explicit step sequences, process gates | `/command` slash commands with orchestration workflows |
| **Skill**      | `invocable-development` | Model-first capabilities, reusable workflows, domain knowledge | Context-activated skills for AI use                    |
| **Agent**      | `agent-development`     | Isolated context, autonomous operation, background tasks       | Independent agents with separate context               |
| **Hook**       | `hook-development`      | Event-driven automation, pre/post triggers, validation gates   | Event hooks for automatic execution                    |
| **MCP**        | `mcp-development`       | Service providers, API interfaces, tool providers              | MCP servers for exposing capabilities                  |

## Deep Verification Pattern

When user request is ambiguous or could match multiple component types:

- `Skill: [skill-name]` → "User request: [request]. Need architectural guidance to determine if this fits [component type] pattern. Please review your documentation and advise."

Then trust the skill's recommendation and proceed with orchestration.

**Examples of when to verify deeply:**

- Request mentions both "automatic" and "manual trigger" → Consult `invocable-development` for architectural guidance
- Complex workflow that could be Skill or Command → Verify with relevant skill
- Unclear isolation requirements → Consult `agent-development`
- Event-triggered but also orchestration → Get guidance from `hook-development` or `invocable-development`

## Complex Cases

- If request matches multiple criteria, the most specific indicator wins
- If unclear, default to **Skill** (most flexible, can orchestrate others)

## Output Format

Return a structured analysis:

```markdown
# Component Analysis Result

## Component Type: [Command/Skill/Agent/Hook/MCP]

## Rationale

[Why this component type was chosen]

## Keywords Detected

- [keyword 1]
- [keyword 2]
- [keyword 3]

## Next Step

Use: `/component-architect:build [Component Type] [original request]`
```

## Trust AI Intelligence

Trust the analysis framework:

- **Comprehensive indicators**: Intent, scope, and trigger patterns
- **Proven mapping**: Component type to development skill
- **Flexible defaults**: Skill as fallback for ambiguous cases
- **Deep verification**: Consult xxx-development skills when needed

**Default to confidence**. Only escalate for verification when truly uncertain.

<critical_constraint>
MANDATORY: Map request to correct component type based on keywords
MANDATORY: Provide routing rationale with detected indicators
MANDATORY: Consult xxx-development skills for ambiguous cases
No exceptions. Component type must match user intent.
