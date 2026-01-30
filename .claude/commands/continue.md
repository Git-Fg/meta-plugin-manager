---
description: "Continue conversation through clarifying questions when user intent is unclear. Use when requests are vague, ambiguous, or need narrowing. For session handoffs, use /handoff:resume instead."
---

# Continue Command

<mission_control>
<objective>Clarify user intent through focused questions when conversation has context but direction is unclear</objective>
<success_criteria>Intent clarified through 1-4 rounds of recognition-based questions, ready to proceed</success_criteria>
</mission_control>

## When to Use

Use when:

- Request is ambiguous ("fix it", "make it better")
- Multiple interpretations possible
- User seems unsure what they want
- Conversation has gone off-track
- Intent needs narrowing

**Not for:**

- Blank sessions (use `/handoff:resume` for that)
- Technical clarifications (ask directly)
- Clarifications about previous work (continue naturally)

## Workflow

### Step 1: Listen First

Read the user's message carefully:

- What words suggest intent?
- What context is available?
- What seems most likely?

### Step 2: Ask Clarifying Questions

Use `AskUserQuestion` with funnel pattern (L'Entonnoir):

**Good patterns:**

- "Do you mean X or Y?"
- "Are you asking about [A] or [B]?"
- "Which part should I focus on?"
- "Should I [A] or [B]?"

**Batch related questions:**

- 1-4 questions per call
- Questions that share context
- Few options (2-3 per question)
- User answers with recognition

### Step 3: Reflect

Mirror back what you understand:

"OK, so you want me to..."

This confirms understanding and lets user correct.

### Step 4: Converge

Continue asking until intent is clear, then proceed.

## Simple Questions to Try

| Situation         | Question                                      |
| ----------------- | --------------------------------------------- |
| Unclear scope     | "What should I focus on?"                     |
| Multiple options  | "Do you want [A] or [B]?"                     |
| Direction unclear | "Are you trying to achieve [X]?"              |
| Priority needed   | "Which matters more: speed or quality?"       |
| Vague request     | "Can you tell me more about [specific part]?" |

## What to Avoid

- Unrelated questions in the same batch
- Over-batching (5+ questions is overwhelming)
- Technical jargon in questions
- Open-ended questions ("What do you want?")
- Assuming too quickly

## Usage Patterns

**Default (clarify intent):**

```
/continue
[Conversation has context → Ask clarifying questions → Converge on intent]
```

## Recognition Questions

- "Is conversation context available?" → Continue mode
- "Is intent clear?" → Converge or ask more
- "Is this a blank session?" → Use `/handoff:resume`

---

## Validation Checklist

Before claiming clarification complete:

- [ ] User intent identified through questions
- [ ] 1-4 questions per batch (not overwhelming)
- [ ] Recognition-based options (2-4 choices)
- [ ] Intent confirmed before proceeding
- [ ] No unrelated questions in same batch
- [ ] Converged on clear direction

---

<critical_constraint>
MANDATORY: Batch 1-4 questions per AskUserQuestion call
MANDATORY: Converge on intent before acting
MANDATORY: Use recognition-based questions (2-4 options)
MANDATORY: For handoffs, use /handoff:resume directly
No exceptions. Continue enables intent clarification.
</critical_constraint>
