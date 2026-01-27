---
name: executing-plans
description: "Execute implementation plans. Use when: Running a plan with multiple independent tasks, needing checkpoints and progress tracking. Not for: Ad-hoc execution or linearly dependent tasks without checkpoints."
---

# Executing Plans

## Overview

Execute comprehensive implementation plans by dispatching batches of tasks with human-in-loop checkpoints. Designed for independent tasks that can be verified and tracked systematically.

**Core principle:** Batch execution with checkpoints + systematic tracking = reliable plan completion.

**Announce at start:** "I'm using the executing-plans skill to execute the implementation plan."

## When to Use

**Use when:**
- Implementation plan exists with bite-sized tasks
- Tasks are independent (can be done in any order)
- Need human-in-loop checkpoints for verification
- Want systematic progress tracking
- Parallel session execution preferred

**Don't use when:**
- Tasks are tightly coupled (must be done sequentially)
- Need fresh subagent per task (use `subagent-driven-development` instead)
- Want same-session execution (use `subagent-driven-development`)

## The Process

### Step 1: Load Plan

Read the implementation plan and extract all tasks:

```bash
# Load plan document
cat docs/plans/YYYY-MM-DD-feature-plan.md

# Extract task list
grep "^### Task" docs/plans/feature-plan.md
```

### Step 2: Create Task List

Create a structured task list for tracking:

```markdown
## Task List

- [ ] Task 1: [Name] (estimated: 5 min)
- [ ] Task 2: [Name] (estimated: 5 min)
- [ ] Task 3: [Name] (estimated: 5 min)
- [ ] Task 4: [Name] (estimated: 5 min)
- [ ] Task 5: [Name] (estimated: 5 min)
```

### Step 3: Execute Batch

Process tasks in batches of 3-5:

**Batch execution:**
```
Batch 1: Tasks 1-3
├── Task 1: Add email validation
├── Task 2: Add password validation
└── Task 3: Add login endpoint
```

### Step 4: Checkpoint

After each batch, present checkpoint:

```
Batch 1 complete (3/3 tasks). Current status:

✅ Task 1: Email validation - DONE
✅ Task 2: Password validation - DONE
✅ Task 3: Login endpoint - DONE

Next batch: Tasks 4-5
- Task 4: Logout endpoint
- Task 5: Registration endpoint

Continue with batch 2?
```

### Step 5: Repeat

Continue until all batches complete.

## Batch Execution Pattern

### Task Structure

Each task should include:
- Exact file paths
- Complete code examples
- Verification commands
- Expected output

### Execution Format

```
## Executing Task N: [Task Name]

### Task Details
Files: src/path/file.py
Steps:
1. Write failing test
2. Run test (verify fails)
3. Write implementation
4. Run test (verify passes)
5. Commit

### Execution Log

[Task 1: Email validation]
✅ Step 1: Write failing test
   Created: tests/test_email.py
   Test: test_validates_email_format

✅ Step 2: Run test (verify fails)
   Run: pytest tests/test_email.py::test_validates_email_format -v
   Result: FAIL (Expected - NameError: validate_email not defined)

✅ Step 3: Write implementation
   Created: src/validators/email.py
   Function: validate_email(email: str) -> bool

✅ Step 4: Run test (verify passes)
   Run: pytest tests/test_email.py::test_validates_email_format -v
   Result: PASS ✅

✅ Step 5: Commit
   git add src/validators/email.py tests/test_email.py
   git commit -m "feat: add email validation"

Task 1: COMPLETE ✅
```

## Checkpoint Strategy

### When to Checkpoint

**After each batch:**
- Process 3-5 tasks
- Verify all completed
- Present progress summary
- Get confirmation to continue

### Checkpoint Format

```
## Batch N Complete: [Batch Name]

### Completed Tasks
✅ Task 1: [Name] ([time taken])
✅ Task 2: [Name] ([time taken])
✅ Task 3: [Name] ([time taken])

### Next Batch
⏳ Task 4: [Name]
⏳ Task 5: [Name]

### Verification
- [ ] All tests passing
- [ ] Code reviewed
- [ ] Commits complete

Continue with next batch?
```

## Progress Tracking

### Task Status

- `[ ]` - Not started
- `[⏳]` - In progress
- `[✅]` - Complete
- `[❌]` - Failed (needs fix)

### Progress Summary

```markdown
## Progress Summary

**Total Tasks:** 10
**Completed:** 6
**In Progress:** 1
**Remaining:** 3

**Completion Rate:** 60%

**Completed Tasks:**
1. ✅ Email validation (5 min)
2. ✅ Password validation (5 min)
3. ✅ Login endpoint (10 min)
4. ✅ Logout endpoint (7 min)
5. ✅ Session middleware (8 min)
6. ✅ Auth tests (12 min)

**In Progress:**
7. ⏳ Registration endpoint (started 5 min ago)

**Next Up:**
8. [ ] Registration tests
9. [ ] Integration tests
10. [ ] Documentation update
```

## Error Handling

### Task Failure

If a task fails:

```
## Task Failed: [Task Name]

❌ Error: [Error message]

### What went wrong:
- Test failed: [details]
- Implementation issue: [details]

### Options:
1. Fix the issue and retry task
2. Skip task and continue (mark for later)
3. Rollback previous changes

How would you like to proceed?
```

### Recovery Strategies

**Fix and Retry:**
- Identify the issue
- Fix implementation
- Re-run tests
- Continue execution

**Skip and Continue:**
- Mark task as deferred
- Continue with next batch
- Return to skipped task later

**Rollback:**
- Revert changes
- Start from checkpoint
- Re-execute affected tasks

## Parallel Session Support

### Opening New Session

When executing in parallel session:

```
Plan loaded: docs/plans/2026-01-27-auth-system.md

To execute this plan in a parallel session:

1. Open new terminal/session
2. Navigate to worktree: cd /path/to/worktree
3. Run: ralph run --preset executing-plans --plan docs/plans/2026-01-27-auth-system.md

This session will monitor progress and provide checkpoints.

Would you like to open parallel session now?
```

### Session Communication

Use checkpoints to sync between sessions:

```
## Session Sync Point

Main session: Batch 1 complete
Parallel session: Ready to start Batch 1

Coordination:
- Main session: Verifies batch completion
- Parallel session: Executes batch
- Both sessions: Review results together

Ready to proceed?
```

## Integration with Other Skills

### With Writing Plans

```
[Use writing-plans to create plan]
[Save to docs/plans/2026-01-27-feature.md]

[Use executing-plans to execute]
[Batch execution with checkpoints]
```

### With Using Git Worktrees

```
[Use using-git-worktrees to create workspace]
[Use writing-plans to create plan]
[Use executing-plans in worktree]
```

### With Ralph

Ralph can orchestrate plan execution:

```yaml
# Ralph blueprint
execution:
  skill: executing-plans
  plan: docs/plans/feature-plan.md
  batches: 3-5 tasks per batch
  checkpoints: after each batch
```

## Example Workflow

### Complete Implementation

```
You: I'm using the executing-plans skill to execute the auth implementation plan.

[Step 1: Load Plan]
cat docs/plans/2026-01-27-auth-system.md

[Step 2: Create Task List]
Created: 10 tasks, estimated 60 minutes

[Step 3: Execute Batch 1 (Tasks 1-3)]

## Executing Task 1: Email validation
✅ All steps complete
✅ Tests passing
✅ Committed

## Executing Task 2: Password validation
✅ All steps complete
✅ Tests passing
✅ Committed

## Executing Task 3: Login endpoint
✅ All steps complete
✅ Tests passing
✅ Committed

[Step 4: Checkpoint]

Batch 1 complete (3/10 tasks). Current status:

✅ Task 1: Email validation - DONE (5 min)
✅ Task 2: Password validation - DONE (5 min)
✅ Task 3: Login endpoint - DONE (10 min)

### Progress Summary
**Completed:** 3/10 (30%)
**Next Batch:** Tasks 4-6
- Task 4: Logout endpoint
- Task 5: Session middleware
- Task 6: Auth tests

Continue with batch 2?

User: Yes

[Continue with Batch 2...]
```

## Quality Checks

### After Each Batch

- [ ] All tasks in batch complete
- [ ] All tests passing
- [ ] Code reviewed
- [ ] Commits made
- [ ] Progress updated
- [ ] Checkpoint confirmed

### Final Verification

- [ ] All tasks complete
- [ ] All tests passing
- [ ] Integration tests passing
- [ ] Documentation updated
- [ ] No deferred tasks
- [ ] Clean git status

## Common Mistakes

### Too Many Tasks Per Batch

❌ **Bad:** 10-15 tasks per batch
✅ **Good:** 3-5 tasks per batch

**Why:** Checkpoints provide verification and allow course correction

### Skipping Checkpoints

❌ **Bad:** Execute all tasks without stopping
✅ **Good:** Checkpoint after each batch

**Why:** Human-in-loop catches issues early

### Poor Progress Tracking

❌ **Bad:** No task list, just execute
✅ **Good:** Structured task list with status

**Why:** Systematic tracking ensures nothing is missed

### No Error Recovery Plan

❌ **Bad:** Task fails, panic
✅ **Good:** Fix, skip, or rollback options

**Why:** Systematic error handling prevents failure cascades

## Key Principles

1. **Batch execution** - Process 3-5 tasks together
2. **Human checkpoints** - Verify after each batch
3. **Progress tracking** - Structured task list
4. **Error recovery** - Fix, skip, or rollback
5. **Quality verification** - Tests passing at checkpoints
6. **Systematic approach** - Same process every batch

Executing plans systematically ensures reliable completion of implementation plans with human verification at each stage.
