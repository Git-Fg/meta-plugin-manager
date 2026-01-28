---
description: Audit skill for YAML compliance, pure XML structure, progressive disclosure, and best practices
argument-hint: <skill-path>
---

<mission_control>
<objective>Audit skill for YAML compliance, pure XML structure, progressive disclosure, and best practices</objective>
<success_criteria>Skill audit completes with XML structure evaluation, compliance findings, and recommendations</success_criteria>
</mission_control>

### Objective

Invoke the skill-auditor subagent to audit the skill at $ARGUMENTS for compliance with Agent Skills best practices.

This ensures skills follow proper structure (pure XML, required tags, progressive disclosure) and effectiveness patterns.

### Process

1. Invoke skill-auditor subagent
2. Pass skill path: $ARGUMENTS
3. Subagent will read updated best practices (including pure XML structure requirements)
4. Subagent evaluates XML structure quality, required/conditional tags, anti-patterns
5. Review detailed findings with file:line locations, compliance scores, and recommendations

### Success Criteria

- Subagent invoked successfully
- Arguments passed correctly to subagent
- Audit includes XML structure evaluation

<critical_constraint>
MANDATORY: Pass skill path as argument to skill-auditor subagent
MANDATORY: Allow subagent to read its own reference files
No exceptions. Skill audit must complete full compliance evaluation.
</critical_constraint>
