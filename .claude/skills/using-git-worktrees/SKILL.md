---
name: using-git-worktrees
description: "Manage git worktrees when creating isolated workspaces for features or parallel plans. Not for simple branch switching or single-task sessions."
---

# Using Git Worktrees

## Overview

Git worktrees create isolated workspaces sharing the same repository, allowing work on multiple branches simultaneously without switching.

**Core principle:** Systematic directory selection + safety verification = reliable isolation.

**Announce at start:** "I'm using the using-git-worktrees skill to set up an isolated workspace."

## Directory Selection Process

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

**MUST verify directory is ignored before creating worktree:**

```bash
# Check if directory is ignored (respects local, global, and system gitignore)
git check-ignore -q .worktrees 2>/dev/null || git check-ignore -q worktrees 2>/dev/null
```

**If NOT ignored:**

Per the rule "Fix broken things immediately":

1. Add appropriate line to .gitignore
2. Commit the change
3. Proceed with worktree creation

**Why critical:** Prevents accidentally committing worktree contents to repository.

### For Global Directory (~/.config/superpowers/worktrees)

No .gitignore verification needed - outside project entirely.

## Creation Steps

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

## Quick Reference

| Situation                  | Action                     |
| -------------------------- | -------------------------- |
| `.worktrees/` exists       | Use it (verify ignored)    |
| `worktrees/` exists        | Use it (verify ignored)    |
| Both exist                 | Use `.worktrees/`          |
| Neither exists             | Check CLAUDE.md → Ask user |
| Directory not ignored      | Add to .gitignore + commit |
| Tests fail during baseline | Report failures + ask      |
| No package.json/Cargo.toml | Skip dependency install    |

## Common Mistakes

### Skipping ignore verification

- **Problem:** Worktree contents get tracked, pollute git status
- **Fix:** Always use `git check-ignore` before creating project-local worktree

### Assuming directory location

- **Problem:** Creates inconsistency, violates project conventions
- **Fix:** Follow priority: existing > CLAUDE.md > ask

### Proceeding with failing tests

- **Problem:** Can't distinguish new bugs from pre-existing issues
- **Fix:** Report failures, get explicit permission to proceed

### Hardcoding setup commands

- **Problem:** Breaks on projects using different tools
- **Fix:** Auto-detect from project files (package.json, etc.)

## Example Workflow

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

## Red Flags

**Never:**

- Create worktree without verifying it's ignored (project-local)
- Skip baseline test verification
- Proceed with failing tests without asking
- Assume directory location when ambiguous
- Skip CLAUDE.md check

**Always:**

- Follow directory priority: existing > CLAUDE.md > ask
- Verify directory is ignored for project-local
- Auto-detect and run project setup
- Verify clean test baseline

## Integration

**Called by:**

- **brainstorming** (Phase 4) - REQUIRED when design is approved and implementation follows
- Any skill needing isolated workspace

**Pairs with:**

- **finishing-a-development-branch** - REQUIRED for cleanup after work complete
- **engineering-lifecycle** or **subagent-driven-development** - Work happens in this worktree

## Directory Structure

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

## Safety Checklist

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

- [ ] Use `finishing-a-development-branch` for cleanup
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
5. **Proper cleanup** - Use finishing-a-development-branch when done

Using git worktrees provides isolation without context switching, making parallel feature development safe and efficient.

---

<critical_constraint>
MANDATORY: Verify worktree directory is ignored before creating (project-local)
MANDATORY: Run tests to establish clean baseline before starting work
MANDATORY: Never proceed with failing tests without explicit permission
MANDATORY: Auto-detect project type and run appropriate setup commands
No exceptions. Worktree isolation requires verification at each step.
</critical_constraint>
