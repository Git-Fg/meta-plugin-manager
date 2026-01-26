---
name: deductive-reasoning
description: Use this skill to infer context, determine strategic direction, and pivot when needed mid-conversation. The AI performs silent deductive reasoning using analytical frameworks and presents findings for user validation.
user-invocable: true
---

# AI-First Deductive Reasoning

Think of deductive reasoning as **reading the user's mind**—not telepathy, but the skill to infer what they actually need from subtle cues in their language, frustration patterns, and unspoken assumptions.

## Core Philosophy

**"Infer → Validate → Execute."**
Trust the AI's intelligence to read between the lines, infer intent, and determine the optimal path. User validates (yes/no/correct), AI executes.

## The Reasoning Protocol

When conversation context suggests uncertainty, misalignment, or a needed pivot:

1. **Detect Signal** - Notice cues indicating strategic shift needed
2. **Select Framework** - Choose analytical framework to process situation
3. **Apply Deduction** - Use framework to infer what's happening beneath surface
4. **State Inference** - Present deduction clearly for validation
5. **Execute** - Proceed with confidence once validated

## Recognition Patterns

**When to use deductive-reasoning:**
```
✅ Good: User says "wait" or "actually" after multiple failed attempts
✅ Good: User asks for something contradicting previous decisions
✅ Good: Debugging for 15+ minutes with no progress
✅ Good: User gives vague feedback like "it's not right"
❌ Bad: Clear, specific requests with no ambiguity
❌ Bad: Straightforward tasks with no complications

Why good: Deductive reasoning shines when context suggests misalignment or strategic pivot needed.
```

**Pattern Match:**
- User expresses frustration after repeated attempts
- Scope changes or requirement pivots mid-task
- Multiple failed approaches suggest wrong direction
- User feedback contradicts implemented solution

**Recognition:** "Does the context suggest a strategic pivot is needed?" → Apply deductive reasoning.

## Analytical Frameworks

Use these mental models silently to create inference options:

| Framework | Strategy | When |
|-----------|----------|------|
| **Inversion** | Options based on failure modes | Risk assessment, stuck projects |
| **Pareto (80/20)** | Group by impact | Prioritization, resource allocation |
| **Root Cause (5 Whys)** | Distinguish symptoms from systems | Debugging, recurring problems |
| **Eisenhower Matrix** | Urgency vs Importance | Overwhelm, firefighting |
| **Constraints** | Where flow is blocked | Slow velocity, efficiency issues |
| **First Principles** | Strip away assumptions | Innovation, challenging conventions |
| **Regret Minimization** | Future timeline choices | Long-term decisions, career moves |
| **Occam's Razor** | Simplest to complex options | Complexity reduction, initial debugging |
| **Opportunity Cost** | What is lost | Mutually exclusive choices |
| **Second-Order Thinking** | Downstream effects | Strategic planning, consequences |
| **Via Negativa** | What to remove | Process improvement, simplification |
| **Leverage Points** | Effort vs output | High-leverage decision making |

## The Inference Pattern

**When you detect a pivot signal:**

1. **Pause and Analyze** - What does context suggest is really happening?
2. **Apply Framework** - Which mental model explains the situation?
3. **Form Inference** - State deduction explicitly
4. **Validate** - Ask user to confirm/correct inference
5. **Execute** - Proceed with new direction once validated

**Contrast:**
```
✅ Good: "Based on the context, the real issue is X"
✅ Good: "I infer the real problem is Y, changing approach"
❌ Bad: "Which approach do you prefer?"
❌ Bad: "What do you think is wrong?"

Why good: You own the deduction and ask for validation, not choice.
```

## Example Flows

### Example 1: Strategic Pivot
**Context**: Debugging Node.js app for 15 minutes. User: "It's still not working."

**Deductive Reasoning**:
```
[Pause. Apply: Pareto + Second-Order Thinking]
[Analyzes: 5 bugs fixed but user still frustrated - suggests wrong direction]
```

**Inference**: "After fixing 5 bugs, if it's still 'not working,' the issue likely isn't technical—it's expectation mismatch. I'll review requirements to understand what success actually looks like. Correct me if I'm wrong, but should I pivot from debugging to requirements validation?"

**User**: "Yes, exactly!"

### Example 2: Context Inference
**Context**: Task "add user authentication." Created auth module. User: "Wait, we need social login."

**Deductive Reasoning**:
```
[Pause. Apply: Opportunity Cost + First Principles]
[Analyzes: Original task expanding. What's the real goal?]
```

**Inference**: "I infer you want social login (Google, GitHub, etc.) as part of authentication. This adds OAuth flow and token management. I'll design the auth system to support both email/password AND social login from the start. Should I proceed with this expanded scope?"

**User**: "Expand the scope - social login is important"

### Example 3: Multi-File Coordination
**Context**: "Refactor payment system." User: "Make sure you don't break refund functionality."

**Deductive Reasoning**:
```
[Pause. Apply: First Principles + Second-Order Thinking]
[Analyzes: Critical paths in payment systems]
```

**Inference**: "You're right to be concerned. I'll identify all payment system critical paths (charge, refund, disputes, reporting) and create a dependency map before touching anything. This ensures zero regression. I'll also write integration tests covering all flows before refactoring."

**Recognition:** "Does this output show proper deductive reasoning?" → Check: 1) Applied framework, 2) Stated inference clearly, 3) Asked for validation not choice.

**For detailed framework applications:**
- `references/framework-deep-dives.md` - Comprehensive framework explanations
- `references/pivot-patterns.md` - Recognition patterns for strategic pivots
- `references/example-flows.md` - Extended example scenarios
