---
name: meta-learning-extractor
description: "Analyze session history to auto-refine rules, skills, and configuration. Use when friction occurs, corrections are made, or new patterns emerge. Includes error taxonomy, root cause analysis, and surgical file patching. Not for code refactoring or feature implementation."
---

# Meta-Learning Extractor

<mission_control>
<objective>Analyze interaction history to refine the system's own source code (rules, skills, agents) and prevent error recurrence.</objective>
<success_criteria>Root causes mapped to specific files; concrete patches applied; zero regression; system evolves based on experience.</success_criteria>
</mission_control>

## Core Workflow

**Phase 1: Diagnosis** → Scan transcript for correction signals and map to system layers.
**Phase 2: Synthesis** → Distill specific errors into general principles.
**Phase 3: Surgery** → Apply atomic patches to the correct file location.
**Phase 4: Verification** → Confirm syntax validity and alignment with architecture.

## Navigation

| If you need...          | Read...                                  |
| :---------------------- | :--------------------------------------- |
| Understand the workflow | ## Core Workflow                         |
| Diagnose error signals  | ## Phase 1: The Taxonomy                 |
| Synthesize principles   | ## Phase 2: The Synthesis                |
| Apply surgical patches  | ## Phase 3: The Surgery                  |
| Verify changes          | ## Core Workflow → Phase 4: Verification |

## Phase 1: The Taxonomy (Routing Logic)

Use this decision matrix to determine _where_ the fix belongs.

| Error Signal (Symptom)                                             | Root Cause Type      | Target File Location                                                                                 |
| :----------------------------------------------------------------- | :------------------- | :--------------------------------------------------------------------------------------------------- |
| "You used the wrong tool", "Why didn't you use X?", "Skill failed" | **Procedural Gap**   | **The Specific Skill** (`.claude/skills/*/SKILL.md`) <br> _Fix: Update `## Workflow` or triggers._   |
| "Wrong folder", "Bad file name", "Structure is wrong"              | **Structural Drift** | **Architecture Rule** (`.claude/rules/architecture.md`) <br> _Fix: Add pattern to relevant section._ |
| "Too chatty", "Don't apologize", "Be more autonomous"              | **Behavioral Drift** | **Principles Rule** (`.claude/rules/principles.md`) <br> _Fix: Update Voice or Freedom constraints._ |
| "We use Bun now", "The DB is Postgres", "API key changed"          | **Context Rot**      | **Project Config** (`CLAUDE.md`) <br> _Fix: Update `System Discoveries` or `Navigation`._            |
| "You hallucinated code", "That doesn't exist", "Security risk"     | **Quality Failure**  | **Quality Rule** (`.claude/rules/quality.md`) <br> _Fix: Add `<critical_constraint>`._               |

## Phase 2: The Synthesis (Distillation)

Do not patch specific instances; patch the _principle_.

- **Weak**: "Don't use `npm test` in the `backend` folder."
- **Strong**: "Detect package manager via lockfile before running commands." (Universal)

- **Weak**: "Add `pandas` to the list of allowed libraries."
- **Strong**: "When data processing is required, check `requirements.txt` before suggesting libraries." (Universal)

## Phase 3: The Surgery (Patching Protocols)

Apply edits according to the file type to maintain system integrity.

### Protocol A: Patching a Skill (`SKILL.md`)

1.  **Read** the skill file fully.
2.  **Determine Logic vs. Constraint**:
    - If the _process_ was wrong: Edit the `## Workflow` or `## Implementation Patterns` section.
    - If a _rule_ was broken: Append to the `<critical_constraint>` block at the bottom (Recency Bias).
3.  **Atomic Write**: Apply the edit.

### Protocol B: Patching Global Rules (`rules/*.md`)

1.  **Locate Section**: Find the specific header related to the topic (e.g., "Voice", "Directory Structure").
2.  **Append Pattern**: Add a new bullet point or XML tag.
3.  **Positive Constraints**: When banning behavior, describe the positive alternative that achieves the goal.

### Protocol C: Patching `CLAUDE.md`

1.  **Locate "System Discoveries"**: This is Section 4 in the standard Seed System.
2.  **Append Entry**: Add a new sub-section with the date and the discovery.

    ```markdown
    ### [Topic] Correction (YYYY-MM-DD)

    **Discovery**: [What was learned]
    **Resolution**: [What changed]
    ```

## PATTERN: Interaction Schema

The meta-learning extraction follows this workflow:

1. READ_TRANSCRIPT → 2. CLASSIFY_ERROR → 3. SYNTHESIZE_PRINCIPLE → 4. SELECT_TARGET → 5. APPLY_PATCH → 6. VERIFY_SYNTAX

## PATTERN: Thinking Process

Before applying any fix, work through these questions:

1. **Analyze**: What exactly did the user correct?
2. **Trace**: Why did I make that mistake? (Missing rule? Bad instruction? Hallucination?)
3. **Locate**: Which file governs this behavior?
4. **Draft**: Create the specific text insertion/replacement.
5. **Critique**: Will this break anything else? Is it too restrictive?

## The Path to High-Quality Rule Extraction

### 1. Generalization Prevents Overfitting

Extracted rules should apply generally, not just to edge cases. Overfitting creates brittle rules that don't transfer.

### 2. Historical Preservation Maintains Context

When modifying `CLAUDE.md`, append to "System Discoveries" rather than overwriting unrelated sections. History preserves learning.

### 3. Recency Bias Placement Works

When adding constraints to Skills or Rules, place them at the BOTTOM of the file or section for maximum adherence. Recent tokens get more attention.

### 4. Portability Ensures Reusability

Hardcoded paths (e.g., `/Users/jdoe/`) break portability. Use relative paths or environment variables.

---

## Common Mistakes to Avoid

### Mistake 1: Overfitting to Specific Cases

❌ **Wrong:**
"Detect package manager via lockfile" → Only for this specific project

✅ **Correct:**
"Detect package manager via lockfile" → Universal rule applicable everywhere

### Mistake 2: Patching Wrong File Location

❌ **Wrong:**
Fixing skill behavior in architecture.md

✅ **Correct:**
Update the specific skill file, not a global rule

### Mistake 3: Skipping Generalization

❌ **Wrong:**
"Don't use npm test in backend folder" → Specific to one folder

✅ **Correct:**
"Detect package manager via lockfile before running test commands" → General pattern

### Mistake 4: Modifying Wrong File Type

❌ **Wrong:**
Updating CLAUDE.md instead of the specific skill for a procedural issue

✅ **Correct:**
Use Protocol A for skills, Protocol B for rules, Protocol C for CLAUDE.md

---

## Validation Checklist

Before claiming meta-learning extraction complete:

**Diagnosis:**
- [ ] Error signal correctly classified (Procedural Gap, Structural Drift, Behavioral Drift, Context Rot, Quality Failure)
- [ ] Root cause type identified correctly
- [ ] Target file location determined

**Synthesis:**
- [ ] Principle generalized beyond specific case
- [ ] Rule applies universally, not just edge case
- [ ] No hardcoded paths or project-specific values

**Surgery:**
- [ ] Correct protocol used (A for skills, B for rules, C for CLAUDE.md)
- [ ] Edit applied to correct file
- [ ] Constraint placed at bottom for recency bias

**Verification:**
- [ ] Syntax valid (no malformed XML/Markdown)
- [ ] No breaking changes to existing structure
- [ ] Change aligned with system architecture

---

## Best Practices Summary

✅ **DO:**
- Classify errors correctly using the taxonomy (5 types)
- Generalize rules to apply universally, not just edge cases
- Use correct patching protocol for file type
- Place new constraints at bottom of files (recency bias)
- Append to "System Discoveries" in CLAUDE.md rather than overwriting
- Work through the 5 thinking questions before applying fixes
- Preserve historical context in CLAUDE.md

❌ **DON'T:**
- Patch specific instances instead of general principles
- Fix procedural issues in architecture rules
- Use hardcoded paths (breaks portability)
- Modify the wrong file type
- Skip the thinking process questions
- Overwrite existing sections in CLAUDE.md
- Create brittle rules that don't transfer

---

<critical_constraint>
**System Physics:**

1. Zero external dependencies for portable components
2. Rules generalize across contexts, not edge cases
3. Historical preservation in CLAUDE.md

