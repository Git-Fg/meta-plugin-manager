# Architecture Philosophy

**Philosophy Before Process**

This document teaches architectural patterns grounded in core philosophy. Understanding WHY before HOW enables intelligent adaptation.

**See**: @.laude/rules/philosophy.md for foundational principles:
- Context Window as Public Good
- Degrees of Freedom Framework
- Trust AI Intelligence
- Local Project Autonomy
- The Delta Standard
- Progressive Disclosure Philosophy

---

# FOR DIRECT USE

⚠️ **Apply these patterns when building skills and workflows**

## Skills-First Architecture

Every capability should be a Skill first. Commands and Subagents are orchestrators, not creators.

### Project Scaffolding Router

Use factory skills directly for component creation:

#### Router Decision Tree
1. **Validate**: User's project has .claude/ directory
2. **Scan existing structure**: `ls -la .claude/` to see what exists
3. **Determine component type**:
   - "I need a skill" → Use create-skill factory
   - "I want web search/MCP" → Use create-mcp-server factory
   - "I need hooks/automation" → Use create-hook factory
   - "I need subagents" → Use create-subagent factory
   - "Multi-session workflow" → Use TaskList directly
   - "I need CLAUDE.md or memory management" → Use claude-md-archivist

#### Autonomy Pattern
Smart defaults based on exploration:
- **No .claude/ exists** → Create .claude/ directory structure first
- **Empty .claude/** → Infer from request keywords (skill/MCP/hook/agent/CLAUDE.md)
- **Has skills/** → Suggest skill enhancements or new skills
- **Has .mcp.json** → Suggest additional MCP servers
- **Has messy/outdated CLAUDE.md** → Suggest claude-md-archivist for refactoring
- **No CLAUDE.md exists** → Suggest claude-md-archivist for creation

#### Output Clarification Patterns

When delegating to skills or subagents, follow these patterns:

**Delegation to Knowledge Skills**:
1. **Source Attribution**: Always mark the source clearly
2. **Context Bridge**: Explain how knowledge applies to current request
3. **Summarize Key Points**: Extract actionable insights, don't dump full reference
4. **Maintain Voice Separation**: Keep architect's voice distinct from knowledge skill's voice

**Forked Worker Results**:
1. **Mark as Subagent Output**: Clearly identify as subagent result
2. **Parse and Summarize**: Extract insights from noisy output
3. **Present Key Findings First**: Lead with scores and critical issues
4. **Acknowledge Isolation**: Note this is from isolated context

## Hub-and-Spoke Pattern

Hub Skills (routers with disable-model-invocation: true) delegate to knowledge skills. Prevents context rot.

**CRITICAL**: For hub to aggregate results, ALL delegate skills MUST use `context: fork`. Regular skill handoffs are one-way only.

**See**: [CLAUDE.md](../../CLAUDE.md) for complete hub-and-spoke pattern documentation and test validation results.

## v4 Knowledge-Factory Architecture (2026-01-24)

### Separation of Concerns

**Knowledge Skills** (Passive Reference):
- Contain ONLY reference information
- NO execution logic, workflows, or scripts
- user-invocable: false (background context)
- Used for: Understanding concepts, patterns, standards

**Factory Skills** (Script-Based Execution):
- Contain ONLY execution logic
- NO theory, philosophy, or detailed explanations
- user-invocable: true
- Have scripts/ directory with bash/python scripts
- Used for: Creating components, running operations

### Usage Pattern

Load knowledge skills to understand concepts and patterns, then use factory skills to execute operations (create skills, add MCP servers, configure hooks, create agents).

### Reference Pattern

See test-runner skill for complete script-based skill pattern:
- scripts/ directory with executable scripts
- README.md documenting script usage
- SKILL.md provides usage guidance, not detailed script docs

### Knowledge Skills

| Skill | Content |
|-------|---------|
| knowledge-skills | Agent Skills standard, Progressive Disclosure, quality framework |
| knowledge-mcp | Model Context Protocol, transports, primitives |
| knowledge-hooks | Events, security patterns, exit codes |
| knowledge-subagents | Agent types, frontmatter, context detection |

### Factory Skills

| Skill | Scripts | Purpose |
|-------|---------|---------|
| create-skill | scaffold_skill.sh, validate_structure.sh | Skill scaffolding |
| create-mcp-server | add_server.sh, validate_mcp.sh, merge_config.py | MCP registration |
| create-hook | add_hook.sh, scaffold_script.sh, validate_hook.sh | Hook creation |
| create-subagent | create_agent.sh, validate_agent.sh, detect_context.sh | Agent creation |

### Meta-Critic (Feedback Loop)

Quality validation and alignment checking:

| Skill | Purpose | Use When |
|-------|---------|----------|
| meta-critic | Three-way comparison: Request vs Delivery vs Standards | Quality checks, workflow validation, drift detection |

**Analysis Framework**:
- **Intent Alignment**: Did actions match user's goal?
- **Standards Compliance**: Does output comply with knowledge-skills?
- **Completeness**: Were all requirements addressed?
- **Quality**: Is work production-ready? (≥80/100 score)

**Output**: Constructive critique with specific, actionable recommendations.

See `.claude/skills/meta-critic/references/analysis-framework.md` for detailed methodology.

## Progressive Disclosure

**See**: [CLAUDE.md](../../CLAUDE.md) for complete Progressive Disclosure documentation (Tier 1/2/3 structure, line count rules, implementation guidance).

## Prompt Efficiency

Minimize API call count ("prompts" = one request + all tool calls). Critical for subscription providers with limited prompts (e.g., 150 prompts/5h plans).

- Skills consume 1 prompt
- Subagents consume multiple prompts

**Prefer skills over subagents when both achieve the same result.**

## Component Patterns

### Project Structure (v4)
```
.claude/
├── skills/                      # Skills organized by type
│   ├── knowledge-*/             # Knowledge Skills (passive reference)
│   │   ├── SKILL.md            # <500 lines, pure knowledge
│   │   └── references/          # On-demand (Tier 3)
│   ├── create-*/                # Factory Skills (script-based execution)
│   │   ├── SKILL.md            # Execution guidance
│   │   └── scripts/            # Bash/python scripts
│   └── test-runner/             # Reference pattern for script-based skills
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

### Task-Integrated Quality Validation

For complex quality audits requiring visual progress tracking and dependency enforcement, use TaskList integration:

**When to use**:
- Multi-component validation (skills + subagents + hooks + MCP)
- Need to enforce scan completion before validation
- Want visual progress tracking (Ctrl+T)
- Quality tracking across audit iterations

**Workflow description**:

Use TaskList to create a multi-phase validation workflow. First use TaskCreate to establish the structure scan task that identifies all .claude/ components. Then use TaskCreate to set up parallel component validation tasks for skills (15 points), subagents (10 points), hooks (10 points), and MCP (5 points) — configure these with dependencies so they wait for the structure scan to complete. Use TaskCreate to establish the standards compliance check (20 points) with dependencies on all component validations. Finally use TaskCreate to create the final report generation task that depends on the standards check. Use TaskUpdate to mark tasks as completed as each phase finishes, and use TaskList to check overall progress.

**Critical dependency**: Component validation tasks must be configured to wait for the structure scan task to complete. The standards check task must wait for all component validation tasks. This ensures comprehensive evaluation before scoring begins and a complete picture before final scoring.

**Task tracking provides**:
- Visual progression through validation phases (visible in Ctrl+T)
- Dependency enforcement (tasks block until dependencies complete)
- Persistent quality tracking across audit iterations
- Clear phase completion markers

### Task-Integrated Audit Workflow

For complex .claude/ audits requiring visual progress tracking and dependency enforcement:

**When to use**:
- Multi-component validation (skills + subagents + hooks + MCP)
- Need to enforce scan completion before component validation
- Want visual progress tracking (Ctrl+T)
- Quality tracking across audit iterations

**Workflow description**:

Use TaskCreate to establish a .claude/ structure scan task first. Then use TaskCreate to set up parallel component validation tasks for skills (15 points), subagents (10 points), hooks (10 points), and MCP (5 points) — configure these to depend on the scan completion. Use TaskCreate to establish a standards compliance check task (20 points) that depends on all component validations completing. Finally use TaskCreate to establish a final audit report generation task. Use TaskUpdate to mark tasks complete as each phase finishes, and use TaskList to check overall progress and identify any blocked tasks.

**Critical dependency**: Component validation tasks must be configured to depend on the structure scan task completing. The standards check task must depend on all component validation tasks. This ensures comprehensive evaluation before scoring and a complete picture before final reporting.

**Task tracking provides**:
- Visual progression through audit phases (visible in Ctrl+T)
- Dependency enforcement (tasks block until dependencies complete)
- Persistent quality tracking across audit iterations
- Clear phase completion markers

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
