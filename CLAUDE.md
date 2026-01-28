# CLAUDE.md: The Seed System

Meta-toolkit for Claude Code focused on .claude/ configuration with dual-role architecture: **health maintenance** + **portable component factory**.

---

## Core Philosophy

This project is a **meta-meta system**—a toolkit for building toolkits. It serves **two distinct roles**:

### Role 1: Health Maintenance (Current Session)

The Seed System governs its own internal health:

- Maintains consistency across rules, skills, and documentation
- Ensures high autonomy (80-95% target: 0-5 questions per session)
- Enforces quality standards and progressive disclosure
- Validates component structure and portability

### Role 2: Portable Component Factory (Building Offspring)

The Seed System builds portable, self-sufficient components:

- Generates Skills/Commands/Agents/Hooks/MCPs that bundle their own philosophy
- Ensures components work in isolation (zero .claude/rules dependency)
- Embeds Success Criteria for self-validation
- Creates components with intentional redundancy (condensed philosophy included)

**Key Innovation**: Components carry their own "genetic code"—they don't depend on the Seed System to function.

---

## Dual-Layer Architecture

The Seed System uses a **two-layer architecture** to achieve both roles:

### Layer A: Behavioral Rules (Session-Only)

**Purpose**: Guide agent behavior in the current session
**Scope**: Session-only, not embedded in components
**Audience**: The agent operating NOW

### Layer B: Construction Standards (For Building Components)

**Purpose**: Meta-rules for creating portable components
**Scope**: Embedded in generated components as "genetic code"
**Audience**: The component's own intelligence

**Key Insight**: The agent's "soul" (Layer A) teaches it to embed its "brain" (Layer B) into every component it builds.

---

## The Portability Invariant

<critical_constraint>
MANDATORY: Every component MUST be self-contained and work in a project with ZERO .claude/rules.
</critical_constraint>

This is the **defining characteristic** of the Seed System. Unlike traditional toolkits that create project-dependent components, the Seed System creates portable "organisms" that survive being moved to any environment.

---

## The Delta Standard

> **Good Component = Expert-only Knowledge − What Claude Already Knows**

See `.claude/rules/principles.md` for complete Delta Standard explanation with positive/negative delta examples.

---

## Knowledge-Factory Architecture

This project demonstrates the **Knowledge-Factory architecture**:

### Knowledge Layer (Understanding)

- **Unified Knowledge Skill**: `invocable-development` - Commands and skills are the same system with different organization
- **Other Knowledge Skills**: hook-development, agent-development, mcp-development
- Provides concepts, patterns, and philosophy
- Teaches the "why" behind component creation

### Factory Layer (Execution)

- **Toolkit Commands**: Intent-based orchestration with context inference
  - `/toolkit:build:*` - Create commands, skills, packages
  - `/toolkit:audit:*` - Validate commands, skills
  - `/toolkit:critique:*` - Meta-critic review for commands, skills
- Apply architectural patterns via `invocable-development` skill
- Bundle condensed philosophy into outputs

### Quality Layer (Validation)

- **Meta-Critic**: Three-way quality validation (Request vs Delivery vs Standards)
- Success Criteria Invariant for self-validation
- **Component Orchestrate**: TDD-based component validation with staged deployment

**Usage pattern**: Use toolkit commands for workflow orchestration, which invoke `invocable-development` for domain logic.

### Semantic Anchoring Pattern

**Pattern**: Replace bash code blocks with tool invocation anchors to force correct tool usage.

**Format**: `- \`Tool: command\` → description`

**Example**:

````markdown
# Before:

```bash
npx knip
```
````

# After:

- `Bash: npx knip` → Run knip for unused exports/files/dependencies

```

**Applied to**: All commands, agents (68+ files converted)

**Why**: Forces AI to use native tools instead of treating commands as prose text.

---

## Toolkit Commands

The toolkit provides command-based interfaces for creating and validating invocable components (commands and skills).

### Invocable Components

**Commands and Skills are the same system** - same frontmatter, same invocation, same capabilities. The only difference is organizational:

| Component    | Structure                                                      | Naming                                 | Best For                                |
| ------------ | -------------------------------------------------------------- | -------------------------------------- | --------------------------------------- |
| **Commands** | Single `.md` file                                              | `commands/build/fix.md` → `/build:fix` | Intent/state definition, folder nesting |
| **Skills**   | Folder with `SKILL.md` + optional `workflows/` + `references/` | Flat: `skills/engineering-lifecycle/`  | Domain logic, progressive disclosure    |

### Build Commands

| Command                  | Purpose                                                             | Autonomy             |
| ------------------------ | ------------------------------------------------------------------- | -------------------- |
| `/toolkit:build:command` | Create one-file commands                                            | High (0-2 questions) |
| `/toolkit:build:skill`   | Create skills with workflows/ and references/                       | High (0-2 questions) |
| `/toolkit:build:package` | Create complete packages (command + skill + workflows + references) | High (0-3 questions) |

### Audit Commands

| Command          | Purpose                                                                  | Autonomy                   |
| ---------------- | ------------------------------------------------------------------------ | -------------------------- |
| `/toolkit:audit` | Universal auditor - auto-detects target and routes to correct references | High (auto-detects target) |

### Critique Commands

| Command             | Purpose                                             | Autonomy                |
| ------------------- | --------------------------------------------------- | ----------------------- |
| `/toolkit:critique` | Universal quality audit via quality-standards skill | High (analyzes context) |

**Rooter Archetype**: A complete capability package with multiple entry points:

- **Command**: Quick intent invocation
- **Workflows**: Guided step-by-step processes
- **Skill**: Comprehensive domain knowledge
- **Examples/Scripts**: Working demonstrations and automation

### Key Features

**Context Inference**: Commands auto-detect targets from conversation

- Auto-detects recently created components
- No need to specify paths manually

**No Syntax Required**: Trust AI intelligence

- Commands work with natural language descriptions
- Progressive refinement when necessary

**High Autonomy**: Target 80-95% completion (0-5 questions)

- Auto-detect when possible
- Ask only when genuinely ambiguous

### Command Orchestration Pattern (Optional)

One component can orchestrate another for workflow automation. Both are auto-invocable - this pattern is about coordination, not capability difference.

- **Orchestrator**: Coordinates workflow, manages interaction flow, handles state transitions
- **Orchestrated**: Contains detailed knowledge/patterns to execute

**Critical constraint**: Orchestrated component must not reference orchestrator (portability invariant).

See `invocable-development/references/command-orchestration.md` for complete pattern documentation.

---

## Quick Navigation

### For Health Maintenance (Current Session)

```

Need to maintain project health?
│
├─ Self-maintenance → Use /ops namespace
│ ├─ /ops:rooter - Router for all ops commands
│ ├─ /ops:extract - Extract patterns from conversation
│ ├─ /ops:drift - Detect and fix context drift
│ └─ /ops:reflect - Review session for improvements
├─ Update rules → Check .claude/rules/ for consistency
├─ Audit quality → Use quality-standards skill
├─ Fix autonomy issues → Review architecture.md (L'Entonnoir pattern)
└─ Validate structure → Check quality.md (anti-patterns)

```

### For Component Factory (Building Offspring)

```

Need to build a portable component?
│
├─ Complete package → /toolkit:build:package
├─ Create a command → /toolkit:build:command
├─ Create a skill → /toolkit:build:skill
├─ Audit component → /toolkit:audit (auto-routes by extension)
├─ Critique component → /toolkit:critique (auto-routes by extension)
├─ Create agent → agent-development
├─ Add hook → hook-development
├─ Add MCP server → mcp-development
└─ Refine prompt → refine-prompts

```

---

## Invocable Components

**Commands and Skills are the same system** with identical capabilities. The difference is structural:

| **Commands** | Single `.md` file | Folder nesting: `commands/analysis/diagnose.md` → `/analysis:diagnose` |
| **Skills** | Folder with `SKILL.md` + optional `workflows/` and `references/` | Flat: `skills/engineering-lifecycle/SKILL.md` |

**Both are auto-invocable** - AI and users can invoke either based on description and context.

### Primary Meta-Skill

**`invocable-development`** - Unified skill for creating both commands and skills. Consolidates `skill-development` and `command-development` knowledge.

### Toolkit Commands

| **Category** | **Commands**                                                             |
| ------------ | ------------------------------------------------------------------------ |
| **Build**    | `/toolkit:build:command` `/toolkit:build:skill` `/toolkit:build:package` |
| **Audit**    | `/toolkit:audit:command` `/toolkit:audit:skill`                          |
| **Critique** | `/toolkit:critique:command` `/toolkit:critique:skill`                    |

### Planning Commands

| **Command**         | \*\*Purpose                                             |
| ------------------- | ------------------------------------------------------- |
| `/plan:create`      | Fully autonomous planning (brief/roadmap/phases/chunks) |
| `/plan:execute`     | Execute single PLAN.md file                             |
| `/plan:execute-all` | Execute all incomplete PLAN.md files sequentially       |
| `/plan:handoff`     | Create context handoff                                  |
| `/plan:resume`      | Continue from handoff                                   |

**Planning system**: Single command (`/plan:create`) handles everything - auto-detects state and creates brief → roadmap → phases → chunks as needed. Domain logic in 'engineering-lifecycle' skill.

**Deprecated**: `/plan:brief`, `/plan:roadmap`, `/plan:chunk` - merged into `/plan:create` for fully autonomous planning.

---

## The Three Rule Files

The Seed System consolidates all guidance into three rule files:

| File                | Focus               | Content                                                     |
| ------------------- | ------------------- | ----------------------------------------------------------- |
| **principles.md**   | The "Soul"          | The "Why," the "Tone," and the "Degrees of Freedom"         |
| **architecture.md** | The "Skeleton"      | UHP (XML/MD), Progressive Disclosure, Interaction Protocols |
| **quality.md**      | The "Immune System" | "Smell tests," anti-hallucination, verification loops       |

---

## Component Description Guidelines

### No Direct Skill Mentions in Descriptions

**Rule**: Never mention other skills by name in component descriptions.

**Why**:

- **Discoverability anti-pattern**: Claude can discover skills through the skill system—naming others creates implicit dependencies
- **Portability violation**: A command that references `skill-development` cannot work in a project without that skill
- **Self-containment**: Descriptions should explain what the component does, not point to other components

**How to describe without naming**:

| Instead of...                                      | Use...                                             |
| -------------------------------------------------- | -------------------------------------------------- |
| "Reusable logic libraries (use skill-development)" | "Logic libraries that Claude invokes contextually" |
| "Background event handling (use hook-development)" | "Background event handling"                        |
| "Create agents (use agent-development)"            | "Autonomous agents with independent execution"     |

**What belongs in descriptions**:

- What the component does (verb + object)
- When to use it (use cases)
- What it's NOT for (by behavior, not by referencing other components)

---

## Native Tool Pattern (CRITICAL)

**Replace brittle bash scripts with native tool calls in skill instructions.**

When documenting file operations, search, or text manipulation in skills, use native tools instead of complex bash commands:

| Bash Pattern                | Replace With                    |
| --------------------------- | ------------------------------- |
| `grep -n "pattern" file`    | `Grep` tool                     |
| `head -n N \| grep`         | `Read` with offset + `Grep`     |
| `sed -n '/^---$/,/^---$/p'` | `Read` tool + parse             |
| `echo "$VAR" \| grep -q`    | `Grep` with `-q` flag           |
| `fd \| xargs rg`            | `Glob` + `Grep`                 |
| `xargs sed -i`              | `Edit` with `replace_all: true` |

**Why**: Native tools are more reliable, self-documenting, and work consistently across environments. Bash scripts with pipes are brittle and hard to maintain.

**When**: Apply this pattern when documenting search, validation, or file manipulation patterns in skills and references.

**Example**:

```

<!-- Instead of -->

grep -n "type=\"checkpoint" PLAN.md

<!-- Use -->

Grep: Search PLAN.md for pattern type="checkpoint (shows line numbers)

```

**Files updated with this pattern**:

- `engineering-lifecycle/references/execution-modes.md`
- `invocable-development/references/testing-strategies.md`
- `file-search/references/advanced-workflows.md`
- `hook-development/references/patterns.md`
- `invocable-development/references/plugin-features-reference.md`
- `quality-standards/SKILL.md`

---

## Writing Style

See `.claude/rules/principles.md` for:

- **Imperative Form** - How to write instructions
- **Clear Examples** - Show, don't just tell
- **Voice Strength** - Gentle → Standard → Strong → Critical
- **Degrees of Freedom** - High → Medium → Low specificity

---

## Progressive Disclosure

**Tier 1**: Metadata (~100 tokens)
**Tier 2**: Component body (~1,500-2,000 words)
**Tier 3**: References/ (on-demand)

Keep SKILL.md focused and lean. Move detailed content to references/.

---

## Format: Unified Hybrid Protocol (UHP)

See `.claude/rules/architecture.md` for complete UHP reference (3-layer architecture, XML/Markdown usage, state management).

---

## Session Commands

- `/handoff` - Create session handoff document
- `/plan` - Enter plan mode for complex tasks

**Self-Maintenance Commands (ops namespace):**

- `/ops:reflect` - Review conversation for improvements
- `/ops:extract` - Extract reusable patterns
- `/ops:drift` - Detect context drift

---

## Plan Mode Workflow (CRITICAL)

**MANDATORY: Get user approval before proceeding to implementation.**

For any non-trivial task requiring multiple steps or file modifications:

1. **Phase 1** - Understand requirements
2. **Phase 2** - Design approach
3. **Phase 3** - Get user approval
4. **Phase 4** - Execute plan
5. **Phase 5** - Verify and complete

**CRITICAL**: Never skip Phase 3 (Review) or jump directly to implementation.

---

## Verification Protocol (MANDATORY)

**Before calling `ExitPlanMode`, you MUST verify:**

1. **Evidence-based verification** - Run verification commands and provide fresh evidence
2. **Complete execution** - All planned tasks completed
3. **Quality gates passed** - All automated checks pass
4. **No false completion claims** - Never claim "complete" without verification

**The Iron Law**: NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE

---

<critical_constraint>
MANDATORY: No cross-references between CLAUDE.md and .claude/rules/
</critical_constraint>

<critical_constraint>
MANDATORY: No completion claims without fresh verification evidence
</critical_constraint>

<critical_constraint>
MANDATORY: Use ExitPlanMode before implementation
</critical_constraint>

<critical_constraint>
MANDATORY: Every component MUST work with zero .claude/rules dependencies
</critical_constraint>
```
