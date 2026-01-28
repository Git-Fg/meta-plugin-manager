# AskUserQuestion Best Practices

**Core Principle: L'Entonnoir (The Funnel) - Iterative Narrowing Through Intelligent Batching**

<mission_control>
<objective>Structure interactions for efficient funneling through multiple AskUserQuestion rounds, each batching 1-4 relevant questions based on current investigation state</objective>
<success_criteria>Multiple rounds with interleaved investigation, each round intelligently batching related questions, narrowing toward execution</success_criteria>
</mission_control>

## L'Entonnoir Pattern

**Core principle**: Use multiple AskUserQuestion rounds to iteratively narrow the problem space. Each round batches 1-4 relevant questions based on current investigation. After each response, investigate further before the next round.

### The Funnel Flow

```
┌─────────────────────────────────────────────────────┐
│              ITERATIVE FUNNELING PATTERN            │
│                                                     │
│  Investigate → AskUserQuestion (batch Q1-Q3)        │
│       ↓                                            │
│  Analyze response → Narrow investigation            │
│       ↓                                            │
│  AskUserQuestion (batch Q4-Q5 based on previous)    │
│       ↓                                            │
│  Analyze response → Final investigation             │
│       ↓                                            │
│  AskUserQuestion (final confirmation Q6)            │
│       ↓                                            │
│  Execute                                            │
└─────────────────────────────────────────────────────┘
```

### Full Example: Debugging Build Failure

**Round 1 - Broad Investigation**

User: "Build is failing, help me debug"

Agent: [Silent investigation - 20 tool calls]

- Reads build logs
- Identifies it's a Node.js project
- Sees dependency-related error
- Cannot determine specific issue yet

Agent: AskUserQuestion [First round - 2 questions]
"Q1: Which language is this project using?

1. TypeScript
2. JavaScript
3. Python
4. Go

Q2: What type of error are you seeing?

1. Dependency/version mismatch
2. Syntax error
3. Runtime error
4. Test failure"

User: [Answers both]
A1: "1"
A2: "1"

**Round 2 - Narrowed Investigation**

Agent: [Silent investigation - 15 tool calls based on answers]

- Reads package.json
- Checks TypeScript version
- Examines node_modules
- Scans lockfile for conflicts
- Identifies lodash version conflict

Agent: AskUserQuestion [Second round - 2 questions based on findings]
"Analysis shows a dependency conflict. Q3: Which dependency is causing issues?

1. react
2. lodash
3. axios
4. @types/node

Q4: What action would you prefer?

1. Upgrade to compatible version
2. Downgrade to match peer requirements
3. Remove the dependency
4. Something else"

User: [Answers both]
A3: "2"
A4: "2"

**Round 3 - Targeted Investigation**

Agent: [Silent investigation - 10 tool calls]

- Checks lodash versions in package.json
- Examines peer dependency requirements
- Identifies compatible version range
- Verifies no breaking changes

Agent: AskUserQuestion [Third round - 1 confirmation question]
"Q5: Should I downgrade lodash to version 4.17.21 (compatible with all peer deps)?"

User: A5: "Yes"

**Execute**

Agent: [Updates package.json and runs npm install]
"Downgraded lodash to 4.17.21. Running build...
Build successful! ✓"

---

## Recognition Over Generation

Users recognize faster than they generate. Structure questions in each round for recognition.

**Recognition Question**: "Would the user need to think to answer this, or can they just recognize/validate?"

**Batching Principle**: Each AskUserQuestion call should batch 1-4 questions that:

- Share the same investigation context
- Are related to each other
- Can be answered together without additional context

---

## Intelligent Batching Per Round

### Good Batching

Questions that share context and dependencies:

```
Q1: Database type? 1) PostgreSQL 2) MongoDB 3) SQLite
Q2: Which ORM for [database from Q1]? 1) Prisma 2) TypeORM 3) None
Q3: Environment for deployment? 1) Dev 2) Staging 3) Production
```

**Why good**: Q2 depends on Q1 answer, Q3 is related context. All gathered in one round-trip.

### Poor Batching

Unrelated or out-of-order questions:

```
Q1: Favorite color? (unrelated to task)
Q2: Database type?
Q3: Pizza topping? (unrelated)
Q4: ORM for database? (should be with Q2)
```

**Why bad**: Wastes user's cognitive load. Should batch related questions, defer unrelated.

### Batching Guidelines

**DO batch together:**

- Questions that share the same context/investigation phase
- Questions where earlier answers inform later options
- Questions about the same topic/decision area
- 2-4 questions max per AskUserQuestion call

**DON'T batch together:**

- Unrelated topics (database vs UI vs deployment)
- Questions that require separate investigation phases
- More than 4 questions in one call (overwhelming)

---

## Interleaving Investigation and Questions

### The Pattern

After each AskUserQuestion response:

1. **Analyze answers** - What did the user tell us?
2. **Narrow investigation** - Use answers to focus next investigation
3. **Run targeted diagnostics** - Check specific things based on answers
4. **Determine next questions** - What else do we need to know?
5. **Ask again** - Batch next set of questions (1-4)
6. **Repeat** - Until ready to execute

### Example: Multi-Round Funneling

**Round 1 - Categorization**

Agent: [Investigates broadly]
"Q1: What type of task? 1) Bug fix 2) Feature 3) Refactor
Q2: Priority? 1) Critical 2) High 3) Normal"

User: A1: "1", A2: "1"

**Round 2 - Specific Identification** (after Round 1 answers)

Agent: [Investigates bug-related areas based on critical priority]
"Q3: Which component is affected? 1) Auth 2) API 3) Database
Q4: When did it start? 1) Today 2) This week 3) Unknown"

User: A3: "1", A4: "1"

**Round 3 - Action Planning** (after Round 2 answers)

Agent: [Investigates auth component, recent changes]
"Q5: Should I revert today's auth commit or patch the issue?"

User: A5: "Patch"

**Execute**

Agent: [Implements patch]

---

## Question Structure Patterns

### Pattern 1: Broad → Specific → Action

Round 1: Broad categorization
Round 2: Specific identification
Round 3: Action confirmation
Execute

### Pattern 2: Dependency Chain

Round 1: "Q1: Language? Q2: Framework?"
Round 2: [Investigate based on language/framework] "Q3: Which [framework] library?"
Round 3: [Investigate library options] "Q4: Which version?"
Execute

### Pattern 3: Elimination

Round 1: "Q1: Is it X, Y, or Z?"
Round 2: [Eliminate X based on investigation] "Q2: Is it Y or Z?"
Round 3: [Eliminate Y] "Q3: Confirm Z?"
Execute

---

## Anti-Patterns

### Anti-Pattern 1: Single-Question obsession

**Wrong**: Asking one question per round-trip when 2-4 related questions exist

```
Round 1: "Q1: Language?" → User: "TypeScript"
Round 2: "Q2: Framework?" → User: "React"
Round 3: "Q3: Build tool?" → User: "Vite"
Round 4: "Q4: Deployment?" → User: "Vercel"
```

**Right**: Batch related questions

```
Round 1: "Q1: Language? Q2: Framework? Q3: Build tool? Q4: Deployment?"
User: [Answers all 4]
Round 2: [Investigate based on answers]
Round 3: "Q5: Confirm setup?"
Execute
```

### Anti-Pattern 2: Over-batching

**Wrong**: 5+ questions or unrelated topics

```
Round 1: "Q1-Q10 (10 questions!)"
```

**Right**: 2-4 related questions per round

```
Round 1: "Q1-Q3 (related tech stack questions)"
Round 2: [Investigate] "Q4-Q6 (related deployment questions)"
```

### Anti-Pattern 3: No Investigation Between Rounds

**Wrong**: Ask → Ask → Ask without investigating

```
Round 1: "Q1: What's wrong?"
Round 2: "Q2: More details?"
Round 3: "Q3: Even more details?"
```

**Right**: Investigate → Ask → Investigate → Ask

```
Round 1: [Investigate] "Q1: Category? Q2: Severity?"
Round 2: [Investigate based on Q1-Q2] "Q3: Specific component? Q4: Action?"
Round 3: [Investigate] "Q5: Confirm?"
Execute
```

---

## Context-Specific Patterns

### Debugging: Funneling to Root Cause

Round 1: Symptom categorization
Round 2: Component identification
Round 3: Root cause confirmation
Round 4: Fix approach selection
Execute

### Feature Implementation: Requirements Gathering

Round 1: Feature scope and priority
Round 2: Technical decisions (batch related)
Round 3: Edge cases and constraints
Round 4: Implementation approach
Execute

### Setup/Configuration: Layered Decisions

Round 1: High-level architecture
Round 2: Specific technologies (batch by layer)
Round 3: Configuration values
Round 4: Confirmation
Execute

---

## Quality Checklist

Before each AskUserQuestion call, verify:

- [ ] Did I investigate since the last round?
- [ ] Do these questions share the same context?
- [ ] Are earlier answers used to inform later questions/options?
- [ ] Is this 2-4 questions max?
- [ ] Will answers narrow the problem space?
- [ ] Can the user recognize answers without generating?

---

## Summary

**The L'Entonnoir Protocol:**

1. **Investigate** - Gather information
2. **Ask** - Batch 1-4 relevant questions based on investigation
3. **Analyze** - Use answers to narrow investigation scope
4. **Repeat** - Investigate → Ask until ready to execute
5. **Execute** - Complete the task

**Key distinctions:**

- **Multiple rounds encouraged** - Funnel toward execution efficiently
- **Batch intelligently per round** - Group related questions (1-4 max)
- **Interleave investigation** - Investigate between rounds, not just before first round
- **Recognition over generation** - Users select from options, don't generate from scratch

**Remember**: L'entonnoir (the funnel) - each round narrows the problem space through intelligent questioning and investigation.

---

<critical_constraint>
MANDATORY: Batch 1-4 related questions per AskUserQuestion call
MANDATORY: Investigate between rounds to narrow scope
MANDATORY: Use answers from previous rounds to inform next investigation
MANDATORY: Each round should funnel toward execution
No exceptions. Efficient funneling through iterative narrowing.
</critical_constraint>
