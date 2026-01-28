---
name: handoff:resume
description: Resume work by injecting the latest handoff context using !{command} syntax to auto-find and cat the most recent handoff file.
disable-model-invocation: true
allowed-tools: Read, Write, Bash, Glob
---

<mission_control>
<objective>Resume work by extracting and injecting the latest handoff context using shell command substitution</objective>
<success_criteria>Latest handoff found via !{command}, context injected, previous handoffs archived</success_criteria>
</mission_control>

<interaction_schema>
find_latest_handoff → archive_old_handoffs → inject_context → confirm
</interaction_schema>

# Handoff Resume

Resume work by injecting the latest handoff context using shell command substitution.

## What This Command Does

1. **Find** the most recent handoff using `!{command}` syntax
2. **Archive** old handoffs with timestamp suffix
3. **Inject** the handoff content as immediate context

## How It Works

### Phase 1: Find Latest Handoff with Command Substitution

Use shell command substitution to auto-find the latest handoff:

```bash
# Find most recently modified handoff
LATEST=!{ls -t .claude/workspace/handoffs/*.yaml 2>/dev/null | head -1}

if [ -z "$LATEST" ]; then
  echo "No handoffs found in .claude/workspace/handoffs/"
  exit 1
fi

echo "Found: $LATEST"
!{cat "$LATEST"}
```

**Command substitution pattern:**

- `!{ls -t ... | head -1}` - Finds latest file
- `!{cat "$(ls -t ... | head -1)"}` - Inlines content directly

### Phase 2: Archive Old Handoffs

Before resuming, archive any existing handoffs:

```bash
# Archive all existing handoffs with timestamp
for f in .claude/workspace/handoffs/*.yaml; do
  [ -f "$f" ] || continue
  TIMESTAMP=!{date +%Y%m%d_%H%M%S}
  mv "$f" ".attic/!{basename "$f" .yaml}_old_${TIMESTAMP}.yaml"
done
```

### Phase 3: Inject Handoff Context

Read and format the handoff for context injection:

```bash
# Load latest handoff
HANDOFF=!{ls -t .claude/workspace/handoffs/*.yaml 2>/dev/null | head -1}

# Extract key fields
GOAL=!{grep "^goal:" "$HANDOFF" | sed 's/^goal: //'}
NOW=!{grep "^now:" "$HANDOFF" | sed 's/^now: //'}

echo "=== RESUMING SESSION ==="
echo "Goal: $GOAL"
echo "Now: $NOW"
echo ""
echo "Full handoff:"
!{cat "$HANDOFF"}
```

## Inline Command Substitution Examples

```bash
# Direct inline content
!{cat "$(ls -t .claude/workspace/handoffs/*.yaml | head -1)"}

# With echo prefix
echo "=== LATEST HANDOFF ==="
!{cat "$(ls -t .claude/workspace/handoffs/*.yaml 2>/dev/null | head -1)"}

# Parse specific fields
echo "Goal: !{grep '^goal:' \"$(ls -t .claude/workspace/handoffs/*.yaml | head -1)\" | sed 's/^goal: //'}"
echo "Now: !{grep '^now:' \"$(ls -t .claude/workspace/handoffs/*.yaml | head -1)\" | sed 's/^now: //'}"
```

## Quick Resume Pattern

```bash
# One-liner resume
!{cat "$(ls -t .claude/workspace/handoffs/*.yaml 2>/dev/null | head -1)"}

# With archive
for f in .claude/workspace/handoffs/*.yaml; do [ -f "$f" ] && mv "$f" ".attic/!{basename "$f" .yaml}_resumed_!{date +%Y%m%d_%H%M%S}.yaml"; done && !{cat "$(ls -t .claude/workspace/handoffs/*.yaml 2>/dev/null | head -1)"}
```

## Handoff Format Reference

The handoff YAML structure:

```yaml
---
date: YYYY-MM-DD
session: { session-name }
status: complete|partial|blocked
outcome: SUCCEEDED|PARTIAL_PLUS|PARTIAL_MINUS|FAILED
---
goal: { What this session accomplished }
now: { What next session should do first }
test: { Verification command }

done_this_session:
  - task: { Task name }
    files: [{ file1 }, { file2 }]

blockers: [{ Any blocking issues }]
questions: [{ Unresolved questions }]
decisions:
  - { name }: { rationale }
findings:
  - { name }: { details }
worked: [{ What worked }]
failed: [{ What failed }]
next:
  - { Next step 1 }
  - { Next step 2 }
files:
  created: [{ Created files }]
  modified: [{ Modified files }]
```

## Best Practices

- Use `!{command}` for inline execution and substitution
- Always archive old handoffs before resuming
- Extract `goal` and `now` for immediate context
- Keep the full handoff for detailed reference

## Recognition Questions

- "Is this the correct handoff to resume?"
- "Have all old handoffs been archived?"
- "Is the 'now' field clear for immediate action?"

<critical_constraint>
MANDATORY: Use !{command} syntax for auto-finding and inlining handoff content
MANDATORY: Archive old handoffs with timestamp before resuming
MANDATORY: Extract goal/now fields for immediate context visibility
MANDATORY: Preserve all handoff fields in context injection
No exceptions. Resume must enable seamless continuation with command substitution.
</critical_constraint>
