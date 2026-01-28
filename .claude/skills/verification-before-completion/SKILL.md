---
name: verification-before-completion
description: "Verify work before claiming completion when you are about to finish a task, commit code, or claim a fix. Not for assumption-based completion or skipping verification evidence."
---

# Verification Before Completion

## Overview

Claiming work is complete without verification is dishonesty, not efficiency.

**Core principle:** Evidence before claims, always.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

## The Gate Function

```
BEFORE claiming any status or expressing satisfaction:

1. IDENTIFY: What command proves this claim?
2. RUN: Execute the FULL command (fresh, complete)
3. READ: Full output, check exit code, count failures
4. VERIFY: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. ONLY THEN: Make the claim

Skip any step = lying, not verifying
```

## Common Failures

| Claim                 | Requires                        | Not Sufficient                 |
| --------------------- | ------------------------------- | ------------------------------ |
| Tests pass            | Test command output: 0 failures | Previous run, "should pass"    |
| Linter clean          | Linter output: 0 errors         | Partial check, extrapolation   |
| Build succeeds        | Build command: exit 0           | Linter passing, logs look good |
| Bug fixed             | Test original symptom: passes   | Code changed, assumed fixed    |
| Regression test works | Red-green cycle verified        | Test passes once               |
| Agent completed       | VCS diff shows changes          | Agent reports "success"        |
| Requirements met      | Line-by-line checklist          | Tests passing                  |

## Red Flags - STOP

- Using "should", "probably", "seems to"
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!", etc.)
- About to commit/push/PR without verification
- Trusting agent success reports
- Relying on partial verification
- Thinking "just this once"
- Tired and wanting work over
- **ANY wording implying success without having run verification**

## Rationalization Prevention

| Rationalization (Stop)                  | Reality                |
| --------------------------------------- | ---------------------- |
| "Should work now"                       | RUN the verification   |
| "I'm confident"                         | Confidence ≠ evidence  |
| "Just this once"                        | No exceptions          |
| "Linter passed"                         | Linter ≠ compiler      |
| "Agent said success"                    | Verify independently   |
| "I'm tired"                             | Exhaustion ≠ excuse    |
| "Partial check is enough"               | Partial proves nothing |
| "Different words so rule doesn't apply" | Spirit over letter     |

## Key Patterns

**Tests:**

```
✅ [Run test command] [See: 34/34 pass] "All tests pass"
❌ "Should pass now" / "Looks correct"
```

**Regression tests (TDD Red-Green):**

```
✅ Write → Run (pass) → Revert fix → Run (MUST FAIL) → Restore → Run (pass)
❌ "I've written a regression test" (without red-green verification)
```

**Build:**

```
✅ [Run build] [See: exit 0] "Build passes"
❌ "Linter passed" (linter doesn't check compilation)
```

**Requirements:**

```
✅ Re-read plan → Create checklist → Verify each → Report gaps or completion
❌ "Tests pass, phase complete"
```

**Agent delegation:**

```
✅ Agent reports success → Check VCS diff → Verify changes → Report actual state
❌ Trust agent report
```

## Why This Matters

Without verification discipline:

- False completion claims waste time
- Trust is broken when claims are wrong
- Bugs shipped without proper testing
- Incomplete work gets merged
- Rework required when issues discovered

**Evidence before assertions always.**

## When To Apply

**ALWAYS before:**

- ANY variation of success/completion claims
- ANY expression of satisfaction
- ANY positive statement about work state
- Committing, PR creation, task completion
- Moving to next task
- Delegating to agents

**Rule applies to:**

- Exact phrases
- Paraphrases and synonyms
- Implications of success
- ANY communication suggesting completion/correctness

## The Bottom Line

**No shortcuts for verification.**

Run the command. Read the output. THEN claim the result.

This is non-negotiable.

## Comprehensive Verification

For comprehensive 6-phase verification (build → type → lint → test → security → diff), use the **verification-loop** skill:

```bash
# Run full verification loop
/verify-loop

# Or directly
.claude/scripts/gates/verification-loop.sh
```

The verification-loop provides:

- **Sequential enforcement**: Gates run in order, stop on failure
- **Project detection**: Automatically detects project type and runs appropriate commands
- **Evidence logging**: Results logged to `~/.claude/homunculus/verification-log.jsonl`
- **Pre-commit integration**: Can be configured as automatic pre-commit hook

For complex changes requiring comprehensive validation, prefer verification-loop over manual verification.

## Integration with Other Skills

When validating components:

1. **Identify verification commands** - What proves this component works?
2. **Run verification** - Execute actual tests/validation
3. **Read full output** - Check all results, not just summary
4. **Verify claims** - Does evidence support stated status?
5. **Report with evidence** - Include verification output in report

**Validation checklist:**

- [ ] All tests pass (with verification output)
- [ ] All requirements met (verified against spec)
- [ ] Portability confirmed (works without external dependencies)
- [ ] Quality gates passed (lint, type-check, etc.)
- [ ] Evidence collected (screenshots, logs, test results)

**Never mark complete without fresh verification evidence.**

---

<critical_constraint>
MANDATORY: Run verification command fresh before claiming any status
MANDATORY: Read complete output, not just summary
MANDATORY: Include evidence in completion claims (not "should pass" but "passes: output shows 34/34")
MANDATORY: Never claim completion without fresh verification evidence
MANDATORY: Verify agent reports independently (check VCS diff, test output)
No exceptions. No completion claims without fresh verification evidence.
</critical_constraint>
