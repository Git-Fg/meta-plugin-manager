# Workflow: Plan Phase

## Required Reading

**Read these files NOW:**

1. templates/phase-prompt.md
2. references/plan-format.md
3. references/scope-estimation.md
4. references/checkpoints.md

## Purpose

Create an executable phase prompt (PLAN.md). This is where we get specific:
objective, context, tasks, verification, success criteria, and output specification.

**Key insight:** PLAN.md IS the prompt that Claude executes. Not a document that
gets transformed into a prompt.

## Process

#### identify_phase

Check roadmap for phases:

```bash
cat .claude/workspace/planning/ROADMAP.md
ls .claude/workspace/planning/phases/
```

**Infer** phase from ROADMAP - first incomplete phase is usually obvious.
Only ask if multiple incomplete phases exist.

Read any existing PLAN.md or FINDINGS.md in the phase directory.

#### check_research_needed

For this phase, assess:

- Are there technology choices to make?
- Are there unknowns about the approach?
- Do we need to investigate APIs or libraries?

If yes: Route to workflows/research-phase.md first.
Research produces FINDINGS.md, then return here.

If no: Proceed with EXPLORE.

#### EXPLORE

Perform maximum exploration BEFORE asking questions:

| What to Explore    | How                                                     | Goal                                              |
| ------------------ | ------------------------------------------------------- | ------------------------------------------------- |
| Planning artifacts | Read BRIEF.md, ROADMAP.md, FINDINGS.md                  | Understand project vision, phases, any research   |
| Existing code      | Glob src/, read key files, check package.json           | Identify tech stack, patterns, what's implemented |
| Git history        | `git log --online -5`, `git diff HEAD~1`                | What was just done, current state                 |
| Domain patterns    | Use loaded expertise (macos-apps, with-agent-sdk, etc.) | Standard approaches, conventions                  |
| User request       | Analyze original request for implicit context           | Constraints, priorities, implicit requirements    |

**Rule**: If answer exists in any file or can be reasonably inferred from patterns, DON'T ask.

#### INFER

Try to infer from exploration:

| Question     | Can Infer If...                      | Won't Ask If...             |
| ------------ | ------------------------------------ | --------------------------- |
| Phase goal   | ROADMAP.md clearly describes         | ROADMAP exists and is clear |
| What exists  | Codebase scan shows files            | Files are present and match |
| Dependencies | Previous SUMMARY.md files            | Previous plans complete     |
| Approach     | Domain expertise + codebase patterns | Convention established      |

#### ASK ONE

Only if context is unclear after EXPLORE + INFER, ask ONE focused question with numbered options the user can select.

**Provide actionable propositions** - present the inferred context and let user confirm/adjust by selection, not typing. Include all context so user can validate understanding.

**If all inferred**: Skip ASK ONE, proceed to WRITE.

#### break_into_tasks

Decompose the phase into tasks.

Each task must have:

- **Type**: auto, checkpoint:human-verify, checkpoint:decision (human-action rarely needed)
- **Task name**: Clear, action-oriented
- **Files**: Which files created/modified (for auto tasks)
- **Action**: Specific implementation (including what to avoid and WHY)
- **Verify**: How to prove it worked
- **Done**: Acceptance criteria

**Identify checkpoints:**

- Claude automated work needing visual/functional verification? → checkpoint:human-verify
- Implementation choices to make? → checkpoint:decision
- Truly unavoidable manual action (email link, 2FA)? → checkpoint:human-action (rare)

**Critical:** If external resource has CLI/API (Vercel, Stripe, Upstash, GitHub, etc.), use type="auto" to automate it. Only checkpoint for verification AFTER automation.

See references/checkpoints.md and references/cli-automation.md for checkpoint structure and automation guidance.

#### estimate_scope

After breaking into tasks, assess scope against the **quality degradation curve**.

**ALWAYS split if:**

- > 3 tasks total
- Multiple subsystems (DB + API + UI = separate plans)
- > 5 files modified in any single task
- Complex domains (auth, payments, data modeling)

**Aggressive atomicity principle:** Better to have 10 small, high-quality plans than 3 large, degraded plans.

**If scope is appropriate (2-3 tasks, single subsystem, <5 files per task):**
Proceed to WRITE.

**If scope is large (>3 tasks):**
Split into multiple plans by:

- Subsystem (01-01: Database, 01-02: API, 01-03: UI, 01-04: Frontend)
- Dependency (01-01: Setup, 01-02: Core, 01-03: Features, 01-04: Testing)
- Complexity (01-01: Layout, 01-02: Data fetch, 01-03: Visualization)
- Autonomous vs Interactive (group auto tasks for subagent execution)

**Each plan must be:**

- 2-3 tasks maximum
- ~50% context target (not 80%)
- Independently committable

**Autonomous plan optimization:**

- Plans with NO checkpoints → will execute via subagent (fresh context)
- Plans with checkpoints → execute in main context (user interaction required)
- Try to group autonomous work together for maximum fresh contexts

See references/scope-estimation.md for complete splitting guidance and quality degradation analysis.

#### write_phase_prompt

Use template from `templates/phase-prompt.md`.

**If single plan:**
Write to `.claude/workspace/planning/phases/XX-name/{phase}-01-PLAN.md`

**If multiple plans:**
Write multiple files:

- `.claude/workspace/planning/phases/XX-name/{phase}-01-PLAN.md`
- `.claude/workspace/planning/phases/XX-name/{phase}-02-PLAN.md`
- `.claude/workspace/planning/phases/XX-name/{phase}-03-PLAN.md`

Each file follows the template structure:

```markdown
---
phase: XX-name
plan: { plan-number }
type: execute
domain: [if domain expertise loaded]
---

## Objective

[Plan-specific goal - what this plan accomplishes]

Purpose: [Why this plan matters for the phase]
Output: [What artifacts will be created by this plan]

## Execution Context

@~/.claude/skills/create-plans/workflows/execute-phase.md
@~/.claude/skills/create-plans/templates/summary.md
[If plan has ANY checkpoint tasks (type="checkpoint:*"), add:]
@~/.claude/skills/create-plans/references/checkpoints.md

## Context

@.claude/workspace/planning/BRIEF.md
@.claude/workspace/planning/ROADMAP.md
[If research done:]
@.claude/workspace/planning/phases/XX-name/FINDINGS.md
[If continuing from previous plan:]
@.claude/workspace/planning/phases/XX-name/{phase}-{prev}-SUMMARY.md
[Relevant source files:]
@src/path/to/relevant.ts

## Tasks

[Tasks in XML format with type attribute]
[Mix of type="auto" and type="checkpoint:*" as needed]

## Verification

[Overall plan verification checks]

## Success Criteria

[Measurable completion criteria for this plan]

## Output

After completion, create `.claude/workspace/planning/phases/XX-name/{phase}-{plan}-SUMMARY.md`
[Include summary structure from template]
```

**For multi-plan phases:**

- Each plan has focused scope (3-6 tasks)
- Plans reference previous plan summaries in context
- Last plan's success criteria includes "Phase X complete"

#### CONFIRM

Single final question about invoking execution:

**If single plan:**

```
Plan created: .claude/workspace/planning/phases/XX-name/{phase}-01-PLAN.md

- [x] 2 tasks (autonomous - no checkpoints)
- [x] Scope: [scope summary]
- [x] Verification: [verification summary]

Invoke /run-plan to execute? (yes / review / later)
```

**If multiple plans:**

```
Plans created:
- {phase}-01-PLAN.md ([X] tasks) - [Subsystem name]
- {phase}-02-PLAN.md ([X] tasks) - [Subsystem name]
- {phase}-03-PLAN.md ([X] tasks) - [Subsystem name]

Total: [X] tasks across [Y] focused plans.
[X] autonomous (no checkpoints), [Y] interactive (checkpoints)

Invoke /run-plan for first plan? (yes / review / later)
```

## Task Quality

Good tasks:

- "Add User model to Prisma schema with email, passwordHash, createdAt"
- "Create POST /api/auth/login endpoint with bcrypt validation"
- "Add protected route middleware checking JWT in cookies"

Bad tasks:

- "Set up authentication" (too vague)
- "Make it secure" (not actionable)
- "Handle edge cases" (which ones?)

If you can't specify Files + Action + Verify + Done, the task is too vague.

## Anti-Patterns

- Don't add story points
- Don't estimate hours
- Don't assign to team members
- Don't add acceptance criteria committees
- Don't create sub-sub-sub tasks
- Don't scatter questions throughout (always ASK ONE at beginning, then proceed)

Tasks are instructions for Claude, not Jira tickets.

## Success Criteria

Phase planning is complete when:

- [ ] EXPLORE phase completed (all 5 exploration steps)
- [ ] INFER attempted (0 questions if all inferred)
- [ ] One or more PLAN files exist with XML structure ({phase}-{plan}-PLAN.md)
- [ ] Each plan has: Objective, context, tasks, verification, success criteria, output
- [ ] @context references included
- [ ] Each plan has 3-6 tasks (scoped to ~50% context)
- [ ] Each task has: Type, Files (if auto), Action, Verify, Done
- [ ] Checkpoints identified and properly structured
- [ ] Tasks are specific enough for Claude to execute
- [ ] If multiple plans: logical split by subsystem/dependency/complexity
- [ ] CONFIRM asked: "Invoke /run-plan?"
