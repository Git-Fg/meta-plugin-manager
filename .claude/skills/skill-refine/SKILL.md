---
name: skill-refine
description: "Analyze conversation and files to refine skills. Use when user says 'no' or 'wrong', when friction occurs, or when skills need improvement. Includes issue classification, evidence-based findings, and concrete fixes. Not for creating new skills or commands."
---

<mission_control>
<objective>Analyze conversation and files to identify skill refinements and prevent recurrence of issues</objective>
<success_criteria>Evidence-based findings documented, concrete fixes specified, no false positives flagged</success_criteria>
</mission_control>

## Quick Start

**If user said "no" or "wrong":** MUST READ ## PATTERN: Conversation Analysis → Output refinements → Prevent recurrence

**If conversation had friction:** Scan for patterns → Identify gaps → Synthesize fixes

**If files provided:** Analyze alongside conversation → Cross-reference findings

**Why:** Meta-analysis turns corrections into prevention—every mistake becomes a rule.

**MUST READ before claiming completion:** ## PATTERN: Evidence-Based Findings (core invariant)

## Navigation

| If you need...              | Read this section...               |
| :-------------------------- | :--------------------------------- |
| Analyze conversation        | ## PATTERN: Conversation Analysis  |
| Classify issues             | ## PATTERN: Issue Classification   |
| Output refinements          | ## PATTERN: Refinement Output      |
| Anti-patterns to avoid      | ## ANTI-PATTERN: Lazy Analysis     |
| Verification                | ## PATTERN: Verification           |

## PATTERN: Conversation Analysis

### What to Look For

| Signal | Means | Action |
| :----- | :----- | :----- |
| "No, that's wrong" | Pattern violation | Add anti-pattern |
| "I said X, not Y" | Misunderstanding | Clarify triggers |
| "You skipped X" | Process violation | Add constraint |
| "Not what I meant" | Intent mismatch | Refine description |
| Silence after output | Quality issue | Review standards |
| User repeats correction | Persistent gap | Strengthen constraint |

### Conversation-First Analysis

The conversation IS your primary input. No file reads needed for context.

**When @files provided:**
- Read injected content for additional context
- Cross-reference with conversation
- Synthesize findings from both sources

**When no @files:**
- Conversation alone is sufficient

### Analysis Format

Each finding MUST have:

```
**Issue:** One-line description
**Evidence:** Quote from conversation or @file
**Root Cause:** Why it happened (not just symptoms)
**Fix:** Specific change to apply
```

### Example

```
**Issue:** Skill triggers too broad
**Evidence:** User said "No" after skill-X invoked for unrelated task
**Root Cause:** "Use when" includes too many scenarios
**Fix:** Add "Not for X" exclusion to description
```

---

## PATTERN: Issue Classification

### Classification Matrix

| Error Signal | Root Cause Type | Target |
| :----------- | :-------------- | :----- |
| "Wrong pattern used" | Pattern Gap | Add ANTI-PATTERN |
| "Too many files" | Scope Creep | Add constraint |
| "Not clear enough" | Ambiguity | Clarify triggers |
| "Skipped verification" | Process Violation | Add critical constraint |
| "Wrong skill invoked" | Discovery Issue | Refine description |
| "Missing section" | Structure Gap | Add PATTERN section |

### Severity Levels

| Level | Signal | Language |
| :---- | :----- | :------- |
| **CRITICAL** | Safety, security, repeated failure | USE STRONG WORDS |
| **HIGH** | Quality issue affecting many | Clear directive |
| **MEDIUM** | Edge case or minor gap | Guidance |
| **LOW** | Nice-to-have improvement | Consider |

---

## PATTERN: Refinement Output

### Concrete Changes Format

**File:** `path/to/skill.md`
**Section:** `## PATTERN: X`
**Change:** `[Specific edit to apply]`
**Why:** `[Reason for change]`

### Verification Checklist

1. Read the actual file
2. Apply the change
3. Verify no regressions
4. Test with similar conversation pattern

### Output Template

```
## Refinement 1: [Title]

**File:** `.claude/skills/skill-name/SKILL.md`
**Section:** `## PATTERN: [Name]`
**Current:** [What exists]
**Change:** [What to add/replace]
**Why:** [Reason]

## Refinement 2: [Title]
...
```

---

## ANTI-PATTERN: Lazy Analysis

!** **CRITICAL:** Vague findings = lazy analysis. BE SPECIFIC.

### Anti-Pattern: Vague Findings

```
❌ Wrong:
"The conversation had issues"

✅ Correct:
"Line 47: User said 'No' after skill-X was invoked.
Root cause: Skill triggers too broad.
Fix: Add 'Not for X' exclusion to description."
```

### Anti-Pattern: Symptom-Only Reports

```
❌ Wrong:
"User was unhappy with the output"

✅ Correct:
"User said 'No' three times.
Pattern: Skill-Y invoked for each request.
Root cause: Skill-Y triggers too broad.
Fix: Narrow triggers in description."
```

### Anti-Pattern: No Evidence

```
❌ Wrong:
"The skill needs improvement"

✅ Correct:
"User correction at line X: 'Not what I meant'
Issue: Description promises X but delivers Y
Fix: Align description with actual behavior"
```

### Anti-Pattern: Missing Root Cause

```
❌ Wrong:
"Fix the frontmatter"

✅ Correct:
"Frontmatter missing 'Not for' on line 5.
Impact: Skill triggers for unintended use cases.
Fix: Add 'Not for Z' to description."
```

---

## PATTERN: Verification

### Before Publishing Refinements

| Check | Pass If |
| :---- | :------ |
| Evidence quoted | Every finding has conversation/file quote |
| Root cause analyzed | Not just symptoms reported |
| Fix is concrete | File + section + change specified |
| No false positives | Only real issues flagged |
| Language appropriate | Strong for failures, positive for correct |

### Verification Commands

```markdown
1. Read target file
2. Apply refinement
3. Run: `mcp__ide__getDiagnostics`
4. Verify: No errors
5. Test: Does this prevent the original issue?
```

---

## EDGE: Multiple Issues

### Prioritization

When conversation has multiple problems:

1. **Critical first** — Safety, repeated failures
2. **High frequency next** — Most common issues
3. **Group related** — Single fix for multiple occurrences

### Batch Output

```
## Refinements (Priority Order)

### 1. CRITICAL: [Issue Title]
[Evidence] → [Root Cause] → [Fix]

### 2. HIGH: [Issue Title]
[Evidence] → [Root Cause] → [Fix]

### 3. MEDIUM: [Issue Title]
...
```

---

## EDGE: No Issues Found

### When Analysis Yields Nothing

```
## Analysis Result: No Issues Detected

**What happened:** Conversation completed without corrections
**What this means:** Skills working as intended

**If this is wrong:**
- User may have silently accepted poor output
- Check for quality gates that were skipped
- Review patterns that "felt right" but weren't verified
```

---

## Recognition Questions

| Question | Pass Means... |
| :------- | :------------ |
| Evidence provided? | Every finding has a quote |
| Root cause analyzed? | Not just surface symptoms |
| Fix is actionable? | Can apply directly |
| Language is strong? | Failures called out clearly |
| No false positives? | Only real issues flagged |

---

## PATTERN: Quick Refinement Checklist

| Check | Description |
| :---- | :---------- |
| Specific evidence | Quote from conversation or file |
| Root cause | WHY it happened, not just WHAT |
| Concrete fix | File + section + change |
| No assumptions | Verified against actual files |
| Strong language | Failures clearly named |

---

## Validation Checklist

Before claiming skill refinement complete:

**Analysis Quality:**
- [ ] Evidence provided for every finding (conversation quote or file reference)
- [ ] Root cause analyzed, not just surface symptoms
- [ ] Fix is concrete (file + section + specific change)
- [ ] No false positives flagged
- [ ] No vague findings or assumptions

**Classification:**
- [ ] Issue correctly classified (Pattern Gap, Scope Creep, Ambiguity, etc.)
- [ ] Severity level assigned appropriately (CRITICAL/HIGH/MEDIUM/LOW)
- [ ] Target file and section identified correctly

**Output Format:**
- [ ] Concrete changes format used (File/Section/Change/Why)
- [ ] Language appropriate (strong for failures, positive for correct)
- [ ] Multiple issues prioritized (Critical first)

**Verification:**
- [ ] Actual file read before applying changes
- [ ] Diagnostics run after changes
- [ ] Fix prevents original issue (verified)

---

## Best Practices Summary

✅ **DO:**
- Quote specific evidence from conversation or files
- Analyze root cause, not just symptoms
- Specify exact file, section, and change for each fix
- Use strong language for agent failures and repeated issues
- Prioritize CRITICAL issues first
- Verify changes against actual files
- Read the target file before applying refinements

❌ **DON'T:**
- Make vague findings ("The skill needs improvement")
- Report symptoms without root cause analysis
- Skip evidence (every finding must have a quote)
- Assume issues without verification
- Use weak language for quality failures
- Skip diagnostics after applying changes
- Make changes without reading the actual file

---

<critical_constraint>
**Meta-Analysis Invariant:**

1. Conversation is PRIMARY input (already in context)
2. @files are OPTIONAL supplements
3. Output MUST be concrete (not vague recommendations)
4. Every finding MUST have evidence
5. Fixes MUST specify exact file and section
6. Strong language for agent failures
7. Verify everything against actual files

**NO VAGUE FINDINGS. NO ASSUMPTIONS. BE SPECIFIC.**
</critical_constraint>
