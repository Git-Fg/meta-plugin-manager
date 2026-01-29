---
name: ops:reflect
description: "Review conversation for improvement opportunities. Identify patterns, detect drift, suggest patches. Uses TodoWrite for patch tracking. Use when reflecting on work or ending a session."
context: fork
---

# Reflect and Patch

**Uses TodoWrite for patch tracking**

## Quick Context

Review conversation to identify patterns, detect drift, and suggest improvements.

## Workflow

### 1. Detect

Gather context:

- `Glob: .claude/workspace/current-events` → Current session events
- `Glob: .claude/workspace/handoffs/*.yaml` → Recent handoffs
- `Grep: "git diff" .claude/commands/` → Recent command changes

### 2. Ask

If needed, use recognition-based questions:

- "What patterns emerged during this session?"
- "What should be extracted as reusable commands?"

### 3. Execute

**Conversation Scan:**

- Review injected context and conversation history
- `Grep` for patterns (success or failure)
- `Grep` for issues encountered and resolutions

**Pattern Extraction:**

For each pattern identified:

- **Success pattern**: Document for future reuse
- **Anti-pattern**: Flag for avoidance or refactoring
- **Refinement opportunity**: Suggest improvement

**Drift Detection:**

- `Grep: "\.claude/.*\.claude/"` → Portable paths (no nested references)
- `Grep: "(concept|pattern).*\n.*\1"` → Centralized or scattered docs

### 4. Verify

Create patch recommendations:

1. **TodoWrite**: Create task entries for each patch
2. **Write**: SUMMARY.md with findings

## Output Format

```markdown
## Reflection Summary

### Patterns Identified

- **Pattern 1**: [Description] - [Reuse/Refactor/Ignore]
- **Pattern 2**: [Description] - [Reuse/Refactor/Ignore]

### Context Drift

- [Issue 1]: [Location] - [Fix recommendation]
- [Issue 2]: [Location] - [Fix recommendation]

### Patches Recommended

| Priority | Type     | Description            | Action                  |
| -------- | -------- | ---------------------- | ----------------------- |
| High     | Pattern  | Extract [X] as command | Create /ops:extract     |
| Medium   | Drift    | Consolidate [X]        | Inline to single source |
| Low      | Refactor | Rename [X] to [Y]      | Move file               |
```

## Usage

```
/ops:reflect
[Analyzes conversation and produces summary]
```

---

<critical_constraint>
MANDATORY: Run with context: fork for isolation
MANDATORY: Focus on actionable improvements, not general observations
MANDATORY: Use TodoWrite for patch tracking
MANDATORY: Prioritize patches (High/Medium/Low)
MANDATORY: Provide specific file locations and actions
No exceptions. Reflection must produce actionable patches.
</critical_constraint>
