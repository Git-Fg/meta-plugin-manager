# GraphViz Documentation Conventions

Standardize process visualization using GraphViz DOT language for clear, consistent documentation.

## Overview

GraphViz provides a standardized way to visualize workflows, decision trees, and process flows. Following these conventions ensures consistent, readable diagrams across all meta-skills.

## Node Shapes Convention

Use standardized shapes to communicate meaning:

| Shape | Meaning | Example |
|-------|---------|---------|
| **Diamond** | Questions/Decisions | "Tests pass?" |
| **Box** | Actions/Processes | "Run test command" |
| **Double Circle** | Start/End States | "Begin", "Complete" |
| **Ellipse** | States/Conditions | "Failing test", "Clean code" |
| **Octagon** | Critical/Warning | "STOP", "ERROR" |

### Example Usage

```dot
digraph example {
    "Start" [shape=doublecircle];
    "Tests pass?" [shape=diamond];
    "Run tests" [shape=box];
    "Fix issues" [shape=box];
    "Complete" [shape=doublecircle];

    "Start" -> "Tests pass?";
    "Tests pass?" -> "Complete" [label="yes"];
    "Tests pass?" -> "Run tests" [label="no"];
    "Run tests" -> "Fix issues";
    "Fix issues" -> "Tests pass?";
}
```

## Edge Labels Convention

Always label edges to show conditions/paths:

```dot
"Decision point" -> "Path A" [label="condition 1"];
"Decision point" -> "Path B" [label="condition 2"];
"Decision point" -> "Path C" [label="otherwise"];
```

### Common Label Patterns

| Pattern | Usage | Example |
|---------|-------|---------|
| `[label="yes/no"]` | Binary decisions | "Is valid? yes/no" |
| `[label="if X"]` | Conditional paths | "if error" |
| `[label="otherwise"]` | Default path | "if no match" |
| `[label="loop"]` | Cycle back | "back to start" |

## Rank Direction

Control flow direction with `rankdir`:

- **LR** (Left-to-Right): For horizontal flows
- **TB** (Top-to-Bottom): For vertical flows (default)

```dot
# Horizontal flow
digraph horizontal {
    rankdir=LR;
    A -> B -> C;
}

# Vertical flow
digraph vertical {
    rankdir=TB;
    A -> B -> C;
}
```

## Clustering

Group related elements using subgraphs:

```dot
digraph cluster_example {
    subgraph cluster_phase1 {
        label="Phase 1: Planning";
        "Define requirements" [shape=box];
        "Create design" [shape=box];
    }

    subgraph cluster_phase2 {
        label="Phase 2: Implementation";
        "Write code" [shape=box];
        "Run tests" [shape=box];
    }

    "Define requirements" -> "Create design";
    "Create design" -> "Write code";
    "Write code" -> "Run tests";
}
```

## Styling

Use minimal styling for emphasis:

```dot
digraph styled {
    # Critical elements
    "STOP" [shape=octagon, style=filled, fillcolor=red, fontcolor=white];

    # Important elements
    "Verify tests" [shape=box, style=filled, fillcolor=lightgreen];

    # Start/End
    "Begin" [shape=doublecircle, style=filled, fillcolor=lightblue];
}
```

### Color Guidelines

- **Red**: Critical/Stop/Warning
- **Light Green**: Success/Approved
- **Light Blue**: Start/End states
- **Yellow**: Caution (use sparingly)

## Common Patterns

### Decision Tree

```dot
digraph decision {
    rankdir=TB;
    "Requirement met?" [shape=diamond];
    "All tests pass?" [shape=diamond];
    "Deploy" [shape=box];
    "Fix tests" [shape=box];
    "Fix requirements" [shape=box];

    "Requirement met?" -> "All tests pass?" [label="yes"];
    "Requirement met?" -> "Fix requirements" [label="no"];
    "All tests pass?" -> "Deploy" [label="yes"];
    "All tests pass?" -> "Fix tests" [label="no"];
    "Fix tests" -> "All tests pass?" [label="retry"];
    "Fix requirements" -> "Requirement met?" [label="retry"];
}
```

### Process Flow

```dot
digraph process {
    rankdir=TB;
    "Start" [shape=doublecircle];

    subgraph cluster_steps {
        label="Implementation Steps";
        "Write test" [shape=box];
        "Run test (RED)" [shape=box];
        "Write code" [shape=box];
        "Run test (GREEN)" [shape=box];
        "Refactor" [shape=box];
        "Run tests" [shape=box];
    }

    "Complete" [shape=doublecircle];

    "Start" -> "Write test";
    "Write test" -> "Run test (RED)";
    "Run test (RED)" -> "Write code";
    "Write code" -> "Run test (GREEN)";
    "Run test (GREEN)" -> "Refactor";
    "Refactor" -> "Run tests";
    "Run tests" -> "Complete";
}
```

### Two-Stage Review

```dot
digraph two_stage {
    rankdir=TB;

    subgraph cluster_stage1 {
        label="Stage 1: Spec Compliance";
        "Build component" [shape=box];
        "Review spec" [shape=diamond];
        "Fix spec issues" [shape=box];
    }

    subgraph cluster_stage2 {
        label="Stage 2: Quality Review";
        "Review quality" [shape=diamond];
        "Fix quality issues" [shape=box];
    }

    "Approved" [shape=doublecircle, style=filled, fillcolor=lightgreen];

    "Build component" -> "Review spec";
    "Review spec" -> "Fix spec issues" [label="issues found"];
    "Review spec" -> "Review quality" [label="compliant"];
    "Fix spec issues" -> "Review spec" [label="re-review"];
    "Review quality" -> "Fix quality issues" [label="issues found"];
    "Review quality" -> "Approved" [label="approved"];
    "Fix quality issues" -> "Review quality" [label="re-review"];
}
```

## Best Practices

### DO

✅ Use consistent node shapes
✅ Label all edges
✅ Keep diagrams simple
✅ Group related elements with clusters
✅ Use rankdir for readability
✅ Use minimal styling for emphasis

### DON'T

❌ Overuse colors
❌ Create complex diagrams (split into multiple)
❌ Forget edge labels
❌ Mix horizontal and vertical in same diagram
❌ Use decorative elements
❌ Create overly wide diagrams

## Integration with Meta-Skills

### When to Use

Include GraphViz diagrams for:
- **Decision trees** (when to use a skill)
- **Process flows** (step-by-step workflows)
- **Two-stage reviews** (spec + quality)
- **Review loops** (iterative processes)

### Documentation Standards

**Every workflow diagram should include:**
1. Clear title
2. Meaningful node labels
3. Labeled edges
4. Consistent shapes
5. Proper rank direction

### Example Integration

```markdown
## When to Use

```dot
digraph decision {
    rankdir=TB;
    "Need to test?" [shape=diamond];
    "Writing new code?" [shape=diamond];
    "Use TDD workflow" [shape=box];
    "Add tests to existing" [shape=box];

    "Need to test?" -> "Writing new code?" [label="yes"];
    "Need to test?" -> "N/A" [label="no"];
    "Writing new code?" -> "Use TDD workflow" [label="yes"];
    "Writing new code?" -> "Add tests to existing" [label="no"];
}
```
```

## Tools

### Rendering

GraphViz diagrams render automatically in:
- GitHub/GitLab markdown
- Many markdown viewers
- VS Code (with GraphViz extension)

### Editing

- **Online**: Draw.io, Mermaid.live
- **Desktop**: GraphViz, yEd
- **Text**: Edit DOT source directly

## Reference Examples

### Superpowers Patterns

Superpowers uses GraphViz extensively:
- Skill invocation flow
- Debugging phases
- Subagent orchestration
- Two-stage review process

### Ralph Integration

Ralph validation uses GraphViz for:
- Two-stage review workflow
- Hat coordination patterns
- Validation gates
- Review loops

## Summary

**Key Conventions:**
- Diamond = decision
- Box = action
- Double circle = start/end
- Label edges
- Use rankdir for flow direction
- Cluster related elements
- Minimal styling

**Benefits:**
- Consistent documentation
- Clear communication
- Standardized patterns
- Professional appearance

Following these conventions ensures all meta-skills have consistent, readable process visualizations.
