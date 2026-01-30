---
description: "Create structured handoff document for session continuity. Use when pausing work and need to preserve context. Supports quick and full handoffs."
argument-hint: "[--quick|--full] [session-name]"
---

<mission_control>
<objective>Create or update a structured YAML handoff document for seamless context preservation</objective>
<success_criteria>Handoff saved with appropriate context level based on flags</success_criteria>
</mission_control>

## Quick Start

**Default (full handoff):** `/handoff [session-name]` - Complete context preservation
**Quick handoff:** `/handoff --quick [session-name]` - Essential fields only

## Handoff Types

| Type | File | Use when |
|------|------|----------|
| `--full` (default) | `handoff-full.yaml` | Complete context preservation with git state |
| `--quick` | `handoff.yaml` | Essential fields only, faster creation |

## Existing Handoffs

```
!`find .claude/workspace/handoffs -maxdepth 1 -type f ! -name ".*" ! -path "*/.*" 2>/dev/null | sort`
```

## Quick Handoff Fields

```yaml
---
date: YYYY-MM-DD
session: { session-name }
status: { complete|partial|blocked }
outcome: { SUCCEEDED|PARTIAL_PLUS|PARTIAL_MINUS|FAILED }
---
goal: { What this session accomplished }
now: { What next session should do first }
test: { Command to verify continuation works }
done_this_session:
  - task: { Task name }
    files: [{ file1.py }, { file2.py }]
    changes: { Brief description }
decisions:
  - { decision_name }: { rationale }
blockers: [{ blocking issues }]
questions: [{ unresolved questions }]
next:
  - { First next step }
```

## Full Handoff (Default)

Includes everything in quick handoff PLUS:

```yaml
git:
  branch: !`git branch --show-current`
  commit: !`git rev-parse HEAD`
  status: !`git status --porcelain`
  log: !`git log --oneline -5`
  diff_summary: !`git diff --stat HEAD`
files:
  created: [{ new files }]
  modified: [{ changed files }]
  deleted: [{ deleted files }]
findings:
  - { key_finding }: { details }
worked: [{ approaches that worked }]
failed: [{ approaches that failed }]
```

## Argument Handling

- `--quick` or `-q`: Create minimal handoff to `handoff.yaml`
- `--full` or no flag (default): Create full handoff to `handoff-full.yaml`
- `[session-name]`: Optional session name (derived from context if omitted)

## Archive Behavior

If handoff file exists, archive before creating new:

```
mv .claude/workspace/handoffs/{handoff,handoff-full}.yaml .claude/workspace/handoffs/.attic/{handoff,handoff-full}_$(date +%Y%m%d_%H%M%S).yaml 2>/dev/null || true
```

## Save Location

- Quick: `.claude/workspace/handoffs/handoff.yaml`
- Full: `.claude/workspace/handoffs/handoff-full.yaml`

---

<critical_constraint>
MANDATORY: Use exact YAML format with goal/now/test fields
MANDATORY: Archive via mv before write if complete replacement
MANDATORY: Include precise file locations (path:line format)
MANDATORY: Document decisions with rationale
MANDATORY: `--full` includes git state and all context
No exceptions. Handoffs must enable zero-information-loss context switches.
</critical_constraint>
