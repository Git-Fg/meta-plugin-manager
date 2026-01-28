---
name: systematic-debugging
description: "Enforce systematic debugging discipline when you encounter bugs, test failures, or unexpected behavior. Not for quick patches, partial fixes, or ignoring root causes."
---

# Systematic Debugging

<mission_control>
<objective>Find root cause before attempting any fixes - systematic investigation prevents symptom patches</objective>
<success_criteria>Root cause identified with evidence, minimal fix applied, verification confirms resolution</success_criteria>
</mission_control>

## Overview

Random fixes waste time and create new bugs. Quick patches mask underlying issues.

**Core principle:** ALWAYS find root cause before attempting fixes. Symptom fixes are failure.

**Violating the letter of this process is violating the spirit of debugging.**

<interaction_schema>
symptom → evidence → hypothesis → test → implementation → verify → done
</interaction_schema>

## The Iron Law

<absolute_constraint>
**NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST**

If you haven't completed Phase 1, you CANNOT propose fixes.

This is not a suggestion. This is a law of debugging.
</absolute_constraint>

## Investigation Format

<critical_constraint>
**MANDATORY: Use `<investigation>` format for systematic debugging.**

This format enforces evidence-based reasoning and prevents jumping to fixes.
</critical_constraint>

<investigation_format>
<investigation>
<symptom>
<description>[What is the observable problem?]</description>
<reproduction_steps>[Exact steps to reproduce]</reproduction_steps>
<frequency>[Always/Sometimes/Once]</frequency>
</symptom>

<evidence>
<error_messages>[Complete error text, stack traces]</error_messages>
<logs>[Relevant log output]</logs>
<recent_changes>[Git diff, recent commits, config changes]</recent_changes>
<environment_data>[OS, versions, dependencies]</environment_data>
</evidence>

<hypothesis>
<root_cause>[What is the likely root cause?]</root_cause>
<reasoning>[Why does this cause the symptom?]</reasoning>
<confidence>[High/Medium/Low - based on evidence]</confidence>
</hypothesis>

<test>
<minimal_reproduction>[Smallest test to confirm hypothesis]</minimal_reproduction>
<expected_result>[What should happen if hypothesis is correct]</expected_result>
<actual_result>[What actually happened]</actual_result>
<conclusion>[Confirmed/Rejected - hypothesis status]</conclusion>
</test>
</investigation>
</investigation_format>

### Investigation Example

```xml
<investigation>
<symptom>
<description>Login fails with "Invalid credentials" for valid user</description>
<reproduction_steps>1. Enter valid username/password
2. Click login
3. Observe error</reproduction_steps>
<frequency>Always</frequency>
</symptom>

<evidence>
<error_messages>AuthError: Invalid credentials (line 42, auth.js)</error_messages>
<logs>INFO: Password hash comparison failed</logs>
<recent_changes>Commit abc123: Updated bcrypt cost factor</recent_changes>
<environment_data>Node v18, bcrypt 5.1.0</environment_data>
</evidence>

<hypothesis>
<root_cause>Password hash comparison using wrong cost factor</root_cause>
<reasoning>Recent commit changed cost factor from 10 to 12, but login still uses 10</reasoning>
<confidence>High</confidence>
</hypothesis>

<test>
<minimal_reproduction>Change login to use cost=12, verify login succeeds</minimal_reproduction>
<expected_result>Login succeeds with cost=12</expected_result>
<actual_result>Login succeeded</actual_result>
<conclusion>Confirmed</conclusion>
</test>
</investigation>
```

---

<debug_protocol>
digraph IronLaw {
RootCause -> Pattern;
Pattern -> Hypothesis;
Hypothesis -> TestMinimal;
TestMinimal -> Implementation [label="Confirmed"];
TestMinimal -> Hypothesis [label="Failed"];
Implementation -> Verify;
Verify -> RootCause [label="Regression"];
Verify -> Done [label="Success"];
}
</debug_protocol>

## When to Use

Use for ANY technical issue:

- Test failures
- Bugs in production
- Unexpected behavior
- Performance problems
- Build failures
- Integration issues

**Use this ESPECIALLY when:**

- Under time pressure (emergencies make guessing tempting)
- "Just one quick fix" seems obvious
- You've already tried multiple fixes
- Previous fix didn't work
- You don't fully understand the issue

**Don't skip when:**

- Issue seems simple (simple bugs have root causes too)
- You're in a hurry (rushing guarantees rework)
- External pressure wants it fixed NOW (systematic is faster than thrashing)

## The Four Phases

You MUST complete each phase before proceeding to the next.

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

1. **Read Error Messages Carefully**
   - Don't skip past errors or warnings
   - They often contain the exact solution
   - Read stack traces completely
   - Note line numbers, file paths, error codes

2. **Reproduce Consistently**
   - Can you trigger it reliably?
   - What are the exact steps?
   - Does it happen every time?
   - If not reproducible → gather more data, don't guess

3. **Check Recent Changes**
   - What changed that could cause this?
   - Git diff, recent commits
   - New dependencies, config changes
   - Environmental differences

4. **Gather Evidence in Multi-Component Systems**

   **WHEN system has multiple components (CI → build → signing, API → service → database):**

   **BEFORE proposing fixes, add diagnostic instrumentation:**

   ```
   For EACH component boundary:
     - Log what data enters component
     - Log what data exits component
     - Verify environment/config propagation
     - Check state at each layer

   Run once to gather evidence showing WHERE it breaks
   THEN analyze evidence to identify failing component
   THEN investigate that specific component
   ```

   **Example (multi-layer system):**

   ```bash
   # Layer 1: Workflow
   echo "=== Secrets available in workflow: ==="
   echo "IDENTITY: ${IDENTITY:+SET}${IDENTITY:-UNSET}"

   # Layer 2: Build script
   echo "=== Env vars in build script: ==="
   env | grep IDENTITY || echo "IDENTITY not in environment"

   # Layer 3: Signing script
   echo "=== Keychain state: ==="
   security list-keychains
   security find-identity -v

   # Layer 4: Actual signing
   codesign --sign "$IDENTITY" --verbose=4 "$APP"
   ```

   **This reveals:** Which layer fails (secrets → workflow ✓, workflow → build ✗)

5. **Trace Data Flow**

   **WHEN error is deep in call stack:**

   See `references/root-cause-tracing.md` for the complete backward tracing technique.

   **Quick version:**
   - Where does bad value originate?
   - What called this with bad value?
   - Keep tracing up until you find the source
   - Fix at source, not at symptom

### Phase 2: Pattern Analysis

**Find the pattern before fixing:**

1. **Find Working Examples**
   - Locate similar working code in same codebase
   - What works that's similar to what's broken?

2. **Compare Against References**
   - If implementing pattern, read reference implementation COMPLETELY
   - Don't skim - read every line
   - Understand the pattern fully before applying

3. **Identify Differences**
   - What's different between working and broken?
   - List every difference, however small
   - Don't assume "that can't matter"

4. **Understand Dependencies**
   - What other components does this need?
   - What settings, config, environment?
   - What assumptions does it make?

### Phase 3: Hypothesis and Testing

**Scientific method:**

1. **Form Single Hypothesis**
   - State clearly: "I think X is the root cause because Y"
   - Write it down
   - Be specific, not vague

2. **Test Minimally**
   - Make the SMALLEST possible change to test hypothesis
   - One variable at a time
   - Don't fix multiple things at once

3. **Verify Before Continuing**
   - Did it work? Yes → Phase 4
   - Didn't work? Form NEW hypothesis
   - DON'T add more fixes on top

4. **When You Don't Know**
   - Say "I don't understand X"
   - Don't pretend to know
   - Ask for help
   - Research more

### Phase 4: Implementation

**Fix the root cause, not the symptom:**

1. **Create Failing Test Case**
   - Simplest possible reproduction
   - Automated test if possible
   - One-off test script if no framework
   - MUST have before fixing
   - Use the `tdd-workflow` skill for writing proper failing tests

2. **Implement Single Fix**
   - Address the root cause identified
   - ONE change at a time
   - No "while I'm here" improvements
   - No bundled refactoring

3. **Verify Fix**
   - Test passes now?
   - No other tests broken?
   - Issue actually resolved?

4. **If Fix Doesn't Work**
   - STOP
   - Count: How many fixes have you tried?
   - If < 3: Return to Phase 1, re-analyze with new information
   - **If ≥ 3: STOP and question the architecture (step 5 below)**
   - DON'T attempt Fix #4 without architectural discussion

5. **If 3+ Fixes Failed: Question Architecture**

   **Pattern indicating architectural problem:**
   - Each fix reveals new shared state/coupling/problem in different place
   - Fixes require "massive refactoring" to implement
   - Each fix creates new symptoms elsewhere

   **STOP and question fundamentals:**
   - Is this pattern fundamentally sound?
   - Are we "sticking with it through sheer inertia"?
   - Should we refactor architecture vs. continue fixing symptoms?

   **Discuss with your human partner before attempting more fixes**

   This is NOT a failed hypothesis - this is a wrong architecture.

## Red Flags - STOP and Follow Process

If you catch yourself thinking:

- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "Add multiple changes, run tests"
- "Skip the test, I'll manually verify"
- "It's probably X, let me fix that"
- "I don't fully understand but this might work"
- "Pattern says X but I'll adapt it differently"
- "Here are the main problems: [lists fixes without investigation]"
- Proposing solutions before tracing data flow
- **"One more fix attempt" (when already tried 2+)**
- **Each fix reveals new problem in different place**

**ALL of these mean: STOP. Return to Phase 1.**

**If 3+ fixes failed:** Question the architecture (see Phase 4.5)

## Common Rationalizations

| Rationalization (Stop)                       | Reality                                                                 |
| -------------------------------------------- | ----------------------------------------------------------------------- |
| "Issue is simple, don't need process"        | Simple issues have root causes too. Process is fast for simple bugs.    |
| "Emergency, no time for process"             | Systematic debugging is FASTER than guess-and-check thrashing.          |
| "Just try this first, then investigate"      | First fix sets the pattern. Do it right from the start.                 |
| "I'll write test after confirming fix works" | Untested fixes don't stick. Test first proves it.                       |
| "Multiple fixes at once saves time"          | Can't isolate what worked. Causes new bugs.                             |
| "Reference too long, I'll adapt the pattern" | Partial understanding guarantees bugs. Read it completely.              |
| "I see the problem, let me fix it"           | Seeing symptoms ≠ understanding root cause.                             |
| "One more fix attempt" (after 2+ failures)   | 3+ failures = architectural problem. Question pattern, don't fix again. |

## Quick Reference

| Phase                 | Key Activities                                         | Success Criteria            |
| --------------------- | ------------------------------------------------------ | --------------------------- |
| **1. Root Cause**     | Read errors, reproduce, check changes, gather evidence | Understand WHAT and WHY     |
| **2. Pattern**        | Find working examples, compare                         | Identify differences        |
| **3. Hypothesis**     | Form theory, test minimally                            | Confirmed or new hypothesis |
| **4. Implementation** | Create test, fix, verify                               | Bug resolved, tests pass    |

## When Process Reveals "No Root Cause"

If systematic investigation reveals issue is truly environmental, timing-dependent, or external:

1. You've completed the process
2. Document what you investigated
3. Implement appropriate handling (retry, timeout, error message)
4. Add monitoring/logging for future investigation

**But:** 95% of "no root cause" cases are incomplete investigation.

## Supporting Techniques

These techniques are part of systematic debugging and available in this directory:

- **`references/root-cause-tracing.md`** - Trace bugs backward through call stack to find original trigger
- **`references/defense-in-depth.md`** - Add validation at multiple layers after finding root cause
- **`references/condition-based-waiting.md`** - Replace arbitrary timeouts with condition polling

**Related skills:**

- **`tdd-workflow`** - For creating failing test case (Phase 4, Step 1)
- **`meta-critic`** - Verify fix worked before claiming success

## Real-World Impact

From debugging sessions:

- Systematic approach: 15-30 minutes to fix
- Random fixes approach: 2-3 hours of thrashing
- First-time fix rate: 95% vs 40%
- New bugs introduced: Near zero vs common

---

## Absolute Constraints (Non-Negotiable)

<critical_constraint>
**THE IRON LAW: NO FIXES WITHOUT ROOT CAUSE INVESTIGATION**

- Complete Phase 1 (Root Cause Investigation) BEFORE proposing ANY fix
- Document symptoms, evidence, hypothesis BEFORE implementing
- Test hypothesis with minimal reproduction BEFORE full fix
- NEVER skip to Phase 4 without completing Phases 1-3

**MANDATORY: Use `<investigation>` format**

- Symptom: What is the observable problem?
- Evidence: Error messages, logs, recent changes, environment
- Hypothesis: What is the likely root cause and why?
- Test: Minimal reproduction to confirm hypothesis

**MANDATORY: One change at a time**

- Implement single fix based on confirmed hypothesis
- Test to verify it works
- If it fails, return to investigation
- NEVER try multiple fixes simultaneously

**MANDATORY: Verification before claiming completion**

- Test confirms fix resolves issue
- No regressions introduced
- Edge cases considered
- Documentation updated if needed

**MANDATORY: Question architecture after 3+ failed hypotheses**

- If 3+ hypotheses fail: STOP fixing
- Question the pattern/architecture
- Discuss with human partner
- Wrong pattern cannot be fixed by more patches

**No exceptions. No short-cuts. No "quick fixes." Symptom patches are failure.**
</critical_constraint>
