# Code Task Format Specification

Standard format for `.code-task.md` files used with Ralph task workflows.

## File Structure

```markdown
---
status: pending | in_progress | completed | blocked
created: YYYY-MM-DD
started: null | YYYY-MM-DD
completed: null | YYYY-MM-DD
---
# Task: [Task Name]

## Description
[Clear description of what needs to be implemented and why]

## Background
[Relevant context needed to understand the task]

## Reference Documentation
**Required:**
- Design: [path to detailed design document]

**Additional References (if relevant):**
- [Specific research documents]

## Technical Requirements
1. [First requirement]
2. [Second requirement]

## Dependencies
- [First dependency with details]

## Implementation Approach
1. [First implementation step]
2. [Second implementation step]

## Acceptance Criteria

1. **[Criterion Name]**
   - Given [precondition]
   - When [action]
   - Then [expected result]

## Metadata
- **Complexity**: Low | Medium | High
- **Labels**: [Comma-separated list]
- **Required Skills**: [Skills needed]
```

## Status Lifecycle

| Status | Symbol | Meaning |
|--------|--------|---------|
| `pending` | ○ | Task created, not started |
| `in_progress` | ● | Work has begun |
| `completed` | ✓ | Task finished |
| `blocked` | ■ | Cannot proceed |

## Naming Conventions

### Single Tasks
```
tasks/{task-name}.code-task.md
```

### PDD Step Tasks
```
tasks/step{NN}/task-{NN}-{title}.code-task.md

# Example:
tasks/step01/task-01-create-data-models.code-task.md
tasks/step01/task-02-implement-validation.code-task.md
tasks/step02/task-01-add-api-endpoints.code-task.md
```

## Integration with Ralph

### Generate Tasks
```bash
ralph task              # Start code-task-generator session
```

### Find Tasks
```bash
# List all tasks with status
.claude/skills/find-code-tasks/task-status.sh

# Filter by status
.claude/skills/find-code-tasks/task-status.sh --pending
.claude/skills/find-code-tasks/task-status.sh --in_progress

# JSON output for scripting
.claude/skills/find-code-tasks/task-status.sh --json
```

### Execute Tasks
Create a PROMPT.md for Ralph:

```markdown
## Objective
Implement the task defined in tasks/{task-name}.code-task.md

## Requirements
- Read and follow the task specification
- Use TDD approach (tests first)
- Commit with conventional commit message

## Acceptance
All acceptance criteria from the task file must pass.
```

Then run:
```bash
ralph run -P PROMPT.md
```

## Best Practices

1. **One concept per task** - Split complex work into multiple tasks
2. **Testable criteria** - Every acceptance criterion should be verifiable
3. **Include dependencies** - List blockers explicitly
4. **Update frontmatter** - Keep status current as work progresses
5. **No separate test tasks** - Include tests in implementation tasks
