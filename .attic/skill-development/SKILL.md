---
name: skill-development
description: "Create portable, self-sufficient skills for reusable capabilities or specialized knowledge blocks. Use when content benefits from multiple files with progressive disclosure."
---

# Skill Development

**Commands and Skills are the same system** - both are auto-invocable tools. The difference is structural:

**Skills:**

- Folder with `SKILL.md` + optional `workflows/` and `references/`
- Progressive disclosure (main content + detailed references)
- Best when multiple files provide better organization
- Flat naming structure

**Commands:**

- Single `.md` file
- Folder nesting produces `/folder:subfolder:command` patterns
- Useful for categorization and quick access
- Best when content fits in one file (~500-1500 words)

Both are invocable by AI and users based on description and context.

**Core principle**: Skills must be self-contained and work in isolation without external dependencies.

---

## When to Use Skills

**Choose SKILL when:**

- Content benefits from multiple files
- Progressive disclosure needed (core + detailed references)
- Multiple workflow files provide better organization
- Examples or scripts should be bundled
- Example: `skill/tdd-workflow` - comprehensive TDD methodology

**Choose COMMAND when:**

- Single file is sufficient
- Folder nesting provides useful categorization
- Content fits in one file (~500-1500 words)
- Quick access via `/category:command` naming is valuable

---

## Description Template

Third person, specific and concise:

```
[Action] [object/target] [constraints]
Use when [trigger phrase]
```

Examples:

- "Processes PDF files to extract text content. Use when you need data from PDFs."
- "API design patterns for this codebase. Use when designing or reviewing APIs."
- "Terraform best practices. Use when provisioning infrastructure."

---

## Core Structure

<thinking>
**Task Analysis:** Need to define UHP-compliant skill structure
**Constraints:** Must follow 3-Layer Architecture (Control/Data/Interaction planes)
**Approach:** Provide template with mandatory UHP elements
**Selected:** Include mission_control, trigger, interaction_schema at top; critical_constraint at bottom
</thinking>

### Frontmatter

```yaml
---
name: skill-name
description: Clear, actionable description with What-When-Not format
---
```

### UHP Header (MANDATORY)

All skills must begin with UHP structure for semantic anchoring:

```markdown
# Skill Name

<mission_control>
<objective>[What this skill achieves]</objective>
<success_criteria>[How to verify success]</success_criteria>
</mission_control>

<trigger>When [specific condition]. Not for: [exclusion cases].</trigger>

<interaction_schema>
[State flow for reasoning tasks, e.g., ANALYZE → DESIGN → EXECUTE → VALIDATE]
</interaction_schema>

[Skill body content follows...]
```

### Skill Body

- **Trigger phrases**: When to use this skill
- **Core instructions**: How to apply the skill
- **Examples**: Concrete usage patterns
- **Integration**: How it works with other components

### UHP Footer (MANDATORY - Recency Bias)

All skills must end with absolute constraints:

```markdown
---

## Absolute Constraints

<critical_constraint>
MANDATORY: [Non-negotiable rule 1]
MANDATORY: [Non-negotiable rule 2]

No exceptions. No "looks complete" rationalization.
</critical_constraint>
```

**Why this matters**: Recency Bias - final tokens have highest activation during generation.

---

## Best Practices

### Portability

- Self-contained (no external dependencies)
- Include all necessary context
- Work in isolation

### Autonomy

- 80-95% autonomy (0-5 AskUserQuestion rounds)
- Clear triggering conditions
- Progressive disclosure

### Quality

- Imperative form
- Clear examples
- Single source of truth

### Advanced Logic: Diagrams > Tables

For complex conditional logic or state machines, diagrams are unambiguous and token-efficient.

**A. Semantic Routing (Mermaid)**
Use inside `<router>` tags when decisions depend on natural language analysis.

```markdown
<router>
flowchart TD
    Input --> Analyze{Category?}
    Analyze -- Bug --> FixPath
    Analyze -- Feature --> PlanPath
    FixPath --> Test
</router>
```

**B. Strict State Machines (DOT/Graphviz)**
Use inside `<logic_flow>` tags for strict loops, retries, and error handling. **Preferred for high density.**

```markdown
<logic_flow>
digraph RetryLogic {
Start -> Attempt;
Attempt -> Success [label="200 OK"];
Attempt -> Backoff [label="5xx"];
Backoff -> Attempt;
}
</logic_flow>
```

### Persuasion Principles for Critical Skills

**CRITICAL**: Skills that enforce discipline require strong psychological enforcement to ensure compliance.

**Use authority language for non-negotiables:**

- MANDATORY: Must follow this workflow
- NEVER: Prohibited actions
- ALWAYS: Required steps

**Apply commitment techniques for multi-step workflows:**

- Require explicit user acknowledgment
- Force choices between approaches
- Create psychological barriers to shortcuts

**Examples:**

❌ Weak language (easily skipped):

```
"It's good to write tests first"
"You should probably use TDD"
"Maybe run the tests"
```

✅ Strong language (enforces compliance):

```
MANDATORY: Complete RED phase before GREEN
NEVER skip verification before completion
ALWAYS provide evidence for claims
```

**Red Flag Recognition**: If skill content is critical for quality or compliance, use absolute language to prevent rationalization and skipping.

---

## Navigation

| If you need...         | Reference                              |
| ---------------------- | -------------------------------------- |
| Description guidelines | `references/description-guidelines.md` |
| Progressive disclosure | `references/progressive-disclosure.md` |
| Autonomy design        | `references/autonomy-design.md`        |
| Orchestration patterns | `references/orchestration-patterns.md` |
| Anti-patterns          | `references/anti-patterns.md`          |
| Quality framework      | `references/quality-framework.md`      |
| Advanced execution     | `references/advanced-execution.md`     |
| Creation workflow      | `references/workflows-create.md`       |
| Audit workflow         | `references/workflows-audit.md`        |
| Meta-critic workflow   | `references/workflows-metacritic.md`   |

---

## Absolute Constraints

<critical_constraint>
MANDATORY: All generated skills MUST include UHP header (mission_control, trigger, interaction_schema)

MANDATORY: All generated skills MUST include critical_constraint at bottom (Recency Bias)

MANDATORY: Skills MUST work in isolation (zero .claude/rules dependency)

MANDATORY: Skills MUST achieve 80-95% autonomy (0-5 AskUserQuestion rounds per session)

MANDATORY: Skills MUST use XML for Control Plane, Markdown for Data Plane

MANDATORY: Generated skills MUST follow Unified Hybrid Protocol (UHP):

- XML tags for Control Plane (steering, constraints, patterns)
- Markdown for Data Plane (content inside XML tags)
- State management for Interaction Plane (thinking, execution_plan)

No exceptions. Portability invariant must be maintained.
</critical_constraint>
