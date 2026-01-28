---
name: continue
description: "Continue the conversation through simple clarifying questions that progressively narrow down user intent. Not for clear specific requests."
---

<mission_control>
<objective>Continue conversation through natural questioning that helps user clarify and narrow their intent</objective>
<success_criteria>User provides clarity through simple recognition-based questions</success_criteria>
</mission_control>

<interaction_schema>
listen → ask_simple_question → reflect → converge → act
</interaction_schema>

# Continue

Continue a conversation by asking simple clarifying questions.

## When to Use

When the user is unclear, vague, or you need to narrow down their intent:

- Request is ambiguous ("fix it", "make it better")
- Multiple interpretations possible
- User seems unsure what they want
- Conversation has gone off-track

## How It Works

### Step 1: Listen First

Read the user's message carefully. What are they actually asking?

- What words suggest intent?
- What context is available?
- What seems most likely?

### Step 2: Ask Clarifying Questions

Use AskUserQuestion with l'entonnoir (funnel) pattern:

**Good patterns:**

- "Do you mean X or Y?"
- "Are you asking about [A] or [B]?"
- "Which part should I focus on?"
- "Should I [A] or [B]?"

**Batch related questions in one call:**

- 1-4 questions per AskUserQuestion call
- Questions that share context
- Natural language
- Few options (2-3 per question)
- User can answer with recognition

### Step 3: Reflect

Mirror back what you understand:

"OK, so you want me to..."

This confirms understanding and lets user correct you.

### Step 4: Converge

Continue asking until intent is clear. Then proceed.

### Step 5: Act

Once clarity is achieved, take action.

## Example

**User says:** "Make it better"

**You investigate context, then ask:**

"Would you like me to:

1. Improve performance
2. Fix bugs
3. Add features
4. Something else?"

**User selects: "1"**

**You reflect:** "OK, performance is the priority. What aspect?

1. Speed (faster execution)
2. Efficiency (less resources)
3. Both"

## Simple Questions to Try

| Situation         | Question                                      |
| ----------------- | --------------------------------------------- |
| Unclear scope     | "What should I focus on?"                     |
| Multiple options  | "Do you want [A] or [B]?"                     |
| Direction unclear | "Are you trying to achieve [X]?"              |
| Priority needed   | "Which matters more: speed or quality?"       |
| Vague request     | "Can you tell me more about [specific part]?" |

## What to Avoid

- Unrelated questions in the same batch (batch by topic/context)
- Over-batching (5+ questions in one call is overwhelming)
- Technical jargon in questions
- Open-ended questions ("What do you want?")
- Assuming too quickly

## Natural Language

Keep questions conversational:

**Natural:** "So you're saying the login is slow?"

**Robotic:** "Please clarify whether the authentication flow performance degradation is the primary concern."

---

<critical_constraint>
MANDATORY: Batch 1-4 related questions per AskUserQuestion call
MANDATORY: Use simple, natural language
MANDATORY: Let user recognize and confirm, not generate
MANDATORY: Continue until intent is clear before acting
</critical_constraint>
