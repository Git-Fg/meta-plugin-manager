---
description: "Create project plans with intelligent auto-inference. Detects context and creates brief/roadmap/phases as needed."
argument-hint: [project description or "auto" for context detection]
---

# Plan Creation

<mission_control>
<objective>Create project plans with intelligent context inference - brief, roadmap, or phases as needed</objective>
<success_criteria>Appropriate planning artifacts created based on detected context with minimal user input</success_criteria>
</mission_control>

## Purpose

Single entry point for all planning operations. Auto-detects what's needed and creates:

- **BRIEF.md** - Project vision (no structure exists)
- **ROADMAP.md** - Phase structure (brief exists, no roadmap)
- **Phase plans** - Implementation prompts (roadmap exists)

## Context Scan

```bash
# Check planning structure
[ -f .claude/workspace/planning/BRIEF.md ] && echo "BRIEF: exists"
[ -f .claude/workspace/planning/ROADMAP.md ] && echo "ROADMAP: exists"
find .claude/workspace/planning/phases -name "PLAN.md" 2>/dev/null | wc -l
find .claude/workspace/planning/phases -name "SUMMARY.md" 2>/dev/null | wc -l
find .claude/workspace/planning/phases -name ".continue-here.md" 2>/dev/null
```

## Auto-Inference Logic

### No Structure → Create Brief + Roadmap

**When**: No `.claude/workspace/planning/` directory

**EXPLORE**:

- Analyze user's original request for project name, description, constraints
- Check for similar projects in git history
- Identify tech stack hints in request

**INFER**:
| Question | Can Infer If... |
|----------|----------------|
| Project name | Request mentions name |
| What building | Request describes functionality |
| Why needed | Request mentions problem/solution |
| Constraints | Request mentions tech stack |

**ASK ONE** (if needed):

- Provide numbered options for project type/scope
- Otherwise proceed with inferred values

**Create Brief** (use template from `create-plans/templates/brief.md`):

```bash
mkdir -p .claude/workspace/planning
cat > .claude/workspace/planning/BRIEF.md <<'EOF'
# Project: [Name]

## Description

[One-line description]

## Problem

[Why this exists]

## Success Criteria

- [Criterion 1]
- [Criterion 2]

## Constraints

- [Any technical or time constraints]

## Out of Scope

[What we're NOT building]
EOF
```

**Create Roadmap** (use template from `create-plans/templates/roadmap.md`):

Based on brief, define 3-6 phases:

- `01-foundation` - Database schema, API structure
- `02-authentication` - User accounts, login flow
- `03-core-features` - Main functionality
- `04-polish` - Testing, documentation

```bash
mkdir -p .claude/workspace/planning/phases/{01-{phase1},02-{phase2},...}
```

**Commit initialization**:

```bash
git add .claude/workspace/planning/
git commit -m "docs: initialize [project-name] ([N] phases)"
```

**CONFIRM**:

```
Project initialized:
- Brief: .claude/workspace/planning/BRIEF.md
- Roadmap: .claude/workspace/planning/ROADMAP.md
- [N] phases defined

Ready to plan Phase 1? (yes / review / later)
```

### Brief Exists, No Roadmap → Create Roadmap

**When**: BRIEF.md exists but no ROADMAP.md

**EXPLORE**:

- Read BRIEF.md for project vision
- Check existing codebase for what's built
- Git history for recent work

**INFER** phases from brief + domain patterns:

- Foundation → Core Feature → Enhancement → Polish
- 3-6 phases, 1-3 days each

**Create Roadmap** with phase directories and commit.

### Roadmap Exists → Plan Next Phase

**When**: ROADMAP.md exists with incomplete phases

**Find next incomplete phase**:

```bash
grep -A 2 "not_started\|in_progress" .claude/workspace/planning/ROADMAP.md
```

**Route to** `create-plans` skill's `plan-phase` workflow:

- Skill loads domain expertise if needed
- Creates 2-3 atomic tasks for phase
- Delegates to `execution-orchestrator` for execution

### Handoff Found → Resume

**When**: `.continue-here.md` found in phase directory

Present summary and ask to resume.

## Usage Patterns

**New project (no structure)**:

```
/plan:create Build a task manager app
→ Creates brief + roadmap + commits
→ Asks to plan Phase 1
```

**Existing project (roadmap exists)**:

```
/plan:create
→ Detects roadmap, finds next phase
→ Plans 2-3 tasks for next phase
```

**Continue from handoff**:

```
/plan:create
→ Finds .continue-here.md
→ Presents context, asks to resume
```

## Success Criteria

- [ ] EXPLORE → INFER → ASK ONE pattern followed
- [ ] 0 questions if context clear (max 1 if ambiguous)
- [ ] Correct artifacts created based on state
- [ ] Brief: Under 50 lines, has name/description/problem/success
- [ ] Roadmap: 3-6 phases, XX-kebab-case naming
- [ ] Phase: 2-3 atomic tasks, delegated to skill
- [ ] Initialization committed (brief + roadmap)

<critical_constraint>
MANDATORY: Auto-detect planning state before asking anything

MANDATORY: Use EXPLORE → INFER → ASK ONE (max 1 question)

MANDATORY: Create brief under 50 lines (human-focused)

MANDATORY: Roadmap: 3-6 phases maximum

MANDATORY: Delegate phase planning to create-plans skill

MANDATORY: Commit brief + roadmap as initialization

No exceptions. Single command handles all planning states.
</critical_constraint>
