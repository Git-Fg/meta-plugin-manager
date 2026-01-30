---
description: "Refine documentation for consistency. Use when documentation has drifted. Keywords: refine, docs, update, improve, documentation."
argument-hint: "[doc-name]"
---

<mission_control>
<objective>Analyze and improve project documentation</objective>
<success_criteria>Documentation refined with identified drift and proposed fixes</success_criteria>
</mission_control>

## Quick Start

**If refining documentation:** Review docs, explore codebase, ask questions iteratively, apply fixes.

## Patterns

### Documentation Refinement Flow

1. **Review documentation** - Examine AGENTS.md, README.md for issues
2. **Explore codebase** - Identify drift between docs and code
3. **Ask questions** - use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively to clarify what, how
4. **Apply fixes** - Update documentation
5. **Confirm** - Present changes for approval

### Documentation Quality Patterns

| Issue | Fix |
|-------|-----|
| Outdated information | Update to reflect current state |
| Missing sections | Add missing content |
| Inconsistent style | Align with project conventions |
| Poor structure | Reorganize for clarity |
| Code-doc mismatch | Sync with actual implementation |

---

<critical_constraint>
Trust Claude to identify documentation drift from codebase. use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively until scope is clear.
</critical_constraint>
