# Preset-Aware Invariants

**For:** Defining preset-specific validation rules that catch logical errors simple log parsing misses.

## Purpose

Different Ralph workflows have different success patterns. Invariants validate that the orchestration follows its intended logic, not just that it completes without errors.

## TDD Red-Green

**Pattern:** Strict alternation of test and implement phases.

### Invariants

```yaml
tdd_red_green:
  test_written:
    must_follow: null # First event
    must_precede: test_passing
    forbid_consecutive: true # No back-to-back test_written

  test_passing:
    must_follow: test_written
    must_precede: refactor_done
    forbid_consecutive: true # No back-to-back test_passing

  refactor_done:
    must_follow: test_passing
    must_precede: test_written # Cycle continues
    skip_if: tests_complete # Can end after tests

  forbidden_patterns:
    - pattern: "test_written → test_written"
      diagnosis: "Test written but previous test never passed"
      action: "Inject task: Fix failing test before writing new one"

    - pattern: "LOOP_COMPLETE without tests_passing"
      diagnosis: "Workflow completed without all tests passing"
      action: "Inject task: Ensure all tests pass before completion"
```

### Detection

```bash
# Check for proper alternation
jq -s 'map(select(.data.event | test("test")) | .data.event)' .ralph/events.jsonl

# Verify no consecutive same events
# (should alternate: test_written, test_passing, refactor_done)
```

## Confession Loop

**Pattern:** Quality gate with confidence scoring.

### Invariants

```yaml
confession_loop:
  confession_event:
    requires:
      - confidence_score # Must include numeric confidence
      - work_description # Must describe what was done

  confidence_threshold:
    minimum: 80 # Confidence >= 80 to auto-approve
    handler_required_if: "confidence < 80"
    handler_timeout: 10 # Minutes before escalation

  forbidden_patterns:
    - pattern: "confidence < 80 without Handler activation"
      diagnosis: "Low confidence work bypassed review"
      action: "Inject task: Handler must review low-confidence work"

    - pattern: "confidence consistently < 60 for >5 iterations"
      diagnosis: "Workflow stuck in low-confidence loop"
      action: "Inject task: Reassess approach or escalate to human"

    - pattern: "confidence always 100"
      diagnosis: "Possible gaming of confidence scores"
      action: "Inject task: Verify confidence scores reflect actual uncertainty"
```

### Detection

```bash
# Extract confidence scores
jq 'select(.data.event == "confession.submitted") | .data.confidence' .ralph/events.jsonl

# Check Handler activations follow low confidence
# (should see handler.review after confidence < 80)
```

## Adversarial Review

**Pattern:** Red team finds issues OR explicitly approves.

### Invariants

```yaml
adversarial_review:
  red_team_activation:
    must_produce_within: 10 # Minutes
    valid_outputs:
      - vulnerability.found
      - security.approved

  vulnerability_found:
    requires:
      - severity # Low, Medium, High, Critical
      - description # What the vulnerability is
      - exploit # How to exploit it

  security_approved:
    requires:
      - scope # What was reviewed
      - limitations # What wasn't tested
      - confidence # How confident in the approval

  forbidden_patterns:
    - pattern: "red_team.active without output for >15 minutes"
      diagnosis: "Red Team stuck or not doing actual work"
      action: "Inject task: Red Team must produce findings or approval"

    - pattern: "security.approved without findings within 2 minutes"
      diagnosis: "Premature approval without real scrutiny"
      action: "Inject task: Red Team must perform actual security analysis"

    - pattern: "LOOP_COMPLETE without vulnerability.found OR security.approved"
      diagnosis: "Red Team never concluded its review"
      action: "Inject task: Complete security review before ending"
```

### Detection

```bash
# Check Red Team outputs
jq 'select(.data.hat == "red_team") | .data.event' .ralph/events.jsonl

# Verify time between activation and output
# (should be >2 minutes for real analysis)
```

## Mob Programming

**Pattern:** Multiple perspectives rotate through work.

### Invariants

```yaml
mob_programming:
  perspective_rotation:
    required_perspectives:
      - implementation # Code structure
      - testing # Test coverage
      - documentation # User-facing docs
      - security # Security implications

    activation_limit: 5 # Max consecutive same-perspective activations

  forbidden_patterns:
    - pattern: "Same perspective active for >5 consecutive iterations"
      diagnosis: "Perspective domination - not true mob rotation"
      action: "Inject task: Rotate to next perspective"

    - pattern: "LOOP_COMPLETE without all perspectives activated"
      diagnosis: "Workflow ended without full perspective coverage"
      action: "Inject task: Ensure all perspectives contribute before completion"

    - pattern: "implementation perspective always first"
      diagnosis: "Implementation-first bias - should consider other perspectives first"
      action: "Inject task: Start with testing or documentation perspective"
```

### Detection

```bash
# Track perspective activations
jq 'select(.data.perspective) | .data.perspective' .ralph/events.jsonl | sort | uniq -c

# Check for proper rotation
# (should see alternating perspectives, not dominance)
```

## Spec-Driven Development

**Pattern:** Specification approved before implementation.

### Invariants

```yaml
spec_driven:
  spec_approval:
    must_precede: implementation_start
    requires:
      - stakeholder_approval
      - acceptance_criteria

  implementation_start:
    must_follow: spec.approved
    must_track:
      - spec_compliance # Implementation matches spec
      - deviation_reason # If deviating, explain why

  forbidden_patterns:
    - pattern: "implementation_started before spec.approved"
      diagnosis: "Implementation started without spec approval"
      action: "Inject task: Approve spec before implementing"

    - pattern: "spec.rejected but implementation continues"
      diagnosis: "Ignoring spec rejection"
      action: "Inject task: Address spec feedback before continuing"
```

### Detection

```bash
# Verify spec.approved precedes implementation.started
jq -s 'map(.data.event) | .[]' .ralph/events.jsonl | grep -E "spec|implementation"
```

## Debugging (Scientific Method)

**Pattern:** Hypothesis → Test → Confirm/Reject loop.

### Invariants

```yaml
scientific_method:
  hypothesis:
    must_include:
      - prediction # What will happen
      - test_method # How to verify

  test_execution:
    must_follow: hypothesis.proposed
    must_include:
      - actual_result # What actually happened
      - conclusion # confirmed or rejected

  loop_continuation:
    if_confirmed: "Fix based on confirmed hypothesis"
    if_rejected: "propose new hypothesis"

  forbidden_patterns:
    - pattern: "hypothesis.proposed → LOOP_COMPLETE without test"
      diagnosis: "Hypothesis never tested"
      action: "Inject task: Test hypothesis before concluding"

    - pattern: "test.completed without conclusion"
      diagnosis: "Test ran but no conclusion drawn"
      action: "Inject task: Analyze test results and conclude"
```

### Detection

```bash
# Verify hypothesis → test → conclusion flow
jq 'select(.data.event | test("hypothesis|test")) | .data.event' .ralph/events.jsonl
```

## General Invariants (All Presets)

Apply to all Ralph workflows regardless of preset:

```yaml
general:
  iteration_progression:
    rule: "iterations must increment monotonically"
    violation: "iteration count stays same or decreases"
    action: "Check Ralph event loop state"

  event_publishing:
    rule: "one event published per iteration (fresh context)"
    violation: "iterations << events (same-iteration switching)"
    action: "Add STOP instruction to hat prompts"

  orphaned_loops:
    rule: "all trigger events must have handling hats"
    violation: "event published but no hat triggers on it"
    action: "Review event flow, add or fix hat triggers"

  completion_convergence:
    rule: "workflow must reach LOOP_COMPLETE"
    violation: "max_iterations reached without completion"
    action: "Investigate deadlock or circular event flow"
```

## Implementation Strategy

### In Monitoring Subagent

1. **Load preset invariants** at start based on selected preset
2. **Validate events in real-time** against invariant rules
3. **Inject recovery tasks** when invariants violate
4. **Report pattern health** to main agent periodically

### In ralph-execution Skill

1. **Detect preset type** from ralph.yml or prompt
2. **Select appropriate invariants** from this reference
3. **Configure monitoring subagent** with preset-specific rules
4. **Handle violations** via state injection (task add)

## Reference Integration

- **Preset Selection:** See `SKILL.md` Decision Matrix
- **Monitoring Protocol:** See `monitoring-subagent.md`
- **Coordination Patterns:** See `coordination-patterns.md`
