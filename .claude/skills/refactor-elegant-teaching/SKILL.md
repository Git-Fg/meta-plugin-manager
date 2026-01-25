---
name: refactor-elegant-teaching
description: Meta-skill protocol to enforce "Elegant Teaching" style. Performs strict audits, manages progressive disclosure, and applies pattern-based transformations.
allowed-tools: Read, Write, Grep
---

# Protocol: Elegant Teaching Refactor

**Role:** Style Enforcer & Technical Editor.
**Objective:** Rewrite content to maximize autonomy, clarity, and token efficiency.
**Mode:** Low-Freedom Enforcement.

## Core Constraints
1.  **Zero Fluff:** Delete definitions of concepts Claude already knows.
2.  **Presume Competence:** No "You should," "Must," "Always." Use Imperative.
3.  **Recognition over Generation:** Convert abstract advice into pattern-matching tests.
4.  **Concrete Contrast:** Show, don't tell. Every rule requires a ✅/❌ example pair.
5.  **Smart Disclosure:** Hide complexity *only* when it is conditionally relevant (edge cases), never when it is core logic.

---

## Phase 1: The Audit

Scan the input content for "Anti-Patterns." Generate an audit report.

**Audit Checklist:**
*   [ ] **Subject-Pollution:** "You/Your/We."
*   [ ] **Prescriptives:** "Always/Never/Must/Ensure."
*   [ ] **Abstracts:** Advice without examples.
*   [ ] **Dense Blocks:** Paragraphs > 4 lines.
*   [ ] **False References:** Core principles hidden in external files.
*   [ ] **Bloat:** Excessive examples or repetitive lists.

---

## Phase 2: The Transformation Arsenal

### Arsenal Category 1: High-Trust Language
*(Tools to fix: Subject-Pollution, Prescriptives)*

**Tool A: The Imperative Shift**
*   **Logic:** Remove subject. Convert "You should X" to "X."
*   **Template:** `[Imperative Verb] [Object]. Remember that [Context].`

**Tool B: The Permission Shift**
*   **Logic:** Convert commands to suggestions.
*   **Template:** `Consider [Action]` or `Avoid [Action] when [Condition].`

---

### Arsenal Category 2: Progressive Disclosure (The Split)
*(Tools to fix: Bloat, Cognitive Load, Bad References)*

**Tool C: The Happy Path Heuristic**
*   **Logic:** Distinguish between "Always Needed" (Core) and "Sometimes Needed" (Reference).
*   **Rule:** If the content explains **How** to do the main task, it is Core. If it lists **Options/Variations**, it is Reference.
*   **Action:**
    *   **Keep in SKILL.md:** Principles, Core Constraints, Standard Examples, The "Happy Path" workflow.
    *   **Move to references/:** Detailed lists (e.g., 20+ examples), Troubleshooting, Tool-specific edge cases.
*   **Check:** "Do I need this to do the basic job?" -> If Yes, Keep.

**Tool D: The Data vs. Logic Split**
*   **Logic:** Separate *instructions* from *raw data*.
*   **Action:**
    *   **SKILL.md (Logic):** "Use imperative form. See `examples/` for variations."
    *   **examples/ (Data):** A file containing 50 examples of imperative forms.

**Tool E: Conditional Linking**
*   **Logic:** Replace hard content with pointers.
*   **Template:** `For [Specific Edge Case], see references/[file].md.`
*   **Example:**
    *   *In SKILL.md:* "Use standard Bash commands."
    *   *Added:* "For Docker-specific Bash patterns, see `references/docker-patterns.md`."

---

### Arsenal Category 3: Recognition-Based Structure
*(Tools to fix: Abstracts, Vague Advice)*

**Tool F: The Recognition Test**
*   **Logic:** Turn advice into a binary self-check.
*   **Template:** `Recognition: "[Question]?" → [Action]`

**Tool G: The Pattern Match**
*   **Logic:** Identify the pattern to spot.
*   **Template:** `Look for: [Pattern].`

---

### Arsenal Category 4: Metaphors & Contrast
*(Tools to fix: Abstract Concepts, Lack of Examples)*

**Tool H: The Analogy Map**
*   **Logic:** Map intangible constraints to physical objects.
*   **Template:** `Think of [Concept] like a [Container]: [Explanation].`

**Tool I: The Contrast Pair**
*   **Logic:** Show wrong vs. right.
*   **Template:**
    ```
    ✅ Good: [Concrete Example]
    ❌ Bad: [Concrete Example]
    Why good: [Reason]
    ```

---

## Phase 3: Execution & Validation

1.  **Execute:** Iterate sections. Apply Arsenal tools.
2.  **Validate (The 5-Second Gate):**
    *   **Scan:** Can you read all headers in 5 seconds?
    *   **Contrast:** Does every abstract rule have a ✅/❌ example?
    *   **Disclosure Check:** Is the `SKILL.md` focused on the **Happy Path**? Are edge cases cleanly linked out?
    *   **Dependency Check:** Is any *essential* knowledge hidden in a reference file? (Fix if yes).

---

## Execution Example: Progressive Disclosure in Action

**Input (Bloated SKILL.md):**
"Use imperative form. Here are 20 examples:
1. Run the test.
2. Build the image.
...
20. Delete the cache.
Also, if you are using Kubernetes, check for pod limits.
If you are using Docker, check for volume mounts."

**Step 1 (Apply Tool C - Happy Path):**
*   *Analysis:* "Use imperative form" is Core. "20 examples" is Data. "Kubernetes/Docker" is Edge Case.
*   *Action:* Keep the rule. Move examples. Link edge cases.

**Step 2 (Apply Tool E - Conditional Linking):**
*   *Action:* Add conditional link.

**Step 3 (Refined Output):**

**SKILL.md:**
"Use imperative form. Remember that this reduces latency.
For extensive examples, see `examples/imperative-phrases.md`.

For container specifics:
- Kubernetes? See `references/k8s-patterns.md`.
- Docker? See `references/docker-patterns.md`."

**Result:** The `SKILL.md` is clean and focused on the logic. The data is available on demand. The "Happy Path" (just writing commands) is unobstructed.

---

## Final System Reminder

You are refining a tool for another Claude.
*   **Efficiency is intelligence.**
*   **Structure is clarity.**
*   **Disclosure is conditional:** Hide only what slows down the main flow. Never hide what powers it.