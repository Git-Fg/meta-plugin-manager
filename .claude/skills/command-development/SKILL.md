---
name: command-development
description: "Create portable slash commands. Use when: You need a human-triggerable orchestration workflow or 'button' for complex ops. Not for: Reusable logic libraries (use skill-development) or background event handling."
---

# Command Development

Commands are human-invoked orchestrators that bundle skills and tools into coherent workflows. Unlike skills (which Claude can invoke contextually), commands are explicit actions users trigger with `/name`.

**Core principle**: Commands should work standalone without depending on external files or documentation.

---

## What Makes Good Commands

### 1. Human-Facing "Buttons"

Commands are verbs you can invoke intentionally:

- `/plan` - Create implementation plan with confirmation gate
- `/deploy` - Deploy to environment with safety checks
- `/verify` - Run comprehensive verification pipeline
- `/tdd` - Enforce test-driven development workflow

### 2. Orchestration Focus

Commands don't implement logic—they orchestrate. They delegate to agents, skills, or tools.

### 3. Safety and Gating

Commands protect against destructive or high-impact operations with frontmatter guardrails.

---

## Persuasion Principles for Critical Commands

**CRITICAL**: Commands that enforce discipline (TDD, verification, review) require psychological enforcement to prevent shortcuts.

**Use authority language for non-negotiables:**

- MANDATORY: Must follow workflow
- NEVER: Prohibited actions
- ALWAYS: Required verification steps

**Apply commitment techniques:**

- Require explicit user confirmation before destructive operations
- Create psychological barriers to skipping safety checks
- Use strong language for workflow enforcement

**Examples:**

❌ Weak (easily skipped):

```
"It's recommended to test first"
"Consider using TDD"
"Verification would be good"
```

✅ Strong (enforces compliance):

```
MANDATORY: Complete RED phase before GREEN
NEVER skip verification before deployment
ALWAYS provide evidence for completion claims
```

**Recognition**: If command enforces critical workflows (testing, review, safety), use absolute language to prevent rationalization and shortcuts.

---

## Quick Reference

### Command Structure

- **Simple commands**: Just markdown content
- **Complex commands**: Add frontmatter with `disable-model-invocation: true`
- **Interactive commands**: Use frontmatter to require confirmation

### Best Practices

- Keep instructions imperative and concise
- Define clear stop conditions
- Include safety gates for destructive operations
- Delegate to agents/skills rather than implementing logic

### Advanced: Execution Logic (DOT)

For complex commands that orchestrate multi-step processes with failure/retry loops, use **DOT** inside `<execution_logic>` tags. It is superior to text for defining state transitions.

```markdown
<execution_logic>
digraph Workflow {
rankdir=LR;
Plan -> Review;
Review -> Approve [label="Yes"];
Review -> Revise [label="No"];
Revise -> Plan;
Approve -> Execute;
}
</execution_logic>
```

---

## Navigation

| If you need...            | Reference                                        |
| ------------------------- | ------------------------------------------------ |
| Executable examples       | MANDATORY: `references/executable-examples.md`   |
| Frontmatter configuration | MANDATORY: `references/frontmatter-reference.md` |
| Interactive commands      | `references/interactive-commands.md`             |
| Testing strategies        | `references/testing-strategies.md`               |
| Plugin features           | `references/plugin-features-reference.md`        |
| Advanced workflows        | `references/advanced-workflows.md`               |
