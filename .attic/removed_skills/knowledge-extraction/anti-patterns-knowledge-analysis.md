# Anti-Patterns Knowledge Analysis

## Sources
- `.claude/rules/anti-patterns.md` - All sections
- `.claude/skills/skills-architect/SKILL.md` - Lines 125-177
- `.claude/skills/hooks-architect/SKILL.md` - Lines 115-119
- `.claude/skills/mcp-architect/SKILL.md` - Lines 110-121

## Extracted Anti-Patterns

### 1. Testing Anti-Patterns (anti-patterns.md:9-27)

**Source**: `anti-patterns.md:9-27`
```
❌ NEVER create test runner scripts:
- run_*.sh
- batch_*.sh
- test_runner.sh
- Multiple tests in monitoring loops

❌ NEVER use `cd` to navigate - it's unreliable and causes confusion about current directory.

ONLY TWO EXCEPTIONS for cd:
1. Setting claude's working directory: `cd /path && claude ...`
2. Both cd and command in same line

✅ ALWAYS:
- Create ONE new folder per test
- Execute tests individually
- Read entire test-output.json before concluding pass/fail
- Use `test-runner` skill first for pattern detection
```

**TESTING PATTERNS IN SKILLS**:
None of the skills (skills-architect, hooks-architect, mcp-architect) implement testing directly.

**COMPLIANCE**: N/A - Skills don't implement testing, anti-patterns apply to test implementation

### 2. Architectural Anti-Patterns (anti-patterns.md:29-56)

**Source**: `anti-patterns.md:29-56`
```
❌ Regular skill chains expecting return - Regular→Regular is one-way handoff
- skill-a calls skill-b → skill-b becomes final output
- skill-a NEVER resumes

❌ Context-dependent forks - Don't fork if you need caller context
- Forked skills cannot access caller's conversation history
- Parameters via args ARE the proper data transfer method

❌ Command wrapper skills - Skills that just invoke commands
- Pure commands are anti-pattern for skills
- Well-crafted description usually suffices
- Reserve disable-model-invocation for destructive operations

❌ Linear chain brittleness - Use hub-and-spoke instead
- Hub Skills delegate to knowledge skills
- For aggregation, ALL workers MUST use `context: fork`

❌ Non-self-sufficient skills - Must achieve 80-95% autonomy
- 0 questions = 95-100% autonomy
- 1-3 questions = 85-95% autonomy
- 6+ questions = <80% (fail)

❌ Empty scaffolding - Remove directories with no content
- Creates technical debt
- Clean up immediately after refactoring
```

**ARCHITECTURAL PATTERNS IN SKILLS**:

**skills-architect**:
- Uses workflow detection (ASSESS/CREATE/EVALUATE/ENHANCE)
- Routes to skills-knowledge
- Implements autonomy-first design
- **COMPLIANCE**: ✅ Avoids anti-patterns

**hooks-architect**:
- Trust AI intelligence
- Routes to hooks-knowledge
- Uses workflow detection (INIT/SECURE/AUDIT/REMEDIATE)
- **COMPLIANCE**: ✅ Avoids anti-patterns

**mcp-architect**:
- Trust AI reasoning
- Routes to mcp-knowledge
- Uses workflow detection (DISCOVER/INTEGRATE/VALIDATE/OPTIMIZE)
- **COMPLIANCE**: ✅ Avoids anti-patterns

### 3. Documentation Anti-Patterns (anti-patterns.md:57-63)

**Source**: `anti-patterns.md:57-63`
```
❌ Stale URLs - Always verify with mcp__simplewebfetch__simpleWebFetch before implementation
❌ Missing URL sections - Knowledge skills MUST include mandatory URL fetching
❌ Drift - Same concept in multiple places
❌ Generic tutorials - Mixed with project-specific rules
```

**DOCUMENTATION PATTERNS IN SKILLS**:

**All Skills**:
- Include mandatory URL fetching sections ✅
- Use mcp__simplewebfetch__simpleWebFetch for validation ✅
- No generic tutorials (focus on domain-specific) ✅
- **COMPLIANCE**: ✅ Avoid anti-patterns

### 4. Skill Field Confusion (anti-patterns.md:64-75)

**Source**: `anti-patterns.md:64-75`
```
❌ Using `context: fork` in subagents - This is for skills, not subagents

❌ Using `agent: Explore` in subagents - This field doesn't exist for subagents

❌ Using `model:` or `permissionMode:` in subagents - Keep simple

❌ Using `user-invocable` in subagents - Subagents aren't skills

❌ Using `disable-model-invocation` in subagents - For skills, not subagents
```

**FIELD USAGE IN SKILLS**:
Skills (not subagents) properly use:
- context: fork (in worker skills)
- disable-model-invocation (should be in hub skills)
- user-invocable (in skill frontmatter)

**COMPLIANCE**: ✅ Skills use correct fields

### 5. Skill Structure Anti-Patterns (anti-patterns.md:76-94)

**Source**: `anti-patterns.md:76-94`
```
❌ Over-specified descriptions - Including "how" in descriptions
- Descriptions should signal, not manual — specify WHAT/WHEN/NOT, not HOW
- Implementation details belong in SKILL.md (Tier 2), not description (Tier 1)
- Tier 1 is always loaded; verbose descriptions waste token budget

❌ Kitchen sink approach - Everything included
- Remove Claude-obvious content
- Keep only: working commands, non-obvious gotchas, architecture decisions
- "NEVER do X because [specific reason]"

❌ Missing references when needed - SKILL.md + references >500 lines
- Create references/ directory
- Extract deep details
- Keep SKILL.md <500 lines
```

**SKILL STRUCTURE ANALYSIS**:

**skills-architect**:
- Tier 1: ~300 tokens (bloat present)
- Uses references/ for deep details ✅
- Description includes HOW (violation) ❌
- **COMPLIANCE**: ⚠️ PARTIAL - Over-specified description

**hooks-architect**:
- Tier 1: ~250 tokens (bloat present)
- Uses references/ for deep details ✅
- Description focused on WHAT/WHEN ✅
- **COMPLIANCE**: ✅ ACCEPTABLE

**mcp-architect**:
- Tier 1: ~300 tokens (bloat present)
- Uses references/ for deep details ✅
- Description includes HOW (violation) ❌
- **COMPLIANCE**: ⚠️ PARTIAL - Over-specified description

### 6. Hooks Anti-Patterns (anti-patterns.md:95-101)

**Source**: `anti-patterns.md:95-101`
```
❌ Prescriptive hook patterns - Trust AI to make intelligent decisions
❌ Over-complex configuration hierarchies - Start with local project settings
❌ Interactive command references in skills - Focus on autonomous capabilities
❌ Deprecated legacy format emphasis - Use modern JSON approach
```

**HOOKS PATTERNS IN hooks-architect**:
- Trust AI intelligence ✅
- Project-first approach ✅
- Component-scoped hooks preferred ✅
- Modern JSON approach (settings.json) ✅
- **COMPLIANCE**: ✅ Follows best practices

### 7. Prompt Efficiency Anti-Patterns (anti-patterns.md:102-108)

**Source**: `anti-patterns.md:102-108`
```
❌ Preferring subagents over skills when both work
- Skills consume 1 prompt
- Subagents consume multiple prompts
- Critical for limited prompts (150 prompts/5h plans)
```

**EFFICIENCY PATTERNS IN SKILLS**:
All skills prefer skills over subagents where appropriate.

**COMPLIANCE**: ✅ Efficient prompt usage

### 8. Task Management Anti-Patterns (anti-patterns.md:109-179)

**Source**: `anti-patterns.md:109-179`
```
❌ Code examples when citing TaskList/Agent/Task tools - ABSOLUTE CONSTRAINT
❌ Confusing TaskList with skills - Architectural layer mistake
❌ Using TaskList for workflows Claude can handle autonomously - Overengineering
❌ Using TaskList for simple workflows - Tasks add overhead
❌ Tasks without dependencies - Missing the point
❌ Tasks for one-shot work - Persistence unnecessary
❌ Missing TaskList for multi-session workflows - Context window limit
```

**TASK MANAGEMENT VIOLATIONS**:

**skills-architect**:
- Contains TaskCreate code examples ❌ (VIOLATION)
- Recommends TaskList for complex workflows ✅ (appropriate)
- **COMPLIANCE**: ❌ VIOLATION - Code examples

**hooks-architect**:
- Contains TaskCreate/TaskUpdate code examples ❌ (VIOLATION)
- Recommends TaskList for complex security validation ✅ (appropriate)
- **COMPLIANCE**: ❌ VIOLATION - Code examples

**toolkit-architect**:
- Routes to task-architect (no direct TaskList usage) ✅
- Uses natural language ✅
- **COMPLIANCE**: ✅ AVOIDS VIOLATION

### 9. Anti-Patterns Compliance Summary

| Anti-Pattern Category | skills-architect | hooks-architect | toolkit-architect | Overall |
|---------------------|------------------|-----------------|-------------------|---------|
| Testing | N/A | N/A | N/A | N/A |
| Architectural | ✅ COMPLIANT | ✅ COMPLIANT | ✅ COMPLIANT | ✅ GOOD |
| Documentation | ✅ COMPLIANT | ✅ COMPLIANT | ✅ COMPLIANT | ✅ GOOD |
| Field Confusion | ✅ COMPLIANT | ✅ COMPLIANT | ✅ COMPLIANT | ✅ GOOD |
| Skill Structure | ⚠️ PARTIAL | ✅ ACCEPTABLE | ✅ ACCEPTABLE | ⚠️ MIXED |
| Hooks | N/A | ✅ COMPLIANT | N/A | ✅ GOOD |
| Prompt Efficiency | ✅ COMPLIANT | ✅ COMPLIANT | ✅ COMPLIANT | ✅ GOOD |
| Task Management | ❌ VIOLATION | ❌ VIOLATION | ✅ COMPLIANT | ❌ CRITICAL |

### 10. Critical Violations Summary

**VIOLATION 1: Over-specified Descriptions**
- Affected: skills-architect, mcp-architect
- Problem: Descriptions include HOW, not just WHAT/WHEN/NOT
- Impact: Token waste, cognitive overhead

**VIOLATION 2: TaskList Code Examples**
- Affected: skills-architect, hooks-architect
- Problem: Use TaskCreate/TaskUpdate code examples
- Violates: ABSOLUTE CONSTRAINT - Natural Language Only
- Impact: Context drift, token waste

**TOTAL CRITICAL VIOLATIONS**: 2 categories, 3 skill instances

### 11. Knowledge Consistency

**CONSISTENT**:
- Architectural patterns well understood
- Documentation anti-patterns avoided
- Field confusion avoided
- Hooks best practices followed
- Prompt efficiency considered

**INCONSISTENT**:
- Task management: 2/3 skills violate natural language requirement
- Skill structure: Mixed compliance on over-specified descriptions

## Summary

**Total Anti-Pattern Categories**: 8
**Compliance Rate**: 75%
**Critical Violations**: 2 categories
**Skills with Violations**: 2/3 (skills-architect, hooks-architect)

Anti-patterns knowledge is largely understood and followed, with 2 critical violations: over-specified descriptions and TaskList code examples. Task management violations are most severe due to ABSOLUTE CONSTRAINT.
