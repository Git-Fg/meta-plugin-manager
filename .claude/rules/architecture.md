# Architecture: The Navigator's Map

**The "Map" for where information lives - Cognitive Load Management through Progressive Disclosure**

Think of this as the structural patterns for building components. We provide the architecture, you navigate the implementation.

---

## Commander's Intent Pattern

Define the destination and boundaries, not the turn-by-turn mechanics.

```
❌ Script: "Run `npm test`, then if it passes, run `git add .`, then `git commit`."
✅ Intent: "Commit the changes once the test suite passes."

❌ Script: "First create the directory. Then create the SKILL.md file. Then add frontmatter."
✅ Intent: "Here is the directory structure, quality standards, and where patterns live."

❌ Script: "Run `trash component.md`, then update the index, then clean dependencies."
✅ Intent: "Archive retired components to conserve history while keeping the context window clean."
```

**Why this works:**

| Script (Low Trust)                           | Intent (High Trust)              |
| -------------------------------------------- | -------------------------------- |
| Assumes agent cannot manage basic operations | Respects the agent's capability  |
| Brittle—breaks when context shifts           | Flexible—adapts to context       |
| Consumes tokens on implementation details    | Focuses on what matters: outcome |

**The Pattern:** State what a perfect result looks like, then trust the agent to navigate there.

---

## Anti-Laziness Compensation Patterns

> **Objective:** Ensure critical content is found whether agents skim or attend to recency.
> **Success Criteria:** Content discoverable via navigation tables AND grep AND recency.

### The Dual-Path Problem

AI agents exhibit two conflicting behaviors due to their RLHF training:

| Behavior           | Implication                             | Result                                     |
| ------------------ | --------------------------------------- | ------------------------------------------ |
| **Recency bias**   | Models attend strongly to recent tokens | Place constraints at bottom of files       |
| **Agent laziness** | Agents tend to skim/skip to end         | Critical content missed if not at very end |

**The conflict:** "Constraints at bottom" assumes models read sequentially. "Agents skip to end" means critical content may be missed entirely.

**Solution:** Multi-modal discoverability—critical content accessible via multiple paths.

### Required Elements for Reference Files

| Element                       | Purpose                        | Placement                               |
| :---------------------------- | :----------------------------- | :-------------------------------------- |
| **Navigation table**          | Quick lookup via recognition   | File top, immediately after frontmatter |
| **Greppable section headers** | PATTERN:, EDGE:, ANTI-PATTERN: | Throughout body                         |
| **Constraints footer**        | Recency bias compliance        | File bottom                             |

### Greppable Header Registry

Use consistent, searchable prefixes that agents can find via grep:

| Prefix             | Purpose                     | When to Use               |
| :----------------- | :-------------------------- | :------------------------ |
| `## PATTERN:`      | Core implementation pattern | Default for all patterns  |
| `## ANTI-PATTERN:` | What to avoid               | Warnings, common mistakes |
| `## EDGE:`         | Edge case handling          | Special conditions        |
| `## TL;DR:`        | Executive summary           | Quick context             |

**Removed:** `## REFERENCE:` and `## EXAMPLE:` — merge into `## PATTERN:` with embedded code examples.

### Reference File Template

```markdown
# Reference Title

## Navigation

| If you need... | Read...                   |
| :------------- | :------------------------ |
| Quick pattern  | ## PATTERN: Core Pattern  |
| Edge case      | ## EDGE: Edge Cases       |
| Common mistake | ## ANTI-PATTERN: Mistakes |

## TL;DR

[Executive summary - 2-3 lines]

## PATTERN: Core Pattern

[Main content with embedded examples via ``` code blocks ```]

## ANTI-PATTERN: Common Mistakes

[What to avoid and why]

## EDGE: Edge Cases

[Special conditions and handling]

---

## Absolute Constraints

<critical_constraint>
[Non-negotiable rules]
</critical_constraint>
```

### Why Multi-Modal Discovery Works

| Problem                 | Solution                | Result                  |
| ----------------------- | ----------------------- | ----------------------- |
| Agent skips to end      | Navigation table at top | Finds what it needs     |
| Agent misses navigation | Greppable headers       | Searches find content   |
| Agent attends to bottom | Constraints footer      | Final tokens reinforced |

---

## The Unified Hybrid Protocol (UHP)

**The Standard:** XML for the Machine (Control), Markdown for the Human (Content), State for Interaction.

### When to Use XML vs Markdown

| Use XML (Pay the Tax)          | Use Markdown (Skip)        |
| ------------------------------ | -------------------------- |
| Critical constraints           | Bulk data content          |
| Rules that must not be ignored | Informational prose        |
| Semantic anchoring needed      | Tables and structured data |

**Rule of Thumb:** If it's "Instruction" → XML. If it's "Data" → Markdown.

**Example:**

```
❌ Wrapped: <instructions>## Step 1\nCreate directory</instructions>
✅ Inline: ## Step 1\nCreate directory

✅ Only wrap when critical:
<critical_constraint>ALWAYS validate before save</critical_constraint>
```

### Standard Tags (Minimal)

| Tag                     | Purpose                          | When to Use                |
| :---------------------- | :------------------------------- | :------------------------- |
| `<mission_control>`     | Objective and success criteria   | Low-freedom workflows only |
| `<critical_constraint>` | System physics (true invariants) | Non-negotiables only       |
| `<injected_content>`    | Wrapped @ references             | Command content injection  |

---

## The Path to High-Autonomy Success

### 1. The Unified Neural Core

Keep core logic in SKILL.md, not scattered across references. When logic is fragmented, context becomes fragmented. The pilot needs a single source of truth for each capability domain.

**Recognition:** "Is the decision-making content in SKILL.md or scattered?"

### 2. The Integrity of Discovery (Blind Pointers)

Use navigation tables as **blind pointers** only. Never describe content in SKILL.md navigation.

✅ **Blind Pointer:**

```markdown
| If you need...              | Read...                         |
| :-------------------------- | :------------------------------ |
| API Technical Specification | `references/lookup_api_spec.md` |
```

❌ **Spoiler:**

```markdown
| If you need... | Read...                                                  |
| :------------- | :------------------------------------------------------- |
| API endpoints  | See `references/api.md` for login, logout, token refresh |
```

**Recognition:** "Does my navigation describe what's in the reference, or just point to it?"

### 3. Semantic Speed

Use `lookup_`/`pattern_`/`workflow_` prefixes for reference files. Semantic prefixes create discoverable anchors.

✅ `references/lookup_api.md` finds faster than `references/api_details_v2.md`

### 4. Fluid User Experience

Use positional arguments for unique identifiers only. `$1` should always be a slug, hash, or ID—not a flag or mode.

✅ `/handoff:resume session-x` (ID-based)
❌ `/handoff:resume --verbose` (not allowed)

### 5. The Recency Advantage

Place critical content at file bottoms. Models attend to recent tokens. The final tokens receive highest attention.

### 6. The Attic Pattern

Archive retired components, never delete. Git history is permanent; context window is not.

- Use `trash` command to move to OS trash bin
- Add `<deprecated>` tags at file top for clarity

### 7. Define Boundaries, Not Steps

Provide invariants (what the output must be), not instructions (how to get there). Trust the pilot to navigate.

❌ "Run `rm -rf node_modules`"
✅ "Zero external dependencies"

---

## Command vs Skill: Structural Choice, Not Capability

> **Objective:** Guide structural choice based on cognitive load, not capability differences.

**The Key Insight:** Skills and commands have IDENTICAL capabilities. The choice is about cognitive load management.

| Both Can:           |                        |
| :------------------ | :--------------------- |
| User invocable      | Via slash commands     |
| Model invocable     | By other components    |
| Invoke tools        | Any tool (Bash, etc)   |
| Delegate            | To specialized workers |
| Use AskUserQuestion | For interaction        |

### When to Choose Command

- Quick intent-based invocation is primary
- Content fits in single file (~500-1500 words)
- Direct user interaction is the main pattern

### When to Choose Skill

- Content benefits from progressive disclosure
- Need references/ for detailed lookup tables
- Content may be invoked by other components

### Structure Comparison

```
command.md (single file)
└── All content loads at invocation

skill-name/ (folder)
├── SKILL.md (core)
├── references/ (detailed lookup)
├── examples/ (optional)
└── scripts/ (optional)
```

---

## The Unified Separation of Concerns Protocol

> **Objective:** Define boundaries between Commands (Infrastructure) and Skills (Portable Logic).

### Core Principle: Adapter Pattern

**Command** = Local Adapter (Claude-specific infrastructure)
**Skill** = Universal Logic Core (portable to any agent)

### Three Boundaries

| Boundary        | Commands (Adapter)           | Skills (Logic Core) |
| --------------- | ---------------------------- | ------------------- |
| **Context**     | Active injection (@, !)      | Passive reading     |
| **Tooling**     | Hard binding (Bash, MCP)     | Semantic intent     |
| **Interaction** | Negotiator (AskUserQuestion) | Executor (headless) |

### The Rules

1. **Injection Rule:** Commands use `!/@` for dynamic state. Skills use text instructions.
2. **Argument Rule:** Only use `$1` for unique identifiers (IDs, hashes, slugs).
3. **Binding Rule:** Commands translate universal intent into specific tool calls.

---

## Component Structure: Frontmatter

All portable components MUST use YAML frontmatter with What-When-Not-Includes format:

```yaml
---
name: component-name
description: "Verb + object. Use when [triggers]. Includes [features]. Not for [exclusions]."
---
```

**Format breakdown:**

| Part         | Purpose                                        |
| :----------- | :--------------------------------------------- |
| **What**     | Action verb + object (what the component does) |
| **When**     | Triggers (when to use this component)          |
| **Includes** | Key features                                   |
| **Not**      | Exclusions (what this is NOT for)              |

**Why:** Frontmatter description IS the trigger mechanism for auto-discovery.

✅ **Correct:** "Apply TypeScript conventions for type safety. Use when writing or refactoring TypeScript code. Includes naming conventions, immutability patterns. Not for JavaScript projects."

❌ **Incorrect:** Separate "## When to Use" sections that duplicate frontmatter.

---

## Content Injection: Dynamic Context Loading

Commands support dynamic content injection at execution time:

### @ Pattern (File Injection)

```markdown
<injected_content>
@.claude/workspace/handoffs/diagnostic.yaml
</injected_content>
```

### ! Pattern (Command Execution)

```markdown
Current branch: !`git branch --show-current`
```

### When to Use

| Pattern              | Use When                                       |
| -------------------- | ---------------------------------------------- |
| `@path`              | Injecting static or existing file content      |
| `!command`           | Dynamic state that changes between invocations |
| `<injected_content>` | Semantic grouping of related @ injections      |

**Note:** Skills must NOT use `@` or `!` syntax. Use text instructions instead.

---

## L'Entonnoir: The Funnel Pattern

> **Objective:** Iteratively narrow problem space through intelligent batching.

### The Funnel Flow

```
AskUserQuestion (2-4 options, recognition-based)
     ↓
User selects from options
     ↓
Explore based on selection → AskUserQuestion (narrower)
     ↓
Repeat until ready → Execute
```

### Key Principles

**Continuous Exploration:**

- Investigate at ANY time—before first question, between questions
- Don't wait for user response to explore context
- Exploration informs the NEXT question

**Actionable Questions:**

- Every question offers 2-4 options (recognition-based)
- User selects, never types free-form text
- Options should narrow scope (funnel effect)

### Batching Guidelines

**DO batch together:**

- Questions sharing the same context
- Questions where earlier answers inform later options
- 2-4 questions max per call

**DON'T batch together:**

- Unrelated topics
- More than 4 questions (overwhelming)

---

## Progressive Disclosure

> **Objective:** Manage cognitive load through layered information architecture.

Think of information architecture as cognitive load management:

| Tier       | Content                            | Tokens        |
| ---------- | ---------------------------------- | ------------- |
| **Tier 1** | YAML metadata                      | ~100          |
| **Tier 2** | Core workflows, mission, patterns  | 1.5k-2k words |
| **Tier 3** | Deep patterns, API specs, examples | Unlimited     |

**Scope:** Progressive disclosure applies ONLY to skills (with `references/`). Commands are single-file.

**Principle:** Keep Tier 2 lean. Move detailed content to references/.

---

## Operational Patterns

The architecture describes behavioral intent through semantic directives. Native tools execute these patterns at runtime.

| Semantic Directive               | Purpose                        |
| -------------------------------- | ------------------------------ |
| "Delegate to specialized worker" | Spawn agents for complex tasks |
| "Maintain a visible task list"   | Track progress                 |
| "Consult the user"               | Recognition-based interaction  |
| "Locate files matching patterns" | File discovery                 |
| "Search file contents"           | Content search                 |

<critical_constraint>
ALWAYS use native tools to fulfill semantic directives. Trust the System Prompt to select the correct implementation.
</critical_constraint>

---

## Recency Bias: The Final Token Rule

**The pattern:** Header for identity, body for teaching, footer for what matters most.

**Why position matters:** Models attend more strongly to recent tokens. Place non-negotiables where they'll receive highest attention—at the end of a document.

---

## Skill Opening Section Standard

**Every skill MUST open with either `## Quick Start` or `## Workflow`:**

| Section Type     | Use When                        | Pattern                          |
| ---------------- | ------------------------------- | -------------------------------- |
| `## Quick Start` | Tool-like skills with scenarios | "If you need X: Do Y → Result:"  |
| `## Workflow`    | Process skills with phases      | "Phase → What happens → Result:" |

Both sections MUST explain WHY:

```markdown
## Quick Start

**If you need X:** Do Y → Result

**Why:** [Purpose and benefit]
```

---

## Self-Containment: The Portability Invariant

**Recognition Question:** "Would this component work in a project with zero rules?"

- Include everything needed directly
- Don't reference external files or directories
- Bundle condensed philosophy with component

---

## Summary: The Architecture Map

| Concept                    | Role         | Description                                      |
| -------------------------- | ------------ | ------------------------------------------------ |
| **UHP**                    | Format       | XML for control, Markdown for data               |
| **Rooter**                 | Organization | Complete packages with multiple entry points     |
| **L'Entonnoir**            | Interaction  | Iterative funneling through intelligent batching |
| **Progressive Disclosure** | Distribution | Tier 1 → Tier 2 → Tier 3                         |
| **Recency Bias**           | Priority     | Constraints at bottom of files                   |

## The Attic Pattern: Retiring with Grace

**The principle:** Conserve history while keeping the context window clean.

| If you want to... | Do this...                                        |
| ----------------- | ------------------------------------------------- |
| Recover later     | Use `trash` command (files go to OS trash bin)    |
| Keep in repo      | Add `<deprecated>REASON</deprecated>` at file top |

**After archiving:** Remove links from `CLAUDE.md` and indexes.

---

<critical_constraint>
**Absolute Portability Invariant:**

Every component (Skill, Command, Agent, Hook, MCP) MUST be functionally complete and executable in a vacuum.

1. It must work in a project containing ZERO config files
2. It must carry its own "Genetic Code" within its own structure
3. It must NOT reference global rules via text or links
   </critical_constraint>
