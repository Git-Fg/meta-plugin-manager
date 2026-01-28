# Spec Compliance Reviewer Prompt Template

Use this template when dispatching a spec compliance reviewer subagent for Ralph orchestration.

**Purpose:** Verify component builder built what was requested (nothing more, nothing less)

## Template Structure

```
Task tool (general-purpose):
  description: "Review Spec Compliance: [component-name]"
  prompt: |
    You are reviewing whether a component implementation matches its specification.

    ## What Was Requested

    [FULL TEXT of component requirements from blueprint]

    ## What Builder Claims They Built

    [From builder's report]

    ## CRITICAL: Do Not Trust the Report

    The builder finished suspiciously quickly. Their report may be incomplete,
    inaccurate, or optimistic. You MUST verify everything independently.

    **DO NOT:**
    - Take their word for what they implemented
    - Trust their claims about completeness
    - Accept their interpretation of requirements

    **DO:**
    - Read the actual code they wrote
    - Compare actual implementation to requirements line by line
    - Check for missing pieces they claimed to implement
    - Look for extra features they didn't mention
    - Verify portability claims

    ## Your Job

    Read the implementation and verify:

    **Missing requirements:**
    - Did they implement everything that was requested?
    - Are there requirements they skipped or missed?
    - Did they claim something works but didn't actually implement it?

    **Extra/unneeded work:**
    - Did they build things that weren't requested?
    - Did they over-engineer or add unnecessary features?
    - Did they add "nice to haves" that weren't in spec?

    **Portability issues:**
    - Does component depend on external dependencies?
    - Are there references to files outside the component?
    - Would this work in a fresh project?

    **Misunderstandings:**
    - Did they interpret requirements differently than intended?
    - Did they solve the wrong problem?
    - Did they implement the right feature but wrong way?

    **Verify by reading code, not by trusting report.**

    ## Report Format

    Report:
    - ✅ Spec compliant (if everything matches after code inspection)
    - ❌ Issues found: [list specifically what's missing or extra, with file:line references]
    - 🔍 Portability check: [verify zero external dependencies]
```

## Usage

When dispatching a spec compliance reviewer:

```bash
Task("Review Spec Compliance: my-skill", {
  prompt: render_template("spec-reviewer-prompt.md", {
    component_name: "my-skill",
    requirements: blueprint.requirements,
    builder_report: builder_results.report
  })
})
```

## Key Principles

**Distrust Reports:** Always verify independently, never trust builder claims

**Line-by-Line Comparison:** Check implementation against requirements systematically

**Portability Verification:** Ensure component works without external dependencies

**Specific Findings:** Cite file:line references for all issues
