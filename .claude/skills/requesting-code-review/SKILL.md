---
name: requesting-code-review
description: "Request code reviews when preparing code for review or verifying readiness. Not for actual reviewing or incomplete work."
---

# Requesting Code Review

## Overview

Request code review with systematic preparation. Ensures all code is reviewed through spec compliance and quality stages before merging.

**Core principle:** Spec compliance first + quality review second = systematic code review.

## When to Use

**Use when:**

- Requesting code review for implementation
- Preparing code for merge/PR
- Ensuring systematic review process

**Don't use when:**

- Emergency fixes (use emergency workflow)
- Trivial changes (use judgment)

## Pre-Review Checklist

Before requesting review:

### Code Quality

- [ ] All tests passing
- [ ] Code follows existing patterns
- [ ] No dead code or TODO comments
- [ ] Proper error handling
- [ ] Clear naming conventions
- [ ] Consistent formatting

### Documentation

- [ ] Code comments where needed
- [ ] README updated if applicable
- [ ] API documentation updated
- [ ] CHANGELOG updated

### Testing

- [ ] Unit tests added/updated
- [ ] Integration tests passing
- [ ] Edge cases covered
- [ ] Error scenarios tested

### Self-Review

- [ ] Reviewed own code first
- [ ] Fixed obvious issues
- [ ] Verified against requirements
- [ ] Checked portability

## Two-Stage Review Process

### Stage 1: Spec Compliance Review

**Purpose:** Verify implementation matches requirements exactly.

**Reviewer checks:**

- [ ] All requirements implemented?
- [ ] No extra features added?
- [ ] Blueprint/spec followed?
- [ ] Acceptance criteria met?

**Report format:**

```
✅ Spec Compliant
```

OR

```
❌ Issues Found:
- Missing: [specific requirement] (file:line)
- Extra: [unrequested feature] (file:line)
- Misunderstood: [requirement interpretation] (file:line)
```

### Stage 2: Quality Review

**Purpose:** Verify implementation quality and maintainability.

**Reviewer checks:**

- [ ] Code quality standards met
- [ ] Clear naming and structure
- [ ] Proper error handling
- [ ] Tests comprehensive
- [ ] Documentation complete
- [ ] Seed System patterns followed

**Report format:**

```
Strengths:
- [what was done well]

Issues:
- Critical: [must fix before merge]
- Important: [should fix for quality]
- Minor: [nice to have]

Assessment: Approved / Needs fixes
```

## Request Format

### For Manual Review

```markdown
## Code Review Request

**Changes:**

- [File 1]: [Description]
- [File 2]: [Description]

**Purpose:** [Why these changes]

**Testing:**

- [Test results]
- [How to verify]

**Notes:**
[Any important context]

Ready for review.
```

## Reviewer Guidelines

### For Spec Compliance Reviewers

**DO:**

- Verify requirements line by line
- Check for missing features
- Check for extra work
- Compare against blueprint/spec
- Cite specific file:line references

**DON'T:**

- Review code quality (that's Stage 2)
- Trust the implementation report
- Assume requirements are met
- Skip verification

### For Quality Reviewers

**DO:**

- Check code quality and structure
- Verify tests are comprehensive
- Ensure documentation is complete
- Follow Seed System patterns
- Categorize issues by severity

**DON'T:**

- Review spec compliance (already done in Stage 1)
- Accept "good enough" quality
- Skip error handling checks
- Ignore test coverage

## Example Workflow

### Complete Review Request

```
## Code Review Request

**Component:** User Authentication Skill
**Type:** Skill
**Files Changed:**
- .claude/skills/auth/SKILL.md
- .claude/skills/auth/references/examples.md
- tests/test_auth_skill.py

### Requirements
From blueprint.yaml:
- Implement OAuth authentication
- Support Google and GitHub providers
- Include token refresh
- Add logout functionality

### Implementation Summary
Built skill with:
- OAuth flow for Google and GitHub
- Token management (refresh, expiration)
- Logout endpoint
- Complete test coverage (95%)

### Testing
- Unit tests: 15/15 passing
- Integration tests: 8/8 passing
- Coverage: 95%
- Manual testing: OAuth flows verified

### Two-Stage Review

**Stage 1: Spec Compliance**
Please verify:
- [ ] All 4 requirements implemented?
- [ ] OAuth authentication (Google + GitHub)?
- [ ] Token refresh working?
- [ ] Logout functionality complete?
- [ ] No extra features added?

**Stage 2: Quality Review**
Please verify:
- [ ] Code follows Seed System patterns?
- [ ] Progressive disclosure tiers present?
- [ ] Test coverage adequate?
- [ ] Documentation clear and complete?
- [ ] Error handling proper?

Ready for review through both stages.
```

## Review Response

### Spec Compliance Response

```
✅ **Spec Compliance: PASS**

All requirements verified:
- ✅ OAuth authentication (Google + GitHub) - SKILL.md:45-78
- ✅ Token refresh - SKILL.md:89-112
- ✅ Logout functionality - SKILL.md:123-145
- ✅ No extra features

Ready for Stage 2: Quality Review.
```

OR

```
❌ **Spec Compliance: ISSUES FOUND**

Issues:
- Missing: Token refresh not implemented (SKILL.md:89-112 shows placeholder)
- Misunderstood: Logout clears token but doesn't revoke (requirements say "revoke")

Please fix these issues before Stage 2 review.
```

### Quality Review Response

```
✅ **Quality Review: APPROVED**

**Strengths:**
- Excellent test coverage (95%)
- Clear progressive disclosure structure
- Comprehensive examples in references/
- Proper error handling throughout

**Issues:**
- Minor: Could add more inline comments (Critical: none, Important: none, Minor: 1)

**Assessment:** Approved - Ready to merge
```

OR

```
❌ **Quality Review: NEEDS FIXES**

**Strengths:**
- Good test coverage
- Clear structure

**Issues:**
- Critical: Missing error handling for invalid tokens (SKILL.md:67)
- Important: Test coverage gap in token refresh (tests/test_auth.py:45-67)

Please fix Critical and Important issues before merge.
```

## Common Issues

### Spec Compliance Issues

**Missing Requirements:**

- Implementation doesn't include all features
- Acceptance criteria not met
- Edge cases not handled

**Extra Work:**

- Features not in requirements
- Scope creep
- "Nice to have" additions

**Misunderstanding:**

- Requirements interpreted incorrectly
- Wrong approach taken
- Blueprint not followed

### Quality Issues

**Code Quality:**

- Poor naming conventions
- Complex logic not simplified
- No error handling
- Inconsistent formatting

**Testing:**

- Low coverage
- Missing edge cases
- Brittle tests
- No integration tests

**Documentation:**

- Unclear descriptions
- Missing examples
- No troubleshooting guide
- Outdated information

## Red Flags

**Before Requesting Review:**

- [ ] Tests not all passing
- [ ] Self-review skipped
- [ ] Requirements not verified
- [ ] Documentation incomplete

**During Review:**

- [ ] Spec compliance not verified first
- [ ] Quality reviewed before spec compliance
- [ ] Issues ignored or deferred
- [ ] "Good enough" accepted

## Key Principles

1. **Spec first, quality second** - Order matters
2. **Systematic verification** - Checklists ensure nothing missed
3. **Evidence-based** - Cite file:line references
4. **Categorize issues** - Critical, Important, Minor

## Quick Reference

| Stage               | Purpose            | Checks                                     |
| ------------------- | ------------------ | ------------------------------------------ |
| **Spec Compliance** | Match requirements | All features, no extra, blueprint followed |
| **Quality**         | Code quality       | Standards, tests, docs, patterns           |

Requesting code review systematically ensures high-quality implementations through spec compliance and quality verification.

---

<critical_constraint>
MANDATORY: Complete spec compliance review BEFORE quality review
MANDATORY: Verify all tests pass before requesting review
MANDATORY: Cite specific file:line references for issues
MANDATORY: Categorize issues by severity (Critical/Important/Minor)
No exceptions. Systematic review prevents merge of substandard code.
</critical_constraint>
