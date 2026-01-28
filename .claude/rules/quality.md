# Quality: The Safety Rails

**"Smell Tests," Anti-Hallucination, and "Trust but Verify"**

Think of this as the quality guardrails that prevent common mistakes, hallucinating claims, and skipping verification.

---

## The Iron Law: Trust but Verify

<critical_constraint>
**NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE**

Execute independently (Trust). Provide evidence before claiming done (Verify).
</critical_constraint>

### What This Means

**Forbidden:**

- "Looks complete" (no verification)
- "Should work" (untested assumption)
- "That should fix it" (no confirmation)

**Required:**

- Read file → Trace logic → Confirm claim → Mark VERIFIED
- Test invocation → Confirm loads → Fix issues → Re-test
- Portability check → Confirm zero rules dependencies

### Anti-Hallucination

Reserve constraints for "Negative Knowledge" (what NOT to do), where AI typically needs the most guidance:

- **Security**: What MUST NEVER be done
- **Verification**: What evidence is required before claiming done
- **Anti-patterns**: Common mistakes that even experts make

---

## Claim Verification Protocol

**LESSON LEARNED:** An 80% false claim rate occurred when grep results were trusted without reading files.

### Before Making Claims

| Claim Type   | Wrong                        | Right                                    |
| ------------ | ---------------------------- | ---------------------------------------- |
| **Exists**   | grep found X → "has X"       | Read file → Find X → Confirm code wraps  |
| **Missing**  | grep empty → "doesn't exist" | Glob + alternate names → Confirm absence |
| **Behavior** | Found name → "does X"        | Read function → Trace logic → Understand |

### Confidence Markers

| Marker      | Meaning                | When             |
| ----------- | ---------------------- | ---------------- |
| ✓ VERIFIED  | Read file, traced code | Safe to assert   |
| ? INFERRED  | Based on grep/search   | Must verify      |
| ✗ UNCERTAIN | Haven't checked        | Must investigate |

### Common False Claims

| Pattern              | Why It Fails                      |
| -------------------- | --------------------------------- |
| `grep -L "pattern"`  | Different naming possible         |
| `grep "error"` empty | Might be "exception" or "failure" |
| "No files matched"   | Wrong directory or extension      |
| Found in comments    | Not actual implementation         |

**Recognition Question:** "Did I read the actual file, or just see it in grep?"

---

## Recognition-First Approach

Think of anti-patterns as "smell tests"—quick checks that reveal deeper issues. Ask recognition questions instead of memorizing rules:

- "Could the description alone suffice?"
- "Can this work standalone?"
- "Is the overhead justified?"
- "Would Claude know this without being told?"
- "Did I read the actual file, or just see it in grep?"

If the answer suggests a problem, look deeper.

---

## Common Anti-Patterns

### Command Wrapper

**Definition:** Creating skills that serve only as wrappers for single CLI commands.

**Recognition:** "Could the description alone suffice?"

**Fix:** Delete the skill. Improve the command description instead.

---

### Non-Self-Sufficient

**Definition:** Skills requiring constant user hand-holding.

**Autonomy Standards:**

| Questions | Autonomy | Status     |
| --------- | -------- | ---------- |
| 0         | 95-100%  | Excellent  |
| 1-3       | 85-95%   | Good       |
| 4-5       | 80-85%   | Acceptable |
| 6+        | <80%     | Fail       |

**Recognition:** "Can this work standalone?"

**Fix:** Add concrete patterns, examples, and decision criteria.

---

### Context Fork Misuse

**Definition:** Using fork when overhead isn't justified.

**Recognition:** "Is the overhead justified?"

**Fix:** Use fork only for isolation, parallel processing, or untrusted code. Otherwise, use regular invocation with `args`.

---

### Zero/Negative Delta

**Definition:** Providing information Claude already knows.

| Keep (Positive Delta)            | Delete (Zero Delta)        |
| -------------------------------- | -------------------------- |
| Project-specific decisions       | Basic programming concepts |
| Domain expertise not in training | Standard library docs      |
| Non-obvious workarounds          | Generic tutorials          |
| Team conventions                 | Claude-obvious patterns    |

**Recognition:** "Would Claude know this without being told?"

---

### Skill Name in Description

**Definition:** Mentioning other skill names creates discoverability anti-patterns and portability violations.

**Recognition:** "Does the description reference another skill by name?"

**Fix:** Describe by behavior, not by referencing components:

| Instead of...               | Use...                                        |
| --------------------------- | --------------------------------------------- |
| "Use invocable-development" | "Logic libraries Claude invokes contextually" |
| "Use hook-development"      | "Background event handling"                   |

---

### External Path References

**Definition:** Using paths to files outside the component.

**Recognition:** "Does this reference a file outside the component?"

**Fix:** Use command names, skill invocations, or bundle philosophy directly.

---

### Content Drift

**Definition:** Same concept documented in multiple places.

**Recognition:** "Is this concept documented elsewhere?"

**Fix:** Choose single source of truth. Cross-reference from other locations.

---

### Documentation Sync Failure

**Definition:** Updating CLAUDE.md without checking .claude/rules/.

**Recognition:** "Did I check .claude/rules/ when updating CLAUDE.md?"

**Fix:** Rules are unified—review .claude/rules/ as a single system.

---

### Preferring Subagents Over Skills

**Definition:** Using subagents when skills would work.

**Recognition:** "Could a skill handle this?"

**Note:** Skills consume 1 prompt. Subagents consume 2-5+ prompts.

---

## Verification Checklist

Before claiming completion, verify:

- [ ] **Frontmatter valid** - Component loads without silent failures
- [ ] **Claims verified** - All claims marked VERIFIED with file reads
- [ ] **Portability confirmed** - Works with zero .claude/rules dependencies
- [ ] **Invocation tested** - Can be discovered from description alone
- [ ] **No regressions** - Related components reference correctly
- [ ] **Documentation synced** - References are accurate

---

## Summary: Recognition Questions

| Pattern             | Recognition Question                               |
| ------------------- | -------------------------------------------------- |
| Command wrapper     | "Could the description alone suffice?"             |
| Non-self-sufficient | "Can this work standalone?"                        |
| Context fork misuse | "Is the overhead justified?"                       |
| Zero/negative delta | "Would Claude know this without being told?"       |
| Content drift       | "Is this documented elsewhere?"                    |
| False claims        | "Did I read the actual file, or just grep?"        |
| External paths      | "Does this reference files outside the component?" |

---

<critical_constraint>
MANDATORY: Mark every factual claim with confidence marker (VERIFIED/INFERRED/UNCERTAIN)
MANDATORY: Read actual file before asserting "X exists"
MANDATORY: Verify behavior by tracing logic, not just grep
MANDATORY: No completion claims without fresh verification evidence
MANDATORY: Use recognition questions instead of memorized rules
MANDATORY: Verify frontmatter, portability, and invocation before claiming done
No exceptions. Quality enables intelligent verification, not rigid enforcement.
</critical_constraint>
