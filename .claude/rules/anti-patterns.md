# Common Anti-Patterns

---

# FOR DIRECT USE

⚠️ **Follow these rules when building skills and workflows** - these are actions to avoid.

## Testing Anti-Patterns

**❌ NEVER create test runner scripts:**
- run_*.sh
- batch_*.sh
- test_runner.sh
- Multiple tests in monitoring loops

**❌ NEVER use `cd` to navigate** - it's unreliable and causes confusion about current directory.

**ONLY TWO EXCEPTIONS for cd:**
1. Setting claude's working directory: `cd /path && claude ...`
2. Both cd and command in same line

**✅ ALWAYS**:
- Create ONE new folder per test
- Execute tests individually
- Read entire test-output.json before concluding pass/fail
- Use `test-runner` skill first for pattern detection

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

**See**: [skills-knowledge/references/script-best-practices.md](../skills/skills-knowledge/references/script-best-practices.md) for complete patterns.

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

## Skill Structure Anti-Patterns

**❌ Over-specified descriptions** - Including "how" in descriptions
- Descriptions should **signal**, not **manual** — specify WHAT/WHEN/NOT, not HOW
- Implementation details belong in SKILL.md (Tier 2), not description (Tier 1)
- Tier 1 is always loaded; verbose descriptions waste token budget
- **Why it matters**: Trust Claude's intelligence. Over-specifying treats Claude like a script executor
- **Solution**: Use What-When-Not framework. See `skills-architect/references/description-guidelines.md`

**❌ Kitchen sink approach** - Everything included
- Remove Claude-obvious content
- Keep only: working commands, non-obvious gotchas, architecture decisions
- "NEVER do X because [specific reason]"

**❌ Missing references when needed** - SKILL.md + references >500 lines
- Create references/ directory
- Extract deep details
- Keep SKILL.md <500 lines

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

## Task Management Anti-Patterns

**❌ Code examples when citing TaskList/Agent/Task tools** - ABSOLUTE CONSTRAINT
- TaskList (Layer 0) is a **fundamental primitive** for complex workflows
- Agent tool and Task tool are **built-in** (Layer 1)
- Claude **already knows** their structure and how to use them
- Code examples add risk of context drift and token waste
- **✅ ALWAYS use natural language** to describe workflow and dependencies
- Describe WHAT needs to happen in what order, not HOW to invoke the tools
- Trust Claude's intelligence to use built-in tools correctly

**❌ Confusing TaskList with skills** - Architectural layer mistake
- TaskList is **Layer 0** - workflow state engine for complex workflows
- Skills are **Layer 2** - user content loaded by Skill tool
- TaskList enables indefinitely long projects through context spanning
- Skills execute domain tasks, TaskList orchestrates them

**❌ Using TaskList for workflows Claude can handle autonomously** - Overengineering
- Claude already knows what to do for smaller tasks (TodoWrite was removed for this reason)
- TaskList is for complex projects exceeding autonomous execution
- **Threshold question**: "Would this exceed Claude's autonomous state tracking?"
- Use skills directly for work Claude can complete independently

**❌ Using TaskList for simple workflows** - Tasks add overhead
- Simple 2-3 step work? Use skills directly
- Tasks shine at 5+ steps with dependencies
- Consider cognitive load vs. benefit

**❌ Tasks without dependencies** - Missing the point
- If no tasks block other tasks, you're not using dependencies
- Consider simpler skill-based workflow

**❌ Tasks for one-shot work** - Persistence unnecessary
- Session-bound work? Skills are sufficient
- Use tasks when work spans sessions or requires multi-subagent coordination

**❌ Missing TaskList for multi-session workflows** - Context window limit
- When conversation exceeds context window, start new session with same CLAUDE_CODE_TASK_LIST_ID
- TaskList enables indefinitely long projects across context boundaries
- Without TaskList: work lost when context fills up

**❌ Not capturing conversation knowledge** - Missing INCREMENTAL-UPDATE default
- When there is ANY prior conversation in a session, default to INCREMENTAL-UPDATE
- Prior conversation = knowledge has been generated = capture it
- No explicit request needed — prior conversation IS the trigger
- Review conversation for: working commands, discovered patterns, errors encountered, new rules learned
- **Recognition pattern**: "Is there prior conversation with discoverable knowledge?"

---

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
