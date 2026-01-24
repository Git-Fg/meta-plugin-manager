---
name: task-architect
description: "Multi-step workflow coordinator with task tracking. Use for complex workflows spanning sessions or requiring coordination across multiple components. Detects task-heavy needs and routes to appropriate specialists with TaskList orchestration."
user-invocable: true
---

# Task Architect

## WIN CONDITION

**Called by**: toolkit-architect, user requests
**Purpose**: Coordinate complex multi-step workflows with TaskList orchestration

**Output**: Must output completion marker after workflow coordination

```markdown
## TASK_ARCHITECT_COMPLETE

Workflow: [DETECT|CREATE|EXECUTE|VALIDATE|CLOSE]
Tasks: [count] created/tracked
Coordination: [TaskList|Skills|Subagents|Mixed]
Quality Score: XX/100
```

**Completion Marker**: `## TASK_ARCHITECT_COMPLETE`

Coordinates complex workflows using native Task Management (TaskList, TaskCreate, TaskUpdate) while delegating execution to appropriate specialists.

## 🚨 MANDATORY: Read BEFORE Routing

**CRITICAL**: You MUST read and understand these URLs:

### Primary Documentation (MUST READ)
- **[MUST READ] Skills Guide**: https://code.claude.com/docs/en/skills
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Content**: Skills architecture, progressive disclosure, delegation patterns
  - **Cache**: 15 minutes minimum

- **[MUST READ] Subagents Guide**: https://code.claude.com/docs/en/sub-agents
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Content**: Agent coordination patterns, state management
  - **Cache**: 15 minutes minimum

### ⚠️ BLOCKING RULES
- **DO NOT proceed** until you've fetched and reviewed Primary Documentation
- **MUST validate** all URLs are accessible before routing
- **REQUIRED** to understand task orchestration before coordination

---

## Core Philosophy

**Task Management is Native**: Claude already knows how to use TaskList, TaskCreate, TaskUpdate, TaskGet. Focus on **when to trigger** tasks, not **how to use** them.

**Orchestration Over Execution**: task-architect coordinates workflows but delegates execution to specialists:
- Skills provide domain expertise
- Subagents provide isolation/parallelism
- TaskList provides persistence and dependency tracking

**Trigger-Based Routing**: Detect task-heavy workflows and route appropriately:
- "workflow spanning sessions" → TaskList orchestration
- "multi-stage project setup" → Create task list
- "complex refactoring" → Use TaskList for tracking

## Agent Type Selection for Tasks

When creating tasks via Task tool, consider agent specialization for optimal performance:

**Simple Tasks (general-purpose)**:
- File operations, basic validation
- Standard workflow execution
- Balanced performance needed
- Mixed operations requiring multiple tool types

**Command-Heavy Tasks (bash)**:
- Pure shell workflows
- Git operations, terminal tasks
- No file operations required
- Command execution specialist work

**Exploration Tasks (explore)**:
- Fast codebase scanning
- Pattern discovery across files
- No nested TaskList needed
- Quick navigation and analysis

**Planning Tasks (plan)**:
- Architecture design
- Complex decision-making
- Multi-stage project planning
- Strategic analysis and design

**See task-knowledge**: [agent-types.md](task-knowledge/references/agent-types.md) for complete agent selection guidance.

## Model Selection for Tasks

Explicit model selection based on task complexity and cost optimization:

**Simple Tasks (haiku)**:
- File operations, basic validation
- Quick grep, simple analysis
- Cost-sensitive workflows
- High-volume simple operations

**Default Tasks (sonnet)**:
- Most workflow tasks
- Balanced performance
- Standard execution
- Typical project work

**Complex Tasks (opus)**:
- Architecture design
- Complex decision-making
- Multi-stage planning with dependencies
- Critical decisions affecting project trajectory

**Cost Consideration**: opus is ~10x more expensive than haiku. Use judiciously.

**See task-knowledge**: [model-selection.md](task-knowledge/references/model-selection.md) for detailed cost optimization strategies.

## activeForm Best Practices

The active form appears in Ctrl+T progress display - quality matters for user experience.

**Good activeForms** ([Verb-ing] [specific object]):
- "Running database migrations"
- "Analyzing codebase structure"
- "Executing test suite"
- "Validating component dependencies"
- "Scanning security vulnerabilities"
- "Implementing OAuth integration"

**Poor activeForms** (vague, unhelpful):
- "Doing stuff"
- "Processing"
- "Working"
- "Running"
- "In progress"

**Naming Convention**: [Verb-ing] [specific object]

**Examples by Phase**:
- Planning phase: "Analyzing requirements", "Designing architecture"
- Execution phase: "Creating component", "Validating configuration"
- Completion phase: "Generating report", "Running final checks"

**See task-knowledge**: [activeform-guide.md](task-knowledge/references/activeform-guide.md) for complete activeForm quality guidance.

## Context Window Spanning

TaskList enables **indefinitely long projects** by breaking context window limits.

**Workflow**:
1. Conversation approaches context window limit
2. Note CLAUDE_CODE_TASK_LIST_ID for current session
3. Start new session with same CLAUDE_CODE_TASK_LIST_ID
4. New session picks up where previous left off
5. Work continues across context boundaries

**Use When**:
- Complex projects exceeding single conversation
- Long-running workflows with many steps
- Projects requiring multiple context refreshes
- Indefinitely long development cycles

**Example**:
```bash
# Session 1: Start project
CLAUDE_CODE_TASK_LIST_ID=my-project claude

# Session 2: Continue after context fills
CLAUDE_CODE_TASK_LIST_ID=my-project claude

# Session 3: Continue again after second context fills
CLAUDE_CODE_TASK_LIST_ID=my-project claude
```

**Task files persist**: `~/.claude/tasks/my-project/`

**See task-knowledge**: [context-spanning.md](task-knowledge/references/context-spanning.md) for detailed context spanning patterns.

## Multi-Session Collaboration

Multiple sessions can collaborate on the same Task List in **real-time**.

**Real-Time Synchronization**:
- When one session updates a Task, broadcasted to all sessions
- Multiple sessions see changes immediately
- Enables true collaborative workflows

**Use When**:
- Team collaboration on project
- Parallel workflow execution across sessions
- Distributed processing across multiple Claude instances
- Real-time coordination needed

**Setup**:
```bash
# Terminal 1 (Session A)
CLAUDE_CODE_TASK_LIST_ID=shared-project claude

# Terminal 2 (Session B - simultaneous)
CLAUDE_CODE_TASK_LIST_ID=shared-project claude

# Both sessions see real-time updates
```

**Collaboration Patterns**:
- Session A: Creates tasks, sets dependencies
- Session B: Claims tasks, executes in parallel
- Both sessions: See real-time progress updates

**See task-knowledge**: [multi-session.md](task-knowledge/references/multi-session.md) for detailed collaboration patterns.

## Task JSON File Management

Tasks are stored as JSON in `~/.claude/tasks/<list-id>/` for inspection and management.

**File Structure**:
```
~/.claude/tasks/
└── [task-list-id]/
    └── tasks/
        ├── [task-id-1].json
        ├── [task-id-2].json
        └── [task-id-3].json
```

**Management Operations**:
- **Inspect**: Read JSON files to check task state, dependencies, owner
- **Backup**: Copy task directory for safety before major changes
- **Version Control**: Track task state in git for workflow reproducibility
- **Manual Edit**: Modify tasks directly if needed (advanced use case)
- **Template Sharing**: Copy task lists between projects as workflow templates

**External Tooling**:
- Task files are infrastructure for utilities
- Can build custom tools on top of task JSON
- API surface for integrations and automation

**See task-knowledge**: [task-json-schema.md](task-knowledge/references/task-json-schema.md) for complete task file documentation.

---

## Quick Decision Tree

**START: What do you need?**

```
├─ "Multi-step workflow with persistence"
│  └─→ TaskList + forked workers
│
├─ "Long-running project"
│  └─→ TaskList + skills architecture
│
├─ "Multi-session task"
│  └─→ TaskList + subagents
│
└─ "Complex coordination needed"
   └─→ DETECT workflow first
```

**When to Use TaskList**:
- Work spans multiple sessions (set `CLAUDE_CODE_TASK_LIST_ID`)
- Need dependency tracking between steps
- Want visual progress tracking (Ctrl+T)
- Coordinating across multiple components

**When NOT to Use TaskList**:
- Simple 2-3 step workflows (use skills directly)
- Session-bound work (skills are sufficient)
- No dependencies between steps

---

## Multi-Workflow Detection Engine

Automatically detects and executes appropriate workflow:

```python
def detect_task_workflow(project_state, user_request):
    has_tasks = exists_task_list()
    is_multi_session = "spanning sessions" in user_request.lower()
    has_dependencies = "depends on" in user_request.lower() or "blocked by" in user_request.lower()

    if "create" in user_request or (not has_tasks and is_multi_session):
        return "CREATE"  # Initialize task list
    elif "validate" in user_request or "check" in user_request:
        return "VALIDATE"  # Check task completion
    elif has_tasks and has_dependencies:
        return "EXECUTE"  # Coordinate with task tracking
    else:
        return "DETECT"  # Analyze workflow complexity
```

**Detection Logic**:
1. **Create request OR multi-session workflow** → **CREATE mode** (initialize TaskList)
2. **Validation/check requested** → **VALIDATE mode** (verify task completion)
3. **Existing tasks with dependencies** → **EXECUTE mode** (coordinate execution)
4. **Default analysis** → **DETECT mode** (analyze workflow complexity)

---

## Four Workflows

### DETECT Workflow - Analyze Workflow Complexity

**Use When**:
- Unclear if task tracking is needed
- Workflow analysis phase
- Understanding complexity before committing to TaskList

**Why**:
- Identifies task tracking needs
- Maps workflow steps and dependencies
- Suggests optimal coordination approach
- Prevents unnecessary TaskList overhead

**Process**:
1. Analyze workflow step count
2. Identify dependency relationships
3. Check for session-spanning needs
4. Assess coordination complexity
5. Generate recommendation report

**Output**:
```markdown
## Workflow Analysis Complete

### Complexity Assessment
- Steps: [count]
- Dependencies: [count]
- Session Span: [Yes/No]
- Coordination: [Simple|Complex]

### Recommendation
- [Use TaskList | Use skills directly | Use hybrid approach]

### Rationale
- [Why this approach fits the workflow]
```

---

### CREATE Workflow - Initialize Task List

**Use When**:
- Explicit multi-session workflow
- Complex multi-step project setup
- Workflow with clear dependencies

**Why**:
- Creates persistent task tracking
- Establishes dependency relationships
- Enables visual progress tracking
- Facilitates cross-session continuity

**Process**:
1. Analyze workflow requirements
2. Break down into discrete tasks
3. Identify dependency relationships
4. Create tasks with proper blocking
5. Set task persistence if needed

**Task Creation Pattern**:
- Task: High-level deliverable
- Dependencies: What must complete first
- Owner: Which specialist handles execution
- Active form: Progress tracking description

**Output**:
```markdown
## Task List Created

### Tasks: [count]
- Task 1: [subject] (pending)
- Task 2: [subject] (blocked by Task 1)
- Task 3: [subject] (blocked by Task 1, Task 2)

### Persistence
- Session ID: [CLAUDE_CODE_TASK_LIST_ID]
- Location: ~/.claude/tasks/[session-id]/

### Coordination Plan
- [How tasks will be executed and tracked]
```

---

### EXECUTE Workflow - Coordinate with Task Tracking

**Use When**:
- Existing task list needs coordination
- Multi-step workflow with dependencies
- Coordinating specialists across tasks

**Why**:
- Manages task execution order
- Delegates to appropriate specialists
- Tracks progress and dependencies
- Aggregates results across tasks

**Process**:
1. Load task list (TaskList)
2. Identify unblocked tasks
3. Route to appropriate specialists:
   - Domain expertise → Skills
   - Isolation needed → Subagents
   - Simple execution → Direct action
4. Update task status (TaskUpdate)
5. Wait for dependencies, continue

**Routing Matrix**:
| Task Type | Route To | Example |
|-----------|----------|---------|
| Domain analysis | Skill (forked) | Code review, security scan |
| Noisy operation | Subagent | Log analysis, full repo scan |
| Simple execution | Direct | File edit, command run |

**Output**:
```markdown
## Workflow Execution Complete

### Tasks Completed: [X]/[Y]
- Task 1: ✅ Complete (skill: code-analyzer)
- Task 2: ✅ Complete (skill: security-scanner)
- Task 3: ✅ Complete (subagent: log-worker)

### Results Aggregated
- [Summary of combined results]

### Quality Score: XX/100
```

---

### VALIDATE Workflow - Check Task Completion

**Use When**:
- Audit or validation requested
- Checking task completion status
- Verifying workflow progress

**Why**:
- Ensures task completion accuracy
- Validates dependency satisfaction
- Provides progress visibility
- Identifies blocking issues

**Process**:
1. Load task list (TaskList)
2. Check each task status
3. Verify dependency completion
4. Generate completion report
5. Identify next steps or blockers

**Output**:
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
- Task [Z]: Blocked by [W]

### Next Actions
1. [Unblock Task X by completing Y]
2. [Continue with next available task]
```

---

## Coordination Patterns

For detailed coordination patterns and integration guidance, see **[references/coordination-patterns.md](references/coordination-patterns.md)**.

## Output Contracts

For complete output contract templates and anti-patterns guidance, see **[references/output-contracts.md](references/output-contracts.md)**.

## When in Doubt

1. **Analyzing workflow?** → DETECT first
2. **Multi-session project?** → Set `CLAUDE_CODE_TASK_LIST_ID`
3. **Complex dependencies?** → TaskList manages order
4. **Simple workflow?** → Skills are sufficient

**Remember**: Task Management orchestrates, specialists execute.
