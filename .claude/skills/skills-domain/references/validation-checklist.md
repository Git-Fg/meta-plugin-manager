# Post-Implementation Validation Checklist

Production readiness verification for skill improvements.

---

## Overview

After applying all improvements, verify the skill meets production standards using this comprehensive checklist.

---

## Tier 1 Validation ✓

```
□ YAML frontmatter present
□ Name in kebab-case (2-4 words)
□ Description follows What-When-Not framework
□ Description <200 characters
□ Description contains no "how" language
□ user-invocable set appropriately
```

---

## Tier 2 Validation ✓

```
□ SKILL.md <500 lines
□ All 4 workflows documented (ASSESS, CREATE, EVALUATE, ENHANCE)
□ Completion marker present: ## SKILLS_ARCHITECT_COMPLETE
□ Security validation section included
□ Decision trees and examples provided
□ Troubleshooting scenarios documented
```

---

## Tier 3 Validation ✓

```
□ references/ directory present (if SKILL.md >500 lines)
□ Reference files properly structured
□ URL validation patterns included
□ Quality framework documented
```

---

## Quality Score Validation ✓

```
□ Knowledge Delta: ≥16/20
□ Autonomy: ≥12/15 (80%+)
□ Discoverability: ≥12/15
□ Progressive Disclosure: ≥12/15
□ Overall Score: ≥128/160 (Grade B or higher)
```

---

## Security Validation ✓

```
□ URL validation implemented
□ Input sanitization documented
□ Safe execution patterns included
□ Workflow protection mechanisms present
```

---

## Autonomy Validation ✓

```
□ Examples provided for all workflows
□ Decision trees included
□ Edge cases documented
□ Troubleshooting scenarios covered
□ Questions minimized (target 0-3)
```

---

## Performance Validation ✓

```
□ Workflow detection optimized (fast-path checks)
□ Minimal filesystem operations
□ Early returns for explicit requests
□ Context-aware detection
```

---

## Self-Review Validation

**To validate your own skill improvements:**

### 1. Calculate Quality Score
- Run EVALUATE workflow
- Check all 11 dimensions
- Verify ≥128/160 threshold

### 2. Test Autonomy
- Run skill in test environment
- Count questions asked
- Verify 0-3 questions (80-95% autonomy)

### 3. Verify Progressive Disclosure
- Check SKILL.md line count (<500)
- Verify references/ structure if needed
- Test auto-discovery

### 4. Validate Security
- Check URL validation patterns
- Verify input sanitization
- Test safe execution guards

### 5. Confirm Standards Compliance
- YAML frontmatter valid
- Completion markers present
- Tier structure correct

---

## Production Readiness Criteria

**Skill is ready when all checkboxes ✓ and score ≥128/160.**

---

## See Also

- [quality-framework.md](../quality-framework.md) - 11-dimensional scoring details
- [autonomy-design.md](../autonomy-design.md) - Autonomy testing patterns
- [workflow-examples.md](workflow-examples.md) - Workflow examples and edge cases
