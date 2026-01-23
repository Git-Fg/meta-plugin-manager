---
name: skills-knowledge
description: "Create self-sufficient skills following Agent Skills standard. Use when building autonomous capabilities with progressive disclosure. Do not use for general programming or non-Claude contexts."
user-invocable: true
---

# Skills Knowledge Base

## WIN CONDITION

**Called by**: skills-architect
**Purpose**: Provide implementation guidance for skill development
**Metric**: **Knowledge Delta** (Project-Specific ÷ Total Tokens)

**Success Criteria**:
1. **Zero Generic Tutorials**: No "How to use Python" or standard library docs.
2. **Expert-Only Focus**: Content restricted to architectural decisions, blocking rules, and complex project-specific patterns.

**Output**: Must output completion marker after providing guidance

```markdown
## SKILLS_KNOWLEDGE_COMPLETE

Guidance: [Implementation patterns provided]
References: [List of reference files]
Recommendations: [List]
```

**Completion Marker**: `## SKILLS_KNOWLEDGE_COMPLETE`

Create, audit, and refine Claude Code skills following the 2026 unified skills-commands paradigm.

## 🚨 MANDATORY: Read BEFORE Creating Skills

**CRITICAL**: You MUST read and understand these URLs:

### ⚠️ BLOCKING RULES
- **DO NOT proceed** until you've read the mandatory reference files
- **REQUIRED** to understand progressive disclosure before creating skills

## Core Principles

**Skills** are the PRIMARY building blocks for Claude Code plugins.

### The Delta Principle
> **Good Customization = Expert-only Knowledge − What Claude Already Knows**
> "If Claude knows it from training, **DELETE** it from the skill."

**Self-Sufficient Design**:
- Autonomous: Complete 80-95% of tasks without user questions
- Self-Sufficient: Work standalone AND enhance other workflows
- Discoverable: Auto-load through description trigger matching
- Progressive Disclosure: Tier 1 (metadata) → Tier 2 (instructions) → Tier 3 (resources)

## Skills vs Commands (2026)

**Unified Paradigm**: Commands and skills are unified - both create the same `/name` invocation.

**Choose Skills for**:
- Rich workflows with supporting files
- Complex capabilities with progressive disclosure
- Domain expertise that should be auto-discovered
- User-triggered workflows with `disable-model-invocation: true`

**Migration Path**:
```markdown
# Old: .claude/commands/deploy.md
# New: .claude/skills/deploy/SKILL.md
```

## Three Skill Types

### 1. Auto-Discoverable (Default)
Claude discovers and uses when relevant. User can also invoke via `/name`.

```yaml
---
name: api-conventions
description: "API design patterns for this codebase. Use when writing API endpoints."
---
```

### 2. User-Triggered Workflows
Only user can invoke via `/name`. Use for side-effects, timing-critical, or destructive actions.

```yaml
---
name: deploy
description: "Deploy application to production"
disable-model-invocation: true
argument-hint: [environment]
---
```

### 3. Background Context
Only Claude uses. Hidden from `/` menu. Use for context that enhances understanding.

```yaml
---
name: legacy-system-context
description: "Explains the legacy authentication architecture"
user-invocable: false
---
```

See **[references/types.md](references/types.md)** for detailed comparison and examples.

## Context: Fork Skills

**Context: fork** enables skills to run in isolated subagents with separate context windows.

### How Context: Fork Works

In a context: fork Skill run, the forked subagent's system prompt comes from the chosen agent (built-in or custom), while the Skill's SKILL.md becomes the task prompt that drives that subagent. If the chosen custom subagent also has `skills:` configured, those Skills' full contents are also injected into that forked subagent's context at startup—they don't get "replaced" by the forked Skill; they sit alongside it.

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

**Example**:
```yaml
---
name: codebase-scanner
description: "Scan entire codebase for patterns"
context: fork
agent: Explore
---

Scan $ARGUMENTS:
1. Find all files matching pattern
2. Analyze content
3. Generate comprehensive report
```

**Don't Use For**:
- Simple, direct tasks
- User interaction workflows
- Low output volume operations

## Pattern: Context-Forked Worker Skills

**When to Use**: Skills designed to be called by other skills in multi-step pipelines

### Problem Solved

Linear skill chains accumulate "context rot" - intermediate outputs, thinking noise, and token bloat that make later steps less effective. Using `context: fork` for worker skills mitigates this brittleness.

### Clean Fork Pipeline Architecture

**Instead of** (brittle linear chain in one context):
```
[Main Context]: Step 1 output → Step 2 output → Step 3 output
                      (Huge Token Bloat, Context Rot)
```

**Use** (hub with forked workers):
```
[Hub Skill - Main Context]
    ↓ (spawn with context: fork)
[Worker A - Isolated Context] → Clean Result
    ↓ (hub receives result)
[Worker B - Isolated Context] → Clean Result (uses A)
    ↓ (hub receives result)
[Worker C - Isolated Context] → Final Result (uses A+B)
```

### Benefits of Forked Workers

1. **Prevents Context Rot**: Each worker starts with clean, focused context
2. **Enables Parallelism**: Hub can spawn multiple forked skills simultaneously
3. **Reduces Hallucinations**: Constrained context prevents confusion from irrelevant history
4. **Modular & Reusable**: Worker skills can be called from any hub skill
5. **Error Isolation**: Failure in one worker doesn't corrupt others' contexts

### Implementation Example

**Hub Skill** (orchestrates workflow):
```yaml
---
name: analysis-pipeline
description: "Orchestrate multi-step analysis workflow"
disable-model-invocation: true
---

# Analysis Pipeline

1. Spawn research-worker (context: fork)
   - Input: $ARGUMENTS
   - Output: Research findings

2. Spawn analysis-worker (context: fork, parallel)
   - Input: Research findings
   - Output: Analysis results

3. Aggregate results
4. Spawn report-worker (context: fork)
   - Input: Aggregated data
   - Output: Final report
```

**Worker Skill** (isolated execution):
```yaml
---
name: research-worker
description: "Deep research in isolated context"
context: fork
agent: Explore
---

Research $ARGUMENTS thoroughly:
1. Find relevant files
2. Analyze content
3. Generate comprehensive research report

# This creates noise, but it's isolated from main context
```

### When to Use Forked Workers

| Scenario | Pattern | Why |
|----------|---------|-----|
| Multi-step pipeline (>3 steps) | Hub + Forked Workers | Prevents context rot |
| High-volume intermediate output | Forked Workers | Keeps main context clean |
| Parallel execution needed | Forked Workers | Isolation enables parallelism |
| Complex reasoning tasks | Forked Workers | Reduces confusion from irrelevant history |
| Simple deterministic chain | Linear | Low overhead, simple enough |

### When NOT to Use Forked Workers

| Scenario | Reason |
|----------|--------|
| Simple one-off tasks | Overhead not justified |
| Tasks needing conversation context | Forked context lacks history |
| Low-volume operations | No benefit to isolation |
| Single-step operations | Unnecessary complexity |

---

## Quick Start

### Step 1: Create Directory Structure
```bash
mkdir -p .claude/skills/skill-name
mkdir -p .claude/skills/skill-name/{references,scripts}
```

### Step 2: Write SKILL.md
```yaml
---
name: skill-name
description: "WHAT + WHEN + NOT formula"
---

# Skill Name

## What This Skill Does
[Clear description]

## When to Use
[Triggers and conditions]

## Implementation
[Step-by-step instructions]
```

### Step 3: Add Supporting Files (Optional)
```bash
# references/ - Detailed documentation
echo "# Detailed Reference" > references/detailed.md

# scripts/ - Executable utilities
echo "#!/bin/bash" > scripts/validate.sh
chmod +x scripts/validate.sh
```

See **[references/creation.md](references/creation.md)** for complete creation guide.

## Progressive Disclosure

**Tier 1** (~100 tokens): Metadata (name + description) - Always loaded
**Tier 2** (<500 lines): SKILL.md - Loaded when invoked
**Tier 3** (as needed): references/ and scripts/ - Loaded on-demand

**Rule**: Keep SKILL.md concise; move detailed content to references/ when approaching 500 lines.

## Quality Framework

11-dimensional scoring system (100 points total):

1. **Knowledge Delta** (20 points) - **CRITICAL**: Expert-only knowledge vs Generic info
2. **Autonomy** (10 points) - Completes 80-95% without questions
3. **Discoverability** (10 points) - Clear description triggers
4. **Progressive Disclosure** (10 points) - Tier 1/2/3 properly organized
5. **Clarity** (10 points) - Clear instructions and workflows
6. **Completeness** (10 points) - Covers all scenarios, handles edge cases
7. **Standards Compliance** (10 points) - Follows Agent Skills specification
8. **Security** (10 points) - Tool restrictions, validation, safe execution
9. **Performance** (10 points) - Efficient workflows, minimal token usage
10. **Maintainability** (5 points) - Well-structured, easy to update
11. **Innovation** (5 points) - Unique value, creative solutions

**Pass Threshold**: ≥80/100

See **[references/audit.md](references/audit.md)** for complete audit checklist.

## Common Patterns

### Template Pattern
```markdown
## Report structure
ALWAYS use this exact template structure:
```markdown
# [Analysis Title]
## Executive summary
[One-paragraph overview]
```
```

### Examples Pattern
```markdown
## Commit message format
**Example 1:**
Input: Added user authentication
Output:
```
feat(auth): implement JWT-based authentication
```
```

### Conditional Workflow Pattern
```markdown
## Document modification workflow
1. Determine modification type:
   **Creating new content?** → Follow "Creation workflow"
   **Editing existing content?** → Follow "Editing workflow"
```

See **[references/patterns.md](references/patterns.md)** for all patterns and examples.

## Troubleshooting

### Skill Not Triggering
**Problem**: Claude doesn't use the skill when expected

**Solutions**:
1. Check description includes keywords users would naturally say
2. Verify skill appears in `/help`
3. Try rephrasing request to match description
4. Invoke directly with `/skill-name` if user-invocable

### Poor Auto-Discovery
**Problem**: Skill isn't discovered automatically

**Solutions**:
1. Review description for trigger clarity
2. Add relevant keywords users would say
3. Test with different phrasings
4. Consider if skill should be user-triggered instead

See **[references/troubleshooting.md](references/troubleshooting.md)** for complete troubleshooting guide.

## Additional Resources

### Reference Files
- **[types.md](references/types.md)** - Skill types, examples, comparison
- **[creation.md](references/creation.md)** - Complete creation guide
- **[audit.md](references/audit.md)** - Quality framework and checklist
- **[patterns.md](references/patterns.md)** - Refinement patterns and examples
- **[troubleshooting.md](references/troubleshooting.md)** - Common issues and solutions

### External Resources
- **Agent Skills Specification**: https://github.com/agentskills/agentskills
- **Skills Examples**: https://github.com/agentskills/examples
- **Official Anthropic Skills**: https://github.com/anthropics/skills

### Related Skills
- **[meta-architect-claudecode](meta-architect-claudecode/)** - Layer selection and architecture decisions
- **[toolkit-architect](toolkit-architect/)** - Project scaffolding and .claude/ organization

## Transitive Skills (Called by Other Skills)

### Definition
Transitive skills are workflow steps called by other skills in multi-step processes.

### When You Need a Transitive Skill
- Called by architect skills as part of a workflow
- Reusable component across multiple workflows
- Needs clear completion for workflow coordination

### Win Conditions for Transitive Skills

Transitive skills **MUST** output a completion marker:

```markdown
# Transitive Skill Example
---
name: check-skill-quality
description: "Checks if skill meets quality standards"
---

Analyze skill and output:

## QUALITY_CHECK_COMPLETE

Quality Score: X/10
Pass/Fail: [PASS|FAIL]
Issues: [List of issues]
```

### Regular Skills (No Win Conditions)

Regular skills are user-invocable or knowledge skills:

```markdown
# Regular Skill Example
---
name: api-conventions
description: "API design patterns for this codebase. Use when writing API endpoints."
user-invocable: true
---

# No win condition needed - user invokes directly
```

### Context: Fork for Transitive Skills

**Use sparingly** - forked skills lose global context:

```markdown
# ❌ BAD - Needs context from main conversation
---
name: make-decision
description: "Makes workflow decisions"
context: fork  # LOSES CONTEXT!
---

# Will fail - no access to user preferences or workflow history

# ✅ GOOD - Isolated analysis
---
name: scan-files
description: "Scans files for patterns"
context: fork
agent: Explore
---

# WIN CONDITION:
## FILE_SCAN_COMPLETE

{"patterns": [...], "count": X}
```

**When to fork a transitive skill**:
- ✅ Isolated analysis (no context needed)
- ✅ Noisy operations (want isolation)
- ❌ Need conversation history
- ❌ Need user preferences
- ❌ Need project context
