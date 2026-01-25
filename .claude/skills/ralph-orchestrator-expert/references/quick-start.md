# Quick Start Guide

This guide covers the 5 most common Ralph workflows with step-by-step instructions. Read this first if you're new to Ralph.

---

## 1. Building a New Feature

**Use when**: You need to add new functionality to your codebase

### Step-by-Step

```bash
# 1. Navigate to your project
cd /path/to/your/project

# 2. List available presets
ralph init --list-presets

# 3. Initialize with feature preset
ralph init --preset feature

# 4. Review the configuration
cat ralph.yml

# 5. Customize if needed (optional)
# Edit ralph.yml to match your project conventions

# 6. Run Ralph
ralph run

# Or with UI monitoring
ralph run --tui
```

### What Happens

1. **Planner Hat**: Analyzes the task and creates a plan
2. **Builder Hat**: Implements one task at a time
3. **Reviewer Hat**: Reviews implementation for quality
4. **Cycle repeats** until all tasks complete

### Customization

For simple features without ceremony:
```bash
ralph init --preset feature-minimal
```

For test-driven development:
```bash
ralph init --preset tdd-red-green
```

### Expected Output

```bash
✅ Ralph initialized with 'feature' preset
🔄 Starting iteration 1...
📋 Planner created 5 tasks
🔨 Builder implementing task 1...
✅ Task 1 complete
🔍 Reviewer approved changes
🔄 Starting iteration 2...
```

---

## 2. Debugging a Bug

**Use when**: You have a bug to investigate and fix

### Step-by-Step

```bash
# 1. Navigate to project
cd /path/to/project

# 2. Initialize with debug preset
ralph init --preset debug

# 3. Create a PROMPT.md describing the bug
cat > PROMPT.md << 'EOF'
# Debug Memory Leak

## Problem
Application crashes when processing files >100MB

## Symptoms
- Memory usage grows unbounded
- OOM killer terminates process
- Affects 30% of large files

## Investigation
1. Reproduce with test file
2. Profile memory usage
3. Identify leaking function
4. Implement fix
5. Verify solution

Success: Memory usage stable, no crashes
EOF

# 4. Run with verbose output
ralph run --verbose

# 5. Monitor progress
ralph run --tui
```

### What Happens

1. **Observer Hat**: Reproduces and documents the bug
2. **Theorist Hat**: Forms hypothesis about root cause
3. **Experimenter Hat**: Tests hypothesis
4. **Fixer Hat**: Implements and verifies fix

### Alternative Debug Presets

For production incidents:
```bash
ralph init --preset incident-response
```

For hypothesis-driven debugging:
```bash
ralph init --preset scientific-method
```

### Expected Output

```bash
🔬 Observer: Bug reproduced with 200MB file
🧠 Theorist: Hypothesis - file buffer not released
🧪 Experimenter: Hypothesis confirmed - buffer leak in line 145
🔧 Fixer: Fix implemented and tested
✅ Memory stable at 45MB for 500MB file
```

---

## 3. Code Review

**Use when**: You need to review code for quality, security, or correctness

### Step-by-Step

```bash
# 1. Navigate to project
cd /path/to/project

# 2. Initialize with review preset
ralph init --preset review

# 3. Create PROMPT.md with review scope
cat > PROMPT.md << 'EOF'
# Review Payment Processing Changes

## Context
Review PR #123 that adds Stripe payment integration

## Files
- src/payments/stripe.py
- src/payments/models.py
- tests/payments/

## Review Focus
1. Security vulnerabilities
2. Performance issues
3. Code correctness
4. Test coverage
5. Code style

## Deliverable
Detailed review report with actionable feedback
EOF

# 4. Run review
ralph run

# 5. Review findings
cat REVIEW.md  # Ralph creates this
```

### Review Variations

For security-focused review:
```bash
ralph init --preset adversarial-review
```

For multi-reviewer PR:
```bash
ralph init --preset pr-review
```

For gap analysis:
```bash
ralph init --preset gap-analysis
```

### Expected Output

```bash
🔍 Reviewer: Analyzing payment processing code...
⚠️  Found: SQL injection risk in line 42
⚠️  Found: Missing input validation in stripe.py:67
✅ No performance issues found
✅ Good test coverage (85%)
📝 Review report generated: REVIEW.md
```

---

## 4. Understanding Legacy Code

**Use when**: You need to understand an unfamiliar or legacy codebase

### Step-by-Step

```bash
# 1. Navigate to project
cd /path/to/legacy-project

# 2. Initialize with code archaeology preset
ralph init --preset code-archaeology

# 3. Create PROMPT.md
cat > PROMPT.md << 'EOF'
# Understand User Authentication System

## Goal
Document how the user auth system works before making changes

## Focus Areas
- Login flow
- Password storage
- Session management
- Security measures

## Deliverable
Architecture documentation in ANALYSIS.md
EOF

# 4. Run archaeology
ralph run

# 5. Review findings
cat ANALYSIS.md
```

### Learning Variations

For research and exploration:
```bash
ralph init --preset research
```

For guided learning:
```bash
ralph init --preset socratic-learning
```

For documentation generation:
```bash
ralph init --preset docs
```

### Expected Output

```bash
🗺️ Surveyor: Mapping authentication code structure...
📜 Historian: Researching git history and decisions...
⛏️ Archaeologist: Identifying patterns and gotchas...
📝 ANALYSIS.md created with full documentation
🔍 12 hidden assumptions documented
⚠️  3 security risks identified
```

---

## 5. Refactoring Code

**Use when**: You need to improve code quality, performance, or maintainability

### Step-by-Step

```bash
# 1. Navigate to project
cd /path/to/project

# 2. Initialize with refactor preset
ralph init --preset refactor

# 3. Create PROMPT.md
cat > PROMPT.md << 'EOF'
# Refactor User Model

## Target
src/models/user.py

## Goals
1. Improve code readability
2. Reduce complexity (cyclomatic < 10)
3. Add type hints
4. Maintain backward compatibility

## Constraints
- Don't change public API
- Keep all tests passing
- One commit per improvement

## Success
- All tests pass
- Code quality metrics improved
- Documentation updated
EOF

# 4. Run refactoring
ralph run --tui
```

### Refactoring Variations

For performance optimization:
```bash
ralph init --preset performance-optimization
```

For API design improvements:
```bash
ralph init --preset api-design
```

For database migrations:
```bash
ralph init --preset migration-safety
```

### Expected Output

```bash
🔍 Analyzing user model...
📊 Current complexity: 15 (target: <10)
🔨 Refactoring: Extracted helper methods
📊 New complexity: 8 ✅
🔨 Refactoring: Added type hints
✅ All tests passing
📝 Documentation updated
```

---

## Common Workflow Patterns

### Pattern 1: Investigation → Selection → Execution

```bash
# Step 1: Investigation
ralph init --preset research
# Analyze codebase to understand needs

# Step 2: Select appropriate preset
# Based on investigation findings

# Step 3: Execute
ralph init --preset [chosen-preset]
ralph run
```

### Pattern 2: Simple → Complex

```bash
# Start simple
ralph init --preset feature-minimal

# If needed, escalate to full workflow
ralph init --preset feature
```

### Pattern 3: Test → Implement → Review

```bash
# TDD approach
ralph init --preset tdd-red-green
# Tests first, then implementation
```

---

## Customization Tips

### 1. Adjust Quality Gates

Edit `ralph.yml`:

```yaml
hats:
  builder:
    instructions: |
      # Custom quality checks
      run_tests() {
        npm test
        npm run lint
        npm run typecheck
      }
```

### 2. Modify Event Flow

```yaml
hats:
  custom_hat:
    triggers: ["custom.event"]
    publishes: ["next.event"]
    instructions: |
      # Your custom logic
```

### 3. Add Project Context

Create `PROMPT.md`:

```markdown
# Project Context

## Tech Stack
- Language: Python 3.11
- Framework: Django 4.2
- Database: PostgreSQL 15
- Testing: pytest

## Conventions
- Code style: Black + isort
- Tests: Must have 90% coverage
- Documentation: All public APIs documented
```

### 4. Clean Publishes Pattern

**What to do**: Define business logic (hats, triggers, publishes)
**What NOT to do**: Show `ralph emit`, JSONL format, or file paths

Ralph automatically handles event emission mechanics. Your YAML should focus on what to publish, not how.

**Example**:
```yaml
# Good - clean publishes
publishes: ["build.done"]
instructions: |
  When complete, publish build.done

# Bad - shows internal mechanics
instructions: |
  Run: ralph emit build.done
```

For detailed guidance, see [prompt-engineering.md](prompt-engineering.md#v2-architecture-event-data-handling-patterns).

---

## Monitoring Progress

### Real-Time Monitoring

```bash
# TUI mode (recommended)
ralph run --tui

# Verbose output
ralph run --verbose

# Watch events
ralph events --watch
```

### Checkpoint Monitoring

```bash
# View progress
cat .agent/scratchpad.md

# View event history
ralph events list

# Count iterations
ralph events list | jq -r '.topic' | sort | uniq -c
```

---

## Troubleshooting Quick Fixes

### Problem: Ralph keeps rejecting work

**Solution**: Fix quality issues (tests, lint, typecheck)

```bash
# Check what's failing
npm test
npm run lint
npm run typecheck

# Fix issues, Ralph will retry automatically
```

### Problem: Workflow stops too early

**Solution**: Check completion promise

```yaml
# In ralph.yml
event_loop:
  completion_event: "LOOP_COMPLETE"
  starting_event: "workflow.started"  # Event that begins the loop
```

### Problem: Hat never triggers

**Solution**: Check trigger names

```yaml
hats:
  my_hat:
    triggers: ["event.name"]  # Must match published event exactly
```

---

## Next Steps

After quick start:

1. **Read**: [references/preset-patterns.md](references/preset-patterns.md) - Understand available presets
2. **Study**: [references/workflow-selection.md](references/workflow-selection.md) - Choose the right workflow
3. **Master**: [references/prompt-engineering.md](references/prompt-engineering.md) - Write effective prompts
4. **Reference**: [references/troubleshooting.md](references/troubleshooting.md) - Solve problems

---

## Command Cheat Sheet

```bash
# Initialize
ralph init --list-presets
ralph init --preset feature

# Run
ralph run                    # Standard run
ralph run --tui             # With UI
ralph run --verbose          # Verbose output
ralph run --iterations 5     # Limit iterations

# Continue interrupted
ralph run --continue

# Clean state
ralph clean

# Events
ralph events --help
```

---

## Getting Help

```bash
# CLI help
ralph --help
ralph init --help
ralph run --help

# Check logs
ralph events list

# Debug mode
ralph run --verbose --iterations 1
```

---

## Best Practices

1. **Start simple**: Use `feature-minimal` for small tasks
2. **Monitor progress**: Use `--tui` for visibility
3. **Fix quality issues**: Don't work around backpressure
4. **One task at a time**: Let Ralph iterate
5. **Use presets**: Don't create custom configs from scratch
6. **Read output**: Check `.agent/scratchpad.md` and `ANALYSIS.md`
7. **Customize wisely**: Adjust quality gates, not workflow logic
8. **Save state**: Ralph saves progress automatically

You're now ready to use Ralph effectively!
