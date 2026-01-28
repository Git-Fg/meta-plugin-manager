---
description: "Create project plans with intelligent auto-inference. Single command for brief/roadmap/phases/chunks - detects context and acts autonomously."
argument-hint: [project description or "auto" for context detection]
---

# Plan Creation

<mission_control>
<objective>Fully autonomous planning - detects state, creates brief/roadmap/phases/chunks as needed with minimal user input</objective>
<success_criteria>Appropriate planning action taken with 0 AskUserQuestion rounds (context clear) or 1 round (ambiguous)</success_criteria>
</mission_control>

## Purpose

Single fully autonomous command for all planning operations. Auto-detects and executes:

- **No structure** → Create brief + roadmap
- **Brief only** → Create roadmap
- **Roadmap only** → Create first phase plan
- **Incomplete phase** → Identify next 1-3 tasks (chunk)
- **Handoff exists** → Resume from where you left off

## Context Scan

```bash
# Full planning state detection
STATE=""

# Check for planning directory
[ -d .claude/workspace/planning ] && STATE+="planning_exists "

# Check for artifacts
[ -f .claude/workspace/planning/BRIEF.md ] && STATE+="brief "
[ -f .claude/workspace/planning/ROADMAP.md ] && STATE+="roadmap "

# Check for phase plans and completion
PLAN_COUNT=$(find .claude/workspace/planning/phases -name "*-PLAN.md" 2>/dev/null | wc -l)
SUMMARY_COUNT=$(find .claude/workspace/planning/phases -name "*-SUMMARY.md" 2>/dev/null | wc -l)
[ "$PLAN_COUNT" -gt 0 ] && STATE+="plans:${PLAN_COUNT} "
[ "$SUMMARY_COUNT" -gt 0 ] && STATE+="summaries:${SUMMARY_COUNT} "

# Check for handoffs
HANDOFF=$(find .claude/workspace/planning/phases -name ".continue-here.md" 2>/dev/null)
[ -n "$HANDOFF" ] && STATE+="handoff "

echo "Detected: $STATE"
```

## Fully Autonomous Logic

### State 1: No Planning Structure

**Detected**: `planning_exists` missing

**Action**: Create brief + roadmap autonomously

**EXPLORE** (silent, no questions):

- Analyze user's $ARGUMENTS for project name, description, constraints
- Check git history for similar projects
- Identify tech stack from request

**INFER** from context:
| What to Infer | Sources |
|--------------|---------|
| Project name | $ARGUMENTS, git history, folder name |
| Description | $ARGUMENTS functionality description |
| Problem | $ARGUMENTS pain points or context |
| Constraints | $ARGUMENTS tech stack mentions |

**AUTONOMOUS CREATE**:

```bash
# Create structure
mkdir -p .claude/workspace/planning/phases

# Create brief (inferred from $ARGUMENTS)
cat > .claude/workspace/planning/BRIEF.md <<BRIEF_EOF
# Project: [INFERRED_NAME]

## Description
[INFERRED_ONE_LINER]

## Problem
[INFERRED_PROBLEM]

## Success Criteria
- [Criterion 1 - inferred from goals]
- [Criterion 2 - inferred from goals]

## Constraints
[INFERRED_CONSTRAINTS if any]

## Out of Scope
[What's clearly NOT in scope]
BRIEF_EOF

# Create roadmap (3-6 phases from domain patterns)
cat > .claude/workspace/planning/ROADMAP.md <<ROADMAP_EOF
# Project Roadmap

## Phases

### Phase 01: foundation
[Status: not_started]
Core infrastructure setup

### Phase 02: [inferred from project type]
[Status: not_started]
[Description]

... (3-6 phases total)
ROADMAP_EOF

# Create phase directories
for phase in 01-*; do mkdir -p ".claude/workspace/planning/phases/$phase"; done

# Commit initialization
git add .claude/workspace/planning/
git commit -m "docs: initialize [INFERRED_NAME] ([N] phases)"
```

**CONFIRM** (single question):

```
✓ Created brief + roadmap for [INFERRED_NAME]
✓ [N] phases defined
✓ Committed initialization

Next: Plan Phase 1 tasks? (yes/no/customize)
```

### State 2: Brief Only (No Roadmap)

**Detected**: `brief` present, `roadmap` missing

**Action**: Create roadmap autonomously from brief

**EXPLORE**:

- Read BRIEF.md for scope and goals
- Check codebase for what exists
- Git history for recent work

**INFER** phases:

- Project type → domain pattern (web app, CLI tool, library)
- Brief scope → number of phases (3-6)
- Domain → phase ordering (foundation → auth → features → polish)

**AUTONOMOUS CREATE**:

- Generate ROADMAP.md with inferred phases
- Create phase directories
- Commit with descriptive message

**CONFIRM**:

```
✓ Created roadmap with [N] phases
✓ Phase directories created

Next: Plan Phase 1? (yes/review)
```

### State 3: Roadmap Only (No Phase Plans)

**Detected**: `roadmap` present, `plans:0`

**Action**: Create first phase plan autonomously

**EXPLORE**:

- Read ROADMAP.md for Phase 1 scope
- Check codebase for existing foundation
- Domain expertise loading (if skill exists)

**INFER** tasks for Phase 1:

- Phase scope → 2-3 atomic tasks
- Dependencies → task ordering
- Tech stack → specific implementation steps

**AUTONOMOUS CREATE** via `create-plans` skill:

```
Skill: plan-phase workflow
Input: Phase 1 scope from ROADMAP
Output: 2-3 atomic tasks in PLAN.md
```

**CONFIRM**:

```
✓ Phase 1 planned: [N] tasks
→ Task 1: [name]
→ Task 2: [name]
→ Task 3: [name]

Execute Phase 1? (yes/review/customize)
```

### State 4: Incomplete Phase (Plans > Summaries)

**Detected**: `plans:N` where `N > summaries`

**Action**: Identify next tasks chunk (fully autonomous)

**EXPLORE** phase state:

```bash
# Find current incomplete phase
INCOMPLETE_PHASE=$(find .claude/workspace/planning/phases -name "*-PLAN.md" -exec sh -c '
  plan="$1"
  summary="${plan%-PLAN.md}-SUMMARY.md"
  [ ! -f "$summary" ] && echo "$plan"
' _ {} \; | head -1 | xargs dirname)

# Read the plan
CURRENT_PLAN="$INCOMPLETE_PHASE/$(basename $INCOMPLETE_PHASE)-PLAN.md"
cat "$CURRENT_PLAN"
```

**ANALYZE** plan content:

- Extract task list with completion status
- Identify next 1-3 incomplete tasks
- Verify dependencies are met

**PRESENT** chunk autonomously:

```
Current: [Phase Name]
Progress: [X]/[Y] tasks complete

Next chunk (ready to work):
1. Task [N]: [Name] - [Action description]
2. Task [N+1]: [Name] - [Action description]

Working on these now? (yes/see full plan/different)
```

**If yes** → Delegate to `execution-orchestrator` skill
**If see full** → Show all remaining tasks
**If different** → Ask what to focus on

### State 5: Handoff Exists

**Detected**: `handoff` present

**Action**: Resume from handoff

**EXPLORE**:

- Read `.continue-here.md` for context
- Parse YAML frontmatter
- Calculate time ago

**PRESENT** summary:

```
Resuming: [Phase] - Task [N]/[Total]
Last updated: [time ago]

Completed:
- [Task 1]
- [Task 2]

Current: [Task N]
- Progress: [what's done]
- Remaining: [what's left]

Ready to continue? (yes/see full/refresh)
```

**If yes** → Load context, delete handoff, continue
**If see full** → Show complete handoff
**If refresh** → Re-assess from plan

## Autonomous Decision Matrix

```
DETECTED STATE              | ACTION                            | QUESTIONS
----------------------------|-----------------------------------|---------------------------
No structure                | Create brief + roadmap             | 1 (confirm & next)
Brief only                   | Create roadmap                     | 1 (confirm & next)
Roadmap only                 | Create first phase plan            | 1 (confirm & execute)
Incomplete phase             | Present next 1-3 tasks (chunk)     | 1 (execute/see more)
Handoff exists               | Resume from handoff                | 1 (confirm/see full)
```

**Maximum 1 AskUserQuestion round** after autonomous detection and action.

## Usage Examples

**Start new project**:

```
/plan:create Build a CLI tool for task management
→ [Analyzes request]
→ [Creates brief + roadmap]
→ [Infers 4 phases: foundation, core-features, polish, docs]
→ [Commits initialization]
✓ Created brief + roadmap
Next: Plan Phase 1? (yes)
```

**Continue existing**:

```
/plan:create
→ [Scans structure]
→ [Finds Phase 1 in progress: 2/5 tasks complete]
Current: 01-foundation
Progress: 2/5 tasks complete

Next chunk:
1. Task 3: Setup database schema - Create models and migrations
2. Task 4: Create API client - Build request/response handling

Working on these? (yes)
```

**Quick "what's next"**:

```
/plan:create
→ [Immediately shows next tasks]
→ No setup, no questions about state
```

## Success Criteria

- [ ] 0 AskUserQuestion rounds when context fully inferable
- [ ] 1 AskUserQuestion round max (confirmation/selection)
- [ ] No asking about state (detected autonomously)
- [ ] Brief under 50 lines
- [ ] Roadmap 3-6 phases
- [ ] Chunks 1-3 tasks only
- [ ] Handoff deleted after resume

<critical_constraint>
MANDATORY: Detect all state autonomously before any user interaction

MANDATORY: Maximum 1 AskUserQuestion round after autonomous action

MANDATORY: Chunk size 1-3 tasks maximum

MANDATORY: Brief under 50 lines (human-focused)

MANDATORY: Roadmap 3-6 phases maximum

MANDATORY: Delete handoff after resume (not permanent storage)

No exceptions. Fully autonomous single-command planning.
</critical_constraint>
