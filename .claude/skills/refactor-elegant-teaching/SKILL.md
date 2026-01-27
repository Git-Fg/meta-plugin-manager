---
name: refactor-elegant-teaching
description: AI-agent skill for refining the writing craft of Claude components (skills, commands, agents, hooks). Focuses on form: syntax, voice, teaching structure, and examples. Not for: validating correctness or assessing meaning. Use when: a component's writing needs polish.
allowed-tools: Read, Edit, Grep, Write
---

# Elegant Teaching Refactor

**Purpose:** Refine the writing craft of Claude components through form-focused analysis.

Think of this like editing for style: you're not judging the content's correctness, but polishing how it's written—the syntax, the voice, the teaching structure, the examples.

**Core principle:** Focus on form, not meaning. Improve how the component teaches, not what it teaches.

---

## What This Skill Does

This skill refines the **writing quality** of Claude components:

**Form improvements (in scope):**
- Syntax and structure
- Voice and tone
- Teaching clarity
- Example quality
- Progressive disclosure
- Contrast and comparison

**Meaning judgments (out of scope):**
- Whether content is correct
- Whether approach is optimal
- Whether component should exist
- Whether examples are semantically right

---

## Phase 1: Component Type Detection

**Identify the component type from structure:**

```
1. Read the component file
2. Detect structure:
   - Has description + body (no <example>) → Skill
   - Has !/@ syntax, orchestration focus → Command
   - Has <example> triggering blocks → Agent
   - Has event matcher + exit code → Hook
3. Note form-specific elements for that type
```

**Form signatures by type:**

| Component | Form Signature | Key Writing Elements |
|-----------|---------------|---------------------|
| **Skill** | Tiered content, teaching voice | Progressive disclosure, imperative examples, references/ structure |
| **Command** | Orchestration language, parameters | !/@ syntax, numbered steps, guardrails section |
| **Agent** | `<example>` blocks, system prompt | Triggering format, responsibility lists, output structure |
| **Hook** | Event matcher, validation logic | Matcher syntax, JSON response, stderr logging |

---

## Phase 2: Form Analysis

**Analyze the writing form, not the meaning.**

### Universal Form Elements (All Components)

#### Voice: Imperative Teaching

**Check the writing voice:**

**Elegant form:**
```markdown
Transform verbose content. Apply progressive disclosure.
Remember that context is expensive.
```

**Needs work:**
```markdown
You should transform content. We need to apply progressive disclosure.
The user must remember that context is expensive.
```

**Recognition:** Scan for "you/your/we" - these indicate prescriptive voice, not teaching voice.

#### Examples: Concrete and Copyable

**Check example quality:**

**Elegant form:**
```markdown
Use imperative form: "Transform content. Remove noise. Trust intelligence."
```

**Needs work:**
```markdown
Use imperative form for clear instructions.
```

**Recognition:** Does the example show exactly what the text describes? Can the reader copy it directly?

#### Structure: Scannable Headers

**Check header organization:**

**Elegant form:**
```markdown
## Core Workflow
## Edge Cases
## Reference Material
```

**Needs work:**
```markdown
## Some information about workflows
## Additional notes
## More stuff
```

**Recognition:** Can a reader understand the outline from headers alone in 5 seconds?

---

### Skill Form Analysis

**Skills use progressive disclosure structure.**

#### Tier 1: Core Content (SKILL.md)

**Check for elegant tiering:**

**Elegant form:**
```markdown
## Core Workflow

Identify the task. Apply the pattern. Validate results.

For comprehensive examples, see references/advanced-patterns.md
```

**Needs work:**
```markdown
## Core Workflow

Identify the task. Apply the pattern. Validate results.

Here are 50 examples of every possible variation:
[50 examples embedded]
```

**Recognition:** Is the core content focused on the 80% use case? Are specialized cases moved to references/?

#### Contrast Structure

**Check for before/after contrast:**

**Elegant form:**
```markdown
✅ **Elegant:**
"Transform content. Trust intelligence."

❌ **Verbose:**
"You should transform the content. You need to trust the intelligence."
```

**Needs work:**
```markdown
Use imperative form instead of prescriptive form.
```

**Recognition:** Does the skill show the difference through concrete examples?

---

### Command Form Analysis

**Commands use orchestration language and dynamic syntax.**

#### Dynamic Context Syntax

**Check for proper !/@ usage:**

**Elegant form:**
```markdown
Inspect @ for context:
- Current file: @!file
- Selection: @!selection
- Working directory: @!cwd
```

**Needs work:**
```markdown
Look at the file path passed as an argument.
```

**Recognition:** Does the command use dynamic context markers instead of manual references?

#### Numbered Steps

**Check for clear sequence:**

**Elegant form:**
```markdown
1. Analyze the file structure
2. Identify refactoring opportunities
3. Apply transformations
4. Validate results
```

**Needs work:**
```markdown
Analyze the file structure, then identify refactoring opportunities, then apply transformations, then validate results.
```

**Recognition:** Are multi-step processes broken into numbered items?

---

### Agent Form Analysis

**Agents use specific triggering formats and complete prompts.**

#### Example Block Structure

**Check for proper `<example>` syntax:**

**Elegant form:**
```markdown
<example>
<context>User is working on authentication code</context>
<user>Review this auth module for security issues</user>
<assistant>[Performs security audit, reports findings]</assistant>
</example>
```

**Needs work:**
```markdown
Trigger when user asks for security review.
```

**Recognition:** Does the agent show concrete triggering scenarios?

#### System Prompt Structure

**Check for complete prompt format:**

**Elegant form:**
```markdown
You are a security analyst specializing in authentication systems.

**Responsibilities:**
- Identify vulnerabilities
- Check for secrets
- Validate inputs

**Process:**
1. Scan for obvious issues
2. Analyze authentication flow
3. Report findings

**Output format:**
## Security Audit Report
### Critical
[...]
```

**Needs work:**
```markdown
You are a security analyst. Find vulnerabilities.
```

**Recognition:** Does the system prompt specify responsibilities, process, and output format?

---

### Hook Form Analysis

**Hooks use event matcher syntax and validation structure.**

#### Matcher Syntax

**Check for precise matcher patterns:**

**Elegant form:**
```json
{
  "matcher": "tool == \"Write\" && tool_input.file_path matches \"\\.env$\"",
  "description": "Prevent .env file writes"
}
```

**Needs work:**
```json
{"matcher": "tool == \"Write\""}
```

**Recognition:** Does the matcher target specific events, not generic categories?

#### Response Structure

**Check for proper hook response format:**

**Elegant form:**
```bash
# Log decision
echo "BLOCKED: .env write detected" >&2

# Return structured response
echo '{"blocked": true, "reason": ".env files may contain secrets"}'
```

**Needs work:**
```bash
# Just exit
exit 1
```

**Recognition:** Does the hook log decisions AND return structured JSON?

---

## Phase 3: Form Refactoring

**Apply form-specific patterns to improve writing quality.**

### Pattern 1: Voice Transformation

**Transform prescriptive to teaching voice:**

**Before:**
```markdown
You should always use imperative form.
You must provide examples for every pattern.
We need to focus on clarity.
```

**After:**
```markdown
Use imperative form for clarity.
Provide examples for every pattern.
Focus on clarity in teaching.
```

**Recognition:** Remove "you/your/we" - rewrite as direct imperative.

---

### Pattern 2: Example Enrichment

**Add concrete, copyable examples:**

**Before:**
```markdown
Use progressive disclosure to structure content.
```

**After:**
```markdown
Use progressive disclosure: core content in SKILL.md, edge cases in references/.

**Example:**
```markdown
## Core Workflow
[Basics]

For advanced patterns, see references/advanced.md
```
```

**Recognition:** Every abstract principle needs a concrete example.

---

### Pattern 3: Progressive Disclosure

**Structure content by frequency of use:**

**Before (Flat):**
```markdown
## How to Use This Skill

1. Basic usage
2. Advanced usage
3. Edge case 1
4. Edge case 2
5. Edge case 3
...
20. All possible variations
```

**After (Tiered):**
```markdown
## Core Workflow

[Basics for 80% of use cases]

## Advanced Patterns

For comprehensive edge cases, see references/edge-cases.md
```

**Recognition:** Is the reader overwhelmed by detail up front?

---

### Pattern 4: Contrast Teaching

**Show difference through comparison:**

**Before:**
```markdown
Avoid using prescriptive language in components.
```

**After:**
```markdown
❌ **Prescriptive (creates dependency):**
"You should transform the content."

✅ **Imperative (builds autonomy):**
"Transform the content."

**Why:** Prescriptive language implies oversight; imperative enables autonomous operation.
```

**Recognition:** Does the component show both "bad" and "good" forms with rationale?

---

### Pattern 5: Header Scannability

**Make headers informative and scannable:**

**Before:**
```markdown
## Information
## Details
## More Information
## Additional Details
```

**After:**
```markdown
## Core Workflow
## Edge Cases
## Reference Material
## Troubleshooting
```

**Recognition:** Can a reader understand the component structure from headers alone?

---

## Component-Specific Form Patterns

### Skill Form Patterns

**Teaching voice + progressive disclosure:**

| Element | Elegant Form | Why It Matters |
|---------|-------------|----------------|
| Voice | Imperative with "Remember/Think/Consider" | Teaching, not commanding |
| Examples | Concrete and copyable | Recognition over generation |
| Structure | Tiered (core → references/) | Cognitive load management |
| Contrast | Before/after with rationale | Shows difference, doesn't tell |

### Command Form Patterns

**Orchestration language + dynamic syntax:**

| Element | Elegant Form | Why It Matters |
|---------|-------------|----------------|
| Syntax | Uses @!file, @!selection | Runtime flexibility |
| Steps | Numbered for multi-step processes | Clear sequence |
| Guardrails | Explicit safety sections | Destructive operation awareness |
| Parameters | Clear argument documentation | Usability |

### Agent Form Patterns

**Specific triggering + complete prompts:**

| Element | Elegant Form | Why It Matters |
|---------|-------------|----------------|
| Triggering | `<example>` blocks with context/user/assistant | Shows activation clearly |
| System Prompt | Responsibilities + Process + Output | Complete guidance |
| Output | Structured format specification | Predictable results |
| Preload | `skills:` for domain knowledge | Context isolation |

### Hook Form Patterns

**Event targeting + decision logging:**

| Element | Elegant Form | Why It Matters |
|---------|-------------|----------------|
| Matcher | Specific event patterns | Precision targeting |
| Response | JSON + stderr logging | Auditability |
| Validation | Complete logic in hook | Self-contained |
| Exit | Always code 0 | Non-blocking design |

---

## Form Validation Checklist

**After refactoring, verify the writing form:**

### Universal Checks (All Components)
- [ ] No "you/your/we" in instructions?
- [ ] Examples concrete and copyable?
- [ ] Headers enable 5-second scan?
- [ ] Contrast examples with rationale?
- [ ] Progressive disclosure applied?

### Skill-Specific
- [ ] Core content focused on 80% use cases?
- [ ] Edge cases moved to references/?
- [ ] Each principle has concrete example?
- [ ] Teaching voice ("Remember/Think/Consider")?

### Command-Specific
- [ ] Uses !/@ syntax for dynamic context?
- [ ] Multi-step processes numbered?
- [ ] Safety sections for destructive operations?
- [ ] Parameters clearly documented?

### Agent-Specific
- [ ] `<example>` blocks with context/user/assistant?
- [ ] System prompt has responsibilities + process + output?
- [ ] Output format clearly specified?
- [ ] Domain knowledge preloaded if needed?

### Hook-Specific
- [ ] Matcher targets specific events (not generic)?
- [ ] Returns JSON + logs to stderr?
- [ ] Validation logic self-contained?
- [ ] Always exits code 0?

---

## Remember

**Form refinement focuses on:**

- **Voice** - Imperative teaching, not prescriptive commands
- **Examples** - Concrete and copyable, not abstract
- **Structure** - Progressive disclosure, not flat information
- **Contrast** - Before/after with rationale, not rules
- **Syntax** - Component-specific patterns, not generic

**What form refinement doesn't do:**

- Assess whether content is correct
- Judge if the component should exist
- Validate semantic meaning
- Determine optimal approach

**The principle:** Polish the writing craft. Let others judge the meaning.

**Final tip:** Elegant form makes content teach itself. The reader should understand exactly how to write well from the examples alone.
