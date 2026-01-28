---
name: executing-plans
description: "Execute implementation plans. Use when: Running a plan with multiple independent tasks, needing checkpoints and progress tracking. Not for: Ad-hoc execution or linearly dependent tasks without checkpoints."
---

# Executing Plans

<mission_control>
<objective>Execute implementation plans with batch-level state tracking and human-in-loop checkpoints</objective>
<success_criteria>All tasks completed systematically with verification at each batch boundary</success_criteria>
</mission_control>

## Overview

Execute comprehensive implementation plans by dispatching batches of tasks with human-in-loop checkpoints. Designed for independent tasks that can be verified and tracked systematically.

**Core principle:** Batch execution with checkpoints + systematic tracking = reliable plan completion.

**Announce at start:** "I'm using the executing-plans skill to execute the implementation plan."

## Checkpoint Protocol

**Key insight:** Checkpoints are BATCHED at end of execution, not after each batch.

| Plan Type                 | Execution Path                                                     |
| ------------------------- | ------------------------------------------------------------------ |
| `type="auto"` only        | **AUTONOMOUS** → subagent execution, NO checkpoints                |
| Has `type="checkpoint:*"` | **INTERACTIVE** → execute all auto tasks, batch checkpoints at end |

### Autonomous Path (Auto-Only Plans)

If plan has NO checkpoints (`type="checkpoint:*"`):

1. Load PLAN.md
2. Detect: all tasks are `type="auto"`
3. Execute via subagent with fresh context (no degradation)
4. Create SUMMARY.md
5. CONFIRM: "Plan complete. Invoke next plan?"

### Interactive Path (Plans with Checkpoints)

If plan HAS checkpoints:

1. Load PLAN.md
2. Detect checkpoint tasks
3. Execute ALL `type="auto"` tasks first (no interruption)
4. At first checkpoint → STOP
5. Present ALL checkpoints at once (batched)
6. User confirms all checkpoints
7. Resume execution
8. At next checkpoint → STOP → Present ALL remaining checkpoints
9. Repeat until complete

<interaction_schema>
load_plan → detect_checkpoints → [autonomous | execute_auto_then_stop] → batch_checkpoints → user_confirm → resume → repeat
</interaction_schema>

---

## State Management

<critical_constraint>
**MANDATORY: Maintain state in XML containers throughout execution.**

State containers prevent "hallucinated completion" where the model loses track of what's done.
</critical_constraint>

### State Containers

<batch_status>
<purpose>Maintain batch-level state across long-running execution</purpose>

<current_batch>
<batch_id>1</batch_id>
<task_range>1-3</task_range>
<status>in_progress | complete | failed</status>
<started_at>timestamp</started_at>
</current_batch>

<completed_batches>
<batch id="0">
<task_range>N/A</task_range>
<status>complete</status>
<completed_at>timestamp</completed_at>
</batch>
</completed_batches>
</batch_status>

<task_queue>
<priority>sequential</priority>

<task id="1">
<name>Add email validation</name>
<status>pending | in_progress | complete | failed</status>
<file_path>src/validators/email.py</file_path>
<estimated_minutes>5</estimated_minutes>
<dependencies>none</dependencies>
</task>

<task id="2">
<name>Add password validation</name>
<status>pending</status>
<file_path>src/validators/password.py</file_path>
<estimated_minutes>5</estimated_minutes>
<dependencies>none</dependencies>
</task>
</task_queue>

### State Update Protocol

<batching_logic>
<rules>

1. **Before execution**: Update task status to `in_progress`
2. **After completion**: Update task status to `complete`
3. **After batch**: Move batch to `completed_batches`
4. **On failure**: Update task status to `failed`, log error
5. **Never assume**: Always check state container, don't rely on memory
   </rules>

<dependency_check>
Before adding task to batch:

- Check `<dependencies>` field
- Verify all dependencies have status `complete`
- If not ready, defer to next batch
  </dependency_check>
  </batching_logic>

### State Container Examples

**Initial State:**

```xml
<batch_status>
<current_batch>
<batch_id>1</batch_id>
<status>not_started</status>
</current_batch>
<completed_batches></completed_batches>
</batch_status>

<task_queue>
<task id="1"><status>pending</status>...</task>
<task id="2"><status>pending</status>...</task>
<task id="3"><status>pending</status>...</task>
</task_queue>
```

**During Execution:**

```xml
<batch_status>
<current_batch>
<batch_id>1</batch_id>
<status>in_progress</status>
<started_at>2026-01-27T10:00:00Z</started_at>
</current_batch>
</batch_status>

<task_queue>
<task id="1"><status>complete</status>...</task>
<task id="2"><status>in_progress</status>...</task>
<task id="3"><status>pending</status>...</task>
</task_queue>
```

**After Batch Complete:**

```xml
<batch_status>
<current_batch>
<batch_id>2</batch_id>
<status>not_started</status>
</current_batch>
<completed_batches>
<batch id="1">
<status>complete</status>
<completed_at>2026-01-27T10:15:00Z</completed_at>
</batch>
</completed_batches>
</batch_status>
```

---

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

**For autonomous plans (no checkpoints):**

- NO checkpoints - execute via subagent with fresh context
- Create SUMMARY.md on completion

**For interactive plans (has checkpoints):**

- Execute ALL `type="auto"` tasks first (no interruption)
- At first `checkpoint:*` task → STOP execution
- Present ALL checkpoints at once (batched)
- After user confirmation → resume
- At next checkpoint → STOP → Present ALL remaining checkpoints
- Repeat until all checkpoints verified

### Batched Checkpoint Format

```
## Checkpoint Verification Required

I've completed all automated tasks. Please verify:

### Completed Work
✅ Task 1: [Name] - [what was done]
✅ Task 2: [Name] - [what was done]
✅ Task 3: [Name] - [what was done]

### Checkpoints to Verify
1. **[checkpoint:human-verify:UI]**: Review the new dashboard layout
   - Visual check: layout matches design
   - Interactive: hover states, transitions work

2. **[checkpoint:decision:Auth]**: Confirm auth provider selection
   - Options: Firebase Auth / Auth0 / Custom JWT
   - Recommendation: Firebase Auth (simplest for MVP)

Select:
1. All checkpoints verified - continue
2. Adjust checkpoint 1 (UI)
3. Adjust checkpoint 2 (Auth)
4. Need to see more context first
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

**In Progress:** 7. ⏳ Registration endpoint (started 5 min ago)

**Next Up:** 8. [ ] Registration tests 9. [ ] Integration tests 10. [ ] Documentation update
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
3. Run: executing-plans with plan path

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

## Example Workflow

### Complete Implementation

```
You: I'm using the executing-plans skill to execute the auth implementation plan.

[Step 1: Load Plan]
cat docs/plans/2026-01-27-auth-system.md

[Step 2: Detect Checkpoint Type]
Scanning PLAN.md for checkpoint tasks...

Found:
- Tasks 1-3: type="auto" (no checkpoints)
- Task 4: type="checkpoint:human-verify" (requires verification)
- Task 5: type="checkpoint:decision" (requires choice)

**Path: INTERACTIVE** (has checkpoints)

[Step 3: Execute Auto Tasks]
Executing all type="auto" tasks first (no interruption)...

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

[Step 4: BATCH Checkpoints]
STOP at first checkpoint. Present ALL checkpoints at once:

## Checkpoint Verification Required

I've completed all automated tasks. Please verify:

### Completed Work
✅ Task 1: Email validation - DONE (5 min)
✅ Task 2: Password validation - DONE (5 min)
✅ Task 3: Login endpoint - DONE (10 min)

### Checkpoints to Verify
1. **checkpoint:human-verify**: Review login UI
   - Visual check: form matches design
   - Interactive: validation messages work

2. **checkpoint:decision**: Confirm session duration
   - Options: 1 hour / 24 hours / 7 days
   - Recommendation: 24 hours for balance of security UX

Select:
1. All checkpoints verified - continue
2. Adjust checkpoint 1 (UI)
3. Adjust checkpoint 2 (Session)
4. Need more context

User: 1 (All verified)

[Step 5: Resume and Continue]
Resuming execution...
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

---

## Absolute Constraints (Non-Negotiable)

<critical_constraint>
**MANDATORY: Detect plan type first**

- Scan PLAN.md for `type="checkpoint:*"` before execution
- If NO checkpoints → use AUTONOMOUS path (subagent execution)
- If checkpoints exist → use INTERACTIVE path (batched checkpoints)

**MANDATORY: Maintain state in XML containers throughout execution**

- Initialize `<batch_status>` and `<task_queue>` before execution
- Update task status: `pending` → `in_progress` → `complete` / `failed`
- Check dependencies before adding tasks to batch
- Never rely on memory - always verify state container

**MANDATORY: BATCH checkpoints, don't scatter**

- Execute ALL `type="auto"` tasks before first checkpoint
- At first checkpoint → STOP execution entirely
- Present ALL checkpoints at once (never one at a time)
- After user confirmation → resume
- At next checkpoint → STOP → Present ALL remaining checkpoints

**MANDATORY: Verify state before claiming completion**

- Read `<task_queue>` to verify all tasks status `complete`
- Verify `<batch_status>` shows final batch complete
- Run verification commands (tests, git status)
- Never assume completion without evidence

**MANDATORY: Handle failures with state preservation**

- On task failure: update status to `failed`, log error
- Offer fix/skip/rollback options
- Preserve state across error recovery
- Never lose track of what was done

**No exceptions. State containers are your source of truth, not memory.**
</critical_constraint>
