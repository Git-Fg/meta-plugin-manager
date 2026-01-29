---
name: handoff:create
description: "Create or update structured handoff document for session continuity. Use when pausing work and need to preserve context for next session."
argument-hint: "[session-name]"
---

# Handoff Creation

<mission_control>
<objective>Create or update a structured YAML handoff document for seamless context preservation across sessions</objective>
<success_criteria>Handoff saved with goal/now fields, file locations, decisions, and next steps</success_criteria>
</mission_control>

## Existing handoffs

```
!`find .claude/workspace/handoffs -maxdepth 1 -type f ! -name ".*" ! -path "*/.*" 2>/dev/null | sort`
```

If `handoff.yaml` exists: Archive before creating new one

## Action

If file doesn't exist: Create new handoff

If file exists and needs complete replacement:

```
mv .claude/workspace/handoffs/handoff.yaml .claude/workspace/handoffs/.attic/handoff_$(date +%Y%m%d_%H%M%S).yaml 2>/dev/null || true
```

If file exists and needs update: Merge new content with existing

## Document Session

Extract session name from `$ARGUMENTS` or conversation context.

### Core Fields (Required)

```yaml
---
date: YYYY-MM-DD
session: { session-name }
status: { complete|partial|blocked }
outcome: { SUCCEEDED|PARTIAL_PLUS|PARTIAL_MINUS|FAILED }
---
goal: { What this session accomplished - for statusline }
now: { What next session should do first - for statusline }
test: { Command to verify continuation works }
```

### Session Work (Required)

```yaml
done_this_session:
  - task: { Task name }
    files: [{ file1.py }, { file2.py }]
    changes: { Brief description of changes }
```

### Context (Required)

```yaml
decisions:
  - { decision_name }: { rationale }

blockers: [{ any blocking issues }]

questions: [{ unresolved questions for next session }]

next:
  - { First next step }
  - { Second next step }
```

### Optional Enhancements

```yaml
findings:
  - { key_finding }: { details }

worked: [{ approaches that worked }]

failed: [{ approaches that failed and why }]

files:
  created: [{ new files }]
  modified: [{ changed files }]
```

## Save

```
Write: .claude/workspace/handoffs/handoff.yaml
```

---

<critical_constraint>
MANDATORY: Use exact YAML format with goal/now/test fields
MANDATORY: Archive via mv before write if complete replacement
MANDATORY: Include precise file locations (path:line format)
MANDATORY: Document decisions with rationale
No exceptions. Handoffs must enable zero-information-loss context switches.
</critical_constraint>
