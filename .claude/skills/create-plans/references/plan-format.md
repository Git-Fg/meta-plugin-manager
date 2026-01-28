## Overview

Claude-executable plans have a specific format that enables Claude to implement without interpretation. This reference defines what makes a plan executable vs. vague.

**Key insight:** PLAN.md IS the executable prompt. It contains everything Claude needs to execute the phase, including objective, context references, tasks, verification, success criteria, and output specification.

## Core Principle

A plan is Claude-executable when Claude can read the PLAN.md and immediately start implementing without asking clarifying questions.

If Claude has to guess, interpret, or make assumptions - the task is too vague.

## Prompt Structure

Every PLAN.md follows this XML structure:

```markdown
---
phase: XX-name
type: execute
domain: [optional]
---

## Objective

[What and why]
Purpose: [...]
Output: [...]

## Context

@.claude/workspace/planning/BRIEF.md
@.claude/workspace/planning/ROADMAP.md
@relevant/source/files.ts

## Tasks

### auto

<name>Task N: [Name]
  <files>[paths]
  <action>[what to do, what to avoid and WHY]
  <verify>[command/check]
  <done>[criteria]

### checkpoint:human-verify

<what-built>[what Claude automated]</what-built>
  <how-to-verify>[numbered verification steps]</how-to-verify>
  <resume-signal>[how to continue - "approved" or describe issues]</resume-signal>

### checkpoint:decision

<decision>[what needs deciding]
  
## Context

[why this matters]
  
## Options

##### option-a

<name>[Name]
## Pros

[pros]
## Cons

[cons]
    
##### option-b

<name>[Name]
## Pros

[pros]
## Cons

[cons]
  
  <resume-signal>[how to indicate choice]</resume-signal>

## Verification

[Overall phase checks]

## Success Criteria

[Measurable completion]

## Output

[SUMMARY.md specification]

```

## Task Anatomy

Every task has four required fields:

### files

**What it is**: Exact file paths that will be created or modified.

**Good**: `src/app/api/auth/login/route.ts`, `prisma/schema.prisma`
**Bad**: "the auth files", "relevant components"

Be specific. If you don't know the file path, figure it out first.

### action

**What it is**: Specific implementation instructions, including what to avoid and WHY.

**Good**: "Create POST endpoint that accepts {email, password}, validates using bcrypt against User table, returns JWT in httpOnly cookie with 15-min expiry. Use jose library (not jsonwebtoken - CommonJS issues with Next.js Edge runtime)."

**Bad**: "Add authentication", "Make login work"

Include: technology choices, data structures, behavior details, pitfalls to avoid.

### verify

**What it is**: How to prove the task is complete.

**Good**:

- `npm test` passes
- `curl -X POST /api/auth/login` returns 200 with Set-Cookie header
- Build completes without errors

**Bad**: "It works", "Looks good", "User can log in"

Must be executable - a command, a test, an observable behavior.

### done

**What it is**: Acceptance criteria - the measurable state of completion.

**Good**: "Valid credentials return 200 + JWT cookie, invalid credentials return 401"

**Bad**: "Authentication is complete"

Should be testable without subjective judgment.

## Task Types

Tasks have a `type` attribute that determines how they execute:

### auto

**Default task type** - Claude executes autonomously.

**Structure:**

```xml

### auto

<name>Task 3: Create login endpoint with JWT
  <files>src/app/api/auth/login/route.ts
  <action>POST endpoint accepting {email, password}. Query User by email, compare password with bcrypt. On match, create JWT with jose library, set as httpOnly cookie (15-min expiry). Return 200. On mismatch, return 401.
  <verify>curl -X POST localhost:3000/api/auth/login returns 200 with Set-Cookie header
  <done>Valid credentials → 200 + cookie. Invalid → 401.

```

Use for: Everything Claude can do independently (code, tests, builds, file operations).

### checkpoint:human-action

**RARELY USED** - Only for actions with NO CLI/API. Claude automates everything possible first.

**Structure:**

```xml

### checkpoint:human-action

<action>[Unavoidable manual step - email link, 2FA code]
  <instructions>
    [What Claude already automated]
    [The ONE thing requiring human action]
  
  
## Verification

[What Claude can check afterward]
  <resume-signal>[How to continue]</resume-signal>

```

Use ONLY for: Email verification links, SMS 2FA codes, manual approvals with no API, 3D Secure payment flows.

Do NOT use for: Anything with a CLI (Vercel, Stripe, Upstash, Railway, GitHub), builds, tests, file creation, deployments.

See: references/cli-automation.md for what Claude can automate.

**Execution:** Claude automates everything with CLI/API, stops only for truly unavoidable manual steps.

### checkpoint:human-verify

**Human must verify Claude's work** - Visual checks, UX testing.

**Structure:**

```xml

### checkpoint:human-verify

<what-built>Responsive dashboard layout</what-built>
  <how-to-verify>
    1. Run: npm run dev
    2. Visit: http://localhost:3000/dashboard
    3. Desktop (>1024px): Verify sidebar left, content right
    4. Tablet (768px): Verify sidebar collapses to hamburger
    5. Mobile (375px): Verify single column, bottom nav
    6. Check: No layout shift, no horizontal scroll
  </how-to-verify>
  <resume-signal>Type "approved" or describe issues</resume-signal>

```

Use for: UI/UX verification, visual design checks, animation smoothness, accessibility testing.

**Execution:** Claude builds the feature, stops, provides testing instructions, waits for approval/feedback.

### checkpoint:decision

**Human must make implementation choice** - Direction-setting decisions.

**Structure:**

```xml

### checkpoint:decision

<decision>Select authentication provider
  
## Context

We need user authentication. Three approaches with different tradeoffs:
  
## Options

##### supabase

<name>Supabase Auth
      
## Pros

Built-in with Supabase, generous free tier
      
## Cons

Less customizable UI, tied to ecosystem
    
    
##### clerk

<name>Clerk
      
## Pros

Beautiful pre-built UI, best DX
      
## Cons

Paid after 10k MAU
    
    
##### nextauth

<name>NextAuth.js
      
## Pros

Free, self-hosted, maximum control
      
## Cons

More setup, you manage security
    
  
  <resume-signal>Select: supabase, clerk, or nextauth</resume-signal>

```

Use for: Technology selection, architecture decisions, design choices, feature prioritization.

**Execution:** Claude presents options with balanced pros/cons, waits for decision, proceeds with chosen direction.

**When to use checkpoints:**

- Visual/UX verification (after Claude builds) → `checkpoint:human-verify`
- Implementation direction choice → `checkpoint:decision`
- Truly unavoidable manual actions (email links, 2FA) → `checkpoint:human-action` (rare)

**When NOT to use checkpoints:**

- Anything with CLI/API (Claude automates it) → `type="auto"`
- Deployments (Vercel, Railway, Fly) → `type="auto"` with CLI
- Creating resources (Upstash, Stripe, GitHub) → `type="auto"` with CLI/API
- File operations, tests, builds → `type="auto"`

**Golden rule:** If Claude CAN automate it, Claude MUST automate it. See: references/cli-automation.md

See `references/checkpoints.md` for comprehensive checkpoint guidance.

## Context References

Use @file references to load context for the prompt:

```markdown

## Context

@.claude/workspace/planning/BRIEF.md           # Project vision
@.claude/workspace/planning/ROADMAP.md         # Phase structure
@.claude/workspace/planning/phases/02-auth/FINDINGS.md  # Research results
@src/lib/db.ts                # Existing database setup
@src/types/user.ts            # Existing type definitions

```

Reference files that Claude needs to understand before implementing.

## Verification Section

Overall phase verification (beyond individual task verification):

```markdown

## Verification

Before declaring phase complete:
- [ ] `npm run build` succeeds without errors
- [ ] `npm test` passes all tests
- [ ] No TypeScript errors
- [ ] Feature works end-to-end manually

```

## Success Criteria Section

Measurable criteria for phase completion:

```markdown

## Success Criteria

- All tasks completed
- All verification checks pass
- No errors or warnings introduced
- JWT auth flow works end-to-end
- Protected routes redirect unauthenticated users
  
```

## Output Section

Specify the SUMMARY.md structure:

```markdown

## Output

After completion, create `.claude/workspace/planning/phases/XX-name/SUMMARY.md`:

# Phase X: Name Summary

**[Substantive one-liner]**

## Accomplishments

## Files Created/Modified

## Decisions Made

## Issues Encountered

## Next Phase Readiness

```

## Specificity Levels

### Too Vague

```xml

### auto

<name>Task 1: Add authentication
  <files>???
  <action>Implement auth
  <verify>???
  <done>Users can authenticate

```

Claude: "How? What type? What library? Where?"

### Just Right

```xml

### auto

<name>Task 1: Create login endpoint with JWT
  <files>src/app/api/auth/login/route.ts
  <action>POST endpoint accepting {email, password}. Query User by email, compare password with bcrypt. On match, create JWT with jose library, set as httpOnly cookie (15-min expiry). Return 200. On mismatch, return 401. Use jose instead of jsonwebtoken (CommonJS issues with Edge).
  <verify>curl -X POST localhost:3000/api/auth/login -H "Content-Type: application/json" -d '{"email":"test@test.com","password":"test123"}' returns 200 with Set-Cookie header containing JWT
  <done>Valid credentials → 200 + cookie. Invalid → 401. Missing fields → 400.

```

Claude can implement this immediately.

### Too Detailed

Writing the actual code in the plan. Trust Claude to implement from clear instructions.

## Anti-Patterns

### Vague Actions

- "Set up the infrastructure"
- "Handle edge cases"
- "Make it production-ready"
- "Add proper error handling"

These require Claude to decide WHAT to do. Specify it.

### Unverifiable Completion

- "It works correctly"
- "User experience is good"
- "Code is clean"
- "Tests pass" (which tests? do they exist?)

These require subjective judgment. Make it objective.

### Missing Context

- "Use the standard approach"
- "Follow best practices"
- "Like the other endpoints"

Claude doesn't know your standards. Be explicit.

## Sizing Tasks

Good task size: 15-60 minutes of Claude work.

**Too small**: "Add import statement for bcrypt" (combine with related task)
**Just right**: "Create login endpoint with JWT validation" (focused, specific)
**Too big**: "Implement full authentication system" (split into multiple plans)

If a task takes multiple sessions, break it down.
If a task is trivial, combine with related tasks.

**Note on scope:** If a phase has >7 tasks or spans multiple subsystems, split into multiple plans using the naming convention `{phase}-{plan}-PLAN.md`. See `references/scope-estimation.md` for guidance.