# TaskList Integration Patterns

Complex skill workflows with visual progress tracking and dependency enforcement.

---

## When to Use TaskList for Skills

Use TaskList integration for complex skill development when:
- Multi-skill refactoring projects (5+ skills)
- Complex skill validation with dependencies
- Skill architecture design spanning sessions
- Multi-phase skill creation workflows
- Coordination across multiple skill specialists

**When NOT to Use TaskList**:
- Single skill creation or editing
- Simple 2-3 skill workflows
- Session-bound skill work
- Projects fitting in single conversation

---

## Task Creation Patterns

### ASSESS Workflow

```
1. Scan project structure
2. Identify skill candidates
3. Map existing skills
4. Generate recommendations
```

### CREATE Workflow

```
1. Determine tier structure
2. Generate YAML frontmatter
3. Write SKILL.md
4. Create references/ (if needed)
5. Validate autonomy ≥80%
```

### ENHANCE Workflow (Dependent on EVALUATE)

```
1. Review evaluation findings [blockedBy: evaluate-task]
2. Prioritize improvements [blockedBy: evaluate-task]
3. Apply optimizations [blockedBy: 1, 2]
4. Re-evaluate score [blockedBy: 3]
```

---

## Critical Value

**ENHANCE tasks are explicitly blocked by EVALUATE completion**, ensuring improvements are based on actual assessment findings rather than assumptions.

---

## Task Tracking Benefits

Task tracking provides:
- Visual workflow progression
- Dependency enforcement (ENHANCE blocked by EVALUATE)
- Persistent quality tracking across cycles
- Clear stage completion markers

---

## Integration Example

**Pattern**: Use TaskCreate to establish a skill structure scan task. Then use TaskCreate to set up parallel analysis tasks for skill quality, dependencies, and compliance — configure these to depend on the scan completion. Use TaskCreate to establish a refactoring plan task that depends on all analysis tasks completing. Use TaskUpdate to mark tasks complete as each phase finishes, and use TaskList to check overall progress.

**Natural Language Description**: Complex workflows involving multiple skills benefit from visual progress tracking and explicit dependency management. Start with a structure scan, then run parallel validation tasks that depend on scan completion. Create a refactoring plan that depends on all validation completing. Mark progress as each phase finishes.

---

## See Also

- [workflow-examples.md](workflow-examples.md) - Detailed examples and edge cases
- [quality-framework.md](../quality-framework.md) - 11-dimensional scoring
- [autonomy-design.md](../autonomy-design.md) - Autonomy patterns
