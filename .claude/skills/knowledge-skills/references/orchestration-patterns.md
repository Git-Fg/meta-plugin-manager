# Orchestration Patterns

Patterns for coordinating multiple skills, workflows, and context isolation.

---

## Pattern: Hub-and-Spoke Orchestration

**When**: Multi-step workflows (>3 steps) with high-volume intermediate output

### Problem Solved

Linear skill chains accumulate "context rot" - intermediate outputs, thinking noise, and token bloat make later steps less effective.

```
[Brittle Linear Chain]
[Main Context]: Step 1 output → Step 2 output → Step 3 output → Step 4 output
               (Huge Token Bloat, Context Rot)
```

### Solution: Hub with Forked Workers

```
[Hub Skill - Main Context]
    ↓ (spawn with context: fork)
[Worker A - Isolated Context] → Clean Result
    ↓ (hub receives result)
[Worker B - Isolated Context] → Clean Result (uses A)
    ↓ (hub receives result)
[Worker C - Isolated Context] → Final Result (uses A+B)
```

### Benefits

1. **Prevents Context Rot**: Each worker starts with clean, focused context
2. **Enables Parallelism**: Hub can spawn multiple forked skills simultaneously
3. **Reduces Hallucinations**: Constrained context prevents confusion from irrelevant history
4. **Modular & Reusable**: Worker skills can be called from any hub skill
5. **Error Isolation**: Failure in one worker doesn't corrupt others' contexts

### Hub Skill Example

```yaml
---
name: project-auditor
description: "Orchestrate comprehensive project audit with security, performance, and architecture validation"
disable-model-invocation: true
---

# Project Auditor

Coordinate multi-phase audit:

1. Spawn architecture-scan (context: fork)
   - Input: Project root
   - Output: Architecture patterns found

2. Spawn security-audit (context: fork, parallel)
   - Input: Project root
   - Output: Security findings

3. Spawn performance-check (context: fork, parallel)
   - Input: Project root
   - Output: Performance metrics

4. Aggregate all results
5. Generate comprehensive audit report

See individual audit skills for detailed patterns.
```

### Worker Skill Example

```yaml
---
name: security-audit
description: "Deep security analysis in isolated context"
context: fork
agent: Explore
---

Conduct security audit of $ARGUMENTS:

1. Analyze authentication patterns
2. Check for OWASP Top 10 vulnerabilities
3. Review permissions and access controls
4. Validate input sanitization
5. Generate security report with severity ratings

This creates noise, but isolation prevents context bloat.
```

### When to Use Hub-and-Spoke

| Scenario | Pattern | Why |
|----------|---------|-----|
| Multi-step pipeline (>3 steps) | Hub + Forked Workers | Prevents context rot |
| High-volume intermediate output | Forked Workers | Keeps main context clean |
| Parallel execution needed | Forked Workers | Isolation enables parallelism |
| Complex reasoning tasks | Forked Workers | Reduces confusion from irrelevant history |
| Simple deterministic chain | Linear | Low overhead, simple enough |

---

## Pattern: Context Fork Skills

**Context: fork** enables skills to run in isolated subagents with separate context windows.

### How Context: Fork Works

In a context: fork Skill run, the forked subagent's system prompt comes from the chosen agent (built-in or custom), while the Skill's SKILL.md becomes the task prompt that drives that subagent.

**Key Mechanism**:
1. **System Prompt Source**: The chosen agent (Explore, Plan, Bash, general-purpose, or custom)
2. **Task Direction**: The Skill's SKILL.md content
3. **Skills Composition**: Custom subagent skills inject at startup (additive, not replacement)

### When to Use Context: Fork

**Use For**:
- High-volume output (extensive grep, repo traversal)
- Noisy exploration that would clutter conversation
- Isolated computation needs
- Tasks requiring separate context window

**Don't Use For**:
- Simple, direct tasks
- User interaction workflows
- Low output volume operations
- Tasks needing conversation context

### Example

```yaml
---
name: codebase-scanner
description: "Scan entire codebase for architectural patterns and quality metrics"
context: fork
agent: Explore
---

Scan $ARGUMENTS:
1. Find all source files matching patterns
2. Identify architectural patterns used
3. Calculate complexity metrics
4. Generate comprehensive report

This creates noise, but isolation prevents context bloat.
```

**Recognition Question**: "Would separate context windows help here?"

---

## Pattern: Sequential Workflows

**For**: Complex tasks that benefit from deterministic, step-by-step execution

Use when tasks have clear dependencies and order matters.

### Example

```yaml
---
name: database-migration
description: "Execute database migrations with validation and rollback capability"
---

# Database Migration

Migration involves these sequential steps:

1. **Analyze the form** (run analyze_form.py)
2. **Create field mapping** (edit fields.json)
3. **Validate mapping** (run validate_fields.py)
4. **Fill the form** (run fill_form.py)
5. **Verify output** (run verify_output.py)

Each step depends on the previous. Execute in order.
```

**Recognition**: Use when step N requires output from step N-1.

---

## Pattern: Conditional Workflows

**For**: Tasks with branching logic where different conditions require different approaches

### Example

```yaml
---
name: data-processor
description: "Process data files based on type with appropriate validation and transformation"
---

# Data Processor

Determine the data type and apply appropriate workflow:

1. **Determine data type**:

   **JSON data?** → Follow JSON workflow
   - Validate JSON schema
   - Transform data structure
   - Export to database

   **CSV data?** → Follow CSV workflow
   - Parse CSV with delimiter detection
   - Validate column headers
   - Import to database

   **XML data?** → Follow XML workflow
   - Parse XML with namespace handling
   - Extract relevant elements
   - Transform to JSON
   - Export to database

2. Validate output regardless of type
3. Generate processing summary
```

**Recognition**: Use when different input types require fundamentally different processing.

---

## Pattern: Resource Taxonomy

When bundling resources with skills, understand the purpose of each type.

### Resource Types

| Type | Purpose | When to Use | Example |
|------|---------|-------------|---------|
| **scripts/** | Deterministic execution | Complex operations >3-5 lines, reusable utilities, performance-sensitive | rotate_pdf.py, validate.sh |
| **references/** | On-demand knowledge loading | Domain-specific details, API docs, schemas, troubleshooting guides | schema.md, api-docs.md |
| **assets/** | Output artifacts (not context) | Templates, images, icons, boilerplate that gets copied | logo.png, template.html |

### Scripts

**When to include**:
- Complex operations (>3-5 lines) that benefit from determinism
- Reusable utilities called multiple times
- Performance-sensitive operations where native tool speed matters
- Operations requiring explicit error handling patterns

**When to avoid**:
- Simple 1-2 line operations (use native tools directly)
- Highly variable tasks where Claude's adaptability is valuable
- One-time operations that don't warrant automation

### References

**Purpose**: Documentation and reference material intended to be loaded as needed into context

**When to include**:
- Domain-specific knowledge (finance schemas, business logic)
- API documentation and specifications
- Detailed workflow guides
- Troubleshooting information
- Company policies and conventions

**Benefits**:
- Keeps SKILL.md lean
- Loaded only when Claude determines it's needed
- Avoids duplication with SKILL.md

### Assets

**Purpose**: Files not intended to be loaded into context, but used within output

**When to include**:
- Templates that get copied or modified
- Images, icons, fonts
- Boilerplate code or project scaffolds
- Sample documents

---

## Decision Patterns

### When to Use Context: Fork

**Use**:
- High-volume output (extensive grep, repo traversal)
- Noisy exploration (clutters conversation)
- Isolated computation (separate context window)
- Parallel execution (multiple workers)

**Don't Use**:
- Simple tasks
- User interaction workflows
- Low output volume
- Tasks needing conversation context

### When to Use Hub-and-Spoke

**Use**:
- Multi-step workflows (>3 steps)
- High-volume intermediate output
- Need result aggregation from multiple workers
- Parallel execution of independent tasks

**Don't Use**:
- Simple sequential workflows (≤3 steps)
- Single-step operations
- Low-volume operations

### When to Use Regular Skills

**Use**:
- Simple, direct tasks
- Workflows ≤3 steps
- Need conversation context
- User interaction beneficial

**Don't Use**:
- High-volume output operations
- Noisy exploration
- Tasks requiring isolation

---

## Quick Reference

**DO**:
- Use hub-and-spoke for complex multi-step workflows
- Use context: fork for high-volume or noisy operations
- Design workers to be modular and reusable
- Aggregate results in hub skill

**DON'T**:
- Use context: fork for simple tasks (overhead not justified)
- Create linear chains >3 steps (context rot)
- Mix hub coordination with worker logic (separate concerns)
- Use regular skills for aggregation (one-way handoff only)

**See also**:
- [progressive-disclosure.md](progressive-disclosure.md) - Tier 1/2/3 structure
- [autonomy-design.md](autonomy-design.md) - High-autonomy patterns
- [anti-patterns.md](anti-patterns.md) - Common orchestration mistakes
