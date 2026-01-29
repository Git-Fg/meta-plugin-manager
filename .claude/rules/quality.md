# Quality: The Safety Rails

**"Smell Tests," Anti-Hallucination, and "Trust but Verify"**

Think of this as the quality guardrails that prevent common mistakes, hallucinating claims, and skipping verification.

---

## The Iron Law: Trust but Verify

Execute independently (Trust). Provide evidence before claiming done (Verify).

<guiding_principles>

## The Path to High-Quality Claims

### 1. Trace, Don't Guess

Read the actual file, trace the logic. The difference between "I grepped" and "I traced" determines claim reliability.

### 2. Evidence Before Assertion

Verification is practice, not checkpoint. Before claiming done: read, trace, confirm.

### 3. Confidence Markers

- **✓ VERIFIED** — File read, logic traced
- **? INFERRED** — Grep-based, needs verification
- **✗ UNCERTAIN** — Not checked, must investigate
  </guiding_principles>

### What This Means

Avoid making these claims without evidence:

- "Looks complete" (no verification)
- "Should work" (untested assumption)
- "That should fix it" (no confirmation)

Instead, build the habit of verification:

- view_file the actual file, trace the logic, then confirm
- Test the invocation, confirm it loads, fix issues, re-test
- Check portability by confirming zero external dependencies

### Anti-Hallucination

Constraints help prevent mistakes by providing clear guidance:

- Security requirements define what must never happen
- Verification standards set evidence expectations
- Anti-patterns highlight common pitfalls even experts encounter

---

## Verifying Claims

A hard lesson shaped this guidance: an 80% false claim rate occurred when grep results were trusted without reading files.

### The Principle

When making claims about code, trace the actual logic. The difference between "I grepped this" and "I traced the code" determines whether your claim is reliable.

### Three Claim Types

**Existence claims** ("X exists") require reading the file and confirming the code actually wraps or defines X—not just finding a reference in search results.

**Absence claims** ("X doesn't exist") require searching thoroughly with alternate names and patterns before concluding something is missing.

**Behavior claims** ("X does Y") require reading the function and understanding its logic—not just trusting the function name.

### Confidence Markers

Use these markers to signal how certain you are:

- **✓ VERIFIED** — You read the file and traced the logic. Safe to assert.
- **? INFERRED** — Based on grep or search. Needs verification before claiming.
- **✗ UNCERTAIN** — Haven't checked. Must investigate.

### Common Failure Modes

Grep results can mislead. Different naming conventions hide matches. Empty search results might mean wrong directory or extension. Finding something in comments isn't finding actual implementation. Always read the file before claiming something exists or doesn't exist.

**Recognition question:** "Did I read the actual file, or just see it in grep?"

---

## Recognition-First Approach

Think of anti-patterns as "smell tests"—quick checks that reveal deeper issues. Ask these questions when something feels off:

- "Could the description alone suffice?"
- "Can this work standalone?"
- "Is the overhead justified?"
- "Would Claude know this without being told?"
- "Did I read the actual file, or just see it in grep?"

If the answer suggests a problem, look deeper.

---

## Common Anti-Patterns

### Command Wrapper

Creating skills that serve only as wrappers for single CLI commands adds no value. The description should suffice. Delete such skills and improve the command description instead.

**Recognition:** "Could the description alone suffice?"

### Non-Self-Sufficient

Skills requiring constant user hand-holding fail their purpose. The goal is autonomy—0-3 questions to complete a task. Beyond 5 questions, the skill is adding friction rather than capability.

**Recognition:** "Can this work standalone?"

### Context Fork Misuse

Forks solve specific problems: isolation, parallel processing, or untrusted code. If none of those apply, regular invocation with arguments is simpler and faster.

**Recognition:** "Is the overhead justified?"

### Zero/Negative Delta

Good documentation covers what Claude wouldn't already know. Keep project-specific decisions, domain expertise, and non-obvious workarounds. Delete basic programming concepts, standard library docs, and generic patterns.

**Recognition:** "Would Claude know this without being told?"

### Skill Name in Description

Mentioning other skill names creates discoverability problems and portability violations. Describe what something does by its behavior, not by pointing to other components.

**Recognition:** "Does the description reference another skill by name?"

### External Path References

Using paths to files outside the component creates hidden dependencies. Use command names or skill invocations instead.

**Scope:** This anti-pattern applies ONLY to portable components (skills, commands, agents). Rules files and CLAUDE.md can freely reference specific paths.

**Recognition:** "Does this reference a file outside the component?"

### Content Drift

When the same concept appears in multiple places, pick a single source of truth. Cross-reference from other locations rather than duplicating.

**Recognition:** "Is this concept documented elsewhere?"

### Documentation Sync Failure

Rules are a unified system. When updating CLAUDE.md, check .claude/rules/ to keep everything synchronized.

**Recognition:** "Did I check .claude/rules/ when updating CLAUDE.md?"

### Preferring Subagents Over Skills

Skills consume 1 prompt. Subagents consume 2-5+ prompts. Before reaching for a subagent, consider whether a skill would accomplish the same task more efficiently.

**Recognition:** "Could a skill handle this?"

### Duplicate Section Anti-Pattern

Creating a "## When to Use" section in the body that duplicates frontmatter triggers is redundant and creates maintenance burden.

**Recognition:** "Does the body repeat 'When to Use' content from frontmatter?"

**Fix:** Remove duplicate sections. Frontmatter description IS the trigger mechanism.

**Audit verification:** Skills should be checked for:

- Correct opening section (`## Quick Start` or `## Workflow`)
- No duplicate "When to Use" sections
- Frontmatter description contains all trigger conditions

### Hardcoded Tool Syntax

Using precise tool syntax (e.g., `Task(subagent_type="...")`) in skills creates portability violations and may confuse with incorrect syntax.

**Recognition:** "Does this skill show exact tool invocation syntax?"

**Instead:** Use semantic patterns ("Delegate to X specialist"). Trust System Prompt for implementation.

### Rule Scope: Portability Invariant

Portability invariant applies to portable components. Commands are infrastructure.

| Component    | Portability Rule                         |
| ------------ | ---------------------------------------- |
| Skills       | Zero external dependencies               |
| Agents       | Zero external dependencies               |
| Hooks        | Zero external dependencies               |
| MCP          | Zero external dependencies               |
| **Commands** | Can reference paths, use specific syntax |

**Why**: Commands are loaded with CLAUDE.md, never forked standalone. Skills/agents may be copied between projects.

**Recognition:** "Is this component portable or infrastructure?"

### Non-Greppable Reference

Reference files without navigation tables or greppable headers fail agent discovery. AI agents tend to skip/skim, and models attend to recency—critical content missed if not discoverable multiple ways.

**Required elements for reference files:**

| Element             | Purpose             | Placement                   |
| :------------------ | :------------------ | :-------------------------- |
| Navigation table    | Recognition lookup  | File top, after frontmatter |
| Critical read block | Attention hook      | After navigation            |
| Greppable headers   | PATTERN:, EDGE:     | Throughout body             |
| Summary section     | Context compression | Before deep content         |
| Constraints footer  | Recency compliance  | File bottom                 |

**Recognition:** "Does this reference lack navigation table and greppable headers (PATTERN:, EDGE:, ANTI-PATTERN:)?"

**Fix:** Add navigation table at top, use consistent greppable section headers throughout.

**Reference:** See `architecture.md:Anti-Laziness Compensation Patterns` for complete pattern.

---

## Verification Checklist

Before claiming completion, verify:

- **Frontmatter valid** — Component loads without silent failures
- **Claims verified** — All assertions backed by file reads
- **Portability confirmed** — Works with zero external dependencies
- **Invocation tested** — Can be discovered from description alone
- **No regressions** — Related components reference correctly
- **Documentation synced** — References remain accurate

**Reference file specific:**

- **Navigation table present** — At file top, after frontmatter
- **Greppable headers** — PATTERN:, EDGE:, ANTI-PATTERN: used throughout
- **Critical read block** — For non-negotiables
- **Summary section** — Before long content
- **Constraints footer** — At file bottom for recency

---

## Summary: Recognition Questions

Use these questions to diagnose quality issues:

| Pattern             | Question                                                      |
| ------------------- | ------------------------------------------------------------- |
| Command wrapper     | "Could the description alone suffice?"                        |
| Non-self-sufficient | "Can this work standalone?"                                   |
| Context fork misuse | "Is the overhead justified?"                                  |
| Zero/negative delta | "Would Claude know this without being told?"                  |
| Content drift       | "Is this concept documented elsewhere?"                       |
| False claims        | "Did I read the actual file, or just see it in grep?"         |
| External paths      | "Does this reference files outside the component?"            |
| Non-greppable ref   | "Does reference lack navigation table and greppable headers?" |

---

## Quality as Practice

Verification is a practice, not a checkpoint. When making assertions about code, trace the actual logic—don't rely on grep results alone. Mark your confidence level. Read files before claiming existence. Verify behavior by understanding what the code does, not just what it's named.

Quality enables intelligent verification. It teaches discipline through practice, not through rigid enforcement. The goal is reliability that emerges from consistent, thoughtful habits.

---

<critical_constraint>
**Quality Physics:**

1. NO completion claims without fresh verification evidence
2. Portability Invariant: Zero external dependencies
3. Self-containment: Carry genetic code for fork isolation
   </critical_constraint>
