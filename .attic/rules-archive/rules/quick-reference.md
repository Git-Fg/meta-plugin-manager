# Quick Reference

---

# FOR DIRECT USE

⚠️ **Use these patterns when building skills and workflows**

## Skill Calling Cheat Sheet

```
Need orchestration? → Hub (regular) calls Workers (forked)
Need data transfer? → Use parameters (args="key=value")
Need isolation? → Forked skill (context: fork)
Need control return? → Forked skill (not regular)
Need nested workflows? → Forked can call forked (validated)
Need autonomy? → 80-95% without questions
Need custom tools? → Custom subagent (tools + model fields)
```

## Script Implementation Quick Reference

**When to include scripts in skills**:
- Complex operations (>3-5 lines) that benefit from determinism
- Reusable utilities called multiple times
- Performance-sensitive operations where native tool speed matters
- Operations requiring explicit error handling patterns

**When to avoid scripts**:
- Simple 1-2 line operations (use native tools directly)
- Highly variable tasks where Claude's adaptability is valuable
- One-time operations that don't warrant automation

**Core Script Principles**:
- **Solve, Don't Punt**: Handle errors explicitly with try/except and fallbacks
- **Avoid Magic Numbers**: Document all config constants with rationale (WHY chosen)
- **Self-Contained**: Validate dependencies, document prerequisites
- **Edge Cases**: Handle empty files, missing directories, permissions
- **Meaningful Exit Codes**: 0=success, 1=input error, 2=system error, 3=blocked
- **Forward Slashes**: Use Unix-style paths for cross-platform compatibility

**Script Structure Template**:
```bash
#!/usr/bin/env bash
# Script Name - Brief single-line description
#
# Dependencies: jq 1.6+, curl 7.79+
#
# Exit Codes:
#   0 - Success
#   1 - Input validation error
#   2 - System configuration error
#   3 - Permission denied
#
set -euo pipefail

# Configuration - All values documented
# Three retries balance reliability vs speed
DEFAULT_RETRIES=3

validate_dependencies() {
    command -v jq >/dev/null 2>&1 || { echo "Missing jq"; exit 2; }
}

main() {
    validate_dependencies
    # Process...
}

main "$@"
```

**See**: [skills-knowledge/references/script-best-practices.md](../skills/skills-knowledge/references/script-best-practices.md) for comprehensive patterns.

## Skill Description: What-When-Not Framework

**Component parts**:
- **WHAT**: What the skill does (core function)
- **WHEN**: When to use it (triggers, contexts)
- **NOT**: What it doesn't do (boundaries)

**Anti-Pattern**: "Use to CREATE (new projects), REFACTOR (cleanup)"
- Contains "how" language ("Use to")
- Describes implementation, not purpose

**Good Pattern**: "Maintain CLAUDE.md project memory. Use when: new project setup, documentation is messy, conversation revealed insights"
- Describes what + when
- No "how" language
- Trusts Claude's intelligence

## INCREMENTAL-UPDATE Default Pattern

**Default behavior when prior conversation exists**:
- ANY prior conversation → Default to INCREMENTAL-UPDATE
- No explicit request needed — prior conversation IS the trigger
- Review conversation for: working commands, discovered patterns, errors encountered, new rules learned

**Recognition question**: "Is there prior conversation with discoverable knowledge?"
- Yes → INCREMENTAL-UPDATE (capture knowledge)
- No → Use appropriate mode based on explicit request

## Unified Documentation Rule

**CLAUDE.md + .claude/rules/ are a single unit**:
- Always review and update both together
- When CLAUDE.md changes → Check .claude/rules/ for updates
- When .claude/rules/ change → Check CLAUDE.md for updates
- CLAUDE.md may reference .claude/rules/ that no longer exist
- **Prevents drift** between documentation layers

**Recognition question**: "Did I check both files when updating documentation?"

## Decision Tree

```
├─ Multi-step workflow?
│  └─ Yes → Use forked skills (context: fork)
│
├─ Need to aggregate results?
│  └─ Yes → ALL workers MUST be forked
│
├─ Need caller context?
│  ├─ Yes → DON'T fork
│  └─ No → Use fork (context: fork)
│
├─ Need parallel execution?
│  └─ Yes → Use forked skills (security isolation)
│
└─ Need custom tools?
   └─ Yes → Custom subagent (tools + model)
│
├─ Need persistent task tracking?
│  └─ Yes → Use TaskList for orchestration
│
└─ Complex multi-step with dependencies?
    └─ Yes → Use TaskList for orchestration
```

## Testing Commands (from skills/test-runner/references/execution-patterns.md)

### Skill Discovery Test
```bash
!pwd
mkdir <use-actual-path>test-discovery
cd <use-actual-path>test-discovery && claude --dangerously-skip-permissions -p "List all available skills" --output-format stream-json --verbose --debug --no-session-persistence --max-turns 5 > <use-actual-path>test-discovery/test-output.json 2>&1
cat <use-actual-path>test-discovery/test-output.json
```
**Verify**: Line 1 shows your test skills in `"skills"` array.

### Autonomy Test
```bash
!pwd
mkdir <use-actual-path>test-autonomy
cd <use-actual-path>test-autonomy && claude --dangerously-skip-permissions -p "Create README with project structure" --output-format stream-json --verbose --debug --no-session-persistence --max-turns 8 > <use-actual-path>test-autonomy/test-output.json 2>&1
cat <use-actual-path>test-autonomy/test-output.json
```
**Verify**: No `"permission_denials"` in line 3, README created.

### Context Fork Isolation Test
```bash
!pwd
mkdir <use-actual-path>test-fork
# Create forked skill with context: fork in frontmatter
cd <use-actual-path>test-fork && claude --dangerously-skip-permissions -p "Call forked skill, verify context isolation" --output-format stream-json --verbose --debug --no-session-persistence --max-turns 15 > <use-actual-path>test-fork/test-output.json 2>&1
cat <use-actual-path>test-fork/test-output.json
```
**Verify**: Forked skill executes without accessing main conversation variables.

## Parameter Passing Pattern

**Caller invokes with:**
```yaml
Skill("analyze-data", args="dataset=production_logs timeframe=24h")
```

**Forked skill receives via $ARGUMENTS:**
```yaml
---
name: analyze-data
context: fork
---
Scan $ARGUMENTS:
1. Parse: dataset=production_logs timeframe=24h
2. Execute analysis
3. Output: ## ANALYZE_COMPLETE
```

## Context Isolation Model

**🔒 SECURITY ISOLATION**: Forked skills cannot access:
- Caller's conversation history
- User preferences (user_preference, session_id)
- Context variables (project_codename, etc.)
- Caller's session state

**✅ WHAT PASSES**:
- Parameters via `args` (proper data transfer method)
- Their own isolated execution context
- Files they create/modify

**🛡️ USE FOR**:
- Parallel processing (secure isolation)
- Untrusted code execution (security barrier)
- Multi-tenant processing (isolated contexts)
- Noisy operations (keep main context clean)

**❌ DON'T FORK WHEN**:
- Need conversation history
- Need user preferences
- Need previous workflow steps
- Simple sequential tasks

## Autonomy Levels (from skills/test-runner/references/autonomy-testing.md)

**Check test-output.json line 3:**
```json
"permission_denials": [
  {
    "tool_name": "AskUserQuestion",
    "tool_input": { "questions": [...] }
  }
]
```

| Score | Questions | Grade |
|-------|-----------|-------|
| 95% | 0-1 | Excellence |
| 85% | 2-3 | Good |
| 80% | 4-5 | Acceptable |
| <80% | 6+ | Fail |

## Skill Completion Markers

**Each skill must output:**
```
## SKILL_NAME_COMPLETE
```

**Expected formats:**
- `## SKILL_A_COMPLETE`
- `## FORKED_OUTER_COMPLETE`
- `## CUSTOM_AGENT_COMPLETE`
- `## ANALYZE_COMPLETE`

## Test-Validated Patterns (from tests/results/TEST_RESULTS_SUMMARY.md)

✅ **Test 2.2**: Context isolation confirmed
✅ **Test 2.3**: 100% autonomy validated
✅ **Test 3.2**: Custom subagents work (Read+Grep, Haiku)
✅ **Test 4.2**: Nested forks validated
✅ **Test 5.1**: Parameter passing works
✅ **Test 7.1**: Hub-and-spoke pattern validated

## Testing Workflow

**MANDATORY**:
1. **First**: Call `test-runner` skill to automate pattern detection
2. **Then**: Read full log manually if analyzer output unclear
3. **Watch for**: synthetic skill use (hallucinated) vs. real tool/task/skill use

**NEVER**:
- Create test runner scripts (run_*.sh, batch_*.sh)
- Use `cd` to navigate (unreliable)
- Run multiple tests in monitoring loops

## Project Structure Quick Reference

```
.claude/
├── skills/                      # Skills are PRIMARY building blocks
│   └── skill-name/
│       ├── SKILL.md            # <500 lines (Tier 2)
│       └── references/          # On-demand (Tier 3)
├── agents/                      # Context fork isolation
├── hooks/                       # Event automation
├── settings.json                # Project-wide hooks & configuration
├── settings.local.json          # Local overrides (gitignored)
└── .mcp.json                   # MCP server configuration
```

## Router Logic (from toolkit-architect/SKILL.md)

**Route to specialized architects:**
- "I need a skill" → Route to skills-architect
- "I want web search" → Route to mcp-architect
- "I need hooks" → Route to hooks-architect
- "I need a PR reviewer" → Route to skills-architect or subagents-architect

## When in Doubt

**Most customization needs** met by CLAUDE.md + one Skill.

**Build from skills up** - Every capability should be a Skill first. Commands and Subagents are orchestrators, not creators.

**Reference**: [Official docs](https://agentskills.io/home)

## Quality Gate

All skills must score ≥80/100 on 11-dimensional framework before production.

**Reference**: [CLAUDE.md rules/quality-framework](rules/quality-framework.md)

## Tool Layer Architecture (CRITICAL)

TaskList is a **fundamental primitive for complex workflows**, NOT on the same layer as skills.

### Layer 0: Workflow State Engine

**TaskList**: Fundamental primitive for complex workflows
- Context window spanning across sessions
- Multi-session collaboration with real-time updates
- Enables indefinitely long projects

### Layer 1: Built-In Claude Code Tools

**Execution Primitives**: `Write`, `Edit`, `Read`, `Bash`, `Grep`, `Glob`, `LSP`

**Orchestration Tools**:
- `Skill` tool - Built-in skill invoker (loads user content)
- `Task` tool - Built-in subagent launcher

### Layer 2: User-Defined Content (Invoked BY Layer 1)

```
Skill tool (built-in) → loads → .claude/skills/*/SKILL.md (user content)
                                              ↓
                                  May use TaskList (Layer 0) for complex workflows
                                              ↓
                                  May call Task tool (built-in)
                                              ↓
                                  launches → .claude/agents/*.md (user content)
```

### Key Distinction

| Aspect | TaskList (Layer 0) | Agent/Task Tools (Layer 1) | Skills (Layer 2) |
|--------|-------------------|-----------------------------|------------------|
| **Layer** | Workflow state engine | Built-in tools | User content |
| **Purpose** | Complex workflow orchestration | Tool invocation | Domain workflows |
| **Scope** | Multi-session, indefinite projects | Session-bound execution | Task-specific expertise |
| **Relationship** | Enables long-running workflows | Execute operations | Implement functionality |

**TaskList is to workflow state what Write/Edit are to file operations.**

### ABSOLUTE CONSTRAINT: Natural Language Only

**❌ NEVER use code examples when citing TaskList/Agent/Task tools**:
- TaskList (Layer 0) - fundamental primitive
- Agent tool (Layer 1) - launches subagents
- Task tool (Layer 1) - built-in subagent launcher

**Why these tools are different**:
- TaskList is a **fundamental primitive** for complex workflows
- Agent/Task tools are **built-in** to Claude Code (Layer 1)
- Claude **already knows** their structure and API
- Code examples add context drift risk and token waste
- The AI reading your skill knows how to use them

**✅ ALWAYS use natural language**:
- Describe **WHAT** needs to happen in **WHAT ORDER**
- Describe dependencies (e.g., "validation must complete before optimization")
- Describe the workflow, not the tool invocation
- Trust Claude's intelligence to use built-in tools correctly

**Example**:
```markdown
## Task-Integrated Quality Validation

For complex audits requiring visual progress tracking and dependency enforcement:

First scan the .claude/ structure to identify all components, then validate each component type in parallel (skills, subagents, hooks, MCP), check standards compliance after all component validation completes, and finally generate the quality report.

**Critical dependency**: Component validation waits for structure scan to complete, ensuring comprehensive evaluation.
```

**Not this** (anti-pattern):
```python
TaskCreate(subject="Scan .claude/ structure")
TaskCreate(subject="Validate skills", addBlockedBy=["Scan .claude/ structure"])
```

## Task Integration Patterns

**Complex workflows (5+ steps)**: Use TaskList for orchestration
- Visual progress tracking (Ctrl+T)
- Dependency management between steps
- Persistent state across invocations

**Context window spanning**: TaskList enables indefinitely long projects
- When conversation exceeds context window, start new session with same CLAUDE_CODE_TASK_LIST_ID
- New session picks up where previous left off
- Work continues across context boundaries
- Without TaskList: work lost when context fills up

**Multi-session collaboration**: Real-time synchronization
- When one session updates a Task, broadcasted to all sessions working on same Task List
- Multiple sessions collaborate on single project
- Environment variable: CLAUDE_CODE_TASK_LIST_ID=my-project

**Subagent trigger pattern**: TaskList + Subagents is the intended pattern
- Primary trigger: spawning subagents for distributed work
- Use owner field to assign tasks to specific subagents
- Multiple subagents work on same task list simultaneously

**Dependency tracking**: Use addBlockedBy for sequential steps
- Ensures proper sequencing (e.g., execution blocked by pre-flight)
- Prevents skipping critical validation steps

**Session-spanning work**: Set CLAUDE_CODE_TASK_LIST_ID for persistence
- Tasks survive across sessions
- Stored in ~/.claude/tasks/[id]/

**"Unhobbling" principle**: Claude already knows what to do for smaller tasks
- TodoWrite was removed because newer models handle simple tasks autonomously
- TaskList (Layer 0) is for complex projects exceeding autonomous state tracking
- **Threshold**: "Would this exceed Claude's autonomous state tracking?"
- TaskList enables indefinitely long projects through context window spanning

**Skill-integrated patterns**: Individual skills may use TaskList tools for their own workflows
- test-runner: Unified testing with pre-flight blocking
- skills-architect: ENHANCE blocked by EVALUATE results
- task-architect: User-invoked session-spanning workflows

---

# TO KNOW WHEN

Understanding these patterns helps make better architectural decisions.

## Layer Architecture Recognition

**Three-Layer Model**:
- **Layer 0 (TaskList)**: Workflow state engine for complex, multi-session projects
- **Layer 1 (Built-in Tools)**: Execution and orchestration primitives
- **Layer 2 (User Content)**: Skills, subagents, commands

**Recognition Pattern**:
- Simple, session-bound work → Layer 1 tools directly
- Complex, multi-session work → Layer 0 (TaskList) orchestrates Layer 1
- Domain expertise → Layer 2 (Skills) implement

## "Unhobbling" Principle

**When to recognize**: TodoWrite was removed because newer models handle simple tasks autonomously.

**Threshold Decision**:
- **Yes**: "Would this exceed Claude's autonomous state tracking?" → Use TaskList
- **No**: Can Claude complete this independently? → Use skills directly

**Context Spanning Recognition**:
- Projects requiring context window spanning need TaskList
- Multi-session collaboration requires TaskList
- Work that must survive context limits needs Layer 0

## Natural Language Citations

**Built-in tools** (Layer 0/1) require natural language:
- TaskList: Fundamental primitive, Claude knows how to use
- Agent/Task tools: Built-in orchestration, Claude knows structure

**Why natural language**:
- Claude already knows built-in tool APIs
- Code examples add context drift risk
- Trust AI intelligence for tool usage

**Recognition**: If you're writing code examples for TaskList/Agent/Task tools → anti-pattern
