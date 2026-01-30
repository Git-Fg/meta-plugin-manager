---
description: "Review architecture. Use when assessing component organization. Keywords: architecture, review, components, structure."
argument-hint: "[area]"
---

<mission_control>
<objective>Review component architecture and organization</objective>
<success_criteria>Architecture review completed with health assessment</success_criteria>
</mission_control>

## Quick Start

**If reviewing architecture:** Review .claude/, explore codebase, ask questions iteratively, report findings.

## Patterns

### Architecture Review Flow

1. **Review .claude/** - Examine organization
2. **Explore codebase** - Find structure issues
3. **Ask questions** - use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively to clarify areas
4. **Report findings** - Document structure assessment
5. **Confirm** - Present for approval

### Architecture Quality Patterns

| Issue | Description | Fix |
|-------|-------------|-----|
| Deep nesting | Too many folder levels | Flatten structure |
| Inconsistent naming | Different conventions | Standardize naming |
| Orphaned components | Components not referenced | Remove or link |
| Mixed concerns | Files in wrong locations | Reorganize |
| Missing organization | No logical grouping | Add structure |

---

<critical_constraint>
Trust Claude to identify structure issues from codebase. use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively until areas are clear.
</critical_constraint>
