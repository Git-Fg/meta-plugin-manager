---
name: task-knowledge
context: fork
description: "TaskList workflow orchestration for complex, multi-session, multi-agent projects. Use when work exceeds Claude's autonomous execution, spans context windows, or requires distributed subagent coordination. Triggers: 'workflow spanning sessions', 'context window full', 'multi-agent coordination', 'project persistence'."
user-invocable: true
---

# TaskList Knowledge Base

## WIN CONDITION

**Called by**: task-architect, toolkit-architect
**Purpose**: Provide implementation guidance for TaskList workflow orchestration

**Output**: Must output completion marker after providing guidance

```markdown
## TASK_KNOWLEDGE_COMPLETE

Guidance: [Implementation patterns provided]
References: [List of reference files]
Recommendations: [List]
```

**Completion Marker**: `## TASK_KNOWLEDGE_COMPLETE`

Complete TaskList knowledge base for orchestrating complex, multi-session, multi-agent projects in Claude Code. Access comprehensive guidance on context window spanning, multi-session collaboration, agent type selection, model selection, and TaskList integration patterns.

## RECOMMENDED: Context Validation

Read these URLs when accuracy matters for TaskList orchestration work:

### Primary Documentation
- **Official TaskList Guide**: https://code.claude.com/docs/en/tasks
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: TaskList workflow orchestration, persistence, dependencies

- **Agent Task Tool Documentation**: https://code.claude.com/docs/en/cli-reference
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Agent types, model selection, task coordination

### When to Fetch vs Skip
**Fetch when**:
- Documentation may have changed since last read
- User requests verification of TaskList patterns
- Starting new task orchestration workflow
- Uncertain about when TaskList is appropriate

**Skip when**:
- Simple task coordination based on known patterns
- Local-only work without external dependencies
- Working offline
- Recently read and documentation is stable

**Trust your judgment**: You know when validation is needed for accurate task orchestration.

## Progressive Disclosure Knowledge Base

This skill provides complete TaskList knowledge through progressive disclosure:

### Tier 1: Quick Overview
This SKILL.md provides the decision framework and quick reference.

### Tier 2: Comprehensive Guides
Load full guides on demand:
- **[agent-types.md](references/agent-types.md)** - Four agent types with selection guidance
- **[model-selection.md](references/model-selection.md)** - haiku/sonnet/opus cost optimization
- **[context-spanning.md](references/context-spanning.md)** - Breaking context window limits

### Tier 3: Deep Reference
Individual reference files provide complete implementation details:
- **[multi-session.md](references/multi-session.md)** - Real-time collaboration patterns
- **[task-json-schema.md](references/task-json-schema.md)** - Task file structure and management
- **[activeform-guide.md](references/activeform-guide.md)** - Progress display quality
- **[parallel-patterns.md](references/parallel-patterns.md)** - Multi-agent coordination

## Quick Start

### New to TaskList?
Start with the **"Unhobbling" Principle** below to understand when TaskList is needed.

### Need to Decide?
**Threshold Question**: "Would this exceed Claude's autonomous state tracking?"

If yes → Use TaskList. If no → Use skills directly.

### Coordinating Multiple Agents?
See **[parallel-patterns.md](references/parallel-patterns.md)** for multi-agent coordination strategies.

### Spanning Multiple Sessions?
See **[context-spanning.md](references/context-spanning.md)** for session continuation workflows.

## "Unhobbling" Principle

TodoWrite was removed because newer models (Opus 4.5) can handle simpler tasks autonomously. TaskList exists specifically for **complex projects exceeding autonomous execution**.

**Threshold Question**: "Would this exceed Claude's autonomous state tracking?"

### When Claude Needs TaskList

- **Multi-session workflows**: Projects spanning multiple sessions (context window spanning)
- **Multi-subagent coordination**: Distributed processing across specialized workers
- **Complex dependencies**: Tasks with blocking relationships requiring enforcement
- **Projects exceeding capacity**: Work that exceeds single conversation limits

### When Claude Does NOT Need TaskList

- **Simple 2-5 step workflows**: Skills suffice for straightforward execution
- **Autonomous work**: Tasks Claude can complete independently
- **Session-bound tasks**: Work that completes in one session
- **Projects fitting in context**: Single conversation capacity is sufficient

**Key Insight**: TaskList is for **complexity management**, not task tracking. Claude already knows what to do for ordinary work.

## Layer 0 Architecture

TaskList is a **workflow state engine** that sits below built-in tools:

```
┌─────────────────────────────────────────────────────────────┐
│     LAYER 0: Workflow State Engine (TaskList)               │
├─────────────────────────────────────────────────────────────┤
│  Persistent workflow state, dependency tracking,            │
│  multi-agent coordination, cross-session workflows          │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│     LAYER 1: Built-In Claude Code Tools                     │
├─────────────────────────────────────────────────────────────┤
│  Execution:  Write | Edit | Read | Bash | Grep | Glob      │
│  Orchestration: TaskList | TaskCreate | TaskUpdate         │
│  Invokers:     Skill tool | Task tool                      │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│     LAYER 2: User-Defined Content                          │
├─────────────────────────────────────────────────────────────┤
│  .claude/skills/*/SKILL.md   ← Loaded by Skill tool        │
│  .claude/agents/*.md          ← Launched by Task tool      │
└─────────────────────────────────────────────────────────────┘
```

**Implication**: TaskList orchestrates everything below, including built-in tools.

## Agent Types Quick Reference

| Agent Type | Tools | Purpose | Use When |
|------------|-------|---------|----------|
| **general-purpose** | All tools | Default, full capability | Most tasks, no specialization needed |
| **bash** | Bash only | Command execution specialist | Pure shell workflows, no file operations |
| **explore** | All except Task | Fast codebase exploration | Quick navigation, no nested TaskList |
| **plan** | All except Task | Architecture design | Complex decision-making, planning |

**For detailed guidance**: See [agent-types.md](references/agent-types.md)

## Model Selection Quick Reference

| Model | Use Case | Cost Factor |
|-------|----------|-------------|
| **haiku** | Fast, straightforward tasks | 1x (baseline) |
| **sonnet** | Default, balanced performance | 3x haiku |
| **opus** | Complex reasoning tasks | 10x haiku |

**Guideline**: Default to sonnet. Use haiku for simple operations. Use opus only for complex reasoning.

**For detailed guidance**: See [model-selection.md](references/model-selection.md)

## Core Capabilities

### 1. Context Window Spanning
TaskList enables **indefinitely long projects** by breaking context window limits:
- Session 1: Start project with CLAUDE_CODE_TASK_LIST_ID
- Session 2: Continue with same CLAUDE_CODE_TASK_LIST_ID
- Session 3+: Continue as needed
- **Result**: Projects never limited by context window

**See**: [context-spanning.md](references/context-spanning.md)

### 2. Real-Time Multi-Session Collaboration
Multiple sessions collaborate on same Task List:
- Session A updates Task → broadcasted to all sessions
- Session B sees changes immediately
- **Result**: True collaborative workflows

**See**: [multi-session.md](references/multi-session.md)

### 3. Distributed Subagent Coordination
Multiple subagents work on same task list:
- Owner field assigns work to specific agents
- Agents claim and complete tasks in parallel
- **Result**: Distributed processing

**See**: [parallel-patterns.md](references/parallel-patterns.md)

### 4. File-Based Infrastructure
Tasks stored as JSON in `~/.claude/tasks/[id]/`:
- Inspect, backup, version control task state
- Build external tools on task JSON
- **Result**: Extensible infrastructure

**See**: [task-json-schema.md](references/task-json-schema.md)

## When to Use TaskList

### Use TaskList When:

1. **Multi-Session Workflow**: Project spans multiple sessions
2. **Complex Dependencies**: Tasks block other tasks (addBlockedBy)
3. **Multi-Agent Coordination**: Multiple subagents need coordination
4. **Context Window Limit**: Project exceeds single conversation
5. **Visual Progress Tracking**: Need Ctrl+T progress visibility
6. **Session Persistence**: Work must survive session termination

### Don't Use TaskList When:

1. **Simple 2-3 Step Work**: Skills are sufficient
2. **No Dependencies**: Tasks don't block each other
3. **Session-Bound**: Work completes in one session
4. **Fits in Context**: Single conversation capacity sufficient

## Integration Patterns

### Natural Language Citations

**CRITICAL**: When citing TaskList in skills, use **natural language only** - NO code examples.

**✅ DO**:
```markdown
Use TaskCreate to establish a structure scan task. Then use TaskCreate to set up parallel validation tasks for components — configure these to depend on the scan completion. Use TaskUpdate to mark tasks complete as each phase finishes, and use TaskList to check overall progress.
```

**❌ DON'T**:
```markdown
TaskCreate(subject="Scan structure")
TaskCreate(subject="Validate components", addBlockedBy=["Scan structure"])
```

**Why**: TaskList tools are built-in (Layer 1). Claude already knows how to use them. Code examples add context drift risk.

### Dependency Patterns

Describe dependencies in natural language:
- "Validation must complete before optimization"
- "Scan blocks all component validation tasks"
- "Report generation waits for all analysis phases"

### Workflow Patterns

Common TaskList workflow patterns:

**Sequential Pipeline**: Scan → Validate → Optimize → Report
**Parallel Execution**: Scan → [Validate A, Validate B, Validate C] → Report
**Hybrid**: Scan → [Validate A, Validate B] → Optimize → Report

## activeForm Quick Guide

The active form appears in Ctrl+T progress display - quality matters.

**Good activeForms** ([Verb-ing] [specific object]):
- "Running database migrations"
- "Analyzing codebase structure"
- "Validating component dependencies"

**Poor activeForms** (vague, unhelpful):
- "Doing stuff"
- "Processing"
- "Working"

**For detailed guidance**: See [activeform-guide.md](references/activeform-guide.md)

## Layer Selection Decision Tree

```
Need workflow orchestration?
│
├─ "Multi-session project"
│  └─→ TaskList + task-architect
│     ├─ Context window spanning
│     └─ Real-time collaboration
│
├─ "Complex multi-step with dependencies"
│  └─→ TaskList + forked workers
│
├─ "Multi-agent coordination"
│  └─→ TaskList + subagents
│
└─ "Simple workflow"
   └─→ Skills directly (no TaskList needed)
```

## Cost Optimization Strategy

Model selection significantly affects cost:

1. **Start with haiku** for simple exploration and validation
2. **Escalate to sonnet** for standard workflow execution
3. **Use opus only** for complex reasoning critical to success

**Rule of Thumb**: If haiku can do it, don't use sonnet. If sonnet can do it, don't use opus.

**See**: [model-selection.md](references/model-selection.md) for detailed cost analysis

## Common Patterns

### Pattern 1: TaskList + Forked Skills

Use for complex workflows with domain expertise:
```
[TaskList Orchestrator]
  ├── Forked Skill: code-analyzer (Task 1)
  ├── Forked Skill: security-scanner (Task 2 - blocked by 1)
  └── Forked Skill: report-generator (Task 3 - blocked by 1,2)
```

### Pattern 2: TaskList + Subagents

Use for noisy operations with isolation:
```
[TaskList Orchestrator]
  ├── Subagent: log-worker (Task 1)
  ├── Subagent: repo-scanner (Task 2)
  └── Subagent: test-runner (Task 3 - blocked by 1,2)
```

### Pattern 3: Context Spanning

Use for indefinitely long projects:
```
Session 1: Create tasks, execute initial phases
[Context fills]
Session 2: Continue with same CLAUDE_CODE_TASK_LIST_ID
[Context fills]
Session 3: Continue with same CLAUDE_CODE_TASK_LIST_ID
[Project completes]
```

## Next Steps

Choose your path:

1. **[Learn agent types](references/agent-types.md)** - Four agent types with selection guidance
2. **[Optimize model selection](references/model-selection.md)** - Cost-aware haiku/sonnet/opus strategy
3. **[Enable context spanning](references/context-spanning.md)** - Break the context window limit
4. **[Multi-session collaboration](references/multi-session.md)** - Real-time synchronization patterns
5. **[Parallel coordination](references/parallel-patterns.md)** - Multi-agent workflows
6. **[Task file management](references/task-json-schema.md)** - JSON structure and external tooling
7. **[activeForm quality](references/activeform-guide.md)** - Better progress display

## Anti-Patterns

**❌ Using TaskList for simple workflows** - Overengineering
- Claude handles simple tasks autonomously
- Use skills directly for 2-5 step workflows

**❌ Tasks without dependencies** - Missing the point
- If no tasks block others, simpler workflow suffices
- Consider direct skill execution

**❌ Using opus by default** - Cost inefficiency
- Opus is ~10x more expensive than haiku
- Default to sonnet, escalate when needed

**❌ Poor activeForms** - User experience impact
- Vague descriptions confuse users
- Use [Verb-ing] [specific object] pattern

## When in Doubt

1. **Threshold**: "Would this exceed Claude's autonomous state tracking?"
2. **Multi-session?** → Use TaskList with CLAUDE_CODE_TASK_LIST_ID
3. **Dependencies?** → Use TaskList for enforcement
4. **Simple work?** → Use skills directly

**Remember**: TaskList orchestrates, skills execute. Tasks don't replace skills—they coordinate them.

## Common Anti-Patterns

**Usage Anti-Patterns:**
- ❌ Code examples when citing TaskList/Agent/Task tools - Use natural language
- ❌ Confusing TaskList with skills - Architectural layer mistake
- ❌ Using TaskList for workflows Claude can handle autonomously - Overengineering
- ❌ Using TaskList for simple workflows - Tasks add overhead
- ❌ Tasks without dependencies - Missing the point
- ❌ Tasks for one-shot work - Persistence unnecessary
- ❌ Missing TaskList for multi-session workflows - Context window limit

**Natural Language Citation Anti-Patterns:**
- ❌ Providing code examples like `TaskCreate(subject="...")`
- ❌ Showing tool invocation syntax
- ✅ Describe WHAT needs to happen in WHAT ORDER
- ✅ Describe dependencies (e.g., "validation must complete before optimization")

**"Unhobbling" Recognition:**
- TodoWrite was removed because newer models handle simple tasks autonomously
- TaskList exists for **complex projects exceeding autonomous state tracking**
- **Threshold question**: "Would this exceed Claude's autonomous state tracking?"
- If yes → Use TaskList; If no → Use skills directly

**Context Window Spanning Pattern:**
- When conversation exceeds context window, start new session with same CLAUDE_CODE_TASK_LIST_ID
- TaskList enables indefinitely long projects across context boundaries
- Without TaskList: work lost when context fills up

**INCREMENTAL-UPDATE Default Recognition:**
- When there is ANY prior conversation in a session, default to INCREMENTAL-UPDATE
- Prior conversation = knowledge has been generated = capture it
- Review conversation for: working commands, discovered patterns, errors encountered, new rules learned
- **Recognition pattern**: "Is there prior conversation with discoverable knowledge?"
