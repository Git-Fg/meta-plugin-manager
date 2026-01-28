# Workflow: Create Roadmap

## Required Reading

**Read these files NOW:**

1. templates/roadmap.md
2. Read `.claude/workspace/planning/BRIEF.md` if it exists

## Purpose

Define the phases of implementation. Each phase is a coherent chunk of work
that delivers value. The roadmap provides structure, not detailed tasks.

## Process

#### EXPLORE

| What to Explore    | How                           | Goal                                   |
| ------------------ | ----------------------------- | -------------------------------------- |
| Planning artifacts | Read BRIEF.md                 | Understand project vision, constraints |
| Existing code      | Glob src/, check package.json | Identify what's already built          |
| Git history        | `git log --oneline -10`       | What was done recently                 |
| User request       | Analyze original request      | Scope, priorities                      |

#### INFER

Try to infer from exploration:

| Question      | Can Infer If...             | Won't Ask If...    |
| ------------- | --------------------------- | ------------------ |
| Project scope | BRIEF.md + code scope       | Clear from context |
| Phases needed | Domain patterns + codebase  | Obvious structure  |
| Dependencies  | Git history shows work done | No prior work      |
| Phase order   | Logical dependencies        | Obvious sequence   |

#### ASK ONE

Only if context is unclear after EXPLORE + INFER, ask ONE focused question with numbered options the user can select.

**Provide actionable propositions** - present inferred roadmap structure and let user confirm/adjust by selection, not typing.

**If all inferred**: Proceed to identify_phases without asking.

#### check_brief

```bash
cat .claude/workspace/planning/BRIEF.md 2>/dev/null || echo "No brief found"
```

**If no brief exists:** This should be caught in ASK ONE. Only ask here if ASK ONE wasn't used.

#### identify_phases

Based on the brief/context, identify 3-6 phases.

Good phases are:

- **Coherent**: Each delivers something complete
- **Sequential**: Later phases build on earlier
- **Sized right**: 1-3 days of work each (for solo + Claude)

Common phase patterns:

- Foundation → Core Feature → Enhancement → Polish
- Setup → MVP → Iteration → Launch
- Infrastructure → Backend → Frontend → Integration

#### create_structure

```bash
mkdir -p .claude/workspace/planning/phases
```

#### write_roadmap

Use template from `templates/roadmap.md`.

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

#### git_commit_initialization

Commit project initialization (brief + roadmap together):

```bash
git add .claude/workspace/planning/
git commit -m "$(cat <<'EOF'
docs: initialize [project-name] ([N] phases)

[One-liner from BRIEF.md]

Phases:
1. [phase-name]: [goal]
2. [phase-name]: [goal]
3. [phase-name]: [goal]
EOF
)"
```

Confirm: "Committed: docs: initialize [project] ([N] phases)"

#### CONFIRM

```
Project initialized:
- Brief: .claude/workspace/planning/BRIEF.md
- Roadmap: .claude/workspace/planning/ROADMAP.md
- Committed as: docs: initialize [project] ([N] phases)

Invoke /create-plans to plan Phase 1? (yes / review / later)
```

<phase_naming>
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
- Don't scatter questions throughout

Phases are buckets of work, not project management artifacts.

## Success Criteria

Roadmap is complete when:

- [ ] EXPLORE + INFER attempted
- [ ] 0 questions asked if all inferred (max 1 if needed)
- [ ] `.claude/workspace/planning/ROADMAP.md` exists
- [ ] 3-6 phases defined with clear names
- [ ] Phase directories created
- [ ] Dependencies noted if any
- [ ] Status tracking in place
- [ ] CONFIRM asked: "Invoke /create-plans for Phase 1?"
