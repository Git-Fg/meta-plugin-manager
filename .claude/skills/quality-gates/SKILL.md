---
name: quality-gates
description: "Enforce automated quality gates. Use when: Validating components, checking structure, or verifying portability. Not for: Manual reviews or skipping automated checks."
---

# Quality Gates

## Overview

Automated quality gate enforcement for Ralph validation and component creation. Ensures systematic quality validation through progressive disclosure verification, portability checks, and automated gates.

**Core principle:** Automated quality gates + systematic validation = consistent quality enforcement.

**CRITICAL: Evidence Before Claims**

Before claiming any quality gate passes or component is "complete" or "approved", you MUST run verification commands and provide fresh evidence. This is non-negotiable.

## Verification Protocol

### The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

If you haven't run the verification command in this message, you cannot claim it passes.

### The Gate Function

BEFORE claiming any status or expressing satisfaction:

1. **IDENTIFY**: What command proves this claim?
2. **RUN**: Execute the FULL command (fresh, complete)
3. **READ**: Full output, check exit code, count failures
4. **VERIFY**: Does output confirm the claim?
   - If NO: State actual status with evidence
   - If YES: State claim WITH evidence
5. **ONLY THEN**: Make the claim

Skip any step = lying, not verifying

### Common Verification Requirements

| Claim                | Requires                           | Not Sufficient                 |
| -------------------- | ---------------------------------- | ------------------------------ |
| Tests pass           | Test command output: 0 failures    | Previous run, "should pass"    |
| Linter clean         | Linter output: 0 errors            | Partial check, extrapolation   |
| Build succeeds       | Build command: exit 0              | Linter passing, logs look good |
| Quality gates pass   | Automated gate output: 0 failures  | Manual review, assumed correct |
| Portability verified | Portability check output: 0 issues | Code review, looks portable    |

### Evidence Examples

**✅ Correct Verification:**

```bash
[Run test command] [See: 34/34 pass] "All tests pass"
```

**❌ Incorrect Claims:**

- "Should pass now"
- "Looks correct"
- "Tests should be working"
- "Linter passed earlier"

## Red Flags - STOP

### Quality Gate Violations

- Using "should", "probably", "seems to" in quality reports
- Expressing satisfaction before verification ("Great!", "Perfect!", "Done!", etc.)
- Claiming gates pass without running automated checks
- Trusting previous verification results
- Relying on partial verification
- Accepting "close enough" on critical gates
- **ANY wording implying success without having run verification**

### Rationalization Prevention

| Excuse                                  | Reality                   |
| --------------------------------------- | ------------------------- |
| "Should work now"                       | RUN the verification      |
| "I'm confident"                         | Confidence ≠ evidence     |
| "Just this once"                        | No exceptions             |
| "Linter passed"                         | Linter ≠ gate checks      |
| "Looks good"                            | Subjective ≠ verification |
| "I'm tired"                             | Exhaustion ≠ excuse       |
| "Partial check is enough"               | Partial proves nothing    |
| "Different words so rule doesn't apply" | Spirit over letter        |

### Stop Phrases

If you catch yourself about to say any of these, STOP and verify first:

- "Should be working"
- "Looks correct"
- "Appears to pass"
- "Tested successfully" (without showing evidence)
- "Quality gates pass" (without running them)
- "All checks green" (without verification output)

## Quality Gates Checklist

### Gate 1: Structure Verification

- [ ] YAML frontmatter valid (name, description)
- [ ] File structure follows conventions
- [ ] No extraneous files (README, INSTALLATION, etc.)
- [ ] Naming conventions followed

### Gate 2: Progressive Disclosure

- [ ] Tier 1: Metadata (~100 tokens)
- [ ] Tier 2: Main content (<500 lines)
- [ ] Tier 3: References/ directory for details
- [ ] No extraneous documentation files

### Gate 3: Portability Verification

- [ ] Zero external dependencies (component works standalone)
- [ ] All context bundled in component
- [ ] Self-contained references
- [ ] No absolute paths

### Gate 4: Content Quality

- [ ] Description has trigger phrases
- [ ] Imperative voice for instructions
- [ ] Expert-only knowledge (no Claude-obvious)
- [ ] Clear examples provided

### Gate 5: Test Coverage

- [ ] Tests exist for component
- [ ] Tests verify behavior (not mocks)
- [ ] Edge cases covered
- [ ] Tests run successfully

## Key Principles

1. **Automated gates** - Consistent quality enforcement
2. **Progressive disclosure** - Proper tier structure
3. **Portability first** - Zero external dependencies
4. **Test coverage** - Comprehensive testing
5. **Systematic validation** - Same checks every time

Quality gates ensure consistent, automated quality enforcement for all components.
