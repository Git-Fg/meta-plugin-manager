---
description: "Create STRATEGY.md with dependency graph using EnterPlanMode and planning philosophy. Use when starting new projects, continuing from brief/roadmap, or planning complex work with parallel execution. Not for simple tasks - use /plan:create for atomic work."
argument-hint: [project description or "auto" for context detection]
---

# Strategy Architecture

**Uses native EnterPlanMode with parallel detection logic**

## Quick Context

Creates STRATEGY.md with phase-based dependency graph. Detects parallelizable work and structures phases accordingly.

## Workflow

### 1. Detect Strategy State

Detect current planning state:

- `Glob: .claude/workspace/strategy/**/*-STRATEGY.md` → Existing strategies
- `Glob: .claude/workspace/strategy/**/phases/**/*` → Phase breakdowns
- `Glob: .claude/workspace/planning/BRIEF.md` → Project brief
- `Glob: .claude/workspace/planning/ROADMAP.md` → Roadmap

**Decision Matrix:**

| Detected State    | Action                                   |
| ----------------- | ---------------------------------------- |
| No structure      | Enter plan mode with project description |
| Brief only        | Enter plan mode with parallel detection  |
| Existing strategy | Ask: continue, modify, or create variant |
| Incomplete phases | Present next phase, migrate to TodoWrite |

### 2. Enter Plan Mode with Parallel Detection

**Invoke EnterPlanMode** with planning philosophy context:

```
EnterPlanMode(
  allowedPrompts=[{tool: "Bash", prompt: "run git commands"}],
  pushToRemote=false
)
```

**Inject planning context:**

- Read `.claude/skills/planning-guide/SKILL.md`
- Include parallel detection patterns from `architecture.md`
- Include project description or brief content

### 3. Parallel Detection Logic

During plan mode, apply parallel detection heuristics:

**Parallel candidates (independent work):**

| Pattern              | Example                            |
| -------------------- | ---------------------------------- |
| Multiple file types  | "Create API and UI components"     |
| Different modules    | "Implement auth and user services" |
| Documentation + code | "Write tests and docs"             |
| Separate features    | "Add search and filter"            |

**Sequential requirements (dependencies):**

| Pattern              | Example                             |
| -------------------- | ----------------------------------- |
| Shared models        | "Must have User model before API"   |
| Shared configuration | "Config first, then implementation" |
| Dependent features   | "Login before profile"              |

### 4. Structure STRATEGY.md

Generate STRATEGY.md with phase structure:

```markdown
# Strategy: [Project Name]

## Overview

[Brief description]

## Phases

<phases>

## Phase 1: [Sequential Work]

<phase id="phase-1" type="sequential" gate="qa:verify-phase">

<task id="1.1" name="..." style="tdd" agent="general-purpose" checkpoint="none">
  - [Subtask 1]
</task>

</phase>

## Phase 2: [Parallel Work]

<phase id="phase-2" type="parallel" gate="qa:verify-phase">

<task id="2.1" name="..." style="tdd" agent="general-purpose" checkpoint="none">
  - [Subtask 1]
</task>

<task id="2.2" name="..." style="tdd" agent="general-purpose" checkpoint="none">
  - [Subtask 1]
</task>

</phase>

</phases>

## Gate Criteria

[gates per phase]
```

### 5. After Plan Mode Exits

**Migrate to TodoWrite:**

1. Parse STRATEGY.md phases
2. Create phase-level TodoWrite tasks
3. Use TaskList for tracking

```typescript
TaskCreate({
  subject: "Phase 1: [Phase name]",
  description: "[Task list from STRATEGY.md]",
});
```

### 6. Create Documentation

- Write STRATEGY.md for execution reference
- Update ROADMAP.md with new strategy
- Create phase subdirectories if needed

## Usage Patterns

**New project:**

```
/strategy:architect Build user authentication system
```

**Continue from existing state:**

```
/strategy:architect auto
```

**Parallel-heavy project:**

```
/strategy:architect Implement API, UI, and docs concurrently
```

## Success Criteria

- [ ] EnterPlanMode invoked with planning philosophy
- [ ] Parallel detection applied (identifies independent work)
- [ ] STRATEGY.md written with dependency graph
- [ ] TodoWrite tasks created for phase tracking
- [ ] ROADMAP.md updated

---

<critical_constraint>
MANDATORY: Detect parallelizable work and structure phases accordingly

MANDATORY: Use <phase type="parallel"> for independent tasks

MANDATORY: Tag sequential dependencies explicitly

MANDATORY: Phase-level TodoWrite (not micro-task tracking)
</critical_constraint>
