# Common Anti-Patterns

**Trust your intelligence. These patterns help recognize when things go wrong. Adapt based on context.**

---

<mission_control>
<objective>Help recognize anti-patterns through recognition questions</objective>
<success_criteria>Anti-patterns identified and corrected through recognition</success_criteria>
</mission_control>

## Recognition-First Approach

Think of anti-patterns as "smell tests" - quick checks that reveal deeper issues. Instead of memorizing rules, ask recognition questions:

- "Could the description alone suffice?"
- "Can this work standalone?"
- "Is the overhead justified?"
- "Would Claude know this without being told?"

If the answer suggests a problem, look deeper.

---

## DO/DON'T Quick Reference

**DO:**

- ✅ Trust AI intelligence for quality evaluation
- ✅ Use conversational tone ("you might", "consider")
- ✅ Provide principles, not prescriptions
- ✅ Include "Why it matters" explanations
- ✅ Challenge every piece of information

**DON'T:**

- ❌ Use "ALWAYS/NEVER/MUST" for non-critical things
- ❌ Provide exhaustive examples for simple patterns
- ❌ Explain Claude-obvious concepts
- ❌ Create skills that just invoke commands
- ❌ Duplicate content across files

---

## Generic Anti-Patterns

<rule_category name="generic_anti_patterns">

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

---

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

---

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

---

<anti_pattern name="zero_negative_delta">
<definition>Providing information Claude already knows from training.</definition>

<positive_delta> - Project-specific architecture decisions - Domain expertise not in general training - Non-obvious bug workarounds - Team-specific conventions
</positive_delta>

<zero_negative_delta> - General programming concepts - Standard library documentation - Common patterns Claude already knows - Generic tutorials
</zero_negative_delta>

<recognition_trigger>
Question: "Would Claude know this without being told?"
</recognition_trigger>
<fix>
Delete content that Claude would know from training.
</fix>
</anti_pattern>

---

<anti_pattern name="skill_name_in_description">
<definition>Mentioning other skill names in component descriptions creates discoverability anti-patterns and portability violations.</definition>

<recognition_trigger>
Question: "Does the description reference another skill by name?"
</recognition_trigger>

<fix>
Describe by behavior, not by referencing components:

| Instead of...                                       | Use...                                             |
| --------------------------------------------------- | -------------------------------------------------- |
| "Reusable logic libraries (use skill-development)"  | "Logic libraries that Claude invokes contextually" |
| "Background event handling (use hook-development)"  | "Background event handling"                        |
| "User-triggered commands (use command-development)" | "User-triggered commands"                          |

Claude discovers skills through the skill system—descriptions should explain what the component does, not point to others.
</fix>
</anti_pattern>

---

<anti_pattern name="empty_scaffolding">
<definition>Creating directories with no content, creating technical debt.</definition>

<recognition_trigger>
Question: "Is this directory empty with no planned content?"
</recognition_trigger>
<fix>
Remove directories with no content immediately after refactoring.
</fix>
</anti_pattern>

</rule_category>

---

<rule_category name="documentation_anti_patterns">

<anti_pattern name="stale_urls">
<definition>Including URLs in documentation without verification.</definition>
<recognition_trigger>
Question: "Did I verify this URL works before including it?"
</recognition_trigger>
<fix>
Always verify with web fetch tools before adding URLs.
</fix>
</anti_pattern>

<anti_pattern name="content_drift">
<definition>Same concept documented in multiple places, creating maintenance burden and inconsistency.</definition>
<recognition_trigger>
Question: "Is this concept already documented elsewhere?"
</recognition_trigger>
<fix>
Choose single source of truth for each concept, cross-reference from other locations.
</fix>
</anti_pattern>

<anti_pattern name="generic_tutorials_in_rules">
<definition>Including generic tutorials (how to use Git, what is YAML) in project-specific documentation.</definition>
<recognition_trigger>
Question: "Is this generic programming knowledge or project-specific?"
</recognition_trigger>
<fix>
Remove generic content. Keep only project-specific rules and conventions.
</fix>
</anti_pattern>

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

</rule_category>

---

<rule_category name="prompt_efficiency_anti_patterns">

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

</rule_category>

---

<rule_category name="component_specific_anti_patterns">

<pattern>
For component-specific anti-patterns, see the relevant meta-skill documentation in .claude/skills/:

| Component | You'll find guidance for...                       |
| --------- | ------------------------------------------------- |
| Skills    | Architectural patterns, field confusion, autonomy |
| Commands  | Script patterns, bash execution, frontmatter      |
| Agents    | Agent-specific fields, triggering, isolation      |
| Hooks     | Event handling patterns, security validation      |
| MCPs      | Server configuration, tool definitions            |

</pattern>

</rule_category>

---

## Summary

**Core recognition questions:**

| Pattern             | Recognition Question                         |
| ------------------- | -------------------------------------------- |
| Command wrapper     | "Could the description alone suffice?"       |
| Non-self-sufficient | "Can this work standalone?"                  |
| Context fork misuse | "Is the overhead justified?"                 |
| Zero/negative delta | "Would Claude know this without being told?" |
| Content drift       | "Is this documented elsewhere?"              |
| Wrong component     | "Does this belong in a meta-skill instead?"  |

**Think of it this way**: These patterns help recognize problems, not prescribe solutions. Use your judgment based on context.

---

<critical_constraint>
MANDATORY: Use recognition questions instead of memorized rules
MANDATORY: Ask "Would Claude know this without being told?" for delta check
MANDATORY: Trust intelligence - these are smell tests, not prescriptions
No exceptions. Anti-patterns enable recognition, not rigid enforcement.
</critical_constraint>
