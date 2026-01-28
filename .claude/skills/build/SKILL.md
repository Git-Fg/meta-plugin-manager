---
name: build
description: "Orchestrates build-related tasks. Routes to frontend or backend build skills based on target."
---

# Build Orchestrator

<mission_control>
<objective>Route build requests to appropriate build subsystem</objective>
<success_criteria>Correct subsystem targeted with appropriate build command</success_criteria>
</mission_control>

<trigger>When user wants to build the application, or any component of it</trigger>

## Routing

| Request                               | Route To                          |
| ------------------------------------- | --------------------------------- |
| "frontend", "UI", "React", "Vue"      | `build-frontend`                  |
| "backend", "API", "server", "service" | `build-backend`                   |
| "all", "everything", "full"           | Execute both frontend and backend |
| Unclear                               | Ask which subsystem to build      |

---

## Genetic Code

This component carries essential Seed System principles for context: fork isolation:

<critical_constraint>
MANDATORY: All components MUST be self-contained (zero .claude/rules dependency)
MANDATORY: Achieve 80-95% autonomy (0-5 AskUserQuestion rounds per session)
MANDATORY: Description MUST use What-When-Not format in third person
MANDATORY: No component references another component by name in description
MANDATORY: Progressive disclosure - references/ for detailed content
MANDATORY: Use XML for control (mission_control, critical_constraint), Markdown for data
No exceptions. Portability invariant must be maintained.
</critical_constraint>

**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows

**Recognition Questions**:

- "Would Claude know this without being told?" → Delete (zero delta)
- "Can this work standalone?" → Fix if no (non-self-sufficient)
- "Did I read the actual file, or just see it in grep?" → Verify before claiming

---

<critical_constraint>
MANDATORY: Load appropriate nested skill based on routing decision
No exceptions. Orchestrator must delegate, not implement.
</critical_constraint>
