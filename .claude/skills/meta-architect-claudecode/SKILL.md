---
name: meta-architect-claudecode
description: "Guide layer selection for Claude Code. Use when choosing between CLAUDE.md rules, skills, subagents, hooks, or MCP. Do not use for general coding questions or non-architecture tasks."
user-invocable: true
---

# Meta-Architect

## WIN CONDITION

**Called by**: Various architect skills
**Purpose**: Guide layer selection and architecture decisions

**Output**: Must output completion marker after providing guidance

```markdown
## META_ARCHITECT_COMPLETE

Layer Selected: [CLAUDE.md|Skill|Subagent|Hook|MCP]
Pattern: [Linear|Hub-Spoke|Fork]
Decision: [Summary]
```

**Completion Marker**: `## META_ARCHITECT_COMPLETE`

Choose the right customization layer and build effective skills for Claude Code using official documentation.

## 🚨 MANDATORY: Read BEFORE Proceeding

**CRITICAL**: You MUST read and understand these URLs:

### Primary Documentation (MUST READ)
- **[MUST READ] Official Skills Guide**: https://code.claude.com/docs/en/skills
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **When to Read**: Before any customization layer decisions
  - **Content**: Skills architecture, progressive disclosure, best practices
  - **Cache**: 15 minutes minimum

- **[MUST READ] Subagents Guide**: https://code.claude.com/docs/en/sub-agents
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **When to Read**: When considering subagent usage
  - **Content**: Agent coordination patterns, state management, context: fork
  - **Cache**: 15 minutes minimum

- **[MUST READ] Plugin Architecture**: https://code.claude.com/docs/en/plugins
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **When to Read**: Before plugin structure decisions
  - **Content**: Plugin organization, component architecture
  - **Cache**: 15 minutes minimum

### ⚠️ BLOCKING RULES
- **DO NOT proceed** until you've fetched and reviewed Primary Documentation
- **REQUIRED** to understand skills-first architecture before layer selection
- **REQUIRED** to understand progressive disclosure before implementation

---

## Quick Decision Tree

### Layer Selection (START HERE)

```
START: What do you need?
│
├─ "Persistent project norms"
│  └─→ CLAUDE.md rules
│
├─ "Domain expertise to discover"
│  └─→ Skill (Minimal Pack: CLAUDE.md + Skill)
│     ├─ "Simple, focused task" → Skill (regular)
│     └─ "Complex workflow needing isolation" → Skill (context: fork)
│
├─ "Event automation"
│  └─→ Hook
│
├─ "Service integration"
│  └─→ MCP
│
└─ "Isolation/parallelism"
   └─→ Subagent (RARE/ADVANCED)
```

**Context: Fork Triggers:**
- High-volume output (extensive grep, repo traversal)
- Noisy exploration that clutters conversation
- Log analysis, full codebase audits
- Tasks benefiting from separate context window

**Context: Fork Mechanism:**
In a context: fork Skill run, the forked subagent's system prompt comes from the chosen agent (built-in or custom), while the Skill's SKILL.md becomes the task prompt that drives that subagent. If the chosen custom subagent also has `skills:` configured, those Skills' full contents are also injected into that forked subagent's context at startup—they don't get "replaced" by the forked Skill; they sit alongside it.

**Key Implementation Details**:
- **System Prompt Source**: The chosen agent type (Explore, Plan, Bash, general-purpose, or custom agent)
- **Task Instruction Source**: The Skill's SKILL.md content
- **Skills Composition**: Custom subagent skills are additive, not replaced by the forked Skill

**When NOT to use context: fork:**
- Simple, direct tasks
- User interaction is beneficial
- Low output volume

---

## Core Principles

### The Delta Standard

> **Good Customization = Expert-only Knowledge − What Claude Already Knows**

Only provide context Claude cannot infer. Focus on expert decisions, trade-offs, and domain-specific thinking frameworks.

### Minimal Pack Philosophy

> **A complete customization pack can be just CLAUDE.md + one Skill.**

Subagents are **optional enhancements**. Add them only when proven necessary (isolation/parallelism).

## Skill Types & When to Use Win Conditions

### Three Skill Types

| Type | Called By | Purpose | Win Conditions Needed? |
|------|-----------|---------|----------------------|
| **Regular Skills** | User | Domain expertise, workflows | ❌ No |
| **Knowledge Skills** | User/Architect | Implementation guidance | ❌ No |
| **Transitive Skills** | Other Skills | Workflow steps | ✅ **YES** |

### Win Conditions: Only for Transitive Skills

**Definition**: A win condition is a **specific completion marker** that prevents workflow bugs when skills call other skills.

**When Required**:
- ✅ Transitive skills (called by other skills)
- ✅ Multi-step workflows
- ✅ Skills that delegate TO other skills

**When NOT Required**:
- ❌ Regular user-invocable skills
- ❌ Knowledge/reference skills
- ❌ Standalone skills

**Example Win Condition**:
```markdown
# Transitive Skill called by other skills
---
name: validate-skill-structure
description: "Validates skill YAML structure"
---

# WIN CONDITION: Must output completion marker
## VALIDATION_COMPLETE

Validation Results:
- Skills valid: 12/12
- Errors: 0
- Warnings: 2

# Hub skill waits for "## VALIDATION_COMPLETE" marker
```

### Forked Skills: Use Sparingly

**WARNING**: Forked skills **lose global context**. This has **huge side effects**.

**When Context Loss is Acceptable**:
- Isolated analysis work (no context needed)
- Noisy operations (want isolation)
- Clear, self-contained tasks

**When Context Loss is DANGEROUS**:
- Need conversation history
- Need user preferences
- Need project-specific decisions
- Need previous workflow steps

**Rule of Thumb**: If you need context from the main conversation, **DON'T FORK**.

**Example Dangerous Fork**:
```yaml
# ❌ BAD - Needs user preferences from main context
---
name: make-decision
description: "Makes decisions based on user preferences"
context: fork  # ❌ LOSES USER PREFERENCES
agent: general-purpose
---

# This will fail - no access to user's preferences!
```

**Example Safe Fork**:
```yaml
# ✅ GOOD - Isolated analysis, no context needed
---
name: analyze-logs
description: "Analyzes log files for patterns"
context: fork
agent: Explore
---

# WIN CONDITION:
## LOG_ANALYSIS_COMPLETE

{"patterns": [...], "anomalies": [...]}
```

### When Skills Call Other Skills

**Pattern**:
```yaml
# Caller Skill
---
name: caller-skill
description: "Orchestrates multi-step workflow"
---

# Step 1: Call transitive skill
Call: validate-skill-structure
Wait for: "## VALIDATION_COMPLETE"
Extract: Score, errors, warnings

# Step 2: Call another transitive skill
Call: analyze-quality
Wait for: "## QUALITY_ANALYSIS_COMPLETE"
Extract: Quality metrics

# Step 3: Make decision based on both results
If errors > 0:
  Report failure
Else:
  Report success
```

**Why Win Conditions Matter**:
- Prevents race conditions
- Ensures proper sequencing
- Clear completion detection
- Easier debugging

### Progressive Disclosure

**Tier 1**: Metadata (~100 tokens) — Always loaded
**Tier 2**: SKILL.md (<35,000 characters) — Loaded when invoked
**Tier 3**: Resources — Loaded on-demand

**Rule**: Keep core knowledge inline; disperse only when >35,000 characters or highly situational (<5% of tasks).

---

## The Five Layers

| Layer               | Purpose                | Priority           | Use For                              |
| ------------------- | ---------------------- | ------------------ | ------------------------------------ |
| **CLAUDE.md Rules** | Persistent norms       | **Foundation**     | Project standards, safety boundaries |
| **Skills**          | Discoverable expertise | **PRIMARY**        | Domain procedures, complex workflows |
| **Subagents**       | Isolation/parallelism  | **RARE**           | Noisy tasks, separate context        |
| **Hooks**           | Event automation       | **INFRASTRUCTURE** | MCP/LSP config, event handling      |
| **MCP**             | Service integration    | **EXTERNAL**       | External APIs, tools, services       |

---

## Core Values Framework

Each value represents a **design approach**, not a rigid category.

| Value            | Design Focus                               | When to Apply                               |
| ---------------- | ------------------------------------------ | ------------------------------------------- |
| **Reliability**  | Deterministic execution with validation    | "I need this done the same way, every time" |
| **Wisdom**       | Decision frameworks and trade-off analysis | "I need expert judgment"                    |
| **Consistency**  | Templates and standardized patterns        | "Everything must look the same"             |
| **Coordination** | Routing logic and state management         | "Many parts, one symphony"                  |
| **Simplicity**   | Direct path with minimal overhead          | "Keep it simple" (3 steps or fewer)         |

---

## Autonomy-First Design

Skills should be **self-sufficient by default** (80-95% autonomous):

### Autonomy Policy

1. **Classify**: Task type + criticality + variability → define budget
2. **Explore First**: Use read/grep before asking questions
3. **Execute Deterministically**: Complete workflow if path clear
4. **Question Burst** (rare): Only if info not inferrable + high impact + 3-7 questions unlock all
5. **Escalate**: Recommend command (explicit control) or fork (noise isolation)

### Question Burst Criteria (ALL 3 required)

✓ Information NOT inferrable from repo/tools
✓ High impact if wrong choice
✓ Small set (3-7 max) unlocks everything

---

## Orchestration Patterns

### Quick Reference

| Pattern | Use When | Complexity |
|---------|----------|------------|
| **Linear** | Simple, deterministic workflows | Low |
| **Hub-and-Spoke** | Complex workflows with decisions | Medium |
| **Worker** | High-volume output, noisy tasks | Medium |
| **Context: Fork** | Isolation needed, no context dependency | Variable |

**For detailed patterns and examples**: [orchestration-patterns.md](references/orchestration-patterns.md)
- Linear skill chaining
- Hub-and-Spoke architecture
- Worker orchestration
- Decision trees
- Prompt budget playbook
- Common use cases
- Anti-patterns to avoid

---

## Workflow Selection

### What do you need?

**"Choose the right layer"** → [layer-selection.md](references/layer-selection.md)
- Layer decision tree with context: fork guidance
- Comparison matrix
- When to use each layer

**"Create skill from scratch"** → **Load: skills-knowledge**
- Step-by-step building workflow
- Golden path extraction method
- Autonomy design patterns

**"Evaluate skill quality"** → **Load: skills-knowledge#evaluating-skill-quality**
- 12-dimensional evaluation framework
- Common failure patterns
- Quality scoring (160 points)

**"Learn core principles"** → [common.md](references/common.md)
- Delta Standard
- Core Values Framework
- Anti-patterns

**"Advanced patterns"** → [orchestration-patterns.md](references/orchestration-patterns.md)
- Orchestration patterns
- Prompt budget optimization
- Use cases and anti-patterns

---

## Reference Files

| Reference                                                   | When to Load               | Purpose                                            |
| ----------------------------------------------------------- | -------------------------- | -------------------------------------------------- |
| **[layer-selection.md](references/layer-selection.md)**     | **First**: Before building | Choose between layers + context: fork guidance     |
| **[skills-knowledge](skills-knowledge)**                    | Creating/evaluating        | Skill building + extraction + evaluation workflows |
| **[common.md](references/common.md)**                       | Foundational               | Core principles, archetypes, shared patterns       |
| **[orchestration-patterns.md](references/orchestration-patterns.md)** | When to Use Which | Detailed orchestration patterns and use cases |

**Progressive Disclosure**: Only load what you need, when you need it.

## Historical References

- **Command Patterns (Legacy)** - *Note: This guide is historical. Commands were unified with skills in 2026.*
  - *Archived in .attic/legacy-files/*

---

## When in Doubt

> **Start with layer selection** → [references/layer-selection.md](references/layer-selection.md)

1. **Choosing a layer?** → layer-selection.md
2. **Building skills?** → layer-selection.md → skills-knowledge → common.md
3. **Evaluating quality?** → skills-knowledge#evaluating-skill-quality
4. **Learning fundamentals?** → common.md

**Remember**: Most customization needs are met by CLAUDE.md + one Skill.
