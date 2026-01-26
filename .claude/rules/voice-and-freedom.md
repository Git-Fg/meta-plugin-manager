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

## Degrees of Freedom: Default to Highest Freedom

### The Default: High Freedom

**Consider starting with HIGH FREEDOM unless a clear constraint exists.**

Reduce freedom when:
- Operations are destructive (irreversible)
- Safety-critical systems
- External system requirements
- Error consequences are severe

**Default pattern:**
- Provide principles and context
- Trust Claude's intelligence
- Let Claude determine approach
- Multiple valid ways to execute

**Reduce when justified:**
- Operations are fragile or error-prone
- Consistency is critical
- Irreversible consequences
- External system sequences required

### Recognition Questions

**Ask:**
- "What breaks if Claude chooses differently?" (more breaks = lower freedom)
- "Is this fragile or flexible?" (fragile = lower freedom)
- "Why can't Claude figure this out?" (answer this honestly)

### Why High Freedom Default?

From skill-development:
```
Why good: High-level guidance trusts Claude to handle implementation details

Why bad: Prescriptive commands insult intelligence and waste tokens.
```

Trust Claude's intelligence. Start with principles, not prescriptions.

---

## The Matrix: Voice × Freedom

These combine independently:

|  | High Freedom | Medium Freedom | Low Freedom |
|---|---|---|---|
| **Imperative** | "Consider approaches based on context" | "Use this pattern, adapting as needed" | "Execute steps 1-3 precisely" |
| **Natural** | "Think about what makes sense here" | "You might try this structure" | "Here's exactly what to do" |

**Key insight:** You can be imperative (clear instructions) while also being natural (teaching, explaining).

---

## Common Mistakes

### Mistake 1: Starting with Low Freedom

**❌ Too prescriptive from the start:**
```
Execute step 1. Execute step 2. Execute step 3.
Use mkdir -p command.
Run touch command.
```

**✅ Better (default to high freedom):**
```
Follow these steps in order. Trust Claude to handle implementation details.
```

**Why:** Start with highest freedom. Only reduce when justified.

### Mistake 2: Robotic Imperative

**❌ Too robotic:**
```
Execute step 1. Execute step 2. Execute step 3.
```

**✅ Better (natural imperative):**
```
Follow these steps in order. Remember to adapt based on context.
```

### Mistake 3: Confusing Voice and Freedom

**❌ Wrong thinking:**
"Low freedom means use 'You should...' instead of imperative"

**✅ Correct:**
Low freedom + imperative = "Execute steps 1-3 precisely"
Low freedom + natural = "Here's exactly what to do"

### Mistake 4: Over-Constraining

**Problem:** Using low freedom when high freedom would work
**Solution:** Ask "What actually breaks if Claude chooses differently?"

### Mistake 5: Not Teaching

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

## Reference Guidelines

### Why References Matter

References provide essential context that affects task quality. Simply linking to them doesn't ensure consumption. When users skip references, it often leads to incomplete understanding and lower quality output.

### Making References Clear

**Use clear language:**

✅ **Good examples:**
```
Read references/frontmatter-reference.md before configuring command frontmatter.
Remember that invalid frontmatter causes silent failures.
```

**Navigation patterns:**
```
| If you are... | Read... |
|---------------|---------|
| Creating commands | references/executable-examples.md |
| Configuring frontmatter | references/frontmatter-reference.md |

These references contain validation rules that prevent common errors.
```

**Progressive disclosure:**

```
## Frontmatter Validation

Read references/frontmatter-reference.md before configuring command frontmatter.

Invalid frontmatter causes silent failures. The reference contains:
- Required fields and validation rules
- Common error patterns and fixes
- Testing strategies for frontmatter
```

**Questions to consider:**
- What happens if this reference is skipped?
- Is this context critical for quality?
- Could the task be completed without this?

---

## Summary

**Voice:**
- Use imperative (bare infinitive) for instructions
- Make it natural (teaching, explaining, natural language)
- Avoid robotic commands

**Freedom:**
- **DEFAULT: Consider starting with HIGH FREEDOM**
- Trust Claude's intelligence
- Reduce freedom when justified (destructive, safety-critical, external requirements)
- Ask "What breaks if Claude chooses differently?"

**References:**
- Make critical references clear
- Explain WHY skipping is problematic
- Use progressive disclosure to ensure consumption

**Natural Communication:**
- Explain WHY alongside HOW
- "Think of this as..." / "Remember that..." / "Benefits:"
- Use examples and rationale
- "Why bad/good" explanations

**Both Together:**
- Voice = HOW we write (imperative but natural)
- Freedom = HOW SPECIFIC we are (start high, reduce when needed)
- Independent choices based on context
