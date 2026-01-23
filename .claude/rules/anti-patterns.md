# Common Anti-Patterns

## Testing Anti-Patterns (from skills/claude-cli-non-interactive/SKILL.md)

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
- Use `tool-analyzer` skill first for pattern detection

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

## Documentation Anti-Patterns

**❌ Stale URLs** - Always verify with mcp__simplewebfetch__simpleWebFetch before implementation
**❌ Missing URL sections** - Knowledge skills MUST include mandatory URL fetching
**❌ Drift** - Same concept in multiple places
**❌ Generic tutorials** - Mixed with project-specific rules

## Skill Field Confusion (from actual test findings)

**❌ Using `context: fork` in subagents** - This is for **skills**, not subagents

**❌ Using `agent: Explore` in subagents** - This field **doesn't exist** for subagents

**❌ Using `model:` or `permissionMode:` in subagents** - Keep simple

**❌ Using `user-invocable` in subagents** - Subagents aren't skills

**❌ Using `disable-model-invocation` in subagents** - For skills, not subagents

## Skill Structure Anti-Patterns

**❌ Kitchen sink approach** - Everything included
- Remove Claude-obvious content
- Keep only: working commands, non-obvious gotchas, architecture decisions
- "NEVER do X because [specific reason]"

**❌ Missing references when needed** - SKILL.md + references >500 lines
- Create references/ directory
- Extract deep details
- Keep SKILL.md <500 lines

## Hooks Anti-Patterns

**❌ Global hooks for component concerns** - Use component-scoped instead
**❌ Prompt hooks for PreToolUse** - Use command hooks instead
**❌ Missing quality gates** - All skills must score ≥80/100

## Prompt Efficiency Anti-Patterns

**❌ Preferring subagents over skills when both work**
- Skills consume 1 prompt
- Subagents consume multiple prompts
- Critical for limited prompts (150 prompts/5h plans)
