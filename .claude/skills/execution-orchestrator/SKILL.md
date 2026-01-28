---
name: execution-orchestrator
description: "Execute implementation plans with intelligent routing between execution modes. Use when implementing tasks from a plan with checkpoints. Not for ad-hoc execution without a plan."
---

# Execution Orchestrator

<mission_control>
<objective>Execute implementation plans with intelligent routing between execution modes based on checkpoint types and quality requirements</objective>
<success_criteria>Tasks completed in appropriate mode with correct checkpoint handling and verification</success_criteria>
<standards_gate>
MANDATORY: Load execution-orchestrator references BEFORE routing to execution modes:

- Execution modes → references/modes.md
- Checkpoint handling → references/checkpoints.md
- Quality requirements → references/quality.md
  </standards_gate>
  </mission_control>

<trigger>When implementing tasks from a plan and need to choose execution strategy.
Not for: Ad-hoc execution without a plan, single isolated tasks without planning context.</trigger>

<interaction_schema>
ANALYZE_PLAN → DETERMINE_MODE → EXECUTE → VERIFY_COMPLETION
</interaction_schema>

Execute implementation plans by routing to the appropriate execution mode based on:

- Checkpoint types present in the plan
- Quality requirements (spec compliance + quality review needs)
- Dependency relationships between tasks

---

## Execution Modes

### Mode 1: AUTONOMOUS (Fully Subagent)

**Use when:** Plan has NO checkpoints (`type="checkpoint:*"`)

**Flow:**

1. Load PLAN.md
2. Detect: all tasks are `type="auto"`
3. Spawn single subagent with fresh context for entire plan
4. Subagent executes all tasks, creates SUMMARY.md
5. Commit with plan guidance

**Key benefit:** Fresh 200k context for maximum quality, no checkpoint overhead

```
Announce: "Using AUTONOMOUS mode - spawning subagent for fully autonomous plan execution"
```

### Mode 2: SEGMENTED (Subagent + Main Context)

**Use when:** Plan has ONLY `checkpoint:human-verify` checkpoints

**Flow:**

1. Parse plan into segments by checkpoint
2. For each autonomous segment: spawn subagent with fresh context
3. At each checkpoint: execute in main context, wait for user verification
4. Continue to next segment with fresh subagent
5. Aggregate results → SUMMARY → commit

**Segment routing rules:**
| Prior Checkpoint | Next Segment Routing |
|-----------------|---------------------|
| None (first) | SUBAGENT |
| `checkpoint:human-verify` | SUBAGENT |

**Key benefit:** Fresh context for each autonomous segment, human verification at checkpoints

```
Announce: "Using SEGMENTED mode - subagent for autonomous segments, main for verify checkpoints"
```

### Mode 3: MAIN CONTEXT (Sequential)

**Use when:** Plan has `checkpoint:decision` or `checkpoint:human-action` checkpoints

**Flow:**

1. Execute tasks sequentially in main context
2. At checkpoint: present decision/action to user, wait for response
3. Continue execution with decision context
4. Decisions affect subsequent task execution
5. SUMMARY → commit

**Key benefit:** Maintains decision context across dependent tasks

```
Announce: "Using MAIN CONTEXT mode - executing sequentially for decision-dependent workflow"
```

### Mode 4: REVIEWED (Fresh Subagent + Two-Stage Review)

**Use when:** Quality gates required (spec compliance + quality review) OR explicitly requested

**Flow per task:**

1. Dispatch fresh subagent to implement task
2. Stage 1: Spec compliance review (requirements match implementation?)
3. If fails: send back to implementer → re-review
4. Stage 2: Quality review (security, performance, code quality)
5. If fails: send back to implementer → re-review
6. Mark task complete → proceed to next task

**Two-stage review gate:**

- NEVER run Stage 2 if Stage 1 fails
- ALWAYS complete stages in sequence
- Review loops until both pass

**Key benefit:** Systematic quality gates prevent "LGTM" on bad code

```
Announce: "Using REVIEWED mode - fresh subagent per task with two-stage quality gates"
```

---

## Mode Selection Algorithm

### Step 1: Analyze Checkpoint Types

Use the `Grep` tool to detect checkpoint types in the plan:

```
Grep: Search PLAN.md for pattern: type="checkpoint
Output mode: content (shows line numbers)
```

### Step 2: Apply Decision Matrix

| Checkpoint Types Found           | Quality Gates?  | Execution Mode |
| -------------------------------- | --------------- | -------------- |
| None                             | No              | AUTONOMOUS     |
| Only `human-verify`              | No              | SEGMENTED      |
| Has `decision` or `human-action` | Any             | MAIN CONTEXT   |
| Any                              | Yes (requested) | REVIEWED       |

### Step 3: Override Conditions

**Override to REVIEWED mode when:**

- Plan explicitly requires quality gates
- Critical security/safety code
- External API integration requiring spec verification

**Override to MAIN CONTEXT when:**

- Plan has decision checkpoints AND tasks are tightly coupled
- Following tasks depend on checkpoint outcome

---

## Segment Parsing (for SEGMENTED Mode)

### Identify Segments

Segment = tasks between checkpoints (or start→first checkpoint, last checkpoint→end)

Use the `Grep` tool to find all checkpoints and their line numbers:

```
Grep: Search PLAN.md for pattern: type="checkpoint
Output mode: content (shows line numbers)
```

### Execute Segments

**For SUBAGENT segments:**

```
Spawn Task tool with subagent_type="general-purpose":

Prompt: "Execute tasks [task numbers] from plan at [plan path].

Context:
- You are executing a SEGMENT of this plan (not full plan)
- Read full plan for objective, context files, and deviation rules
- DO NOT create SUMMARY.md (will be created after all segments complete)
- DO NOT commit (will be done after all segments complete)

Report back:
- Tasks completed
- Files created/modified
- Deviations encountered"
```

**For MAIN CONTEXT checkpoints:**

- Execute checkpoint_protocol from execute-phase.md
- Wait for user response
- Verify if possible
- Continue to next segment

---

## Checkpoint Protocol

### Human Verify Checkpoint

```
I automated: [what was automated - deployed, built, configured]

How to verify:
1. [Step 1 - exact command/URL]
2. [Step 2 - what to check]
3. [Step 3 - expected behavior]

Type 'approved' or describe issues
```

### Decision Checkpoint

```
Decision needed: [decision]

Context: [why this matters]

Options:
1. [option-id]: [name]
   Pros: [pros]
   Cons: [cons]

2. [option-id]: [name]
   Pros: [pros]
   Cons: [cons]

Select: option-id
```

### Human Action Checkpoint

```
I automated: [what Claude already did via CLI/API]

Need your help with: [the ONE thing with no CLI/API]

Instructions:
[Single unavoidable step]

I'll verify after: [verification]

Type 'done' when complete
```

---

## Two-Stage Review (for REVIEWED Mode)

### Stage 1: Spec Compliance Review

**Verify independently:**

- Read actual implementation code
- Compare against requirements line-by-line
- Check for missing work
- Check for extra work (YAGNI violations)
- Report with file:line references

**Pass criteria:** All requirements implemented, no extra work

**Fail action:** Send back to implementer with specific issues

### Stage 2: Quality Review

**Review dimensions:**

1. Security: Injection, auth, secrets
2. Performance: N+1, algorithms, caching
3. Quality: Naming, duplication, complexity
4. Tests: Coverage and quality

**Pass criteria:** Quality is acceptable, no blockers

**Fail action:** Request changes with specific recommendations

### Review Loop Enforcement

```
NEVER skip stages
NEVER run quality review if spec compliance fails
ALWAYS complete stages in sequence
Review loops until approval (don't accept "close enough")
```

---

## State Management

### State Containers

<batch_status>
<purpose>Maintain execution state across long-running operations</purpose>

<current_segment>
<segment_id>1</segment_id>
<task_range>1-3</task_range>
<status>in_progress | complete | failed</status>
<mode>AUTONOMOUS | SEGMENTED | MAIN | REVIEWED</mode>
</current_segment>

<completed_segments>
<segment id="0">
<task_range>N/A</task_range>
<status>complete</status>
<completed_at>timestamp</completed_at>
</segment>
</completed_segments>
</batch_status>

<task_queue>
<priority>sequential</priority>

<task id="1">
<name>Task name</name>
<status>pending | in_progress | complete | failed | reviewing</status>
<mode_context>Which mode this task executes in</mode_context>
<segment_id>1</segment_id>
</task>
</task_queue>

### State Update Protocol

1. **Before execution**: Update task/segment status to `in_progress`
2. **After completion**: Update to `complete`
3. **On failure**: Update to `failed`, log error
4. **Never assume**: Always check state container, don't rely on memory

---

## Integration with Other Components

<routing_table>
Explicit routing for skill orchestration.

| When You Need To...                | Use This Skill/Command                 | Routing Command                           |
| ---------------------------------- | -------------------------------------- | ----------------------------------------- |
| Create a plan with checkpoints     | `writing-plans` skill                  | `Skill("writing-plans")`                  |
| Execute a plan                     | `/plan:execute` command                | Invoke via `/plan:execute <path>`         |
| Run full autonomous plan execution | `/plan:execute-all` command            | Invoke via `/plan:execute-all`            |
| Run quality review (REVIEWED mode) | `meta-critic` skill                    | `Skill("meta-critic")`                    |
| Final PR review                    | `pr-reviewer` skill                    | `Skill("pr-reviewer")`                    |
| Commit changes after execution     | `finishing-a-development-branch` skill | `Skill("finishing-a-development-branch")` |

</routing_table>

### With Planning Skills

```
[Use writing-plans to create plan with checkpoint types]
[Use execution-orchestrator to execute with appropriate mode]
```

### With Quality Skills

```
[execution-orchestrator with REVIEWED mode uses:]
- meta-critic for quality review → Skill("meta-critic")
- pr-reviewer for final review → Skill("pr-reviewer")
```

### With Git Workflow

```
[After execution complete:]
- Create SUMMARY.md
- Stage all changes
- Commit with message following plan guidance
```

---

## Red Flags

**Never:**

- Skip mode analysis (jump to execution without determining mode)
- Use batch mode when segmented is appropriate
- Skip checkpoint verification
- Proceed with unfixed review issues
- Mix modes arbitrarily

**If mode is unclear:**

- Re-read plan for checkpoint types
- Check if quality gates are explicitly required
- Default to SEGMENTED if unsure (safer than AUTONOMOUS)
- Ask for clarification if decision checkpoints affect flow

---

## Example Workflows

### Example 1: Autonomous Plan (No Checkpoints)

```
Plan: auth-system-PLAN.md (5 auto tasks, no checkpoints)

Announce: "AUTONOMOUS mode - spawning subagent for fully autonomous execution"

[1] Spawn subagent for tasks 1-5
→ Subagent completes: 5 files modified, 0 deviations

[2] Create SUMMARY.md
[3] Commit

✓ Complete
```

### Example 2: Segmented Plan (Verify Checkpoints)

```
Plan: dashboard-PLAN.md (8 tasks, 2 human-verify checkpoints)

Announce: "SEGMENTED mode - subagent for segments, main for verify checkpoints"

[1] Parse segments:
    - Segment 1: Tasks 1-3
    - Checkpoint 4: human-verify
    - Segment 2: Tasks 5-6
    - Checkpoint 7: human-verify
    - Segment 3: Task 8

[2] Execute Segment 1 (SUBAGENT):
    → Subagent completes: 3 files modified

[3] Checkpoint 4 (MAIN):
    ════════════════════════════════
    CHECKPOINT: Verify dashboard layout
    I built: Login page, registration page, dashboard shell
    How to verify: Check src/pages/*.tsx
    Type 'approved' or describe issues
    ════════════════════════════════

[4] User: "approved"

[5] Execute Segment 2 (SUBAGENT):
    → Subagent completes: 2 files modified

[6] Checkpoint 7 (MAIN):
    [Verify data integration]

[7] User: "approved"

[8] Execute Segment 3 (SUBAGENT):
    → Subagent completes: 1 file modified

[9] Aggregate results → SUMMARY → commit

✓ Complete
```

### Example 3: Reviewed Plan (Quality Gates)

```
Plan: api-security-PLAN.md (3 tasks, quality gates required)

Announce: "REVIEWED mode - fresh subagent per task with two-stage quality gates"

Task 1: Auth middleware

[1] Dispatch implementer (SUBAGENT)
→ Implemented: JWT validation middleware

[2] Stage 1: Spec compliance review
→ Reviewer: ✅ COMPLIANT - all requirements met

[3] Stage 2: Quality review
→ Reviewer: ⚠️ Missing token expiry check
→ Requested: Add exp claim validation

[4] Implementer fixes: Added token expiry validation

[5] Stage 2 re-review: ✅ APPROVED

[6] Task 1: COMPLETE

... (repeat for Task 2, Task 3)

✓ All tasks passed two-stage review
```

---

## Quick Reference

| Mode       | Checkpoints     | Session  | Review        | When to Use          |
| ---------- | --------------- | -------- | ------------- | -------------------- |
| AUTONOMOUS | None            | Subagent | No            | Fully auto plans     |
| SEGMENTED  | human-verify    | Mixed    | No            | Verify-then-continue |
| MAIN       | decision/action | Main     | No            | Decision-dependent   |
| REVIEWED   | Any             | Subagent | Yes (2-stage) | Quality-critical     |

---

## Absolute Constraints

<critical_constraint>
MANDATORY: Analyze plan structure before choosing execution mode

- Scan PLAN.md for checkpoint types
- Apply decision matrix to determine mode
- Announce mode before execution begins

MANDATORY: Route segments based on checkpoint type (not arbitrary)

- human-verify checkpoint → SUBAGENT for next segment
- decision/human-action checkpoint → MAIN CONTEXT for next segment

MANDATORY: In REVIEWED mode, complete two-stage review in sequence

- Stage 1: Spec compliance (requirements match implementation?)
- Stage 2: Quality review (security, performance, quality)
- NEVER run Stage 2 if Stage 1 fails
- Review loops until both pass

MANDATORY: Maintain state in XML containers throughout execution

- Initialize state before execution
- Update status: pending → in_progress → complete/failed
- Never rely on memory - verify state container

MANDATORY: Verify independently, don't trust reports

- Read actual code during reviews
- Compare against requirements line-by-line
- Report with file:line references

No exceptions. State containers are source of truth. Two-stage review prevents "LGTM" hallucinations.
</critical_constraint>
