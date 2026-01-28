# Interactive Command Patterns

Guide to creating commands that use AskUserQuestion for iterative decision-making through the l'entonnoir (funnel) pattern.

## Overview

Some commands need user input beyond simple arguments. Use AskUserQuestion for:

- Multiple choice decisions with trade-offs
- Selecting multiple items from a list
- Decisions requiring investigation between rounds
- Configuration that needs progressive narrowing

**Key pattern**: L'entonnoir (the funnel) - multiple AskUserQuestion rounds, each batching 1-4 related questions based on investigation.

## When to Use AskUserQuestion

### Use AskUserQuestion When:

- Multiple valid approaches with trade-offs
- Complex options requiring context to choose
- Multi-select scenarios (choosing multiple items)
- User intent must be clarified after investigation
- Interactive workflows that adapt based on answers

### Use Command Arguments When:

- Simple values (file paths, numbers, names)
- Known inputs user already has
- Scriptable workflows that should be automatable
- Fast invocations where prompting would slow down

## L'Entonnoir Pattern in Commands

Commands should use multiple AskUserQuestion rounds to funnel toward execution:

```
Round 1: Broad categorization (batch 2-4 questions)
  ↓ [Investigate based on answers]
Round 2: Focused decisions (batch 1-3 questions)
  ↓ [Investigate based on answers]
Round 3: Targeted confirmation (1 question)
  ↓ [Execute]
```

### Full Command Example: Plugin Setup

**User invokes**: `/setup-plugin`

**Round 1 - Broad configuration**

Agent: [Investigates project structure - 15 tool calls]

- Checks existing files
- Analyzes dependencies
- Identifies deployment context

Agent: AskUserQuestion [Round 1 - 3 questions]
"Q1: Which deployment platform will you use?

1. AWS (Amazon Web Services with ECS/EKS)
2. GCP (Google Cloud with GKE)
3. Azure (Microsoft Azure with AKS)
4. Local (Docker on local machine)

Q2: How many environments do you need?

1. Single (Production only)
2. Standard (Dev + Production)
3. Complete (Dev + Staging + Production)

Q3: Which features do you need? (Select all that apply)

1. Auto-scaling
2. Monitoring (metrics, dashboards)
3. CI/CD pipeline
4. Automated backups"

User: [Answers all 3]
A1: "1"
A2: "2"
A3: ["1", "2", "4"]

**Round 2 - Focused based on answers**

Agent: [Investigates AWS options - 20 tool calls based on answers]

- Researches AWS ECS configuration
- Checks monitoring tools compatible with AWS
- Reviews backup strategies for Dev+Production

Agent: AskUserQuestion [Round 2 - 2 questions based on findings]
"Q4: For AWS ECS, which launch type fits your needs?

1. Fargate (serverless, no EC2 management)
2. EC2 (more control, manage instances)
3. Lambda (event-driven, microservices)

Q5: For Dev+Production with backups, should I use:

1. Separate databases for each environment
2. Shared database with environment-specific schemas
3. Single database with data segmentation"

User: [Answers both]
A4: "1"
A5: "1"

**Round 3 - Targeted**

Agent: [Investigates Fargate setup - 15 tool calls]

- Checks ECS task definition patterns
- Reviews separate database options
- Validates backup strategy

Agent: AskUserQuestion [Round 3 - 1 confirmation question]
"Q6: Should I proceed with AWS Fargate + separate databases (PostgreSQL) + CloudWatch monitoring + automated backups?"

User: A6: "Yes"

**Execute**

Agent: [Generates configuration files]
"Created:

- ecs-task-definition.json
- docker-compose.yml
- cloudwatch-dashboard.json
- backup-schedule.json
- .env.development and .env.production"

## Command Patterns for User Interaction

### Pattern 1: Multi-Round Configuration Setup

**Round 1**: High-level architecture (language, framework, deployment)
**Investigate**: Based on answers
**Round 2**: Specific technologies (database, cache, queue)
**Investigate**: Based on answers
**Round 3**: Configuration values (sizing, regions, versions)
**Execute**

### Pattern 2: Diagnostic Funneling

**Round 1**: Symptom category (error type, component, severity)
**Investigate**: Based on answers
**Round 2**: Specific identification (which file, which line, what changed)
**Investigate**: Based on answers
**Round 3**: Fix approach (revert, patch, rewrite)
**Execute**

### Pattern 3: Feature Selection

**Round 1**: Scope and priority (what to build, when)
**Investigate**: Based on answers
**Round 2**: Technical decisions (how to implement)
**Investigate**: Based on answers
**Round 3**: Edge cases and constraints
**Execute**

## Batching Guidelines

### DO Batch Together

- Questions sharing the same investigation context
- Questions where earlier answers inform later options
- Questions about the same decision area
- 2-4 questions max per AskUserQuestion call

### DON'T Batch Together

- Unrelated topics (database vs UI vs deployment)
- Questions requiring separate investigation phases
- More than 4 questions (split into multiple rounds)

### Example Batching

**Good - Round 1 (Architecture):**

Q1: Frontend framework? (React/Vue/Svelte)
Q2: State management? (Redux/Zustand/Context)
Q3: Build tool? (Vite/Webpack/Next.js)
Q4: Styling? (CSS Modules/Tailwind/Styled Components)

**Good - Round 2 (Backend - separate round after investigation):**

Q5: Backend framework? (Express/Fastify/NestJS)
Q6: Database? (PostgreSQL/MongoDB/SQLite)

**Bad - All in one round:**

Q1-Q10 mixed topics, overwhelming

## Question Design Best Practices

### Clear Questions

**Good**: "Which database should we use for user data?

1. PostgreSQL (Relational, ACID compliant)
2. MongoDB (Document store, flexible schema)
3. SQLite (Embedded, simple setup)"

**Poor**: "Database?"

### Helpful Descriptions

Each option should explain:

- What it is
- When to use it
- Key trade-offs

**Example**:

"Which deployment target?

1. Vercel (Zero-config, optimized for Next.js, free tier available)
2. Netlify (Fast deploys, form handling, generous free tier)
3. AWS (Full control, more complex, pay-as-you-go)
4. DigitalOcean (Simple, predictable pricing, good for APIs)"

### Multi-Select Guidelines

**When to use multiSelect:**

- User might want any combination
- Features list (enable multiple)
- Stack choices (can use multiple tools)
- Integration targets (connect to multiple services)

**Example:**

"Which features should I enable? (multiSelect)

1. Authentication
2. Authorization (permissions)
3. Rate limiting
4. Caching
5. Logging
6. Metrics"

User might select: [1, 2, 4, 6]

**When NOT to use multiSelect:**

- Mutually exclusive choices
- Only one option makes sense
- Selecting one determines behavior

## Implementation Examples

### Example 1: Component Generator

```markdown
---
description: Interactive component generator
allowed-tools: AskUserQuestion, Write, Read
---

# Component Generator

## Round 1 - Component Type

Agent: [Investigates project structure]

- Reads existing components
- Analyzes patterns used
- Checks UI library

Agent: AskUserQuestion
"Q1: What type of component?

1. Presentational (UI only, no logic)
2. Container (manages state, passes to children)
3. Custom hook (reusable logic)
4. Page component (route, data fetching)

Q2: Which UI library are you using?

1. Material-UI
2. Chakra UI
3. Tailwind (headless UI)
4. None (plain CSS)"

User: A1: "2", A2: "3"

## Round 2 - Specific Features

Agent: [Investigates Chakra + Tailwind patterns]

- Reads component examples
- Checks TypeScript types
- Reviews styling patterns

Agent: AskUserQuestion
"Q3: What should this component display?

1. Form (input fields, validation, submit)
2. Data table (sorting, filtering, pagination)
3. Card (content container, image, actions)
4. Modal (dialog, overlay, focus trap)

Q4: Which features? (multiSelect)

1. TypeScript types
2. Accessibility attributes
3. Loading states
4. Error handling"

User: A3: "1", A4: ["1", "2", "3", "4"]

## Round 3 - Confirmation

Agent: [Investigates form patterns]

- Reads existing form components
- Checks validation library
- Reviews submission patterns

Agent: AskUserQuestion
"Q5: Should I create a Chakra UI form component with TypeScript, full accessibility, loading states, and error handling?"

User: A5: "Yes"

## Execute

Agent: [Generates component]
"Created:

- components/FormComponent.tsx
- components/FormComponent.test.tsx
- stories/FormComponent.stories.tsx
  "
```

### Example 2: Debug Assistant

```markdown
---
description: Interactive debugging assistant
allowed-tools: AskUserQuestion, Bash, Read, Grep
---

# Debug Assistant

## Round 1 - Categorization

Agent: [Investigates error]

- Reads error logs
- Checks git status
- Analyzes stack traces

Agent: AskUserQuestion
"Q1: What type of issue?

1. Build failure
2. Runtime error
3. Test failure
4. Performance issue

Q2: When did this start?

1. Just now (after recent change)
2. Today (unclear cause)
3. This week (intermittent)
4. Unknown"

User: A1: "1", A2: "1"

## Round 2 - Identification

Agent: [Investigates recent changes]

- Checks git diff
- Reads build output
- Analyzes error messages

Agent: AskUserQuestion
"Q3: The build error is in payment-service.ts. Which line?

1. Line 42 (import statement)
2. Line 87 (type error)
3. Line 156 (missing dependency)

Q4: Analysis shows a type mismatch. Should I:

1. Fix the type annotation
2. Update the imported library
3. Refactor the function signature"

User: A3: "2", A4: "1"

## Round 3 - Execution Plan

Agent: [Investigates fix options]

- Checks library versions
- Reads changelog
- Verifies compatibility

Agent: AskUserQuestion
"Q5: Should I upgrade @types/node to version 20 to fix the type mismatch?"

User: A5: "Yes"

## Execute

Agent: [Runs npm install and tests]
"Upgraded @types/node to v20. Running build...
Build successful! ✓"
```

## Quality Checklist

Before using AskUserQuestion in a command:

- [ ] Did I investigate since the last round?
- [ ] Do these questions share context?
- [ ] Are earlier answers used to inform later options?
- [ ] Is this 2-4 questions max?
- [ ] Will answers narrow the next step?
- [ ] Can the user recognize answers without generating?

## Summary

**L'Entonnoir for Interactive Commands:**

1. **Round 1**: Broad questions (categorization)
2. **Investigate**: Based on answers, narrow scope
3. **Round 2**: Focused questions (identification)
4. **Investigate**: Based on answers, target specifics
5. **Round 3**: Targeted questions (confirmation)
6. **Execute**: Complete the task

**Key principles:**

- Multiple rounds with funneling
- 1-4 related questions per round
- Investigation between rounds based on answers
- Recognition over generation (user selects, doesn't type)
