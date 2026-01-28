---
name: brainstorming
description: "Turn ideas into validated designs. Use when creative work starts, requirements are vague, or user intent needs clarification. Not for execution when requirements are clear or simple fixes."
---

# Brainstorming Ideas Into Designs

## Overview

Help turn ideas into fully formed designs and specs through natural collaborative dialogue.

Start by understanding the current project context, then use the l'entonnoir pattern: investigate, batch 1-4 related questions, investigate based on answers, repeat. Once you understand what you're building, present the design in small sections (200-300 words), checking after each section whether it looks right so far.

## The Process

**Understanding the idea:**

- Check out the current project state first (files, docs, recent commits)
- Use l'entonnoir: investigate → batch 1-4 related questions → investigate based on answers → repeat
- Prefer multiple choice questions when possible, but open-ended is fine too
- Batch related questions in one AskUserQuestion call (1-4 max)
- Focus on understanding: purpose, constraints, success criteria

**Exploring approaches:**

- Propose 2-3 different approaches with trade-offs
- Present options conversationally with your recommendation and reasoning
- Lead with your recommended option and explain why

**Presenting the design:**

- Once you believe you understand what you're building, present the design
- Break it into sections of 200-300 words
- Ask after each section whether it looks right so far
- Cover: architecture, components, data flow, error handling, testing
- Be ready to go back and clarify if something doesn't make sense

## After the Design

**Documentation:**

- Write the validated design to `docs/plans/YYYY-MM-DD-<topic>-design.md`
- Use clear, concise language
- Commit the design document to git

**Implementation (if continuing):**

- Ask: "Ready to set up for implementation?"
- Use `using-git-worktrees` to create isolated workspace
- Use `writing-plans` to create detailed implementation plan

## Key Principles

- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended when possible
- **YAGNI ruthlessly** - Remove unnecessary features from all designs
- **Explore alternatives** - Always propose 2-3 approaches before settling
- **Incremental validation** - Present design in sections, validate each
- **Be flexible** - Go back and clarify when something doesn't make sense

## Question Strategies

### Understanding Phase

**Open-ended questions:**

- "What's the core problem you're trying to solve?"
- "Who is the primary user?"
- "What does success look like?"

**Clarifying questions:**

- "When you say X, do you mean...?"
- "Should this work with...?"
- "Is this a requirement or a nice-to-have?"

### Approach Exploration

**Multiple choice format:**

```
For the architecture, which approach works best?
1. Serverless (cost-effective, scales automatically)
2. Containerized (more control, higher complexity)
3. Managed service (least maintenance, vendor lock-in)

I recommend #1 because... [reasoning]
```

### Design Validation

**Section-by-section review:**

```
Let's validate the design section by section:

**Section 1: Architecture**
- Proposed: Microservices with API gateway
- Reasoning: [why this approach]

Does this section look right, or should I adjust anything?
```

## Common Mistakes

**Too many questions at once:**

- ❌ "Should we use TypeScript or JavaScript? And what about testing framework? Also, styling?"
- ✅ "Let's start with language choice. TypeScript or JavaScript?"

**Skipping context check:**

- ❌ Jump straight to questions
- ✅ First review project state, recent commits, existing patterns

**Leading questions:**

- ❌ "You want to use React, right?"
- ✅ "What frontend framework would you prefer?"

**Not validating incrementally:**

- ❌ Present full design, get feedback, start over
- ✅ Present sections, validate each, build on validated foundation

**YAGNI violations:**

- ❌ "While we're at it, let's also add..."
- ✅ "That's out of scope for this feature"

## Red Flags

**Rationalizations to watch for:**

- "This seems complex, let's just..."
- "We can add that later"
- "It's easier if we..."
- "What if we also..."
- "Since we're already..."

**Red flag questions:**

- "Is X important?" (trivializing important decisions)
- "Should we include Y?" (adding scope creep)
- "Do you prefer A or B?" (without context for decision)

## Example Workflow

```
User: "I want to add user authentication"

[Check project state - see existing auth patterns]

1. "What type of authentication do you need?"
   a) Login with email/password
   b) OAuth (Google, GitHub, etc.)
   c) Both
   d) Other?

[User selects b)]

2. "For OAuth providers, which ones matter?"
   a) Google (personal users)
   b) GitHub (developer users)
   c) Both Google and GitHub
   d) Other?

[User selects c)]

3. "Should we use an existing auth service or build custom?"
   a) Auth0/Supabase (faster setup)
   b) Custom (more control)
   c) Not sure

[User selects a)]

[Continue refining...]

[Present design in sections]

**Section 1: Architecture**
Based on your needs, I recommend using Supabase Auth for OAuth integration:

- Provider: Supabase (handles OAuth flow, session management)
- Database: Extend existing user table with Supabase IDs
- Frontend: Add Supabase client, implement login/logout

Does this architecture look right?
```

## Key Principles Summary

1. **One question at a time** - Prevents overwhelm
2. **Multiple choice preferred** - Reduces cognitive load
3. **YAGNI ruthlessly** - Prevents scope creep
4. **Explore alternatives** - Ensures informed decisions
5. **Incremental validation** - Catches issues early
6. **Check context first** - Builds on existing patterns
7. **YAGNI ruthlessly** - Focus on core value
8. **Be flexible** - Design evolves through dialogue

Remember: The goal is to turn a vague idea into a concrete, validated design through collaborative exploration.

---

<critical_constraint>
MANDATORY: Check project context before asking questions
MANDATORY: One question at a time (never overwhelm)
MANDATORY: Validate design section by section before proceeding
MANDATORY: Apply YAGNI ruthlessly (remove unnecessary features)
MANDATORY: Commit design document to git
No exceptions. Validation before commitment prevents rework.
</critical_constraint>
