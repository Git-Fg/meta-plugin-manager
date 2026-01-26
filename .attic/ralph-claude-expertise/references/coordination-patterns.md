# Ralph Coordination Patterns

Proven multi-agent coordination patterns for Ralph workflows. Use these patterns as starting points for custom hat configurations.

---

## Pattern Selection Guide

| Scenario | Pattern | Preset |
|----------|---------|--------|
| Sequential phases | Linear Pipeline | `tdd-red-green` |
| Spec approval required | Contract-First | `spec-driven` |
| Multiple perspectives | Cyclic Rotation | `mob-programming` |
| Security review | Adversarial | `adversarial-review` |
| Complex debugging | Hypothesis-Driven | `scientific-method` |
| Confidence-aware completion | Confession Loop | `confession-loop` |
| Specialist tasks | Coordinator-Specialist | `gap-analysis` |
| Multiple input formats | Adaptive Entry | `code-assist` |
| Standard development | Basic delegation | `feature` |
| Learning agent | Memory-Enabled | `memory-enabled` |

---

## Pattern 1: Linear Pipeline

Work flows through sequential specialists. Use for TDD, red-green-refactor cycles, or any sequential phase-based workflow.

```yaml
hats:
  test_writer:
    triggers: ["tdd.start", "refactor.done"]
    publishes: ["test.written"]

  implementer:
    triggers: ["test.written"]
    publishes: ["test.passing"]

  refactorer:
    triggers: ["test.passing"]
    publishes: ["refactor.done", "cycle.complete"]
```

**Flow**: `tdd.start → Test Writer → Implementer → Refactorer → (back to Test Writer)`

**Use when**: Tasks require strict sequential phases with handoffs between specialists.

---

## Pattern 2: Contract-First Pipeline

Work must pass validation gates before proceeding. Use for specification-driven development where approval gates prevent implementation of invalid specs.

```yaml
hats:
  spec_writer:
    triggers: ["spec.start", "spec.rejected"]
    publishes: ["spec.ready"]

  spec_reviewer:
    triggers: ["spec.ready"]
    publishes: ["spec.approved", "spec.rejected"]

  implementer:
    triggers: ["spec.approved", "spec.violated"]
    publishes: ["implementation.done"]

  verifier:
    triggers: ["implementation.done"]
    publishes: ["task.complete", "spec.violated"]
```

**Flow**: Spec Writer → Spec Reviewer → (approved) → Implementer → Verifier → (spec violated) → back to Implementer

**Use when**: Quality gates are required before proceeding to implementation.

---

## Pattern 3: Adversarial Review

Opposing roles ensure robustness. Use for security reviews, red-team testing, or devil's advocate scenarios.

```yaml
hats:
  builder:
    name: "Blue Team (Builder)"
    triggers: ["security.review", "fix.applied"]
    publishes: ["build.ready"]

  red_team:
    name: "Red Team (Attacker)"
    triggers: ["build.ready"]
    publishes: ["vulnerability.found", "security.approved"]

  fixer:
    triggers: ["vulnerability.found"]
    publishes: ["fix.applied"]
```

**Flow**: Builder → Red Team → (vulnerability) → Fixer → back to Builder

**Use when**: Security robustness requires adversarial testing perspectives.

---

## Pattern 4: Hypothesis-Driven Investigation

Scientific method for debugging. Use for complex bug investigation where hypothesis formulation and testing is more effective than trial-and-error.

```yaml
hats:
  observer:
    triggers: ["science.start", "hypothesis.rejected"]
    publishes: ["observation.made"]

  theorist:
    triggers: ["observation.made"]
    publishes: ["hypothesis.formed"]

  experimenter:
    triggers: ["hypothesis.formed"]
    publishes: ["hypothesis.confirmed", "hypothesis.rejected"]

  fixer:
    triggers: ["hypothesis.confirmed"]
    publishes: ["fix.applied"]
```

**Flow**: Observer → Theorist → Experimenter → (rejected) → back to Observer, (confirmed) → Fixer

**Use when**: Complex debugging benefits from structured scientific method over trial-and-error.

---

## Pattern 5: Confession Loop (Confidence-Aware Completion)

Internal monologue recording with verification for honest self-assessment. This pattern prevents premature completion through structured confession and verification.

```yaml
hats:
  builder:
    name: "Builder"
    description: "Implements one task and records an internal monologue for the confession phase."
    triggers: ["build.task"]
    publishes: ["build.done", "build.blocked"]
    default_publishes: "build.done"
    instructions: |
      ## BUILDER PHASE
      Implement the task. Record your thinking as memories for the confession phase:
      ```bash
      ralph tools memory add "shortcut: used X instead of Y because..." -t decision
      ralph tools memory add "uncertainty: not sure if edge case Z is handled" -t context
      ralph tools memory add "assumption: assuming API returns sorted results" -t context
      ```
      ### Process
      1. Pick one task from `ralph tools task ready`.
      2. Implement the change.
      3. Run backpressure (tests/lints/builds).
      4. Record what you did as a memory with evidence.
      5. Close the task: `ralph tools task close <id>`.
      ### Don't
      - Do not output the completion promise.
      - Do not skip backpressure.
      - Do not close tasks without running tests.
      ### Event Format
      ```bash
      ralph emit "build.done" "tests: pass, lint: pass. Summary of what was done"
      ```
      If stuck:
      ```bash
      ralph emit "build.blocked" "what you tried and why it failed"
      ```

  confessor:
    name: "Confessor"
    description: "Produces a ConfessionReport; rewarded solely for honesty and finding issues."
    triggers: ["build.done"]
    publishes: ["confession.clean", "confession.issues_found"]
    instructions: |
      ## CONFESSION PHASE
      Act as an internal auditor. Find issues. Surface problems, uncertainties, and shortcuts.
      ### Read First
      1. Search for builder's internal monologue: `ralph tools memory search "shortcut OR uncertainty OR assumption"`
      2. The code/changes produced (git diff, recent commits)
      3. The original task requirements
      ### Create ConfessionReport Memory
      ```bash
      ralph tools memory add "confession: objective=X, met=Yes/Partial/No, evidence=file:line" -t context
      ralph tools memory add "confession: uncertainty=<assumption or gap>" -t context
      ralph tools memory add "confession: shortcut=<what was done>, reason=<why>" -t context
      ralph tools memory add "confession: verify=<easiest check>, confidence=<0-100>" -t context --tags confession
      ```
      ### Then Publish Event
      Confidence threshold: 80.
      - If ANY issues found OR confidence < 80 -> publish `confession.issues_found`
      - If genuinely nothing (rare) AND confidence >= 80 -> publish `confession.clean`
      ### Event Format
      ```bash
      ralph emit "confession.issues_found" "confidence: [0-100], summary: [brief summary], verification: [easiest check]"
      # Or if clean:
      ralph emit "confession.clean" "confidence: [0-100], summary: [brief summary]"
      ```

  confession_handler:
    name: "Confession Handler"
    description: "Verifies one claim and decides whether to continue iterating or finish."
    triggers: ["confession.issues_found", "confession.clean"]
    publishes: ["build.task", "escalate.human"]
    instructions: |
      ## HANDLER PHASE
      Search for confession memories: `ralph tools memory search "confession" --tags confession`

      If triggered by `confession.issues_found`:
      1. Run the verification command/check from the confession memory to calibrate trust.
      2. If the issue is real, the confession is trustworthy.
         - For minor issues: create a fix task and publish `build.task`
         - For major issues: publish `escalate.human`
      3. If the issue is NOT real, the confession is untrustworthy. Publish `escalate.human`.
      Do not output the completion promise on this path.

      If triggered by `confession.clean`:
      1. Be skeptical. Verify at least one positive claim from the builder's work.
      2. If verification passes AND `confidence` from the event is >= 80:
         - Ensure all tasks are closed: `ralph tools task list` should show no open tasks
         - Commit changes with a descriptive message
         - Output the completion promise
      3. If verification fails OR `confidence` < 80:
         - Create a fix task and publish `build.task`
```

**Flow**: `build.task → Builder → build.done → Confessor → confession.issues_found → Handler → build.task` (iterate)

**Key concepts:**
- Builder records honest internal monologue as memories (shortcuts, uncertainties, assumptions)
- Confessor finds issues, not praise
- Handler verifies claims before deciding completion vs iteration
- Confidence threshold (80) prevents premature completion
- Backpressure enforced through verification

**Use when**: Honest self-assessment is critical; premature completion must be prevented through structured confession.
