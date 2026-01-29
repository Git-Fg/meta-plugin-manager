# Correction Patterns

Recognition patterns for classifying user corrections to determine the appropriate target file for patching.

## Pattern Categories

### 1. Architecture Drift

**Trigger phrases:**

- "No, the directory should be X"
- "Wrong structure"
- "That's not where X goes"
- "The structure should be Y"
- "We don't put X in Y"

**Examples:**

- User: "No, skills/ should be plural" → Architecture drift
- User: "Commands go in commands/, not skills/" → Architecture drift

**Target file:** `.claude/rules/architecture.md`

**Recognition question:** "Did this involve directory structure, file organization, or component placement?"

---

### 2. Process Violation

**Trigger phrases:**

- "You skipped testing"
- "You didn't verify"
- "You should have run X first"
- "Where are the tests?"
- "You didn't check for errors"
- "You were supposed to Y before X"

**Examples:**

- User: "You skipped the tests again" → Process violation
- User: "Did you verify this works?" → Process violation

**Target file:** `.claude/rules/quality.md`

**Recognition question:** "Did Claude skip a required step, gate, or verification process?"

---

### 3. Pattern Violation

**Trigger phrases:**

- "That's not how we do X"
- "Wrong pattern"
- "We use Y for X"
- "You should use the X pattern"
- "That's not the convention"

**Examples:**

- User: "That's not how we structure skills" → Pattern violation
- User: "We always use the Rooter pattern for complete packages" → Pattern violation

**Target file:** Relevant SKILL.md (e.g., `invocable-development` for skill patterns)

**Recognition question:** "Did Claude use an incorrect pattern, convention, or approach?"

---

### 4. Format Error

**Trigger phrases:**

- "Wrong YAML format"
- "Missing frontmatter"
- "The format is incorrect"
- "That's not valid YAML"
- "You're missing the required field"

**Examples:**

- User: "The frontmatter is missing the name field" → Format error
- User: "YAML requires quotes around that value" → Format error

**Target file:** `.claude/skills/invocable-development`

**Recognition question:** "Did Claude produce invalid YAML, missing frontmatter, or incorrect format?"

---

### 5. Context Misunderstanding

**Trigger phrases:**

- "I said X, not Y"
- "That's not what I meant"
- "I asked for X, not Z"
- "You misunderstood"
- "Read my request again"

**Examples:**

- User: "I said skills/, not commands/" → Context misunderstanding
- User: "That's not what I asked for at all" → Context misunderstanding

**Target file:** Rule clarification (either `.claude/rules/principles.md` or relevant rule)

**Recognition question:** "Did Claude misread, misinterpret, or ignore user intent?"

---

## Pattern Detection Algorithm

When invoked, follow this flow:

```
1. Read session transcript file

2. Search for correction patterns:
   a. Scan user messages for trigger phrases
   b. Identify which category matches
   c. Extract the specific correction

3. Classify:
   - If directory/structure mentions → Architecture drift
   - If testing/verification mentions → Process violation
   - If pattern/convention mentions → Pattern violation
   - If YAML/frontmatter mentions → Format error
   - If intent/misunderstanding mentions → Context misunderstanding

4. Verify classification:
   - Does this fit the category definition?
   - Is the target file correct?
```

## Confidence Assessment

**High confidence:** User explicitly states the correction type

**Medium confidence:** Multiple patterns detected, need to prioritize

**Low confidence:** Ambiguous correction, may need user clarification

## Fallback Behavior

If classification is unclear:

1. Default to `.claude/rules/principles.md` (most generic)
2. Add recognition question to help future classification
3. Log the uncertainty for manual review

---

## Anti-Pattern: Over-Classification

**Don't:** Classify every correction as "process violation" because it's the default

**Do:** Specific pattern matching based on actual user language

## Anti-Pattern: Under-Classification

**Don't:** Create too many categories making classification difficult

**Do:** Use the 5 categories defined here, add edge cases to existing categories
