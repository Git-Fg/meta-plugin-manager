---
description: "Maintain TODO.md with real-time progress tracking. Use when: user mentions 'todo', 'task list', 'track progress'; starting project work; managing multiple tasks. Not for: simple reminders, single-task workflows."
argument-hint: "[action] [task description]"
allowed-tools: ["Read", "Write", "TodoWrite"]
---

# Realtime Task Tracking

Think of task tracking as **visualizing progress**—maintaining a living TODO.md that updates dynamically as tasks move through states.

## Core Workflow

**Execute this pattern during task work:**

1. **Initialize TODO.md** at project start
2. **Mark task in_progress** before starting work
3. **Update TODO.md** on each state change
4. **Recalculate progress** after each update
5. **Add discovered tasks** immediately when found

## Initialize TODO.md

Create TODO.md at project start:

```markdown
# TODO

## Progress: 0/3 tasks (0%)

### ✅ Completed
_No completed tasks yet_

### 🔄 In Progress
- [*] Current task being worked on

### ⏳ Pending
- [ ] Task two
- [ ] Task three
```

Use TodoWrite tool for internal tracking. Write TODO.md for visualization.

## Task Status Indicators

Track progress with visual markers:
- `[ ]` - Pending task
- `[*]` - In progress (exactly one at a time)
- `[x]` - Completed

## Update Lifecycle

**On each state change:**

1. **Start task** → Mark as `[*]` in In Progress section
2. **Complete task** → Change to `[x]`, move to Completed, recalculate progress
3. **Discover task** → Add to Pending section immediately
4. **Show progress** → Update header with completed/total count

## Progress Calculation

Calculate percentage: `(completed / total) * 100`

Update header format: `## Progress: X/Y tasks (Z%)`

## Discovery Pattern

When finding new work during execution, add immediately to Pending:

```markdown
### ⏳ Pending
- [ ] Original task
- [ ] Discovered task found while implementing X
```

## Usage Pattern

Initialize TODO.md before starting work. Update on each task completion. Mark tasks in progress before starting. Add discovered tasks immediately. Recalculate progress after each change.

**Binary test:** "Is TODO.md current with actual work state?" → Update if no.

## Argument Handling

When invoked with arguments:

- `[task description]` - Add new task to Pending
- No arguments - Initialize TODO.md or show current status

**Contrast:**
```
✅ Good: Update TODO.md on every state change
✅ Good: Add discovered tasks immediately
❌ Bad: Let TODO.md become stale
```
