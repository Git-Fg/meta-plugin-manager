---
description: "Perform deductive analysis and strategic pivots when stuck, after repeated failed approaches or vague feedback like 'it's not right'. Not for clear specific requests or straightforward tasks."
allowed-tools: AskUserQuestion
---

# Strategic Deduction

<mission_control>
<objective>Perform deductive analysis and strategic pivots using analytical frameworks when conversation suggests misalignment</objective>
<success_criteria>User validates inferred direction and conversation proceeds with renewed clarity</success_criteria>
</mission_control>

<trigger>When: user expresses frustration, repeated failed attempts, vague feedback, says 'wait'/'actually' after failures, debugging 15+ minutes with no progress</trigger>

---

<interaction_schema>
DETECT SIGNAL → Select Framework → thinking → STATE INFERENCE → VALIDATE → EXECUTE
</interaction_schema>

Think of strategic reasoning as **reading between the lines**—inferring context, determining direction, and pivoting when needed mid-conversation using analytical frameworks.

## Core Philosophy

**"Infer → Validate → Execute."**

Trust intelligence to read between the lines, infer intent, and determine optimal path. User validates (yes/no/correct), AI executes.

## Reasoning Workflow

**When conversation suggests uncertainty or misalignment:**

1. **Detect Signal** - Notice cues indicating strategic shift needed
2. **Select Framework** - Choose analytical framework to process situation
3. **Apply Deduction** - Use framework to infer what's happening beneath surface
4. **State Inference** - Present deduction clearly for validation
5. **Execute** - Proceed with confidence once validated

## Detection Signals

**Use when these occur:**

- User expresses frustration after repeated attempts
- Multiple failed approaches suggest wrong direction
- Scope changes or requirement pivots mid-task
- Feedback contradicts implemented solution
- User says "wait" or "actually" after failed attempts
- Vague feedback like "it's not right"
- Debugging for 15+ minutes with no progress

**Binary test:** "Is there strategic uncertainty?" → Apply deduction if yes.

## Analytical Frameworks

<thinking>
**Task Analysis:**
Need strategic pivot tools for various complex situations
**Constraints:** Must be mental models (not external tools),快速应用
**Approaches:** Multiple frameworks for different problem types
**Selected:** Provide comprehensive framework matrix for rapid selection
</thinking>

<diagnostic_parameters>
<parameter name="framework_selection">
Choose analytical framework based on problem type
</parameter>

  <parameter name="silent_application">
    Apply frameworks mentally before presenting conclusions
  </parameter>

  <parameter name="inference_validation">
    Always validate inferences with user before proceeding
  </parameter>
</diagnostic_parameters>

**Use these mental models silently:**

| Framework                 | Strategy                          | When                                |
| ------------------------- | --------------------------------- | ----------------------------------- |
| **Inversion**             | Options based on failure modes    | Risk assessment, stuck projects     |
| **Pareto (80/20)**        | Group by impact                   | Prioritization, resource allocation |
| **Root Cause (5 Whys)**   | Distinguish symptoms from systems | Debugging, recurring problems       |
| **Eisenhower Matrix**     | Urgency vs Importance             | Overwhelm, firefighting             |
| **Constraints**           | Where flow is blocked             | Slow velocity, efficiency issues    |
| **First Principles**      | Strip away assumptions            | Innovation, challenging conventions |
| **Occam's Razor**         | Simplest to complex options       | Complexity reduction, debugging     |
| **Second-Order Thinking** | Downstream effects                | Strategic planning, consequences    |
| **Via Negativa**          | What to remove                    | Process improvement, simplification |
| **Leverage Points**       | Effort vs output                  | High-leverage decisions             |

## Inference Pattern

**When pivot signal detected:**

1. **Pause and Analyze** - What does context suggest is really happening?
2. **Apply Framework** - Which mental model explains the situation?
3. **Form Inference** - State deduction explicitly
4. **Validate** - Ask user to confirm/correct inference
5. **Execute** - Proceed with new direction once validated

**Effective inference:**

```
Good: "Based on the context, the real issue is X"
Good: "I infer the real problem is Y, changing approach"
Bad: "Which approach do you prefer?"
Bad: "What do you think is wrong?"
```

**Principle:** Own the deduction and ask for validation, not choice.

## Example Flows

### Example 1: Strategic Pivot

<thinking>
**Context:** Debugging Node.js app for 15 minutes. User: "It's still not working."
**Analysis:** Technical fixes aren't working - might not be technical issue
**Framework:** Pareto (80/20) + Second-Order Thinking
**Inference:** Issue likely expectation mismatch, not technical
**Proposed Pivot:** Switch from debugging to requirements validation
</thinking>

<diagnostic_matrix>
**Context:** Debugging Node.js app for 15 minutes
**Framework Applied:** Pareto + Second-Order Thinking
**Inference:** After fixing 5 bugs, if still 'not working,' issue likely isn't technical—expectation mismatch
**Proposed Pivot:** Switch from debugging to requirements validation
**Validation:** "Should I pivot from debugging to requirements validation?"
</diagnostic_matrix>

**Result:** "Yes, exactly!"

### Example 2: Context Inference

<thinking>
**Context:** Task "add user authentication." Created auth module. User: "Wait, we need social login."
**Analysis:** Scope expansion needed - social login important requirement
**Framework:** Opportunity Cost + First Principles
**Inference:** Design auth system to support both email/password AND social login
**Proposed Pivot:** Expand scope to include social login providers
</thinking>

<diagnostic_matrix>
**Context:** Task "add user authentication." Created auth module. User: "Wait, we need social login."
**Framework Applied:** Opportunity Cost + First Principles
**Inference:** Social login (Google, GitHub, etc.) is requirement, not nice-to-have
**Proposed Pivot:** Design auth system to support both email/password AND social login from start
**Validation:** "Should I expand scope to include social login providers?"
</diagnostic_matrix>

**Result:** "Expand the scope - social login is important"

### Example 3: Multi-File Coordination

<thinking>
**Context:** "Refactor payment system." User: "Make sure you don't break refund functionality."
**Analysis:** Multiple critical paths must be preserved
**Framework:** First Principles + Second-Order Thinking
**Inference:** Identify all payment system critical paths before touching anything
**Proposed Pivot:** Create dependency map to ensure zero regression
</thinking>

<diagnostic_matrix>
**Context:** "Refactor payment system." User: "Make sure you don't break refund functionality."
**Framework Applied:** First Principles + Second-Order Thinking
**Inference:** Identify all payment system critical paths (charge, refund, disputes, reporting) before touching anything
**Proposed Approach:** Create dependency map ensuring zero regression
**Validation:** "Should I map all critical paths before beginning refactoring?"
</diagnostic_matrix>

## Output Format

```markdown
## Deductive Analysis

**Framework Applied:** [name]
**Inference:** [what's really happening]

**Proposed Pivot:**
[Specific direction change]

**Validation:** [confirm/correct inference]
```

## Validation Checklist

Proper deductive reasoning shows:

- Applied framework
- Stated inference clearly
- Asked for validation not choice

**Binary test:** "Does inference reveal strategic direction?" → Proceed if validated.

---

## Absolute Constraints

<critical_constraint>
MANDATORY: Always validate inferences before executing direction changes
MANDATORY: Apply frameworks mentally before presenting conclusions
MANDATORY: State inferences explicitly (not questions to user)
MANDATORY: Own the deduction - don't ask "what do you think"

NO guessing. NO abstractions without frameworks. NO preference questions when inference is clear.
</critical_constraint>
