---
name: task-domain
description: "TaskList workflow orchestration for complex, multi-session, multi-agent projects. Use when work exceeds Claude's autonomous execution, spans context windows, or requires distributed subagent coordination."
user-invocable: true
---

# TaskList Domain

## WIN CONDITION

**Called by**: toolkit-architect, user requests
**Purpose**: Coordinate complex workflows and provide TaskList orchestration guidance

**Output**: Must output completion marker

```markdown
## TASK_DOMAIN_COMPLETE

Workflow: [DETECT|CREATE|EXECUTE|VALIDATE|CLOSE]
Tasks: [count] created/tracked
Coordination: [TaskList|Skills|Subagents|Mixed]
Quality Score: XX/100
```

**Completion Marker**: `## TASK_DOMAIN_COMPLETE`

Complete TaskList knowledge base for orchestrating complex, multi-session, multi-agent projects in Claude Code. Coordinates workflows using native Task Management (TaskList, TaskCreate, TaskUpdate) while delegating execution to appropriate specialists.

## RECOMMENDED: Context Validation

Read these URLs when accuracy matters for task orchestration work:

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

## Multi-Workflow Detection Engine

Automatically detects and executes appropriate workflow:

```python
def detect_task_workflow(project_state, user_request):
    has_tasks = exists_tasks()
    user_lower = user_request.lower()

    # Explicit requests
    if "create" in user_lower or "new task" in user_lower:
        return "CREATE"
    if "execute" in user_lower or "run" in user_lower:
        return "EXECUTE"
    if "validate" in user_lower or "check" in user_lower:
        return "VALIDATE"
    if "close" in user_lower or "complete" in user_lower:
        return "CLOSE"

    # Context-based
    if not has_tasks:
        return "DETECT"

    # Default
    return "DETECT"
```

**Detection Logic**:
1. **Explicit "create"/"new task"** → **CREATE mode** (establish new tasks)
2. **Explicit "execute"/"run"** → **EXECUTE mode** (coordinate workflow execution)
3. **Explicit "validate"/"check"** → **VALIDATE mode** (verify progress and dependencies)
4. **Explicit "close"/"complete"** → **CLOSE mode** (finalize and cleanup)
5. **No tasks exist** → **DETECT mode** (analyze needs and create)
6. **Default** → **DETECT mode** (analyze current state)

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

## Model Selection for Tasks

Model selection significantly affects cost:

| Model | Use Case | Cost Factor |
|-------|----------|-------------|
| **haiku** | Fast, straightforward tasks | 1x (baseline) |
| **sonnet** | Default, balanced performance | 3x haiku |
| **opus** | Complex reasoning tasks | 10x haiku |

**Guideline**: Default to sonnet. Use haiku for simple operations. Use opus only for complex reasoning.

**Rule of Thumb**: If haiku can do it, don't use sonnet. If sonnet can do it, don't use opus.

**For detailed guidance**: See [model-selection.md](references/model-selection.md)

## activeForm Best Practices

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

## Core Capabilities

### 1. Context Window Spanning
TaskList enables **indefinitely long projects** by breaking context window limits:
- Session 1: Start project with CLAUDE_CODE_TASK_LIST_ID
- Session 2: Continue with same CLAUDE_CODE_TASK_LIST_ID
- Session 3+: Continue as needed
- **Result**: Projects never limited by context window

**Example**:
```
Session 1: Start project
[Context fills]
Session 2: Continue with same CLAUDE_CODE_TASK_LIST_ID
[Context fills]
Session 3: Continue with same CLAUDE_CODE_TASK_LIST_ID
[Project completes]
```

### 2. Real-Time Multi-Session Collaboration
Multiple sessions collaborate on same Task List:
- Session A updates Task → broadcasted to all sessions
- Session B sees changes immediately
- **Result**: True collaborative workflows

**Example**:
```
Terminal 1 (Session A)
  └─ Creates task list

Terminal 2 (Session B - simultaneous)
  └─ Sees updates from Terminal 1 in real-time
  └─ Both sessions see real-time updates
```

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

## Five Workflows

### DETECT Workflow - Analyze Workflow Needs

**Use When:**
- Unclear if task orchestration is needed
- Project analysis phase
- Before creating any tasks
- Understanding current workflow landscape

**Why:**
- Identifies when TaskList is appropriate
- Maps existing workflow patterns
- Suggests orchestration strategy
- Prevents unnecessary complexity

**Process:**
1. Analyze project complexity
2. Check for multi-session needs
3. Identify dependency patterns
4. Determine if skills suffice
5. Suggest TaskList if appropriate

### CREATE Workflow - Establish Task Orchestration

**Use When:**
- Explicit create request
- Complex workflow identified
- Multi-session project needed
- User asks for task setup

**Why:**
- Creates properly structured task orchestration
- Sets up dependencies correctly
- Enables progress tracking
- Prepares for execution

**Process:**
1. Create initial task list
2. Define task dependencies
3. Assign ownership if needed
4. Set up tracking
5. Validate orchestration

### EXECUTE Workflow - Coordinate Execution

**Use When:**
- Tasks already created
- Need to coordinate execution
- Workflow in progress
- Multi-agent coordination needed

**Why:**
- Coordinates task execution
- Manages dependencies
- Tracks progress
- Enables parallel work

**Process:**
1. Review task list
2. Identify ready tasks
3. Coordinate execution
4. Update progress
5. Handle dependencies

### VALIDATE Workflow - Verify Progress

**Use When:**
- Progress check requested
- Dependency verification needed
- Quality validation required
- Completion assessment needed

**Why:**
- Ensures task completion accuracy
- Validates dependency satisfaction
- Provides progress visibility
- Identifies blocking issues

**Process:**
1. Load task list (TaskList)
2. Check each task status
3. Verify dependency completion
4. Generate completion report
5. Identify next steps or blockers

### CLOSE Workflow - Finalize and Cleanup

**Use When:**
- Project completion
- Task list finalization
- Cleanup needed
- Documentation required

**Why:**
- Properly closes task orchestration
- Documents outcomes
- Cleans up resources
- Captures learnings

## TaskList Integration Patterns

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

## When to Use TaskList

### Use TaskList When:

1. **Multi-Session Workflow**: Project spans multiple sessions
2. **Complex Dependencies**: Tasks block other tasks
3. **Multi-Agent Coordination**: Multiple subagents need coordination
4. **Context Window Limit**: Project exceeds single conversation
5. **Visual Progress Tracking**: Need Ctrl+T progress visibility
6. **Session Persistence**: Work must survive session termination

### Don't Use TaskList When:

1. **Simple 2-3 Step Work**: Skills are sufficient
2. **No Dependencies**: Tasks don't block each other
3. **Session-Bound**: Work completes in one session
4. **Fits in Context**: Single conversation capacity sufficient

## Layer Selection Decision Tree

```
Need workflow orchestration?
│
├─ "Multi-session project"
│  └─→ TaskList + task-domain
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

## Workflow Selection Quick Guide

**"I need task orchestration"** → CREATE
**"Coordinate workflow execution"** → EXECUTE
**"Check progress"** → VALIDATE
**"Complete project"** → CLOSE
**"Do I need TaskList?"** → DETECT

## When in Doubt

1. **Analyzing workflow?** → DETECT first
2. **Multi-session project?** → Set `CLAUDE_CODE_TASK_LIST_ID`
3. **Complex dependencies?** → TaskList manages order
4. **Simple workflow?** → Skills are sufficient

**Remember**: TaskList orchestrates, specialists execute.

## Common Anti-Patterns

**Usage Anti-Patterns:**
- ❌ Code examples when citing TaskList/Agent/Task tools - Use natural language
- ❌ Confusing TaskList with skills - Architectural layer mistake
- ❌ Using TaskList for workflows Claude can handle autonomously - Overengineering
- ❌ Using TaskList for simple workflows - Tasks add overhead
- ❌ Tasks without dependencies - Missing the point
- ❌ Tasks for one-shot work - Persistence unnecessary

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

## Reference Files

Load these as needed:

- **[agent-types.md](references/agent-types.md)** - Four agent types with selection guidance
- **[model-selection.md](references/model-selection.md)** - haiku/sonnet/opus cost optimization
- **[context-spanning.md](references/context-spanning.md)** - Breaking context window limits
- **[multi-session.md](references/multi-session.md)** - Real-time collaboration patterns
- **[task-json-schema.md](references/task-json-schema.md)** - Task file structure and management
- **[activeform-guide.md](references/activeform-guide.md)** - Progress display quality
- **[parallel-patterns.md](references/parallel-patterns.md)** - Multi-agent coordination

## Output Contracts

### DETECT Output
```markdown
## Task Analysis Complete

### Recommendation: [Use TaskList|Skills Sufficient]
### Reasons: [List]
### Complexity: [High|Medium|Low]
```

### CREATE Output
```markdown
## TaskList Created: {task_list_id}

### Tasks: [count] created
### Dependencies: [count] configured
### Tracking: Enabled ✅
```

### EXECUTE Output
```markdown
## Task Execution Complete

### Tasks Coordinated: [count]
### Completed: [count] ✅
### In Progress: [count] 🔄
### Blocked: [count] 🚫
```

### VALIDATE Output
```markdown
## Task Validation Complete

### Status Summary
- Total: [count]
- Completed: [count] ✅
- In Progress: [count] 🔄
- Pending: [count] ⏳
- Blocked: [count] 🚫

### Blockers
- Task [X]: Blocked by [Y]

### Next Actions
1. [Unblock Task X by completing Y]
2. [Continue with next available task]
```

### CLOSE Output
```markdown
## Project Completed

### Final Status
- All tasks: Completed ✅
- Dependencies: Satisfied ✅
- Quality: Validated ✅

### Summary
[Project outcome summary]
```
