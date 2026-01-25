# CLAUDE.md

**IMPORTANT: This file has TWO purposes - see sections below.**

## Purpose 1: Project Operational Rules (FOR AI AGENTS)

This section contains rules for AI agents working on THIS specific project. When you work on this project, these are your operational constraints.

**Examples:**
- Project-specific conventions
- Local environment quirks
- Business logic constraints
- Non-obvious workarounds discovered through experience

## Purpose 2: Meta-Skill Teaching, global behavior and philosophy (FOR CREATION OF META SKILLS)

This section teaches HOW to create effective meta-skills for ANY project. It's educational content for building the skill ecosystem.

**Why this distinction matters:**
- AI agents using your skills will NOT have access to CLAUDE.md
- Skills must be SELF-SUFFICIENT - they must contain everything needed to function
- Referencing CLAUDE.md from a skill breaks portability

---

Project scaffolding toolkit for Claude Code focused on .claude/ configuration with skills-first architecture and progressive disclosure.

---

# SECTION 1: PROJECT OPERATIONAL RULES

**When working on THIS project, apply these rules:**

## Local Project Conventions

This project uses **Knowledge-Factory architecture (v4)** - clean separation of knowledge and execution.

**Knowledge Skills** (passive reference): knowledge-skills, knowledge-mcp, knowledge-hooks, knowledge-subagents

**Factory Skills** (script-based execution): create-skill, create-mcp-server, create-hook, create-subagent

**Meta-Critic**: Quality validation and alignment checking

**Usage pattern**: Load knowledge skills to understand concepts, then use factory skills to execute operations.

**test-manager** is the reference pattern for script-based skills.

## Working Patterns

- **Test commands**: Use `claude --dangerously-skip-permissions` with stream-json output
- **Context fork**: Use for isolation, parallel processing, or untrusted code
- **Completion markers**: Skills should output `## SKILL_NAME_COMPLETE`
- **Quality standard**: All skills should achieve 80-95% autonomy (0-5 questions per session)

---

# SECTION 2: META-SKILL TEACHING (SINGLE SOURCE OF TRUTH)

**Educational content for creating effective meta-skills. This is the canonical source for all philosophical, architectural, and best practice guidance.**

---

## Core Philosophy

### Context Window as Public Good

Think of it like a shared refrigerator - everything you put in takes space others could use. Be a good roommate.

The context window is a shared resource. Everything loaded competes for space: system prompt, conversation history, skill metadata, other skills, and the actual user request.

**Principle**: Challenge every piece of information. "Does Claude really need this?" and "Does this justify its token cost?"

**Application**:
- Prefer concise examples over verbose explanations
- Remove Claude-obvious content (what training already covers)
- Keep descriptions under 100 words (Tier 1 metadata)
- Keep SKILL.md under 500 lines (Tier 2)
- Move detailed content to references/ (Tier 3, on-demand)

**Recognition**: If you're explaining something Claude already knows from training, delete it.

### Degrees of Freedom Framework

Match specificity to task fragility. Think of Claude as exploring a path: a narrow bridge with cliffs needs specific guardrails (low freedom), while an open field allows many routes (high freedom).

**High Freedom (Text-based Instructions)**: Use when multiple approaches are valid, decisions depend on context. Provide principles and patterns, not prescriptions.

**Medium Freedom (Pseudocode or Scripts)**: Use when a preferred pattern exists, some variation is acceptable. Suggested structure with flexibility.

**Low Freedom (Specific Scripts)**: Use when operations are fragile and error-prone, consistency is critical. Exact steps to follow.

**Recognition**: If the operation breaks easily or has high failure risk, reduce freedom.

### Trust AI Intelligence

**Default assumption**: Claude is already very smart. Only add context Claude doesn't already have.

Think of it this way: You're talking to a senior engineer who joined your team. You don't need to explain how to write code, use Git, or read files. You only need to explain what makes YOUR project unique.

**What this means**:
- Don't explain basic programming concepts
- Don't prescribe every step of obvious workflows
- Don't provide exhaustive examples for simple patterns
- DO provide expert-only knowledge
- DO document project-specific decisions
- DO explain non-obvious trade-offs

**Recognition**: If you're writing "how to use Python" or "what YAML is," delete it.

### The Delta Standard

> **Good Customization = Expert-only Knowledge − What Claude Already Knows**

Only provide information that has a "knowledge delta" - the gap between what Claude knows from training and what it needs to know for this specific project.

**Positive Delta** (keep these):
- Project-specific architecture decisions
- Domain expertise not in general training
- Business logic and constraints
- Non-obvious bug workarounds

**Zero/Negative Delta** (remove these):
- General programming concepts
- Standard library documentation
- Common patterns Claude already knows
- Generic tutorials

**Recognition**: For each piece of content, ask "Would Claude know this without me being told?" If yes, delete it.

### Progressive Disclosure Philosophy

Information architecture as cognitive load management. Reveal complexity progressively, not all at once.

**Three Levels**:

**Tier 1: Metadata** (~100 tokens, always loaded)
- Frontmatter: `name`, `description`, `user-invocable`
- Purpose: Trigger discovery, convey WHAT/WHEN/NOT

**Tier 2: SKILL.md** (<500 lines, loaded on activation)
- Core implementation with workflows and examples
- Purpose: Enable task completion

**Tier 3: References/** (on-demand, loaded when needed)
- Deep details, troubleshooting, comprehensive guides
- Purpose: Specific use cases without cluttering Tier 2

**Recognition**: If SKILL.md is bloated with domain-specific or situational content, split it into references/.

---

## Technical Specifications for Building Skills

When creating skills, commands, or hooks, load **knowledge-skills** for technical specifications:

- **knowledge-skills**: Agent Skills standard, description guidelines (What-When-Not), quality assessment
- **knowledge-mcp**: Model Context Protocol integration patterns
- **knowledge-hooks**: Event types, security patterns, configuration
- **knowledge-subagents**: Agent types, configuration, coordination

**These contain the technical "what" - the specifications, formats, and standards needed for implementation.**

---

TaskList is a workflow state engine for complex projects that exceed autonomous state tracking.

**Think of it this way**: Claude can handle simple tasks autonomously. TaskList exists for the complex projects that need persistent state tracking across sessions.

### When to Use TaskList

**Use TaskList when**:
- Work spans multiple sessions (set `CLAUDE_CODE_TASK_LIST_ID`)
- Complex workflows with 5+ steps requiring dependency tracking
- Visual progress tracking needed (Ctrl+T)
- Work exceeds context window limits

**Don't use TaskList for**:
- Simple 2-3 step workflows (use skills directly)
- Session-bound work without dependencies
- One-shot operations

**Threshold question**: "Would this exceed Claude's autonomous state tracking?"

### Multi-Session Work

TaskList enables work to continue across sessions:
1. Conversation approaches context limit
2. Note `CLAUDE_CODE_TASK_LIST_ID` for the project
3. Start new session with same task list ID
4. Work continues where previous session left off

Multiple sessions can collaborate on the same task list simultaneously.

### Natural Language for Workflows

When documenting workflows that use TaskList, use natural language to describe dependencies:

**✅ DO**:
- "First scan the structure, then validate components in parallel"
- "Optimization must wait for validation to complete"
- "Generate report only after all validation phases finish"

**❌ DON'T**: Provide code examples for tool invocation
- No `TaskCreate(subject="...")` examples
- No `addBlockedBy=["..."]` syntax demonstrations

Trust Claude's intelligence to use built-in tools correctly.

---

## Autonomy Standard

Skills should achieve 80-95% autonomy to pass quality gates.

**Autonomy levels**:
- **95% (Excellent)**: 0-1 questions
- **85% (Good)**: 2-3 questions
- **80% (Acceptable)**: 4-5 questions
- **<80% (Fail)**: 6+ questions

**What counts as a question**:
- "Which file should I modify?"
- "What should I name this variable?"
- "How should I handle this case?"

**Not counted as questions**:
- Reading files for context
- Running bash commands as part of workflow
- Using grep/glob to discover information

**Recognition**: A skill that constantly asks for clarification lacks concrete patterns and examples.

---

## INCREMENTAL-UPDATE Pattern

When there is prior conversation in a session, the default behavior should be INCREMENTAL-UPDATE.

- Prior conversation = knowledge has been generated = capture it
- No explicit request needed — prior conversation IS the trigger
- Review conversation for: working commands, discovered patterns, errors encountered, new rules learned
- Update CLAUDE.md based on discoveries

**Recognition question**: "Is there prior conversation with discoverable knowledge?"
- Yes → INCREMENTAL-UPDATE (capture knowledge)
- No → Use appropriate mode based on explicit request

---

## Skills Must Be Self-Sufficient

**CRITICAL**: Skills MUST NOT reference CLAUDE.md or any external files outside their own directory.

### Why This Matters

- AI agents using your skills will NOT have access to CLAUDE.md
- AI agents will NOT have the same folder structure as this project
- Skills must be SELF-CONTAINED to work in any context

### What This Means

**✅ Allowed**:
- Include all necessary patterns IN the skill's SKILL.md or references/
- Skills can cite other skills or built-in tools
- Skills can reference their OWN references/ files

**❌ Forbidden**:
- Skills MUST NOT reference CLAUDE.md
- Skills MUST NOT reference .claude/rules/
- Skills MUST NOT reference external project files

### The Teaching Pattern

**Think of it this way**: CLAUDE.md teaches YOU how to build skills. The skills you build must then stand on their own, without needing CLAUDE.md.

### Portability Test

Can you copy the skill to a new project?
- YES → It's portable ✅
- NO → It's broken ❌
- WHY? → References project files

---

## Documentation Anti-Pollution Rule

**CRITICAL**: CLAUDE.md must contain ONLY lasting project knowledge.

### NEVER Create

- Update logs, changelogs, or date-stamped sections
- Temporary files like "CLAUDE_MD_UPDATE.md"
- "Update on [date]" or version tracking entries

### Principle

Each addition should be as permanent as architecture decisions.

**Why**: CLAUDE.md is project memory, not a changelog. Temporary pollution reduces signal-to-noise ratio.

---

## Decision Guide

**What do you need?**

- **Persistent project norms** → Project rules (this file, Section 1)
- **Domain expertise to discover** → Knowledge Skills (knowledge-skills, knowledge-mcp, etc.)
- **Create new component** → Factory Skills (create-skill, create-mcp-server, create-hook, create-subagent)
- **Event automation** → create-hook factory
- **Service integration** → create-mcp-server factory
- **Multi-step workflow with persistence** → TaskList
- **Long-running project** → TaskList + skills architecture
- **Isolation/parallelism** → Subagent (RARE/ADVANCED)

**Context fork triggers**:
- High-volume output (extensive grep, repo traversal)
- Noisy exploration that clutters conversation
- Tasks needing separate context window

**Don't fork when**:
- Need conversation history
- Need user preferences
- Simple sequential tasks

---

## Agent and Model Selection

**Agent types**:
- **general-purpose**: Default, balanced performance
- **bash**: Command execution specialist work
- **Explore**: Fast exploration, no nested workflows
- **Plan**: Complex reasoning, architecture design

**Model selection** (consider cost):
- **haiku**: 1x cost - use for quick validation
- **sonnet**: 3x cost - default for most work
- **opus**: 10x cost - only for complex reasoning
