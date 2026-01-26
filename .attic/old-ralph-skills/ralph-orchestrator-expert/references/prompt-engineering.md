# Prompt Engineering Guide

Use this guide when writing custom prompts or hat instructions for Ralph. Covers best practices and techniques for Ralph's multi-agent architecture.

---

## Ralph-Specific Prompt Patterns

### 1. Hat Instructions Pattern

Ralph's hats require specific instruction structure:

```yaml
hats:
  builder:
    name: "Builder"
    triggers: ["build.task"]
    publishes: ["build.done", "build.blocked"]
    default_publishes: "build.done"
    instructions: |
      ## BUILDER MODE

      You're building, not planning. One task, then exit.

      ### Process
      1. **Pick ONE task.** Highest priority `[ ]` from scratchpad.
      2. **Implement.** Write the code. Follow existing patterns.
      3. **Validate.** Run backpressure. Must pass.
      4. **Commit.** One task, one commit.
      5. **Exit.** Publish build.done with evidence.

      ### Backpressure
      ```bash
      cargo check && cargo test && cargo clippy -- -D warnings
      ```
```

**Key Elements**:
- Clear role definition (Builder, not Planner)
- Step-by-step process
- Event emission via publishes
- Backpressure validation
- Exit conditions

### 2. Fresh Context Pattern

Every hat instruction should enforce fresh context:

```yaml
instructions: |
  ## FRESH CONTEXT MODE

  You have NO memory of previous iterations.

  ### Required Actions
  1. **Re-read** all relevant files from scratch
  2. **Re-analyze** the current state
  3. **Re-evaluate** the plan based on current reality
  4. **Act** based on fresh understanding only

  ### DO NOT
  - Assume previous work is complete
  - Skip reading files "you've seen before"
  - Trust your memory of the codebase
  - Make assumptions about state

  ### DO
  - Read every file referenced in the task
  - Check the actual current state
  - Verify all assumptions
  - Base decisions on current reality
```

### 3. Clean Publishes Pattern

Ralph v2 Architecture: YAML files define **Business Logic** (the "What"). The Ralph binary automatically injects **Mechanics** (the "How") at runtime.

#### What This Means

When you write a Ralph preset, you should ONLY define:
- Hat names and roles
- Triggers (what activates each hat)
- Publications (what events each hat can emit)
- Instructions (what the hat should do)

You should **NEVER** include:
- `ralph emit` commands
- JSONL event format examples
- XML tags or special markup
- Internal file paths (`.agent/events.jsonl`)
- Implementation details

#### How It Works Under the Hood

When Ralph runs, it constructs a composite prompt:

```
CORE_IDENTITY        # "I am Ralph..."
+ HAT_INSTRUCTIONS   # Your YAML business logic
+ TOPOLOGY_TABLE     # "Here are the hats available..."
+ EVENT_MECHANICS    # How to actually publish events
```

The `EVENT_MECHANICS` section is **automatically injected** by the Ralph binary. It tells the AI how to translate "publish test.written" into the actual event emission mechanism.

#### How to Prompt Agents

❌ **Bad** - Don't Show Internal Mechanics:
```yaml
instructions: |
  When work is complete, write to .agent/events.jsonl:
  {"topic": "build.done", "data": {"status": "complete"}}

  Or use: ralph emit build.done
```

✅ **Good** - Just Use Publish:
```yaml
instructions: |
  When work is complete, publish build.done
```

### Pattern: Declarative Event Declaration

```yaml
hats:
  builder:
    triggers: ["build.task"]
    publishes: ["build.done", "build.blocked"]
    instructions: |
      Implement the code changes.

      When complete:
      - Publish build.done if successful
      - Publish build.blocked if encountering issues
```

---

## v2 Architecture: Event Data Handling Patterns

Ralph v2 provides two patterns for handling data in events. Choose based on your needs:

### Pattern 1: The "Scratchpad" Pattern (Recommended - 95% of cases)

**Philosophy**: Events are for routing. The Scratchpad (`.agent/scratchpad.md`) is for data.

Use when:
- Passing detailed context to the next hat
- Sharing error messages, analysis, or logs
- Storing structured data for human review

**Why?** The Scratchpad is passed as context to the next hat. If the next hat needs detailed information to make decisions, it reads from the Scratchpad. Passing huge payloads in events wastes context window.

**Example in YAML:**
```yaml
hats:
  builder:
    publishes: ["build.done", "build.blocked"]
    instructions: |
      If the build succeeds:
      1. Write summary to .agent/scratchpad.md
      2. Publish build.done

      If the build fails:
      1. Update .agent/scratchpad.md with "## Blocker Analysis" section containing:
         - Error message
         - Failed command
         - What was attempted
      2. Publish build.blocked with brief summary
```

### Pattern 2: The Structured JSON Pattern (Meta-data only - 5% of cases)

**Philosophy**: You need the data *inside* the event log for automated processing.

Use when:
- Building dashboards that parse events programmatically
- Extracting metrics (error rates, file counts) without LLM
- Storing simple meta-data for analytics

**Example in YAML:**
```yaml
hats:
  builder:
    publishes: ["build.done", "build.blocked"]
    instructions: |
      When complete, publish build.done containing a JSON object with:
      - `files`: List of files modified
      - `tests_passed`: Number of tests that passed
      - `tests_failed`: Number of tests that failed

      If blocked, publish build.blocked with:
      - `reason`: High-level reason
      - `error_code`: Specific error code
      - `attempted`: What was tried
```

**What the Agent does**: Combines your data requirements with Ralph's system prompt to format the CLI command:
```bash
ralph emit build.done --json '{"files": ["main.rs"], "tests_passed": 45, "tests_failed": 0}'
```

### Which Pattern to Use?

| Scenario | Use Pattern | Reason |
|----------|-------------|--------|
| Next hat needs details to decide | Scratchpad | Shared context, human-readable |
| Building automated dashboard | JSON | Programmatic parsing |
| Error logs for debugging | Scratchpad | Detailed, readable |
| Simple metrics (counts, rates) | JSON | Easy to aggregate |
| Stack traces, long messages | Scratchpad | Too large for events |
| File paths for next hat | Scratchpad | Next hat needs to read them |

---

## Examples by Use Case

### 1. Simple Completion

**Bad**:
```yaml
publishes: ["work.done"]
instructions: |
  Emit event when done: {"topic": "work.done"}
```

**Good**:
```yaml
publishes: ["work.done"]
instructions: |
  When complete, publish work.done
```

### 2. Conditional Publishing

**Bad**:
```yaml
publishes: ["approved", "rejected"]
instructions: |
  If approved: echo '{"topic": "approved"}' >> .agent/events.jsonl
  If rejected: echo '{"topic": "rejected"}' >> .agent/events.jsonl
```

**Good**:
```yaml
publishes: ["approved", "rejected"]
instructions: |
  Review the work.

  If acceptable: publish approved
  If issues found: publish rejected with feedback
```

### 3. Quality Gates

**Bad**:
```yaml
publishes: ["quality.passed"]
instructions: |
  Run tests, then if all pass:
  {"topic": "quality.passed", "data": {"tests": 45}}
```

**Good (Scratchpad Pattern)**:
```yaml
publishes: ["quality.passed", "quality.failed"]
instructions: |
  Run quality checks (tests, lint, typecheck).

  If all checks pass:
  1. Update .agent/scratchpad.md with test results summary
  2. Publish quality.passed

  If any check fails:
  1. Update .agent/scratchpad.md with "## Quality Check Failures" section:
     - List each failing check
     - Include specific error messages
     - Suggest next steps
  2. Publish quality.failed
```

**Good (JSON Pattern - for dashboard)**:
```yaml
publishes: ["quality.passed", "quality.failed"]
instructions: |
  Run quality checks.

  If all pass: publish quality.passed with JSON:
  ```json
  {
    "tests_passed": 45,
    "tests_failed": 0,
    "lint_errors": 0,
    "typecheck_errors": 0
  }
  ```

  If any fail: publish quality.failed with JSON:
  ```json
  {
    "tests_failed": 3,
    "lint_errors": 2,
    "typecheck_errors": 0,
    "first_error": "Test failed: expected 5, got 3"
  }
  ```
```

### 4. Error Handling

**Bad**:
```yaml
publishes: ["error.occurred"]
instructions: |
  If error: echo '{"topic": "error.occurred", "data": {...}}' >> .agent/events.jsonl
```

**Good (Scratchpad Pattern - Recommended)**:
```yaml
publishes: ["error.occurred", "task.complete"]
instructions: |
  Handle errors gracefully.

  If unrecoverable error:
  1. Update .agent/scratchpad.md with "## Error Analysis" section:
     - Error type and message
     - Stack trace (if available)
     - Context: what you were trying to do
     - What was attempted to fix it
  2. Publish error.occurred with brief summary

  If task complete:
  1. Update .agent/scratchpad.md with completion summary
  2. Publish task.complete
```

---

## Prompt File Basics

### File Format

Ralph Orchestrator uses Markdown files for prompts:

```markdown
# Task Title

## Objective
Clear description of what needs to be accomplished.

## Requirements
- Specific requirement 1
- Specific requirement 2

## Success Criteria
The task is complete when:
- Criterion 1 is met
- Criterion 2 is met

The orchestrator will run until iteration/time/cost limits are reached.
```

### File Location

Default prompt file: `PROMPT.md`

Custom location:
```bash
ralph run --prompt path/to/task.md
```

---

## Prompt Structure

### Essential Components

Every prompt should include:

1. **Clear Objective**
2. **Specific Requirements**
3. **Success Criteria**
4. **Completion Marker**

### Template

```markdown
# [Task Name]

## Objective
[One or two sentences describing the goal]

## Context
[Background information the agent needs]

## Requirements
1. [Specific requirement]
2. [Specific requirement]
3. [Specific requirement]

## Constraints
- [Limitation or boundary]
- [Technical constraint]
- [Resource constraint]

## Success Criteria
The task is complete when:
- [ ] [Measurable outcome]
- [ ] [Verifiable result]
- [ ] [Specific deliverable]

## Notes
[Additional guidance or hints]

---
The orchestrator will continue iterations until limits are reached.
```

---

## Ralph Workflow Patterns

### 1. Feature Development Pattern

```markdown
# Build New Feature

## Objective
Implement user authentication system with JWT tokens.

## Requirements
1. Create User model with email/password
2. Implement registration endpoint
3. Implement login endpoint with JWT
4. Add password hashing
5. Write comprehensive tests

## Technical Specifications
- Framework: FastAPI
- Database: PostgreSQL
- Authentication: JWT tokens
- Testing: pytest

## Success Criteria
- [ ] All endpoints functional
- [ ] Tests passing with >80% coverage
- [ ] Authentication working
- [ ] Passwords securely hashed

The orchestrator will run until all success criteria are met.
```

### 2. Debug Session Pattern

```markdown
# Debug Memory Leak

## Problem Description
Application crashes after processing large files (>100MB).

## Symptoms
- Memory usage grows unbounded
- Process killed by OOM killer
- Affects 30% of large file operations

## Investigation Steps
1. Reproduce the issue with test file
2. Profile memory usage
3. Identify leaking function
4. Implement fix
5. Verify fix with test

## Success Criteria
- [ ] Issue reproduced
- [ ] Root cause identified
- [ ] Fix implemented
- [ ] No regressions
- [ ] Memory usage stable

The orchestrator will run systematic debugging iterations until resolved.
```

### 3. Code Review Pattern

```markdown
# Review Code Changes

## Context
Review PR #123 that adds new payment processing feature.

## Files to Review
- src/payments/stripe.py
- src/payments/models.py
- tests/payments/

## Review Criteria
1. Correctness and logic
2. Security vulnerabilities
3. Performance implications
4. Code style and patterns
5. Test coverage

## Success Criteria
- [ ] All files reviewed
- [ ] Security issues identified
- [ ] Performance issues identified
- [ ] Style issues identified
- [ ] Actionable feedback provided

The orchestrator will iterate until comprehensive review is complete.
```

---

## Advanced Prompt Techniques

### 1. Self-Documenting Progress

```markdown
## Progress Log
<!-- Agent will update this section -->
- [ ] Step 1: Setup environment
- [ ] Step 2: Implement core logic
- [ ] Step 3: Add tests
- [ ] Step 4: Documentation

## Current Status
<!-- Agent updates this -->
Working on: [current task]
Completed: [list of completed items]
Next: [planned next step]

## Issues Encountered
<!-- Document problems here -->
```

### 2. Iterative Refinement

```markdown
# Iterative Implementation

## Phase 1: Basic Implementation
<!-- After Phase 1 complete, update prompt for Phase 2 -->

## Phase 2: Testing
<!-- After Phase 2 complete, update prompt for Phase 3 -->

## Phase 3: Documentation

Each phase should:
1. Complete the phase objectives
2. Update this prompt for next phase
3. Publish appropriate event
```

### 3. Checkpoint System

```markdown
## Checkpoints
- [ ] CHECKPOINT_1: Environment setup complete
- [ ] CHECKPOINT_2: Core functionality working
- [ ] CHECKPOINT_3: Tests passing
- [ ] CHECKPOINT_4: Documentation complete
- [ ] CHECKPOINT_5: All criteria verified

## Current Checkpoint
[Which checkpoint you're working on]
```

---

## Hat-Specific Instructions

### Builder Hat

```yaml
builder:
  instructions: |
    ## BUILDER HAT

    You implement ONE task at a time.

    ### Process
    1. Read the current task from scratchpad
    2. Implement the code changes
    3. Run quality checks (tests, lint, typecheck)
    4. If checks pass: publish build.done
    5. If checks fail: publish quality.failed with details

    ### Quality Gates
    - All tests must pass
    - No linting errors
    - Type checking must pass
    - Code follows project conventions

    ### DO NOT
    - Plan or design (that's the planner's job)
    - Review or critique (that's the reviewer's job)
    - Work on multiple tasks
    - Skip quality checks
```

### Reviewer Hat

```yaml
reviewer:
  instructions: |
    ## REVIEWER HAT

    You review and critique, never implement.

    ### Review Checklist
    - Correctness: Does it work as intended?
    - Security: Any vulnerabilities?
    - Performance: Any performance issues?
    - Style: Does it follow conventions?
    - Tests: Are there adequate tests?

    ### Process
    1. Read the code changes
    2. Review against checklist
    3. If acceptable: publish review.approved
    4. If issues found: publish review.changes_requested with specific feedback

    ### DO NOT
    - Make code changes
    - Be vague about issues
    - Block on trivial matters
    - Ignore security concerns
```

### Planner Hat

```yaml
planner:
  instructions: |
    ## PLANNER HAT

    You create detailed plans, never implement.

    ### Process
    1. Analyze the overall task
    2. Break into atomic tasks
    3. Estimate complexity
    4. Write tasks to scratchpad
    5. Publish plan.ready

    ### Task Format
    ```
    [ ] Task 1: [description]
        Complexity: Low/Medium/High
        Dependencies: [list]
        Success Criteria: [measurable outcome]
    ```

    ### DO NOT
    - Implement any code
    - Review or critique
    - Skip planning phase
    - Create vague tasks
```

---

## Quality Gate Patterns

### Test-Driven Quality

```yaml
instructions: |
  ## QUALITY GATE ENFORCEMENT

  You MUST run quality checks before publishing success.

  ### Required Checks
  1. Run tests: `npm test`
  2. Run linting: `npm run lint`
  3. Type check: `npm run typecheck`

  ### Success Criteria
  - All tests pass
  - No linting errors
  - Type checking passes

  ### If Checks Fail
  1. Fix the failing check
  2. Re-run all checks
  3. Only publish build.done when ALL pass

  ### Event Emission
  On success:
  - Publish build.done

  On failure:
  - Publish quality.failed with details
```

### Custom Quality Gates

```yaml
instructions: |
  ## CUSTOM QUALITY GATES

  ### Project-Specific Checks
  1. Security scan: `bandit -r .`
  2. Dependency check: `npm audit`
  3. Performance test: `npm run benchmark`
  4. Documentation: Check all public APIs documented

  ### Success Criteria
  - No security vulnerabilities
  - No known dependency issues
  - Performance within acceptable limits
  - All public APIs documented

  ### Only Publish build.done When All Gates Pass

  When all quality gates pass:
  - Publish build.done
```

---

## Error Handling Patterns

### Graceful Failure

```yaml
instructions: |
  ## ERROR HANDLING

  ### When Encountering Errors
  1. Document the error in detail
  2. Attempt recovery if possible
  3. If unrecoverable: publish work.blocked with context

  ### Event Format for Blocks
  - Publish work.blocked with detailed context
  - Include reason, error message, and attempted solutions

  ### DO NOT
  - Ignore errors
  - Skip emitting blocked events
  - Make assumptions about resolution
  - Continue with invalid state
```

### Retry Logic

```markdown
## Retry Strategy

If quality checks fail:
1. Fix the identified issues
2. Re-run all quality checks
3. If still failing: document why and publish work.blocked
4. Do NOT skip checks to "get through"

Maximum 3 retry attempts per task.
```

---

## Common Pitfalls

### 1. Vague Instructions

❌ **Bad**:
```yaml
instructions: |
  Implement the feature.
  Make sure it works.
```

✅ **Good**:
```yaml
instructions: |
  Implement user authentication with JWT.

  ## Requirements
  1. Create POST /auth/login endpoint
  2. Validate email/password
  3. Return JWT token on success
  4. Return 401 on invalid credentials

  ## Quality Gates
  - All tests must pass
  - No linting errors
  - Security scan must pass
```

### 2. Missing Event Emission

❌ **Bad**:
```yaml
instructions: |
  Implement the code changes.
  # No mention of events
```

✅ **Good**:
```yaml
instructions: |
  Implement the code changes.

  ## Event Emission Required
  When complete: Publish build.done
```

### 3. No Fresh Context

❌ **Bad**:
```yaml
instructions: |
  Continue implementing the feature.
  # Assumes previous context
```

✅ **Good**:
```yaml
instructions: |
  ## FRESH CONTEXT REQUIRED

  You have NO memory. Re-read all files.
  Analyze current state from scratch.
  Make decisions based on current reality only.
```

### 4. Missing Quality Gates

❌ **Bad**:
```yaml
instructions: |
  Write the code.
  # No quality validation
```

✅ **Good**:
```yaml
instructions: |
  Write the code.

  ## Quality Gates
  1. Run tests: must all pass
  2. Run linting: no errors
  3. Type check: must pass

  Only publish build.done when all gates pass.
```

---

## Common Mistakes

### Mistake 1: Including Internal Commands

❌ **Don't**:
```yaml
instructions: |
  Run tests, then execute:
  ralph emit test.passing
```

✅ **Do**:
```yaml
instructions: |
  Run tests.

  When all tests pass, publish test.passing
```

### Mistake 2: Showing JSON Format

❌ **Don't**:
```yaml
publishes: ["build.done"]
instructions: |
  Format events as:
  {"topic": "build.done", "data": {"files": [...]}}
```

✅ **Do**:
```yaml
publishes: ["build.done"]
instructions: |
  When complete, publish build.done
```

### Mistake 3: XML or Special Tags

❌ **Don't**:
```yaml
publishes: ["complete"]
instructions: |
  Signal completion with:
  <event name="complete" />
```

✅ **Do**:
```yaml
publishes: ["complete"]
instructions: |
  When complete, publish complete
```

---

## Testing Prompts

### Dry Run Testing

```bash
# Test prompt without execution
ralph run --dry-run --prompt test.md

# Test with limited iterations
ralph run --max-iterations 3 --prompt test.md

# Test with verbose output
ralph run --verbose --prompt test.md
```

### Prompt Validation Checklist

Before running a prompt:

- [ ] Clear objective stated
- [ ] Specific requirements listed
- [ ] Success criteria defined
- [ ] Event emission instructions included
- [ ] Quality gates specified
- [ ] Fresh context enforced
- [ ] Exit conditions clear

---

## Testing Your Preset

When creating a new preset, verify it follows the clean publishes pattern:

### Checklist

- [ ] No `ralph emit` commands in instructions
- [ ] No JSONL format examples
- [ ] No XML tags or special markup
- [ ] No `.agent/events.jsonl` file paths
- [ ] Only `publish <event_name>` phrasing
- [ ] Clear event names in `publishes` array
- [ ] Business logic focus in instructions
- [ ] Quality gates clearly defined (if applicable)

### Quick Test

Read your instructions aloud. If you find yourself explaining **how** to emit events (file paths, JSON format, command syntax), you're showing internal mechanics. If you're explaining **what** to publish and **when**, you're following the pattern.

---

## Ralph-Specific Optimizations

### 1. Context Management

```yaml
instructions: |
  ## CONTEXT MANAGEMENT

  ### Required Re-reads
  - README.md (project overview)
  - Current task from scratchpad
  - Related source files
  - Test files

  ### Output Location
  - Write changes to disk
  - Update scratchpad with progress
  - Publish events to trigger next hats

  ### Memory Constraint
  - Work incrementally
  - One task at a time
  - Save state explicitly
```

### 2. Iteration Efficiency

```yaml
instructions: |
  ## ITERATION EFFICIENCY

  ### One Task Per Iteration
  - Pick ONE task from scratchpad
  - Complete it fully
  - Emit completion event
  - Exit cleanly

  ### Task Prioritization
  1. Highest priority unmarked task
  2. Dependencies first
  3. Core functionality before polish

  ### State Persistence
  - Write progress to scratchpad
  - Mark completed tasks
  - Update priorities
```

### 3. Event-Driven Architecture

```yaml
instructions: |
  ## EVENT-DRIVEN EXECUTION

  ### Event Types
  - `task.start`: Begin work
  - `task.progress`: Update progress
  - `task.complete`: Task finished
  - `task.failed`: Task failed with reason

  ### Event Chain
  Each event should trigger next logical step:
  1. Plan emits `plan.ready` → triggers Builder
  2. Builder emits `build.done` → triggers Reviewer
  3. Reviewer emits `review.approved` → triggers completion

  ### Event Data
  Include relevant context in event data when publishing events:
  - Publish build.done with file paths and test count
```

---

## Best Practices Summary

1. **Be Specific**: Clear, actionable instructions
2. **Enforce Fresh Context**: No assumptions about state
3. **Emit Events**: Explicit event emission required
4. **Quality Gates**: Validate before completion
5. **One Task**: Atomic tasks per iteration
6. **Document Progress**: Update scratchpad
7. **Handle Errors**: Graceful failure with context
8. **Test Prompts**: Validate before production

---

## Prompt Library

### Starter Templates

1. **Feature Development**: User authentication system
2. **Bug Fix**: Memory leak in file processing
3. **Code Review**: Security-focused PR review
4. **Documentation**: API documentation generation
5. **Testing**: Unit test coverage improvement
6. **Refactoring**: Improve code quality

### Ralph-Specific Templates

1. **Hat Instructions**: Builder, Reviewer, Planner patterns
2. **Quality Gates**: Custom validation patterns
3. **Event Emission**: JSONL event format
4. **Fresh Context**: State management patterns

---

## Conclusion

Effective Ralph prompt engineering requires:
- Clear, specific instructions
- Explicit event emission
- Quality gate enforcement
- Fresh context awareness
- Error handling
- Iteration efficiency

Master these patterns to create robust, reliable Ralph workflows.
