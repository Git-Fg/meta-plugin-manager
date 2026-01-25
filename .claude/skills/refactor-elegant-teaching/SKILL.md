---
name: refactor-elegant-teaching
description: AI-agent skill for autonomous refactoring of Claude components. Transforms verbose instructions into elegant, pattern-based guidance through progressive disclosure, recognition structures, and contrast examples.
allowed-tools: Read, Edit, Grep
---

# Elegant Teaching Refactor

**Purpose:** Transform verbose Claude components into elegant, autonomous teaching through pattern-based refactoring.

Think of content refactoring like organizing information for quick access: core concepts live in SKILL.md (always visible), while specialized data sits in references/ (available when needed).

**Core principle:** Claude processes pattern recognition faster than content generation. Structure components for autonomous adaptation, not rigid instruction-following.

---

## What This Skill Does

This skill helps AI agents refactor Claude components to be more elegant and autonomous.

**Good refactored components:**
- Work without constant guidance
- Enable pattern recognition
- Maintain clear structure
- Include concrete examples

❌ **Bad:** Components that require external documentation or step-by-step instructions
✅ **Good:** Components that provide guidance and examples for autonomous operation

**Question:** Would this component work if someone only read this file? If not, include more context.

---

## What Good Refactoring Has

### 1. Natural Imperative Form

**Build autonomous behavior through guidance, not commands.**

✅ **Good:**
```markdown
Transform content using pattern recognition. Trust intelligence to adapt to context.
```

❌ **Bad:**
```markdown
Execute step 1. Execute step 2. Execute step 3. Always use imperative form.
```

**Why:** Natural language builds understanding; prescriptive commands create dependency.

### 2. Progressive Disclosure

**Keep SKILL.md focused on core workflows, move edge cases to references.**

✅ **Good:**
```markdown
Core workflow in SKILL.md. Edge cases in references/.
For comprehensive examples, see examples/imperative-phrases.md
```

❌ **Bad:**
```markdown
Include all information in SKILL.md. Never use references/.
Here are 50 examples...
```

**Why:** Progressive disclosure maintains flow; flat structure creates cognitive overload.

### 3. Pattern Recognition Structure

**Enable binary validation through observable patterns.**

✅ **Good:**
```markdown
Recognition: "Can scan all headers in 5 seconds?" → If no, restructure
```

❌ **Bad:**
```markdown
Make content clear and scannable
```

**Why:** Binary patterns enable self-diagnostic capability; abstract rules require interpretation.

---

## How to Refactor Content

### Step 1: Audit for Dependency Patterns

Look for these patterns that reduce autonomy:

**Subject Dependency:** "You/Your/We" creates instruction-following mode
**Prescriptive Commands:** "Always/Never/Must" implies oversight needed
**Abstract Rules:** Rules without examples lack clarity
**Dense Blocks:** Paragraphs >4 lines reduce scanability
**External Dependencies:** Core principles hidden in other files
**Example Overload:** Too many examples create noise

### Step 2: Distribute Content Strategically

**SKILL.md (Core Knowledge):**
- Information needed for standard workflows
- Common variations users encounter
- Typical troubleshooting steps

**References/ (Specialized Knowledge):**
- Highly specialized tools
- Rare edge cases
- Comprehensive example catalogs
- Platform-specific variations

**Question:** Is this needed for standard tasks? Put in SKILL.md. Only for specific cases? Put in references/.

### Reviewing References

References should be self-contained knowledge modules that work without SKILL.md.

**Checklist:**

✅ **Good Reference:**
- No meta-instructions ("This file contains... Load this when...")
- Clear headers for scanning
- Pure content without circular logic
- Self-contained and understandable alone

❌ **Bad Reference:**
- References SKILL.md for context
- Contains instructions about when to read it
- Unclear structure
- Duplicates content from SKILL.md

**Question:** Can you understand this reference without reading SKILL.md first? If no, fix it.

### Pattern 4: Transformation Arsenal

## Refactoring Examples

### Example 1: Natural Imperative vs Commands

**Before (Dependency-Creating):**
```markdown
You should transform content. You must remove dependencies. You need to trust AI.
```

**After (Autonomy-Building):**
```markdown
Transform verbose content. Remove dependency patterns. Trust autonomous adaptation.
```

**Why:** Natural imperative builds understanding; prescriptive commands create dependency.

---

### Example 2: Progressive Disclosure

**Before (Cognitive Overload):**
```markdown
Include all information in SKILL.md. Never use references/.
Here are 50 examples of imperative form...
```

**After (Elegant Structure):**
```markdown
Core workflow in SKILL.md. Edge cases in references/.
For comprehensive examples, see examples/imperative-phrases.md
```

**Why:** Progressive disclosure maintains flow; flat structure creates cognitive clutter.

### Example 3: Binary Recognition Patterns

**Before (Abstract Rules):**
```markdown
Make content clear and easy to read
Ensure good organization
```

**After (Pattern Recognition):**
```markdown
Look for: Paragraphs >4 lines → split into bullets
Look for: "You/Your/We" → replace with imperative form
Look for: Dense blocks → apply progressive disclosure
```

**Why:** Observable patterns enable autonomous detection and correction.

---

### Example 4: Data vs Logic Separation

**Before (Mixed Content):**
```markdown
Logic and data mixed in SKILL.md
50 examples embedded directly
No catalog separation
```

**After (Separated Concerns):**
```markdown
Logic: Use imperative form for autonomous behavior
Data: 50 examples in examples/imperative-catalogue.md
```

**Why:** Pattern recognition separated from data retrieval improves clarity.

## Validation Checklist

After refactoring, check:

**Structure:**
- [ ] Headers enable 5-second scan?
- [ ] Examples concrete and copyable?
- [ ] Content flows logically?

**Autonomy:**
- [ ] Uses natural imperative form (no "you/your")?
- [ ] Every principle has contrast example?
- [ ] Standard workflow works without references/?

**Distribution:**
- [ ] Core content in SKILL.md?
- [ ] Edge cases in references/?
- [ ] References self-contained?

**Question:** Would this work if someone only read SKILL.md? If no, consolidate.

---

## Complete Refactoring Example

**Before (Bloated):**
```markdown
Use imperative form. Here are 20 examples:
1. Run the test
2. Build the image
...
20. Delete the cache
For Kubernetes, check pod limits
For Docker, check volume mounts
```

**After (Elegant):**
```markdown
Use imperative form. Remember that this reduces processing latency.

Comprehensive imperative patterns: examples/imperative-catalogue.md

Container orchestration:
- Kubernetes specifics → references/k8s-patterns.md
- Docker specifics → references/docker-variations.md
```

**Why better:** Separates core patterns from data catalogs; enables context-aware retrieval.

---

## Quality Checklist

A well-refactored component:

**Content Quality:**
- [ ] Uses natural imperative form (no "you/your")
- [ ] Every principle has contrast example
- [ ] Headers enable 5-second scan
- [ ] Examples concrete and copyable

**Structure:**
- [ ] Core content in SKILL.md
- [ ] Edge cases in references/
- [ ] Standard workflow works without opening references/
- [ ] References self-contained

**Autonomy:**
- [ ] No circular dependencies
- [ ] Pattern recognition enabled through examples
- [ ] Binary validation for quality checks

**Self-check:** Would this component work if moved to a project with no external rules? If no, make it self-contained.

---

## Getting Started

1. **Identify the content to refactor**
   - What component needs simplification?
   - What patterns reduce autonomy?

2. **Apply refactoring patterns**
   - Remove dependency language ("you/your")
   - Add concrete examples with contrast
   - Separate core from edge cases
   - Enable pattern recognition

3. **Validate the result**
   - Run through quality checklist
   - Test if SKILL.md works standalone
   - Verify references are self-contained

4. **Iterate and improve**
   - Refine based on validation
   - Add more examples where needed
   - Remove unnecessary complexity

---

## Remember

Refactoring transforms verbose content into elegant, autonomous teaching. Focus on:

- **Pattern recognition** over rule-following
- **Autonomous operation** over external dependencies
- **Clear examples** over abstract explanations
- **Progressive disclosure** over flat structure

**Final tip:** The best refactoring makes complex content feel simple and self-evident. When someone reads it, they understand exactly what to do without asking questions.