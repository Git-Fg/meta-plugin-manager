# CLAUDE.md

**IMPORTANT: This file has TWO purposes - see sections below.**

## Purpose 1: Project Operational Rules (FOR AI AGENTS)

This section contains rules for AI agents working on THIS specific project. When you work on this project, these are your operational constraints.

**Examples:**
- Project-specific conventions
- Local environment quirks
- Business logic constraints
- Non-obvious workarounds discovered through experience

## Purpose 2: Meta-Skill Teaching (FOR SKILL CREATORS)

This section teaches HOW to create effective meta-skills for ANY project. It's educational content for building the skill ecosystem.

**Why this distinction matters:**
- AI agents using your skills will NOT have access to CLAUDE.md
- Skills must be SELF-SUFFICIENT - they must contain everything needed to function
- Referencing CLAUDE.md from a skill breaks portability

---

Project scaffolding toolkit for Claude Code focused on .claude/ configuration with skills-first architecture and progressive disclosure.

---

# SECTION 1: PROJECT OPERATIONAL RULES

**When working on THIS project, apply these rules:**

## Local Project Conventions

- This project uses **Knowledge-Factory architecture (v4)** - clean separation of knowledge and execution
- **Knowledge Skills** (passive reference): knowledge-skills, knowledge-mcp, knowledge-hooks, knowledge-subagents
- **Factory Skills** (script-based execution): create-skill, create-mcp-server, create-hook, create-subagent
- All factory skills have bash/python scripts in `scripts/` directory
- test-runner is the reference pattern for script-based skills

## v4 Architecture (2026-01-24)

This project uses **Knowledge-Factory architecture** with clean separation between knowledge and execution.

### Knowledge Skills (Passive Reference)

Pure reference information without execution logic:
- **knowledge-skills**: Agent Skills standard, Progressive Disclosure, quality framework
- **knowledge-mcp**: Model Context Protocol, transports (stdio/http), primitives (tools/resources/prompts)
- **knowledge-hooks**: Events (PreToolUse/PostToolUse/Stop), security patterns, exit codes
- **knowledge-subagents**: Agent types, frontmatter fields, context detection, coordination patterns

**Usage Pattern**: Load knowledge to understand concepts, then use factory for execution.

### Factory Skills (Script-Based Execution)

Active execution with deterministic bash/python scripts:
- **create-skill**: Skill scaffolding (scaffold_skill.sh, validate_structure.sh)
- **create-mcp-server**: MCP registration (add_server.sh, validate_mcp.sh, merge_config.py)
- **create-hook**: Hook creation (add_hook.sh, scaffold_script.sh, validate_hook.sh)
- **create-subagent**: Agent creation (create_agent.sh, validate_agent.sh, detect_context.sh)

**Usage Pattern**:
```bash
# Learn concepts (Knowledge)
Skill("knowledge-skills")

# Execute operations (Factory)
Skill("create-skill", args="name=my-skill description='My skill'")
```

### Migration from v3

Architect skills (skill-architect, mcp-architect, hooks-architect, subagents-architect) were split into:
- Knowledge component (pure reference)
- Factory component (script-based execution)

See `.attic/V4_MIGRATION_SUMMARY.md` for complete migration details.

## Working Patterns Discovered

- **Test commands**: Use `claude --dangerously-skip-permissions` with stream-json output
- **Test execution**: Always use absolute paths, never /tmp/ for tests
- **Reference documentation**: Each meta-skill has extensive references/ directory with detailed patterns
- **Context fork**: Use for isolation, parallel processing, or untrusted code
- **Completion markers**: Skills should output `## SKILL_NAME_COMPLETE`

## Project-Specific Constraints

- **Comprehensive meta-skills**: test-runner (915 lines), skills-domain (16 reference files), toolkit-architect (18 reference files)
- **No duplication**: Meta-skills contain all specific patterns - rules/ contains only universal principles
- **Quality standards**: All skills should score ≥80/100 on autonomy (check permission_denials)
- **Progressive disclosure**: Tier 1 (metadata) → Tier 2 (SKILL.md <500 lines) → Tier 3 (references/)
- **Layer architecture**: TaskList (Layer 0) → Built-in tools (Layer 1) → Skills (Layer 2)

---

# SECTION 2: META-SKILL TEACHING

**Educational content for creating effective meta-skills**

## Core Philosophy for Skill Building

**Key Principles**:

1. **Context Window is a Public Good**: Challenge every token. Only add what Claude doesn't already know.
2. **Degrees of Freedom**: Match specificity to task fragility (High/Medium/Low).
3. **Trust AI Intelligence**: Claude is smart. Provide principles, not prescriptions.
4. **Local Project Autonomy**: Start with project config, expand scope only when needed.
5. **Delta Standard**: Keep expert-only knowledge, remove generic information.
6. **Progressive Disclosure**: Tier 1 (metadata) → Tier 2 (SKILL.md <500 lines) → Tier 3 (references/).

**Key insight**: Philosophy before process. Principles enable adaptation; prescriptions create brittleness.

## Critical Actions for Meta-Skill Creation

⚠️ **Skills-First Architecture**: Every capability starts as a Skill. Skills are PRIMARY building blocks. Commands and Subagents are orchestrators, not creators.

⚠️ **Hub-and-Spoke for Aggregation**: Hub Skills delegate to Workers. For result aggregation, ALL workers MUST use `context: fork`. Regular→Regular skill handoffs are one-way only (no return).

⚠️ **Progressive Disclosure**: Create references/ only when SKILL.md + references >500 lines total. Keep SKILL.md under 500 lines for tier 2 efficiency.

⚠️ **What-When-Not Descriptions**: Skill descriptions must signal WHAT (core function), WHEN (triggers), NOT (boundaries). No "Use to CREATE/REFACTOR" language.

⚠️ **Trust AI Judgment**: URL fetching is RECOMMENDED when accuracy matters, not MANDATORY. You know when validation is needed.

⚠️ **Natural Language for Built-in Tools**: When citing TaskList (Layer 0) or Agent/Task tools (Layer 1), describe workflows in natural language. No code examples.

---

## Layer Selection Decision Tree (Meta-Skill Pattern)

```
START: What do you need?
│
├─ "Persistent project norms"
│  └─→ Project rules (this file, Section 1)
│
├─ "Domain expertise to discover"
│  └─→ Knowledge Skills (knowledge-skills, knowledge-mcp, etc.)
│
├─ "Create new component"
│  └─→ Factory Skills (create-skill, create-mcp-server, etc.)
│     ├─ "Need skill" → create-skill
│     ├─ "Need MCP server" → create-mcp-server
│     ├─ "Need hook" → create-hook
│     └─ "Need subagent" → create-subagent
│
├─ "Event automation"
│  └─→ create-hook factory
│
├─ "Service integration"
│  └─→ create-mcp-server factory
│
├─ "Multi-step workflow with persistence"
│  └─→ TaskList + forked workers
│
├─ "Long-running project"
│  └─→ TaskList + skills architecture
│
├─ "Complex multi-session project"
│  └─→ TaskList (Layer 0) for workflow orchestration
│
├─ "Multi-session task"
│  └─→ TaskList + subagents
│
└─ "Isolation/parallelism"
   └─→ Subagent (RARE/ADVANCED)
```

**Context: Fork Triggers:**
- High-volume output (extensive grep, repo traversal)
- Noisy exploration that clutters conversation
- Tasks needing separate context window

**When NOT to fork**:
- Need conversation history
- Need user preferences
- Simple sequential tasks

## TaskList: When and How to Use (Meta-Skill Guidance)

**TaskList is Layer 0** - a fundamental primitive for complex workflow orchestration, NOT on the same layer as skills.

**ALWAYS use TaskList for**:
- Work spanning multiple sessions (set `CLAUDE_CODE_TASK_LIST_ID`)
- Complex workflows with 5+ steps requiring dependency tracking
- Visual progress tracking (Ctrl+T)
- Work exceeding context window limits

**NEVER use TaskList for**:
- Simple 2-3 step workflows (use skills directly)
- Session-bound work without dependencies
- One-shot operations not requiring persistence

**"Unhobbling" Principle**: TaskList exists specifically for complex projects exceeding autonomous state tracking. TodoWrite was removed because newer models handle simple tasks autonomously.

**Threshold**: "Would this exceed Claude's autonomous state tracking?"

## Agent Type Selection (Meta-Skill Pattern)

**ALWAYS select based on needs**:
- **general-purpose**: Default, balanced performance
- **bash**: Command execution specialist work
- **Explore**: Fast exploration, no nested workflows
- **Plan**: Complex reasoning, architecture design

## Model Selection (Meta-Skill Pattern)

**ALWAYS consider cost**:
- **haiku**: 1x cost - use for quick validation
- **sonnet**: 3x cost - default for most work
- **opus**: 10x cost - only for complex reasoning

---

# TO KNOW WHEN (Recognition Patterns)

These patterns help you recognize when to apply specific approaches.

## Core Principles to Recognize

**Trust AI Intelligence** means:
- Provide concepts, AI makes intelligent implementation decisions
- Focus on principles, not prescriptive patterns
- Let AI choose appropriate configuration scope

**Local Project Autonomy** means:
- Always start with local project configuration
- Project directory as default location
- Team collaboration through git

**Autonomous Execution** means:
- Skills work without user interaction
- AI completes tasks independently
- Self-sufficient implementation guidance

## TaskList: Layer 0 Architecture (Meta-Skill)

**RECOGNIZE** TaskList as:
- Fundamental primitive for complex workflows
- Layer 0 workflow state engine below built-in tools
- Enables indefinitely long projects via context window spanning

**CONTEXT WINDOW SPANNING pattern**:
1. Conversation approaches context limit
2. **RECOGNIZE** need to persist: Note `CLAUDE_CODE_TASK_LIST_ID`
3. **START** new session with same `CLAUDE_CODE_TASK_LIST_ID`
4. New session **AUTOMATICALLY** picks up where previous left off
5. Work **CONTINUES** across context boundaries

**MULTI-SESSION COLLABORATION pattern**:
- When one session updates a Task, changes **BROADCAST** to ALL sessions
- Multiple sessions see updates **IMMEDIATELY**
- Enables true collaborative workflows across terminals

## Skill Over-Engineering Anti-Pattern (Meta-Skill)

**RECOGNIZE** this anti-pattern:
- Creating "logic files" (e.g., `mode-detection.md`) for behaviors Claude inherently understands

**APPLY** this solution:
- Define "Commander's Intent" in `SKILL.md`
- Let Claude handle execution details
- Keep reference files as "Data Libraries" or "Inspiration Patterns", not "Instruction Manuals"

## "Unhobbling" Principle (Meta-Skill)

**UNDERSTAND**: Newer models handle simple tasks autonomously. TaskList exists for **complex projects exceeding autonomous state tracking**.

**THRESHOLD QUESTION**: "Would this exceed Claude's autonomous state tracking?"
- Yes → Use TaskList
- No → Use skills directly

## Skill Description: What-When-Not Framework (Meta-Skill)

**RECOGNIZE**: Skill descriptions must signal WHAT/WHEN/NOT, not prescribe HOW.

**Components**:
- **WHAT**: What the skill does (core function)
- **WHEN**: When to use it (triggers, contexts)
- **NOT**: What it doesn't do (boundaries)

**Anti-Pattern**: "Use to CREATE (new projects), REFACTOR (cleanup)" — contains "how" language
**Good Pattern**: "Maintain CLAUDE.md project memory. Use when: new project setup, documentation is messy, conversation revealed insights" — describes what + when

## Default: INCREMENTAL-UPDATE for Prior Conversation (Meta-Skill)

**RECOGNIZE**: When there is ANY prior conversation in a session, the default behavior should be INCREMENTAL-UPDATE.

- Prior conversation = knowledge has been generated = capture it
- No explicit request needed — prior conversation IS the trigger
- Review conversation for: working commands, discovered patterns, errors encountered, new rules learned
- Update CLAUDE.md based on discoveries

## Skills Must Be Self-Sufficient (Meta-Skill)

**CRITICAL**: Skills MUST NOT reference CLAUDE.md or any external files outside their own directory.

**Why:**
- AI agents using your skills will NOT have access to CLAUDE.md
- AI agents will NOT have the same folder structure as this project
- Skills must be SELF-CONTAINED to work in any context

**What this means for skill creation:**
- ✅ Include all necessary patterns IN the skill's SKILL.md or references/
- ✅ Skills can cite other skills or built-in tools
- ✅ Skills can reference their OWN references/ files
- ❌ Skills MUST NOT reference CLAUDE.md
- ❌ Skills MUST NOT reference .claude/rules/
- ❌ Skills MUST NOT reference external project files

**Think of it this way:** CLAUDE.md teaches YOU how to build skills. The skills you build must then stand on their own, without needing CLAUDE.md.

## Documentation Anti-Pollution Rule (Meta-Skill)

**CRITICAL**: CLAUDE.md must contain ONLY lasting project knowledge.

**NEVER create**:
- Update logs, changelogs, or date-stamped sections
- Temporary files like "CLAUDE_MD_UPDATE.md"
- "Update on [date]" or version tracking entries

**Each addition should be as permanent as architecture decisions.**

**Why**: CLAUDE.md is project memory, not a changelog. Temporary pollution reduces signal-to-noise ratio.
