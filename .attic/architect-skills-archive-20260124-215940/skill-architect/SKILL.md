---
name: skill-architect
description: "Build self-sufficient skills following Agent Skills standard. Use when creating, evaluating, or enhancing skills with progressive disclosure and autonomy-first design. Not for general programming tasks."
user-invocable: true
---

# Skill Architect

## Core Philosophy

### The Delta Standard

> **Good Customization = Expert-only Knowledge − What Claude Already Knows**

Only provide information that has a "knowledge delta" - the gap between what Claude knows from training and what it needs for this specific project.

**Positive Delta** (keep these):
- Project-specific architecture decisions
- Domain expertise not in general training
- Business logic and constraints
- Non-obvious trade-offs
- Team-specific conventions

**Zero/Negative Delta** (remove these):
- General programming concepts
- Standard library documentation
- Common patterns Claude already knows
- Generic tutorials
- Obvious best practices

### Trust Your Intelligence

These are architectural patterns from successful implementations, not rigid rules. You understand:

- How to structure projects
- When to use progressive disclosure
- How to write clear descriptions
- When isolation (context: fork) helps
- How to design for autonomy

**Focus on**: Expert knowledge specific to this domain, not generic instructions.

### Recognition Questions

Before building or evaluating, ask yourself:

- **"Would Claude know this without being told?"** → If yes, delete it
- **"Is this expert-only or generic?"** → Keep only expert knowledge
- **"Does this justify its token cost?"** → Challenge every piece of information
- **"Does this signal WHAT/WHEN/NOT?"** → For descriptions

## Skill Lifecycle Awareness

Skills evolve through natural phases - recognize where a skill sits:

### Discovery Phase
- No skills exist or capability gap identified
- Question: "What expertise would help this project?"
- Action: Analyze project structure, identify patterns, suggest capabilities

### Creation Phase
- New capability needed, clear purpose
- Question: "What patterns best serve this domain?"
- Action: Build skill with proper tier structure, validate autonomy

### Evaluation Phase
- Quality check, production readiness
- Question: "Does this achieve its purpose effectively?"
- Action: Score against dimensions, identify improvements

### Enhancement Phase
- Real usage reveals gaps
- Question: "What would make this more useful?"
- Action: Optimize based on actual usage patterns

**Trust your judgment**: Phases aren't linear - iterate based on context and needs.

## Quality Dimensions as Design Lenses

View skills through these lenses for architectural assessment:

| Lens | Question | Recognition |
|------|----------|-------------|
| **Knowledge Delta** | Is this expert-only or could Claude infer it? | If Claude already knows it, remove it |
| **Autonomy** | Can this complete 80-95% without questions? | Count questions in test output |
| **Discoverability** | Does description signal WHEN to use it? | Apply What-When-Not framework |
| **Progressive Disclosure** | Is Tier 2 lean with Tier 3 for depth? | Check if SKILL.md < 500 lines |
| **Context Architecture** | Would isolation create value? | High-volume output benefits from fork |

See [quality-framework.md](references/quality-framework.md) for complete 11-dimensional assessment.

## Architectural Patterns

### Pattern: Three Skill Types

**Auto-Discoverable** (default):
- Claude uses when relevant, user can invoke via `/name`
- Description triggers auto-discovery
- Use for: Domain expertise, workflows, patterns

```yaml
---
name: api-conventions
description: "API design patterns for this codebase. Use when writing API endpoints, modifying existing endpoints, or reviewing API changes."
---
```

**User-Triggered** (destructive/timing-critical):
- Only user can invoke via `/name`
- Use for: Side-effects, timing-critical, destructive actions

```yaml
---
name: deploy
description: "Deploy application to production environment"
disable-model-invocation: true
argument-hint: [environment]
---
```

**Background Context** (hidden):
- Only Claude uses, hidden from `/` menu
- Use for: Context that enhances understanding

```yaml
---
name: legacy-system-context
description: "Explains the legacy authentication architecture"
user-invocable: false
---
```

### Pattern: Progressive Tiering

**When**: SKILL.md + references would exceed 500 lines
**Why**: Metadata always loads, body on trigger, depth on-demand

**Quick Decision Tree**:
- Content used <20% of the time? → Tier 3
- SKILL.md approaching 500 lines? → Move to Tier 3
- Would content help decide if skill is relevant? → Tier 1
- Essential for task completion? → Tier 2

| Tier | When Loaded | Purpose | Size Target |
|------|-------------|---------|-------------|
| **1** | Always | Discovery & relevance | ~100 tokens |
| **2** | On invocation | Core implementation | <500 lines |
| **3** | On demand | Deep details | Unlimited |

See [progressive-disclosure.md](references/progressive-disclosure.md) for complete guide.

### Pattern: Context Fork Skills

**Context: fork** enables skills to run in isolated subagents with separate context windows.

**Use For**:
- High-volume output (extensive grep, repo traversal)
- Noisy exploration that would clutter conversation
- Isolated computation needs
- Tasks requiring separate context window

**Don't Use For**:
- Simple, direct tasks
- User interaction workflows
- Low output volume operations

```yaml
---
name: codebase-scanner
description: "Scan entire codebase for architectural patterns"
context: fork
agent: Explore
---

Scan $ARGUMENTS:
1. Find all files matching pattern
2. Analyze content
3. Generate comprehensive report
```

**Recognition**: "Would separate context windows help here?"

See [orchestration-patterns.md](references/orchestration-patterns.md) for context fork mechanics.

### Pattern: Hub-and-Spoke Orchestration

**When**: Multi-step workflows (>3 steps) with high-volume intermediate output

**Problem**: Linear skill chains accumulate "context rot" - intermediate outputs and token bloat make later steps less effective.

**Solution**: Hub skill orchestrates, worker skills (context: fork) execute in isolation.

```
[Hub Skill - Main Context]
    ↓ (spawn with context: fork)
[Worker A - Isolated Context] → Clean Result
    ↓ (hub receives result)
[Worker B - Isolated Context] → Clean Result (uses A)
    ↓ (hub receives result)
[Worker C - Isolated Context] → Final Result (uses A+B)
```

**Benefits**:
- Prevents context rot - each worker starts with clean context
- Enables parallelism - hub can spawn multiple forked skills simultaneously
- Error isolation - failure in one worker doesn't corrupt others

**Recognition**: "Does this workflow have >3 steps with high-volume output?"

**Hub skill example**:
```yaml
---
name: project-auditor
description: "Orchestrate comprehensive project audit"
disable-model-invocation: true
---

Coordinate multi-phase audit:
1. Spawn architecture-scan (context: fork)
2. Spawn security-audit (context: fork, parallel)
3. Spawn performance-check (context: fork, parallel)
4. Aggregate results
5. Generate report
```

**Worker skill example**:
```yaml
---
name: security-audit
description: "Deep security analysis in isolated context"
context: fork
agent: Explore
---

Conduct security audit of $ARGUMENTS:
1. Analyze authentication patterns
2. Check for vulnerabilities
3. Review permissions
4. Generate security report
```

### Pattern: Resource Taxonomy

When bundling resources with skills, understand the purpose of each type:

| Type | Purpose | When to Use | Example |
|------|---------|-------------|---------|
| **scripts/** | Deterministic execution | Complex operations >3-5 lines, reusable utilities, performance-sensitive | rotate_pdf.py |
| **references/** | On-demand knowledge loading | Domain-specific details, API docs, schemas, troubleshooting guides | schema.md |
| **assets/** | Output artifacts (not context) | Templates, images, icons, boilerplate that gets copied | logo.png |

**When to include scripts**:
- Complex operations (>3-5 lines) that benefit from determinism
- Reusable utilities called multiple times
- Performance-sensitive operations where native tool speed matters
- Operations requiring explicit error handling patterns

**When to avoid scripts**:
- Simple 1-2 line operations (use native tools directly)
- Highly variable tasks where Claude's adaptability is valuable
- One-time operations that don't warrant automation

## Anti-Pattern Recognition

### Command Wrapper Anti-Pattern

**Problem**: Skill exists only to invoke a single command

**Recognition**: "Could the description alone suffice?"

**Example of anti-pattern**:
```yaml
---
name: run-tests
description: "Run the test suite"
---

Just run npm test.
```

**Fix**: Remove the skill - let Claude run commands directly

### Non-Self-Sufficient Anti-Pattern

**Problem**: Skill requires constant user hand-holding or orchestration

**Recognition**: "Can this work standalone?"

**Symptoms**:
- Asks many questions during execution
- Requires external tools/skills to function
- Lacks clear completion criteria

**Fix**: Add examples, context detection, decision trees

### Context Fork Misuse Anti-Pattern

**Problem**: Simple task uses isolation unnecessarily

**Recognition**: "Is the overhead justified?"

**Example of misuse**:
```yaml
---
name: greet-user
description: "Say hello"
context: fork  # Unnecessary overhead
---
```

**Fix**: Remove `context: fork` for simple, direct tasks

### Tier 2 Bloat Anti-Pattern

**Problem**: SKILL.md exceeds 500 lines

**Recognition**: "Could this be a reference file?"

**Fix**: Move detailed content to Tier 3 (references/)

### Description with HOW Anti-Pattern

**Problem**: Description includes implementation details

**Recognition**: "Does this signal WHAT/WHEN/NOT?"

**Anti-pattern**:
```yaml
description: "Use to CREATE skills by following these steps..."
```

**Good pattern**:
```yaml
description: "Build self-sufficient skills. Use when creating, evaluating, or enhancing skills."
```

See [anti-patterns.md](references/anti-patterns.md) for complete catalog.

## Official Documentation

**Primary references** (verify when accuracy matters):

- **Claude Code Skills**: https://code.claude.com/docs/en/skills
- **Agent Skills API**: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview
- **Best Practices**: https://platform.claude.com/docs/en/agents-and-tools/agent-skids/best-practices
- **Agent Skills Specification**: https://agentskills.io/specification

## Reference Files

Load these as needed for comprehensive guidance:

| File | Content | When to Read |
|------|---------|--------------|
| **[progressive-disclosure.md](references/progressive-disclosure.md)** | Tier 1/2/3 structure, decision trees, examples | Designing skill structure, organizing content |
| **[quality-framework.md](references/quality-framework.md)** | 11-dimensional scoring (0-160 scale), grades, evaluation | Assessing skill quality, production readiness |
| **[description-guidelines.md](references/description-guidelines.md)** | What-When-Not framework, examples, anti-patterns | Writing skill descriptions, improving discoverability |
| **[autonomy-design.md](references/autonomy-design.md)** | 80-95% completion patterns, testing methods | Improving skill autonomy, reducing questions |
| **[orchestration-patterns.md](references/orchestration-patterns.md)** | Hub-and-spoke, context fork, workflows | Designing multi-skill coordination |
| **[anti-patterns.md](references/anti-patterns.md)** | Complete anti-pattern catalog with recognition questions | Troubleshooting, avoiding common mistakes |

## SKILL_ARCHITECT_COMPLETE

**What was accomplished**:
- Architecture guidance provided
- High-value patterns demonstrated
- Excellence indicators shown
- Anti-patterns identified with recognition questions

**Your turn**: Apply these patterns intelligently to create, evaluate, or enhance skills. Trust your judgment on when and how to use each pattern.
