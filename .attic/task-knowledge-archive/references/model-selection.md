# Model Selection Reference

Complete guide to selecting the optimal model (haiku, sonnet, opus) for TaskList workflows and subagent coordination.

## Overview

Model selection significantly affects both cost and performance. Understanding when to use each model enables cost-optimized workflows without sacrificing quality.

## Three Models

### 1. haiku (Fast)

**Characteristics**:
- Fastest response time
- Lowest cost (1x baseline)
- Optimized for straightforward tasks
- Limited reasoning depth

**Use When**:
- Simple file operations (read, grep, glob)
- Basic validation checks
- Quick analysis without complex reasoning
- Cost-sensitive workflows
- High-volume simple operations

**Examples**:
- Scan directory structure
- Validate JSON syntax
- Simple pattern matching
- Basic file existence checks
- Quick configuration validation

**Cost**: 1x (baseline)

**When to Avoid**:
- Complex decision-making
- Multi-step reasoning
- Architecture design
- Nuanced trade-off analysis

---

### 2. sonnet (Default)

**Characteristics**:
- Balanced performance
- Good reasoning capability
- Default model (inherits from parent)
- Cost-effective for most tasks

**Use When**:
- Standard workflow execution
- Moderate complexity reasoning
- Most validation and analysis tasks
- Typical project scaffolding
- Default choice when uncertain

**Examples**:
- Multi-step refactoring workflows
- Standard compliance validation
- Code review and analysis
- Documentation generation
- Typical implementation tasks

**Cost**: 3x haiku

**When to Avoid**:
- Very simple tasks (use haiku instead)
- Extremely complex reasoning (consider opus)

---

### 3. opus (Complex Reasoning)

**Characteristics**:
- Highest quality reasoning
- Slowest response time
- Most expensive (10x haiku)
- Optimized for complexity

**Use When**:
- Architecture design
- Complex decision-making
- Multi-stage planning with dependencies
- Critical security analysis
- Nuanced trade-off evaluation

**Examples**:
- System architecture design
- Complex refactoring strategy
- Critical security vulnerability analysis
- Multi-stage project planning
- Complex dependency resolution

**Cost**: 10x haiku

**When to Avoid**:
- Simple operations (use haiku)
- Standard workflows (use sonnet)
- Cost-sensitive scenarios

## Cost Comparison

| Model | Relative Cost | When Justified |
|-------|---------------|----------------|
| **haiku** | 1x | Simple operations, high volume |
| **sonnet** | 3x | Standard workflows, most tasks |
| **opus** | 10x | Complex reasoning, critical decisions |

**Cost Impact Example**:
- 100 simple tasks with haiku: $X
- 100 simple tasks with sonnet: $3X
- 100 simple tasks with opus: $10X

**Key Insight**: Model selection has 10x cost impact. Choose wisely.

## Selection Decision Tree

```
Task complexity?
├─ Simple (straightforward, no reasoning)
│  └─→ haiku (fast, low cost)
├─ Standard (moderate complexity)
│  └─→ sonnet (balanced, default)
└─ Complex (architecture, critical decisions)
   └─→ opus (high quality, high cost)
```

## Cost Optimization Strategy

### Principle: Escalate Only When Necessary

1. **Start with haiku** for simple exploration and validation
2. **Escalate to sonnet** for standard workflow execution
3. **Use opus only** when complex reasoning is critical to success

### Cost-Saving Patterns

**Pattern 1: Haiku for Exploration**
```
Phase 1: Scan structure (haiku)
Phase 2: Basic validation (haiku)
Phase 3: If issues found → escalate to sonnet/opus for resolution
```

**Pattern 2: Sonnet for Execution**
```
Phase 1: Plan with opus (complex reasoning, one-time cost)
Phase 2: Execute with sonnet (standard workflow, repeated operations)
Phase 3: Validate with haiku (simple checks)
```

**Pattern 3: Task-Specific Models**
```
Task A (simple): haiku
Task B (standard): sonnet
Task C (complex): opus
Task D (simple): haiku
```

## TaskList Workflow Optimization

### Sequential Workflows

**Optimize by model per phase**:

```
Phase 1: Quick scan (haiku)
  ↓ Issues found
Phase 2: Detailed analysis (sonnet)
  ↓ Complex decisions needed
Phase 3: Architecture design (opus)
  ↓ Implementation
Phase 4: Standard execution (sonnet)
  ↓ Validation
Phase 5: Quick checks (haiku)
```

**Cost Impact**: Using haiku for phases 1 and 5, opus only for phase 3

### Parallel Workflows

**Different models for different tasks**:

```
Task A: "Validate JSON syntax" (haiku)
Task B: "Analyze code quality" (sonnet)
Task C: "Design architecture" (opus)
Task D: "Check file existence" (haiku)
```

**Cost Impact**: Using appropriate model for each task's complexity

## Subagent Model Selection

### Specifying Model in Tasks

When creating tasks with Task tool, specify model based on task requirements:

**Simple Tasks (haiku)**:
- File operations, basic validation
- Quick grep, simple analysis
- Cost-sensitive workflows

**Default Tasks (sonnet)**:
- Most workflow tasks
- Balanced performance
- Standard execution

**Complex Tasks (opus)**:
- Architecture design
- Complex decision-making
- Multi-stage planning with dependencies

### Example Patterns

**Pattern 1: Escalating Model**
```
Task 1: "Quick validation" (haiku)
  ↓ If validation fails
Task 2: "Detailed analysis" (sonnet)
  ↓ If complex issues
Task 3: "Complex resolution" (opus)
```

**Pattern 2: Specialized Tasks**
```
Task A: "Scan for patterns" (haiku - explore agent)
Task B: "Design solution" (opus - plan agent)
Task C: "Implement fix" (sonnet - general-purpose)
Task D: "Validate fix" (haiku - bash agent for tests)
```

## Quality vs. Cost Trade-offs

### When Opus is Worth the Cost

**Justified when**:
- Architecture mistake would be expensive to fix
- Security criticality requires thorough analysis
- Complex dependencies need careful navigation
- Single decision affects entire project trajectory

**Example**: Designing system architecture for large project - opus cost is justified vs. cost of architectural redesign.

### When Sonnet is Sufficient

**Sufficient when**:
- Standard workflow execution
- Moderate complexity reasoning
- Typical implementation tasks
- Most validation and analysis

**Example**: Implementing feature based on clear requirements - sonnet provides good quality at reasonable cost.

### When Haiku is Appropriate

**Appropriate when**:
- Simple, deterministic operations
- High-volume repetitive tasks
- Basic validation without reasoning
- Cost-sensitive scenarios

**Example**: Scanning 1000 files to find specific pattern - haiku significantly reduces cost.

## Common Mistakes

### ❌ Wrong: Using opus by default

```markdown
**Incorrect** (unnecessary cost):
All tasks use opus model
```

**Correct** (use appropriate model):
```markdown
Simple tasks: haiku
Standard tasks: sonnet
Complex tasks: opus
```

### ❌ Wrong: Using haiku for architecture

```markdown
**Incorrect** (insufficient reasoning):
Task: "Design system architecture" (haiku model)
```

**Correct** (use opus for complexity):
```markdown
Task: "Design system architecture" (opus model)
```

### ❌ Wrong: No model consideration

```markdown
**Incorrect** (missing optimization):
Create tasks without considering model selection
```

**Correct** (optimize by task):
```markdown
Task A (simple): haiku model
Task B (standard): sonnet model
Task C (complex): opus model
```

## Integration with Agent Types

### Agent Type + Model Combinations

| Agent Type | Optimal Model | Rationale |
|------------|---------------|-----------|
| **bash** | haiku | Commands are simple, fast execution |
| **explore** | haiku | Fast scanning, minimal reasoning |
| **plan** | opus | Complex reasoning requires quality |
| **general-purpose** | sonnet | Balanced for most mixed tasks |

**Exceptions**: Always match model to task complexity, not just agent type.

## Recommendations

1. **Default to sonnet** - Use haiku for simple ops, opus for complex reasoning
2. **Optimize for cost** - 10x difference between haiku and opus
3. **Match model to task** - Not all tasks in workflow need same model
4. **Escalate strategically** - Start cheap, escalate when needed
5. **Consider volume** - High-volume tasks benefit most from haiku

## Quick Reference Card

| I Need... | Use Model | Cost | Reasoning |
|-----------|-----------|------|-----------|
| Simple file ops | haiku | 1x | Fast, cheap |
| Basic validation | haiku | 1x | Deterministic |
| Standard workflow | sonnet | 3x | Balanced |
| Code analysis | sonnet | 3x | Good quality |
| Architecture | opus | 10x | Best quality |
| Critical decisions | opus | 10x | Necessary cost |

## Cost Calculation Examples

### Example 1: 100 Simple Tasks

**Using haiku**: 100 × $0.01 = $1.00
**Using sonnet**: 100 × $0.03 = $3.00
**Using opus**: 100 × $0.10 = $10.00

**Savings**: haiku saves 90% vs opus for simple tasks

### Example 2: Mixed Workflow

```
10 tasks × haiku (simple) = $0.10
50 tasks × sonnet (standard) = $1.50
5 tasks × opus (complex) = $0.50
Total: $2.10 vs $6.50 (all sonnet) vs $13.00 (all opus)
```

**Savings**: Appropriate model selection saves 84% vs opus

## Summary

**Key Principles**:
1. Start with haiku for simple operations
2. Use sonnet as default for standard workflows
3. Escalate to opus only for complex reasoning
4. Match model to each task's complexity
5. Consider cost impact at scale (10x difference)

**Decision Framework**:
- Simple? → haiku
- Standard? → sonnet
- Complex? → opus

**Result**: Cost-optimized workflows without sacrificing quality where it matters.
