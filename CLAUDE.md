# CLAUDE.md

Project scaffolding toolkit for Claude Code focused on .claude/ configuration with skills-first architecture and progressive disclosure.

## Critical Gotchas

⚠️ **Context Fork Brittleness**: Regular skill chains >2 levels accumulate noise. Use hub-and-spoke: hub routes to knowledge skills, **never chain regular skills** (one-way handoffs). Forked skills CAN nest properly (Test 4.2 validated).

⚠️ **Progressive Disclosure**: Create references/ only when SKILL.md + references >500 lines total. Under 500? Merge into single SKILL.md.

⚠️ **Skill Over-Engineering**: Trust, don't micro-manage.
- **Anti-Pattern**: Creating "logic files" (e.g., `mode-detection.md`) for behaviors Claude inherently understands.
- **Solution**: Define "Commander's Intent" in `SKILL.md` and let Claude handle execution details.
- **Constraint**: Reference files should be "Data Libraries" or "Inspiration Patterns", not "Instruction Manuals".

⚠️ **Hooks Configuration**: Hooks can be configured in multiple locations:
- **Project Settings**: `.claude/settings.json` (team-shared) or `.claude/settings.local.json` (local only)
- **Global Hooks**: `.claude/hooks.json` (traditional global hooks)
- **Component-Scoped**: Skill/agent frontmatter (preferred for auto-cleanup)
- **Plugin Hooks**: `hooks/hooks.json` in plugin directories
Prefer component-scoped hooks for auto-cleanup; use project settings for team-wide configurations.

⚠️ **Empty Scaffolding**: Remove directories with no content immediately. Creates technical debt.

⚠️ **URL Staleness**: Documentation URLs change. Always verify with mcp__simplewebfetch__simpleWebFetch before implementation.

⚠️ **Delta Standard**: Remove Claude-obvious content. Keep only: working commands, non-obvious gotchas, architecture decisions, "NEVER do X because [specific reason]"

⚠️ **Auto-Discovery**: Claude auto-discovers skills via description keywords. No need for command wrappers.

⚠️ **Context Fork Requirements**: Always inject parameters for forked execution. Forked contexts don't inherit conversation history, but parameters ARE passed successfully.

**Parameter Passing Pattern**:
```yaml
# Caller invokes with:
Skill("analyze-data", args="dataset=production_logs timeframe=24h")

# Forked skill receives via $ARGUMENTS:
---
name: analyze-data
context: fork
---
Scan $ARGUMENTS:
1. Parse: dataset=production_logs timeframe=24h
2. Execute analysis
3. Output: ## ANALYZE_COMPLETE
```

⚠️ **Skill Calling Behavior**:
- **Regular → Regular**: One-way handoff, caller NEVER resumes
- **Regular → Forked**: ✅ **CONTROL RETURNS** - subroutine pattern with isolated context

**Implication**: For hub-and-spoke workflows where orchestrator must aggregate results, ALL worker skills MUST use `context: fork`.

⚠️ **URL Fetching**: Knowledge skills MUST include mandatory URL fetching sections with mcp__simplewebfetch__simpleWebFetch and 15-minute cache minimum.

## Context Isolation Security Model

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

## Subagent Configuration

**Subagents** (`.claude/agents/*.md`) are **different from skills with `context: fork`**. Common confusion leads to incorrect YAML fields.

### ✅ **Custom Subagents Work**
**Simple configuration** - Test 3.2 validated:

```yaml
---
name: custom-worker
description: "Custom worker with restricted tools"
tools: [Read, Grep]  # Only these tools available
---
```

**Focus**: Keep simple and compatible - use `tools` field for restriction

### Correct Subagent Fields
```yaml
---
name: my-agent              # Required: unique ID
description: "Does X when Y" # Required: when to delegate
tools:                       # Optional: tool restrictions
  - Read
  - Grep
  - Glob
disallowedTools:             # Optional: denied tools
  - Write
  - Edit
skills:                     # Optional: inject skill content
  - skills-knowledge
hooks:                      # Optional: lifecycle hooks (PreToolUse, PostToolUse, Stop)
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate.sh"
---
```

**Note**: Agents support component-scoped hooks but do NOT support the `once: true` option (only skills/commands do).

### Invalid Fields (Don't Use)
- ❌ `context: fork` - This is for **skills**, not subagents
- ❌ `agent: Explore` - This field **doesn't exist** for subagents
- ❌ `user-invocable` - Subagents aren't skills
- ❌ `disable-model-invocation` - For skills, not subagents

### Context Detection
Determine subagent location based on scope:
- **Project-level**: `${CLAUDE_PROJECT_DIR}/.claude/agents/`
- **Plugin-level**: `<plugin>/agents/` (for distribution)
- **User-level**: `~/.claude/agents/` (all projects)

### Common Mistake
Using subagents-architect incorrectly suggested `agent:` and `context: fork` for subagents. These fields apply to **skills** that delegate TO subagents, not the subagents themselves.

## Skill Calling Behavior (Critical)

### Regular → Regular: One-Way Handoff
❌ **Caller does NOT resume** - control transfers permanently
```yaml
# skill-a calls skill-b → skill-b becomes final output
# skill-a NEVER resumes
```

### Regular → Forked: ✅ **SUBROUTINE PATTERN**
**Forked skill runs in isolation BUT control returns to caller**
```yaml
# skill-a calls skill-forked → skill-forked runs isolated → skill-a resumes
# Forked skill has NO access to caller's conversation context
```

| Aspect | Regular → Regular | Regular → Forked |
|--------|------------------|------------------|
| Control returns | ❌ NO | ✅ YES |
| Context access | ✅ Preserved | ❌ Isolated |
| Arguments pass | ✅ Yes | ✅ Yes |
| Use case | Handoff | Subroutine |

**Critical Discovery**: Forked skills enable hub-and-spoke architectures. Hub orchestrates → workers execute → hub aggregates.

### Nested Forks Work (Validated)
✅ Forked skills can call other forked skills (Test 4.2)
- Outer (forked) calls Inner (forked)
- Both isolated, both complete
- Control returns properly at each level
- **Not limited by ">2 deep" warning** (that applies to REGULAR chains)

### Forked Skills: 100% Autonomous
**Test Evidence**: Forked skills achieve 100% autonomy (0 permission denials)
- Test 2.3: Made independent decision without questions
- Test 3.2: Completed with custom subagent, no user interaction
- Test 4.2: Nested execution, autonomous completion
- Test 5.1: Parameter processing, independent execution

**Why Forked Skills Are Autonomous**:
- Isolated from caller context (can't ask about main conversation)
- Parameters provide all necessary context
- Must complete with structured output
- No access to user for clarification

**Verification**: Run with `--dangerously-skip-permissions` → `"permission_denials": []`

## Skill Portability

**Default to portable skills**: Create skills usable across any Agent Skills-compatible product.

**Claude Code Extensions** (use ONLY in `.claude/skills/` or plugin contexts with `.claude-plugin`/`plugin.json`):
- `context: fork` - Runs skill in isolated subagent context
- `agent: <name>` - Specifies agent type for execution
- `user-invocable: false` - Hides from slash command menu
- `hooks` in frontmatter - Lifecycle event bindings

⚠️ **`disable-model-invocation` Anti-Pattern**: Turns skills into "pure commands"—rigid, manually-triggered workflows. **Pure commands are an anti-pattern for skills.** A well-crafted description usually suffices. Reserve for genuinely destructive operations (deploy, delete, send) where user timing is critical.

## Project Structure

```
.claude/
├── skills/                      # Skills are PRIMARY building blocks
│   └── skill-name/
│       ├── SKILL.md            # <500 lines (Tier 2)
│       └── references/          # On-demand (Tier 3)
├── agents/                      # Context fork isolation
├── hooks/                       # Event automation (component-scoped preferred)
├── commands/                     # Legacy: manual workflows
├── settings.json                # Project-wide hooks & configuration (team-shared)
├── settings.local.json          # Local overrides (gitignored)
└── .mcp.json                   # MCP server configuration
```

**Hooks Configuration Options**:
- **settings.json**: Team-shared hooks (committed to git)
- **settings.local.json**: Personal hooks (gitignored)
- **hooks.json**: Legacy global hooks format
- **Component-scoped**: Hooks in skill/agent frontmatter

## Layer Selection

```
Need persistent norms? → CLAUDE.md rules
Need domain expertise? → Skill (user-invocable: true)
  Simple task? → Skill (regular)
  Complex workflow? → Skill (context: fork)
Need explicit workflow? → Command (disable-model-invocation: true)
Need isolation/parallelism? → Subagent
```

## Hooks Configuration

Hooks can be configured in **four locations**, each with different scopes and use cases.

### Supported Events

All hook locations support three event types:
- **PreToolUse**: Run before tool execution
- **PostToolUse**: Run after tool execution
- **Stop**: Run when component completes

### 1. Component-Scoped Hooks (Preferred for Auto-Cleanup)

**Location**: Skill/command/agent YAML frontmatter

**Best For**:
- **Skills/Commands**: Preprocessing data, validation after edits, one-time setup (with `once: true`)
- **Agents**: Scoped event handling, automatic cleanup, agent-specific validation
- Component-specific automation
- Auto-cleanup when component finishes

**Key Features**:
- ✅ Auto-cleanup when component completes
- ✅ Skills/Commands support `once: true` (run only once per session)
- ❌ Agents do NOT support `once` option

**Examples**:

**Skill with Preprocessing and Validation**:
```yaml
---
name: deploy-skill
description: "Deploys application with validation"
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/run-tests.sh"
          once: true  # Only runs once per session
  PostToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: "./scripts/format-code.sh"
---
```

**Agent with Automatic Cleanup**:
```yaml
---
name: data-processor
description: "Processes data with scoped validation"
hooks:
  PreToolUse:
    - matcher: "Read|Grep"
      hooks:
        - type: command
          command: "./validate-input.sh"
---
```

### 2. Project Settings - Team Shared

**Location**: `.claude/settings.json`

**Best For**:
- Project-wide preprocessing (e.g., filtering logs to reduce context)
- Team-wide security policies
- Standardized configurations across collaborators
- General automation (NOT component-specific)
- Version-controlled hook configurations

**Use for**: General preprocessing or project-wide automation that applies across all skills/commands

**Example**:
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "WebFetch",
        "hooks": [
          {
            "type": "command",
            "command": "./.claude/scripts/cache-web-content.sh"
          }
        ]
      }
    ]
  }
}
```

### 3. Project Settings - Local Overrides

**Location**: `.claude/settings.local.json`

**Best For**:
- Personal project preferences
- Machine-specific configurations
- Testing hook variations
- Local preprocessing workflows (gitignored)

**Use for**: Local automation that doesn't need to be shared with team

**Example**:
```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "./.claude/scripts/local-stats.sh"
          }
        ]
      }
    ]
  }
}
```

### 4. Global Hooks (Legacy Format)

**Location**: `.claude/hooks.json`

**Best For**:
- Traditional global hook configuration
- Organization-wide security policies
- Cross-skill protection (deprecated)

**Note**: `settings.json` is the modern replacement. Both work, but settings.json provides better team collaboration.

**Supported Events**: PreToolUse, PostToolUse, Stop (all events work in all four locations)

### Quick Decision Guide

**Use component-scoped hooks when**:
- Hook applies to specific skill/command/agent
- Need `once: true` for one-time setup
- Want auto-cleanup when component finishes

**Use settings-based hooks when**:
- Need preprocessing across multiple components
- Team-wide automation required
- Project-wide policies needed

### Configuration Precedence** (highest to lowest):
1. `.claude/settings.local.json` (local overrides)
2. `.claude/settings.json` (team-shared)
3. `.claude/hooks.json` (legacy global)
4. Component-scoped hooks (skill/agent frontmatter)
