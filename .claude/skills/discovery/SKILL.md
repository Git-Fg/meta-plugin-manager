---
name: discovery
description: "Conduct discovery interviews to gather requirements, clarify vague ideas, and create detailed specifications. Use when gathering requirements, clarifying vague ideas, or starting new projects. Includes interview guidance, requirement extraction, and specification templates. Not for execution, simple partial updates, or when requirements are already clear."
user-invocable: true
---

**Skill Location**: This file

<mission_control>
<objective>Conduct discovery interviews to gather requirements, clarify vague ideas, and create detailed specifications through thorough exploration.</objective>
<success_criteria>Minimum 10-15 questions, research loops for non-trivial projects, completeness check before spec</success_criteria>
</mission_control>

## Workflow

**Conduct discovery interviews systematically:**

1. **Initial Orientation →** 2-3 questions to understand project type → Result: Clear project context
2. **Category Deep Dive →** 2-4 questions per category (A-H) → Result: Detailed requirements
3. **Research Loops →** Investigate knowledge gaps → Result: Informed decisions
4. **Conflict Resolution →** Surface impossible requirements → Result: Resolved tradeoffs
5. **Completeness Check →** Verify all areas covered → Result: Ready for spec
6. **Spec Generation →** Create actionable document → Result: Implementation-ready spec

**Why:** L'Entonnoir pattern ensures thorough exploration—minimum 10-15 questions prevent slop and produce quality specs.

## Operational Patterns

This skill follows these behavioral patterns:

- **Discovery**: Locate files matching patterns and search file contents for project context
- **Delegation**: Delegate exploration to specialized workers for research
- **Consultation**: Consult the user with options during interview phases
- **Tracking**: Maintain a visible task list throughout discovery

Use native tools to fulfill these patterns. Trust the System Prompt to select the correct implementation.

## Navigation

| If you need...                  | Read...                           |
| :------------------------------ | :-------------------------------- |
| Initial orientation questions   | ## Workflow → Initial Orientation |
| Category deep dive (A-H)        | ## Workflow → Category Deep Dive  |
| Research unknown areas          | ## Workflow → Research Loops      |
| Resolve impossible requirements | ## Workflow → Conflict Resolution |
| Create specification document   | ## Workflow → Spec Generation     |
| Templates and examples          | resources/templates/              |

## Workflow Decision Tree

### What Stage of Discovery?

| If you need to...                                      | Read this section             |
| ------------------------------------------------------ | ----------------------------- |
| **Initial clarity** → Understand core problem          | Phase 1: Initial Orientation  |
| **Category deep dive** → Explore specific areas        | Phase 2: Category-by-Category |
| **Research gaps** → Investigate unknowns               | Phase 3: Research Loops       |
| **Resolve conflicts** → Handle impossible requirements | Phase 4: Conflict Resolution  |
| **Create spec** → Generate actionable document         | Phase 6: Spec Generation      |

## Implementation Patterns

### Pattern 1: Initial Orientation (2-3 questions)

```bash
# Check project context first
git log --oneline -10
cat CLAUDE.md 2>/dev/null | head -30
```

```typescript
// First batch of questions (1-3 max)
const initialQuestions = [
  {
    question: "In one sentence, what problem are you trying to solve?",
    options: ["Pain point relief", "New capability", "Performance improvement"],
  },
  {
    question: "Who will use this?",
    options: ["End users", "Developers", "Internal team", "All of the above"],
  },
];

// Project type determination
type ProjectType =
  | "backend-service" // Focus: data, scaling, integrations
  | "frontend-webapp" // Focus: UX, state, responsiveness
  | "cli-tool" // Focus: ergonomics, composability
  | "mobile-app" // Focus: offline, platform, permissions
  | "fullstack-app" // Focus: all of the above
  | "script-automation"; // Focus: triggers, reliability
```

### Pattern 2: Category Deep Dive (2-4 questions per category)

```typescript
// Category A: Problem & Goals
const problemQuestions = [
  "What's the current pain point?",
  // a) Manual process takes too long
  // b) Existing tools don't work well
  // c) No current solution exists
  // d) Research options

  "How will you measure success?",
  // a) Time saved
  // b) User satisfaction
  // c) Revenue impact
  // d) Not sure yet
];
```

### Pattern 3: Research Loop

```typescript
function handleResearchRequest(topic: string) {
  // When user says "research this" or shows uncertainty
  const findings = await WebSearch(`best approaches for ${topic}`);
  return {
    options: [
      {
        name: "WebSockets",
        tradeoffs: "Bidirectional but requires sticky sessions",
      },
      {
        name: "SSE",
        tradeoffs: "Simpler, unidirectional, works with load balancers",
      },
      { name: "Polling", tradeoffs: "Easiest but wasteful" },
    ],
    recommendation: "Given your scale, SSE would likely work well",
  };
}
```

### Pattern 4: Spec Generation Template

```markdown
# [Project Name] Specification

## Executive Summary

[2-3 sentences: what, for whom, why]

## Problem Statement

[The problem this solves, current pain points]

## Success Criteria

[Measurable outcomes that define success]

## Functional Requirements

### Must Have (P0)

- [Requirement with acceptance criteria]

### Should Have (P1)

- [Requirement with acceptance criteria]

## Out of Scope

[Explicitly what we're NOT building]
```

## Troubleshooting

### Issue: Questions Too Vague

| Symptom                  | Solution                     |
| ------------------------ | ---------------------------- |
| "What do you want?"      | Narrow to specific domain    |
| User says "I don't know" | Offer options with tradeoffs |

### Issue: Knowledge Gap Signals

| Symptom                              | Solution                             |
| ------------------------------------ | ------------------------------------ |
| "I think..." or "Maybe..."           | Probe deeper, offer research         |
| "Just simple X"                      | Challenge - define what simple means |
| Technology buzzwords without context | Ask what they think it does          |

### Issue: Premature Solution Description

| Symptom                                  | Solution                                 |
| ---------------------------------------- | ---------------------------------------- |
| "Build a React app" (instead of problem) | "What problem does React solve for you?" |
| "Use a database" (instead of data needs) | "What data do you need to store?"        |

### Issue: Time Pressure

| Symptom                       | Solution                           |
| ----------------------------- | ---------------------------------- |
| "We only have 10 minutes"     | Prioritize: core UX and data model |
| Can't complete full discovery | Note uncovered areas as risks      |

### Issue: User Overwhelm

| Symptom                    | Solution                            |
| -------------------------- | ----------------------------------- |
| Long pauses, short answers | Simplify questions, batch less      |
| "Whatever you think"       | Still probe - don't skip categories |

## workflows

### When Requirements Are Vague

1. **Initial Orientation** → 2-3 questions to understand project type
2. **Category Deep Dive** → 2-4 questions per category (A-H)
3. **Research Loops** → Investigate knowledge gaps
4. **Conflict Resolution** → Surface impossible requirements
5. **Completeness Check** → Verify all areas covered
6. **Spec Generation** → Create actionable document

### Transition to Execution

```bash
# After discovery is complete
git worktree add .worktrees/spec -b feature/spec
```

### Phase 2: Category-by-Category Deep Dive

Work through relevant categories IN ORDER. For each category:

1. Ask 2-4 questions using AskUserQuestion
2. Detect uncertainty - if user seems unsure, offer research
3. Educate when needed - don't let them make uninformed decisions
4. Track decisions - update your internal state

#### Category A: Problem & Goals

Questions to explore:

- What's the current pain point? How do people solve it today?
- What does success look like? How will you measure it?
- Who are the stakeholders beyond end users?
- What happens if this doesn't get built?

**Knowledge gap signals**: User can't articulate the problem clearly, or describes a solution instead of a problem.

#### Category B: User Experience & Journey

Questions to explore:

- Walk me through: a user opens this for the first time. What do they see? What do they do?
- What's the core action? (The one thing users MUST be able to do)
- What errors can happen? What should users see when things go wrong?
- How technical are your users? (Power users vs. novices)

**Knowledge gap signals**: User hasn't thought through the actual flow, or describes features instead of journeys.

#### Category C: Data & State

Questions to explore:

- What information needs to be stored? Temporarily or permanently?
- Where does data come from? Where does it go?
- Who owns the data? Are there privacy/compliance concerns?
- What happens to existing data if requirements change?

**Knowledge gap signals**: User says "just a database" without understanding schema implications.

#### Category D: Technical Landscape

Questions to explore:

- What existing systems does this need to work with?
- Are there technology constraints? (Language, framework, platform)
- What's your deployment environment? (Cloud, on-prem, edge)
- What's the team's technical expertise?

**Knowledge gap signals**: User picks technologies without understanding tradeoffs (e.g., "real-time with REST", "mobile with React").

**Research triggers**:

- "I've heard X is good" → Research X vs alternatives
- "We use Y but I'm not sure if..." → Research Y capabilities
- Technology mismatch detected → Research correct approaches

#### Category E: Scale & Performance

Questions to explore:

- How many users/requests do you expect? (Now vs. future)
- What response times are acceptable?
- What happens during traffic spikes?
- Is this read-heavy, write-heavy, or balanced?

**Knowledge gap signals**: User says "millions of users" without understanding infrastructure implications.

#### Category F: Integrations & Dependencies

Questions to explore:

- What external services does this need to talk to?
- What APIs need to be consumed? Created?
- Are there third-party dependencies? What's the fallback if they fail?
- What authentication/authorization is needed for integrations?

**Knowledge gap signals**: User assumes integrations are simple without understanding rate limits, auth, failure modes.

#### Category G: Security & Access Control

Questions to explore:

- Who should be able to do what?
- What data is sensitive? PII? Financial? Health?
- Are there compliance requirements? (GDPR, HIPAA, SOC2)
- How do users authenticate?

**Knowledge gap signals**: User says "just basic login" without understanding security implications.

#### Category H: Deployment & Operations

Questions to explore:

- How will this be deployed? By whom?
- What monitoring/alerting is needed?
- How do you handle updates? Rollbacks?
- What's your disaster recovery plan?

**Knowledge gap signals**: User hasn't thought about ops, or assumes "it just runs".

### Phase 3: Research Loops

When you detect uncertainty or knowledge gaps:

Ask: "You mentioned wanting real-time updates. There are several approaches with different tradeoffs. Would you like me to research this before we continue?"

Options:

1. **Yes, research it** - I'll investigate options and explain the tradeoffs
2. **No, I know what I want** - Skip research, I'll specify the approach
3. **Tell me briefly** - Give me a quick overview without deep research

**If user wants research:**

1. Use WebSearch/WebFetch to gather relevant information
2. Summarize findings in plain language
3. Return with INFORMED follow-up questions

Example research loop:

```
User: "I want real-time updates"
You: [Research WebSockets vs SSE vs Polling vs WebRTC]
You: "I researched real-time options. Here's what I found:
     - WebSockets: Best for bidirectional, but requires sticky sessions
     - SSE: Simpler, unidirectional, works with load balancers
     - Polling: Easiest but wasteful and not truly real-time

     Given your scale expectations of 10k users, SSE would likely work well.
     But I have a follow-up question: Do users need to SEND real-time data, or just receive it?"
```

### Phase 4: Conflict Resolution

When you discover conflicts or impossible requirements:

Ask: "I noticed a potential conflict: You want [X] but also [Y]. These typically don't work together because [reason]. Which is more important?"

Options:

1. **Prioritize X** - What you lose: [Y capabilities]
2. **Prioritize Y** - What you lose: [X capabilities]
3. **Explore alternatives** - Research ways to get both

Common conflicts to watch for:

- "Simple AND feature-rich"
- "Real-time AND cheap infrastructure"
- "Highly secure AND frictionless UX"
- "Flexible AND performant"
- "Fast to build AND future-proof"

### Phase 5: Completeness Check

Before writing the spec, verify you have answers for:

```
## Completeness Checklist

### Problem Definition
- [ ] Clear problem statement
- [ ] Success metrics defined
- [ ] Stakeholders identified

### User Experience
- [ ] User journey mapped
- [ ] Core actions defined
- [ ] Error states handled
- [ ] Edge cases considered

### Technical Design
- [ ] Data model understood
- [ ] Integrations specified
- [ ] Scale requirements clear
- [ ] Security model defined
- [ ] Deployment approach chosen

### Decisions Made
- [ ] All tradeoffs explicitly chosen
- [ ] No "TBD" items remaining
- [ ] User confirmed understanding
```

If anything is missing, GO BACK and ask more questions.

### Phase 6: Spec Generation

Only after completeness check passes:

1. **Summarize what you learned**:
   "Before I write the spec, let me confirm my understanding:

   You're building [X] for [users] to solve [problem].
   The core experience is [journey].
   Key technical decisions:
   - [Decision 1 with rationale]
   - [Decision 2 with rationale]

   Is this accurate?"

2. **Generate the spec** to a file:

Use the spec template from the skill's resources folder:

3. Customize each section based on discovery findings

### Phase 7: Implementation Handoff

After spec is written, ask about next steps:

```
Spec created. How would you like to proceed?
```

Options:

1. **Start implementation now** - Begin implementing the spec
2. **Review spec first** - Read the spec and come back when ready
3. **Plan implementation** - Create a detailed implementation plan with tasks
4. **Done for now** - Save the spec, implement later

## L'Entonnoir: The Question Funnel

**Apply the funnel pattern throughout discovery:**

```
AskUserQuestion (batch of 2-4 options, recognition-based)
     ↓
User selects from options (no typing)
     ↓
Explore based on selection (continuous investigation)
     ↓
AskUserQuestion (narrower batch)
     ↓
Repeat until ready → Move to next category
```

**Key principles:**

1. **Continuous exploration** — Investigate at ANY time, not just between rounds
2. **Recognition-based options** — User selects from 2-4 options, never types free-form
3. **Progressive narrowing** — Each round reduces uncertainty
4. **Actionable questions** — Options should be concrete with clear tradeoffs

**Bad example:**

```
"What database do you want?" (user must generate answer)
```

**Good example:**

```
"What kind of data will you store?"
Options:
- "Simple key-value pairs" (fast, limited queries)
- "Complex relational data" (ACID, joins, schema)
- "Flexible documents" (JSON, schema-less)
- "Research options" (I'll investigate tradeoffs)
```

## AskUserQuestion Best Practices

### Question Phrasing

- **Bad**: "What database do you want?" (assumes they know databases)
- **Good**: "What kind of data will you store, and how often will it be read vs written?"

### Option Design

Always include options that acknowledge uncertainty:

```
options: [
  {label: "Option A", description: "Clear choice with implications"},
  {label: "Option B", description: "Alternative with different tradeoffs"},
  {label: "I'm not sure", description: "Let's explore this more"},
  {label: "Research this", description: "I'll investigate and come back"}
]
```

## Detecting Knowledge Gaps

Watch for these signals:

| Signal                                  | What to do                            |
| --------------------------------------- | ------------------------------------- |
| "I think..." or "Maybe..."              | Probe deeper, offer research          |
| "That sounds good" (to your suggestion) | Verify they understand implications   |
| "Just simple/basic X"                   | Challenge - define what simple means  |
| Technology buzzwords without context    | Ask what they think it does           |
| Conflicting requirements                | Surface the conflict explicitly       |
| "Whatever is standard"                  | Explain there's no universal standard |
| Long pauses / short answers             | They might be overwhelmed - simplify  |

## Iteration Rules

1. **Never write the spec after just 3-5 questions** - that produces slop
2. **Minimum 10-15 questions** across categories for any real project
3. **At least 2 questions per relevant category**
4. **At least 1 research loop** for any non-trivial project
5. **Always do a completeness check** before writing
6. **Summarize understanding** before finalizing

## Handling Different User Types

### Technical User

- Can skip some education
- Still probe for assumptions ("You mentioned Kubernetes - have you considered the operational complexity?")
- Focus more on tradeoffs than explanations

### Non-Technical User

- More education needed
- Use analogies ("Think of an API like a waiter - it takes your order to the kitchen")
- Offer more research options
- Don't overwhelm with technical options

### User in a Hurry

- Acknowledge time pressure
- Prioritize: "If we only have 10 minutes, let's focus on [core UX and data model]"
- Note what wasn't covered as risks

---

## YAGNI Principle

**YAGNI ruthlessly** - Avoid gold-plating requirements. Only document what's actually needed.

Before finalizing any spec, ask:

- [ ] Is this requirement actually requested?
- [ ] Can we deliver value without this?
- [ ] Is this speculation about future needs?

If you catch yourself thinking "we might need this later", remove it. The discovery phase produces specs, not feature wishlists.

---

## Common Rationalizations

| Excuse                                       | Reality                                                       |
| -------------------------------------------- | ------------------------------------------------------------- |
| "We only have 10 minutes, skip questions"    | Incomplete discovery produces incomplete specs. Note risks.   |
| "I understand the problem, skip research"    | Understanding ≠ having all requirements. Research fills gaps. |
| "The user said 'whatever you think'"         | That's uncertainty, not delegation. Probe deeper.             |
| "This is straightforward, minimum questions" | Minimum is 10-15 questions for real projects.                 |
| "We can clarify later"                       | Later means rework. Clarify now.                              |
| "The spec template has TBD items"            | TBD = technical debt. Resolve before writing.                 |

**If you catch yourself thinking these, STOP. Complete the discovery process.**

---

<guiding_principles>

## The Path to High-Quality Discovery

### 1. Thorough Exploration

Quality specs emerge from minimum 10-15 questions across categories. L'Entonnoir pattern prevents slop and ensures comprehensive understanding.

### 2. Research Discipline

Non-trivial projects require investigation loops. Knowledge gaps fill through research, preventing assumptions.

### 3. Completeness Protocol

Completeness check before spec writing catches missing areas. Surface gaps and offer research to maintain quality.

### 4. Problem-Focused

Solution descriptions indicate unclear understanding. Problem statements reveal true requirements.

### 5. YAGNI Principle

Specs document what was asked, not what might be useful someday. Remove "might need later" items ruthlessly.

</guiding_principles>

## Genetic Code

This component carries essential Seed System principles for context fork isolation:

<critical_constraint>
**System Physics:**

1. Zero external dependencies for portable components
2. Achieve 80-95% autonomy (0-5 AskUserQuestion rounds per session)
3. Description uses What-When-Not-Includes format in third person
4. Progressive disclosure - references/ for detailed content
5. XML for control (mission_control, critical_constraint), Markdown for data
   </critical_constraint>

**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows

**Recognition Questions**:

- "Would Claude know this without being told?" → Delete (zero delta)
- "Can this work standalone?" → Fix if no (non-self-sufficient)
- "Did I read the actual file, or just see it in grep?" → Verify before claiming
