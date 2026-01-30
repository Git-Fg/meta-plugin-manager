---
description: "Review project health. Use when auditing components or architecture. Keywords: review, audit, quality, components, architecture."
argument-hint: "[component]"
---

<mission_control>
<objective>Review project components and architecture</objective>
<success_criteria>Review completed with health assessment</success_criteria>
</mission_control>

## Quick Start

**If reviewing project:** Review .claude/, explore codebase, ask questions iteratively, report findings.

## Patterns

### Review Flow

1. **Review .claude/** - Examine components for issues
2. **Explore codebase** - Find related context
3. **Ask questions** - use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively to clarify scope
4. **Report findings** - Document health assessment
5. **Confirm** - Present for approval

### Review Dimensions

| Dimension | What to Check |
|-----------|---------------|
| Completeness | All expected components present |
| Consistency | Same patterns across components |
| Quality | Follows best practices |
| Currency | No outdated references |
| Coverage | No orphaned or duplicate files |

---

<critical_constraint>
Trust Claude to identify issues from codebase. use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively until scope is clear.
</critical_constraint>
