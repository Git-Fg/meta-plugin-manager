---
description: "Create hierarchical project plans (brief → roadmap → phase → PLAN.md) for solo agentic development. Use when planning projects, phases, or tasks."
argument-hint: [project description or "auto" for context detection]
---

# Plan Creation

<mission_control>
<objective>Create hierarchical project plans with context-aware routing and delegation</objective>
<success_criteria>Appropriate planning workflow triggered or plan created with correct structure</success_criteria>
</mission_control>

## Context Inference

When invoked, analyze conversation to determine:

1. **What planning state exists?**
   - Check for `.claude/workspace/planning/` directory
   - Look for BRIEF.md, ROADMAP.md, phase directories
   - Identify what's already defined

2. **What does user want?**
   - Parse $ARGUMENTS for project description
   - Infer planning need from context
   - Detect if continuing existing work

3. **What should happen next?**
   - No planning structure → Offer brief/roadmap
   - Has brief + no roadmap → Create roadmap
   - Has roadmap → Plan next phase or chunk
   - Phase in progress → Continue with chunk

## Routing Logic

**Context Scan:**

```bash
# Check planning structure
ls -la .claude/workspace/planning/ 2>/dev/null
cat .claude/workspace/planning/BRIEF.md 2>/dev/null
cat .claude/workspace/planning/ROADMAP.md 2>/dev/null
find .claude/workspace/planning/phases -name "PLAN.md" 2>/dev/null | head -5
find .claude/workspace/planning/phases -name "SUMMARY.md" 2>/dev/null | head -5
find .claude/workspace/planning/phases -name ".continue-here.md" 2>/dev/null
```

**Routing Decision Tree:**

```
No planning structure?
├─ Yes → Offer: brief → roadmap → phase planning
└─ No  → Continue to next check

Has BRIEF.md but no ROADMAP.md?
├─ Yes → Route to /plan:roadmap
└─ No  → Continue to next check

Has ROADMAP.md with incomplete phases?
├─ Yes → Route to /plan:chunk (next tasks)
└─ No  → Continue to next check

Handoff file found?
├─ Yes → Route to /plan:resume
└─ No  → Continue to next check

User provided specific project description?
├─ Yes → Determine appropriate starting point
└─ No  → Present guided options
```

## Intake & Routing

### Auto-Detection Priority

1. **Handoff exists** → Route to `/plan:resume`
2. **No structure** + $ARGUMENTS provided → Start with brief
3. **Has brief, no roadmap** → Route to `/plan:roadmap`
4. **Roadmap exists, phase in progress** → Route to `/plan:chunk`
5. **Explicit intent in $ARGUMENTS** → Route appropriately

### Present Options

**When no structure exists:**

```
No planning structure found. What would you like to do?

1. Create project vision (BRIEF.md) - Define what and why
2. Create phase structure (ROADMAP.md) - Requires BRIEF.md
3. Plan next tasks (chunk) - Requires existing phase
4. Create comprehensive plan - brief → roadmap → phase
```

**When structure exists:**

```
Planning structure found:
- Brief: [exists/missing]
- Roadmap: [exists/missing]
- Phases: [N total, M incomplete]

Next actions:
1. Plan next phase (/plan:chunk)
2. Create roadmap (/plan:roadmap)
3. Resume from handoff (/plan:resume)
4. Other [specify]
```

## Delegation to Skill

For actual plan creation, delegate to `create-plans` skill via Skill tool:

- Pass inferred requirements and context
- Let skill handle detailed planning logic
- Skill contains workflows, templates, references

**Command role:** Routing, context inference, user interaction
**Skill role:** Domain logic, plan generation, structural decisions

## Usage Patterns

**Start new project:**

```
/plan:create Build a todo app with auth
[Detects no structure → offers to create brief]
```

**Continue existing project:**

```
/plan:create
[Detects roadmap and incomplete phases → offers to chunk]
```

**With explicit workflow:**

```
/plan:create brief: Add user authentication
[Routes directly to /plan:brief]
```

## Success Criteria

- Correct workflow identified from context
- User routed to appropriate command or skill
- High autonomy (0-2 questions)
- Clear next steps presented

<critical_constraint>
MANDATORY: Use EXPLORE → INFER → ASK ONE pattern (max 1 question)

MANDATORY: Delegate detailed planning to create-plans skill

MANDATORY: Commands route, skill executes (portability invariant)

MANDATORY: Auto-detect planning structure before asking

No exceptions. Planning is context-heavy - infer first, ask rarely.
</critical_constraint>
