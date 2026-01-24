# TaskList Integration Patterns

TaskList tools are **built-in Layer 1 orchestration primitives** that skills can USE for coordinating complex workflows.

## When to Use TaskList for Skill Development

**Use TaskList when**:
- Multi-step workflow with 5+ discrete phases
- Need dependency enforcement between steps
- Want visual progress tracking (Ctrl+T visibility)
- Quality gates that must complete before proceeding
- Session-spanning work that needs persistence

**Don't use TaskList when**:
- Simple 2-3 step workflows (direct execution is faster)
- No dependencies between steps (overhead not justified)
- One-shot session-bound work (skills are sufficient)

## Decision Guidance

Ask yourself: Does this workflow need tracking across 5+ steps with dependencies? If yes, use TaskList to create and track the workflow. If it's 2-3 simple steps without dependencies, direct execution is better.

## For Complex Skill Workflows

For multi-skill projects requiring task tracking across sessions, see **task-knowledge**:

- **Context window spanning**: Continue skill development across multiple sessions when context fills
- **Multi-session collaboration**: Multiple developers work on same skill project simultaneously
- **Complex dependency management**: Track skill interdependencies across large refactoring projects
- **Session-persistent workflows**: Skill development spanning days or weeks with TaskList persistence

**When to use TaskList for skills**:
- Multi-skill refactoring projects (5+ skills being updated)
- Complex skill validation with interdependencies
- Skill architecture design spanning sessions
- Multi-phase skill creation workflows requiring coordination

**Integration Pattern**:

Use TaskCreate to establish a skill structure scan task. Then use TaskCreate to set up parallel analysis tasks for skill quality, dependencies, and compliance — configure these to depend on the scan completion. Use TaskCreate to establish a refactoring plan task that depends on all analysis tasks completing. Use TaskUpdate to mark tasks complete as each phase finishes, and use TaskList to check overall progress.

**See task-knowledge**: [task-knowledge](task-knowledge) for complete TaskList workflow orchestration patterns.

## Examples: Skills That Use TaskList

### Testing Workflow (test-runner)

Use TaskCreate to establish each testing phase in sequence. First create a task for test folder setup, then create tasks for test skills/agents creation and pre-flight checklist that depend on setup. Create the test execution task that depends on pre-flight completion. Create log analysis task that depends on test execution, and finally create archive/cleanup task that depends on log analysis. Use TaskUpdate to mark each phase complete as it finishes. Use TaskList to check overall progress and identify any blocked tasks.

### Enhancement Workflow (skills-architect)

Use TaskCreate to establish an evaluation task first. Then create review and prioritization tasks that depend on evaluation completion. Create optimization tasks that depend on review, and finally create re-evaluation task that depends on optimization. Use TaskUpdate to mark tasks complete and TaskList to monitor progress.

### Quality Validation (skills-domain)

Use TaskCreate to establish a structure scan task. Then create parallel component validation tasks (skills, subagents, hooks, MCP) that depend on the scan. Create a standards compliance check task that depends on all validations, and finally create a report generation task. Use TaskList to track parallel execution status and dependencies.

**Quality Standards**:
- Use dimensional scoring (0-10 scale): Structural (30%), Components (50%), Standards (20%)
- Check for anti-patterns: command wrapper, non-self-sufficient skills, context: fork misuse
- Validate 2026 standards: progressive disclosure, autonomy-first design (80-95%)
- Target: ≥8/10 for production readiness

## Implementation Pattern for Skills

When adding TaskList to your skill, explicitly cite which TaskList primitive to use for each action. Use TaskCreate to establish tasks with their dependencies. Use TaskUpdate to mark tasks as completed or update their status. Use TaskList to check progress and identify blocked tasks. Describe the workflow phases, their execution order, and dependencies in natural language.

## Architecture Reminders

- **TaskList, TaskCreate, TaskUpdate, TaskGet are built-in** (Layer 1) - Claude already knows them
- **Skills are user content** (Layer 2) that describe workflows using natural language
- **Cite the specific primitive**: "Use TaskCreate to establish..." not "Create a task..."
- **Describe WHAT and WHEN**, not code syntax

See **[task-architect](../task-architect/)** for complete TaskList orchestration patterns.
