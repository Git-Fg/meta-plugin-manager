# Output Contracts

## DETECT Output

```markdown
## Workflow Analysis Complete

### Complexity: [Simple|Moderate|Complex]
### Recommendation: [Use TaskList|Use skills|Use hybrid]

### Rationale
- [Why this approach fits]

### Suggested Approach
- [Coordination strategy]
```

## CREATE Output

```markdown
## Task List Created: [workflow_name]

### Tasks: [count]
- Task 1: [subject]
- Task 2: [subject] (blocked by Task 1)
- Task 3: [subject] (blocked by Task 1, Task 2)

### Persistence
- Session ID: [id|default]
- Location: [~/.claude/tasks/.../]

### Next Steps
- [How to proceed with execution]
```

## EXECUTE Output

```markdown
## Workflow Execution Complete

### Tasks Completed: [X]/[Y]
### Coordination: [TaskList + Skills|Subagents|Mixed]

### Results
- [Aggregated results summary]

### Quality Score: XX/100
```

## VALIDATE Output

```markdown
## Task Validation Complete

### Status: [count] total, [X] complete, [Y] pending, [Z] blocked

### Blockers
- [List of blocking tasks]

### Next Actions
- [Recommended next steps]
```

---

# Anti-Patterns

## ❌ Using TaskList for simple workflows - Tasks add overhead

- Simple 2-3 step work? Use skills directly

## ❌ Tasks without dependencies - Missing the point

- If no tasks block other tasks, consider simpler workflow

## ❌ Tasks for one-shot work - Persistence unnecessary

- Session-bound work? Skills are sufficient

## ❌ Micro-tasking - Over-granular tasks

- If tasks complete in seconds, consolidate
