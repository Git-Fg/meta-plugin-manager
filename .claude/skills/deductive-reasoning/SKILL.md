---
name: deductive-reasoning
description: Use this skill to infer context, determine strategic direction, and pivot when needed mid-conversation. The AI performs silent deductive reasoning using analytical frameworks and presents findings for user validation.
user-invocable: true
---

# AI-First Deductive Reasoning

This is an **internal reasoning engine** for Claude to infer context and determine next steps during task execution.

**Execution Mode**: When conversation context suggests a pivot, misalignment, or strategic shift, pause and apply deductive reasoning. Infer what the user actually needs based on evidence, then present your inference for validation.

**Core Philosophy**: **"Infer → Validate → Execute."**
Trust the AI's intelligence to read between the lines, infer intent, and determine the optimal path. User validates (yes/no/correct), AI executes.

---

## The Reasoning Protocol (Internal)

When conversation context suggests uncertainty, misalignment, or a needed pivot:

1.  **Detect Signal**: Notice cues that indicate a strategic shift is needed (user frustration, scope changes, repeated issues, etc.)
2.  **Select Framework**: Choose one of the 12 analytical frameworks (below) to process the situation
3.  **Apply Deduction**: Use the framework to infer what's actually happening beneath the surface
4.  **State Inference**: Present your deduction clearly and ask for validation (not choice)
5.  **Execute**: Once validated, proceed with confidence

### Analytical Frameworks (For Hypothesis Generation)

Use these mental models silently to create your multiple-choice options. **NEVER** lecture the user on these frameworks.

| Concept | Option Generation Strategy | When to Use |
|---------|----------------|-------------|
| **Inversion** | Create options based on specific failure modes. "Which risk scares you most: A, B, or C?" | Risk assessment, prevention, "stuck" projects |
| **Pareto (80/20)** | Group options by impact. "Which of these few tasks drives the most value?" | Prioritization, resource allocation |
| **Root Cause (5 Whys)** | Create options distinguishing symptoms from systems. "Is this an Individual, Process, or Technology failure?" | Debugging, recurring problems |
| **Eisenhower Matrix** | Options based on Urgency vs Importance. "Is this 'Do it now', 'Schedule it', or 'Delegate it'?" | Overwhelm, firefighting |
| **Constraints (Bottlenecks)** | Options based on where flow is blocked. "Is the bottleneck: Policy, Capacity, or Skill?" | Slow velocity, efficiency issues |
| **First Principles** | Options stripping away assumptions. "If we ignore X, does Y still matter?" | Innovation, challenging conventions |
| **Regret Minimization** | Options based on future timelines. "In 1 year, which choice will you regret least?" | Long-term decisions, career moves |
| **Occam's Razor** | Options ranging from Simplest to Complex. "Is the simplest explanation X or Y?" | Complexity reduction, initial debugging |
| **Opportunity Cost** | Options defining what is lost. "By choosing A, are we giving up X or Y?" | Mutually exclusive choices |
| **Second-Order Thinking** | Options based on downstream effects. "What happens *after* we solve this?" | Strategic planning, consequences |
| **Via Negativa** | Options based on subtraction. "What can we *remove* to solve this?" | Process improvement, simplification |
| **Leverage Points** | Options based on effort vs. output. "Which single action makes the others unnecessary?" | High-leverage decision making |

---

## When to Apply Deductive Reasoning

Use this skill when you detect these signals:

**Context Cues:**
- User says "wait" or "actually" (scope change)
- User expresses frustration after multiple attempts
- User asks for something that contradicts previous decisions
- User gives vague feedback like "it's not right" after you've implemented exactly what was requested
- User changes requirements mid-task

**Strategic Pivots:**
- You've been debugging but making no progress
- Task scope has silently expanded
- You're solving symptoms instead of root causes
- User expectations don't match reality
- Multiple failed approaches suggest wrong direction

## The Inference Pattern

**When you detect a pivot signal:**

1.  **Pause and Analyze**: What does the context suggest is really happening?
2.  **Apply Framework**: Which mental model explains the situation?
3.  **Form Inference**: State your deduction explicitly
4.  **Validate**: Ask user to confirm/correct your inference
5.  **Execute**: Proceed with new direction once validated

---

## Interaction Rules

### 🚫 Anti-Patterns (Do Not Do)
*   **Don't make user solve the problem**: "Which approach do you prefer?" (BAD - You're the expert, decide)
*   **Don't ask open-ended questions**: "What do you think is wrong?" (BAD - Infer from context)
*   **Don't brute force multiple approaches**: Try A, then B, then C (BAD - Use reasoning to pick one)
*   **Don't ignore pivot signals**: User says "wait" but you continue (BAD - Pause and infer)

### ✅ Success Patterns (Do This)
*   **Infer and State**: "Based on the context, the real issue is X." (GOOD - Own the deduction)
*   **Validate, Don't Choose**: "Is this inference correct?" (GOOD - User validates, you execute)
*   **Read Between Lines**: User frustration + multiple failed fixes = wrong direction (GOOD - Apply framework)
*   **Pivot Confidently**: "I infer the real problem is Y, changing approach." (GOOD - Show strategic thinking)

---

## Example Flows

### Example 1: Mid-Conversation Strategic Pivot

**Context**: You've been debugging a Node.js app for 15 minutes. User says: "It's still not working."

**AI (Deductive Reasoning)**:
```
[Pause. Apply analytical framework: Pareto + Second-Order Thinking]
[Analyzes: 5 different errors have been fixed, but user still says "not working" - suggests we're fixing symptoms, not root cause]
```

**AI (Internal Insight)**: *We've fixed 5 individual bugs but user still frustrated. Pareto suggests 1-2 bugs cause 80% of issues. Second-Order thinking: What if the "not working" isn't about bugs at all - maybe about user expectations vs. reality?*

**AI (Output)**:
"I'm changing approach. After fixing 5 bugs, if it's still 'not working,' the issue likely isn't technical - it's expectation mismatch. I'll review the requirements documentation to understand what success actually looks like. Correct me if I'm wrong, but should I pivot from debugging to requirements validation?"

**User**: "Yes, exactly!"

---

### Example 2: Context Inference Mid-Task

**Context**: Task was "add user authentication." You've created the auth module, but user now says: "Wait, we need to think about social login."

**AI (Deductive Reasoning)**:
```
[Pause. Apply analytical framework: Opportunity Cost + First Principles]
[Analyzes: Original task was basic auth, now expanding scope. What's the real goal?]
```

**AI (Internal Insight)**: *User mentioned social login after auth was being built. This suggests: either (1) they forgot to mention it initially, OR (2) they just realized they need it, OR (3) they're exploring options. First Principles: What's the business goal? Opportunity Cost: How much work is this adding?*

**AI (Output)**:
"I infer you want social login (Google, GitHub, etc.) as part of authentication. This adds OAuth flow, token management, and user linking. I'll design the auth system to support both email/password AND social login from the start. Should I proceed with this expanded scope, or do you want to prioritize basic auth first?"

**User**: "Expand the scope - social login is important"

---

### Example 3: Multi-File Task Coordination

**Context**: Task is "refactor the payment system." You've updated 3 files. User says: "Make sure you don't break the refund functionality."

**AI (Deductive Reasoning)**:
```
[Pause. Apply analytical framework: First Principles + Second-Order Thinking]
[Analyzes: Refactoring payment system, user mentions refund as critical. Are there other critical paths?]
```

**AI (Internal Insight)**: *User specifically calls out refund as critical. In payment systems, the critical paths are: charge, refund, dispute handling, and reporting. They're probably worried we'll break one while fixing another.*

**AI (Output)**:
"You're right to be concerned. I'll identify all payment system critical paths (charge, refund, disputes, reporting) and create a dependency map before touching anything. This ensures zero regression. I'll also write integration tests covering all flows before refactoring. Sound good?"

**User**: "Yes - especially refunds and disputes"