---
name: finishing-a-development-branch
description: "Finish development branches for merge or PR creation. Use when implementation is complete and tests pass. Not for in-progress work or failed tests."
---

# Finishing a Development Branch

## Overview

Guide completion of development work by presenting clear options and handling chosen workflow.

**Core principle:** Verify tests → Present options → Execute choice → Clean up.

**Announce at start:** "I'm using the finishing-a-development-branch skill to complete this work."

## The Process

### Step 1: Verify Tests

**Before presenting options, verify tests pass:**

```bash
# Run project's test suite
npm test / cargo test / pytest / go test ./...
```

**If tests fail:**

```
Tests failing (<N> failures). Must fix before completing:

[Show failures]

Cannot proceed with merge/PR until tests pass.
```

Stop. Don't proceed to Step 2.

**If tests pass:** Continue to Step 2.

### Step 2: Determine Base Branch

```bash
# Try common base branches
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

Or ask: "This branch split from main - is that correct?"

### Step 3: Present Options

Present actionable options for what to do with the completed branch.

### Step 4: Execute Choice

#### Option 1: Merge Locally

```bash
# Switch to base branch
git checkout <base-branch>

# Pull latest
git pull

# Merge feature branch
git merge <feature-branch>

# Verify tests on merged result
<test command>

# If tests pass
git branch -d <feature-branch>
```

Then: Cleanup worktree (Step 5)

#### Option 2: Push and Create PR

```bash
# Push branch
git push -u origin <feature-branch>

# Create PR
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
<2-3 bullets of what changed>

## Test Plan
- [ ] <verification steps>
EOF
)"
```

Then: Cleanup worktree (Step 5)

#### Option 3: Keep As-Is

Report: "Keeping branch <name>. Worktree preserved at <path>."

**Don't cleanup worktree.**

#### Option 4: Discard

**Confirm first:**

```
This will permanently delete:
- Branch <name>
- All commits: <commit-list>
- Worktree at <path>

Type 'discard' to confirm.
```

Wait for exact confirmation.

If confirmed:

```bash
git checkout <base-branch>
git branch -D <feature-branch>
```

Then: Cleanup worktree (Step 5)

### Step 5: Cleanup Worktree

**For Options 1, 2, 4:**

Check if in worktree:

```bash
git worktree list | grep $(git branch --show-current)
```

If yes:

```bash
git worktree remove <worktree-path>
```

**For Option 3:** Keep worktree.

## Quick Reference

| Option           | Merge | Push | Keep Worktree | Cleanup Branch |
| ---------------- | ----- | ---- | ------------- | -------------- |
| 1. Merge locally | ✓     | -    | -             | ✓              |
| 2. Create PR     | -     | ✓    | ✓             | -              |
| 3. Keep as-is    | -     | -    | ✓             | -              |
| 4. Discard       | -     | -    | -             | ✓ (force)      |

## Common Mistakes

**Skipping test verification**

- **Problem:** Merge broken code, create failing PR
- **Fix:** Always verify tests before offering options

**Open-ended questions**

- **Problem:** "What should I do next?" → ambiguous
- **Fix:** Present exactly 4 structured options

**Automatic worktree cleanup**

- **Problem:** Remove worktree when might need it (Option 2, 3)
- **Fix:** Only cleanup for Options 1 and 4

**No confirmation for discard**

- **Problem:** Accidentally delete work
- **Fix:** Require typed "discard" confirmation

## Red Flags

**Never:**

- Proceed with failing tests
- Merge without verifying tests on result
- Delete work without confirmation
- Force-push without explicit request

**Always:**

- Verify tests before offering options
- Present exactly 4 options
- Get typed confirmation for Option 4
- Clean up worktree for Options 1 & 4 only

## Integration

**Called by:**

- **subagent-driven-development** (Step 7) - After all tasks complete
- **executing-plans** (Step 5) - After all batches complete

**Pairs with:**

- **using-git-worktrees** - Cleans up worktree created by that skill

## Example Workflow

### Successful Completion

```
You: I'm using the finishing-a-development-branch skill to complete this work.

[Step 1: Verify tests]
Run: npm test
Result: 45/45 tests passing

[Step 2: Determine base branch]
git merge-base HEAD main
Result: main

[Step 3: Present options]

Present actionable options for branch disposition. User selects option.

User: 2

[Step 4: Execute Choice - Option 2]
git push -u origin feature/auth
gh pr create --title "feat: add OAuth authentication" --body "..."

PR created: https://github.com/project/pull/123

[Step 5: Cleanup worktree]
Keeping worktree for PR review
Worktree preserved at /project/.worktrees/feature/auth
```

### Failed Tests

```
You: I'm using the finishing-a-development-branch skill to complete this work.

[Step 1: Verify tests]
Run: npm test
Result: FAIL

Tests failing (3 failures). Must fix before completing:

FAIL tests/test_auth.js
  × should authenticate user (500ms)
  × should handle invalid credentials (200ms)
  × should redirect after login (300ms)

Cannot proceed with merge/PR until tests pass.
```

### Discard Confirmation

```
User: 4

[Step 4: Execute Choice - Option 4]

This will permanently delete:
- Branch feature/auth
- All commits: a1b2c3, d4e5f6, g7h8i9
- Worktree at /project/.worktrees/feature/auth

Type 'discard' to confirm.

User: discard

[Confirms]
git checkout main
git branch -D feature/auth

[Step 5: Cleanup worktree]
git worktree remove /project/.worktrees/feature/auth

Branch feature/auth deleted.
Worktree cleaned up.
```

## Key Principles

1. **Verify first** - Tests must pass before options
2. **Structured choice** - Exactly 4 options, no ambiguity
3. **Safety checks** - Confirm destructive operations
4. **Proper cleanup** - Handle worktrees appropriately
5. **Evidence-based** - Show test results before decisions

This skill ensures development work is completed safely and systematically.

---

<critical_constraint>
MANDATORY: Verify tests pass before presenting completion options
MANDATORY: Get typed confirmation for destructive operations (discard)
MANDATORY: Only cleanup worktrees for merge/discard options
MANDATORY: Show test evidence before user decisions
No exceptions. Never proceed with merge/PR when tests fail.
</critical_constraint>
