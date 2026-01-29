---
name: agent-development
description: "Create, validate, and audit autonomous agents with isolated subprocess and independent context. Use when building agent systems, designing autonomous workflows, or reviewing agent quality. Includes agent patterns, context fork isolation, tool routing, and success criteria definition. Not for simple logic reuse, synchronous function calls, or human-orchestrated workflows."
---

# Agent Development

## Quick Start

**Create agent:** `references/pattern_agent_templates.md` → Follow agent pattern templates

**Review agent:** Use `quality-standards` skill → Apply quality gates

**Configure triggers:** `references/lookup_trigger_examples.md` → Add `Triggered:` clause

**Why:** Agents run in isolated subprocess with independent context—behavioral guidance must be bundled in `<philosophy_bundle>`.

## Navigation

| If you need...               | Read...                                 |
| :--------------------------- | :-------------------------------------- |
| Create new agent             | `references/pattern_agent_templates.md` |
| Review agent quality         | Use `quality-standards` skill           |
| Configure trigger conditions | `references/lookup_trigger_examples.md` |
| Understand agent patterns    | ## Pattern Library                      |
| Philosophy bundle guidance   | ## Philosophy Bundle                    |

## Critical Reference Loading

**Complete Reading Required**: Invoke `agent-development` and read `references/pattern_agent_templates.md` completely. Summaries miss critical system prompt templates that affect quality.

_Reason: Contains critical system prompt templates that cause poor results if summarized._

## Semantic Anchoring

### Configuration (The Body)

- YAML Frontmatter editing (name, description, model, team_name)
- File placement (`.claude/agents/` directory)
- Trigger conditions in description field

### Prompt Design (The Brain)

- Philosophy Bundle injection (behavioral guidance for context fork)
- Interaction Schema definition (design → template_generation → philosophy_bundle → validation → output)
- System prompt templates from pattern library

## System Requirements

- **Frontmatter fields**: name, description, model (inherit/sonnet/opus/haiku), team_name (optional)
- **Required sections**: `<mission_control>`, `## Overview`, `## Autonomous Capability`, `## Trigger Conditions`, `## Philosophy Bundle`
- **Mode options**: `default`, `plan`, `bypassPermissions`
- **Portability**: Zero external dependencies, self-contained philosophy bundle

## Operational Patterns

This skill follows these behavioral patterns:

- **Planning**: Switch to planning mode for architectural decisions
- **Discovery**: Locate files matching patterns and search file contents for agent context
- **Delegation**: Delegate planning and exploration to specialized workers
- **Tracking**: Maintain a visible task list for agent creation

Trust native tools to fulfill these patterns. The System Prompt selects the correct implementation.

## Troubleshooting

| Issue                           | Symptom                   | Solution                                                                                    |
| ------------------------------- | ------------------------- | ------------------------------------------------------------------------------------------- |
| Agent not triggering            | Weak trigger conditions   | Use proactive language, specific event triggers                                             |
| Poor agent output               | Generic system prompt     | Use pattern templates with specific domain/context                                          |
| Agent confused about scope      | Missing Philosophy Bundle | Add `<philosophy_bundle>` with behavioral rules                                             |
| Agent references external files | Non-portable              | Remove all `.claude/rules` references, bundle in philosophy                                 |
| Missing required sections       | Invalid agent structure   | Add mission_control, Overview, Autonomous Capability, Trigger Conditions, Philosophy Bundle |

<mission_control>
<objective>Create autonomous agents with isolated context and self-contained philosophy</objective>
<success_criteria>Generated agent includes valid frontmatter, clear triggers, and bundled behavioral guidance</success_criteria>
</mission_control>

<interaction_schema>
design → template_generation → philosophy_bundle → validation → output</interaction_schema>

## When to Use Agents

| Use agents when...                                           | Use skills when...                        |
| ------------------------------------------------------------ | ----------------------------------------- |
| Task requires isolation (untrusted code, parallel execution) | Same-conversation execution is sufficient |
| Long-running operations (>30 minutes)                        | Quick task (<5 minutes)                   |
| Context fork required for safety                             | Context sharing is beneficial             |
| Verbose output to keep out of main conversation              | Simple logic reuse                        |

---

## Core Structure

### Frontmatter

```yaml
---
name: agent-name
description: What agent does. Use when [condition]. Not for [condition].
model: inherit # sonnet, opus, haiku, or inherit
team_name: team-context # optional, for multi-agent coordination
---
```

### Body Sections

| Section                    | Purpose                      | Required |
| -------------------------- | ---------------------------- | -------- |
| `<mission_control>`        | Objective + success criteria | Yes      |
| `## Overview`              | What agent does              | Yes      |
| `## Autonomous Capability` | Independent task execution   | Yes      |
| `## Trigger Conditions`    | When to spawn                | Yes      |
| `## Philosophy Bundle`     | Behavioral guidance          | Yes      |

### Mode Options

| Mode                | Behavior                      |
| ------------------- | ----------------------------- |
| `default`           | Standard autonomous execution |
| `plan`              | Requires plan approval        |
| `bypassPermissions` | Skips permission checks       |

---

## Pattern Library

### Pattern 1: Generation Agent

A generation agent transforms requirements into structured outputs. The key insight is that quality emerges from clear specifications, not from telling the agent to "be good."

```markdown
You are an expert {{DOMAIN}} generator specializing in {{OUTPUT_TYPE}}.

**Core Responsibilities:**

- Transform {{input}} into {{output_type}} that meets {{quality_standards}}
- Apply {{conventions}} consistently throughout
- Structure results so readers can quickly find what matters

**Output Format:**
Create {{what}} with:

- {{structure_requirement_1}}
- {{structure_requirement_2}}

**Recognition**: The agent who can describe what good looks like produces better results than one who simply tries hard.
```

### Pattern 2: Analysis Agent

Analysis agents turn information into insight. The distinguishing factor is impact—finding what matters rather than cataloging everything.

```markdown
You are an expert {{DOMAIN}} analyst specializing in {{ANALYSIS_TYPE}}.

**Core Responsibilities:**

- Examine {{target}} to identify {{patterns/issues}} that matter most
- Prioritize findings by real-world impact (High/Medium/Low)
- Ground each observation in specific evidence and actionable recommendations

**Output Format:**

## Analysis Report: {{TITLE}}

### Summary

[2-3 sentence overview—what's the bottom line?]

### Key Findings

- **[Finding]** (Impact: High/Medium/Low)
  - Location: [file:line]
  - Details: [Description]
  - Recommendation: [Action]

**Recognition**: Good analysis doesn't overwhelm—it illuminates. A reader should finish understanding what changed and what to do about it.
```

### Pattern 3: Validation Agent

Validation agents are the gatekeepers—they provide confidence that something meets a standard. The key is clarity: pass/fail should never be ambiguous.

```markdown
You are an expert {{DOMAIN}} validator specializing in {{QUALITY}}.

**Core Responsibilities:**

- Test {{what}} against {{criteria}} with specific, verifiable checks
- Identify and categorize violations by severity
- Report with binary clarity: this passes, or this fails with specific reasons

**Output Format:**

## Validation Result: [PASS/FAIL]

## Summary

[Overall assessment]

## Violations Found: [count]

### Critical ([count])

- [Location]: [Issue] - [Fix]

**Recognition**: A validation agent that can't explain why something failed isn't doing its job. Confidence comes from specificity.
```

### Pattern 4: Orchestration Agent

Orchestration agents coordinate complex workflows—managing multiple phases, dependencies, and transitions. The distinguishing trait is knowing when to proceed, when to wait, and when to escalate.

```markdown
You are an expert {{DOMAIN}} orchestrator specializing in {{WORKFLOW}}.

**Core Responsibilities:**

- Break {{multi-step process}} into logical phases with clear boundaries
- Track dependencies between phases—what must complete before what
- Verify phase completion before advancing, integrating results as you go

**Recognition**: A good orchestrator creates clarity out of complexity—not by managing every detail, but by establishing clear contracts between phases.
```

---

## Trigger Conditions

The best trigger conditions make the agent feel like a natural extension of the workflow—appearing at the moment it becomes useful, not as an afterthought.

**Strong activation patterns:**

```yaml
# Proactive + Mandatory
description: Expert code reviewer. Use PROACTIVELY after writing code.
Triggered: For all code changes before commit.

# Automatic triggering
description: Expert planner. Automatically activated for feature
implementation requests exceeding 5 files.

# Timing-specific
description: Security analyzer. Triggered immediately after
implementing authentication, payment, or data handling code.

# Context-specific
description: Test architect. Activated when test coverage drops
below defined thresholds or when new test files are added.
```

**Recognition**: A trigger that requires the user to remember to invoke it is a weak trigger. Strong triggers activate based on observable context—the system knows when they're needed.

**Example block format:**

```markdown
<example>
Context: [Situation description]
user: "[Exact user message]"
assistant: "[Response before triggering]"
<commentary>
[Explanation of why agent triggers]
</commentary>
assistant: "I'll use the [agent-name] agent to [action]."
</example>
```

---

## Validation Checklist

| Check                         | Tool | Command                            |
| ----------------------------- | ---- | ---------------------------------- |
| Frontmatter starts with `---` | Read | `Read: first 5 lines`              |
| Required fields present       | Grep | `^name:\|^description:`            |
| Use when/Not for clauses      | Grep | `Use when\|Not for`                |
| mission_control present       | Grep | `<mission_control>`                |
| Valid mode value              | Grep | `default\|plan\|bypassPermissions` |

---

## Navigation

| If you need...             | Reference                                  |
| -------------------------- | ------------------------------------------ |
| System prompt templates    | `references/pattern_agent_templates.md`    |
| Triggering examples        | `references/lookup_trigger_examples.md`    |
| Agent configuration fields | See frontmatter specification in this file |

---

## Native Agent Type Mapping

<mission_control>
<objective>Map task requirements to optimal native agent types</objective>
<success_criteria>Every task uses the most appropriate native agent type</success_criteria>
</mission_control>

### Agent Selection Decision Tree

```
                    Task has code/architecture work?
                              |
                              v
                    [YES]         [NO]
                      |             |
                      v             v
            Task needs exploration?  Task is CLI/git work?
                      |             |
            [YES]     v     [NO]    v
              /         \   /         \
          Explore    general-purpose   Bash
```

### Agent Type Reference

| Native Type       | Use When                                                                             | Not For                               |
| ----------------- | ------------------------------------------------------------------------------------ | ------------------------------------- |
| `Explore`         | Pattern discovery, codebase analysis, file location queries, architecture mapping    | Implementation, writing code          |
| `Plan`            | Architectural design, feature planning, complex decision-making, dependency analysis | Simple implementation, bug fixes      |
| `general-purpose` | Feature implementation, refactoring, bug fixes, tests, documentation                 | Exploration, git operations           |
| `Bash`            | Git operations, CLI commands, build scripts, package management                      | Code writing, architectural decisions |

### Strategy Task Mapping

In STRATEGY.md, use the `agent` attribute:

```markdown
<task
id="1.1"
name="Analyze authentication patterns"
agent="Explore"
style="direct"

>

- Survey existing auth implementations
- Identify patterns to follow
  </task>

<task
id="1.2"
name="Design auth architecture"
agent="Plan"
style="direct"

>

- Create architecture diagram
- Define service interfaces
  </task>

<task
id="1.3"
name="Implement auth service"
agent="general-purpose"
style="tdd"

>

- Create AuthService class
- Add unit tests
  </task>

<task
id="1.4"
name="Setup CI pipeline"
agent="Bash"
style="direct"

>

- Configure GitHub Actions
- Add build steps
  </task>
```

### Operational Patterns

This skill follows these behavioral patterns:

- **Exploration**: Delegate investigation and pattern discovery to exploration specialists
- **Planning**: Delegate architectural decisions to planning specialists
- **Implementation**: Delegate coding tasks to implementation specialists
- **Execution**: Delegate shell operations to execution specialists
- **Orchestration**: Coordinate multiple agents for complex workflows

Trust native tools to fulfill these patterns. The System Prompt selects the correct implementation.

---

## Agent Orchestration Patterns

Guide to coordinating multiple agents for complex, multi-stage workflows.

### Sequential Agent Workflows

For complex tasks requiring multiple stages of analysis and action, use sequential agent workflows. Each agent builds on the previous agent's work through structured handoffs.

#### Feature Workflow

Full feature implementation from planning to security validation:

```
planner -> tdd-guide -> code-reviewer -> security-reviewer
```

**Use for:** New feature implementation, multi-file changes, complex functionality

**Flow:**

1. **Planner**: Creates implementation plan, identifies dependencies, breaks down phases
2. **TDD Guide**: Writes tests first, implements to pass tests, ensures coverage
3. **Code Reviewer**: Analyzes implementation quality, checks best practices
4. **Security Reviewer**: Validates security, checks vulnerabilities (especially for auth/payments)

#### Bugfix Workflow

Investigation and fix for reported issues:

```
explorer -> tdd-guide -> code-reviewer
```

**Use for:** Bug investigation, error resolution, unexpected behavior

**Flow:**

1. **Explorer**: Investigates issue, identifies root cause, locates affected code
2. **TDD Guide**: Writes reproduction test, implements fix, verifies solution
3. **Code Reviewer**: Validates fix quality, checks for regression

#### Refactor Workflow

Safe refactoring with validation:

```
architect -> code-reviewer -> tdd-guide
```

**Use for:** Large refactoring, architectural changes, system redesign

**Flow:**

1. **Architect**: Analyzes current state, designs new architecture, documents trade-offs
2. **Code Reviewer**: Validates refactoring approach, checks for breaking changes
3. **TDD Guide**: Ensures tests still pass, adds tests for new structure

#### Security Workflow

Security-focused deep review:

```
security-reviewer -> code-reviewer -> architect
```

**Use for:** Security audits, authentication/payment implementation, compliance checks

**Flow:**

1. **Security Reviewer**: Identifies vulnerabilities, assesses risk, provides remediation
2. **Code Reviewer**: Checks code quality in context of security findings
3. **Architect**: Evaluates architectural security implications, recommends systemic improvements

### Handoff Document Format

Between agents in a sequential workflow, use structured handoff documents to pass context and findings.

```markdown
## HANDOFF: [previous-agent-name] -> [next-agent-name]

### Context

[Summary of what was done in previous stage]
[Task scope and objectives]

### Findings

[Key discoveries, decisions, or insights from previous agent]
[Technical decisions made and rationale]

### Files Modified

- `path/to/file1.ext`: [Change summary]
- `path/to/file2.ext`: [Change summary]

### Open Questions

[Unresolved items that next agent should address]
[Ambiguities or uncertainties requiring further investigation]

### Recommendations

[Suggested next steps for next agent]
[Specific areas to focus on or investigate]

### Risks Identified

[Risks discovered that next agent should consider]
[Potential issues to watch for]
```

### Parallel Execution Patterns

For independent operations that don't depend on each other, run agents in parallel to save time.

**Good candidates for parallel execution:**

- Independent code analysis (security, performance, type safety)
- Multiple file reviews (different modules, independent components)
- Non-blocking validation steps (linting, formatting, testing)
- Multi-perspective analysis (different viewpoints on same code)

**Bad candidates for parallel execution:**

- Sequential dependencies (output of one is input to another)
- Shared resources with conflicts (writing to same files)
- Required ordering (tests must pass before security review)

### Multi-Perspective Analysis

For complex problems requiring diverse expertise, use split-role sub-agents to analyze from multiple perspectives.

For [complex problem], launch multiple specialist agents in parallel:

1. **Factual Reviewer**: Verify correctness, check for bugs, validate logic
2. **Senior Engineer**: Assess code quality, maintainability, patterns
3. **Security Expert**: Identify vulnerabilities, check input handling
4. **Consistency Reviewer**: Verify adherence to conventions and standards
5. **Redundancy Checker**: Look for duplicated code, extraction opportunities

### Orchestration Best Practices

**Always start with the right agent:**

- Always start with planner for features affecting 5+ files, complex functionality, or unclear scope
- Start directly with appropriate agent for simple bug fixes (explorer), clear single-file changes (code-reviewer), or specific security review (security-reviewer)

**Always include code reviewer:**

- Before merging any PR
- After implementing features or fixes
- Before committing refactoring changes
- When code quality is uncertain

**Always use security reviewer for:**

- Authentication and authorization code
- Payment processing or financial transactions
- Personal identifiable information (PII) handling
- Any code accepting user input
- Before deploying to production

### Sequential vs Parallel Decision

| Scenario                                | Pattern        | Rationale                                               |
| --------------------------------------- | -------------- | ------------------------------------------------------- |
| Security + Performance + Quality review | **Parallel**   | Independent checks, no dependencies                     |
| Planner -> TDD -> Code Review           | **Sequential** | Each builds on previous output                          |
| Multiple file type checking             | **Parallel**   | Independent files, no conflicts                         |
| Bug investigation -> Fix -> Validation  | **Sequential** | Fix depends on investigation, validation depends on fix |

---

## The Agent Philosophy

Agents differ fundamentally from skills in their relationship to context. A skill shares the main conversation's context—efficient, collaborative, coherent. An agent forks its own context—isolated, self-contained, independent.

This isolation is intentional. An agent carries everything it needs:

- **Frontmatter**: Identity, triggers, and constraints
- **Mission control**: What it aims to achieve
- **Philosophy bundle**: Behavioral guidance for context fork scenarios

**Recognition**: Would this agent work correctly in a project with zero `.claude/rules`? If it references external files, assumes shared context, or depends on undocumented conventions—it needs more self-containment.

---

## What Belongs in Agent Frontmatter

The description field serves as the agent's first impression and discovery mechanism. A well-crafted description answers two questions implicitly:

1. **When should I be used?** (The trigger)
2. **When should I NOT be used?** (The boundary)

This "Use when / Not for" structure prevents misuse and sets clear expectations. Consider:

```
description: "Expert code reviewer. Use when reviewing pull requests.
Not for trivial one-line fixes or documentation-only changes."
```

The specificity matters. Vague descriptions lead to vague invocations.

---

## Dynamic Knowledge Loading

<router>
This skill is self-contained for standard workflows. Load specialized knowledge ONLY when specific conditions are met:

| Context Condition              | Resource                                 | Action                                     |
| :----------------------------- | :--------------------------------------- | :----------------------------------------- |
| **Copy-paste agent patterns**  | `references/copy_agent_patterns.md`      | `Read` to copy system prompt templates     |
| **Triggering examples**        | `references/lookup_trigger_examples.md`  | `Read` to match activation patterns        |
| **Agent configuration**        | Fetch external docs                      | `WebFetch` official agent docs             |
| **Enforcing agent thresholds** | `Glob: lookup_anti_laziness_patterns.md` | `Grep` for confidence rating, CoT patterns |

---

## Dynamic Sourcing

<fetch*protocol>
**Syntax Source**: This skill focuses on \_patterns* and _philosophy_. For agent configuration fields:

1. **Fetch**: `https://code.claude.com/docs/en/sub-agents.md`
2. **Extract**: The specific configuration fields you need
3. **Discard**: Do not retain the fetch in context
   </fetch_protocol>

---

<critical_constraint>
Agents are isolated organisms. They must work without external dependencies, carry their own philosophy, and define clear boundaries in their descriptions.
</critical_constraint>
