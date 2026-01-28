---
description: Orchestrate the development of components by invoking the appropriate xxx-development skill
disable-model-invocation: true
---

<mission_control>
<objective>Orchestrate component development by invoking appropriate xxx-development skill</objective>
<success_criteria>Component created using correct development skill with full context passed</success_criteria>
</mission_control>

<interaction_schema>
receive_request → invoke_skill → pass_context → trust_expertise → deliver_component
</interaction_schema>

# Component Build Orchestration

Orchestrate the development of components by invoking the appropriate xxx-development skill with full trust in its architectural expertise.

## How It Works

1. **Receive** component type and original request
2. **Invoke** the appropriate xxx-development skill
3. **Pass** full context and rationale
4. **Trust** the skill's expertise
5. **Deliver** completed component

## Usage

```bash
/component-architect:build [component type] [original request]
```

**Example:**

```
User: /component-architect:build Command deploy command

→ Invoke: skill: "invocable-development"
→ Args: "User wants: deploy command. Component type: Command."
→ Trust: invocable-development architecture expertise
→ Result: /deploy command created
```

## Component Type Invocation

### Command Components

```bash
/component-architect:build Command [request]
→ Invoke: skill: "invocable-development"
→ Args: "User wants: [request]. Component type: Command."
```

### Skill Components

```bash
/component-architect:build Skill [request]
→ Invoke: skill: "skill-development"
→ Args: "User wants: [request]. Component type: Skill."
```

### Agent Components

```bash
/component-architect:build Agent [request]
→ Invoke: skill: "agent-development"
→ Args: "User wants: [request]. Component type: Agent."
```

### Hook Components

```bash
/component-architect:build Hook [request]
→ Invoke: skill: "hook-development"
→ Args: "User wants: [request]. Component type: Hook."
```

### MCP Components

```bash
/component-architect:build MCP [request]
→ Invoke: skill: "mcp-development"
→ Args: "User wants: [request]. Component type: MCP."
```

## Orchestration Flow

```
Component Type + Request
  → Invoke appropriate xxx-development skill
  → Pass full context
  → Trust execution
  → Deliver result
```

## Trust AI Intelligence

Trust the xxx-development skills' architectural expertise:

- **They know their domain**: Each skill understands its component type deeply
- **They follow best practices**: Portable, self-contained, progressive disclosure
- **They create quality components**: Success Criteria, validation, testing
- **They handle edge cases**: The skills' documentation covers nuances
- **They're autonomous**: Can create complete components without guidance

**Default to trust**. Only override if there's a clear reason to believe the skill's recommendation doesn't fit the user's intent.

## Orchestration Commands

Use the `Skill` tool to invoke development skills with full trust:

```bash
# For Command components
skill: "invocable-development", args: "User wants: [original request]. Component type: Command. Keywords: [detected]. Rationale: [why Command]."

# For Skill components
skill: "invocable-development", args: "User wants: [original request]. Component type: Skill. Keywords: [detected]. Rationale: [why Skill]."

# For Agent components
skill: "agent-development", args: "User wants: [original request]. Component type: Agent. Keywords: [detected]. Rationale: [why Agent]."

# For Hook components
skill: "hook-development", args: "User wants: [original request]. Component type: Hook. Keywords: [detected]. Rationale: [why Hook]."

# For MCP components
skill: "mcp-development", args: "User wants: [original request]. Component type: MCP. Keywords: [detected]. Rationale: [why MCP]."
```

Each invocation passes:

- **User's original request**: Full context of what they want to build
- **Component type**: The determined type
- **Keywords detected**: Key indicators found
- **Rationale**: Why this component type was chosen

Trust the skill to use its full architectural knowledge and best practices.

## Execution Examples

### Single Component

```
Input: /component-architect:build Command deploy command

→ Analyze:
  Component Type: Command
  Request: deploy command

→ Invoke:
  skill: "invocable-development"
  Args: "User wants: deploy command. Component type: Command."

→ Trust:
  Let invocable-development use full architectural knowledge

→ Deliver:
  /deploy command created following best practices
```

### Multiple Components

```
Input: /component-architect:build Skill code-review + /component-architect:build Command deploy

→ Orchestrate sequentially:
  1. Invoke: skill: "skill-development" for code-review
     → Creates code-review skill

  2. Invoke: skill: "invocable-development" for deploy
     → Creates /deploy command

→ Deliver:
  Both components created following their respective architectures
```

## Development Handoff

Let the xxx-development skill receive and process:

1. **User's original request**
2. **Component type determination**
3. **Analysis rationale and indicators**
4. **Full routing context**

Then trust the skill to:

- Use its architectural knowledge
- Follow best practices
- Create portable, self-contained components
- Include Success Criteria
- Validate the component

## Delivery Phase

Deliver completed component:

- Verify it follows portable, self-contained patterns
- Confirm Success Criteria are met
- Ensure component is ready to use

## Autonomy Guarantee

Provide 95-100% autonomy:

- **Automatic invocation**: Invoke the correct xxx-development skill
- **Trust execution**: Let development skill handle the rest
- **Zero decision burden**: Pass context and let skill create

**Examples:**

**100% Autonomy:**

```
/component-architect:build Command deploy
→ Invoke: skill: "invocable-development"
→ Trust: invocable-development creates /deploy
→ No questions asked
```

## Efficiency Benefits

**Without Orchestration:**

```
User → Figures out type → Finds skill → Creates component
```

**With Build Orchestration:**

```
/component-architect:build [type] [request] → Automatic → Done
```

Eliminate cognitive overhead through intelligent orchestration, reducing user effort by 80%.

<critical_constraint>
MANDATORY: Pass full context (request, type, keywords, rationale) to development skill
MANDATORY: Trust the xxx-development skill's architectural expertise
MANDATORY: Deliver completed component following best practices
No exceptions. Orchestration requires complete context handoff.
