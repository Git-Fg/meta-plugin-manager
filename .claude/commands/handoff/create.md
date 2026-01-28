---
name: handoff
description: "Create structured handoff document for pausing work and resuming in fresh context. Preserves task boundaries, work completed, work remaining, and critical context. Not for active work sessions during ongoing development."
disable-model-invocation: true
allowed-tools: Read, Write, Bash
---

<mission_control>
<objective>Create structured handoff document for seamless context preservation across sessions</objective>
<success_criteria>Handoff saved with YAML format, goal/now fields, file locations, and next steps</success_criteria>
</mission_control>

<interaction_schema>
check_existing → generate_yaml → save_handoff → confirm
</interaction_schema>

# Handoff: Context Preservation

Create structured handoff documents for seamless continuation of work across different conversation contexts.

## What This Command Does

Generate a comprehensive handoff document that preserves:

- Original task and objectives
- Work completed with precise locations
- Work remaining with priorities
- Critical context and decisions
- Current state of deliverables

## How It Works

### Phase 1: Check Existing Handoff

Before creating a new handoff, archive any existing one:

- `Glob: .claude/workspace/handoffs/*.yaml` → Find existing handoffs
- `Bash: for f in .claude/workspace/handoffs/*.yaml; do [ -f "$f" ] && mv "$f" ".attic/$(basename "$f" .yaml)_$(date +%Y%m%d_%H%M%S).yaml"; done` → Archive existing with timestamp

### Phase 2: Generate Handoff Document

Create structured YAML document with this EXACT format:

```yaml
---
date: YYYY-MM-DD
session: { session-name }
status: complete|partial|blocked
outcome: SUCCEEDED|PARTIAL_PLUS|PARTIAL_MINUS|FAILED
---
goal: { What this session accomplished - shown in statusline }
now: { What next session should do first - shown in statusline }
test: { Command to verify this work, e.g., pytest tests/test_foo.py }

done_this_session:
  - task: { First completed task }
    files: [{ file1.py }, { file2.py }]
  - task: { Second completed task }
    files: [{ file3.py }]

blockers: [{ any blocking issues }]

questions: [{ unresolved questions for next session }]

decisions:
  - { decision_name }: { rationale }

findings:
  - { key_finding }: { details }

worked: [{ approaches that worked }]

failed: [{ approaches that failed and why }]

next:
  - { First next step }
  - { Second next step }

files:
  created: [{ new files }]
  modified: [{ changed files }]
```

**Field guide:**

- `goal:` + `now:` - REQUIRED, shown in statusline
- `done_this_session:` - What was accomplished with file references
- `decisions:` - Important choices and rationale
- `findings:` - Key learnings
- `worked:` / `failed:` - What to repeat vs avoid
- `next:` - Action items for next session

### Phase 3: Save Handoff

Save to standardized location with timestamp naming:

- `Bash: echo 'HANDOFF_FILE=".claude/workspace/handoffs/$(date +%Y-%m-%d_%H-%M)-[task-name].yaml"'` → Generate filename
- `Write: .claude/workspace/handoffs/YYYY-MM-DD_HH-MM-[task-name].yaml` → Save YAML content

**File naming**: `YYYY-MM-DD_HH-MM-[descriptive-name].yaml`

### Phase 4: Resume from Handoff

When resuming work, use command substitution to load the latest handoff:

- `Bash: ls -t .claude/workspace/handoffs/*.yaml 2>/dev/null | head -1` → Get latest handoff path

## Reading Latest Handoff

When resuming work, use command substitution to load the latest handoff:

- `Bash: ls -t .claude/workspace/handoffs/*.yaml 2>/dev/null | head -1` → Get latest handoff path

**Method 1: Assign to variable**

```
LATEST=$(ls -t .claude/workspace/handoffs/*.yaml | head -1)
echo "Resuming from: $LATEST"
cat "$LATEST"
```

**Method 2: Direct command substitution**

```
!cat $(ls -t .claude/workspace/handoffs/*.yaml | head -1)
```

**Method 3: One-liner with inline display**

```
!cat $(ls -t .claude/workspace/handoffs/*.yaml 2>/dev/null | head -1)
```

## Handoff Structure Examples

### Example: Component Creation

```yaml
---
date: 2026-01-28
session: mcp-orchestrator
status: partial
outcome: PARTIAL_PLUS
---
goal: Implemented LLM orchestrator with Perplexity/Gemini integration
now: Complete MCP server implementation with test coverage
test: pnpm test --testNamePattern="orchestrator"

done_this_session:
  - task: Created LLM orchestrator core
    files: [src/orchestrator/index.ts:1-150]
  - task: Implemented Perplexity provider
    files: [src/providers/perplexity.ts:1-80]
  - task: Implemented Gemini providers
    files: [src/providers/gemini-pro.ts, src/providers/gemini-flash.ts]

blockers: []

questions: [Should we add caching layer for API responses?]

decisions:
  - unified_interface: "Single interface for all LLM providers"
  - streaming_support: "Deferred for v1.0"

findings:
  - provider_patterns: "All providers share similar request/response structure"

worked: [provider abstraction, TypeScript interfaces]

failed: []

next:
  - Add test coverage
  - Document API
  - Create examples

files:
  created: [src/providers/, src/orchestrator/]
  modified: []
```

## Best Practices

### When Creating Handoffs

- Be specific about file locations (use file:line format)
- Document WHY decisions were made, not just WHAT
- Include dead ends to avoid repeating mistakes
- Prioritize remaining work clearly
- Make the next step unambiguous

### When Resuming from Handoffs

- `Bash: ls -t .claude/workspace/handoffs/*.yaml | head -1` → Get latest handoff
- `Grep: "^goal:" .claude/workspace/handoffs/*.yaml | sed 's/^goal: //'` → Extract goal
- `Grep: "^now:" .claude/workspace/handoffs/*.yaml | sed 's/^now: //'` → Extract now

## Recognition Questions

Before creating handoff, ask:

- "Is all critical work documented?"
- "Are file locations precise?"
- "Is the next step clear and unambiguous?"
- "Would a fresh context understand everything needed?"

<critical_constraint>
MANDATORY: Use exact YAML format with goal/now fields for statusline
MANDATORY: Include precise file locations (path:line format)
MANDATORY: Document dead ends and failed approaches
MANDATORY: Archive existing handoffs before creating new one
No exceptions. Handoffs must enable zero-information-loss context switches.
</critical_constraint>
