---
description: "Refine command content. Use when command needs updating. Keywords: refine, commands, update, improve, command."
argument-hint: "[command-name]"
---

<mission_control>
<objective>Update and improve command content</objective>
<success_criteria>Command refined with identified improvements</success_criteria>
</mission_control>

## Quick Start

**If refining commands:** Review commands, explore codebase, ask questions iteratively, apply refinements.

## Patterns

### Command Refinement Flow

1. **Review commands** - Examine .claude/commands/ for issues
2. **Explore codebase** - Identify drift between commands and practice
3. **Ask questions** - use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively to clarify what, how
4. **Apply refinements** - Update command content
5. **Confirm** - Present changes for approval

### Command Authoring Patterns (Reference)

| Pattern | Use When |
|---------|----------|
| Frontmatter | Every command needs YAML frontmatter |
| argument-hint | Show expected argument format |
| mission_control | Define objective and success criteria |
| Quick Start | Scenario-based entry point |
| Workflow | Step-by-step guidance |

---

<critical_constraint>
Trust Claude to identify command improvements from codebase. use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively until scope is clear.
</critical_constraint>
