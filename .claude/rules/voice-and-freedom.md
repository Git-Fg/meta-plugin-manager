# Voice and Degrees of Freedom

This document clarifies two independent concepts:
1. **Voice** - How we write (imperative but natural)
2. **Degrees of Freedom** - How specific we are (high/medium/low)

---

## Voice: Imperative but Natural

### The Standard: Instructional Imperative

**Use imperative voice (bare infinitive) for all skill/command/agent content.**

**Examples from skill-development:**
```
✅ Correct:
- "Follow these steps in order, skipping only when clearly not applicable."
- "Create the skill directory and SKILL.md file."
- "Use third-person in description."
- "Remember that the skill is for another Claude instance to use."
- "Include specific trigger phrases."

❌ Incorrect:
- "You should follow these steps..."
- "Let's create the skill directory..."
- "The skill is for another Claude instance..."
- "You should include specific trigger phrases..."
```

**Why imperative works:**
- Clear, direct instructions
- Reduces ambiguity
- Professional tone
- Efficient (fewer tokens)

### But Make It Natural (Not Robotic)

**Conversational = Natural teaching language, not robotic commands**

**From brainstorming-together and skill-development:**
- "Think of this as the 'why' behind skill creation"
- "Remember that the skill is for another Claude instance to use"
- "This understanding can come from user examples or generated examples"
- "Notice struggles or inefficiencies"
- "Consider how to execute from scratch"

**Natural language includes:**
- Explanations of WHY
- Context and rationale
- Teaching moments
- "Remember that..." / "Think of this as..." / "Consider that..."
- Examples and tables

### Recognition Test

**Ask yourself:**
- "Am I giving clear instructions?" (should be imperative)
- "Am I explaining or teaching?" (can be conversational)
- "Would a senior engineer understand this?" (natural language)
- "Is this robotic or natural?" (should be natural)

---

## Degrees of Freedom: Matching Specificity to Context

### What Are Degrees of Freedom?

Degrees of freedom determine HOW SPECIFIC our instructions are:

**High Freedom** - Provide principles, trust judgment
- "Consider approaches based on context"
- Multiple valid ways to execute
- Let Claude determine method

**Medium Freedom** - Provide structure with flexibility
- "Use this pattern, adapting as needed"
- Suggested approach with room for variation
- Balance guidance and autonomy

**Low Freedom** - Prescriptive steps
- "Execute steps 1-3 precisely"
- Specific sequence required
- Minimal variation allowed

### When to Use Each

**High Freedom (Trust AI Intelligence):**
- When multiple valid approaches exist
- When context determines best path
- Creative or analytical tasks
- Exploration and investigation

**Medium Freedom (Balanced Guidance):**
- When a preferred pattern exists
- Standard workflows with variation
- Complex but manageable tasks

**Low Freedom (Prescriptive):**
- Destructive operations (delete, deploy)
- Safety-critical systems
- Irreversible consequences
- External system requirements

### Recognition Questions

**Ask:**
- "How many valid ways could this be done?" (more = higher freedom)
- "What breaks if Claude chooses differently?" (more breaks = lower freedom)
- "Is this fragile or flexible?" (fragile = lower freedom)

---

## The Matrix: Voice × Freedom

These combine independently:

|  | High Freedom | Medium Freedom | Low Freedom |
|---|---|---|---|
| **Imperative** | "Consider approaches based on context" | "Use this pattern, adapting as needed" | "Execute steps 1-3 precisely" |
| **Natural** | "Think about what makes sense here" | "You might try this structure" | "Here's exactly what to do" |

**Key insight:** You can be imperative (clear instructions) while also being natural (teaching, explaining).

---

## Examples from the Codebase

### Example 1: Imperative + Medium Freedom (skill-development)

```
Follow these steps in order, skipping only when clearly not applicable.

### Step 1: Understand with Concrete Examples

Clearly understand concrete examples of how the skill will be used. This understanding can come from user examples or generated examples validated with feedback.

**Example questions for an image-editor skill:**
- "What functionality should the image-editor skill support? Editing, rotating, anything else?"
- "Can you give some examples of how this skill would be used?"
- "I can imagine users asking for things like 'Remove the red-eye from this image' or 'Rotate this image'. Are there other ways you imagine this skill being used?"

**Conclude this step when:** Clear sense of the functionality the skill should support.
```

**Analysis:**
- Voice: Imperative ("Follow", "Understand", "Conclude")
- Freedom: Medium (structured steps, but room for judgment)
- Natural: Teaching with examples, explaining WHY

### Example 2: Imperative + Low Freedom (command-development)

```
Validation checklist:

1. Check structure: Skill directory exists with SKILL.md
2. Validate SKILL.md: Has frontmatter with name and description
3. Check trigger phrases: Description includes specific user queries
4. Test progressive disclosure: SKILL.md is lean (~1,500-2,000 words)
```

**Analysis:**
- Voice: Imperative ("Check", "Validate", "Test")
- Freedom: Low (exact steps to follow)
- Natural: Clear, direct instructions with rationale

### Example 3: Natural + High Freedom (brainstorming-together)

```
Think of this as a "why" behind skill creation. Understanding principles enables intelligent adaptation; recipes only work for specific situations.

Think of Claude as exploring a path: a narrow bridge with cliffs needs specific guardrails (low freedom), while an open field allows many routes (high freedom).
```

**Analysis:**
- Voice: Natural ("Think of this as", "Understanding enables")
- Freedom: High (principles, not prescriptions)
- Teaching: Metaphors and reasoning

---

## Common Mistakes

### Mistake 1: Robotic Imperative

**❌ Too robotic:**
```
Execute step 1. Execute step 2. Execute step 3.
```

**✅ Better (natural imperative):**
```
Follow these steps in order. Remember to adapt based on context.
```

### Mistake 2: Confusing Voice and Freedom

**❌ Wrong thinking:**
"Low freedom means use 'You should...' instead of imperative"

**✅ Correct:**
Low freedom + imperative = "Execute steps 1-3 precisely"
Low freedom + natural = "Here's exactly what to do"

### Mistake 3: Over-Constraining

**Problem:** Using low freedom when high freedom would work
**Solution:** Ask "What actually breaks if Claude chooses differently?"

### Mistake 4: Not Teaching

**❌ Just commands:**
```
Create skill directory.
Update SKILL.md.
Validate structure.
```

**✅ Better (teaching + imperative):**
```
Create the skill directory and SKILL.md file.

Remember that the skill is for another Claude instance to use. Focus on procedural knowledge and domain-specific details that would help another Claude instance execute tasks more effectively.
```

---

## Summary

**Voice:**
- Use imperative (bare infinitive) for instructions
- Make it natural (teaching, explaining, natural language)
- Avoid robotic commands

**Freedom:**
- Match specificity to task fragility
- Increase when Claude can handle autonomy
- Decrease only when necessary

**Both Together:**
- Voice = HOW we write (imperative but natural)
- Freedom = HOW SPECIFIC we are (high/medium/low)
- Independent choices based on context
