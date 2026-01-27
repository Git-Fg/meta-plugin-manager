---
name: create-plans
description: "Create project plans when planning projects, phases, or tasks for agent execution. Not for enterprise documentation or non-actionable planning."
---

<mission_control>
<objective>Create hierarchical project plans (brief → roadmap → phase → PLAN.md) for solo agentic development</objective>
<success_criteria>Generated PLAN.md is self-contained executable prompt with verification criteria and handoff support</success_criteria>
</mission_control>

<interaction_schema>
explore → infer → ask_one → write_plan → confirm_execution</interaction_schema>

# Create Plans

Create hierarchical project plans optimized for solo agentic development. Produces Claude-executable plans with verification criteria, not enterprise documentation. Handles briefs, roadmaps, phase plans, and context handoffs.

---

## Essential Principles

### Solo Developer Plus Claude

You are planning for ONE person (the user) and ONE implementer (Claude).

- No teams. No stakeholders. No ceremonies. No coordination overhead.
- The user is the visionary/product owner. Claude is the builder.

### Plans Are Prompts

PLAN.md is not a document that gets transformed into a prompt.
**PLAN.md IS the prompt.** It contains:

- Objective (what and why)
- Context (@file references)
- Tasks (type, files, action, verify, done, checkpoints)
- Verification (overall checks)
- Success criteria (measurable)
- Output (SUMMARY.md specification)

**When planning a phase, you are writing the prompt that will execute it.**

### Scope Control

Plans must complete within ~50% of context usage to maintain consistent quality.

**The quality degradation curve:**

- 0-30% context: Peak quality (comprehensive, thorough, no anxiety)
- 30-50% context: Good quality (engaged, manageable pressure)
- 50-70% context: Degrading quality (efficiency mode, compression)
- 70%+ context: Poor quality (self-lobotomization, rushed work)

**Critical insight:** Claude doesn't degrade at 80% - it degrades at ~40-50% when it sees context mounting and enters "completion mode." By 80%, quality has already crashed.

**Solution:** Aggressive atomicity - split phases into many small, focused plans.

Examples:

- `01-01-PLAN.md` - Phase 1, Plan 1 (2-3 tasks: database schema only)
- `01-02-PLAN.md` - Phase 1, Plan 2 (2-3 tasks: database client setup)
- `01-03-PLAN.md` - Phase 1, Plan 3 (2-3 tasks: API routes)
- `01-04-PLAN.md` - Phase 1, Plan 4 (2-3 tasks: UI components)

Each plan is independently executable, verifiable, and scoped to **2-3 tasks maximum**.

**Atomic task principle:** Better to have 10 small, high-quality plans than 3 large, degraded plans. Each commit should be surgical, focused, and maintainable.

**Autonomous execution:** Plans without checkpoints execute via subagent with fresh context - impossible to degrade.

See: `references/scope-estimation.md`

### Human Checkpoints

**Claude automates everything that has a CLI or API.** Checkpoints are for verification and decisions, not manual work.

**Checkpoint types:**

- `checkpoint:human-verify` - Human confirms Claude's automated work (visual checks, UI verification)
- `checkpoint:decision` - Human makes implementation choice (auth provider, architecture)

**Rarely needed:** `checkpoint:human-action` - Only for actions with no CLI/API (email verification links, account approvals requiring web login with 2FA)

**Critical rule:** If Claude CAN do it via CLI/API/tool, Claude MUST do it. Never ask human to:

- Deploy to Vercel/Railway/Fly (use CLI)
- Create Stripe webhooks (use CLI/API)
- Run builds/tests (use Bash)
- Write .env files (use Write tool)
- Create database resources (use provider CLI)

**Protocol:** Claude automates work → reaches checkpoint:human-verify → presents what was done → waits for confirmation → resumes

See: `references/checkpoints.md`, `references/cli-automation.md`

### Deviation Rules

Plans are guides, not straitjackets. Real development always involves discoveries.

**During execution, deviations are handled automatically via 5 embedded rules:**

1. **Auto-fix bugs** - Broken behavior → fix immediately, document in Summary
2. **Auto-add missing critical** - Security/correctness gaps → add immediately, document
3. **Auto-fix blockers** - Can't proceed → fix immediately, document
4. **Ask about architectural** - Major structural changes → stop and ask user
5. **Log enhancements** - Nice-to-haves → auto-log to ISSUES.md, continue

**No user intervention needed for Rules 1-3, 5.** Only Rule 4 (architectural) requires user decision.

**All deviations documented in Summary** with: what was found, what rule applied, what was done, commit hash.

**Result:** Flow never breaks. Bugs get fixed. Scope stays controlled. Complete transparency.

See: `workflows/execute-phase.md` (deviation_rules section)

### Ship Fast Iterate Fast

No enterprise process. No approval gates. No multi-week timelines.
Plan → Execute → Ship → Learn → Repeat.

**Milestone-driven:** Ship v1.0 → mark milestone → plan v1.1 → ship → repeat.
Milestones mark shipped versions and enable continuous iteration.

### Milestone Boundaries

Milestones mark shipped versions (v1.0, v1.1, v2.0).

**Purpose:**

- Historical record in MILESTONES.md (what shipped when)
- Greenfield → Brownfield transition marker
- Git tags for releases
- Clear completion rituals

**Default approach:** Extend existing roadmap with new phases.

- v1.0 ships (phases 1-4) → add phases 5-6 for v1.1
- Continuous phase numbering (01-99)
- Milestone groupings keep roadmap organized

**Archive ONLY for:** Separate codebases or complete rewrites (rare).

See: `references/milestone-management.md`

### Anti Enterprise Patterns

NEVER include in plans:

- Team structures, roles, RACI matrices
- Stakeholder management, alignment meetings
- Sprint ceremonies, standups, retros
- Multi-week estimates, resource allocation
- Change management, governance processes
- Documentation for documentation's sake

**If it sounds like corporate PM theater, delete it.**

### Context Awareness

Monitor token usage via system warnings.

**At 25% remaining:** Mention context getting full
**At 15% remaining:** Pause, offer handoff
**At 10% remaining:** Auto-create handoff, stop

**Never start large operations below 15% without user confirmation.**

### User Gates

**CRITICAL: Questions should funnel to answers, not scatter throughout.**

Ask questions one at a time, interleaved with exploration/tool use, to narrow down context. Once the funnel reaches a decision, stop asking and proceed.

**Question flow:**

1. **EXPLORE first** - Read all files, analyze codebase, check git history
2. **INFER** - Try to infer answers from exploration
3. **If unclear, ASK ONE** - Ask a focused question, use tools to explore response, ask follow-up if needed
4. **Once clear, STOP** - Don't keep asking once context is sufficient
5. **CONFIRM** - Single final question about invoking execution

**Never scatter questions** throughout workflow. Ask once, funnel to answer, proceed.

See: `references/user-gates.md`

### Git Versioning

All planning artifacts are version controlled. Commit outcomes, not process.

- Check for repo on invocation, offer to initialize
- Commit only at: initialization, phase completion, handoff
- Intermediate artifacts (PLAN.md, RESEARCH.md, FINDINGS.md) NOT committed separately
- Git log becomes project history

See: `references/git-integration.md`

---

## EXPLORE Phase

**Before asking ANY question, exhaust all exploration.**

**Rule**: If answer exists in any file or can be reasonably inferred from patterns, DON'T ask.

### Exploration Steps

| Step                      | Action                                                      | Goal                                        |
| ------------------------- | ----------------------------------------------------------- | ------------------------------------------- |
| 1. Read existing context  | Read BRIEF.md, ROADMAP.md, FINDINGS.md, previous SUMMARY.md | Project vision, phase structure, prior work |
| 2. Analyze codebase       | Glob source files, read key files, check package.json       | Current implementation, patterns used       |
| 3. Check git history      | `git log --oneline -5`, `git diff HEAD~1`                   | What was just done, current state           |
| 4. Apply domain expertise | Use loaded expertise patterns                               | Standard approaches for this domain         |
| 5. Analyze user request   | Extract implicit context from original request              | Constraints, priorities, tone               |

### Context Scan (Quick Check)

Run on every invocation to understand current state:

```bash
# Check git status
git rev-parse --git-dir 2>/dev/null || echo "NO_GIT_REPO"

# Check for planning structure
ls -la .claude/workspace/planning/ 2>/dev/null
ls -la .claude/workspace/planning/phases/ 2>/dev/null

# Find any continue-here files
find . -name ".continue-here.md" -type f 2>/dev/null

# Check for existing artifacts
[ -f .claude/workspace/planning/BRIEF.md ] && echo "BRIEF: exists"
[ -f .claude/workspace/planning/ROADMAP.md ] && echo "ROADMAP: exists"
```

**If NO_GIT_REPO detected:** Proceed with exploration first. Only ask about git init AFTER exploration if context is still unclear.

---

## INFER Phase

Try to infer answers from exploration before asking:

| Question              | Can Infer If...                      | Won't Ask If...                  |
| --------------------- | ------------------------------------ | -------------------------------- |
| What are we building? | BRIEF.md clearly describes project   | BRIEF.md exists and is clear     |
| Which phase to plan?  | First incomplete phase in ROADMAP    | ROADMAP.md exists, phase obvious |
| Task breakdown        | Domain expertise + codebase patterns | Standard patterns exist          |
| Approach choices      | Tech stack in BRIEF + codebase       | Convention established           |
| Constraints           | Git history + recent work            | Recently completed similar work  |

**Decision Tree**:

```
All answers inferred? → Proceed to WRITE (0 questions)
Some answers unclear? → ASK ONE focused question (1 AskUserQuestion, then explore response)
```

---

## ASK ONE Phase

Only if context is unclear after EXPLORE + INFER, ask ONE focused question.

**Always provide actionable propositions** - numbered options that let the user recognize and select, not type. Include all context needed so user can validate understanding without additional questions.

**After user responds:** Explore/verify their answer, then proceed without asking more questions.

---

## Intake

Based on EXPLORE + INFER results, present context-aware options with numbered selections:

- **Handoff found**: Offer resume, discard, or different action
- **Planning structure exists**: Offer plan next, execute, handoff, view roadmap, or other
- **No structure**: Offer start new, create roadmap from brief, jump to phase, or guidance

**After routing to workflow, the workflow handles EXPLORE → INFER → ASK ONE → WRITE → CONFIRM.**

---

## Routing

**Domain expertise lives in `~/.claude/skills/expertise/`**

Before creating roadmap or phase plans, determine if domain expertise should be loaded.

### Scan Domains

```bash
ls ~/.claude/skills/expertise/ 2>/dev/null
```

This reveals available domain expertise (e.g., macos-apps, iphone-apps, unity-games, nextjs-ecommerce).

**If no domain skills found:** Proceed without domain expertise (graceful degradation). The skill works fine without domain-specific context.

### Inference Rules

If user's request contains domain keywords, INFER the domain:

| Keywords                                                                                                                                  | Domain Skill                         |
| ----------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| "macOS", "Mac app", "menu bar", "AppKit", "SwiftUI desktop"                                                                               | expertise/macos-apps                 |
| "iPhone", "iOS", "iPad", "mobile app", "SwiftUI mobile"                                                                                   | expertise/iphone-apps                |
| "Unity", "game", "C#", "3D game", "2D game"                                                                                               | expertise/unity-games                |
| "MIDI", "MIDI tool", "sequencer", "MIDI controller", "music app", "MIDI 2.0", "MPE", "SysEx"                                              | expertise/midi                       |
| "Agent SDK", "Claude SDK", "agentic app"                                                                                                  | expertise/with-agent-sdk             |
| "Python automation", "workflow", "API integration", "webhooks", "Celery", "Airflow", "Prefect"                                            | expertise/python-workflow-automation |
| "UI", "design", "frontend", "interface", "responsive", "visual design", "landing page", "website design", "Tailwind", "CSS", "web design" | expertise/ui-design                  |

If domain inferred, ask user to confirm with actionable options.

### No Inference

If no domain obvious from request, present available expertise options for selection.

### Load Domain

When domain selected, use intelligent loading:

**Step 1: Read domain SKILL.md**

```bash
cat ~/.claude/skills/expertise/[domain]/SKILL.md 2>/dev/null
```

This loads core principles and routing guidance (~5k tokens).

**Step 2: Determine what references are needed**

Domain SKILL.md should contain a references index section that maps planning contexts to specific references.

Example:

```markdown
**For database/persistence phases:** references/core-data.md, references/swift-concurrency.md
**For UI/layout phases:** references/swiftui-layout.md, references/appleHIG.md
**For system integration:** references/appkit-integration.md
**Always useful:** references/swift-conventions.md
```

**Step 3: Load only relevant references**

Based on the phase being planned (from ROADMAP), load ONLY the references mentioned for that type of work.

```bash
# Example: Planning a database phase
cat ~/.claude/skills/expertise/macos-apps/references/core-data.md
cat ~/.claude/skills/expertise/macos-apps/references/swift-conventions.md
```

**Context efficiency:**

- SKILL.md only: ~5k tokens
- SKILL.md + selective references: ~8-12k tokens
- All references (old approach): ~20-27k tokens

Announce: "Loaded [domain] expertise ([X] references for [phase-type])."

**If domain skill not found:** Inform user and offer to proceed without domain expertise.

**If SKILL.md doesn't have references_index:** Fall back to loading all references with warning about context usage.

### When to Load

Domain expertise should be loaded BEFORE:

- Creating roadmap (phases should be domain-appropriate)
- Planning phases (tasks must be domain-specific)

Domain expertise is NOT needed for:

- Creating brief (vision is domain-agnostic)
- Resuming from handoff (context already established)
- Transition between phases (just updating status)

---

## Intake

Based on scan results, present context-aware options with numbered selections:

- **Handoff found**: Offer resume, discard, or different action
- **Planning structure exists**: Offer plan next, execute, handoff, view roadmap, or other
- **No structure**: Offer start new, create roadmap from brief, jump to phase, or guidance

---

## Routing

| Response                                                 | Workflow                                              |
| -------------------------------------------------------- | ----------------------------------------------------- |
| "brief", "new project", "start", 1 (no structure)        | `workflows/create-brief.md`                           |
| "roadmap", "phases", 2 (no structure)                    | `workflows/create-roadmap.md`                         |
| "phase", "plan phase", "next phase", 1 (has structure)   | `workflows/plan-phase.md`                             |
| "chunk", "next tasks", "what's next"                     | `workflows/plan-chunk.md`                             |
| "execute", "run", "do it", "build it", 2 (has structure) | **EXIT SKILL** → Use `/run-plan <path>` slash command |
| "research", "investigate", "unknowns"                    | `workflows/research-phase.md`                         |
| "handoff", "pack up", "stopping", 3 (has structure)      | `workflows/handoff.md`                                |
| "resume", "continue", 1 (has handoff)                    | `workflows/resume.md`                                 |
| "transition", "complete", "done", "next"                 | `workflows/transition.md`                             |
| "milestone", "ship", "v1.0", "release"                   | `workflows/complete-milestone.md`                     |
| "guidance", "help", 4                                    | `workflows/get-guidance.md`                           |

**Critical:** Plan execution should NOT invoke this skill. Use `/run-plan` for context efficiency (skill loads ~20k tokens, /run-plan loads ~5-7k).

**After reading the workflow, follow it exactly.**

---

## Command Integration

**Primary command:** `/plan:create`

This skill provides domain logic for planning workflows. Commands handle routing and context inference, then delegate to this skill for execution.

**Available commands:**

| **Command**     | **Purpose**               | **When to Use**                               |
| --------------- | ------------------------- | --------------------------------------------- |
| `/plan:create`  | Create hierarchical plans | Main entry point - context-aware routing      |
| `/plan:brief`   | Create project vision     | Starting new projects or clarifying direction |
| `/plan:roadmap` | Define phase structure    | BRIEF.md exists, phases need definition       |
| `/plan:chunk`   | Plan immediate next tasks | Phase in progress, next steps unclear         |
| `/plan:execute` | Execute PLAN.md files     | Running implementation phases                 |
| `/plan:handoff` | Create context handoff    | Pausing work or switching sessions            |
| `/plan:resume`  | Continue from handoff     | Resuming from previous work                   |

**Command orchestration pattern:**

- Commands provide entry points and context-aware routing
- This skill contains domain logic and detailed workflows
- Commands delegate to workflows in this skill for execution
- Portability invariant: This skill doesn't reference commands

---

## Hierarchy

The planning hierarchy (each level builds on previous):

```
BRIEF.md          → Human vision (you read this)
    ↓
ROADMAP.md        → Phase structure (overview)
    ↓
RESEARCH.md       → Research prompt (optional, for unknowns)
    ↓
FINDINGS.md       → Research output (if research done)
    ↓
PLAN.md           → THE PROMPT (Claude executes this)
    ↓
SUMMARY.md        → Outcome (existence = phase complete)
```

**Rules:**

- Roadmap requires Brief (or prompts to create one)
- Phase plan requires Roadmap (knows phase scope)
- PLAN.md IS the execution prompt
- SUMMARY.md existence marks phase complete
- Each level can look UP for context

---

## Output Structure

All planning artifacts go in `.claude/workspace/planning/`:

```
.claude/workspace/planning/
├── BRIEF.md                    # Human vision
├── ROADMAP.md                  # Phase structure + tracking
├── MILESTONES.md               # Shipped versions
├── ISSUES.md                   # Deferred enhancements
└── phases/
    ├── 01-foundation/
    │   ├── 01-01-PLAN.md       # Plan 1: Database setup
    │   ├── 01-01-SUMMARY.md    # Outcome (exists = done)
    │   ├── 01-02-PLAN.md       # Plan 2: API routes
    │   ├── 01-02-SUMMARY.md
    │   ├── 01-03-PLAN.md       # Plan 3: UI components
    │   └── .continue-here-01-03.md  # Handoff (temporary, if needed)
    └── 02-auth/
        ├── 02-01-RESEARCH.md   # Research prompt (if needed)
        ├── 02-01-FINDINGS.md   # Research output
        ├── 02-02-PLAN.md       # Implementation prompt
        └── 02-02-SUMMARY.md
```

**Naming convention:**

- Plans: `{phase}-{plan}-PLAN.md` (e.g., 01-03-PLAN.md)
- Summaries: `{phase}-{plan}-SUMMARY.md` (e.g., 01-03-SUMMARY.md)
- Phase folders: `{phase}-{name}/` (e.g., 01-foundation/)

Files sort chronologically. Related artifacts (plan + summary) are adjacent.

---

## Reference Index

All in `references/`:

**Structure:** directory-structure.md, hierarchy-rules.md
**Formats:** handoff-format.md, plan-format.md
**Patterns:** context-scanning.md, context-management.md
**Planning:** scope-estimation.md, checkpoints.md, milestone-management.md
**Process:** user-gates.md, git-integration.md, research-pitfalls.md
**Domain:** domain-expertise.md (guide for creating context-efficient domain skills)

---

## Templates Index

All in `templates/`:

| Template           | Purpose                                    |
| ------------------ | ------------------------------------------ |
| brief.md           | Project vision document with current state |
| roadmap.md         | Phase structure with milestone groupings   |
| phase-prompt.md    | Executable phase prompt (PLAN.md)          |
| research-prompt.md | Research prompt (RESEARCH.md)              |
| summary.md         | Phase outcome (SUMMARY.md) with deviations |
| milestone.md       | Milestone entry for MILESTONES.md          |
| issues.md          | Deferred enhancements log (ISSUES.md)      |
| continue-here.md   | Context handoff format                     |

---

## Workflows Index

All in `workflows/`:

| Workflow              | Purpose                                      |
| --------------------- | -------------------------------------------- |
| create-brief.md       | Create project vision document               |
| create-roadmap.md     | Define phases from brief                     |
| plan-phase.md         | Create executable phase prompt               |
| execute-phase.md      | Run phase prompt, create summary             |
| research-phase.md     | Create and run research prompt               |
| plan-chunk.md         | Plan immediate next tasks                    |
| transition.md         | Mark phase complete, advance                 |
| complete-milestone.md | Mark shipped version, create milestone entry |
| handoff.md            | Create context handoff for pausing           |
| resume.md             | Load handoff, restore context                |
| get-guidance.md       | Help decide planning approach                |

---

## Success Criteria

Planning skill succeeds when:

- EXPLORE phase runs (all 5 exploration steps completed)
- INFER phase attempts answers from exploration
- ASK ONE pattern: 1 focused question, interleaved with exploration/tool use, funnel to response, then STOP
- If all answers inferred, 0 questions asked
- PLAN.md IS the executable prompt (not separate)
- Hierarchy is maintained (brief → roadmap → phase)
- Handoffs preserve full context for resumption
- Context limits are respected (auto-handoff at 10%)
- Deviations handled automatically per embedded rules
- All work (planned and discovered) fully documented
- Domain expertise loaded intelligently (SKILL.md + selective references, not all files)
- Plan execution uses /run-plan command (not skill invocation)
- Final question is CONFIRM: "Invoke /run-plan?" (not "What's next?")

---

<critical_constraint>
MANDATORY: PLAN.md IS the executable prompt—not a document to be transformed

MANDATORY: Respect context limits (auto-handoff at 10%)

MANDATORY: Ask ONE focused question, then proceed without additional questions

MANDATORY: All deviations must be documented in SUMMARY.md

MANDATORY: Domain expertise loaded intelligently (SKILL.md + selective references only)

No exceptions. Plans are prompts—they must be self-contained and context-efficient.
</critical_constraint>
