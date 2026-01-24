# Layer Selection Guide

**Philosophy Before Process**: Understanding WHY before HOW enables intelligent adaptation.

This guide teaches architectural patterns for choosing the right customization layer in Claude Code.

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
├─ "Multi-step workflow with persistence"
│  └─→ TaskList + forked workers
│
├─ "Long-running project"
│  └─→ TaskList + skills architecture
│
├─ "Complex multi-session project"
│  └─→ TaskList (Layer 0) + task-domain
│     ├─ Context window spanning
│     ├─ Real-time collaboration
│     └─ Distributed subagent coordination
│
├─ "Multi-session task"
│  └─→ TaskList + subagents
│
└─ "Isolation/parallelism"
   └─→ Subagent (RARE/ADVANCED)
```

**Context: Fork Triggers:**
- High-volume output (extensive grep, repo traversal)
- Noisy exploration that clutters conversation
- Log analysis, full codebase audits
- Tasks benefiting from separate context window

**When NOT to use context: fork:**
- Simple, direct tasks
- User interaction is beneficial
- Low output volume

## Core Principles

### The Delta Standard

> **Good Customization = Expert-only Knowledge − What Claude Already Knows**

Only provide context Claude cannot infer. Focus on expert decisions, trade-offs, and domain-specific thinking frameworks.

### Minimal Pack Philosophy

> **A complete customization pack can be just CLAUDE.md + one Skill.**

Subagents are **optional enhancements**. Add them only when proven necessary (isolation/parallelism).

## The Five Layers

| Layer               | Purpose                | Priority           | Use For                              |
| ------------------- | ---------------------- | ------------------ | ------------------------------------ |
| **TaskList**        | Workflow state engine   | **Infrastructure** | Complex projects, context spanning, multi-session |
| **CLAUDE.md Rules** | Persistent norms       | **Foundation**     | Project standards, safety boundaries |
| **Skills**          | Discoverable expertise | **PRIMARY**        | Domain procedures, complex workflows |
| **Subagents**       | Isolation/parallelism  | **RARE**           | Noisy tasks, separate context        |
| **Hooks**           | Event automation       | **INSTRUCTURE**   | MCP/LSP config, event handling      |
| **MCP**             | Service integration    | **EXTERNAL**       | External APIs, tools, services       |

## Layer 0 Architecture

TaskList is a **workflow state engine** that sits below built-in tools:

```
┌─────────────────────────────────────────────────────────────┐
│     LAYER 0: Workflow State Engine (TaskList)               │
├─────────────────────────────────────────────────────────────┤
│  Persistent workflow state, dependency tracking,              │
│  multi-agent coordination, cross-session workflows          │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│     LAYER 1: Built-In Claude Code Tools                     │
├─────────────────────────────────────────────────────────────┤
│  Execution:  Write | Edit | Read | Bash | Grep | Glob      │
│  Orchestration: TaskList | TaskCreate | TaskUpdate         │
│  Invokers:     Skill tool | Task tool                      │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│     LAYER 2: User-Defined Content                          │
├─────────────────────────────────────────────────────────────┤
│  .claude/skills/*/SKILL.md   ← Loaded by Skill tool        │
│  .claude/agents/*.md          ← Launched by Task tool      │
└─────────────────────────────────────────────────────────────┘
```

**TaskList is Layer 0**: Below built-in tools. Orchestrates everything including skills and subagents.

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

## Context: Fork - Use Sparingly

**WARNING**: Forked skills **lose global context**. This has **huge side effects**.

### When Context Loss is Acceptable
- Isolated analysis work (no context needed)
- Noisy operations (want isolation)
- Clear, self-contained tasks

### When Context Loss is DANGEROUS
- Need conversation history
- Need user preferences
- Need project-specific decisions
- Need previous workflow steps

**Rule of Thumb**: If you need context from the main conversation, **DON'T FORK**.

### Context: Fork Mechanism

In a context: fork Skill run:
- **System Prompt Source**: The chosen agent (Explore, Plan, Bash, general-purpose, or custom)
- **Task Direction**: The Skill's SKILL.md content
- **Skills Composition**: Custom subagent skills inject at startup (additive, not replacement)

## Core Values Framework

Each value represents a **design approach**, not a rigid category.

| Value            | Design Focus                               | When to Apply                               |
| ---------------- | ------------------------------------------ | ------------------------------------------- |
| **Reliability**  | Deterministic execution with validation    | "I need this done the same way, every time" |
| **Wisdom**       | Decision frameworks and trade-off analysis | "I need expert judgment"                    |
| **Consistency**  | Templates and standardized patterns      | "Everything must look the same"             |
| **Coordination** | Routing logic and state management         | "Many parts, one symphony"                 |
| **Simplicity**   | Direct path with minimal overhead          | "Keep it simple" (3 steps or fewer)         |

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

## Orchestration Patterns

### Quick Reference

| Pattern | Use When | Complexity |
|---------|----------|------------|
| **Linear** | Simple, deterministic workflows | Low |
| **Hub-and-Spoke** | Complex workflows with decisions | Medium |
| **Worker** | High-volume output, noisy tasks | Medium |
| **Context: Fork** | Isolation needed, no context dependency | Variable |

## Progressive Disclosure

**Tier 1**: Metadata (~100 tokens) — Always loaded
**Tier 2**: SKILL.md (<35,000 characters) — Loaded when invoked
**Tier 3**: Resources — Loaded on-demand

**Rule**: Keep core knowledge inline; disperse only when >35,000 characters or highly situational (<5% of tasks).

## When in Doubt

> **Start with layer selection**

1. **Choosing a layer?** → This guide
2. **Building skills?** → This guide → skills-domain
3. **Evaluating quality?** → skills-domain
4. **Learning fundamentals?** → This guide

**Remember**: Most customization needs are met by CLAUDE.md + one Skill.
