---
description: Audit all skills in .claude/skills/ against best practices
---

# Skills Audit

Perform a comprehensive audit of all skills in `.claude/skills/` against best practices.

IMPORTANT: Meta-skills are exempt from the 500-line limit; and globally this is a best practices and should not be enforced blindly, only when it makes sense and the content is not generally relevant even for context. 

## Skill Lists 

!`tree .claude/skills/`

## Frameworks

Use these quality frameworks (you must invoke the skill-development skill):
- `.claude/rules/principles.md` - Delta Standard, Progressive Disclosure, Trust AI
- `.claude/rules/patterns.md` - Writing style, description patterns
- `.claude/rules/anti-patterns.md` - Common mistakes
- `.claude/skills/skill-development/references/quality-framework.md` - Quality dimensions

## Approach

**Sequential TaskList Workflow**: Process skills individually through full audit cycle before moving to next skill. Each task represents one complete skill audit with findings documented.

**Task Lifecycle**: Create all tasks first, then execute sequentially: mark task in_progress → read skill + frameworks → compare → document findings → mark completed. This ensures proper state tracking and progressive disclosure.

**Per-Skill Audit Cycle**:
1. Mark current task as in_progress
2. Load the skill's SKILL.md and its references/ (only this skill - progressive disclosure)
3. Load relevant quality framework sections from skill-development
4. Compare against principles, patterns, anti-patterns, and quality dimensions
5. Document specific findings with file:line references
6. Mark task completed before starting next skill

**Quality Dimensions**: structure, writing style, content delta, autonomy, discoverability

**Final Output**: Prioritized improvement recommendations grouped by severity (critical/warning/suggestion)

## Key Recognition Questions

- "Would Claude know this without being told?" (Delta Standard)
- "Can this work standalone?" (Autonomy)
- "Is the overhead justified?" (Context fork misuse)
- "Does this justify its token cost?" (Context window as public good)

Report findings grouped by severity (critical/warning/suggestion) with specific references.
