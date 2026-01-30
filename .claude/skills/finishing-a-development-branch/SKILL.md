---
name: finishing-a-development-branch
description: "Finish development branches for merge or PR creation. Use when implementation is complete, tests pass, and branch cleanup is needed. Includes merge strategy determination, PR creation, worktree cleanup, and branch archival. Not for in-progress work, failed tests, or partial implementations."
---

<mission_control>
<objective>Complete development branches through verification, target determination, option presentation, execution, and cleanup.</objective>
<success_criteria>Branch finished with merge/PR created or archived, worktree cleaned up</success_criteria>
</mission_control>

## The Path to Clean Branch Completion

### 1. Verify Before Deciding

Test verification before presenting options prevents broken merges and failed PRs. When all tests pass, you know the code is ready for merge or review.

**Why this matters**: Merging failing code wastes reviewer time and creates revert situations. Test evidence builds confidence in completion decisions.

### 2. Structure Choices for Recognition

Present exactly 4 actionable options (merge locally, create PR, keep as-is, discard). Recognition-based selection is faster than open-ended questions.

**Why this matters**: Structured options reduce cognitive load. Users recognize their intent instead of generating free-form text.

### 3. Protect Against Data Loss

Require typed confirmation for destructive operations (discard option). Explicit confirmation prevents accidental deletion of work.

**Why this matters**: Recovery from accidental deletion is difficult. Confirmation adds safety without significant friction.

### 4. Clean Up Appropriately

Handle worktrees based on user choice—cleanup after merge/discard, preserve after PR/keep. Matching cleanup to decision maintains needed context.

**Why this matters**: Preserved worktrees enable continued work (PR review, in-progress branches). Cleanup after completion reduces repository clutter.

### 5. Show Evidence Before Decisions

Display test results and branch status before presenting options. Evidence enables informed decisions.

**Why this matters**: Users make better choices when they see the actual state. Transparency builds trust in completion process.

## Workflow

**Verify:** Run tests, ensure all pass

**Determine target:** Find base branch for merge

**Present options:** Show merge, PR, or archive choices

**Execute:** Create merge commit, PR, or archive branch

**Cleanup:** Remove worktree, clean up artifacts

**Why:** Structured completion prevents forgotten steps—clean branches reduce cognitive load.

## Navigation

| If you need...             | Read...                        |
| :------------------------- | :----------------------------- |
| Verify completion          | ## Workflow → Verify           |
| Determine merge target     | ## Workflow → Determine target |
| Present completion options | ## Workflow → Present options  |
| Execute merge/PR/archive   | ## Workflow → Execute          |
| Cleanup worktree           | ## Workflow → Cleanup          |
| Workflow decision tree     | ## Workflow Decision Tree      |

## Operational Patterns

This skill follows these behavioral patterns:

- **Tracking**: Maintain a visible task list for branch completion
- **Execution**: Execute system commands for git operations
- **Verification**: Verify tests pass before completion

Trust native tools to fulfill these patterns.

## Workflow Decision Tree

### What Stage?

| If you need to...                             | Read this section        |
| --------------------------------------------- | ------------------------ |
| **Verify completion** → Check tests pass      | Step 1: Verify Tests     |
| **Determine target** → Find base branch       | Step 2: Determine Base   |
| **Present options** → Show completion choices | Step 3: Present Options  |
| **Execute choice** → Merge, PR, or discard    | Step 4: Execute Choice   |
| **Cleanup** → Remove worktree                 | Step 5: Cleanup Worktree |

## Implementation Patterns

### Pattern 1: Test Verification

```bash
# Run project's test suite
npm test / cargo test / pytest / go test ./...

# Check results
if [ $? -eq 0 ]; then
  echo "All tests passing"
else
  echo "Tests failing - cannot proceed"
fi
```

### Pattern 2: Base Branch Detection

```bash
# Try common base branches
git merge-base HEAD main 2>/dev/null || \
git merge-base HEAD master 2>/dev/null || \
echo "Could not determine base branch"
```

### Pattern 3: Merge Workflow

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

### Pattern 4: PR Creation

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

## Troubleshooting

### Issue: Tests Failing

| Symptom                            | Solution                           |
| ---------------------------------- | ---------------------------------- |
| Tests fail during verification     | STOP - Cannot proceed until fixed  |
| Flaky tests passing inconsistently | Investigate test reliability first |

### Issue: Open-Ended Questions

| Symptom                  | Solution                             |
| ------------------------ | ------------------------------------ |
| "What should I do next?" | Present exactly 4 structured options |
| User confused by choices | Reiterate options with tradeoffs     |

### Issue: Accidental Worktree Removal

| Symptom                      | Solution                       |
| ---------------------------- | ------------------------------ |
| Removed worktree when needed | Only cleanup for Options 1 & 4 |
| Lost in-progress work        | Check Option 3 keeps worktree  |

### Issue: Discard Without Confirmation

| Symptom                      | Solution                             |
| ---------------------------- | ------------------------------------ |
| Accidentally deleted work    | Require typed "discard" confirmation |
| Force delete without warning | Get explicit approval first          |

### Issue: Merge Conflicts

| Symptom                      | Solution                   |
| ---------------------------- | -------------------------- |
| Merge fails due to conflicts | Resolve before completing  |
| Base branch diverged         | Rebase or merge base first |

## Workflows

### Before Commit

1. **Run tests** → Verify all tests pass
2. **Run linting** → Check code quality
3. **Review changes** → git diff --stat

### Before Merge

1. **Squash commits** → Consolidate history
2. **Update branch** → git merge main
3. **Verify CI passes** → Check external tests

### Completion Workflow

```
Step 1: Verify Tests → All tests passing?
Step 2: Determine Base → Find split point
Step 3: Present Options → 4 structured choices
Step 4: Execute Choice → Merge/PR/Keep/Discard
Step 5: Cleanup → Handle worktree appropriately
```

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

## Common Mistakes to Avoid

### Mistake 1: Skipping Test Verification

❌ **Wrong:**
Present options without verifying tests

✅ **Correct:**
Always run tests first, present options only if all pass

### Mistake 2: Open-Ended Questions

❌ **Wrong:**
"What should I do next?" → User confused, ambiguous

✅ **Correct:**
Present exactly 4 structured options (merge, PR, keep, discard)

### Mistake 3: Automatic Worktree Cleanup

❌ **Wrong:**
Clean up worktree for all options → Remove when user might need it (PR review)

✅ **Correct:**
Only cleanup worktree for Options 1 and 4; preserve for Option 2 and 3

### Mistake 4: No Confirmation for Discard

❌ **Wrong:**
Delete branch without confirmation → Accidental work loss

✅ **Correct:**
Require typed "discard" confirmation before destructive operation

---

## Validation Checklist

Before claiming branch completion:

**Verification:**
- [ ] Tests pass (npm test / cargo test / etc.)
- [ ] Linting passes
- [ ] No merge conflicts with base branch

**Target:**
- [ ] Base branch identified correctly
- [ ] User confirmed merge target

**Options Presented:**
- [ ] Exactly 4 structured options presented
- [ ] Tradeoffs explained for each option
- [ ] User made explicit selection

**Execution:**
- [ ] Selected option executed correctly
- [ ] Merge/PR created successfully (if applicable)
- [ ] Confirmation obtained for destructive operations

**Cleanup:**
- [ ] Worktree handled according to option choice
- [ ] Branch deleted (if merge/discard selected)
- [ ] Repository state clean

---

## Best Practices Summary

✅ **DO:**
- Verify tests pass before presenting options
- Present exactly 4 structured options (recognition-based)
- Show evidence (test results, branch status) before decisions
- Require typed confirmation for discard (Option 4)
- Clean up worktree only for Options 1 and 4
- Preserve worktree for Options 2 (PR review) and 3 (keep)

❌ **DON'T:**
- Proceed with failing tests
- Ask open-ended questions ("What should I do?")
- Skip confirmation for destructive operations
- Clean up worktree when user might need it
- Delete branches without explicit confirmation
- Skip showing evidence before presenting options

---

## Red Flags

**Avoid:**

- Proceeding with failing tests
- Merging without verifying tests on result
- Deleting work without confirmation
- Force-pushing without explicit request

**Recommended:**

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
**Portability Invariant**: This skill must work in a project containing ZERO config files. No external dependencies.

**Safety Boundaries**: Require typed confirmation for destructive operations (discard option). Never bypass confirmation.
</critical_constraint>

---

## Genetic Code

This component carries essential Seed System principles for context: fork isolation:

**Self-Containment**: All components MUST be self-contained (zero .claude/rules dependency)

**Autonomy Target**: Achieve 80-95% autonomy (0-5 AskUserQuestion rounds per session)

**Frontmatter Format**: Description MUST use What-When-Not-Includes format in third person

**Progressive Disclosure**: references/ for detailed content, SKILL.md for core workflows

**UHP Structure**: Use XML for control (mission_control, critical_constraint), Markdown for data

**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows

**Recognition Questions**:

- "Would Claude know this without being told?" → Delete (zero delta)
- "Can this work standalone?" → Fix if no (non-self-sufficient)
- "Did I read the actual file, or just see it in grep?" → Verify before claiming

---
