---
description: "[DEPRECATED] Create ROADMAP.md with phase structure. Use `/plan:create` instead - auto-infers and creates brief/roadmap as needed."
argument-hint: [optional: phases to plan]
---

> **DEPRECATED**: This command has been merged into `/plan:create` for intelligent auto-inference.
>
> **Migration guide:**
>
> - `/plan:roadmap` → `/plan:create` (auto-detects need for roadmap)
> - `/plan:create` now creates brief + roadmap together when no structure exists
> - Use `/plan:create` to continue from brief to roadmap automatically
>
> This command remains for backward compatibility but will be removed in a future version.

---

# Roadmap Creation

<mission_control>
<objective>Define implementation phases with dependencies and status tracking</objective>
<success_criteria>ROADMAP.md created with 3-6 phases, phase directories initialized, committed</success_criteria>
</mission_control>

## Purpose

Define the phases of implementation. Each phase is a coherent chunk of work that delivers value. The roadmap provides structure, not detailed tasks.

## Process

### EXPLORE

| What to Explore    | How                           | Goal                                   |
| ------------------ | ----------------------------- | -------------------------------------- |
| Planning artifacts | Read BRIEF.md                 | Understand project vision, constraints |
| Existing code      | Glob src/, check package.json | Identify what's already built          |
| Git history        | `git log --oneline -10`       | What was done recently                 |
| User request       | Analyze original request      | Scope, priorities                      |

### INFER

Try to infer from exploration:

| Question      | Can Infer If...             | Won't Ask If...    |
| ------------- | --------------------------- | ------------------ |
| Project scope | BRIEF.md + code scope       | Clear from context |
| Phases needed | Domain patterns + codebase  | Obvious structure  |
| Dependencies  | Git history shows work done | No prior work      |
| Phase order   | Logical dependencies        | Obvious sequence   |

### ASK ONE

Only if context is unclear after EXPLORE + INFER, ask ONE focused question.

**Provide actionable propositions** - numbered options the user can select.

**If all inferred**: Proceed to check_brief without asking.

### Check Brief

```bash
cat .claude/workspace/planning/BRIEF.md 2>/dev/null || echo "No brief found"
```

**If no brief exists:** This should be caught in ASK ONE.

### Identify Phases

Based on the brief/context, identify 3-6 phases.

Good phases are:

- **Coherent**: Each delivers something complete
- **Sequential**: Later phases build on earlier
- **Sized right**: 1-3 days of work each (for solo + Claude)

Common phase patterns:

- Foundation → Core Feature → Enhancement → Polish
- Setup → MVP → Iteration → Launch
- Infrastructure → Backend → Frontend → Integration

### Create Structure

```bash
mkdir -p .claude/workspace/planning/phases
```

### Write Roadmap

Use template from `create-plans/templates/roadmap.md`.

Write to `.claude/workspace/planning/ROADMAP.md` with:

- Phase list with names and one-line descriptions
- Dependencies (what must complete before what)
- Status tracking (all start as "not started")

Create phase directories:

```bash
mkdir -p .claude/workspace/planning/phases/01-{phase-name}
mkdir -p .claude/workspace/planning/phases/02-{phase-name}
# etc.
```

### Git Commit Initialization

Commit project initialization (brief + roadmap together):

```bash
git add .claude/workspace/planning/
git commit -m "docs: initialize [project-name] ([N] phases)"
```

### CONFIRM

```
Project initialized:
- Brief: .claude/workspace/planning/BRIEF.md
- Roadmap: .claude/workspace/planning/ROADMAP.md
- Committed as: docs: initialize [project] ([N] phases)

Invoke /plan:create to plan Phase 1? (yes / review / later)
```

## Phase Naming

Use `XX-kebab-case-name` format:

- `01-foundation`
- `02-authentication`
- `03-core-features`
- `04-polish`

Numbers ensure ordering. Names describe content.

## Anti-Patterns

- Don't add time estimates
- Don't create Gantt charts
- Don't add resource allocation
- Don't include risk matrices
- Don't plan more than 6 phases (scope creep)

Phases are buckets of work, not project management artifacts.

## Success Criteria

- [ ] EXPLORE + INFER attempted
- [ ] 0 questions asked if all inferred (max 1 if needed)
- [ ] `.claude/workspace/planning/ROADMAP.md` exists
- [ ] 3-6 phases defined with clear names
- [ ] Phase directories created
- [ ] Dependencies noted if any
- [ ] Status tracking in place
- [ ] CONFIRM asked: "Invoke /plan:create for Phase 1?"

<critical_constraint>
MANDATORY: Use EXPLORE → INFER → ASK ONE pattern

MANDATORY: Limit to 3-6 phases (scope control)

MANDATORY: Phase naming: XX-kebab-case format

MANDATORY: Commit brief + roadmap together as initialization

No exceptions. Roadmap provides structure, not micromanagement.
</critical_constraint>
