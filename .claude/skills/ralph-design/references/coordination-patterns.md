# Coordination Patterns Reference

Complete reference for coordination patterns in Ralph orchestrations.

## What Are Coordination Patterns?

Coordination patterns define how hats interact and sequence work. They're the "dance moves" your orchestration follows.

**Think of it like a choreographed performance:**
- Each hat has a specific role
- Events trigger transitions between hats
- Patterns define the overall structure

## Pattern Selection Guide

| If you need... | Use pattern... | Example preset |
|----------------|----------------|----------------|
| Sequential work | Pipeline | `tdd-red-green` |
| Quality gates | Critic-Actor | `review` |
| Investigation | Scientific Method | `debug` |
| Security review | Adversarial | `adversarial-review` |
| Parallel work | Supervisor-Worker | `gap-analysis` |
| Validation | Confession Loop | `confession-loop` |

## Core Patterns

### 1. Pipeline (Linear)

**Structure:**
```
A → B → C → LOOP_COMPLETE
```

**Use when:**
- Sequential phases with clear handoffs
- Each phase depends on previous
- No iteration or loops needed

**Example: Documentation Generation**
```
analyze → outline → write → review → LOOP_COMPLETE
```

**Ralph Configuration:**
```yaml
hats:
  analyzer:
    triggers: ["workflow.start"]
    publishes: ["analysis.complete"]
  outliner:
    triggers: ["analysis.complete"]
    publishes: ["outline.complete"]
  writer:
    triggers: ["outline.complete"]
    publishes: ["writing.complete"]
  reviewer:
    triggers: ["writing.complete"]
    publishes: ["LOOP_COMPLETE"]
```

**Benefits:**
- Simple to understand
- Easy to validate
- Clear progress tracking

**Drawbacks:**
- No backtracking or iteration
- Cannot handle branching logic
- Rigid structure

### 2. Critic-Actor (Quality Gates)

**Structure:**
```
Actor → Critic → approved/rejected
                   ↓
        rejected → Actor (retry)
```

**Use when:**
- Quality gates required
- Iterative improvement needed
- Review and approval process

**Example: Code Review**
```
implement → review → approved/rejected
                   ↓
          rejected → implement (retry)
```

**Ralph Configuration:**
```yaml
hats:
  implementer:
    triggers: ["workflow.start", "review.rejected"]
    publishes: ["implementation.complete"]
  reviewer:
    triggers: ["implementation.complete"]
    publishes: ["review.approved", "review.rejected"]
    default_publishes: "review.approved"
```

**Benefits:**
- Enforces quality
- Allows iteration
- Clear approval process

**Drawbacks:**
- Can loop indefinitely without caps
- Requires good critic criteria
- May need activation limits

### 3. Scientific Method (Hypothesis Testing)

**Structure:**
```
Observe → Hypothesize → Test → confirmed/rejected
                                    ↓
                         rejected → Observe
```

**Use when:**
- Investigation required
- Hypothesis-driven approach
- Unknown problem space

**Example: Bug Investigation**
```
observe → hypothesize → test → confirmed/rejected
                                 ↓
                      rejected → observe
```

**Ralph Configuration:**
```yaml
hats:
  observer:
    triggers: ["workflow.start", "test.rejected"]
    publishes: ["observation.complete"]
  hypothesizer:
    triggers: ["observation.complete"]
    publishes: ["hypothesis.complete"]
  tester:
    triggers: ["hypothesis.complete"]
    publishes: ["test.confirmed", "test.rejected"]
    default_publishes: "test.confirmed"
```

**Benefits:**
- Systematic investigation
- Evidence-based
- Good for debugging

**Drawbacks:**
- Can be slow
- Requires good observation skills
- May need many iterations

### 4. Supervisor-Worker (Task Delegation)

**Structure:**
```
Supervisor → worker.task → Worker → work.done → Supervisor
                                                   ↓
                                         LOOP_COMPLETE
```

**Use when:**
- Complex task decomposition
- Parallel work possible
- Need coordination of subtasks

**Example: Feature Development**
```
plan → task1 → work1 → task2 → work2 → merge → LOOP_COMPLETE
```

**Ralph Configuration:**
```yaml
hats:
  supervisor:
    triggers: ["workflow.start", "work.done"]
    publishes: ["worker.task", "LOOP_COMPLETE"]
  worker:
    triggers: ["worker.task"]
    publishes: ["work.done"]
```

**Benefits:**
- Scales to complex tasks
- Parallel execution possible
- Clear delegation

**Drawbacks:**
- Supervisor complexity
- Task state management needed
- Potential bottlenecks

### 5. Fan-Out/Fan-In (Parallel Execution)

**Structure:**
```
Start → Task1 → Merge
       → Task2 → Merge
       → Task3 → Merge
```

**Use when:**
- Independent parallel work
- Batch processing
- Multiple components to process

**Example: Batch Testing**
```
start → test.auth → merge
      → test.api → merge
      → test.ui → merge
```

**Ralph Configuration:**
```yaml
hats:
  test_auth:
    triggers: ["workflow.start"]
    publishes: ["test.auth.complete"]
  test_api:
    triggers: ["workflow.start"]
    publishes: ["test.api.complete"]
  test_ui:
    triggers: ["workflow.start"]
    publishes: ["test.ui.complete"]
  merger:
    triggers: ["test.auth.complete", "test.api.complete", "test.ui.complete"]
    publishes: ["LOOP_COMPLETE"]
```

**Benefits:**
- Parallel execution
- Faster completion
- Independent processing

**Drawbacks:**
- Requires all tasks to complete
- Merge complexity
- Resource coordination

## Advanced Patterns

### 6. Confession Loop (Validation with Uncertainty)

**Structure:**
```
Validate → Confidence Check → clean/issues_found
                              ↓
                    issues_found → Fix → Validate
```

**Use when:**
- Validation with uncertainty
- Need confidence tracking
- Self-assessment required

**Example: Code Validation**
```
validate → check_confidence → clean/issues_found
                                ↓
                      issues_found → fix → validate
```

**Ralph Configuration:**
```yaml
hats:
  validator:
    triggers: ["workflow.start", "fix.complete"]
    publishes: ["validation.complete"]
  confidence_checker:
    triggers: ["validation.complete"]
    publishes: ["validation.clean", "validation.issues_found"]
    default_publishes: "validation.clean"
  fixer:
    triggers: ["validation.issues_found"]
    publishes: ["fix.complete"]
```

**Key feature:** Confidence scoring determines whether to iterate or complete.

### 7. Adversarial Review (Security/Quality Focus)

**Structure:**
```
Red Team → Findings → Blue Team → Validation
    ↓           ↓         ↓
  Report    Validated   Confirmed
    ↓           ↓         ↓
  LOOP_COMPLETE (or iterate)
```

**Use when:**
- Security audits
- Critical review processes
- Multiple perspectives needed

**Example: Security Review**
```
red_team → findings → blue_team → validation → report
```

**Ralph Configuration:**
```yaml
hats:
  red_team:
    triggers: ["workflow.start"]
    publishes: ["findings.complete"]
  blue_team:
    triggers: ["findings.complete"]
    publishes: ["validation.complete"]
  reporter:
    triggers: ["validation.complete"]
    publishes: ["LOOP_COMPLETE"]
```

**Key feature:** Two teams with opposing perspectives ensure thorough review.

### 8. Mob Programming (Rotating Roles)

**Structure:**
```
Role1 → Role2 → Role3 → Role1 (rotation)
   ↓       ↓       ↓
 All contribute to same goal
```

**Use when:**
- Collaborative development
- Knowledge sharing
- Multiple expertise areas

**Example: Feature Development**
```
driver → navigator → observer → driver (rotate)
```

**Ralph Configuration:**
```yaml
hats:
  driver:
    triggers: ["workflow.start", "observer.complete"]
    publishes: ["driver.complete"]
  navigator:
    triggers: ["driver.complete"]
    publishes: ["navigator.complete"]
  observer:
    triggers: ["navigator.complete"]
    publishes: ["observer.complete"]
```

**Key feature:** Rotation ensures equal participation and knowledge transfer.

## Pattern Composition

Complex workflows often combine multiple patterns:

### Example: Feature Development with Quality Gates

```
Plan → Implement → Review → Test → Deploy
  ↓         ↓         ↓       ↓       ↓
Pipeline  Critic    Critic   Critic  Pipeline
        (Actor)   (Actor)  (Actor)
```

**Combined patterns:**
- Pipeline for overall flow
- Critic-Actor for quality gates at each stage

### Example: Bug Investigation with Fix

```
Observe → Hypothesize → Test → Fix → Validate
    ↓           ↓         ↓      ↓       ↓
Scientific   Critic     Actor   Actor   Critic
```

**Combined patterns:**
- Scientific Method for investigation
- Critic-Actor for validation
- Pipeline for overall flow

## Choosing Patterns

### Decision Tree

```
START: What is the primary need?
│
├─ Sequential work?
│  └─ Pipeline
│
├─ Quality enforcement?
│  ├─ Single gate? → Critic-Actor
│  └─ Multiple gates? → Pipeline of Critic-Actor
│
├─ Investigation?
│  └─ Scientific Method
│
├─ Parallel work?
│  ├─ Independent tasks? → Fan-Out/Fan-In
│  └─ Coordinated tasks? → Supervisor-Worker
│
├─ Validation with uncertainty?
│  └─ Confession Loop
│
└─ Multiple perspectives?
   └─ Adversarial Review or Mob Programming
```

### Pattern Combinations

| Base Pattern | Combine With | Result |
|--------------|-------------|--------|
| Pipeline | Critic-Actor | Quality gates at each stage |
| Scientific Method | Critic-Actor | Validated investigation |
| Fan-Out/Fan-In | Supervisor-Worker | Parallel coordination |
| Critic-Actor | Confession Loop | Quality gates with uncertainty tracking |

## Implementation Tips

### 1. Start Simple
- Begin with basic pattern
- Add complexity only if needed
- Validate each addition

### 2. Use Pattern Presets
- Most patterns have proven presets
- Start with preset, customize as needed
- Don't reinvent patterns

### 3. Limit Activations
- Add `max_activations` to prevent infinite loops
- Especially for iterative patterns
- Set reasonable caps based on complexity

### 4. Clear Instructions
- Each hat needs explicit instructions
- Include event emission examples
- Add STOP directives to prevent overwork

### 5. Monitor Flow
- Use `ralph events` to track pattern execution
- Watch for unexpected transitions
- Validate against expected pattern

## Common Mistakes

### Mistake 1: Over-Complex Patterns
```yaml
# BAD: Trying to handle everything in one pattern
hats:
  master:
    triggers: ["workflow.start"]
    publishes: ["workflow.anything"]
```
**Fix:** Use simpler, focused patterns.

### Mistake 2: No Exit Strategy
```yaml
# BAD: Pattern with no completion condition
Actor → Critic → approved/rejected
                   ↓
        rejected → Actor (retry forever)
```
**Fix:** Add activation caps or completion conditions.

### Mistake 3: Ignoring Pattern Nature
```yaml
# BAD: Using Pipeline for investigation
# Investigation needs iteration!
```
**Fix:** Match pattern to problem type.

### Mistake 4: Mixing Concerns
```yaml
# BAD: One hat doing implementation + review
hats:
  combined:
    triggers: ["workflow.start"]
    publishes: ["LOOP_COMPLETE"]
```
**Fix:** Separate concerns into different hats.

## Pattern Reference Table

| Pattern | Hats | Events | Best For | Warning |
|---------|------|--------|----------|---------|
| Pipeline | 3-5 | Linear chain | Sequential work | No backtracking |
| Critic-Actor | 2 | Loop with gate | Quality gates | Needs caps |
| Scientific Method | 3 | Hypothesis loop | Investigation | Can be slow |
| Supervisor-Worker | 2+ | Task delegation | Complex tasks | State management |
| Fan-Out/Fan-In | 3+ | Parallel merge | Batch processing | All must complete |
| Confession Loop | 3 | Validation loop | Uncertainty tracking | Confidence scoring |
| Adversarial Review | 3 | Multi-perspective | Security/quality | Requires expertise |
| Mob Programming | 3+ | Rotation | Collaboration | Coordination overhead |

## Testing Patterns

### Pattern Validation

```bash
# Test with dry-run
ralph run --dry-run

# Expected: Shows pattern execution
# - Hat activation sequence
# - Event flow
# - Completion path
```

### Pattern Monitoring

```bash
# Monitor pattern execution
ralph events --format json | jq '.[] | {iteration, topic}'

# Check for pattern violations
# - Same iteration, multiple events?
# - Missing events in chain?
# - Unexpected pattern breaks?
```

### Pattern Health Check

```bash
# Count iterations vs events
grep -c "_meta.loop_start" .ralph/events.jsonl
grep -c "bus.publish" .ralph/events.jsonl

# Expected: ~1:1 ratio for most patterns
# Deviations indicate pattern issues
```
