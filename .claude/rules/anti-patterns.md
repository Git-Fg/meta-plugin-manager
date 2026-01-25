# Common Anti-Patterns

**Trust your intelligence. These patterns help recognize when things go wrong. Adapt based on context.**

---

## Recognition-First Approach

Think of anti-patterns as "smell tests" - quick checks that reveal deeper issues. Instead of memorizing rules, ask recognition questions:

- "Could the description alone suffice?"
- "Can this work standalone?"
- "Is the overhead justified?"

If the answer suggests a problem, look deeper.

---

## DO/DON'T Quick Reference

**DO:**
- ✅ Trust AI intelligence for quality evaluation
- ✅ Use conversational tone ("you might", "consider")
- ✅ Provide principles, not prescriptions
- ✅ Include "Why it matters" explanations

**DON'T:**
- ❌ Use "ALWAYS/NEVER/MUST" for non-critical things
- ❌ Provide exhaustive examples for simple patterns
- ❌ Explain Claude-obvious concepts
- ❌ Create skills that just invoke commands

---

## Architectural Anti-Patterns

**❌ Regular skill chains expecting return** - Regular→Regular is one-way handoff
- skill-a calls skill-b → skill-b becomes final output
- skill-a NEVER resumes
- **Evidence**: Test 1.2 - skill-a → skill-b → END (skill-c never called)

**❌ Context-dependent forks** - Don't fork if you need caller context
- Forked skills cannot access caller's conversation history
- Parameters via `args` ARE the proper data transfer method

**❌ Command wrapper skills** - Skills that just invoke commands
- Pure commands are anti-pattern for skills
- Well-crafted description usually suffices
- Reserve disable-model-invocation for destructive operations (deploy, delete, send)

**❌ Linear chain brittleness** - Use hub-and-spoke instead
- Hub Skills delegate to knowledge skills
- For aggregation, ALL workers MUST use `context: fork`

**❌ Assuming nested forking doesn't work** - Forked skills can call other forked skills
- Nested forking validated to depth 2+
- Control returns properly at each level
- **Evidence**: Test 4.2 - forked-outer → forked-inner → forked-outer

**❌ Assuming system-level error detection in forked skills** - Forked failures are content
- When forked skills fail, they complete normally from system perspective
- Error detection requires parsing output content
- **Evidence**: Test 8.1 - Errors are content, not system states

**❌ Non-self-sufficient skills** - Must achieve 80-95% autonomy
- 0 questions = 95-100% autonomy
- 1-3 questions = 85-95% autonomy
- 6+ questions = <80% (fail)

**❌ Empty scaffolding** - Remove directories with no content
- Creates technical debt
- Clean up immediately after refactoring

## Script Anti-Patterns

**❌ Punting to Claude** - Handle error conditions explicitly

```bash
# Bad: Just fails and lets Claude figure it out
return open(path).read()

# Good: Handle errors with fallbacks
try:
    with open(path) as f:
        return f.read()
except FileNotFoundError:
    print(f"File {path} not found, creating default")
    with open(path, 'w') as f:
        f.write('')
    return ''
```

**Recognition**: Script assumes success, no error handling

**Fix**: Add try/except with fallback behavior

---

**❌ Magic numbers** - Undocumented configuration constants

```bash
# Bad: Why 47? Why 5?
TIMEOUT=47
RETRIES=5

# Good: Document rationale
# Three retries balance reliability vs speed
MAX_RETRIES=3
```

**Recognition**: Numbers without explanation

**Fix**: Add comments explaining WHY values chosen

---

**❌ Brittle paths** - Windows-style backslashes or relative cd

```bash
# Bad: Unreliable, breaks context
cd ../scripts
scripts\validate.sh

# Good: Absolute paths or project-relative
./.claude/scripts/validate.sh
```

**Recognition**: Relative paths, backslashes

**Fix**: Use Unix-style forward slashes, project-relative paths

---

**❌ No validation** - Missing format and error checks

```bash
# Bad: Fails cryptically
jq '.result' "$FILE"

# Good: Validate before processing
if ! jq empty "$FILE" 2>/dev/null; then
    echo "ERROR: Invalid JSON file: $FILE"
    exit 1
fi
```

**Recognition**: No input validation before processing

**Fix**: Validate format before operations

---

**❌ Over-scripting** - Scripts for simple or variable tasks

**Recognition**:
- Simple 1-2 line operations → Use native tools directly
- Highly variable tasks → Let Claude adapt intelligently
- One-time operations → Don't script, execute directly

**✅ Good script practices**:
- Complex operations (>3-5 lines) needing determinism
- Reusable utilities called multiple times
- Performance-sensitive operations
- Explicit error handling and validation

**See also**: Script Implementation Quick Reference in quick-reference.md

## Documentation Anti-Patterns

**❌ Stale URLs** - Always verify with mcp__simplewebfetch__simpleWebFetch before implementation

**❌ Missing URL sections** - Knowledge skills SHOULD include URL fetching with context

**❌ Drift** - Same concept in multiple places

**❌ Generic tutorials** - Mixed with project-specific rules

**❌ Extraneous documentation files in skills** - From skill-creator best practices
**Do NOT create in skills**:
- README.md
- INSTALLATION_GUIDE.md
- QUICK_REFERENCE.md
- CHANGELOG.md
- TUTORIAL.md
- GUIDE.md
- Any auxiliary documentation about the creation process

**Rationale**: Skills should only contain information needed for an AI agent to do the job. They should not contain auxiliary context about setup, testing procedures, or user-facing documentation. Creating additional documentation files just adds clutter and confusion.

**Recognition**: If you're creating a file that explains "how to use" or "how to set up" a skill, you're creating the wrong kind of documentation. Skills are for AI agents, not human users.

**❌ Updating CLAUDE.md without checking .claude/rules/** - Documentation synchronization failure
- CLAUDE.md and .claude/rules/ are a single unit — always review both together
- When CLAUDE.md changes, .claude/rules/ may need updating
- When .claude/rules/ change, CLAUDE.md may need updating
- CLAUDE.md may reference .claude/rules/ that no longer exist
- **Why it matters**: Prevents drift between documentation layers
- **Recognition pattern**: "Did I check .claude/rules/ when updating CLAUDE.md?"

## Skill Field Confusion (from actual test findings)

**❌ Using `context: fork` in subagents** - This is for **skills**, not subagents

**❌ Using `agent: Explore` in subagents** - This field **doesn't exist** for subagents

**❌ Using `model:` or `permissionMode:` in subagents** - Keep simple

**❌ Using `user-invocable` in subagents** - Subagents aren't skills

**❌ Using `disable-model-invocation` in subagents** - For skills, not subagents


## Hooks Anti-Patterns

**❌ Prescriptive hook patterns** - Trust AI to make intelligent decisions
**❌ Over-complex configuration hierarchies** - Start with local project settings
**❌ Interactive command references in skills** - Focus on autonomous capabilities
**❌ Deprecated legacy format emphasis** - Use modern JSON approach

## Prompt Efficiency Anti-Patterns

**❌ Preferring subagents over skills when both work**
- Skills consume 1 prompt
- Subagents consume multiple prompts
- Critical for limited prompts (150 prompts/5h plans)

---

## Troubleshooting Guide

### Skill Not Triggering

**Recognition**: Description unclear or missing triggers

**Fix**: Rewrite description using What-When-Not framework
```yaml
description: "WHAT the skill does. Use when: trigger1, trigger2, trigger3. Not for: anti-triggers."
```

### Constant Questions

**Recognition**: 6+ questions per session (autonomy <80%)

**Fix**: Add concrete patterns, examples, and decision criteria

### SKILL.md Too Long

**Recognition**: File exceeds 450 lines

**Fix**: Move detailed content to references/, keep core in SKILL.md (optimal split at 400-450 lines)

**Note**: Official examples show 400-800+ lines, but optimal progressive disclosure splits at 400-450

### Commands Not Working

**Recognition**: Command fails or produces wrong output

**Fix**: Verify command is written FOR Claude (instructions), not TO user (messages)

---

## Summary

For comprehensive recognition questions covering writing style, descriptions, and structure, see [**patterns.md**](patterns.md).

**Core anti-pattern recognition**:
- Command wrapper → "Could the description alone suffice?"
- Non-self-sufficient skills → "Can this work standalone?"
- Context fork misuse → "Is the overhead justified?"
- Zero/negative delta → "Would Claude know this without being told?"

**Think of it this way**: These patterns help recognize problems, not prescribe solutions. Use your judgment based on context.
