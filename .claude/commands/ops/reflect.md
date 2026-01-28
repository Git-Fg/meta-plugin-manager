---
description: "Review conversation for improvement opportunities. Identify patterns, detect drift, suggest patches. Use when reflecting on work or ending a session."
context: fork
---

<mission_control>
<objective>Analyze conversation for improvement opportunities and generate patch recommendations</objective>
<success_criteria>Patches identified with priority, reflection summary produced</success_criteria>
</mission_control>

# Reflect and Patch

Review conversation to identify patterns, detect drift, and suggest improvements.

## What This Does

1. **Scan conversation** - Review recent messages, decisions, and code changes
2. **Identify patterns** - Extract reusable workflows or anti-patterns observed
3. **Detect drift** - Find context scattered across files or duplicated content
4. **Generate patches** - Suggest specific improvements with priorities

## Process

### Phase 1: Conversation Scan

Review:

- `Bash: git diff HEAD~10 --stat` → Recent changes
- `Read: conversation history` → Decisions and rationale
- `Grep: conversation` → Extract patterns used (success or failure)
- `Grep: conversation` → Identify issues encountered and resolutions

### Phase 2: Pattern Extraction

For each pattern identified:

- **Success pattern**: Document for future reuse
- **Anti-pattern**: Flag for avoidance or refactoring
- **Refinement opportunity**: Suggest improvement

### Phase 3: Drift Detection

Check:

- `Bash: git status --porcelain .claude/` → New files in correct locations
- `Grep: "\.claude/.*\.claude/" .claude/` → Portable paths (no nested .claude references)
- `Grep: "(concept|pattern).*\n.*\1" skills/` → Centralized or scattered documentation

### Phase 4: Patch Generation

Generate recommendations with `Write: SUMMARY.md`

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

**Direct invocation:**

```
/ops:reflect
[Analyzes conversation and produces summary]
```

**After session end:**

```
/ops:reflect
[Generate patches for next session]
```

---

<critical_constraint>
MANDATORY: Run with context: fork for isolation
MANDATORY: Focus on actionable improvements, not general observations
MANDATORY: Prioritize patches (High/Medium/Low)
MANDATORY: Provide specific file locations and actions
No exceptions. Reflection must produce actionable patches.
</critical_constraint>
