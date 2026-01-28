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

<critical_constraint>
MANDATORY: Load appropriate nested skill based on routing decision
No exceptions. Orchestrator must delegate, not implement.
</critical_constraint>
