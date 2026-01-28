---
description: "Audit all skills in .claude/skills/ against best practices when user mentions 'audit skills' or 'check best practices'. Not for auditing single skills or reviewing code files."
---

<mission_control>
<objective>Audit all skills in .claude/skills/ against best practices</objective>
<success_criteria>Prioritized improvement recommendations with file:line references by severity</success_criteria>
</mission_control>

# Skills Audit

Audit all skills in .claude/skills/ against best practices.

## Approach

**Sequential TaskList Workflow**: Process skills individually through full audit cycle before moving to next skill. Each task represents one complete skill audit with findings documented.

**Task Lifecycle**: Create all tasks first, then execute sequentially:

- Mark task in_progress
- Read skill + frameworks
- Compare
- Document findings
- Mark completed

**This ensures proper state tracking and progressive disclosure.**

## Per-Skill Audit Cycle

1. **Mark current task** as in_progress
2. **Load the skill's SKILL.md** and its references/ (only this skill - progressive disclosure)
3. **Load relevant quality framework** sections from skill-development
4. **Compare against** principles, patterns, anti-patterns, and quality dimensions
5. **Document specific findings** with file:line references
6. **Mark task completed** before starting next skill

## Quality Frameworks

**Use these quality frameworks:**

- **principles rule** - Delta Standard, Progressive Disclosure, Trust AI
- **patterns rule** - Writing style, description patterns
- **anti-patterns rule** - Common mistakes
- **skill-development quality-framework** - Quality dimensions

**Key Dimensions:** structure, writing style, content delta, autonomy, discoverability

## Binary Recognition Questions

**Use these binary questions:**

- **"Would Claude know this without being told?"** → Delta Standard
  - Yes = Remove (Claude already knows)
  - No = Keep (project-specific knowledge)

- **"Can this work standalone?"** → Autonomy
  - Yes = Good (self-sufficient)
  - No = Add Success Criteria

- **"Is the overhead justified?"** → Context fork misuse
  - Yes = Use fork
  - No = Regular invocation

- **"Does this justify its token cost?"** → Context window efficiency
  - Yes = Keep
  - No = Remove or move to references/

## Final Output

**Prioritized improvement recommendations grouped by severity:**

**Critical (Blocking):**

- Security vulnerabilities
- Complete misalignment with standards
- Missing core requirements

**Warning (High Priority):**

- Significant standards drift
- Incomplete implementation
- Quality issues affecting reliability

**Suggestion (Medium Priority):**

- Minor standard deviations
- Documentation gaps
- Nice-to-have enhancements

**Report findings grouped by severity with specific file:line references.**

**Binary test:** "Does audit provide actionable recommendations?" → Must include specific file locations and reference frameworks.

---

<critical_constraint>
MANDATORY: Process skills sequentially through full audit cycle
MANDATORY: Provide file:line references for every finding
MANDATORY: Group findings by severity (Critical/High/Medium/Low)
MANDATORY: Reference quality frameworks (principles, patterns, anti-patterns)
No exceptions. Audit must be comprehensive and actionable.
</critical_constraint>
