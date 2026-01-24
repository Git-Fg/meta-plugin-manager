# Skill Patterns and Anti-Patterns

High-value patterns for building effective skills, and common mistakes to avoid.

## Core Patterns

### Pattern 1: What-When-Not Descriptions

**Structure**: WHAT (function) + WHEN (triggers) + NOT (boundaries)

**Good**:
```yaml
---
name: api-conventions
description: "RESTful API design patterns. Use when writing, modifying, or reviewing endpoints. Not for GraphQL or RPC."
---
```

**Pattern**: Clear purpose, specific triggers, defined boundaries

### Pattern 2: Progressive Disclosure

**Structure**: Tier 1 (metadata) → Tier 2 (core) → Tier 3 (details)

**Tier 1** (~100 tokens):
```yaml
---
name: security-validator
description: "Security validation using OWASP patterns. Use when reviewing code or auditing security."
---
```

**Tier 2** (<500 lines):
```markdown
# Security Validator

## Scan For
1. SQL injection (string concat in queries)
2. XSS (no output encoding)
3. Auth bypass (missing checks)

See [owasp.md](references/owasp.md) for complete patterns.
```

**Tier 3** (references/):
- `owasp.md` - Detailed OWASP Top 10
- `remediation.md` - Fix examples
- `advanced.md` - Complex scenarios

**Pattern**: Reveal complexity progressively, not all at once

### Pattern 3: High-Autonomy Design

**Target**: 80-95% completion without questions

**Good**:
```yaml
---
name: file-organizer
description: "Organize project files by type and purpose"
---

# File Organizer

**Organize by**:
- Code (*.js, *.ts) → src/
- Tests (*.test.*) → tests/
- Docs (*.md) → docs/
- Config (*.config.*) → config/

Output: List of files moved.
```

**Questions**: 0 (100% autonomy)

**Low autonomy** (bad):
```yaml
---
name: file-helper
description: "Helps organize files"
---

Organize your files.
```

**Questions**: "How?" "What criteria?" "Where?" (3+ questions)

**Pattern**: Provide clear patterns and outputs, not vague requests

### Pattern 4: Context Fork for Isolation

**Use when**: High-volume output, noisy exploration

**Good**:
```yaml
---
name: codebase-scanner
description: "Scan entire codebase for patterns"
context: fork
agent: Explore
---

Scan $ARGUMENTS:
1. Find all matching files
2. Analyze content
3. Generate report
```

**Pattern**: Isolation prevents context bloat for noisy operations

### Pattern 5: Hub-and-Spoke Orchestration

**Hub** (orchestrates):
```yaml
---
name: project-auditor
description: "Orchestrate comprehensive project audit"
disable-model-invocation: true
---

Coordinate audit phases:
1. Architecture scan
2. Security validation
3. Performance check
4. Report generation
```

**Workers** (isolated):
```yaml
---
name: security-audit
description: "Deep security analysis"
context: fork
agent: Explore
---

Conduct security audit of $ARGUMENTS
```

**Pattern**: Hub delegates to forked workers for clean aggregation

## Common Anti-Patterns

### Anti-Pattern 1: Command Wrapper

**Bad**:
```yaml
---
name: deploy-command
description: "Use to deploy the application"
---

# Deploy

Run: npm run deploy
```

**Problem**: Skill just wraps a command, adds no value

**Good**: Remove the skill, use command directly

### Anti-Pattern 2: Non-Self-Sufficient Skills

**Bad**:
```yaml
---
name: api-helper
description: "Helps with APIs"
---

# API Helper

Refer to docs/api-guide.md for everything.
```

**Problem**: Requires external file, not self-contained

**Good**: Include patterns in skill, use references for deep details

### Anti-Pattern 3: Context Fork Misuse

**Bad**:
```yaml
---
name: simple-counter
description: "Count files in directory"
context: fork
---

Count files.
```

**Problem**: Simple task, no need for fork overhead

**Good**: Remove `context: fork`, use regular skill

### Anti-Pattern 4: Linear Chain Brittleness

**Bad**:
```
[Main] → Step 1 → Step 2 → Step 3 → Step 4 → Step 5
(Context accumulates, becomes noisy)
```

**Good**: Hub with forked workers
```
[Hub]
  ↓ (fork)
[Worker 1] → Result
[Worker 2] → Result
[Worker 3] → Result
```

### Anti-Pattern 5: Over-Prescriptive Workflows

**Bad**:
```yaml
---
name: skill-creator
description: "Create skills by following steps"
---

# Create Skill

Step 1: Create directory
Step 2: Write YAML
Step 3: Add description
Step 4: Write content
Step 5: Test skill
```

**Problem**: Prescribes HOW, not WHAT

**Good**:
```yaml
---
name: skill-architect
description: "Build self-sufficient skills. Use when creating, evaluating, or enhancing skills."
---

## Skill Structure

**Location**: `.claude/skills/{name}/`
**Required**: SKILL.md with YAML (name, description)
**Optional**: references/ for detailed content

## Example Structure
```
skill-name/
├── SKILL.md (required)
└── references/ (optional)
```

Trust your judgment on organization.
```

## Orchestration Patterns

### Pattern 1: Regular Skill Chain
**Use for**: Simple sequential workflows (≤3 steps)

```
[A] → [B] → [C]
```

**Example**: validate → format → commit

### Pattern 2: Hub-and-Spoke
**Use for**: Complex workflows with aggregation (≥4 steps)

```
      [B]
     ↗  ↘
[Hub]     [Aggregator]
     ↘  ↗
      [C]
```

**Critical**: ALL workers MUST use `context: fork` for aggregation

### Pattern 3: Context Fork Chain
**Use for**: Noisy operations needing isolation

```
[Main] → [Forked A] → [Forked B] → [Forked C]
```

**Each fork**: Clean context, no accumulated noise

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

### When to Create References

**Create** when:
- SKILL.md + references >500 lines total
- Content used <20% of time
- Detailed explanations clutter core message
- Multiple specialized use cases

**Don't Create** when:
- Content is essential for task completion
- Used frequently
- SKILL.md is already short (<200 lines)

### When to Use disable-model-invocation

**Use**:
- Destructive operations (deploy, delete, migrate)
- Side-effect actions (send notifications, modify production)
- User-only workflows (manual approval required)

**Don't Use**:
- Information retrieval
- Analysis and inspection
- Read-only operations

## Quality Patterns

### High Autonomy Pattern
**Target**: 0-3 questions (85-100% autonomy)

**Pattern**:
```yaml
---
name: x
description: "Clear purpose with triggers"
---

# Clear Section Headers

## Input
What to provide

## Process
Specific steps or patterns

## Output
Expected result format
```

### High Knowledge Delta Pattern
**Target**: Expert-only, no generic content

**Pattern**:
```yaml
---
name: x
description: "Project-specific patterns. Use when [specific context]."
---

## Our Convention
Specific to this project

## Why This Matters
Non-obvious reasoning

## Examples
Project-specific examples
```

### High Discoverability Pattern
**Target**: Clear WHAT/WHEN/NOT

**Pattern**:
```yaml
description: "[WHAT]. Use when: [TRIGGER 1], [TRIGGER 2], [TRIGGER 3]. Not for: [BOUNDARY]."
```

## Quick Reference

**DO**:
- Trust AI intelligence
- Show examples, not prescriptions
- Use progressive disclosure
- Define clear boundaries
- Design for autonomy

**DON'T**:
- Over-prescribe workflows
- Wrap simple commands
- Use context fork unnecessarily
- Create premature references
- Include generic tutorials
