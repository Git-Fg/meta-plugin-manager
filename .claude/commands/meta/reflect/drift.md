---
description: "Detect context drift. Use when knowledge is scattered across files. Keywords: drift, detect, context, scattered."
argument-hint: "[area]"
---

<mission_control>
<objective>Identify and fix context drift in project</objective>
<success_criteria>Drift identified with consolidation proposed</success_criteria>
</mission_control>

## Quick Start

**If detecting drift:** Review .claude/, explore codebase, ask questions iteratively, consolidate knowledge.

## Patterns

### Drift Detection Flow

1. **Review .claude/** - Identify scattered or duplicate knowledge
2. **Explore codebase** - Find inconsistencies
3. **Ask questions** - use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively to clarify areas
4. **Consolidate** - Merge duplicate content
5. **Confirm** - Present changes for approval

### Drift Types

| Type | Description | Example |
|------|-------------|---------|
| Duplicate | Same info in multiple places | Rules in CLAUDE.md and .claude/rules/ |
| Stale | Info outdated but still present | Old tool references |
| Orphaned | Files referencing non-existent items | Links to deleted docs |
| Inconsistent | Conflicting guidance | Different conventions in different files |

---

<critical_constraint>
Trust Claude to identify drift from codebase. use askuserquestion within concrete, actionable propositions (user don't have to type anything : never ask question you can infer from exploring/investigating) iteratively until areas are clear.
</critical_constraint>
