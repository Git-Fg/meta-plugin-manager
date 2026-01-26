# Command Development: Executable Examples

This file contains complete, working examples of commands with bash injection and file reference syntax. Study these to understand how the patterns work in practice.

---

## Bash Injection Examples

### Example 1: Review Changed Files

```markdown
---
description: Review changed files
allowed-tools: Bash, Read
---

Files changed: !`git diff --name-only HEAD`

Review each file for:
- Code quality and style
- Potential bugs or issues
- Test coverage
```

### Example 2: Run Tests with Coverage

```markdown
---
description: Run tests with coverage
allowed-tools: Bash(npm:*)
---

Test results: !`npm test -- --coverage --json`

Analyze coverage report and identify:
- Files below 80% coverage
- Uncovered critical paths
- Test gaps
```

### Example 3: Validate Arguments Before Deployment

```markdown
---
description: Deploy with validation
argument-hint: [environment]
allowed-tools: Bash(*)
---

Validate: !`echo "$1" | grep -E "^(dev|staging|prod)$" || echo "INVALID"`

If $1 is valid environment, deploy to $1.
Otherwise, explain valid environments.
```

---

## Combined Pattern Examples

### Example 4: Review Pattern (Bash + File References)

```markdown
---
description: Comprehensive code review
allowed-tools: Bash, Read
---

Changed files: !`git diff --name-only HEAD`

For each file, review @FILE for:
- Security issues
- Code quality
- Best practices
- Test coverage
```

### Example 5: Workflow Pattern (Multiple Bash Injections)

```markdown
---
description: Pre-commit validation
allowed-tools: Bash
---

Checks:
- Build: !`npm run build`
- Tests: !`npm test`
- Lint: !`npm run lint`

If all checks pass, approve commit.
Otherwise, report failures.
```

### Example 6: Template Pattern (File References Only)

```markdown
---
description: Generate report from template
argument-hint: [data-file]
---

Template: @templates/report-format.md

Data: @$1

Generate report following template structure.
```

---

## Dynamic Context Command Examples

### Example 7: Review Changed Files (Git + File References)

```markdown
---
description: Review changed files
allowed-tools: Bash, Read
---

Changed files: !`git diff --name-only HEAD`

Review each @FILE for:
- Security issues
- Code quality
- Best practices
```

### Example 8: Test Specific File

```markdown
---
description: Test specific file
argument-hint: [test-file]
allowed-tools: Bash(npm:*)
---

Run tests: !`npm test -- $1`

Analyze results and suggest fixes.
```

### Example 9: Generate Documentation for File

```markdown
---
description: Generate docs for file
argument-hint: [source-file]
---

Generate documentation for @$1 including:
- Function/class descriptions
- Parameter documentation
- Return values
- Usage examples
```

---

## Command Window Lifecycle Examples

### Example 10: Deployment Using AskUserQuestion (Window Stays Open)

```yaml
---
name: deploy
description: Deploy with safety gates
allowed-tools: Bash
---

# Pre-flight checks completed
All tests passing.

AskUserQuestion: Deploy to which environment?
1. staging
2. production

# ← User responds: "1"
# ← Still SAME command, Bash permission still active

# Command can now execute deployment:
Deploying to staging...
Running: !`kubectl apply -f manifests/`
Deployment successful!

# ← Command completes and returns result
# ← Permissions no longer apply
```

### Example 11: Natural Conversation (Window Closes)

```yaml
---
name: deploy
description: Deploy with safety gates
allowed-tools: Bash
---

# Pre-flight checks completed
All tests passing.

Which environment should I deploy to?
# ← Command finishes here

# User responds: "staging"
# ← NEW TURN, no active command, Bash permission DON'T apply

# Model decides what to do - may or may not re-invoke the command
```

---

## Anti-Pattern Examples

### Example 12: Bash Injection Without Permissions (BAD)

```yaml
---
description: Run tests
---

Test results: !`npm test`
```

**Why bad**: Command will fail because Claude doesn't have permission to run bash.

### Example 13: Bash Injection With Permissions (GOOD)

```yaml
---
description: Run tests
allowed-tools: Bash
---

Test results: !`npm test`
```

**Why good**: Always include `allowed-tools: Bash` when using bash injection syntax.

---

## Notes

- All examples in this file use real bash injection syntax for demonstration
- When using these patterns, ensure commands work in your environment first
- Test bash commands independently before embedding them in commands
- Handle errors explicitly with proper error handling patterns
- Remember: bash injection is preprocessing - commands run BEFORE Claude sees the prompt
