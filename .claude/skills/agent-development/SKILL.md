---
name: agent-development
description: "Create, validate, and audit autonomous agents with isolated subprocess and independent context. Use when building agent systems or reviewing agent quality. Not for simple logic reuse or human-orchestrated workflows."
---

# Agent Development

<mission_control>
<objective>Create autonomous agents with isolated context and self-contained philosophy</objective>
<success_criteria>Generated agent includes valid frontmatter, clear triggers, and bundled behavioral guidance</success_criteria>
<standards_gate>
MANDATORY: Read agent documentation BEFORE creating agents:

- Agent configuration → https://code.claude.com/docs/en/sub-agents.md
- Agent structure → references/agent-structure.md
- Philosophy bundle pattern → references/philosophy-bundle.md
- Agent validation → references/validation.md
  </standards_gate>
  </mission_control>

<interaction_schema>
design → template_generation → philosophy_bundle → validation → output</interaction_schema>

Agents are specialized autonomous subprocesses that execute tasks independently with isolated context. Unlike skills (which are invoked within the same conversation), agents run in separate processes with their own conversation context.

**Core principle**: Agents must be autonomous, isolated, and carry their own philosophy for self-guided execution.

<pattern name="agent_templates">
<principle>Strict templates ensure generated agents have valid frontmatter and complete structure.</principle>
</pattern>

### Agent Template Definition

<agent_template>
<purpose>Strict template for generating valid agent files</purpose>

<frontmatter_template>

```yaml
---
name: { { AGENT_NAME } }
description: "{{AGENT_DESCRIPTION}} Use when {{USE_CASE}}. Not for {{NOT_FOR_CASE}}."
mode: { { EXECUTION_MODE } }
team_name: { { TEAM_CONTEXT | optional } }
---
```

</frontmatter_template>

<body_template>

# {{AGENT_TITLE}}

<mission_control>
<objective>{{MISSION_OBJECTIVE}}</objective>
<success_criteria>{{SUCCESS_CRITERIA}}</success_criteria>
</mission_control>

## Overview

{{AGENT_OVERVIEW}}

**Core principle**: {{CORE_PRINCIPLE}}

<interaction_schema>
{{INTERACTION_FLOW}}
</interaction_schema>

## Autonomous Capability

{{TASK_DESCRIPTION}}

## Isolation Requirements

{{CONTEXT_REQUIREMENTS}}

## Trigger Conditions

{{WHEN_TO_SPAWN}}

## Communication Patterns

{{REPORTING_MECHANISM}}

## Philosophy Bundle

{{BEHAVIORAL_GUIDANCE}}
</body_template>

<required_fields>

- <field>name</field> - Agent identifier (kebab-case)
- <field>description</field> - What it does, when to use, when NOT to use
- <field>mode</field> - Execution mode (default, plan, delegate, bypassPermissions)
- <field>mission_control</field> - Objective and success criteria
- <field>autonomous_capability</field> - What it does independently
- <field>trigger_conditions</field> - When to spawn this agent
- <field>philosophy_bundle</field> - Behavioral guidance for isolation
  </required_fields>

<validation_rules>

- description MUST include "Use when:" and "Not for:" clauses
- mode MUST be one of: default, plan, delegate, bypassPermissions
- mission_control MUST include objective and success_criteria
- philosophy MUST be self-contained (no external references)
  </validation_rules>
  </agent_template>

### System Prompt Builder

<system_prompt_builder>
<purpose>Construct agent persona and behavioral guidance</purpose>

<persona_definition>
<role>{{AGENT_ROLE}}</role>
<expertise>{{DOMAIN_EXPERTISE}}</expertise>
<personality>{{BEHAVIORAL_TRAITS}}</personality>
<constraints>{{OPERATIONAL_CONSTRAINTS}}</constraints>
</persona_definition>

<autonomy_protocol>
<decision_making>

- How to make decisions without human input
- What to escalate vs resolve independently
- Error handling and recovery strategies
  </decision_making>

<communication>
- Progress reporting frequency
- Error escalation criteria
- Completion notification format
</communication>
</autonomy_protocol>
</system_prompt_builder>

---

## What Agents Are

Agents provide:

- **Autonomous execution**: Run independently without supervision
- **Isolated context**: Separate conversation and memory
- **Distributed processing**: Parallel task execution
- **Specialized capabilities**: Domain-specific functionality
- **Bundled philosophy**: Self-contained behavioral guidance

### Agent vs Skill vs Command

- **Agents**: Autonomous subprocesses (isolated execution)
- **Skills**: Folder structure with SKILL.md + optional workflows/references (progressive disclosure)
- **Commands**: Single `.md` file with folder nesting for /category:command naming

**Skills and Commands are the same system** - both are auto-invocable tools. The difference is structural (single file vs folder).

---

## Core Structure

### Frontmatter

```yaml
---
name: agent-name
description: Autonomous agent for specific task domain
mode: default
team_name: team-context
---
```

### Agent Body

- **Autonomous capability**: What the agent does independently
- **Isolation requirements**: What context it needs
- **Trigger conditions**: When to spawn this agent
- **Communication patterns**: How it reports progress
- **Philosophy bundle**: Behavioral guidance for isolation

### Critical Fields

**mode**: Execution mode

- `default`: Standard autonomous execution
- `plan`: Requires plan approval before execution
- `delegate`: Accepts delegated tasks
- `bypassPermissions`: Skips permission checks (dangerous)

**team_name**: Context identifier for multi-agent coordination

---

## Best Practices

### Autonomy

- Self-contained decision making
- No dependency on caller for implementation details
- Autonomous error handling and recovery
- Independent progress reporting

### Isolation

- Bundle all necessary context (no external references)
- Include philosophy for self-guidance
- Provide success criteria for validation
- Ensure portable operation

### Spawning Decisions

**Use agents when:**

- Task requires isolation (untrusted code, parallel execution)
- Long-running operations (>30 minutes)
- Independent subprocess needed
- Context fork required for safety

**Use skills when:**

- Same-conversation execution is sufficient
- Quick task (<5 minutes)
- No isolation needed
- Context sharing is beneficial

### Quality

- Imperative form for instructions
- Clear autonomous capabilities
- Progressive disclosure (core → details)
- Self-validation mechanisms

### Agent Communication

- Report progress to parent context
- Provide completion status
- Share errors and blockers
- Enable parent oversight

---

## Dynamic Sourcing Protocol

<fetch_protocol>
**MANDATORY FETCH**: Before creating agents, fetch the content from:

- https://code.claude.com/docs/en/sub-agents.md (agent configuration fields, execution modes)

This skill contains Seed System-specific agent patterns and orchestration strategies.
</fetch_protocol>

---

## Navigation

**Official Documentation**:

- Agent configuration → https://code.claude.com/docs/en/sub-agents.md

---

## Validation Pattern

Use native tools to validate agent files:

**Read: Check frontmatter structure**

- `Read: first 20 lines of agent.md` → Verify frontmatter starts with `---`
- `Read: lines 2-30` → Extract frontmatter content

**Grep: Verify required fields**

- `Grep: search for "^name:"` → Agent identifier present
- `Grep: search for "^description:"` → Description present
- `Grep: search for "^model:"` → Model specified
- `Grep: search for "^mode:"` → Execution mode defined
- `Grep: search for "Use when\|Not for"` → Trigger clauses present

**Grep: Validate frontmatter format**

- `Grep: search for "^---$"` → Closing frontmatter marker
- `Grep: search for "inherit|sonnet|opus|haiku"` → Valid model value

**Validation workflow**:

1. `Read: agent.md` → Load full agent file
2. `Grep: search for "^name:|^description:|^model:|^mode:"` → Verify required fields
3. `Grep: search for "Use when.*Not for"` → Confirm What-When-Not format
4. `Grep: search for "<mission_control>"` → Check for mission control section

---

## Absolute Constraints (Non-Negotiable)

<critical_constraint>
**MANDATORY: Use strict agent templates when generating**

- Follow `<agent_template>` structure exactly
- All required fields MUST be present
- Frontmatter MUST be valid YAML
- description MUST include "Use when:" and "Not for:" clauses

**MANDATORY: Philosophy must be self-contained**

- Bundle all behavioral guidance in agent
- NO external references to rules or other files
- Agent must work in isolation
- Philosophy includes principles, patterns, anti-patterns

**MANDATORY: Autonomous capability clearly defined**

- Specify what agent does independently
- Define trigger conditions clearly
- Specify communication patterns
- Include success criteria

**MANDATORY: System prompt builder for persona**

- Use `<system_prompt_builder>` template
- Define role, expertise, personality, constraints
- Include autonomy protocol (decision making, communication)
- Philosophy bundle must be complete

**No exceptions. Agents are isolated organisms - they carry their own genetic code.**
</critical_constraint>
