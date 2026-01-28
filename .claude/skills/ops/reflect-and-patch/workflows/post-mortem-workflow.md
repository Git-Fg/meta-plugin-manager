# Post-Mortem Workflow

Step-by-step process for reflecting on mistakes and patching rules.

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

---

## Step 1: Detect Trigger

**Input:** User correction detected in conversation

**Recognition triggers:**

- User says "no", "wrong", "not what I asked", "actually..."
- User uses `/rewind` command
- Claude explicitly recognizes its own mistake

**Action:** Note the trigger and proceed to Step 2

---

## Step 2: Read Transcript

**Action:** Read the session transcript

```
Read @.claude/transcripts/last-session.jsonl
```

**What to extract:**

1. The user's original request
2. Claude's response/action
3. The user's correction
4. Any context about what went wrong

**If transcript unavailable:** Use conversation context directly

---

## Step 3: Classify Failure Type

Use `references/correction-patterns.md` to classify:

| Category                 | Question to Ask                         |
| ------------------------ | --------------------------------------- |
| Architecture drift       | "Was this about directory structure?"   |
| Process violation        | "Did Claude skip a required step?"      |
| Pattern violation        | "Was the wrong pattern used?"           |
| Format error             | "Was there a YAML/frontmatter error?"   |
| Context misunderstanding | "Did Claude misunderstand the request?" |

**Output:** Confirmed category and target file

---

## Step 4: Analyze Root Cause

**Question:** Why did Claude make this mistake?

| Root Cause            | Indicator                             | Fix Approach                  |
| --------------------- | ------------------------------------- | ----------------------------- |
| Missing recognition   | Claude didn't pause to check          | Add recognition question      |
| Skipped step          | Claude proceeded without verification | Add critical constraint       |
| Didn't read reference | Claude didn't consult the reference   | Strengthen reference language |
| Misunderstood pattern | Claude applied wrong pattern          | Add example/anti-pattern      |
| Context error         | Claude misread or ignored intent      | Clarify in rules              |

**Output:** Root cause statement (e.g., "Claude created singular directory when plural was required")

---

## Step 5: Apply Patch Strategy

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

---

## Step 6: Verify No Regressions

**Checklist:**

- [ ] XML/Markdown syntax is valid
- [ ] Patch doesn't break existing content
- [ ] Reference links are correct
- [ ] Language strength is appropriate

**If issues found:** Revise patch and re-verify

---

## Step 7: Generate Transparency Report

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

**Example:**

```
Reflect & Patch executed:

Trigger: User said "No, skills/ should be plural"
Classification: Architecture drift - .claude/rules/architecture.md
Root cause: Claude created "skill/" directory when plural form required

Patched: .claude/rules/architecture.md
Change: Added recognition question to directory structure section:
  "Recognition: Am I using the correct directory name (plural/singular)?"

Expected outcome: Claude will now verify directory names before creation.
```

---

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

---

## Anti-Patterns to Avoid

**Don't:** Patch the wrong file based on weak classification
**Don't:** Apply too strong language for minor issues
**Don't:** Create duplicates instead of updating existing rules
**Don't:** Skip verification before completing

**Do:** Verify classification before patching
**Do:** Match language strength to severity
**Do:** Update existing rules, don't create duplicates
**Do:** Always verify before claiming completion
