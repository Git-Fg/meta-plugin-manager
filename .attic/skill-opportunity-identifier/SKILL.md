# Skill Pattern Mining

<mission_control>
<objective>Analyze conversation and codebase to identify patterns suitable for skill or command extraction</objective>
<success_criteria>Patterns identified with clear recommendation (skill vs command vs reject)</success_criteria>
</mission_control>

<trigger>When analyzing conversation/codebase for refactoring opportunities into portable components</trigger>

## When to Use This Skill

Use this skill when:

- Recurring patterns appear across multiple interactions
- Logic is being repeated that could be generalized
- User expresses need for "something reusable"
- A command wrapper anti-pattern is detected
- Complex workflow could benefit from portable component

## Recognition Criteria

<pattern name="skill_candidates">
<when_skill>Logic that Claude invokes contextually based on user intent. Characteristics:
- Reusable across different contexts
- Stateless or state-managed internally
- Decision-making or analysis oriented
- No direct user interaction required
</when_skill>

<when_command>User-triggered workflows with clear entry points. Characteristics:

- Human-initiated actions
- Concrete steps to execute
- Observable execution (not background)
- Result returned to user
  </when_command>

<when_reject>Already exists as skill/command, single-use logic, or over-engineering
</when_reject>
</pattern>

## Analysis Framework

<thinking>
1. Scan conversation history for recurring patterns
2. Identify code/logic duplication
3. Evaluate reusability potential
4. Assess complexity (skill vs command fit)
5. Generate recommendation with rationale
</thinking>

## Output Format

For each opportunity found:

````markdown
## Opportunity: [Descriptive Name]

**Type:** Skill | Command | Reject

**Confidence:** High | Medium | Low

**Rationale:**

- [Evidence 1]
- [Evidence 2]

**Proposed Skeleton:**

```yaml
name: [skill-name]
description: ...
trigger: ...
```
````

</pattern>

---

<critical_constraint>
MANDATORY: Provide evidence for each recommendation
MANDATORY: Distinguish between skill (contextual) and command (user-triggered) candidates
MANDATORY: Reject opportunities that don't meet portability criteria
</critical_constraint>
