---
name: claude-md-manager
description: "Maintain CLAUDE.md project memory. Use to CREATE (new projects), REFACTOR (cleanup), or ACTIVE-LEARN (capture insights).  Triggers: 'update claude.md', 'update claude rules', 'fix documentation', 'save this learning'."
user-invocable: true
---

# CLAUDE.md Manager

**Goal**: Maintain a high-signal, expert-level `CLAUDE.md` that captures **Project Memory**.

## core_directive
"Trust your intelligence. You are a senior engineer. You know what generic documentation looks like (bad). You know what specific, high-value insights look like (good). Manage `CLAUDE.md` to reflect the latter."

## decision_logic

### 1. Detect Mode
- **No CLAUDE.md?** → `CREATE` (Scan project, pick template, generating valid commands).
- **Conversation has insights?** → `ACTIVE-LEARN` (Extract findings, update file).
- **File is messy/generic?** → `REFACTOR` (Apply Delta Standard, cut tutorials).
- **Just checking?** → `AUDIT` (Rate quality).

### 2. Apply Quality Standards (The Scorecard)
Aim for **A (90-100)**.

| Criteria | Points | Target |
|----------|--------|--------|
| **Delta** | 40 | **CRITICAL**: 100% Project Specific. Zero tutorials. |
| **Utility** | 30 | Commands are actionable, specific, and tested. |
| **Structure**| 15 | Clean headers. Modular if >200 lines (`.claude/rules/`). |
| **Context** | 15 | Explains "Why" and "When", not just "What". |

## reference_library
- [references/principles.md](references/principles.md) (The Core Philosophy)
- [references/workflow-examples.md](references/workflow-examples.md) (Inspiration Patterns)

## output_format
```markdown
## CLAUDE_MD_MANAGER_COMPLETE
Mode: [CREATE|REFACTOR|ACTIVE-LEARN]
Score: [0-100]
Action: [What you did]
```
