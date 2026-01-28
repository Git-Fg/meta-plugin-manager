---
description: Audit slash command file for YAML, arguments, dynamic context, tool restrictions, and content quality
argument-hint: <command-path>
---

<mission_control>
<objective>Audit slash command for YAML, arguments, dynamic context, tool restrictions, and content quality</objective>
<success_criteria>Command audit completes with security patterns, content quality findings, and recommendations</success_criteria>
</mission_control>

### Objective

Invoke the slash-command-auditor subagent to audit the slash command at $ARGUMENTS for compliance with best practices.

This ensures commands follow security, clarity, and effectiveness standards.

### Process

1. Invoke slash-command-auditor subagent
2. Pass command path: $ARGUMENTS
3. Subagent will read best practices and evaluate the command
4. Review detailed findings with file:line locations, compliance scores, and recommendations

### Success Criteria

- Subagent invoked successfully
- Arguments passed correctly to subagent

<critical_constraint>
MANDATORY: Pass command path as argument to slash-command-auditor subagent
MANDATORY: Allow subagent to read its own reference files
No exceptions. Command audit must complete full compliance evaluation.
</critical_constraint>
