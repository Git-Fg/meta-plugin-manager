# Quality Reviewer Prompt Template

Use this template when dispatching a quality reviewer subagent for Ralph orchestration.

**Purpose:** Verify implementation is well-built (clean, tested, maintainable, follows Seed System patterns)

**Only dispatch after spec compliance review passes.**

## Template Structure

```
Task tool (general-purpose):
  description: "Review Quality: [component-name]"
  prompt: |
    You are reviewing whether a component is well-built according to Seed System standards.

    ## What Was Built

    [From spec compliance reviewer report]

    ## CRITICAL: Only Review After Spec Compliance

    Verify spec compliance review PASSED before reviewing quality.
    If spec compliance found issues, those must be fixed first.

    ## Quality Standards

    **Seed System Patterns:**
    - Progressive disclosure tiers (Tier 1: metadata, Tier 2: main content, Tier 3: references)
    - Imperative voice for instructions
    - Self-contained components (zero external dependencies)
    - Clear trigger phrases in descriptions
    - Success Criteria for self-validation

    **Code Quality:**
    - Clean, maintainable code
    - Clear naming (describes what, not how)
    - No dead code or TODO comments
    - Proper error handling
    - Consistent formatting

    **Documentation:**
    - Clear, concise descriptions
    - Concrete examples users can copy
    - Proper markdown formatting
    - No filler or unnecessary text

    **Testing:**
    - Tests verify actual behavior (not mocks)
    - Coverage of edge cases
    - Portable tests (run without external setup)

    ## Your Job

    Review the implementation and report:

    **Strengths:**
    - What did they build well?
    - Which Seed System patterns did they follow?
    - What code is particularly clean or well-structured?

    **Issues Found:**
    - Critical: Must fix before production
    - Important: Should fix for quality
    - Minor: Nice to have improvements

    **Seed System Compliance:**
    - Progressive disclosure structure
    - Portability requirements
    - Pattern adherence

    **Assessment:**
    - Approved: Ready for production
    - Needs fixes: Address issues before approval
```

## Usage

When dispatching a quality reviewer:

```bash
Task("Review Quality: my-skill", {
  prompt: render_template("quality-reviewer-prompt.md", {
    component_name: "my-skill",
    spec_compliance_results: spec_reviewer.results
  })
})
```

## Key Principles

**Two-Stage Process:** Spec compliance must pass before quality review

**Seed System Standards:** Check for progressive disclosure, portability, pattern adherence

**Actionable Feedback:** Categorize issues by severity with specific fixes

**Evidence-Based:** Cite specific examples from the code
