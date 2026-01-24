# CLAUDE.md

**Meta-guide: How to teach Claude to work effectively with your project's .claude/ configuration**

This document teaches the core principles for designing skills, workflows, and automation. For specific implementation details, see individual skills referenced throughout.

---

# FOR DIRECT USE

## Critical Principles

⚠️ **Skills-First Architecture**: Every capability should be a Skill first. Commands and Subagents are orchestrators, not creators.

⚠️ **Hub-and-Spoke Pattern**: Hub Skills (with `disable-model-invocation: true`) delegate to knowledge skills. For aggregation, ALL workers MUST use `context: fork`. Regular→Regular skill handoffs are one-way only.

⚠️ **Progressive Disclosure**: Tier 1: Metadata (~100 tokens, always loaded), Tier 2: SKILL.md (<500 lines, loaded on activation), Tier 3: references/ (on-demand, zero context cost).

⚠️ **Multi-Dimensional Delta**: Good customization = expert knowledge + working commands + behavioral guidance + reliability patterns. Not just "what Claude doesn't know."

⚠️ **Degrees of Freedom**: High freedom (text) when multiple approaches valid. Medium freedom (pseudocode/params) when preferred pattern exists. Low freedom (specific scripts) when fragile/consistent.

---

# How to Teach: Core Frameworks

## 1. Teaching Architecture

### Skills-First Principle

Every capability starts as a Skill. Commands and Subagents exist to orchestrate Skills, not create them.

**Why**: Skills are loaded on-demand and provide domain expertise. Commands require explicit invocation. Subagents run in isolated contexts.

**See**: `.claude/skills/skills-architect/SKILL.md` for skill creation workflows.

### Component Selection Heuristics

| Use this | When you want... | Trade-off |
|---------|-----------------|----------|
| **Skills** | Specialized knowledge, autonomous operation | Claude chooses when relevant |
| **Slash commands** | Reusable workflows with explicit invocation | User must type `/command` |
| **Subagents** | Isolated execution, different tool access | Separate context, no skill inheritance |
| **Hooks** | Automation on events (file save, tool use) | Fires automatically on events |
| **MCP** | External tools and data sources | Claude calls tools as needed |

**See**: `.claude/skills/toolkit-architect/SKILL.md` for component routing logic.

### Progressive Disclosure Structure

```
skill-name/
├── SKILL.md (<500 lines - Tier 2)
│   ├── YAML frontmatter (name, description - Tier 1)
│   └── Essential workflows only
└── references/ (on-demand - Tier 3)
    ├── domain-specific patterns
    ├── detailed examples
    └── troubleshooting
```

**Key principle**: Keep references one level deep from SKILL.md. Structure files >100 lines with table of contents.

---

# 2. Teaching Skill Authoring

## Multi-Dimensional Delta

What makes content valuable isn't just "what Claude doesn't know" — it's multi-dimensional:

**Behavioral Delta**: Explicit guidance that shapes behavior vs. relying on inference
- Example: "Concise is Key" - even though Claude knows conciseness, stating it sets expectations

**Multi-Dimensional Delta**: Project-specific commands, patterns, and constraints
- Example: `scripts/init_skill.py <name> --path <output>` (not "create a skill directory")

**Reliability Delta**: Patterns that improve consistency and outcomes
- Example: Sequential workflows with validation gates

**Refined Delta**: Framework enhancements that balance official patterns
- Example: What-When-Not descriptions for discoverability

## Description Framework: What-When-Not

**Components**:
- **WHAT**: What the skill does (core function)
- **WHEN**: When to use it (triggers, contexts)
- **NOT**: What it doesn't do (boundaries)

**Good example**:
```yaml
description: "Build self-sufficient skills following Agent Skills standard. Use when creating, evaluating, or enhancing skills with progressive disclosure. Not for general programming tasks."
```

**Balanced approach**: Include what/when/not, plus minimal behavioral context. Official skills sometimes include "how" language for helpful guidance.

## Degrees of Freedom

| Freedom | When to Use | Example |
|---------|-------------|---------|
| **High** (text) | Multiple valid approaches, context-dependent | Code reviews |
| **Medium** (pseudocode + params) | Preferred pattern exists, some variation acceptable | Report generation with templates |
| **Low** (specific scripts) | Fragile, error-prone, consistency critical | Database migrations |

**Analogy**: Narrow bridge with cliffs (low freedom) vs. Open field (high freedom).

---

# 3. Teaching Workflow Design

## Sequential Workflows

```markdown
Task involves these steps:
1. Analyze the form (run analyze_form.py)
2. Create field mapping (edit fields.json)
3. Validate mapping (run validate_fields.py)
4. Fill the form (run fill_form.py)
5. Verify output (run verify_output.py)
```

**Why**: Clear steps prevent skipping critical validation.

## Conditional Workflows

```markdown
1. Determine task type:
   **New content?** → Follow Creation workflow
   **Existing content?** → Follow Editing workflow
```

**Why**: Explicit branching prevents mode confusion.

## Hub-and-Spoke Aggregation

**Hub Skill** (regular, disable-model-invocation: true):
- Delegates to Worker A (context: fork)
- Delegates to Worker B (context: fork)
- Delegates to Worker C (context: fork)
- Aggregates all results

**Critical**: ALL workers MUST use `context: fork` for hub to aggregate results.

**See**: `.claude/skills/subagents-architect/SKILL.md` for subagent coordination patterns.

---

# 4. Teaching Implementation Patterns

## Script Reliability

**Error handling**:
```bash
try:
    with open(path) as f:
        return f.read()
except FileNotFoundError:
    print(f"File {path} not found, creating default")
    return ''
```

**Documented constants**:
```bash
# Three retries balance reliability vs speed
MAX_RETRIES=3
```

**Unix-style paths**:
```bash
./.claude/scripts/validate.sh
```

**See**: `.claude/skills/skills-knowledge/references/script-best-practices.md` for complete patterns.

## URL Validation (for knowledge skills)

```markdown
- **MUST READ**: [Official Skills Guide](https://code.claude.com/docs/en/skills)
  - Tool: `mcp__simplewebfetch__simpleWebFetch`
  - Cache: 15 minutes minimum
```

**Implementation**: Validate all external URLs before skill creation.

---

# 5. Common Mistakes to Avoid

## Over-Engineering Anti-Pattern

**Problem**: Creating "logic files" (e.g., `mode-detection.md`) for behaviors Claude inherently understands.

**Solution**: Define "Commander's Intent" in SKILL.md, let Claude handle execution details. Keep reference files as "Data Libraries" or "Inspiration Patterns."

## Content Duplication Anti-Pattern

**Problem**: Same information in both SKILL.md and references/.

**Solution**: Information lives in SKILL.md **OR** references/, not both. Keep procedural instructions in SKILL.md, detailed reference material in references/.

## Pure Anti-Patterns (from official skill-creator)

**Do NOT create these files** in skills:
- README.md
- INSTALLATION_GUIDE.md
- QUICK_REFERENCE.md
- CHANGELOG.md

**Rationale**: Skills should only contain information needed for an AI agent to do the job. Auxiliary documentation adds clutter.

---

# Component-Specific Guidance

## For Skill Creation

**See**: `.claude/skills/skills-architect/SKILL.md`
- Multi-dimensional delta concept
- Progressive disclosure patterns
- What-When-Not description framework
- Quality validation

## For Subagent Configuration

**See**: `.claude/skills/subagents-architect/SKILL.md`
- Context detection patterns
- Coordination patterns
- Configuration guide

## For Hook Setup

**See**: `.claude/skills/hooks-architect/SKILL.md`
- Event types (PreToolUse, PostToolUse, Stop)
- Compliance framework
- Implementation patterns

## For MCP Integration

**See**: `.claude/skills/mcp-architect/SKILL.md`
- Protocol guide
- Transport mechanisms
- Tool templates

## For TaskList Workflows

**See**: `.claude/skills/task-architect/SKILL.md`
- Context spanning patterns
- Multi-session collaboration
- Dependency tracking

**When to use TaskList**:
- Work spanning multiple sessions
- 5+ step workflows with dependencies
- Visual progress tracking needed
- Work exceeding context window

**Threshold**: "Would this exceed Claude's autonomous state tracking?"

---

# Recognition Patterns

## Trust AI Intelligence

Provide concepts, AI makes intelligent implementation decisions. Focus on principles, not prescriptive patterns.

## Local Project Autonomy

Always start with local project configuration. Project directory as default location. Team collaboration through git.

## Autonomous Execution

Skills should work 80-95% without questions. Provide context and examples, trust AI decisions.

## "Unhobbling" Principle

TodoWrite was removed because newer models handle simple tasks autonomously. TaskList exists for complex projects exceeding autonomous state tracking.

---

# INCREMENTAL-UPDATE for Prior Conversation

**RECOGNIZE**: When there is ANY prior conversation in a session, the default behavior should be INCREMENTAL-UPDATE.

- Prior conversation = knowledge has been generated = capture it
- No explicit request needed — prior conversation IS the trigger
- Review conversation for: working commands, discovered patterns, errors encountered, new rules learned
- Update CLAUDE.md and relevant skills based on discoveries

---

# See Also

- **Skill creation**: `.claude/skills/skills-architect/SKILL.md`
- **Subagents**: `.claude/skills/subagents-architect/SKILL.md`
- **Hooks**: `.claude/skills/hooks-architect/SKILL.md`
- **MCP**: `.claude/skills/mcp-architect/SKILL.md`
- **TaskList**: `.claude/skills/task-architect/SKILL.md`
