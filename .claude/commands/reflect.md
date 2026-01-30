---
description: "Refine rules, skills, commands, or documentation. Use when content needs updating. Keywords: refine, update, improve, rules, skills, commands, documentation."
---

<mission_control>
<objective>Analyze and improve .claude/ content</objective>
<success_criteria>Refinement proposed with identified issues and fixes</success_criteria>
</mission_control>

## Quick Start

**To refine content:** Specify type as argument: `/refine rules|skills|commands|documentation`

## Sub-Commands

| Sub-command | Use when | Skill to invoke |
|-------------|----------|-----------------|
| `/refine rules` | CLAUDE.md or rules need updating | `learning:refine-rules` |
| `/refine skills` | A skill needs clarification | `skill-authoring` |
| `/refine commands` | A command needs improvement | `command-authoring` |
| `/refine documentation` | Project docs have drifted | `claude-md-development` |

## Workflow

1. Parse argument to identify refinement type
2. Invoke appropriate skill for analysis methodology
3. Review target content for issues
4. Present findings: "Issues found: [list]. Fix? Confirm?"

## Argument Handling

- **First argument** determines refinement type
- If no argument, prompt user to specify: "What to refine? (rules|skills|commands|documentation)"

---

<critical_constraint>
Invoke the specified skill before analyzing. Present one confirmation question only.
</critical_constraint>
