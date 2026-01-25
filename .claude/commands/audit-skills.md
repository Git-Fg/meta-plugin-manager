---
description: Audit all skills in .claude/skills/ against best practices
---

# Skills Audit

Think of skills audit as a **medical checkup for your codebase**—systematically examining each skill for health issues before they become critical problems, ensuring each component follows best practices.

## Recognition Patterns

**When to use audit-skills:**
```
✅ Good: "Audit all skills against best practices"
✅ Good: "Check skill quality"
✅ Good: "Identify skill improvements"
❌ Bad: Auditing single skills
❌ Bad: Reviewing code files

Why good: Skills audit examines multiple skills comprehensively against frameworks.
```

**Pattern Match:**
- User mentions "audit skills", "check best practices"
- Need to review multiple skills
- Quality validation required

**Recognition:** "Do you need to audit multiple skills comprehensively?" → Use audit-skills.

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

**Use these quality frameworks** (you must invoke the skill-development skill):

- `.claude/rules/principles.md` - Delta Standard, Progressive Disclosure, Trust AI
- `.claude/rules/patterns.md` - Writing style, description patterns
- `.claude/rules/anti-patterns.md` - Common mistakes
- `.claude/skills/skill-development/references/quality-framework.md` - Quality dimensions

**Key Dimensions**: structure, writing style, content delta, autonomy, discoverability

## Recognition Questions

**Ask these binary questions:**

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

## Contrast

```
✅ Good: Skills in isolated test directories
❌ Bad: Skills in root .claude/skills/

Why good: Test runner needs isolated structure for verification.

✅ Good: Include Success Criteria with self-validation
❌ Bad: No self-validation logic

Why good: Components must validate themselves without external dependencies.

✅ Good: Bundle condensed philosophy
❌ Bad: Reference external .claude/rules/

Why good: Portability requires self-contained components.
```

**Recognition:** "Does this skill follow best practices?" → Check: 1) Delta Standard, 2) Autonomy, 3) Progressive disclosure, 4) Success Criteria.

## Final Output

**Prioritized improvement recommendations grouped by severity:**

### Critical (Blocking)
- Security vulnerabilities
- Complete misalignment with standards
- Missing core requirements

### Warning (High Priority)
- Significant standards drift
- Incomplete implementation
- Quality issues affecting reliability

### Suggestion (Medium Priority)
- Minor standard deviations
- Documentation gaps
- Nice-to-have enhancements

**Report findings grouped by severity with specific file:line references.**

**Recognition:** "Does this audit provide actionable recommendations?" → Must include specific file locations and reference frameworks.
