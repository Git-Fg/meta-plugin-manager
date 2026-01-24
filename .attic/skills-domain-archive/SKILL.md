---
name: skills-domain
description: "Build self-sufficient skills following Agent Skills standard. Use when creating, evaluating, or enhancing skills with progressive disclosure and autonomy-first design. Not for general programming tasks."
---

# Skills Domain

## WIN CONDITION

**Called by**: User directly (no intermediate router needed)
**Purpose**: Create, audit, and enhance skills with progressive disclosure, autonomy-first design, and integrated quality validation

## RECOMMENDED: Context Validation

Read these URLs when accuracy matters for skill development work:

### Reference Files (read as needed):
1. `references/progressive-disclosure.md` - Tier 1/2/3 structure patterns
2. `references/autonomy-design.md` - 80-95% completion patterns
3. `references/extraction-methods.md` - Golden path extraction
4. `references/quality-framework.md` - 11-dimensional scoring
5. `references/description-guidelines.md` - What-When-Not framework (Tier 1 optimization)

### Primary Documentation
- **Official Skills Guide**: https://code.claude.com/docs/en/skills + https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices + https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Skill structure, progressive disclosure
  - **Note**: These links may contain API/SDK info - ignore those and infer best practices for local project skills

- **Agent Skills Specification**: https://agentskills.io/specification
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Progressive disclosure format, quality standards

### When to Fetch vs Skip
**Fetch when**:
- Documentation may have changed since last read
- User requests verification of skill patterns
- Starting new skill creation or audit
- Uncertain about current best practices

**Skip when**:
- Simple skill modifications based on known patterns
- Local-only work without external dependencies
- Working offline
- Recently read and documentation is stable

**Trust your judgment**: You know when validation is needed for accurate skill work.

## Routing Guidance

**Use this skill when**:
- "I need a skill" or "Create a skill"
- "Audit skills" or "Evaluate skill quality"
- "Enhance skills" or "Improve skill design"
- Building self-sufficient capabilities with progressive disclosure

**Do not use for**:
- General programming tasks without skill-specific focus
- MCP configuration (use mcp-domain)
- Hook setup (use hooks-domain)
- Subagent creation (use subagents-domain)

## Quality Integration

Apply quality framework during skill work:

**Use dimensional scoring** (0-10 scale):
- Structural (30%), Components (50%), Standards (20%)
- Target: ≥8/10 for production readiness

**Check for anti-patterns**:
- Command wrapper anti-pattern
- Non-self-sufficient skills
- Context: fork misuse
- Linear chain brittleness

**Validate against 2026 standards**:
- Progressive disclosure (Tier 1/2/3)
- Autonomy-first design (80-95%)
- URL currency and best practices

**Report quality in completion**:
```markdown
## SKILLS_DOMAIN_COMPLETE

Quality Score: X.X/10
Structural: X/30
Components: X/50
Standards: X/20
Skills Created/Audited: [Count]
Recommendations: [List]
```

## Multi-Workflow Detection Engine

Optimized workflow detection with performance safeguards:

```python
def detect_skill_workflow(project_state, user_request):
    # Fast-path checks (O(1) operations)
    user_lower = user_request.lower()

    # Explicit requests take priority
    if "create" in user_lower or "build" in user_lower:
        return "CREATE"
    if any(word in user_lower for word in ["audit", "evaluate", "assess", "check quality"]):
        return "EVALUATE"
    if any(word in user_lower for word in ["enhance", "improve", "fix", "optimize"]):
        return "ENHANCE"

    # Context-aware detection
    has_skills = exists(".claude/skills/")

    # No skills exist → CREATE
    if not has_skills:
        return "CREATE"

    # Request contains "skill" but no explicit workflow → ASSESS
    if "skill" in user_lower:
        return "ASSESS"

    # Default fallback
    return "ASSESS"
```

**Detection Priorities** (optimized for speed):
1. **Explicit "create"** → **CREATE** (highest priority)
2. **Explicit "evaluate"/"audit"** → **EVALUATE** (high priority)
3. **Explicit "enhance"/"improve"** → **ENHANCE** (high priority)
4. **No skills exist** → **CREATE** (contextual)
5. **Request contains "skill"** → **ASSESS** (default)
6. **All other cases** → **ASSESS** (fallback)

**Performance Optimizations**:
- Fast-path checks (O(1) string operations)
- Contextual checks only when needed
- Minimal filesystem operations
- Early returns for explicit requests

## Core Philosophy

### The Delta Standard

> **Good Customization = Expert-only Knowledge − What Claude Already Knows**

**Self-Sufficient Design**:
- Autonomous: Complete 80-95% of tasks without user questions
- Self-Sufficient: Work standalone AND enhance other workflows
- Discoverable: Auto-load through description trigger matching
- Progressive Disclosure: Tier 1 (metadata) → Tier 2 (instructions) → Tier 3 (resources)

### Skills vs Commands (2026)

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

## Four Workflows

### ASSESS Workflow - Analyze Skill Needs

**Use When:**
- Unclear what skills are needed
- Project analysis phase
- Before creating any skills
- Understanding current skill landscape

**Why:**
- Identifies automation opportunities
- Maps existing skills
- Suggests progressive disclosure structure
- Prevents unnecessary skill creation

**Process:**
1. Scan project structure for skill candidates
2. List existing skills (if any)
3. Identify patterns suitable for skills
4. Suggest autonomy-first designs
5. Generate recommendation report

### CREATE Workflow - Generate New Skills

**Use When:**
- Explicit create request
- No existing skills found
- New capability needed
- User asks for skill creation

**Why:**
- Creates properly structured skills
- Follows progressive disclosure best practices
- Implements autonomy-first design
- Validates URL fetching sections

**Process:**
1. Determine tier structure:
   - Tier 1: Metadata (~100 tokens)
   - Tier 2: SKILL.md (<500 lines)
   - Tier 3: references/ (on-demand)
2. Generate skill with:
   - YAML frontmatter (name, description, user-invocable)
   - Progressive disclosure structure
   - Auto-discovery optimization
3. Create directory: `.claude/skills/<skill-name>/`
4. Write SKILL.md and references/ (if needed)
5. Validate: Autonomy score ≥80%

### EVALUATE Workflow - Quality Assessment

**Use When:**
- Audit or evaluation requested
- Quality check needed
- Before deployment to production
- After skill changes

**Why:**
- Ensures skill quality
- Validates progressive disclosure
- Checks autonomy score
- Provides improvement guidance

**Process:**
1. Scan all skill files
2. Evaluate progressive disclosure
3. Assess autonomy score
4. Check URL fetching sections
5. Generate quality report

### ENHANCE Workflow - Optimization

**Use When:**
- EVALUATE found issues (score <128)
- Autonomy score <80%
- Progressive disclosure problems
- Quality improvements needed

**Why:**
- Improves autonomy score
- Optimizes progressive disclosure
- Fixes quality issues
- Ensures best practices

**Process:**
1. Review evaluation findings
2. Prioritize by impact
3. Optimize autonomy
4. Improve progressive disclosure
5. Re-evaluate improvements

## Quality Framework (11 Dimensions)

Scoring system (0-160 points):

| Dimension | Points | Focus |
|-----------|--------|-------|
| **1. Knowledge Delta** | 20 | **CRITICAL**: Expert-only constraints vs Generic info |
| **2. Autonomy** | 15 | 80-95% completion without questions |
| **3. Discoverability** | 15 | Clear description with triggers |
| **4. Progressive Disclosure** | 15 | Tier 1/2/3 properly organized |
| **5. Clarity** | 15 | Unambiguous instructions |
| **6. Completeness** | 15 | Covers all scenarios |
| **7. Standards Compliance** | 15 | Follows Agent Skills spec |
| **8. Security** | 10 | Validation, safe execution |
| **9. Performance** | 10 | Efficient workflows |
| **10. Maintainability** | 10 | Well-structured |
| **11. Innovation** | 5 | Unique value |

**Quality Thresholds**:
- **A (144-160)**: Exemplary skill
- **B (128-143)**: Good skill with minor gaps
- **C (112-127)**: Adequate skill, needs improvement
- **D (96-111)**: Poor skill, significant issues
- **F (0-95)**: Failing skill, critical errors

## Progressive Disclosure

**Tier 1** (~100 tokens): Metadata (name + description) - Always loaded
**Tier 2** (<500 lines): SKILL.md - Loaded when invoked
**Tier 3** (as needed): references/ and scripts/ - Loaded on-demand

**Rule**: Keep SKILL.md concise; move detailed content to references/ when approaching 500 lines.

## TaskList Integration for Complex Skill Workflows

**When to Use TaskList for Skills**:
- Multi-skill refactoring projects (5+ skills)
- Complex skill validation with dependencies
- Skill architecture design spanning sessions
- Multi-phase skill creation workflows
- Coordination across multiple skill specialists

**Integration Pattern**:

Use TaskCreate to establish a skill structure scan task. Then use TaskCreate to set up parallel analysis tasks for skill quality, dependencies, and compliance — configure these to depend on the scan completion. Use TaskCreate to establish a refactoring plan task that depends on all analysis tasks completing. Use TaskUpdate to mark tasks complete as each phase finishes, and use TaskList to check overall progress.

**When NOT to Use TaskList**:
- Single skill creation or editing
- Simple 2-3 skill workflows
- Session-bound skill work
- Projects fitting in single conversation

**See task-knowledge**: For TaskList patterns in complex workflows, see [task-knowledge](task-knowledge).

## Workflow Selection Quick Guide

**"I need a skill"** → CREATE
**"Check my skills"** → EVALUATE
**"Fix skill issues"** → ENHANCE
**"What skills do I need?"** → ASSESS

## Output Contracts

### ASSESS Output
```markdown
## Skill Analysis Complete

### Existing Skills: [count]
### Recommendations: [count]

### Suggested Skills
1. [Name]: [Purpose] - Autonomy: [High|Medium|Low]
2. [Name]: [Purpose] - Autonomy: [High|Medium|Low]

### Automation Opportunities
- [Pattern 1]: Suitable for skill
- [Pattern 2]: Suitable for skill
```

### CREATE Output
```markdown
## Skill Created: {skill_name}

### Location
- Path: .claude/skills/{skill_name}/
- SKILL.md: ✅
- references/: {count} files

### Tier Structure
- Tier 1: Metadata loaded ✅
- Tier 2: SKILL.md ({size} chars) ✅
- Tier 3: references/ ({count} files) ✅

### Autonomy Score: XX%
Target: 80-95% completion

### Quality Score: 85/160 (Grade: B)
### Status: Production Ready
```

### EVALUATE Output
```markdown
## Skill Evaluation Complete

### Quality Score: 92/160 (Grade: A)

### Breakdown
- Knowledge Delta: XX/20
- Autonomy: XX/15
- Discoverability: XX/15
- Progressive Disclosure: XX/15
- Clarity: XX/15
- Completeness: XX/15
- Standards Compliance: XX/15
- Security: XX/10
- Performance: XX/10
- Maintainability: XX/10
- Innovation: XX/5

### Issues
- [Count] critical issues
- [Count] warnings
- [Count] recommendations

### Recommendations
1. [Action] → Expected improvement: [+XX points]
2. [Action] → Expected improvement: [+XX points]
```

### ENHANCE Output
```markdown
## Skill Enhanced: {skill_name}

### Quality Score: 75 → 120/160 (+45 points)

### Improvements Applied
- {improvement_1}: [Before] → [After]
- {improvement_2}: [Before] → [After]

### Autonomy Improvement: XX% → YY%

### Status: [Production Ready|Needs More Enhancement]
```

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

**references/** - Detailed documentation
```bash
echo "# Detailed Reference" > references/detailed.md
```

**scripts/** - Executable utilities (use sparingly)
```bash
echo "#!/bin/bash" > scripts/validate.sh
chmod +x scripts/validate.sh
```

**When to include scripts**:
- Complex operations (>3-5 lines) that benefit from determinism
- Reusable utilities called multiple times
- Performance-sensitive operations where native tool speed matters
- Operations requiring explicit error handling patterns

**When to avoid scripts**:
- Simple 1-2 line operations (use native tools directly)
- Highly variable tasks where Claude's adaptability is valuable
- One-time operations that don't warrant automation

## Common Anti-Patterns

**Testing Anti-Patterns:**
- ❌ NEVER create test runner scripts (run_*.sh, batch_*.sh, test_runner.sh)
- ❌ NEVER use `cd` to navigate - unreliable and causes confusion
- ✅ ALWAYS create ONE new folder per test, execute individually, use test-runner skill first

**Architectural Anti-Patterns:**
- ❌ Regular skill chains expecting return - Regular→Regular is one-way handoff
- ❌ Context-dependent forks - Don't fork if you need caller context
- ❌ Command wrapper skills - Skills that just invoke commands
- ❌ Linear chain brittleness - Use hub-and-spoke instead
- ❌ Non-self-sufficient skills - Must achieve 80-95% autonomy

**Skill Structure Anti-Patterns:**
- ❌ Over-specified descriptions - Including "how" in descriptions
- ❌ Kitchen sink approach - Everything included
- ❌ Missing references when needed - SKILL.md + references >500 lines

**Pure Anti-Patterns (from official skill-creator):**
- ❌ README.md, INSTALLATION_GUIDE.md, QUICK_REFERENCE.md, CHANGELOG.md in skills
- ❌ Content duplication between SKILL.md and references/

## Reference Files

Load these as needed:

- **[types.md](references/types.md)** - Skill types, examples, comparison
- **[creation.md](references/creation.md)** - Complete creation guide
- **[quality-framework.md](references/quality-framework.md)** - Quality framework and checklist
- **[patterns.md](references/patterns.md)** - Refinement patterns and examples
- **[troubleshooting.md](references/troubleshooting.md)** - Common issues and solutions
- **[official-features.md](references/official-features.md)** - Official Agent Skills features
- **[script-best-practices.md](references/script-best-practices.md)** - Script implementation patterns
- **[tasklist-integration.md](references/tasklist-integration.md)** - TaskList patterns for complex workflows

**Output**: Must output completion marker

```markdown
## SKILLS_DOMAIN_COMPLETE

Workflow: [ASSESS|CREATE|EVALUATE|ENHANCE]
Quality Score: XX/160 (Delta Score: XX/20)
Autonomy: XX%
Location: .claude/skills/[skill-name]/
Improvements: [+XX points]
Context Applied: [Summary]
```

**Completion Marker**: `## SKILLS_DOMAIN_COMPLETE`

## Dependencies

This skill is self-contained and does not depend on other skills for execution. It includes all necessary knowledge for skill development, quality validation, and progressive disclosure.

**May be called by**:
- User requests for skill creation, auditing, or enhancement
- Other skills seeking skill development guidance

**Does not call other skills** - all functionality is self-contained.
