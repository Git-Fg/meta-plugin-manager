# User Gates Reference

User gates prevent Claude from charging ahead at critical decision points.

## New Flow: EXPLORE → ASK (batch) → EXPLORE (narrowed) → ASK (batch) → ... → EXECUTE

**CRITICAL**: Use multiple AskUserQuestion rounds to iteratively narrow decisions. Each round batches 1-4 relevant questions based on current investigation state. This is l'entonnoir (the funnel) pattern.

| Phase     | Purpose                                      | Interaction  |
| --------- | -------------------------------------------- | ------------ |
| EXPLORE 1 | Broad investigation                          | Agent only   |
| ASK 1     | Batch 1-4 broad questions (categorization)   | 1 round-trip |
| EXPLORE 2 | Narrowed investigation based on answers      | Agent only   |
| ASK 2     | Batch 1-4 focused questions (identification) | 1 round-trip |
| EXPLORE 3 | Targeted investigation based on answers      | Agent only   |
| ASK 3     | Batch 1-4 specific questions (action)        | 1 round-trip |
| EXECUTE   | Complete task                                | Agent only   |

**Result**: Multiple rounds with funneling, each batch intelligently based on investigation.

---

## L'Entonnoir: The Funnel Pattern

### Ask Once Per Round, Multiple Rounds Total

Each AskUserQuestion call should batch 1-4 relevant questions based on:

- Current investigation state
- Questions that share context
- Dependencies between answers

After response: investigate further, then ask again if needed.

### Full Example: Creating Authentication Plan

**Round 1 - Broad categorization**

User: "Create a plan for authentication"

Agent: [Explores broadly - 25 tool calls]

- Reads BRIEF.md
- Analyzes tech stack
- Checks existing patterns
- Identifies 3 decision areas needed

Agent: AskUserQuestion [Round 1 - 3 questions]
"Q1: Which authentication approach fits your needs?

1. NextAuth.js (OAuth, social login, simple)
2. Custom JWT (API-first, stateless, more control)
3. Session-based (traditional, server-side state)

Q2: Which features do you need? (Select all that apply)

1. Login
2. Registration
3. Password reset
4. Email verification

Q3: Target deployment environment?

1. Development only
2. Staging + Production
3. Multi-region"

User: [Answers all 3]
A1: "1"
A2: ["1", "2", "3"]
A3: "2"

**Round 2 - Narrowed based on answers**

Agent: [Explores specifically - 20 tool calls based on answers]

- Researches NextAuth.js patterns
- Checks OAuth provider options
- Examines deployment requirements
- Reviews production security needs

Agent: AskUserQuestion [Round 2 - 2 questions based on findings]
"Q4: Which OAuth providers should I integrate?

1. Google + GitHub
2. Google only
3. Custom provider list

Q5: Database for user sessions?

1. PostgreSQL (already in project)
2. MongoDB (already in project)
3. Redis (new addition)"

User: [Answers both]
A4: "1"
A5: "3"

**Round 3 - Targeted**

Agent: [Explores target options - 15 tool calls]

- Researches Redis integration
- Checks session management patterns
- Reviews caching strategy

Agent: AskUserQuestion [Round 3 - 1 question]
"Q6: Should I use Redis for session storage with NextAuth, or use the default database adapter?"

User: A6: "Redis"

**Execute**

Agent: [Writes plan]
"Wrote authentication plan using NextAuth.js with Google/GitHub OAuth, Redis sessions, login/register/password reset features, staged for production deployment."

---

## Question Flow Pattern

### Funnel Toward Execution

Each round should narrow the problem space:

**Round 1**: Broad questions (category, scope, priority)
**Round 2**: Focused questions (specific component, approach)
**Round 3**: Targeted questions (exact implementation, confirmation)
**Execute**

### Good Funneling

**Good**: Multiple rounds that narrow efficiently

Round 1: [Explore] "Q1: Type? Q2: Priority?" → User answers
Round 2: [Explore based on answers] "Q3: Component? Q4: Timeline?" → User answers
Round 3: [Explore based on answers] "Q5: Confirm approach?" → User answers
Execute

**Bad**: No investigation between rounds OR no narrowing

Round 1: "Q1: What's wrong?"
Round 2: "Q2: More details?"
Round 3: "Q3: Even more details?"
(No investigation, no funneling, just fishing)

---

## When to Use Gates

### Type 1: Clarification Gates

Used when context is insufficient to proceed:

| Question        | When Asked                            | Skip When...                   |
| --------------- | ------------------------------------- | ------------------------------ |
| Project context | BRIEF.md missing or unclear           | BRIEF.md exists and is clear   |
| Phase selection | Multiple incomplete phases            | One obvious phase exists       |
| Task scope      | No clear scope from request           | Request defines clear scope    |
| Approach        | Multiple valid approaches, need input | One clear best approach exists |

### Type 2: Confirmation Gates

Always asked at decision points:

| Question           | Purpose                              |
| ------------------ | ------------------------------------ |
| Invoke /run-plan?  | User decides execution               |
| Review plan?       | User wants to see details before run |
| Proceed with next? | User confirms milestone completion   |

---

## Good vs Bad Gating

### Good

- Multiple rounds with funneling (broad → focused → targeted)
- Each batch contains 1-4 related questions
- Investigation between rounds based on previous answers
- Each round narrows the problem space
- Final confirmation before execution

### Bad

- Single round with 10+ questions (overwhelming)
- Multiple rounds without investigation between
- Questions that don't share context in same batch
- No narrowing (same scope questions repeated)
- Asking what investigation could discover

---

## Mandatory Gate Points

| Location        | Gate Pattern                                                | When                |
| --------------- | ----------------------------------------------------------- | ------------------- |
| plan-phase      | Round 1: Scope/priority → Round 2: Phase → Round 3: Confirm | Always for planning |
| create-brief    | Round 1: Project type → Round 2: Team size → Round 3: Goals | If brief missing    |
| create-roadmap  | Round 1: Phases → Round 2: Timeline → Round 3: Dependencies | If roadmap unclear  |
| executing-plans | Round 1: Checkpoint review → Round 2: Proceed?              | At each checkpoint  |
| execute-confirm | Single confirmation question                                | Before execution    |

---

## Old vs New

| Pattern       | Before                             | After                                          |
| ------------- | ---------------------------------- | ---------------------------------------------- |
| Rounds        | Single round, ask everything       | Multiple rounds, funneling                     |
| Investigation | Once at beginning                  | Between each round                             |
| Batching      | No batching (one Q per call)       | 1-4 related questions per round                |
| Questions     | Scattered, no context relationship | Grouped by context, answers inform next round  |
| User effort   | Many round-trips, single questions | Fewer round-trips, batched questions per round |
| Narrowing     | None                               | Each round narrows based on previous answers   |

---

## Batching Guidelines

### DO Batch Together

- Questions sharing same investigation context
- Questions where earlier answers inform later options
- Questions about same decision area
- 2-4 questions max per AskUserQuestion call

### DON'T Batch Together

- Unrelated topics (database vs UI vs deployment)
- Questions requiring separate investigation phases
- More than 4 questions (split into multiple rounds)

### Example

**Good batching (Round 1 - Tech stack):**

Q1: Language? (TypeScript/JavaScript/Python)
Q2: Framework? (React/Vue/Angular - based on language)
Q3: Build tool? (Vite/Webpack/Next.js - related to framework)

**Good batching (Round 2 - Deployment - separate round):**

Q4: Hosting platform? (Vercel/Netlify/AWS)
Q5: Environment? (Dev/Staging/Production)

**Bad batching (all in one round):**

Q1: Language?
Q2: Framework?
Q3: Hosting platform? (unrelated to Q1-Q2)
Q4: Favorite color? (unrelated to task)
Q5: Pizza topping? (unrelated)
Q6: Deployment?
Q7-Q10: (too many)

---

## Summary

**L'Entonnoir Protocol for User Gates:**

1. **Explore** - Gather information
2. **Ask** - Batch 1-4 relevant questions based on exploration
3. **Analyze** - Use answers to narrow next exploration
4. **Repeat** - Explore → Ask → Explore → Ask
5. **Confirm** - Final confirmation before execution
6. **Execute** - Complete the task

**Key distinctions:**

- **Multiple rounds** - Funnel toward execution through iteration
- **Intelligent batching** - 1-4 related questions per round based on context
- **Interleaved investigation** - Explore between rounds based on answers
- **Progressive narrowing** - Each round should reduce the problem space
