---
name: ops/reflect-and-patch
description: "Analyze user corrections, read session transcripts, and proactively update .claude/rules/ or SKILL.md files to prevent recurrence. Not for debugging code errors or handling exceptions during execution."
user-invocable: true
---

# Reflect & Patch

<mission_control>
<objective>Enable Claude to learn from user corrections by analyzing session data and proactively updating its own rules/skills to prevent recurrence</objective>
<success_criteria>After invocation: 1) Session transcript analyzed, 2) Root cause identified, 3) Relevant rule/SKILL.md updated, 4) Change documented with transparency</success_criteria>
</mission_control>

Think of this skill as **self-diagnostic surgery**—when Claude makes a mistake that the user corrects, this skill investigates why and patches the relevant rule to prevent recurrence.

## What This Skill Does

1. **Detects correction triggers** - User says "no", "wrong", "not what I asked", etc.
2. **Reads session transcript** - Accesses `@.claude/transcripts/last-session.jsonl`
3. **Classifies failure type** - Uses correction-patterns.md to categorize the mistake
4. **Identifies root cause** - Why did the mistake occur?
5. **Determines target file** - Which rule or SKILL.md needs patching?
6. **Applies patch strategy** - Uses patch-strategies.md to update the file
7. **Reports transparently** - Explains what was changed and why

## Trigger Conditions

### Auto-Invocation (Primary)

Claude should invoke this skill when it detects:

- User says "no", "wrong", "stop", "not what I asked", "actually..."
- User explicitly rejects Claude's output ("That's not what I meant")
- Claude recognizes its own mistake through user feedback

**Example internal dialogue:**

> "I see I made a mistake with the directory structure. I'm invoking `ops/reflect-and-patch` to update my project rules so I don't do that again."

### Manual Invocation

Users can explicitly request:

- "reflect on last session"
- "analyze what went wrong"
- "update rules based on our conversation"
- "why did you make that mistake?"

## Transcript Access

The session transcript is symlinked to a stable location:

```
@.claude/transcripts/last-session.jsonl
```

**How to read:**

```
Read @.claude/transcripts/last-session.jsonl
```

The file contains the previous session's transcript for analysis.

## Failure Classification

Use `references/correction-patterns.md` to classify the mistake type:

| Category                 | Examples                        | Target File                     |
| ------------------------ | ------------------------------- | ------------------------------- |
| Architecture drift       | "No, the directory should be X" | `.claude/rules/architecture.md` |
| Process violation        | "You skipped testing"           | `.claude/rules/quality.md`      |
| Pattern violation        | "That's not how we do X"        | Relevant SKILL.md               |
| Format error             | "Wrong YAML format"             | `invocable-development`         |
| Context misunderstanding | "I said X, not Y"               | Rule clarification              |

## Patch Application

Use `references/patch-strategies.md` to determine how to update:

| Strategy                 | Use When                             | Example                        |
| ------------------------ | ------------------------------------ | ------------------------------ |
| Add recognition question | Claude keeps making the same mistake | Add "Recognition: X?" question |
| Add critical constraint  | Claude is skipping a critical step   | Add `<critical_constraint>`    |
| Strengthen reference     | Claude is skipping a reference       | "Consider" → "MANDATORY READ"  |
| Add example              | Claude doesn't understand pattern    | Add concrete example           |

## Workflow

See `workflows/post-mortem-workflow.md` for step-by-step process.

## Transparency Reporting

After patching, report:

1. **What triggered the reflection** - The user correction or pattern detected
2. **Root cause analysis** - Why the mistake occurred
3. **File patched** - Which file was updated
4. **Change made** - Specific edit applied
5. **Expected outcome** - How this prevents recurrence

**Example:**

```
Reflect & Patch executed:

Trigger: User said "No, the directory should be skills/, not skill/"
Root cause: Claude created single directory when structure requires plural

Patched: .claude/rules/architecture.md
Change: Added recognition question to directory structure section:
  "Recognition: Am I using the correct directory name (plural for directories)?"

Expected: Claude will now verify directory names before creation.
```

## Constraints

- **Single Source of Truth**: Update the actual rule, don't create duplicates
- **Defensive Patching**: Verify changes don't break existing functionality
- **Progressive Enhancement**: Start with recognition questions, escalate to constraints
- **Transparency**: Always report what was changed and why

## Related Skills

- `deviation-rules` - Handles unexpected work during execution
- `quality-standards` - Audits conversation alignment and quality gates
- `memory-persistence` - Session lifecycle and transcript handling

---

## Genetic Code

This component carries essential Seed System principles for context: fork isolation:

<critical_constraint>
MANDATORY: All components MUST be self-contained (zero .claude/rules dependency)
MANDATORY: Achieve 80-95% autonomy (0-5 AskUserQuestion rounds per session)
MANDATORY: Description MUST use What-When-Not format in third person
MANDATORY: No component references another component by name in description
MANDATORY: Progressive disclosure - references/ for detailed content
MANDATORY: Use XML for control (mission_control, critical_constraint), Markdown for data
No exceptions. Portability invariant must be maintained.
</critical_constraint>

**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows

**Recognition Questions**:

- "Would Claude know this without being told?" → Delete (zero delta)
- "Can this work standalone?" → Fix if no (non-self-sufficient)
- "Did I read the actual file, or just see it in grep?" → Verify before claiming

<trigger>When Claude detects user correction patterns or user explicitly requests reflection on mistakes</trigger>

<success_criteria>

- [ ] Session transcript read and analyzed
- [ ] Failure type classified using correction-patterns.md
- [ ] Root cause identified
- [ ] Target file determined
- [ ] Patch applied using patch-strategies.md
- [ ] Change verified (no regressions)
- [ ] Transparency report generated
      </success_criteria>

<critical_constraint>
MANDATORY: Read the session transcript before making any changes
MANDATORY: Classify failure type before determining patch strategy
MANDATORY: Update the actual rule file, not create duplicates
MANDATORY: Report all changes transparently with expected outcome
MANDATORY: Verify patch doesn't break existing functionality
No exceptions. Systematic reflection requires systematic analysis.
</critical_constraint>
