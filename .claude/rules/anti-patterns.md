# Common Anti-Patterns

---

# FOR DIRECT USE

⚠️ **Follow these rules when building skills and workflows** - these are actions to avoid.


## Architectural Anti-Patterns

**❌ Regular skill chains expecting return** - Regular→Regular is one-way handoff
- skill-a calls skill-b → skill-b becomes final output
- skill-a NEVER resumes

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

**❌ Magic numbers** - Undocumented configuration constants
```bash
# Bad: Why 47? Why 5?
TIMEOUT=47
RETRIES=5

# Good: Document rationale
# Three retries balance reliability vs speed
MAX_RETRIES=3
```

**❌ Brittle paths** - Windows-style backslashes or relative cd
```bash
# Bad: Unreliable, breaks context
cd ../scripts
scripts\validate.sh

# Good: Absolute paths or project-relative
./.claude/scripts/validate.sh
```

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

**❌ Over-scripting** - Scripts for simple or variable tasks
- Simple 1-2 line operations → Use native tools directly
- Highly variable tasks → Let Claude adapt intelligently
- One-time operations → Don't script, execute directly

**✅ Good script practices**:
- Complex operations (>3-5 lines) needing determinism
- Reusable utilities called multiple times
- Performance-sensitive operations
- Explicit error handling and validation

**See**: [skills-domain/references/script-best-practices.md](../skills/skills-domain/references/script-best-practices.md) for complete patterns.

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


# TO KNOW WHEN

Understanding these patterns helps recognize when anti-patterns emerge.

## Architectural Understanding

**Layer 0 (TaskList) vs Layer 2 (Skills)**:
- TaskList orchestrates complex workflows exceeding autonomous execution
- Skills implement domain-specific functionality
- Anti-patterns arise when this relationship is confused

**"Unhobbling" Principle**:
- TodoWrite was removed because newer models handle simple tasks autonomously
- TaskList exists for **complex projects** exceeding autonomous state tracking
- **Recognition pattern**: "Would this exceed Claude's autonomous state tracking?"
- If yes → Use TaskList; If no → Use skills directly

**Context Window Spanning**:
- TaskList enables indefinitely long projects
- Multi-session collaboration with real-time updates
- **When to recognize**: Complex workflows that must survive context limits

**Natural Language Citations**:
- TaskList (Layer 0) and built-in tools (Layer 1) require natural language
- **Why**: Claude already knows how to use them
- Code examples add context drift risk
- **Recognition**: Trust AI intelligence for built-in tool usage

**Unified Documentation Recognition**:
- CLAUDE.md and .claude/rules/ are a single unit — always review both together
- **Recognition pattern**: "Did I check both files when updating documentation?"
- **Why**: Prevents drift between documentation layers
- **When to recognize**: Any time CLAUDE.md or .claude/rules/ are modified

**INCREMENTAL-UPDATE Default Recognition**:
- Prior conversation exists → Default to INCREMENTAL-UPDATE
- **Recognition pattern**: "Is there prior conversation with discoverable knowledge?"
- **Why**: Prior conversation = knowledge generated = capture it
- **When to recognize**: ANY prior conversation in session, no explicit request needed
