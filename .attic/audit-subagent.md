---
description: Audit subagent configuration for role definition, prompt quality, tool selection, XML structure compliance, and effectiveness
argument-hint: <subagent-path>
---

<mission_control>
<objective>Audit subagent configuration for XML structure, role definition, prompt quality, and effectiveness</objective>
<success_criteria>Subagent audit completes with findings, file:line references, and actionable recommendations</success_criteria>
</mission_control>

### Objective

Invoke the subagent-auditor subagent to audit the subagent at $ARGUMENTS for compliance with best practices, including pure XML structure standards.

This ensures subagents follow proper structure, configuration, pure XML formatting, and implementation patterns.

### Process

1. Invoke subagent-auditor subagent
2. Pass subagent path: $ARGUMENTS
3. Subagent will read best practices and evaluate the configuration
4. Review detailed findings with file:line locations, compliance scores, and recommendations

### Success Criteria

- Subagent invoked successfully
- Arguments passed correctly to subagent

<critical_constraint>
MANDATORY: Pass subagent path as argument to subagent-auditor
MANDATORY: Allow subagent to read its own reference files
No exceptions. Subagent must complete full audit with findings.
</critical_constraint>
