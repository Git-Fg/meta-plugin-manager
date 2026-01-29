---
name: ops/reflect-and-patch
description: "Analyze user corrections and session transcripts to update rules and skills. Use when learning from mistakes, updating CLAUDE.md, or preventing error recurrence. Includes transcript analysis, rule updates, and pattern documentation. Not for debugging code errors, handling exceptions, or real-time corrections during execution."
user-invocable: true
---

# Reflect & Patch

<mission_control>
<objective>Enable Claude to learn from user corrections by analyzing session data and proactively updating its own rules/skills to prevent recurrence</objective>
<success_criteria>After invocation: 1) Session transcript analyzed, 2) Root cause identified, 3) Relevant rule/SKILL.md updated, 4) Change documented with transparency</success_criteria>
</mission_control>

## The Path to High-Impact Meta-Learning

**Principle 1: Session Review Fuels Continuous Improvement**

User corrections provide high-value learning opportunities. When Claude analyzes what went wrong and updates its own rules, each mistake becomes an investment in preventing future errors. This transforms corrections from one-time fixes into systemic improvements.

**Principle 2: Root Cause Analysis Enables Targeted Prevention**

Understanding WHY a mistake occurred is more valuable than knowing THAT it occurred. By identifying whether the issue stems from missing recognition questions, unclear constraints, or misunderstood patterns, Claude can apply the right fix strategy that addresses the underlying cause rather than surface symptoms.

**Principle 3: Single-Source Updates Strengthen System Knowledge**

Updating existing rules (rather than creating duplicates) ensures knowledge consolidates in its canonical location. This makes the entire system smarter and more consistent over time, preventing the same mistake across all contexts—not just the current one.

**Principle 4: Transparency Builds Trust and Verification**

Documenting what changed and why enables users to understand the system's self-improvement process. This transparency allows validation that patches are appropriate and provides a clear history of how the system evolves based on real usage patterns.

**Principle 5: Systematic Analysis Ensures Quality**

Reading the full transcript before making changes, classifying the failure type before selecting a strategy, and verifying patches don't break existing functionality all ensure that improvements are well-targeted and safe. This disciplined approach prevents over-correction and ensures each patch meaningfully improves the system.

**Principle 6: Update-in-Place Prevents Fragmentation**

Modifying the actual rule file rather than creating duplicates or exceptions keeps knowledge consolidated in its canonical location. This makes the entire system smarter and more consistent, preventing the same mistake across all contexts rather than creating scattered workarounds.

</guiding_principles>

Think of this skill as **self-diagnostic surgery**—when Claude makes a mistake that the user corrects, this skill investigates why and patches the relevant rule to prevent recurrence.

## Workflow

**Analyze corrections and patch rules to prevent recurrence:**

1. **Detect →** User correction detected ("no", "wrong", "not what I asked") → Result: Trigger identified
2. **Read Transcript →** Read the session transcript file → Result: Full context
3. **Classify →** Categorize failure type (architecture, process, pattern, format) → Result: Target file determined
4. **Analyze →** Identify root cause (missing recognition, skipped step, wrong pattern) → Result: Fix approach
5. **Patch →** Apply strategy (add recognition, constraint, example) → Result: Rule updated
6. **Verify →** Check syntax, no regressions → Result: Safe change
7. **Report →** Explain what changed and why → Result: Transparency

**Why:** Self-diagnostic patching turns mistakes into prevention—systematic reflection enables continuous improvement.

## Navigation

| If you need...     | Read...                                   |
| :----------------- | :---------------------------------------- |
| Detect corrections | ## Workflow → Detect                      |
| Read transcript    | ## Workflow → Read Transcript             |
| Classify failure   | ## Workflow → Classify                    |
| Analyze root cause | ## Workflow → Analyze                     |
| Apply patch        | ## Workflow → Patch                       |
| Verify changes     | ## Workflow → Verify                      |
| Auto-invocation    | ## Trigger Conditions → Auto-Invocation   |
| Manual invocation  | ## Trigger Conditions → Manual Invocation |

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

The session transcript is stored at a stable location. Read it using the Read tool.

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

## Workflow Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    POST-MORTEM WORKFLOW                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. DETECT    →  2. READ      →  3. CLASSIFY  →  4. ANALYZE   │
│  Trigger      →  Transcript   →  Failure      →  Root Cause   │
│                 →              →  Type         →               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  5. PATCH    →  6. VERIFY    →  7. REPORT                     │
│  Apply       →  No           →  Transparency                  │
│  Strategy    →  Regressions  →  Report                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Step-by-Step Process

### Step 1: Detect Trigger

**Input:** User correction detected in conversation

**Recognition triggers:**

- User says "no", "wrong", "not what I asked", "actually..."
- User uses `/rewind` command
- Claude explicitly recognizes its own mistake

**Action:** Note the trigger and proceed to Step 2

### Step 2: Read Transcript

**Action:** Read the session transcript file

**What to extract:**

1. The user's original request
2. Claude's response/action
3. The user's correction
4. Any context about what went wrong

**If transcript unavailable:** Use conversation context directly

### Step 3: Classify Failure Type

Use `references/correction-patterns.md` to classify:

| Category                 | Question to Ask                         |
| ------------------------ | --------------------------------------- |
| Architecture drift       | "Was this about directory structure?"   |
| Process violation        | "Did Claude skip a required step?"      |
| Pattern violation        | "Was the wrong pattern used?"           |
| Format error             | "Was there a YAML/frontmatter error?"   |
| Context misunderstanding | "Did Claude misunderstand the request?" |

**Output:** Confirmed category and target file

### Step 4: Analyze Root Cause

**Question:** Why did Claude make this mistake?

| Root Cause            | Indicator                             | Fix Approach                  |
| --------------------- | ------------------------------------- | ----------------------------- |
| Missing recognition   | Claude didn't pause to check          | Add recognition question      |
| Skipped step          | Claude proceeded without verification | Add critical constraint       |
| Didn't read reference | Claude didn't consult the reference   | Strengthen reference language |
| Misunderstood pattern | Claude applied wrong pattern          | Add example/anti-pattern      |
| Context error         | Claude misread or ignored intent      | Clarify in rules              |

**Output:** Root cause statement

### Step 5: Apply Patch Strategy

Use `references/patch-strategies.md` to select and apply:

```
1. Select strategy based on root cause
2. Locate relevant section in target file
3. Apply patch following strategy instructions
4. Verify syntax is correct
```

**Example application:**

```
Root cause: Claude used "skill/" instead of "skills/"
Strategy: Add recognition question

Patch applied to .claude/rules/architecture.md:

**Recognition:** Am I using the correct directory name (check for plural/singular)?
```

### Step 6: Verify No Regressions

**Checklist:**

- [ ] XML/Markdown syntax is valid
- [ ] Patch doesn't break existing content
- [ ] Reference links are correct
- [ ] Language strength is appropriate

**If issues found:** Revise patch and re-verify

### Step 7: Generate Transparency Report

**Format:**

```
Reflect & Patch executed:

Trigger: [What caused the reflection]
Classification: [Category - Target file]
Root cause: [Why the mistake occurred]

Patched: [File path]
Change: [Specific edit applied]

Expected outcome: [How this prevents recurrence]
```

## Complete Example

```
User: "No, that's wrong. The skill should be in skills/ not skill/"

1. DETECT: User correction detected ("No, that's wrong")
2. READ: Read transcript, found Claude created "skill/" directory
3. CLASSIFY: Architecture drift (directory structure issue)
   Target: .claude/rules/architecture.md
4. ANALYZE: Root cause = Claude didn't verify singular/plural
5. PATCH: Added recognition question using Strategy A
6. VERIFY: Syntax valid, no regressions
7. REPORT: Generated transparency report
```

## Anti-Patterns to Avoid

- Don't patch the wrong file based on weak classification
- Don't apply too strong language for minor issues
- Don't create duplicates instead of updating existing rules
- Don't skip verification before completing

**Do:**

- Verify classification before patching
- Match language strength to severity
- Update existing rules, don't create duplicates
- Always verify before claiming completion

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

**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows

**Recognition Questions**:

- "Would Claude know this without being told?" → Delete (zero delta)
- "Can this work standalone?" → Fix if no (non-self-sufficient)
- "Did I read the actual file, or just see it in grep?" → Verify before claiming

## Success Criteria

- [ ] Session transcript read and analyzed
- [ ] Failure type classified using correction-patterns.md
- [ ] Root cause identified
- [ ] Target file determined
- [ ] Patch applied using patch-strategies.md
- [ ] Change verified (no regressions)
- [ ] Transparency report generated

## Trigger

When Claude detects user correction patterns or user explicitly requests reflection on mistakes

---

<critical_constraint>
All portable components MUST be self-contained (zero .claude/rules dependency).
Portability invariant must be maintained.
</critical_constraint>
