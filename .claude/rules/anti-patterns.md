# Common Anti-Patterns

**Trust your intelligence. These patterns help recognize when things go wrong. Adapt based on context.**

---

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

### Command Wrapper Skills

**❌ Creating skills that just invoke commands**

Pure commands are anti-pattern for skills. Well-crafted description usually suffices.

**Recognition**: "Could the description alone suffice?"

**Fix**: If the skill just runs a command, delete it. Improve the command description instead.

Reserve `disable-model-invocation` for destructive operations (deploy, delete, send).

---

### Non-Self-Sufficient Skills

**❌ Skills that require constant user hand-holding**

Skills must achieve 80-95% autonomy (0-5 questions per session).

| Questions | Autonomy | Status |
|----------|----------|--------|
| 0 | 95-100% | Excellent |
| 1-3 | 85-95% | Good |
| 4-5 | 80-85% | Acceptable |
| 6+ | <80% | Fail |

**Recognition**: "Can this work standalone?"

**Fix**: Add concrete patterns, examples, and decision criteria.

---

### Context Fork Misuse

**❌ Using context fork when overhead isn't justified**

Forked skills cannot access caller's conversation history. Parameters via `args` ARE the proper data transfer method.

**Recognition**: "Is the overhead justified?"

**Fix**: Use fork only for isolation, parallel processing, or untrusted code. Otherwise use regular skill invocation.

---

### Zero/Negative Delta

**❌ Providing information Claude already knows**

For each piece of content, ask: "Would Claude know this without being told?"

**Positive Delta (keep):**
- Project-specific architecture decisions
- Domain expertise not in general training
- Non-obvious bug workarounds
- Team-specific conventions

**Zero/Negative Delta (remove):**
- General programming concepts
- Standard library documentation
- Common patterns Claude already knows
- Generic tutorials

**Fix**: Delete content that Claude would know from training.

---

### Empty Scaffolding

**❌ Creating directories with no content**

Empty directories create technical debt.

**Recognition**: Is this directory empty with no planned content?

**Fix**: Remove directories with no content immediately after refactoring.

---

## Documentation Anti-Patterns

### Stale URLs

**❌ Including URLs without verification**

URLs in documentation should be verified before inclusion.

**Fix**: Always verify with web fetch tools before adding URLs.

---

### Content Drift

**❌ Same concept documented in multiple places**

Creates maintenance burden and inconsistency.

**Recognition**: "Is this concept already documented elsewhere?"

**Fix**: Choose single source of truth for each concept, cross-reference from other locations.

---

### Generic Tutorials Mixed with Project Rules

**❌ Including generic tutorials in project documentation**

Generic tutorials (how to use Git, what is YAML) don't belong in project-specific documentation.

**Fix**: Remove generic content. Keep only project-specific rules and conventions.

---

### Extraneous Documentation Files in Skills

**❌ Creating auxiliary documentation files in skills**

Skills should contain only information needed for an AI agent to do the job.

**Do NOT create in skills:**
- README.md
- INSTALLATION_GUIDE.md
- QUICK_REFERENCE.md
- CHANGELOG.md
- TUTORIAL.md
- GUIDE.md
- Any "how to use" documentation

**Recognition**: "Is this file explaining how to use or set up a skill?"

**Fix**: Delete auxiliary documentation. Skills are for AI agents, not human users.

---

### Documentation Synchronization Failure

**❌ Updating CLAUDE.md without checking .claude/rules/**

CLAUDE.md and .claude/rules/ are a single unit — always review both together.

**Recognition**: "Did I check .claude/rules/ when updating CLAUDE.md?"

**Fix**: When CLAUDE.md changes, .claude/rules/ may need updating. When .claude/rules/ change, CLAUDE.md may need updating.

---

## Prompt Efficiency Anti-Patterns

### Preferring Subagents Over Skills

**❌ Using subagents when skills would work**

Skills consume 1 prompt. Subagents consume multiple prompts.

| Approach | Prompts consumed |
|----------|------------------|
| Skill | 1 |
| Subagent | Multiple (2-5+) |

**Critical for**: Limited prompts (150 prompts/5h plans)

**Recognition**: "Could a skill handle this?"

**Fix**: Use skills unless you specifically need subagent capabilities (context isolation, independent operation).

---

## Component-Specific Anti-Patterns

For component-specific anti-patterns, see the relevant meta-skill:

| Component | Meta-Skill | Content |
|-----------|------------|---------|
| Skills | skill-development | Architectural patterns, field confusion, autonomy issues |
| Commands | command-development | Script patterns, bash execution issues |
| Agents | agent-development | Agent-specific field confusion, triggering issues |
| Hooks | hook-development | Event handling patterns, security issues |
| MCPs | mcp-development | Server configuration, tool definition issues |

---

## Summary

**Core recognition questions:**

| Pattern | Recognition Question |
|---------|---------------------|
| Command wrapper | "Could the description alone suffice?" |
| Non-self-sufficient | "Can this work standalone?" |
| Context fork misuse | "Is the overhead justified?" |
| Zero/negative delta | "Would Claude know this without being told?" |
| Content drift | "Is this documented elsewhere?" |
| Wrong component | "Does this belong in a meta-skill instead?" |

**Think of it this way**: These patterns help recognize problems, not prescribe solutions. Use your judgment based on context.
