---
name: refine-rules
description: "Analyze CLAUDE.md and .claude/rules for quality, consistency, and best practices. Use when reviewing project memory files for gaps, redundancies, or alignment issues."
---

# Refine Rules Command

## Current rules state (if exists)

<injected_content>
@CLAUDE.md
@.claude/rules/principles.md
@.claude/rules/architecture.md
@.claude/rules/quality.md
</injected_content>

## Context

Invoke `claude-md-development` skill and read SKILL.md for CLAUDE.md quality patterns and rules organization best practices.

## Workflow

### 1. Detect

Analyze `$ARGUMENTS` for analysis scope:

- **Focus areas**: security, testing, API design, or full analysis
- **Scope limits**: specific directories or all rules
- **Priority emphasis**: gaps, consistency, or delta assessment

Use `AskUserQuestion` if context is unclear.

### 2. Execute

Delegate to `claude-md-development` skill with requirements:

- Analyze injected content for quality (length, progressive disclosure, delta standard)
- Check consistency (contradictions, overlaps, outdated info)
- Identify gaps (missing critical content)
- Generate prioritized report (Critical/High/Medium/Low)

### 3. Verify

Confirm report contains quality findings:

- File:line references for every issue
- Priority classification for each finding
- Zero/negative delta content flagged
- Actionable recommendations

---

## Genetic Code

This component carries essential Seed System principles for context: fork isolation:

<critical_constraint>
MANDATORY: All components MUST be self-contained (zero .claude/rules dependency)
MANDATORY: Description MUST use What-When-Not-Includes format in third person
MANDATORY: No component references another component by name in description
MANDATORY: Use XML for control, Markdown for data
No exceptions. Portability invariant must be maintained.
</critical_constraint>
