# Executable Command Examples

This reference contains complete, executable command examples using real syntax that will be executed when invoked.

---

## Trust Pattern Examples

### Declarative Command (Recommended)

```markdown
---
description: Analyze recent changes for security issues
---

Current changes: !`git diff --name-only`
Current branch: !`git branch --show-current`

Analyze the changes above for security vulnerabilities including SQL injection, XSS, and authentication issues.

Provide specific findings with file locations and severity ratings.
```

**Why this works:** Declares intent, lets AI determine investigation path.

### Prescriptive Command (Only for Destructive Operations)

```markdown
---
description: Deploy to production
allowed-tools: Bash(kubectl:*)
disable-model-invocation: true
---

Validate environment: !`kubectl config current-context`

If context is production:
Build: !`npm run build`
Deploy: !`kubectl apply -f k8s/production/`
Verify: !`kubectl rollout status deployment/app`
Otherwise:
Error: Not in production context
```

**Why this is needed:** Destructive operations require explicit sequences.

---

## Argument Examples

### $ARGUMENTS Pattern

```markdown
---
description: Fix issue by number
argument-hint: [issue-number]
---

Fix issue #$ARGUMENTS following our coding standards and best practices.
```

**Usage:** `/fix-issue 123` or `/fix-issue 456 --urgent`

### Positional Arguments ($1, $2, $3)

```markdown
---
description: Review PR with priority and assignee
argument-hint: [pr-number] [priority] [assignee]
---

Review pull request #$1 with priority level $2.
After review, assign to $3 for follow-up.
```

**Usage:** `/review-pr 123 high alice`

---

## File Reference Examples

### Single File Reference

```markdown
---
description: Review specific file
argument-hint: [file-path]
---

Review @$1 for code quality, best practices, and potential bugs.

Provide specific line numbers for any issues found.
```

**Usage:** `/review-file src/api/users.ts`

### Multiple File References

```markdown
---
description: Compare two versions
argument-hint: [old-file] [new-file]
---

Compare @src/$1.js with @src/$2.js.

Identify breaking changes, new features, and bug fixes.
```

**Usage:** `/compare old-version new-version`

### Static File References

```markdown
---
description: Validate package and tsconfig consistency
---

Review @package.json and @tsconfig.json for consistency.

Ensure TypeScript version matches, dependencies are aligned, and build configuration is correct.
```

**Usage:** `/validate-config`

---

## Context Gathering Examples

### Git Context Injection

```markdown
---
description: Analyze recent changes
---

Current changes: !`git diff --name-only`
Current branch: !`git branch --show-current`
Recent commits: !`git log -5 --oneline`

Analyze the context above for potential issues, bugs, or improvements.
```

**Effect:** Injects git state before AI reasoning begins.

### Environment Context

```markdown
---
description: Check deployment readiness
---

Current branch: !`git branch --show-current`
Uncommitted changes: !`git status --short`
Test status: !`npm test 2>&1 | tail -5`

Assess deployment readiness based on the context above.
```

---

## Plugin Command Examples

### Using CLAUDE_PLUGIN_ROOT

```markdown
---
description: Run plugin analysis script
argument-hint: [target]
allowed-tools: Bash(node:*)
---

Run analysis: !`node ${CLAUDE_PLUGIN_ROOT}/scripts/analyze.js $1`

Review results and report findings with specific recommendations.
```

### Plugin Configuration Loading

```markdown
---
description: Deploy using plugin config
argument-hint: [environment]
allowed-tools: Read
---

Load configuration: @${CLAUDE_PLUGIN_ROOT}/config/$1-deploy.json

Deploy to $1 using the loaded configuration settings.
Monitor deployment and report status.
```

### Plugin Template Usage

```markdown
---
description: Generate docs from template
argument-hint: [component]
---

Template: @${CLAUDE_PLUGIN_ROOT}/templates/docs.md

Generate documentation for $1 following the template structure above.
```

---

## Skill Orchestration Examples

### Pure Delegation (No Tools)

```markdown
---
description: Create new skill
argument-hint: [skill-name]
allowed-tools: []
---

Use the create-skill skill to create a new skill named $1.
```

### Context Gathering + Skill Invocation

```markdown
---
description: Analyze codebase then create skill
argument-hint: [skill-name]
allowed-tools: Read, Glob, Grep, Skill(create-skill)
---

Gather context about the current codebase structure using Read, Glob, and Grep.

Then use the create-skill skill to create a new skill named $1 based on the gathered context.
```

### Multi-Skill Orchestration

```markdown
---
description: Full skill audit and improvement
argument-hint: [skill-name]
allowed-tools: Read, Glob, Grep, Skill(quality-standards), Skill(invocable-development)
---

First, read the current state of $1 using Read and Glob.

Then invoke the quality-standards skill to audit the skill for quality and alignment.

Finally, invoke the invocable-development skill to implement improvements based on the audit.
```

---

## Advanced Patterns

### Conditional Context

```markdown
---
description: Smart deployment
argument-hint: [environment]
---

Current context: !`git log -1 --oneline`

Deploy to $1 environment.

If $1 appears to be production, verify readiness and ask for confirmation before proceeding.
```

### Multi-Phase Workflow

```markdown
---
description: Comprehensive code review
argument-hint: [file-path]
allowed-tools: Bash(node:*) Read
---

Target: @$1

Analysis results:
!`node ${CLAUDE_PLUGIN_ROOT}/scripts/lint.js $1`

Phase 1: Static analysis complete above

Phase 2: Perform deep review focusing on security, performance, and maintainability.

Phase 3: Generate actionable recommendations with priority levels.
```

---

## Best Practice Examples

### Adaptive Command (Trusts AI)

```markdown
---
description: Run appropriate test suite
---

Identify the testing framework used in this project.

Run the appropriate test command based on the framework detected.

Report results with specific failure details.
```

### Heuristic-Based Command

```markdown
---
description: Safe deployment
argument-hint: [environment]
---

Deploy to $1 environment.

Current context: !`git log -1 --oneline`

If $1 appears to be a production environment (contains prod, production, live):
Ask for explicit confirmation before proceeding.
Verify all checks pass.
Report deployment status clearly.
```

---

## Troubleshooting Commands

### Debug Command Execution

```markdown
---
description: Debug command execution
argument-hint: [command-name]
---

Show the content of .claude/commands/$1.md.

Verify the file exists and has valid markdown format.
```

### Test Command with Arguments

```markdown
---
description: Test argument parsing
argument-hint: [arg1] [arg2] [arg3]
---

Echo received arguments:

- First: $1
- Second: $2
- All: $ARGUMENTS
```

---

**Usage Note:** These examples contain executable syntax. Copy and adapt them to your specific needs. Always test commands in a safe environment before using in production.
