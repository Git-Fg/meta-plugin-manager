# Agent Types Reference

Complete guide to the four agent types available in Claude Code, their tool restrictions, use cases, and selection patterns.

## Overview

When creating tasks via the Task tool, you can specify agent types for optimized performance. Each agent type has different tool access and is optimized for specific workflows.

## Four Agent Types

### 1. general-purpose (Default)

**Tools**: All tools available

**Characteristics**:
- Full capability access
- Balanced performance for most tasks
- Inherits parent model (sonnet by default)
- No restrictions on workflow complexity

**Use When**:
- Standard workflow execution
- Full capability needed
- No specialization required
- Mixed operations (file ops + analysis + execution)

**Examples**:
- Multi-step refactoring with file analysis
- Complex validation requiring multiple tool types
- Standard project scaffolding workflows

**Cost**: Inherits parent model cost (typically sonnet)

---

### 2. bash

**Tools**: Bash only

**Characteristics**:
- Optimized for command execution
- Lower overhead for command-focused tasks
- Cannot read/write files directly
- Pure shell workflow specialist

**Use When**:
- Pure command execution needed
- No file operations required
- Git operations, terminal tasks
- Shell script execution

**Examples**:
- Running test suites via command line
- Git operations (clone, pull, push)
- Build processes via terminal
- System administration tasks

**Cost**: Lower overhead than general-purpose for command tasks

**Anti-Pattern**: Don't use for file operations - use general-purpose instead

---

### 3. explore

**Tools**: All tools except Task

**Characteristics**:
- Fast codebase exploration
- Optimized for quick navigation
- Cannot spawn additional TaskList workflows
- Pattern discovery specialist

**Use When**:
- Fast codebase scanning
- Pattern discovery across files
- Quick navigation and search
- No nested TaskList needed

**Examples**:
- Finding all instances of a pattern
- Exploring codebase structure
- Quick dependency mapping
- File relationship analysis

**Constraint**: Cannot create additional tasks (Task tool unavailable)

**Cost**: Optimized for fast exploration operations

**Anti-Pattern**: Don't use when you need nested task coordination

---

### 4. plan

**Tools**: All tools except Task

**Characteristics**:
- Software architecture design
- Complex decision-making optimization
- Multi-stage project planning
- Cannot spawn additional TaskList workflows

**Use When**:
- Architecture design required
- Complex decision-making
- Multi-stage project planning
- Strategic analysis

**Examples**:
- Designing system architecture
- Breaking down complex projects
- Analyzing trade-offs between approaches
- Creating implementation roadmaps

**Constraint**: Cannot create additional tasks (Task tool unavailable)

**Cost**: Higher cost for complex reasoning (typically sonnet or opus)

**Anti-Pattern**: Don't use for simple execution - use general-purpose instead

---

## Agent Selection Decision Tree

```
Need command execution only?
└─ Yes → bash agent
└─ No
   └─ Need architecture design?
      └─ Yes → plan agent
      └─ No
         └─ Fast exploration without TaskList?
            └─ Yes → explore agent
            └─ No → general-purpose agent
```

## Selection Patterns

### Pattern 1: Pure Command Workflows

**Scenario**: Run tests, execute build process, git operations

**Agent**: bash

**Rationale**: Optimized for command execution, no file ops needed

### Pattern 2: Architecture Design

**Scenario**: Design system architecture, plan implementation strategy

**Agent**: plan

**Rationale**: Optimized for reasoning, no nested TaskList needed

### Pattern 3: Fast Exploration

**Scenario**: Scan codebase for patterns, find file relationships

**Agent**: explore

**Rationale**: Fast navigation, no nested TaskList needed

### Pattern 4: Standard Workflow

**Scenario**: Multi-step refactoring, complex validation

**Agent**: general-purpose

**Rationale**: Full capability needed for mixed operations

## Tool Restrictions

| Agent Type | Write | Edit | Read | Bash | Grep | Glob | LSP | Skill | Task |
|------------|-------|------|------|------|------|------|-----|-------|------|
| general-purpose | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| bash | ✗ | ✗ | ✗ | ✓ | ✗ | ✗ | ✗ | ✗ | ✗ |
| explore | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ |
| plan | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✗ |

**Key Restrictions**:
- **bash**: Command execution only - no file operations
- **explore**: No Task tool - cannot spawn nested workflows
- **plan**: No Task tool - cannot spawn nested workflows

## Performance Considerations

### Speed
- **explore**: Fastest for codebase navigation
- **bash**: Fastest for command execution
- **general-purpose**: Balanced for most tasks
- **plan**: Optimized for reasoning (slower but more thoughtful)

### Cost
- **bash**: Lowest overhead for command tasks
- **general-purpose**: Inherits parent model (typically sonnet)
- **explore**: Optimized for fast operations (often haiku)
- **plan**: Higher cost for complex reasoning (sonnet or opus)

### Capability
- **general-purpose**: Maximum capability
- **plan**: High capability minus Task spawning
- **explore**: High capability minus Task spawning
- **bash**: Limited to commands only

## Common Mistakes

### ❌ Wrong: Using bash for file operations

```markdown
**Incorrect** (bash agent cannot read files):
Agent: bash
Task: "Read config file and extract settings"
```

**Correct** (use general-purpose for file ops):
```markdown
Agent: general-purpose
Task: "Read config file and extract settings"
```

### ❌ Wrong: Using explore for nested TaskList

```markdown
**Incorrect** (explore cannot use Task tool):
Agent: explore
Task: "Create subtasks for parallel execution"
```

**Correct** (use general-purpose for nested TaskList):
```markdown
Agent: general-purpose
Task: "Create subtasks for parallel execution"
```

### ❌ Wrong: Using plan for simple execution

```markdown
**Incorrect** (plan is overkill for simple tasks):
Agent: plan
Task: "Run tests and report results"
```

**Correct** (use general-purpose for execution):
```markdown
Agent: general-purpose
Task: "Run tests and report results"
```

## Integration with TaskList

When using TaskList for coordination:

1. **Task assignment**: Use owner field to assign tasks to specific agent types
2. **Parallel execution**: Different agent types can work on same task list simultaneously
3. **Agent specialization**: Match agent type to task requirements for optimal performance

**Example**:
```
Task 1: "Scan codebase structure" → owner: explore agent
Task 2: "Run build process" → owner: bash agent
Task 3: "Design architecture" → owner: plan agent
Task 4: "Implement features" → owner: general-purpose agent
```

## Recommendations

1. **Default to general-purpose** - Use specialized agents only when clear benefit exists
2. **Match agent to task** - bash for commands, explore for scanning, plan for design
3. **Consider constraints** - explore and plan cannot spawn nested TaskList workflows
4. **Optimize for cost** - Use cheaper agents (bash, explore with haiku) when appropriate

## Quick Reference Card

| I Need... | Use Agent | Why |
|-----------|-----------|-----|
| Command execution only | bash | Optimized for shell |
| Architecture design | plan | Optimized for reasoning |
| Fast codebase scan | explore | Optimized for navigation |
| Standard workflow | general-purpose | Full capability |
| Nested TaskList | general-purpose | Only one with Task tool |
