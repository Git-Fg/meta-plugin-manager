# Quick Reference

**Philosophy-First Reference**: See @.claude/rules/philosophy.md for core principles before applying patterns. See @.laude/rules/teaching.md for how to structure knowledge effectively.

---

# FOR DIRECT USE

⚠️ **Trust your intelligence. These are patterns and reference materials, not prescriptions. Adapt based on context.**

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

## Parameter Passing Pattern

**Caller provides arguments as key=value pairs, forked skill receives via $ARGUMENTS:**

For forked skills with context: fork, parse $ARGUMENTS to extract parameters provided by the caller.

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


## When in Doubt

**Most customization needs** met by CLAUDE.md + one Skill.

**Build from skills up** - Every capability should be a Skill first. Commands and Subagents are orchestrators, not creators.

**Reference**: [Official docs](https://agentskills.io/home)

## Quality Gate

All skills must score ≥80/100 on 11-dimensional framework before production.

**Reference**: [CLAUDE.md rules/quality-framework](rules/quality-framework.md)



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
