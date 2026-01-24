---
name: meta-critic
description: "Audit conversation alignment between requests, actions, and knowledge standards. Use when: quality check needed, workflow validation, standards compliance review, detecting drift. Not for creating content or executing tasks."
user-invocable: true
---

# Meta-Critic

The feedback loop for v4 architecture. Compares what was requested vs what was done vs what knowledge standards specify.

## Core Purpose

Meta-critic is the "Senior Dev" that performs code review on the agent's work. It bridges the gap between Knowledge (Brain) and Factory (Hands) by validating alignment.

## When to Use

Invoke meta-critic when:
- Quality check needed after workflow completion
- Workflow validation before proceeding
- Standards compliance review
- Detecting drift between request and execution
- Verifying knowledge-factory alignment
- Post-implementation audit

## What It Does

Meta-critic analyzes recent conversation to perform three-way comparison:

1. **What was Requested**: Extract user's original intent and requirements
2. **What was Done**: Review actual actions taken and outputs produced
3. **What Standards Specify**: Compare against knowledge-skills standards

## Analysis Framework

### Alignment Check

| Dimension | Check | Pass Criteria |
|-----------|-------|---------------|
| **Intent** | Did actions match user's stated goal? | Direct alignment |
| **Standards** | Does output comply with knowledge-skills? | No violations |
| **Completeness** | Were all requirements addressed? | 100% covered |
| **Quality** | Is work production-ready? | ≥80/100 score |
| **Drift** | Did implementation diverge from request? | No deviation |

### Critique Output Format

```markdown
## Meta-Critic Review

### Alignment Assessment
- **Request**: [What was asked]
- **Delivered**: [What was done]
- **Gap**: [Any mismatches]

### Standards Compliance
- **knowledge-skills**: [Pass/Fail] [Notes]
- **Relevant standards**: [Specific references]

### Quality Score
- **Autonomy**: [X/10] - [Notes]
- **Completeness**: [X/10] - [Notes]
- **Standards**: [X/10] - [Notes]

### Findings
✅ **Strengths**: [What went well]
⚠️ **Issues**: [Problems found]
❌ **Critical**: [Blocking issues if any]

### Recommendations
1. [Specific actionable recommendations]
2. [Priority order]
```

## Usage Pattern

### Manual Invocation

User or agent invokes meta-critic when review is needed:

"Run meta-critic to validate this workflow aligns with standards."

### Automated Trigger

Meta-critic can be invoked automatically after:
- Complex multi-step workflows
- Factory skill execution
- Knowledge-dependent implementations

## Integration with Knowledge Skills

Meta-critic uses knowledge-skills as reference baseline:

| Knowledge Skill | Meta-Critic Uses For |
|-----------------|---------------------|
| knowledge-skills | Structure validation, description quality |
| knowledge-mcp | MCP configuration correctness |
| knowledge-hooks | Hook implementation standards |
| knowledge-subagents | Agent configuration validation |

## Critique Principles

### Constructive Feedback

- ✅ Specific, actionable recommendations
- ✅ Reference to specific standards
- ✅ Priority-based issue ordering
- ✅ Recognition of good work

### Avoid

- ❌ Vague criticism
- ❌ Prescription without rationale
- ❌ Ignoring context
- ❌ Micromanagement

## Examples

### Example 1: Post-Factory Review

**Context**: After create-skill execution

**Meta-Critic Analysis**:
- Request: Create skill for Docker log scanning
- Delivered: Skill created with fork context, scripts/
- Standards: knowledge-skills specifies structure
- Alignment: ✅ Pass - Proper use of fork for verbose task

### Example 2: Drift Detection

**Context**: API endpoint creation

**Meta-Critic Analysis**:
- Request: RESTful API with standard response format
- Delivered: API with inconsistent responses
- Standards: knowledge-skills specifies consistency
- Alignment: ❌ Fail - Response format drift detected

## Completion Marker

## META_CRITIC_COMPLETE
