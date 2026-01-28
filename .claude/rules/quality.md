# Quality: The Safety Rails

**"Smell Tests," Anti-Hallucination, and "Trust but Verify"**

This document provides the quality guardrails that prevent agents from making common mistakes, hallucinating claims, and failing to verify their work.

---

## The Iron Law: Trust but Verify

<critical_constraint>
**NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE**

The Agent is free to execute (Trust), but it **MUST** provide evidence (Verify) before claiming a task is done.

**Trust**: Assume the Agent is expert-level and can execute independently.
**Verify**: Require evidence (test logs, grep results, file reads) before completion.

This is "Trust but Verify" - not "Micromanage everything."
</critical_constraint>

### What This Means

**Forbidden patterns:**

- ❌ "Looks complete, I'm done" (no verification)
- ❌ "Should work now" (untested assumption)
- ❌ "That should fix it" (no confirmation)

**Required patterns:**

- ✅ Read file → Trace logic → Confirm claim → Mark VERIFIED
- ✅ Test invocation → Confirm skill/command loads → Fix frontmatter → Re-test
- ✅ Portability check → Confirm works with zero rules dependencies → Fix issues

### Anti-Hallucination

Reserve constraints for "Negative Knowledge" (what _not_ to do), which is where AI typically needs the most guidance:

- **Security**: What MUST NEVER be done (expose secrets, skip validation)
- **Verification**: What evidence is required before claiming done
- **Anti-patterns**: Common mistakes that even experts make

### Verification Checklist

Before claiming completion, verify:

- [ ] **Frontmatter valid** - Component loads without silent failures (check YAML syntax, required fields)
- [ ] **Claims verified** - All factual claims marked VERIFIED with file reads
- [ ] **Portability confirmed** - Component works with zero .claude/rules dependencies
- [ ] **Invocation tested** - Component can be discovered/invoke from description alone
- [ ] **No regressions** - Related components still reference correctly
- [ ] **Documentation synced** - References are accurate and complete

---

## Recognition-First Approach

Think of anti-patterns as "smell tests" - quick checks that reveal deeper issues. Instead of memorizing rules, ask recognition questions:

- "Could the description alone suffice?"
- "Can this work standalone?"
- "Is the overhead justified?"
- "Would Claude know this without being told?"
- "Did I read the actual file, or just see it in grep?"

If the answer suggests a problem, look deeper.

---

## Claim Verification Protocol

**LESSON LEARNED:** An 80% false claim rate occurred when grep results were trusted without reading files.

### Before Making Existence Claims

When asserting "X exists", "X doesn't exist", or "X has/lacks Y":

#### 1. EXISTS Claims

```
WRONG: grep found "try.*catch" in file -> "file has error handling"
RIGHT: Read the file, find the try/catch block, confirm it wraps relevant code
```

#### 2. DOESN'T EXIST Claims

```
WRONG: grep returned no results -> "feature doesn't exist"
RIGHT: Search with Glob, try alternate names, Read likely files to confirm absence
```

#### 3. BEHAVIOR Claims

```
WRONG: Found function name in grep -> "system does X"
RIGHT: Read the function, trace the logic, understand what it actually does
```

### Confidence Markers

Mark every factual claim about the codebase:

| Marker      | Meaning                        | When to Use                 |
| ----------- | ------------------------------ | --------------------------- |
| ✓ VERIFIED  | Read the file, traced the code | Safe to assert              |
| ? INFERRED  | Based on grep/search pattern   | Must verify before claiming |
| ✗ UNCERTAIN | Haven't checked                | Must investigate            |

### Two-Pass Audit Pattern

When doing system audits or reviews:

**Pass 1: Hypotheses**

```
"I think X might be missing" (? INFERRED)
```

**Pass 2: Verification**

```
Read the actual file
-> Found X at line 42
-> "X exists at file.ts:42" (✓ VERIFIED)
```

### Common False Claim Patterns

| Pattern                        | Why It Fails                             |
| ------------------------------ | ---------------------------------------- |
| `grep -L "pattern"`            | File might use different naming          |
| `grep "error"` returns nothing | Might be called "exception" or "failure" |
| "No files matched"             | Searched wrong directory or extension    |
| Found in comments              | Not actual implementation                |

### Recognition Questions

Before making a claim, ask:

- "Did I read the actual file, or just see it in grep?"
- "Could this be named differently?"
- "Is there context I'm missing?"

**Remember**: Recognition over generation. Verify before claiming.

---

## Generic Anti-Patterns

### DO/DON'T Quick Reference

**DO:**

- ✅ Trust AI intelligence for quality evaluation
- ✅ Use conversational tone ("you might", "consider")
- ✅ Provide principles, not prescriptions
- ✅ Include "Why it matters" explanations
- ✅ Challenge every piece of information
- ✅ Read files before claiming existence

**DON'T:**

- ❌ Use "ALWAYS/NEVER/MUST" for non-critical things
- ❌ Provide exhaustive examples for simple patterns
- ❌ Explain Claude-obvious concepts
- ❌ Create skills that just invoke commands
- ❌ Duplicate content across files
- ❌ Trust grep without verification

### Command Wrapper

<anti_pattern name="command_wrapper">
<definition>Creating skills that serve only as wrappers for single CLI commands.</definition>
<recognition_trigger>
Question: "Could the description alone suffice?"
</recognition_trigger>
<fix>
Delete the skill. Improve the command description instead.
Reserve `disable-model-invocation` for destructive operations (deploy, delete, send).
</fix>
</anti_pattern>

### Non-Self-Sufficient

<anti_pattern name="non_self_sufficient">
<definition>Skills that require constant user hand-holding, failing to achieve 80-95% autonomy (0-5 questions per session).</definition>

<autonomy_standards>
| Questions | Autonomy | Status |
|----------|----------|--------|
| 0 | 95-100% | Excellent |
| 1-3 | 85-95% | Good |
| 4-5 | 80-85% | Acceptable |
| 6+ | <80% | Fail |
</autonomy_standards>

<recognition_trigger>
Question: "Can this work standalone?"
</recognition_trigger>
<fix>
Add concrete patterns, examples, and decision criteria.
</fix>
</anti_pattern>

### Context Fork Misuse

<anti_pattern name="context_fork_misuse">
<definition>Using context fork when overhead isn't justified. Forked skills cannot access caller's conversation history.</definition>

<context>
Parameters via `args` ARE the proper data transfer method.
</context>

<recognition_trigger>
Question: "Is the overhead justified?"
</recognition_trigger>
<fix>
Use fork only for isolation, parallel processing, or untrusted code.
Otherwise use regular skill invocation.
</fix>
</anti_pattern>

### Zero/Negative Delta

<anti_pattern name="zero_negative_delta">
<definition>Providing information Claude already knows from training.</definition>

<positive_delta>

- Project-specific architecture decisions
- Domain expertise not in general training
- Non-obvious bug workarounds
- Team-specific conventions
  </positive_delta>

<zero_negative_delta>

- General programming concepts
- Standard library documentation
- Common patterns Claude already knows
- Generic tutorials
  </zero_negative_delta>

<recognition_trigger>
Question: "Would Claude know this without being told?"
</recognition_trigger>
<fix>
Delete content that Claude would know from training.
</fix>
</anti_pattern>

### Skill Name in Description

<anti_pattern name="skill_name_in_description">
<definition>Mentioning other skill names in component descriptions creates discoverability anti-patterns and portability violations.</definition>

<recognition_trigger>
Question: "Does the description reference another skill by name?"
</recognition_trigger>

<fix>
Describe by behavior, not by referencing components:

| Instead of...                                          | Use...                                             |
| ------------------------------------------------------ | -------------------------------------------------- |
| "Reusable logic libraries (use invocable-development)" | "Logic libraries that Claude invokes contextually" |
| "Background event handling (use hook-development)"     | "Background event handling"                        |
| "User-triggered commands (use invocable-development)"  | "User-triggered commands"                          |

Claude discovers skills through the skill system—descriptions should explain what the component does, not point to others.
</fix>
</anti_pattern>

### Empty Scaffolding

<anti_pattern name="empty_scaffolding">
<definition>Creating directories with no content, creating technical debt.</definition>

<recognition_trigger>
Question: "Is this directory empty with no planned content?"
</recognition_trigger>
<fix>
Remove directories with no content immediately after refactoring.
</fix>
</anti_pattern>

### External Path References

<anti_pattern name="external_path_references">
<definition>Using relative paths to files outside a skill/command from within the component.</definition>

<context>
Skills/commands must be portable and work in isolation. Relative paths to external files create dependencies that break when the component is moved.
</context>

<recognition_trigger>
Question: "Does this reference a file outside the component's own directory?"
</recognition_trigger>

<fix>
**Never use relative paths to external files.** Instead:

1. **Use precise command names**:
   - "Invoke `/toolkit:skill:audit`" instead of "see ../toolkit/skill:audit.md"
   - "Use the skill `tdd-workflow`" instead of "see ../../skills/tdd-workflow/"

2. **Use Skill invocation with specific file references**:
   - "Invoke the skill `create-agent-skills` and read `workflows/create-domain-expertise-skill.md`"
   - "Use `invocable-development` skill, reference `workflows/add-workflow.md`"

3. **Bundle the philosophy directly**:
   - Include condensed principles in the skill's own metadata
   - Use "genetic code injection" for portability
     </fix>
     </anti_pattern>

---

## Documentation Anti-Patterns

### Stale URLs

<anti_pattern name="stale_urls">
<definition>Including URLs in documentation without verification.</definition>
<recognition_trigger>
Question: "Did I verify this URL works before including it?"
</recognition_trigger>
<fix>
Always verify with web fetch tools before adding URLs.
</fix>
</anti_pattern>

### Content Drift

<anti_pattern name="content_drift">
<definition>Same concept documented in multiple places, creating maintenance burden and inconsistency.</definition>
<recognition_trigger>
Question: "Is this concept already documented elsewhere?"
</recognition_trigger>
<fix>
Choose single source of truth for each concept, cross-reference from other locations.
</fix>
</anti_pattern>

### Generic Tutorials in Rules

<anti_pattern name="generic_tutorials_in_rules">
<definition>Including generic tutorials (how to use Git, what is YAML) in project-specific documentation.</definition>
<recognition_trigger>
Question: "Is this generic programming knowledge or project-specific?"
</recognition_trigger>
<fix>
Remove generic content. Keep only project-specific rules and conventions.
</fix>
</anti_pattern>

### Extraneous Documentation Files

<anti_pattern name="extraneous_documentation_files">
<definition>Creating auxiliary documentation files in skills (README.md, INSTALLATION_GUIDE.md, etc.).</definition>

<context>
Skills should contain only information needed for an AI agent to do the job.
</context>

<do_not_create>

- README.md
- INSTALLATION_GUIDE.md
- QUICK_REFERENCE.md
- CHANGELOG.md
- TUTORIAL.md
- GUIDE.md
- Any "how to use" documentation
  </do_not_create>

<recognition_trigger>
Question: "Is this file explaining how to use or set up a skill?"
</recognition_trigger>

<fix>
Delete auxiliary documentation. Skills are for AI agents, not human users.
</fix>
</anti_pattern>

### Documentation Sync Failure

<anti_pattern name="documentation_sync_failure">
<definition>Updating CLAUDE.md without checking .claude/rules/ (or vice versa).</definition>

<context>
Rules are unified—always review .claude/rules/ as a single system.
</context>

<recognition_trigger>
Question: "Did I check .claude/rules/ when updating CLAUDE.md?"
</recognition_trigger>

<fix>
When CLAUDE.md changes, .claude/rules/ may need updating.
When .claude/rules/ change, CLAUDE.md may need updating.
</fix>
</anti_pattern>

---

## Prompt Efficiency Anti-Patterns

### Preferring Subagents Over Skills

<anti_pattern name="preferring_subagents_over_skills">
<definition>Using subagents when skills would work - consumes 2-5x more prompts for same outcome.</definition>

<context>
Skills consume 1 prompt. Subagents consume multiple prompts (2-5+).
Critical for: Limited prompts (150 prompts/5h plans)
</context>

<recognition_trigger>
Question: "Could a skill handle this?"
</recognition_trigger>

<fix>
Use skills unless you specifically need subagent capabilities (context isolation, independent operation).
</fix>
</anti_pattern>

---

## Component-Specific Anti-Patterns

For component-specific anti-patterns, see the relevant meta-skill documentation in `.claude/skills/`:

| Component | You'll find guidance for...                       |
| --------- | ------------------------------------------------- |
| Skills    | Architectural patterns, field confusion, autonomy |
| Commands  | Script patterns, bash execution, frontmatter      |
| Agents    | Agent-specific fields, triggering, isolation      |
| Hooks     | Event handling patterns, security validation      |
| MCPs      | Server configuration, tool definitions            |

---

## Summary: Recognition Questions

| Pattern                  | Recognition Question                                |
| ------------------------ | --------------------------------------------------- |
| Command wrapper          | "Could the description alone suffice?"              |
| Non-self-sufficient      | "Can this work standalone?"                         |
| Context fork misuse      | "Is the overhead justified?"                        |
| Zero/negative delta      | "Would Claude know this without being told?"        |
| Content drift            | "Is this documented elsewhere?"                     |
| False claims             | "Did I read the actual file, or just grep?"         |
| Empty scaffolding        | "Is this directory empty with no content?"          |
| External path references | "Does this reference a file outside the component?" |

**Think of it this way**: These patterns help recognize problems, not prescribe solutions. Use your judgment based on context.

---

<critical_constraint>
MANDATORY: Mark every factual claim with confidence marker (VERIFIED/INFERRED/UNCERTAIN)
MANDATORY: Read actual file before asserting "X exists"
MANDATORY: Verify behavior by tracing logic, not just grep
MANDATORY: No completion claims without fresh verification evidence
MANDATORY: Verify frontmatter validity, portability, and invocation before claiming done
MANDATORY: Use recognition questions instead of memorized rules
MANDATORY: Trust intelligence - these are smell tests, not prescriptions
No exceptions. Anti-patterns enable recognition, not rigid enforcement.
</critical_constraint>
