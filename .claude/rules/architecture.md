# Architecture Philosophy

---

# FOR DIRECT USE

⚠️ **Follow these patterns when building skills and workflows**

## Skills-First Architecture

Every capability should be a Skill first. Commands and Subagents are orchestrators, not creators.

**Reference**: [toolkit-architect/SKILL.md](skills/toolkit-architect/SKILL.md)

### Router Logic (from toolkit-architect/SKILL.md)
1. Validate: User's project has .claude/ directory
2. Determine component type:
   - "I need a skill" → Route to skills-architect
   - "I want web search" → Route to mcp-architect
   - "I need hooks" → Route to hooks-architect
3. Scan existing structure: `ls -la .claude/` to see what exists
4. Check for existing components in skills/, agents/, settings.json, hooks.json

## Hub-and-Spoke Pattern

Hub Skills (routers with disable-model-invocation: true) delegate to knowledge skills. Prevents context rot.

**CRITICAL**: For hub to aggregate results, ALL delegate skills MUST use `context: fork`. Regular skill handoffs are one-way only.

**See**: [CLAUDE.md](../../CLAUDE.md) for complete hub-and-spoke pattern documentation and test validation results.

## Progressive Disclosure

**See**: [CLAUDE.md](../../CLAUDE.md) for complete Progressive Disclosure documentation (Tier 1/2/3 structure, line count rules, implementation guidance).

## Prompt Efficiency

Minimize API call count ("prompts" = one request + all tool calls). Critical for subscription providers with limited prompts (e.g., 150 prompts/5h plans).

- Skills consume 1 prompt
- Subagents consume multiple prompts

**Prefer skills over subagents when both achieve the same result.**

## Component Patterns

**Reference**: [toolkit-architect/references/component-patterns.md](skills/toolkit-architect/references/component-patterns.md)

### Project Structure
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

### Plugin Manifest (plugin.json)
Required fields:
```json
{
  "name": "plugin-name"  # kebab-case format
}
```

**Name requirements:**
- Use kebab-case format (lowercase with hyphens)
- Must be unique across installed plugins
- Example: `code-review-assistant`, `test-runner`

## Hooks Configuration

Hooks follow a modern hierarchy emphasizing **local project autonomy** and **trust in AI intelligence**.

### Modern Configuration Hierarchy

**Configuration Locations** (trust AI to choose appropriate scope):

#### 1. Local Project Settings (Default Recommendation)
**Location**: `.claude/settings.json`

**Best For**:
- Project-specific automation and security
- Team collaboration through version control
- Project-specific validation and guardrails
- Shared configurations across collaborators

**Example**:
```json
{
  "hooks": {
    "PreToolUse": [{
      "matcher": "Write",
      "hooks": [{
        "type": "command",
        "command": "./.claude/scripts/validate-file.sh"
      }]
    }]
  }
}
```

#### 2. Component-Scoped Hooks (Auto-Cleanup)
**Location**: YAML frontmatter in skills/agents

**Best For**:
- Skill-specific validation and automation
- Temporary or experimental hooks
- One-time setup with `once: true`
- Avoiding global side effects

**Features**:
- ✅ Auto-cleanup when component finishes
- ✅ Skills/Commands support `once: true`
- ❌ Agents do NOT support `once` option

#### 3. Local Project Overrides
**Location**: `.claude/settings.local.json`

**Best For**:
- Personal project customization
- Machine-specific configurations
- Individual developer preferences

#### 4. User-Wide Settings
**Location**: `~/.claude/settings.json`

**Best For**:
- Universal personal workflows
- Global security policies
- Cross-project standardization

#### 5. Legacy Global Hooks (Deprecated)
**Location**: `.claude/hooks.json`

**Note**: Use `settings.json` format for better maintainability.

### Hooks Refactoring Insights (2026)

**Key Learning**: Modern hooks prioritize **local project autonomy** and **trust in AI intelligence**.

#### Philosophical Changes
- **Local Project First**: Default to `.claude/settings.json` for project-specific automation
- **Trust AI Intelligence**: Provide concepts, let AI make implementation decisions
- **Autonomous by Default**: Skills work without user interaction
- **Minimal Prescriptiveness**: Focus on principles, not rigid patterns
- **Clean Architecture**: Remove deprecated patterns and legacy knowledge

#### Quality Indicators
**High-Quality Hook Implementation**:
- ✅ Uses appropriate events for use case
- ✅ Configured at appropriate scope
- ✅ Includes proper error handling
- ✅ Performs efficiently
- ✅ Provides clear feedback

**Trust AI to Achieve**:
- Appropriate event selection
- Smart scope choice
- Intelligent validation logic
- Optimal performance
- Clear user experience

## Tool Layer Architecture

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

### Layer 2: User-Defined Content

- `.claude/skills/*/SKILL.md` - Loaded by Skill tool (built-in)
- `.claude/agents/*.md` - Launched by Task tool (built-in)

### Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│         LAYER 0: Workflow State Engine                     │
├─────────────────────────────────────────────────────────────┤
│  TaskList: Context spanning, multi-session collaboration    │
│  Real-time updates, indefinitely long projects              │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│           LAYER 1: Built-In Claude Code Tools               │
├─────────────────────────────────────────────────────────────┤
│  Execution:  Write | Edit | Read | Bash | Grep | Glob      │
│  Orchestration: Skill tool → loads user skills              │
│                Task tool → launches user subagents         │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│           LAYER 2: User-Defined Content                     │
├─────────────────────────────────────────────────────────────┤
│  .claude/skills/*/SKILL.md   ← Loaded by Skill tool        │
│  .claude/agents/*.md          ← Launched by Task tool      │
└─────────────────────────────────────────────────────────────┘
```

### Key Distinction

**TaskList/Agent/Task tools are NOT "on the same layer as skills"**. They are:
- Built-in orchestration primitives (like Write/Edit are execution primitives)
- TaskList operates as **Layer 0** - workflow state engine below all built-in tools
- Agent/Task tools are **Layer 1** - orchestration tools available to any workflow
- Available to ANY skill or workflow
- Part of Claude Code's core toolset
- **Claude already knows how to use them** - no code examples needed

**Skills are user content** that:
- Get loaded by the `Skill` tool (built-in)
- MAY use TaskList (Layer 0) for complex workflows
- ARE on Layer 2 (user-defined content)

### ABSOLUTE CONSTRAINT: Natural Language Only

**When citing TaskList (Layer 0) or Agent/Task tools (Layer 1) in skills, ALWAYS use natural language**:

**Why**: TaskList is a fundamental primitive, and Agent/Task tools are built-in tools that Claude already knows how to use. Code examples add context drift risk.

**✅ DO**: Describe the workflow and dependencies in natural language
- "First scan the structure, then validate components in parallel"
- "Optimization must wait for validation to complete"
- "Generate report only after all validation phases finish"

**❌ DON'T**: Provide code examples showing tool invocation
- No `TaskCreate(subject="...")` examples
- No `addBlockedBy=["..."]` syntax demonstrations
- Trust Claude's intelligence to use built-in tools correctly

## Task Integration

Task Management provides persistent orchestration for complex workflows. Use TaskList when:
- Work spans multiple sessions with `CLAUDE_CODE_TASK_LIST_ID`
- Need dependency tracking between steps
- Want visual progress tracking (Ctrl+T)
- Work exceeds context window (TaskList enables indefinitely long projects)

**Relationship to skills-first**:
- TaskList (Layer 0) orchestrates complex workflows
- Skills (Layer 2) execute domain-specific tasks
- TaskList doesn't replace skills—it enables indefinitely long projects through context spanning

**Documentation principle**: Describe workflows in natural language, not tool invocation syntax.

## TaskList Philosophy: "Unhobbling" Claude

### Design Principle
TodoWrite was removed because newer models (Opus 4.5) can handle simpler tasks autonomously. TaskList exists specifically for **complex projects exceeding autonomous execution**.

**Threshold question**: "Would this exceed Claude's autonomous state tracking?"

### Key Capabilities

**Context Window Spanning**:
- When conversation fills context window, start new session with same `CLAUDE_CODE_TASK_LIST_ID`
- New session picks up where previous left off
- Enables **indefinitely long projects** across context boundaries

**Multi-Session Collaboration**:
- Real-time synchronization: when one session updates a Task, broadcasted to all sessions
- Multiple sessions collaborate on single project simultaneously
- Environment variable: `CLAUDE_CODE_TASK_LIST_ID=my-project`

**Subagent Coordination**:
- Primary trigger: spawning subagents for distributed work
- Use owner field to assign tasks to specific subagents
- Multiple subagents work on same task list simultaneously

**File-Based Infrastructure**:
- Tasks stored in `~/.claude/tasks/[task-list-id]/`
- Intentional for interoperability and external tooling
- Task files as API surface for utilities

---

# TO KNOW WHEN

Understanding these principles helps make better architectural decisions.

## Core Philosophy Recognition

**Skills-First Architecture**:
- Every capability should be a Skill first
- Commands and Subagents are orchestrators, not creators
- **Recognition**: Start with skills, add orchestration only when needed

**Trust AI Intelligence**:
- Provide concepts, AI makes intelligent implementation decisions
- Focus on principles, not prescriptive patterns
- **When to recognize**: Avoid over-engineering and micro-management

**Local Project Autonomy**:
- Always start with local project configuration
- Project directory as default location
- **Recognition**: Default to project-level, expand scope only when needed

## Layer 0 (TaskList) Understanding

**Context Window Spanning**:
- Enables indefinitely long projects
- Breaks through context window limitations
- **When to recognize**: Projects that must survive context boundaries

**Multi-Session Collaboration**:
- Real-time synchronization across sessions
- Multiple terminals working on same project
- **Recognition pattern**: "Does this project need to continue across sessions?"

**"Unhobbling" Principle**:
- TodoWrite removed because models handle simple tasks autonomously
- TaskList for complex projects only
- **Threshold question**: "Would this exceed Claude's autonomous state tracking?"

## Natural Language Citations

**Built-in Tools** (Layer 0/1):
- TaskList (Layer 0) is a fundamental primitive
- Agent/Task tools (Layer 1) are built-in orchestration
- Claude already knows how to use them

**Why Natural Language**:
- Code examples add context drift risk
- Trust AI intelligence for built-in tool usage
- **Recognition**: If writing TaskList code examples → anti-pattern

**Pattern**: Describe WHAT needs to happen, not HOW to invoke tools
