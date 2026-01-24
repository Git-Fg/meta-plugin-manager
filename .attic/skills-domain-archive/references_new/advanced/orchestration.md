# Complex Workflow Orchestration

Using TaskList for complex, multi-step skill development workflows.

## When to Use This Reference

Use this guide when:
- Coordinating complex skill development
- Managing multi-phase workflows
- Tracking progress across sessions
- Coordinating multiple skill changes

## When to Use TaskList

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

**Question**: Does this workflow need tracking across 5+ steps with dependencies?

**Yes** → Use TaskList
**No** → Direct execution is better

## TaskList Integration Pattern

TaskList tools are built-in orchestration primitives:

- **TaskCreate** - Establish tasks with dependencies
- **TaskUpdate** - Mark tasks as completed
- **TaskList** - Check progress and identify blocked tasks
- **TaskGet** - Get full task details

**Describe workflows in natural language**:
- "Use TaskCreate to establish a scan task"
- "Use TaskUpdate to mark tasks complete"
- "Use TaskList to check overall progress"

## Complex Skill Development Example

### Scenario: Multi-Skill Refactoring

**Goal**: Refactor 10 skills for better autonomy

**Without TaskList** (hard to track):
```
1. Start refactoring skill-1
2. Move to skill-2
3. ... lose track of progress
4. ... forget which skills are done
5. ... can't see overall status
```

**With TaskList** (organized and visible):
```markdown
## Orchestration Plan

Use TaskCreate to establish a skill scan task. Then use TaskCreate to set up parallel refactoring tasks for each identified skill — configure these without dependencies since they can be done independently. Use TaskCreate to establish a validation task that depends on all refactoring completing. Use TaskUpdate to mark tasks complete as each skill is refactored. Use TaskList to check overall progress and identify any blocked tasks.
```

### Task Structure

**Phase 1: Scan**
- Task: Scan all skills for autonomy issues
- Dependencies: None
- Output: List of skills needing refactoring

**Phase 2: Refactor (parallel)**
- Task: Refactor skill-1 for autonomy
- Task: Refactor skill-2 for autonomy
- Task: Refactor skill-3 for autonomy
- Dependencies: None (can work in parallel)

**Phase 3: Validate**
- Task: Validate all refactored skills
- Dependencies: All refactor tasks must complete

**Phase 4: Report**
- Task: Generate refactoring summary
- Dependencies: Validation must complete

## Multi-Phase Quality Audit Example

### Scenario: Comprehensive .claude/ Audit

**Goal**: Audit entire .claude/ configuration

**Orchestration**:

```markdown
Use TaskCreate to establish a structure scan task. Then use TaskCreate to set up parallel component validation tasks for skills, subagents, hooks, and MCP — configure these to depend on the scan completion. Use TaskCreate to establish a standards compliance check task that depends on all component validations. Use TaskCreate to create a final audit report task. Use TaskUpdate to mark tasks complete as each phase finishes. Use TaskList to check overall progress.
```

**Task Dependencies**:
```
[Structure Scan]
       ↓
[Skills Valid] [Subagents Valid] [Hooks Valid] [MCP Valid]
       ↓
[Standards Check]
       ↓
[Final Report]
```

## Session-Spanning Work

### Scenario: Multi-Day Skill Refactoring

**Challenge**: Work spans multiple sessions

**Solution**: TaskList provides persistence

```markdown
# Session 1
Use TaskCreate to establish refactoring tasks.
Work on first 3 skills.
Use TaskUpdate to mark complete.

# Session 2
Use TaskList to see remaining tasks.
Continue with next 3 skills.
Use TaskUpdate to mark complete.

# Session 3
Use TaskList to see final tasks.
Complete remaining work.
Generate final report.
```

**Benefit**: Progress persists across sessions

## Collaborative Work

### Scenario: Multiple Agents Working Together

**Challenge**: Coordinate work across multiple Claude sessions

**Solution**: TaskList provides real-time synchronization

```markdown
# Terminal 1: Session A
Use TaskCreate to establish tasks.
Work on skills validation.
Use TaskUpdate to mark complete.

# Terminal 2: Session B
Use TaskList to see progress.
Work on hooks validation.
Use TaskUpdate to mark complete.

# Both sessions see:
- Real-time task updates
- What's completed
- What's blocked
- What remains
```

## Natural Language Task Descriptions

### Good: Clear Natural Language

```markdown
## Audit Workflow

1. **Scan Structure**
   Scan .claude/ directory for all components
   Output: Component inventory

2. **Validate Components** (parallel)
   - Validate skills quality
   - Validate subagents structure
   - Validate hooks configuration
   - Validate MCP setup

3. **Check Standards**
   Verify 2026 compliance across all components

4. **Generate Report**
   Compile findings and recommendations
```

### Poor: Code-Like Syntax

```markdown
## Audit Workflow

TaskCreate({
  name: "scan",
  action: scanDirectory(".claude/")
})

TaskCreate({
  name: "validate",
  depends: ["scan"],
  parallel: true
})
```

**Why poor**: Unnecessary complexity, AI knows how to use TaskList

## When NOT to Use TaskList

### Simple Workflows

**Too simple for TaskList**:
```markdown
## Quick Skill Update

1. Read skill file
2. Identify issue
3. Fix issue
4. Verify fix
```

**Better**: Direct execution without TaskList overhead

### No Dependencies

**Independent tasks**:
```markdown
## Check Three Skills

1. Evaluate skill-1
2. Evaluate skill-2
3. Evaluate skill-3
```

**Better**: Execute directly, no coordination needed

## Progress Tracking Examples

### Example 1: Visual Progress

**TaskList output**:
```
# Task List

[✓] Scan .claude/ structure
[✓] Validate skills (15/15)
[✓] Validate subagents (3/3)
[→] Validate hooks (2/4) - IN PROGRESS
[ ] Validate MCP (0/2) - BLOCKED
[ ] Standards compliance - BLOCKED
[ ] Final report - BLOCKED
```

**Benefits**:
- Clear visual status
- Blocked tasks visible
- Progress percentage
- What's next

### Example 2: Dependency Tracking

**TaskList output**:
```
# Task List

[✓] Structure scan - COMPLETED
[✓] Skills validation - COMPLETED
[✓] Subagents validation - COMPLETED
[ ] Hooks validation - WAITING (blocked by: nothing)
[ ] MCP validation - WAITING (blocked by: nothing)
[ ] Standards check - BLOCKED (blocked by: hooks, mcp)
[ ] Final report - BLOCKED (blocked by: standards)
```

**Benefits**:
- Dependency chain clear
- Blockers visible
- Can work on unblocked tasks

## Quality Gates Pattern

### Scenario: Enforce Quality Standards

**Pattern**: Each phase must pass before proceeding

```markdown
Use TaskCreate to establish a pre-flight checklist task. Then use TaskCreate to set up a validation task that depends on pre-flight completion. Use TaskCreate to establish a testing task that depends on validation passing. Use TaskCreate to set up a deployment task that depends on successful testing. Use TaskUpdate to mark tasks complete. Use TaskList to verify all quality gates passed before deployment.
```

**Quality Gates**:
1. Pre-flight ✓ → Can validate
2. Validation ✓ → Can test
3. Testing ✓ → Can deploy
4. All passed → Deployment safe

## TaskList Best Practices

### DO: Natural Language Descriptions

```markdown
Use TaskCreate to establish a scan task for identifying all .claude/ components.
```

### DON'T: Code-Like Syntax

```markdown
TaskCreate({name: "scan", action: "scanDirectory"})
```

### DO: Describe Dependencies Naturally

```markdown
Create validation task that depends on scan completion.
```

### DON'T: Specify Technical Details

```markdown
Create task with dependency ID: 12345
```

### DO: Focus on WHAT and WHEN

```markdown
After scan completes, validate each component in parallel.
```

### DON'T: Prescribe HOW

```markdown
Use TaskList.update() with JSON payload...
```

## Summary

**TaskList for skills when**:
- 5+ step workflows
- Dependencies between steps
- Visual tracking needed
- Session-spanning work
- Multi-agent coordination

**Direct execution when**:
- 2-3 step workflows
- No dependencies
- Session-bound work
- Simple coordination needed

**Always**: Use natural language, trust AI intelligence

## See Also

- **[quality.md](../core/quality.md)** - Quality standards
- **[inference.md](inference.md)** - Smart workflow selection
- **[anti-patterns.md](anti-patterns.md)** - Orchestration anti-patterns
