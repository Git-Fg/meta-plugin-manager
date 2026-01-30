---
description: "Refine skill content. Use when skill needs updating. Keywords: refine, skills, update, improve, skill."
argument-hint: "[skill-name]"
---

<mission_control>
<objective>Update and improve skill content</objective>
<success_criteria>Skill refined with identified improvements</success_criteria>
</mission_control>

## Quick Start

**If refining skills:** Review skills, explore codebase, ask questions iteratively, apply refinements.

## Patterns

### Skill Refinement Flow

1. **Review skills** - Examine SKILL.md files for issues
2. **Explore codebase** - Identify drift between skills and practice
3. **Ask questions** - use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively to clarify what, how
4. **Apply refinements** - Update skill content
5. **Confirm** - Present changes for approval

### Skill Authoring Patterns (Reference)

| Pattern | Use When |
|---------|----------|
| Frontmatter | Every skill needs YAML frontmatter first |
| Quick Start | Skills should open with scenario-based guidance |
| Navigation | Multi-section skills need "If you need... Read..." tables |
| PATTERN: | Core workflows and standard approaches |
| ANTI-PATTERN: | What to avoid, common mistakes |
| EDGE: | Special cases and unusual conditions |
| critical_constraint | Non-negotiable rules at file bottom |

---

<critical_constraint>
Trust Claude to identify skill improvements from codebase. use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively until scope is clear.
</critical_constraint>
