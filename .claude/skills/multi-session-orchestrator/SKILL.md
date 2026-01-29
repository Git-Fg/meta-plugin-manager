---
name: multi-session-orchestrator
description: "Orchestrate multi-session workflows that span multiple sessions or require state persistence. Use when tasks span multiple sessions, state needs tracking, or progress must be maintained. Includes task persistence, progress tracking, and seamless resume. Not for single-session tasks, simple scripts, or stateless operations."
---

<mission_control>
<objective>Orchestrate multi-session workflows that maintain state and progress across Claude Code sessions.</objective>
<success_criteria>TaskList persisted, progress maintained, workflow resumes seamlessly in next session</success_criteria>
</mission_control>

# Multi-Session Orchestration

## Workflow

**Session 1:** Create TaskList with all phases, execute first phase, save TaskList ID

**Between sessions:** User provides TaskList ID, system loads state

**Session 2:** Resume from last completed phase, continue execution

**Why:** TaskList persists across sessions—workflows that span hours/days continue seamlessly.

---

## Navigation

| If you need...          | Read...                                |
| :---------------------- | :------------------------------------- |
| Session 1 workflow      | ## Workflow → Session 1                |
| Between sessions        | ## Workflow → Between sessions         |
| Session 2 resume        | ## Workflow → Session 2                |
| Cross-session pattern   | ## Workflow → Why                      |
| Implementation patterns | ## Implementation Patterns             |
| TaskList persistence    | ## Implementation Patterns → Pattern 1 |

---

## Implementation Patterns

### Pattern 1: Session 1 (Initial)

```typescript
// Create TaskList with migration phases
const taskList = await TaskListCreate({
  tasks: [
    { id: "database-migration", status: "pending" },
    { id: "application-migration", status: "pending" },
    { id: "data-validation", status: "pending" },
  ],
});

// Execute first task
await TaskUpdate({ id: "database-migration", status: "IN_PROGRESS" });
// ... do work ...
await TaskUpdate({ id: "database-migration", status: "COMPLETE" });

// CRITICAL: Report TaskList ID
console.log(`TaskList ID: ${taskList.id} - Save for Session 2`);
```

### Pattern 2: Session 2 (Resume)

```typescript
// Load existing TaskList by ID
const taskList = await TaskListGet({ id: savedTaskListId });

// Verify state preserved
if (taskList.tasks[0].status === "COMPLETE") {
  console.log("Status preserved - continuing...");
}

// Continue from where Session 1 ended
await TaskUpdate({ id: "application-migration", status: "IN_PROGRESS" });
```

### Pattern 3: Validation

```typescript
// Binary check: "Proper cross-session persistence?"
const checks = {
  taskListIdContinuity: savedId !== null,
  statusPreserved: previousStatus === "COMPLETE",
  seamlessContinuation: currentPhase === previousPhase + 1,
};

if (allChecksPass(checks)) {
  return "Cross-session persistence: VERIFIED";
}
```

---

## Troubleshooting

### Issue: TaskList ID Lost

| Symptom                      | Solution                      |
| ---------------------------- | ----------------------------- |
| No TaskList ID for Session 2 | Report and save TaskList ID   |
| ID not persisted             | Use TaskListGet to load by ID |

### Issue: State Not Preserved

| Symptom                 | Solution                       |
| ----------------------- | ------------------------------ |
| Status reset to PENDING | Verify TaskList ID is correct  |
| Tasks missing           | Check taskList.tasks structure |

### Issue: Session Continuation Failed

| Symptom                                | Solution                                      |
| -------------------------------------- | --------------------------------------------- |
| Can't continue from previous state     | Create new TaskList with previous as template |
| Session 2 doesn't know about Session 1 | Explicit handoff of TaskList ID               |

### Issue: Handoff Document Missing

| Symptom                     | Solution                                 |
| --------------------------- | ---------------------------------------- |
| Next session has no context | Create handoff document with TaskList ID |

---

## Workflows

### Cross-Session Workflow

```
Session 1:
1. Create TaskList with phases
2. Execute first phase
3. Report TaskList ID

Session 2:
1. Load TaskList by ID
2. Verify state preserved
3. Continue execution
4. Complete remaining phases
```

### State Persistence Pattern

```bash
# Verify before proceeding
TaskListGet --id <id>
# Check: Are previous tasks marked COMPLETE?
```

---

## Genetic Code

This component carries essential Seed System principles for context: fork isolation:

<critical_constraint>
Portability invariant: All components MUST be self-contained (zero .claude/rules dependency)
Progressive disclosure: Use XML for control (mission_control, critical_constraint), Markdown for data
No exceptions. Portability invariant must be maintained.
</critical_constraint>

**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows

**Recognition Questions**:

- "Would Claude know this without being told?" → Delete (zero delta)
- "Can this work standalone?" → Fix if no (non-self-sufficient)
- "Did I read the actual file, or just see it in grep?" → Verify before claiming

---
