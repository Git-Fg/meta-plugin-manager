---
name: writing-plans
description: "Write implementation plans when planning multi-step tasks before coding or defining bite-sized steps. Not for execution."
---

# Writing Plans

<mission_control>
<objective>Create comprehensive implementation plans with complete context for zero-knowledge engineers</objective>
<success_criteria>Plan includes exact file paths, complete code, test commands, and can be executed by fresh Claude instance without questions</success_criteria>
</mission_control>

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

<interaction_schema>
thinking → dependency_analysis → task_breakdown → validation → output
</interaction_schema>

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by `using-git-worktrees` skill).

**Save plans to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`

---

## Thinking Protocol: Dependency Analysis First

<thinking_protocol>
<mandatory_trigger>
Before creating ANY implementation plan tasks
</mandatory_trigger>

<process>
1. **Open `<dependency_analysis>`** - Analyze what must exist before each task
2. **Identify constraints** - Tech stack, existing code, testing requirements
3. **Map dependencies** - Which tasks block others (minimize cross-task dependencies)
4. **Calculate complexity** - Ensure each task is 2-5 minutes
5. **Close `</dependency_analysis>`** - Hard stop before task generation
6. **Generate task list** - Only after analysis complete
</process>
</thinking_protocol>

### Dependency Analysis Template

```xml
<dependency_analysis>
<constraints>
- Tech stack: [Python/Node/Go/etc.]
- Existing patterns: [TDD, specific frameworks]
- File structure: [monorepo, specific conventions]
</constraints>

<dependency_map>
Task A (foundation)
├─ Task B (depends on A)
├─ Task C (depends on A)
└─ Task D (depends on B, C)
</dependency_map>

<complexity_check>
- Task A: ~3 minutes (single file)
- Task B: ~4 minutes (two files, test first)
- Task C: ~5 minutes (integration)
</complexity_check>

<minimization_strategy>
- Minimize cross-task dependencies
- Make tasks self-contained where possible
- Group related changes in single task
</minimization_strategy>
</dependency_analysis>
```

### Recognition Questions

Before starting tasks, verify:

- "Did I complete `<dependency_analysis>`?" → No, complete it first
- "Do I know the tech stack and constraints?" → No, investigate first
- "Can I explain the dependency tree?" → No, map it first
- "Are all tasks 2-5 minutes?" → No, split larger tasks

---

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**

- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use `executing-plans` to implement this plan task-by-task.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

```markdown
### Task N: [Component Name]

**Files:**

- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```
```

**Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

**Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

**Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

**Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```

```

## Plan Requirements

### Complete Information Per Task

**For each task, provide:**
- Exact file paths (no wildcards)
- Complete code (not "add validation")
- Exact commands with expected output
- Specific commit messages
- Verification steps

### Task Granularity

**Each task should be:**
- Single purpose (one component/feature)
- 2-5 minutes to complete
- Self-contained (doesn't depend on other tasks)
- Verifiable (can check if done)

**Good task:**
```

Task 3: Add email validation
Files: src/validators/email.py
Steps:

1. Write failing test
2. Implement minimal code
3. Run tests
4. Commit

```

**Bad task:**
```

Task 3: Add all validations
Files: src/validators/\*.py
Steps: Add all validations, test, commit

```

## Remember

- Exact file paths always
- Complete code in plan (not "add validation")
- Exact commands with expected output
- Reference relevant skills with @ syntax
- DRY, YAGNI, TDD, frequent commits

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan complete and saved to `docs/plans/<filename>.md`. Two execution options:**

**1. Subagent-Driven (this session)** - I dispatch fresh subagent per task, review between tasks, fast iteration

**2. Parallel Session (separate)** - Open new session with `executing-plans`, batch execution with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use `subagent-driven-development`
- Stay in this session
- Fresh subagent per task + code review

**If Parallel Session chosen:**
- Guide them to open new session in worktree
- **REQUIRED SUB-SKILL:** New session uses `executing-plans`

## Integration with Other Skills

### With Brainstorming

```

User: "I want to add user authentication"

[Use brainstorming skill to refine requirements]
[Get validated design]

[Use writing-plans to create implementation plan]
[Save to docs/plans/2026-01-27-auth-design.md]

```

### With Using Git Worktrees

```

[Use writing-plans to create plan]
[Use using-git-worktrees to create isolated workspace]
[Execute plan in worktree]

```

## Task Examples

### Example 1: Simple Feature

```markdown
### Task 1: Add retry decorator

**Files:**

- Create: `src/utils/retry.py`
- Modify: `tests/test_retry.py` (add test)
- Modify: `README.md` (update usage section)

**Step 1: Write failing test**

```python
@pytest.mark.asyncio
async def test_retry_decorator():
    call_count = 0

    @retry(max_attempts=3)
    async def failing_function():
        nonlocal call_count
        call_count += 1
        if call_count < 3:
            raise ValueError("fail")
        return "success"

    result = await failing_function()
    assert result == "success"
    assert call_count == 3
```
```

**Step 2: Run test to verify it fails**

Run: `pytest tests/test_retry.py::test_retry_decorator -v`
Expected: FAIL with "NameError: retry is not defined"

**Step 3: Write minimal implementation**

```python
def retry(max_attempts=3):
    def decorator(func):
        async def wrapper(*args, **kwargs):
            for attempt in range(max_attempts):
                try:
                    return await func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_attempts - 1:
                        raise
        return wrapper
    return decorator
```

**Step 4: Run test to verify it passes**

Run: `pytest tests/test_retry.py::test_retry_decorator -v`
Expected: PASS

**Step 5: Commit**

```bash
git add src/utils/retry.py tests/test_retry.py
git commit -m "feat: add retry decorator utility"
```

```

### Example 2: Integration Task

```markdown
### Task 3: Wire up auth middleware

**Files:**
- Modify: `src/middleware/auth.py` (add middleware logic)
- Modify: `tests/integration/test_auth_flow.py` (add integration test)
- Modify: `docs/middleware.md` (document middleware usage)

**Step 1: Write integration test**

```python
async def test_auth_middleware_redirects_unauthenticated():
    app = create_app()
    client = TestClient(app)

    response = await client.get("/protected")
    assert response.status_code == 302
    assert "/login" in response.headers["location"]
```

**Step 2: Run test to verify it fails**

Run: `pytest tests/integration/test_auth_flow.py::test_auth_middleware_redirects_unauthenticated -v`
Expected: FAIL (middleware not configured)

**Step 3: Add middleware to app**

```python
from .auth import auth_middleware

app = FastAPI()
app.middleware("http")(auth_middleware)
```

**Step 4: Run test to verify it passes**

Run: `pytest tests/integration/test_auth_flow.py::test_auth_middleware_redirects_unauthenticated -v`
Expected: PASS

**Step 5: Commit**

```bash
git add src/middleware/auth.py tests/integration/test_auth_flow.py
git commit -m "feat: add auth middleware to app"
```

```

## Quality Checklist

### Before Finalizing Plan

- [ ] Every task has exact file paths
- [ ] Every code example is complete
- [ ] Every command has expected output
- [ ] Tasks are 2-5 minutes each
- [ ] Tasks are self-contained
- [ ] Plan follows TDD (test first)
- [ ] Commit messages are descriptive
- [ ] Dependencies between tasks are minimal

### Verification Steps

For each task:
- [ ] Step 1: Test file creation/modification
- [ ] Step 2: Verify test fails as expected
- [ ] Step 3: Implementation provided
- [ ] Step 4: Verify test passes
- [ ] Step 5: Commit command with message

## Common Mistakes

### Too Vague

❌ **Bad:**
```

Task 1: Add auth
Steps: Add auth to app

```

✅ **Good:**
```

Task 1: Add email validation
Files: src/models/user.py:45-50
Steps: Add email validation, test, commit

```

### Missing Commands

❌ **Bad:**
```

Step 2: Run tests

```

✅ **Good:**
```

Step 2: Run test to verify it fails
Run: pytest tests/test_user.py::test_email_validation -v
Expected: FAIL with "ValidationError"

```

### Too Complex

❌ **Bad:**
```

Task 1: Build entire auth system
Steps: Add login, logout, registration, password reset, email verification, OAuth

```

✅ **Good:**
```

Task 1: Add email validation
Task 2: Add password validation
Task 3: Add login endpoint
Task 4: Add logout endpoint
Task 5: Add registration endpoint

```

## Red Flags

**Rationalizations to watch for:**
- "This task is complex but..." → Split into smaller tasks
- "I can skip the test for now" → Every task needs a test
- "The code is obvious" → Still provide complete code
- "I'll write detailed tests later" → Tests are part of the task
- "This should take longer than 5 minutes" → Split the task

## Key Principles

1. **Bite-sized tasks** - 2-5 minutes each
2. **Complete information** - Exact paths, complete code
3. **TDD approach** - Test first, then implementation
4. **Frequent commits** - Small, focused commits
5. **Verifiable steps** - Can check if task is done
6. **Self-contained** - Minimal dependencies between tasks
7. **DRY, YAGNI** - Don't repeat, don't add unnecessary
8. **Clear handoff** - Next steps clearly defined

Remember: The plan should be so complete that any developer (including a fresh Claude instance) can execute it successfully.

---

## Absolute Constraints (Non-Negotiable)

<critical_constraint>
**MANDATORY: Complete `<dependency_analysis>` BEFORE task generation**

- Analyze constraints, tech stack, dependencies first
- Map which tasks block others (minimize cross-task dependencies)
- Verify each task is 2-5 minutes before listing
- NEVER generate tasks without analysis phase

**MANDATORY: Complete information per task**

- Exact file paths (no wildcards like `*.py`)
- Complete code examples (not "add validation here")
- Exact commands with expected output
- Specific commit messages
- Verification steps for each task

**MANDATORY: TDD approach**

- Every task must have test first
- Test must fail before implementation
- Implementation must make test pass
- Verify test passes before commit

**No exceptions. No "looks complete" rationalization.**
</critical_constraint>
```
