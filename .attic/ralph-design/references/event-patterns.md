# Event Flow Patterns Reference

Complete reference for designing event flows in Ralph orchestrations.

## Event Flow Principles

### 1. One-to-One Mapping
Each trigger must map to exactly one hat. No ambiguous routing.

### 2. Reserved Events
Never use these as triggers:
- `task.start`
- `task.resume`
- `LOOP_COMPLETE`

### 3. Complete Chains
Every event chain must eventually reach `LOOP_COMPLETE`.

## Event Naming Conventions

### Phase Transitions
```yaml
<phase>.ready    # Ready to start phase
<phase>.done     # Phase completed successfully
```

**Examples:**
```yaml
design.ready → design.done
execution.ready → execution.done
validation.ready → validation.done
```

### Review Gates
```yaml
<thing>.approved    # Accepted after review
<thing>.rejected   # Rejected with feedback
```

**Examples:**
```yaml
review.approved → review.rejected
spec.approved → spec.rejected
design.approved → design.rejected
```

### Discovery Events
```yaml
<noun>.found      # Discovery made
<noun>.missing    # Expected item not found
```

**Examples:**
```yaml
dependency.found → dependency.missing
pattern.found → pattern.missing
issue.found → issue.missing
```

### Request-Response
```yaml
<action>.request   # Request for action
<action>.complete  # Action completed
```

**Examples:**
```yaml
analysis.request → analysis.complete
build.request → build.complete
review.request → review.complete
```

### Status Updates
```yaml
<component>.blocked  # Cannot proceed (awaiting external condition)
<component>.ready   # Ready to start
<component>.done    # Successfully completed
<component>.failed  # Failed after attempts
```

**Examples:**
```yaml
build.blocked → build.ready → build.done
execution.blocked → execution.ready → execution.done
```

## Common Event Chain Patterns

### Linear Pipeline

```
Start → A → B → C → LOOP_COMPLETE
```

**Use case:** Sequential workflow with distinct phases

**Example: Document Processing**
```yaml
workflow.start
  → analysis.ready → analysis.done
  → writing.ready → writing.done
  → review.ready → review.done
  → LOOP_COMPLETE
```

**Configuration:**
```yaml
hats:
  analyzer:
    triggers: ["workflow.start"]
    publishes: ["analysis.done"]
  writer:
    triggers: ["analysis.done"]
    publishes: ["writing.done"]
  reviewer:
    triggers: ["writing.done"]
    publishes: ["LOOP_COMPLETE"]
```

### Critic-Actor Loop

```
Actor → Critic → approved/rejected
                   ↓
        rejected → Actor (retry)
```

**Use case:** Quality gates, iterative improvement

**Example: Code Review**
```yaml
workflow.start
  → actor.work → critic.review
                    ↓
        rejected → actor.work (retry)
                   ↓
                approved → LOOP_COMPLETE
```

**Configuration:**
```yaml
hats:
  actor:
    triggers: ["workflow.start", "critic.rejected"]
    publishes: ["actor.work"]
  critic:
    triggers: ["actor.work"]
    publishes: ["critic.approved", "critic.rejected"]
    default_publishes: "critic.approved"
```

### Scientific Method

```
Observe → Hypothesize → Test → confirmed/rejected
                                     ↓
                          rejected → Observe
```

**Use case:** Debugging, investigation, hypothesis testing

**Example: Bug Investigation**
```yaml
workflow.start
  → observe.start → observe.done
  → hypothesis.start → hypothesis.done
  → test.start → test.confirmed
                      ↓
                   test.rejected → observe.start
```

**Configuration:**
```yaml
hats:
  observer:
    triggers: ["workflow.start", "test.rejected"]
    publishes: ["observe.done"]
  hypothesizer:
    triggers: ["observe.done"]
    publishes: ["hypothesis.done"]
  tester:
    triggers: ["hypothesis.done"]
    publishes: ["test.confirmed", "test.rejected"]
    default_publishes: "test.confirmed"
```

### Supervisor-Worker

```
Supervisor → worker.task → Worker → work.done → Supervisor
                                                   ↓
                                         LOOP_COMPLETE
```

**Use case:** Task decomposition, parallel work management

**Example: Feature Development**
```yaml
workflow.start
  → supervisor.plan → worker.task
                    → worker.work → work.done
                    → supervisor.plan (if more tasks)
                    → LOOP_COMPLETE
```

**Configuration:**
```yaml
hats:
  supervisor:
    triggers: ["workflow.start", "work.done"]
    publishes: ["worker.task", "LOOP_COMPLETE"]
  worker:
    triggers: ["worker.task"]
    publishes: ["work.done"]
```

### Fan-Out/Fan-In

```
Start → Task1 → Task2 → Task3
         ↓       ↓       ↓
      done1   done2   done3
         ↓       ↓       ↓
      Merge → LOOP_COMPLETE
```

**Use case:** Parallel execution with aggregation

**Example: Batch Testing**
```yaml
workflow.start
  → test.suite1 → test.suite1.done
  → test.suite2 → test.suite2.done
  → test.suite3 → test.suite3.done
  → merge.results → LOOP_COMPLETE
```

**Configuration:**
```yaml
hats:
  test_suite1:
    triggers: ["workflow.start"]
    publishes: ["test.suite1.done"]
  test_suite2:
    triggers: ["workflow.start"]
    publishes: ["test.suite2.done"]
  test_suite3:
    triggers: ["workflow.start"]
    publishes: ["test.suite3.done"]
  merger:
    triggers: ["test.suite1.done", "test.suite2.done", "test.suite3.done"]
    publishes: ["LOOP_COMPLETE"]
```

## Complex Patterns

### Confession Loop

```
Validator → Confidence Check → clean/issues_found
                              ↓
                    issues_found → Fix → Validator
```

**Use case:** Validation with uncertainty tracking

**Example: Code Validation**
```yaml
workflow.start
  → validate.execution → validate.confidence
                              ↓
                    issues_found → fix.issues → validate.execution
                              ↓
                          clean → LOOP_COMPLETE
```

**Configuration:**
```yaml
hats:
  validator:
    triggers: ["workflow.start", "fix.issues"]
    publishes: ["validate.confidence"]
  confidence_check:
    triggers: ["validate.confidence"]
    publishes: ["validate.clean", "validate.issues_found"]
    default_publishes: "validate.clean"
  fixer:
    triggers: ["validate.issues_found"]
    publishes: ["fix.issues"]
```

### Adversarial Review

```
Red Team → Findings → Blue Team → Defenses
    ↓           ↓         ↓
  report    validated   confirmed
    ↓           ↓         ↓
  LOOP_COMPLETE (or iterate)
```

**Use case:** Security review, critical analysis

**Example: Security Audit**
```yaml
workflow.start
  → red.team.attack → red.team.findings
  → blue.team.defend → blue.team.validation
  → report.generate → LOOP_COMPLETE
```

**Configuration:**
```yaml
hats:
  red_team:
    triggers: ["workflow.start"]
    publishes: ["red.team.findings"]
  blue_team:
    triggers: ["red.team.findings"]
    publishes: ["blue.team.validation"]
  reporter:
    triggers: ["blue.team.validation"]
    publishes: ["LOOP_COMPLETE"]
```

## Event Flow Validation

### Checklist

Before running your orchestration:

**Mapping:**
- [ ] Each trigger maps to exactly one hat
- [ ] No reserved events used as triggers
- [ ] All publishes have corresponding triggers

**Completeness:**
- [ ] Every chain reaches LOOP_COMPLETE
- [ ] No orphan events
- [ ] All hats have at least one publish

**Naming:**
- [ ] Follow naming conventions
- [ ] Events are descriptive
- [ ] Phase transitions are clear

### Validation Commands

```bash
# Check event flow
ralph run --dry-run

# Expected output shows:
# Hat activation sequence
# Event routing
# Completion path
```

### Troubleshooting

**Problem: Orphaned loop**
```yaml
# Symptoms: Ralph waits indefinitely
# Cause: Event published with no matching trigger
# Fix: Check all publishes have corresponding triggers
```

**Problem: Same-iteration switching**
```yaml
# Symptoms: Multiple events in single iteration
# Cause: Hat not publishing STOP
# Fix: Add "STOP after publishing" to instructions
```

**Problem: No progress**
```yaml
# Symptoms: Iteration count not incrementing
# Cause: Hat not publishing required event
# Fix: Check hat instructions for proper event emission
```

## Best Practices

1. **Keep events simple and descriptive**
   - Use nouns and verbs clearly
   - Avoid overly complex event names
   - Be consistent with naming

2. **Minimize event types**
   - Use existing patterns when possible
   - Don't create new event types unnecessarily
   - Reuse common patterns

3. **Document event flows**
   - Comment complex chains
   - Explain non-obvious routing
   - Note any special handling

4. **Test with dry-run**
   - Always validate event flow before running
   - Check routing is correct
   - Verify completion path

5. **Monitor event flow**
   - Use `ralph events` to track flow
   - Watch for unexpected patterns
   - Validate against expected chain

## Example: Complete Event Flow

### Feature Development Workflow

```yaml
# Event Chain:
workflow.start
  → coordinator.route
  → design.specs
  → design.tests
  → execution.ready
  → execution.build
  → execution.test
  → validation.confession
  → validation.clean
  → LOOP_COMPLETE

# Configuration:
hats:
  coordinator:
    triggers: ["workflow.start"]
    publishes: ["coordinator.route"]
    instructions: |
      Route based on task type.
      STOP after publishing.

  designer:
    triggers: ["coordinator.route"]
    publishes: ["design.specs", "design.tests"]
    instructions: |
      Create specifications and tests.
      STOP after publishing.

  executor:
    triggers: ["design.tests"]
    publishes: ["execution.ready", "execution.build", "execution.test"]
    instructions: |
      Implement and test the feature.
      STOP after publishing.

  validator:
    triggers: ["execution.test"]
    publishes: ["validation.confession"]
    instructions: |
      Validate implementation.
      STOP after publishing.

  finalizer:
    triggers: ["validation.clean"]
    publishes: ["LOOP_COMPLETE"]
    instructions: |
      Complete workflow.
      STOP after publishing.
```
