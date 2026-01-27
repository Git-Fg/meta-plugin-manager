---
description: "Perform deductive analysis and strategic pivots when stuck. Use when: user expresses frustration after repeated attempts, multiple failed approaches, vague feedback like 'it's not right', user says 'wait'/'actually' after failed attempts, debugging 15+ minutes with no progress. Not for: clear specific requests, straightforward tasks."
allowed-tools: ["AskUserQuestion"]
---

# Strategic Deduction

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

**Use these mental models silently:**

| Framework | Strategy | When |
|-----------|----------|------|
| **Inversion** | Options based on failure modes | Risk assessment, stuck projects |
| **Pareto (80/20)** | Group by impact | Prioritization, resource allocation |
| **Root Cause (5 Whys)** | Distinguish symptoms from systems | Debugging, recurring problems |
| **Eisenhower Matrix** | Urgency vs Importance | Overwhelm, firefighting |
| **Constraints** | Where flow is blocked | Slow velocity, efficiency issues |
| **First Principles** | Strip away assumptions | Innovation, challenging conventions |
| **Occam's Razor** | Simplest to complex options | Complexity reduction, debugging |
| **Second-Order Thinking** | Downstream effects | Strategic planning, consequences |
| **Via Negativa** | What to remove | Process improvement, simplification |
| **Leverage Points** | Effort vs output | High-leverage decisions |

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

**Example 1: Strategic Pivot**
- Context: Debugging Node.js app for 15 minutes. User: "It's still not working."
- Apply: Pareto + Second-Order Thinking
- Inference: "After fixing 5 bugs, if still 'not working,' issue likely isn't technical—expectation mismatch. Should I pivot from debugging to requirements validation?"
- Result: "Yes, exactly!"

**Example 2: Context Inference**
- Context: Task "add user authentication." Created auth module. User: "Wait, we need social login."
- Apply: Opportunity Cost + First Principles
- Inference: "I infer you want social login (Google, GitHub, etc.) as part of authentication. Design auth system to support both email/password AND social login from the start."
- Result: "Expand the scope - social login is important"

**Example 3: Multi-File Coordination**
- Context: "Refactor payment system." User: "Make sure you don't break refund functionality."
- Apply: First Principles + Second-Order Thinking
- Inference: "Identify all payment system critical paths (charge, refund, disputes, reporting) and create dependency map before touching anything. This ensures zero regression."

## Output Format

```
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
