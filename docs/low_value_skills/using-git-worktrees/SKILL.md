---
name: using-git-worktrees
description: "Manage git worktrees to create isolated workspaces for features or parallel plans. Use when creating isolated workspaces, working on multiple features, or avoiding branch switching. Includes worktree creation, isolation patterns, and cleanup protocols. Not for simple branch switching, single-task sessions, or when regular branches suffice."
keywords: git-worktrees, isolation, workspace, branch, cleanup
---

## Quick Start

**Safety check:** Verify no conflicts with existing worktrees

**Directory selection:** Check `.worktrees` or `worktrees`, or CLAUDE.md preference

**Create worktree:** `git worktree add <path> <branch>`

**Verify isolation:** Confirm workspace is isolated and ready

**Why:** Worktrees enable parallel development without branch switching—no context loss between tasks.

## Navigation

| If you need... | Read this section... |
| :------------- | :------------------- |
| Core concept | ## PATTERN: Overview |
| Workflow | ## PATTERN: Workflow |
| Directory selection | ## PATTERN: Directory Selection |
| Safety verification | ## PATTERN: Safety Verification |
| Examples | ## EDGE: Worked Examples |
| Common mistakes | ## ANTI-PATTERN: Common Mistakes |
| Self-check | ## Recognition Questions |

## PATTERN: Overview

<mission_control>
<objective>Manage git worktrees to create isolated workspaces for features or parallel plans without branch switching.</objective>
<success_criteria>Worktree created, isolated workspace established, safety verification passed</success_criteria>
</mission_control>

# Using Git Worktrees

## Overview

Git worktrees create isolated workspaces sharing the same repository, allowing work on multiple branches simultaneously without switching.

**Core principle:** Systematic directory selection + safety verification = reliable isolation.

**Announce at start:** "I'm using the using-git-worktrees skill to set up an isolated workspace."

---

## The Path to Successful Isolation

<mission_control>

Following a clear priority order for directory location eliminates ambiguity and ensures consistency across sessions. When directory selection is systematic, worktrees are predictably located and easily managed.

**Why this works:** A priority-based approach (existing → CLAUDE.md preference → ask) respects project conventions while providing fallback options. This prevents scattered worktree locations and makes cleanup straightforward.

### 2. Safety Verification Protects Repository Integrity

Verifying that project-local worktree directories are git-ignored prevents accidental commits of worktree contents to the repository. This check is a simple step that avoids complex cleanup later.

**Why this works:** Using `git check-ignore` before creation catches the problem before it exists. Fixing .gitignore immediately when the check fails maintains the principle of fixing broken things as soon as they're discovered.

### 3. Clean Baseline Enables Accurate Problem Diagnosis

Running tests immediately after worktree creation establishes a known-good state. When tests pass at the start, any failures during feature work are attributable to new code, not pre-existing issues.

**Why this works:** A passing test suite provides confidence that the workspace is functional. Reporting failures immediately gives the user an informed choice about proceeding versus investigating.

### 4. Auto-Detection Ensures Project Compatibility

Detecting project type from manifest files (package.json, Cargo.toml, etc.) and running appropriate setup commands ensures the worktree is ready for work regardless of technology stack.

**Why this works:** Auto-detection adapts to the project's actual tooling rather than assuming a specific ecosystem. This flexibility makes the skill work across Node, Rust, Python, Go, and other environments.

### 5. Proper Cleanup Maintains Workspace Hygiene

Using the cleanup checklist after work completion ensures proper merge, cleanup, and worktree removal when appropriate.

**Why this works:** Structured cleanup prevents abandoned worktrees from accumulating and keeps the workspace organized over time.

## PATTERN: Workflow

**Safety check:** Verify no conflicts with existing worktrees

**Directory selection:** Check `.worktrees` or `worktrees`, or CLAUDE.md preference

**Create worktree:** `git worktree add <path> <branch>`

**Verify isolation:** Confirm workspace is isolated and ready

**Why:** Worktrees enable parallel development without branch switching—no context loss between tasks.

## Navigation

| If you need...       | Read...                           |
| :------------------- | :-------------------------------- |
| Understand worktrees | ## PATTERN: Overview              |
| Safety check         | ## PATTERN: Safety Verification   |
| Directory selection  | ## PATTERN: Directory Selection   |
| Create worktree      | ## PATTERN: Creation Steps        |
| Verify isolation     | ## PATTERN: Workflow → Verify     |
| Cleanup protocol     | See cleanup patterns in body      |

## PATTERN: Directory Selection Process

Follow this priority order:

### 1. Check Existing Directories

```bash
# Check in priority order
ls -d .worktrees 2>/dev/null     # Preferred (hidden)
ls -d worktrees 2>/dev/null      # Alternative
```

**If found:** Use that directory. If both exist, `.worktrees` wins.

### 2. Check CLAUDE.md

```bash
grep -i "worktree.*director" CLAUDE.md 2>/dev/null
```

**If preference specified:** Use it without asking.

### 3. Ask User

If no directory exists and no CLAUDE.md preference:

```
No worktree directory found. Where should I create worktrees?

1. .worktrees/ (project-local, hidden)
2. ~/.config/superpowers/worktrees/<project-name>/ (global location)

Which would you prefer?
```

## Safety Verification

### For Project-Local Directories (.worktrees or worktrees)

Verifying directory is ignored before creating worktree prevents accidental commits of worktree contents to the repository.

```bash
# Check if directory is ignored (respects local, global, and system gitignore)
git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null
```

**If NOT ignored:** Following the principle of fixing broken things immediately, add the appropriate line to .gitignore, commit the change, then proceed with worktree creation.

**Why this matters:** A single ignored directory check prevents complex cleanup and repository pollution.

### For Global Directory (~/.config/superpowers/worktrees)

No .gitignore verification needed - the directory is outside the project entirely.

## PATTERN: Creation Steps

### 1. Detect Project Name

```bash
project=$(basename "$(git rev-parse --show-toplevel)")
```

### 2. Create Worktree

```bash
# Determine full path
case $LOCATION in
  .worktrees|worktrees)
    path="$LOCATION/$BRANCH_NAME"
    ;;
  ~/.config/superpowers/worktrees/*)
    path="~/.config/superpowers/worktrees/$project/$BRANCH_NAME"
    ;;
esac

# Create worktree with new branch
git worktree add "$path" -b "$BRANCH_NAME"
cd "$path"
```

### 3. Run Project Setup

Auto-detect and run appropriate setup:

```bash
# Node.js
if [ -f package.json ]; then npm install; fi

# Rust
if [ -f Cargo.toml ]; then cargo build; fi

# Python
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
if [ -f pyproject.toml ]; then poetry install; fi

# Go
if [ -f go.mod ]; then go mod download; fi
```

### 4. Verify Clean Baseline

Run tests to ensure worktree starts clean:

```bash
# Examples - use project-appropriate command
npm test
cargo test
pytest
go test ./...
```

**If tests fail:** Report failures, ask whether to proceed or investigate.

**If tests pass:** Report ready.

### 5. Report Location

```
Worktree ready at <full-path>
Tests passing (<N> tests, 0 failures)
Ready to implement <feature-name>
```

## PATTERN: Quick Reference

| Situation                  | Action                     |
| -------------------------- | -------------------------- |
| `.worktrees/` exists       | Use it (verify ignored)    |
| `worktrees/` exists        | Use it (verify ignored)    |
| Both exist                 | Use `.worktrees/`          |
| Neither exists             | Check CLAUDE.md → Ask user |
| Directory not ignored      | Add to .gitignore + commit |
| Tests fail during baseline | Report failures + ask      |
| No package.json/Cargo.toml | Skip dependency install    |

## EDGE: Worked Examples

```
You: I'm using the using-git-worktrees skill to set up an isolated workspace.

[Check .worktrees/ - exists]
[Verify ignored - git check-ignore confirms .worktrees/ is ignored]
[Create worktree: git worktree add .worktrees/auth -b feature/auth]
[Run npm install]
[Run npm test - 47 passing]

Worktree ready at /Users/project/.worktrees/auth
Tests passing (47 tests, 0 failures)
Ready to implement auth feature
```

## PATTERN: Red Flags

**Practices to avoid:**

- Creating worktree without verifying it's ignored (project-local)
- Skipping baseline test verification
- Proceeding with failing tests without asking
- Assuming directory location when ambiguous
- Skipping CLAUDE.md check

**Practices that lead to success:**

- Following directory priority: existing > CLAUDE.md > ask
- Verifying directory is ignored for project-local
- Auto-detecting and running project setup
- Verifying clean test baseline

## Integration

**Called by:**

- Design workflows when implementation follows approved design
- Any component needing isolated workspace for experimentation

**Pairs with:**

- Branch cleanup workflows after work complete
- Planning and execution workflows where work happens in isolated worktree

## PATTERN: Directory Structure

### Project-Local (.worktrees/)

```
project/
├── .worktrees/          # Worktree directory
│   ├── feature-auth/   # Individual worktree
│   ├── feature-api/    # Another worktree
│   └── bugfix-123/     # Another worktree
├── .git/               # Main repository
└── .gitignore          # Must ignore .worktrees/
```

### Global (~/.config/superpowers/worktrees/)

```
~/.config/superpowers/worktrees/
├── project-a/
│   ├── feature-auth/
│   └── bugfix-123/
└── project-b/
    ├── feature-api/
    └── refactor-core/
```

## PATTERN: Safety Checklist

### Before Creating Worktree

- [ ] Directory location determined (existing > CLAUDE.md > ask)
- [ ] For project-local: Verify ignored with git check-ignore
- [ ] If not ignored: Add to .gitignore and commit
- [ ] Branch name determined (feature/bugfix naming)

### After Creating Worktree

- [ ] Auto-detect project type (Node, Rust, Python, Go)
- [ ] Run appropriate setup (install, build, etc.)
- [ ] Run tests to verify clean baseline
- [ ] Report location and status

### After Work Complete

- [ ] Merge back to main or create PR
- [ ] Remove worktree if appropriate
- [ ] Report completion status

## Auto-Detection Logic

```bash
# Detect project type and run setup
if [ -f "package.json" ]; then
    echo "Detected Node.js project"
    npm install
elif [ -f "Cargo.toml" ]; then
    echo "Detected Rust project"
    cargo build
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    echo "Detected Python project"
    if [ -f "pyproject.toml" ]; then
        poetry install
    else
        pip install -r requirements.txt
    fi
elif [ -f "go.mod" ]; then
    echo "Detected Go project"
    go mod download
else
    echo "No recognized project type - skipping auto-setup"
fi
```

## Key Principles

1. **Systematic selection** - Follow directory priority rules
2. **Safety verification** - Always check gitignore for project-local
3. **Auto-detection** - Detect project type and run appropriate setup
4. **Clean baseline** - Verify tests pass before starting work
5. **Proper cleanup** - Follow cleanup checklist when done

Using git worktrees provides isolation without context switching, making parallel feature development safe and efficient.

---

## ANTI-PATTERN: Common Mistakes

### Mistake 1: Skipping Git Ignore Verification

❌ **Wrong:**
```bash
git worktree add .worktrees/auth -b feature/auth
# Later: git status shows untracked files in .worktrees/
```

✅ **Correct:**
```bash
git check-ignore -q .worktrees || git check-ignore -q worktrees
if [ $? -ne 0 ]; then
  echo ".worktrees" >> .gitignore
  git add .gitignore && git commit -m "Add .worktrees to gitignore"
fi
git worktree add .worktrees/auth -b feature/auth
```

### Mistake 2: Assuming Directory Location

❌ **Wrong:**
```bash
# Creates worktree in random location based on current directory
git worktree add ../some-path -b feature/auth
```

✅ **Correct:**
```bash
# Follow priority: existing > CLAUDE.md > ask
ls -d .worktrees 2>/dev/null && LOCATION=".worktrees"
ls -d worktrees 2>/dev/null && LOCATION="worktrees"
grep -i "worktree.*dir" CLAUDE.md && LOCATION=$(grep...)
# If neither: Ask user for location preference
```

### Mistake 3: Proceeding with Failing Tests

❌ **Wrong:**
```bash
npm test
# 3 failures detected
# "Tests have some issues but let's proceed anyway"
```

✅ **Correct:**
```bash
npm test
# 3 failures detected
echo "Tests are failing (3 failures). Do you want to proceed with feature work anyway, or investigate the failures first?"
# Wait for user confirmation before continuing
```

### Mistake 4: Hardcoding Setup Commands

❌ **Wrong:**
```bash
# Assuming npm project
npm install
npm test
# Fails on Rust project: no package.json
```

✅ **Correct:**
```bash
# Auto-detect project type
if [ -f package.json ]; then npm install && npm test;
elif [ -f Cargo.toml ]; then cargo build && cargo test;
elif [ -f pyproject.toml ]; then poetry install && pytest;
elif [ -f go.mod ]; then go mod download && go test ./...;
else echo "No recognized project type - skipping setup"; fi
```

### Mistake 5: Not Using Proper Cleanup

❌ **Wrong:**
```bash
# Feature complete
git checkout main
git merge feature/auth
# Worktree still exists, cluttering .worktrees/
```

✅ **Correct:**
```bash
# Feature complete - follow cleanup steps
git checkout main
git merge feature/auth
# Remove worktree when done
git worktree remove <path>
```

---

## Recognition Questions

| Question | Check |
| :--- | :--- |
| Directory selected systematically? | Existing > CLAUDE.md > ask |
| Safety verified? | Git-ignore checked for project-local |
| Worktree created correctly? | New branch with proper naming |
| Setup complete? | Auto-detected project type |
| Baseline verified? | Tests passing (or user acknowledged) |

---

## PATTERN: Best Practices Summary

✅ **DO:**
- Follow directory priority: existing > CLAUDE.md > ask user
- Always verify git-ignore for project-local directories
- Auto-detect project type and run appropriate setup
- Verify clean test baseline before starting work
- Report failures and get user acknowledgment before proceeding
- Remove worktrees when done (git worktree remove <path>)

❌ **DON'T:**
- Skip git check-ignore verification for project-local directories
- Hardcode setup commands (npm install, cargo build, etc.)
- Proceed with failing tests without user acknowledgment
- Create worktrees in inconsistent locations
- Skip CLAUDE.md preference check
- Forget to remove worktrees when done

---

<critical_constraint>
**Portability Invariant**: Zero external dependencies. Works standalone.
**Security Boundary**: Project-local worktree directories MUST be verified as git-ignored before creation.
**Verification Standard**: Clean test baseline required before starting work.
**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows
</critical_constraint>
