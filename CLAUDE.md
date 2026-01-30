# CLAUDE.md: The Seed System

Meta-toolkit for Claude Code focused on `.claude/` configuration with dual-role architecture: **health maintenance** + **portable component factory**.

---

## 1. Quick Reference

### Quick Actions

| Intent | Command |
| :----- | :------ |
| Build | `/create` |
| Analyze | `/analyze` |
| Verify | `/verify` |
| Phase Verify | `/qa:verify-phase` |

### Native Planning

When in Plan Mode, prefer a phase-based dependency graph. Use `EnterPlanMode` for non-trivial implementation tasks.

### Component Index

- **Skills**: `.claude/skills/` - Domain knowledge with progressive disclosure
- **Commands**: `.claude/commands/` - Intent aliases and shortcuts
- **Agents**: `.claude/agents/` - Autonomous workers

### Factory Reference

| To Build... | Invoke Skill... |
| :---------- | :-------------- |
| Skill | `skill-authoring` |
| Command | `command-authoring` |
| Audit Skill | `system-refiner` |
| Audit Command | `command-refine` |
| Agent | `agent-development` |
| MCP Server | `mcp-development` |
| Hook | `hook-development` |

---

## 2. Skills vs Commands: Structure, Not Capability

<critical_constraint>
Skills and commands have IDENTICAL capabilities. The ONLY difference is structure for cognitive load management.
</critical_constraint>

### Functional Equivalence

| Aspect | Skills | Commands |
| :----- | :----- | :------- |
| User invocable | ✅ Yes | ✅ Yes |
| Model invocable | ✅ Yes | ✅ Yes |
| Can invoke tools | ✅ Yes | ✅ Yes |
| Can delegate | ✅ Yes | ✅ Yes |
| Can use AskUserQuestion | ✅ Yes | ✅ Yes |

### Structural Differences

| Aspect | Skills | Commands |
| :----- | :----- | :------- |
| Format | Folder with SKILL.md + optional references/ | Single file |
| Progressive disclosure | Yes (Tier 2/Tier 3) | No |
| Naming | Flat structure | Nested with `:` separator |

### When to Choose Which

**Choose Skill** when content benefits from progressive disclosure, need references/ for detailed lookup tables, or content may be invoked by other components.

**Choose Command** when quick intent-based invocation is primary, content fits in single file, or direct user interaction is the main pattern.

### Command Dual-Mode Pattern

| Mode | Behavior | Example |
| :--- | :------- | :------ |
| Implicit | Infer from context when no arguments provided | `/handoff:resume` → scans directory |
| Explicit | Use provided argument | `/handoff:resume session-x` → loads specific |

---

## 3. The Map: Architecture

Provide boundaries and invariants. Trust the Pilot to navigate.

### Commander's Intent

Define the destination, not the turn-by-turn mechanics.

```
❌ Script: "Run `npm test`, then if it passes, run `git add .`, then `git commit`."
✅ Intent: "Commit the changes once the test suite passes."

❌ Script: "First create the directory. Then create the SKILL.md file. Then add frontmatter."
✅ Intent: "Here is the directory structure, quality standards, and where patterns live."
```

### Unified Hybrid Protocol (UHP)

**XML for control, Markdown for data.**

| Use XML | Use Markdown |
| :------ | :----------- |
| Critical constraints | Bulk data content |
| Rules that must not be ignored | Informational prose |
| Semantic anchoring needed | Tables and structured data |

**Standard tags (minimal):**

| Tag | Purpose | When to Use |
| :-- | :------ | :---------- |
| `<mission_control>` | Objective and success criteria | Low-freedom workflows |
| `<critical_constraint>` | System invariants | Non-negotiables only |
| `<injected_content>` | Wrapped @ references | Command content injection |

### L'Entonnoir: The Funnel Pattern

Iteratively narrow problem space through intelligent batching.

```
AskUserQuestion (2-4 options, recognition-based)
     ↓
User selects from options
     ↓
Explore based on selection → AskUserQuestion (narrower)
     ↓
Repeat until ready → Execute
```

**Continuous Exploration:** Investigate at ANY time—before first question, between questions.

### Progressive Disclosure

Manage cognitive load through layered information.

| Tier | Content | Tokens |
| :--- | :------ | :----- |
| Tier 1 | YAML metadata | ~100 |
| Tier 2 | Core workflows, mission, patterns | 1.5k-2k words |
| Tier 3 | Deep patterns, API specs, examples | Unlimited |

### Recency Bias: The Final Token Rule

Place critical content at file bottoms. Models attend more strongly to recent tokens.

### The Attic Pattern

Archive retired components, never delete. Use `trash` command. Add `<deprecated>` tags at file top.

---

## 4. The Pilot: Principles

### High Trust Mandate

| Script (Low Trust) | Intent (High Trust) |
| :----------------- | :------------------ |
| Assumes agent cannot manage basic operations | Respects the agent's capability |
| Brittle—breaks when context shifts | Flexible—adapts to context |
| Consumes tokens on implementation details | Focuses on outcome |

### Semantic Tool Patterns

| Semantic Directive | Maps To Native |
| :----------------- | :------------- |
| "Consult the user" | AskUserQuestion |
| "Maintain a visible task list" | TodoWrite |
| "Delegate to specialized worker" | Task() |
| "Locate files matching patterns" | Glob |
| "Search file contents" | Grep |
| "Navigate code structure" | LSP |
| "Switch to planning mode" | EnterPlanMode |

### Voice: Commander's Intent

**Use the imperative/infinitive form:**

```
✅ Correct: "Validate inputs before processing."
✅ Correct: "Create the skill directory and SKILL.md file."
❌ Incorrect: "You should validate inputs..."
❌ Incorrect: "Let's create the skill directory..."
```

### Voice Strength

| Strength | When to Use | Markers | Example |
| :------- | :---------- | :------ | :------ |
| **Gentle** | Best practices | Consider, prefer | "Consider running in tmux" |
| **Standard** | Default patterns | Create, use, follow | "Create the skill directory" |
| **Strong** | Quality gates | ALWAYS, NEVER | "ALWAYS validate before save" |
| **Critical** | Security, safety | MANDATORY, CRITICAL | "CRITICAL: Back up first" |

### Degrees of Freedom

**Default to HIGH FREEDOM unless a clear constraint exists.**

| Freedom | When to Use | Example |
| :------ | :---------- | :------ |
| **High** | Multiple valid approaches | "Consider using immutable data structures" |
| **Medium** | Some guidance needed | "Use this pattern, adapting as needed" |
| **Low** | Fragile/error-prone | "Execute steps 1-3 precisely" |

### Agent Recursion Prohibition

Agents can NOT spawn other agents.

| Pattern | Status |
| :------ | :----- |
| Agent → Task(subagent_type="...") | Forbidden |
| Agent → Delegate to specialist | Forbidden |
| Agent → Provide philosophy + context | Required |

---

## 5. Component Structure

### Frontmatter (Required)

```yaml
---
name: component-name
description: "Verb + object. Use when [triggers] {with optional keywords}. Not for [exclusions]."
---
```

**Format breakdown:**

| Part | Purpose |
| :--- | :------ |
| What | Action verb + object |
| When | Triggers (when to use) |
| Includes | Key features |
| Not | Exclusions |

### Skill Opening Section

Every skill MUST open with either `## Quick Start` or `## Workflow`:

| Section Type | Use When | Pattern |
| :----------- | :------- | :------ |
| `## Quick Start` | Tool-like skills with scenarios | "If you need X: Do Y → Result:" |
| `## Workflow` | Process skills with phases | "Phase → What happens → Result:" |

### Reference File Structure

| Element | Purpose | Placement |
| :------ | :------ | :-------- |
| Navigation table | Quick lookup via recognition | File top, after frontmatter |
| Greppable headers | PATTERN:, EDGE:, ANTI-PATTERN: | Throughout body |
| Constraints footer | Recency bias compliance | File bottom |

---

## 6. Content Injection (Commands Only)

| Pattern | Component | Purpose |
| :------ | :-------- | :------- |
| `@path` | Commands only | File injection at invocation time |
| `` !`command` `` | Commands only | Execute bash, inline output |
| `<injected_content>` | Commands only | Semantic wrapper |

### Three Boundaries

| Boundary | Commands (Adapter) | Skills (Logic Core) |
| :------- | :----------------- | :------------------ |
| Context | Active injection (@, !) | Passive reading |
| Tooling | Hard binding (Bash, MCP) | Semantic intent |
| Interaction | Negotiator (AskUserQuestion) | Executor (headless) |

<critical_constraint>
Skills MUST NEVER use `@` or `!` syntax.
</critical_constraint>

---

## 7. Quality: Trust but Verify

### The Iron Law

Execute independently (Trust). Provide evidence before claiming done (Verify).

### Confidence Markers

| Marker | Meaning |
| :----- | :------ |
| **✓ VERIFIED** | Read file, traced logic—safe to assert |
| **? INFERRED** | Based on grep/search—needs verification |
| **✗ UNCERTAIN** | Haven't checked—must investigate |

### Evidence-Based Claims

| Instead of... | Use This Evidence... |
| :------------ | :------------------- |
| "I fixed the bug" | `Test auth_login_test.ts passed (Exit Code 0)` |
| "TypeScript is happy" | `tsc --noEmit: 0 errors, 0 warnings` |
| "File exists" | `Read /path/to/file.ts:47 lines verified` |

### Anti-Patterns

| Pattern | Recognition Question |
| :------ | :------------------- |
| Command wrapper | "Could the description alone suffice?" |
| Non-self-sufficient | "Can this work standalone?" |
| Context fork misuse | "Is the overhead justified?" |
| Zero/negative delta | "Would Claude know this without being told?" |
| Content drift | "Is this concept documented elsewhere?" |
| False claims | "Did I read the actual file, or just see it in grep?" |
| External paths | "Does this reference files outside the component?" |
| Non-greppable ref | "Does reference lack navigation table?" |

### Verification Checklist

Before claiming completion:

- **Frontmatter valid** — Component loads without silent failures
- **Claims verified** — All assertions backed by file reads
- **Portability confirmed** — Zero external dependencies
- **Invocation tested** — Discovered from description alone

---

## 8. Iterative Prompting Framework

### Confidence Rating (0-100)

Before any significant action, explicitly rate confidence:

| Confidence | Level | Action |
| :--------- | :---- | :----- |
| 100-95 | Certain | Proceed without tools |
| 94-90 | High | Consider tools, likely not needed |
| 89-80 | Moderate | Invoke tools if relevant |
| 79-70 | Low | Invoke tools |
| <70 | Insufficient | Invoke tools, gather context |

### The 1% Rule (ABSOLUTE)

> "If there is even the remotest chance a tool/skill applies, invoke it. No exceptions."

### Mandatory Loop

```
CONTEXT → CHECK → EXECUTE

Before EVERY action:
1. Gather relevant context
2. ASK YOURSELF: "Does a tool/skill exist?"
3. If 1% chance applies, invoke it
4. Execute with evidence
```

### Anti-Laziness Triggers

| Stop Thinking | Do Instead |
| :------------ | :--------- |
| "Simple, no tool needed" | Check for tools first |
| "I'll just explore first" | Tools tell you HOW |
| "I know what to do" | Use tool for best practices |

---

## 9. The Delta Standard

**Good Component = Expert Knowledge − What Claude Already Knows**

### Positive Delta (Keep)

- Best practices (not just possibilities)
- Modern conventions Claude might not default to
- Explicit project-specific decisions
- Domain expertise not in general training
- Non-obvious trade-offs (why X over Y)
- Anti-patterns (what to avoid)

### Zero/Negative Delta (Remove)

- Basic programming concepts
- Standard library documentation
- Generic tutorials
- Claude-obvious operations

### Self-Containment

Every component must work in a project with ZERO config files. Carry condensed philosophy within the component.

---

## 10. Portability Invariant

<critical_constraint>
Every component (Skill, Command, Agent, Hook, MCP) MUST be functionally complete and executable in a vacuum.

1. It must work in a project containing ZERO config files
2. It must carry its own "Genetic Code" within its own structure
3. It must NOT reference global rules via text or links
</critical_constraint>

### Rule Scope

| Component | Can Reference Paths? |
| :-------- | :------------------- |
| Rules files | YES (source of truth) |
| CLAUDE.md | YES (project-specific) |
| Skills/Commands/Agents | NO (portable) |

---

## 11. Skill Library Index

### Factory (Building the toolkit)

| Skill | Description |
| :---- | :---------- |
| `skill-authoring` | Create portable skills with SKILL.md and references/ |
| `system-refiner` | Refine system based on corrections and friction |
| `command-authoring` | Create single-file commands with @/! injection patterns |
| `command-refine` | Analyze conversation to refine commands |
| `agent-development` | Create, validate, and audit autonomous agents |
| `hook-development` | Create, validate, and audit event-driven hooks |
| `mcp-development` | Create, test, and audit MCP servers and tools |
| `claude-md-development` | Manage CLAUDE.md as project's single source of truth |

### Software Lifecycle (The "Big Skills")

| Skill | Description |
| :---- | :---------- |
| `engineering-lifecycle` | Plan, implement, and verify software with TDD discipline |
| `quality-standards` | Verify completion with evidence using 6-phase gates |
| `pr-reviewer` | Review pull requests for spec, security, performance, quality |
| `requesting-code-review` | Request code reviews through pre-review checklist |
| `finishing-a-development-branch` | Finish development branches for merge or PR |

### Analysis & Thinking (Cognitive Tools)

| Skill | Description |
| :---- | :---------- |
| `analysis-diagnose` | Systematic root cause investigation with evidence-based hypothesis testing |
| `brainstorming` | Collaborative design exploration using l'entonnoir pattern and YAGNI |
| `discovery` | Requirements gathering with context exploration and research loops |
| `premortem` | Proactive risk identification with tiger/paper/elephant categorization |
| `simplification-principles` | Apply simplification principles to debug issues |
| `think-tank` | Unified reasoning framework: 5 Whys, Pareto, Inversion, SWOT, 10/10/10, First Principles, and more |

### Operations & Environment

| Skill | Description |
| :---- | :---------- |
| `filesystem-context` | Manage filesystem context for large data offloading |
| `using-git-worktrees` | Manage git worktrees for isolated workspaces |
| `uv` | Manage Python packages and projects using uv |

### Specialized Orchestration

| Skill | Description |
| `jules-api` | Programmatic interface to Google's Jules API |
| `create-meta-prompts` | Generate meta-prompts for Claude-to-Claude pipelines |
| `system-refiner` | Refine system based on corrections and friction |

### API Integrations

| Skill | Description |
| :---- | :---------- |
| `google-genai-typescript` | Integrate Google GenAI SDK for Gemini models |
| `perplexity-typescript` | Integrate Perplexity AI APIs in TypeScript |
| `memory-persistence` | Provide session lifecycle hooks for context persistence |

### Evaluation & Decision-Making

| Skill | Description |
| :---- | :---------- |
| `deviation-rules` | Handle unexpected work during execution |
| `evaluation` | Evaluate agent systems with quality gates |
| `refactor-elegant-teaching` | Refactor code to be cleaner and self-documenting |
| `refine-prompts` | Refine vague prompts into precise instructions |

### Development Tools

| Skill | Description |
| :---- | :---------- |
| `agent-browser` | Automate browser interactions |
| `exploration-guide` | Exploration philosophy and verification practice |
| `planning-guide` | Planning philosophy, patterns, and practices |
| `typescript-conventions` | Apply TypeScript conventions for type safety |

### Self-Maintenance (ops namespace)

| Intent | Command |
| :----- | :------ |
| Extract patterns | `/ops:extract` |
| Detect context drift | `/ops:drift` |
| Review session | `/ops:reflect` |

---

<critical_constraint>
**Absolute Constraints:**

1. No completion claims without fresh verification evidence
2. Every component MUST work with zero .claude/rules dependencies
3. MANDATORY: Use ExitPlanMode before implementation
4. MANDATORY: Produced components must work in a vacuum
</critical_constraint>
