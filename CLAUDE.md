# CLAUDE.md: The Seed System

Meta-toolkit for Claude Code focused on `.claude/` configuration with dual-role architecture: **health maintenance** + **portable component factory**.

---

## 1. The Constitution (Global Rules)

Behavioral rules are defined in `.claude/rules/`. These files are load together with CLAUDE.md at session start.

---

## 2. Project Navigation (Local Map)

### Quick Actions

| Intent       | Command               |
| :----------- | :-------------------- |
| Build        | `/create`             |
| Analyze      | `/analyze`            |
| Verify       | `/verify`             |
| Plan         | `/strategy:architect` |
| Execute Plan | `/strategy:execute`   |
| Phase Verify | `/qa:verify-phase`    |

### Skills vs Commands: Structure, Not Capability

<critical_constraint>
ARCHITECTURAL FACT: Skills and commands have IDENTICAL capabilities under the hood.
The ONLY difference is structure/syntax for cognitive load management.
</critical_constraint>

**Functional Equivalence:**

| Aspect                      | Skills | Commands |
| :-------------------------- | :----- | :------- |
| **User invocable**          | ✅ Yes | ✅ Yes   |
| **Model invocable**         | ✅ Yes | ✅ Yes   |
| **Can invoke tools**        | ✅ Yes | ✅ Yes   |
| **Can delegate**            | ✅ Yes | ✅ Yes   |
| **Can use AskUserQuestion** | ✅ Yes | ✅ Yes   |

**Structural Differences Only:**

| Aspect                     | Skills                                      | Commands                                            |
| :------------------------- | :------------------------------------------ | :-------------------------------------------------- |
| **Format**                 | Folder with SKILL.md + optional references/ | Single file                                         |
| **Progressive disclosure** | Yes (Tier 2/Tier 3)                         | No (single-file loads full content)                 |
| **Naming**                 | Flat structure                              | Nested with `:` separator (e.g., `/folder:command`) |

**When to Use Which:**

- **Choose Skill** when content benefits from progressive disclosure (complex domain knowledge), need references/ folder for detailed lookup tables, or content may be invoked by other components
- **Choose Command** when quick intent-based invocation is primary use case, content fits comfortably in single file, or direct user interaction is the main pattern

### Component Index

- **Skills**: `.claude/skills/` - Domain knowledge with progressive disclosure
- **Commands**: `.claude/commands/` - Intent aliases and shortcuts
- **Agents**: `.claude/agents/` - Autonomous workers

### Skill Library Index

44 skills organized by purpose. Skills marked with `(*)` have navigation tables.

#### Factory (Building the toolkit)

| Skill                   | Description                                             |
| :---------------------- | :------------------------------------------------------ |
| `skill-authoring`       | Create portable skills with SKILL.md and references/    |
| `skill-iterate`         | Audit, critique, and improve existing skills            |
| `command-authoring`     | Create single-file commands with @/! injection patterns |
| `command-iterate`       | Audit and improve commands with dynamic injection       |
| `agent-development`     | Create, validate, and audit autonomous agents           |
| `hook-development`      | Create, validate, and audit event-driven hooks          |
| `mcp-development`       | Create, test, and audit MCP servers and tools           |
| `claude-md-development` | Manage CLAUDE.md as project's single source of truth    |

<deprecated>
`invocable-development` has been split into 4 granular skills above.
</deprecated>

#### Software Lifecycle (The "Big Skills")

| Skill                            | Description                                                   |
| :------------------------------- | :------------------------------------------------------------ |
| `engineering-lifecycle`          | Plan, implement, and verify software with TDD discipline      |
| `quality-standards`              | Verify completion with evidence using 6-phase gates           |
| `pr-reviewer`                    | Review pull requests for spec, security, performance, quality |
| `requesting-code-review`         | Request code reviews through pre-review checklist             |
| `finishing-a-development-branch` | Finish development branches for merge or PR                   |

#### Analysis & Thinking (Cognitive Tools)

| Skill                       | Description                                        |
| :-------------------------- | :------------------------------------------------- |
| `analysis-diagnose`         | Perform systematic root cause investigation        |
| `brainstorming`             | Turn ideas into validated designs                  |
| `discovery`                 | Conduct discovery interviews for requirements      |
| `first-principles-thinking` | Break down problems to fundamental truths          |
| `inversion-thinking`        | Solve problems backwards to identify failure modes |
| `premortem`                 | Identify failure modes before they occur           |
| `simplification-principles` | Apply simplification principles to debug issues    |

#### Operations & Environment

| Skill                 | Description                                             |
| :-------------------- | :------------------------------------------------------ |
| `filesystem-context`  | Manage filesystem context for large data offloading     |
| `using-git-worktrees` | Manage git worktrees for isolated workspaces            |
| `uv`                  | Manage Python packages and projects using uv            |
| `file-search`         | Search files and content in a codebase                  |
| `iterative-retrieval` | Execute 4-phase loop for progressive context refinement |

#### Specialized Orchestration

| Skill                         | Description                                             |
| :---------------------------- | :------------------------------------------------------ |
| `dispatching-parallel-agents` | Dispatch parallel agents for concurrent problem-solving |
| `distributed-processor`       | Distribute work across multiple contexts                |
| `jules-api`                   | Programmatic interface to Google's Jules API            |
| `create-meta-prompts`         | Generate meta-prompts for Claude-to-Claude pipelines    |
| `ops/reflect-and-patch`       | Review conversation for improvement opportunities       |

#### API Integrations

| Skill                        | Description                                             |
| :--------------------------- | :------------------------------------------------------ |
| `google-genai-typescript`    | Integrate Google GenAI SDK for Gemini models            |
| `perplexity-typescript`      | Integrate Perplexity AI APIs in TypeScript              |
| `memory-persistence`         | Provide session lifecycle hooks for context persistence |
| `multi-session-orchestrator` | Orchestrate multi-session workflows                     |

#### Evaluation & Decision-Making

| Skill                       | Description                                           |
| :-------------------------- | :---------------------------------------------------- |
| `evaluation`                | Evaluate agent systems with quality gates             |
| `swot-analysis`             | Analyze Strengths, Weaknesses, Opportunities, Threats |
| `deviation-rules`           | Handle unexpected work during execution               |
| `refactor-elegant-teaching` | Refactor code to be cleaner and self-documenting      |
| `refine-prompts`            | Refine vague prompts into precise instructions        |

#### Development Tools

| Skill                     | Description                                      |
| :------------------------ | :----------------------------------------------- |
| `agent-browser`           | Automate browser interactions                    |
| `exploration-guide`       | Exploration philosophy and verification practice |
| `planning-guide`          | Planning philosophy, patterns, and practices     |
| `typescript-conventions`  | Apply TypeScript conventions for type safety     |
| `meta-learning-extractor` | Analyze session history to auto-refine rules     |

---

### Self-Maintenance (ops namespace)

| Intent               | Command        |
| :------------------- | :------------- |
| Extract patterns     | `/ops:extract` |
| Detect context drift | `/ops:drift`   |
| Review session       | `/ops:reflect` |

---

## 3. The Factory Protocols

<critical_constraint>
MANDATORY: Produced components must work in a vacuum (Zero CLAUDE.md/.claude/rules/ dependency).
</critical_constraint>

### Factory Reference Table

| To Build...   | Invoke Skill...     |
| :------------ | :------------------ |
| Skill         | `skill-authoring`   |
| Command       | `command-authoring` |
| Audit Skill   | `skill-iterate`     |
| Audit Command | `command-iterate`   |
| Agent         | `agent-development` |
| MCP Server    | `mcp-development`   |
| Hook          | `hook-development`  |

### Build Commands

| Command                  | Purpose                                   |
| :----------------------- | :---------------------------------------- |
| `/create`                | Unified entry - auto-routes to builder    |
| `/toolkit:build:command` | Create one-file commands                  |
| `/toolkit:build:skill`   | Create skills with SKILL.md + references/ |
| `/toolkit:build:package` | Create complete packages                  |

### Audit & Critique

| Command             | Purpose                             |
| :------------------ | :---------------------------------- |
| `/toolkit:audit`    | Universal auditor (auto-routes)     |
| `/toolkit:critique` | Quality audit via quality-standards |

---

## 4. System Discoveries (2026-01-29)

Key findings from internal system review and their resolutions:

### mission_control Requirement

**Discovery**: Not all skills had `<mission_control>` and `<critical_constraint>` XML tags as mandated by `invocable-development`.

**Resolution**: Added `<mission_control>` with `<objective>` and `<success_criteria>` to all 39 skills.

### Progressive Disclosure Scope

**Discovery**: `principles.md` stated progressive disclosure applies ONLY to skills, but `architecture.md` referenced `references/` for commands.

**Resolution**: Commands can reference `references/` for ultra-situational lookup. Progressive disclosure primarily applies to skills.

### SUMMARY.md Pattern Removed

**Discovery**: Several skills used `SUMMARY.md` pattern but it was never documented in rules.

**Resolution**: Deleted all SUMMARY.md files. Skills must be self-contained in SKILL.md.

### Portability Invariant Enforcement

**Discovery**: Skills contained explicit file paths creating portability violations.

**Resolution**: Removed explicit file path references from skill headers. Skills are self-contained.

### AskUserQuestion Integration Pattern

**Discovery**: Commands should present concrete placement options with AskUserQuestion before applying changes, rather than using abstract syntax examples.

**Example**:

- Instead of: `[Ask user for approval before applying]`
- Use: "I found X placements: Append to ## Gotchas, Create new section ## Commands, etc."

**Rationale**: Concrete options are actionable; abstract syntax guidance wastes context.

### Dual-Mode Command Pattern

**Discovery**: Commands can operate in two modes based on arguments:

- **Implicit Mode**: Infer from conversation context when no explicit arguments provided
- **Explicit Mode**: Use user-provided content when arguments are specified

**Example**: `/learning:archive` now scans conversation for discoveries, then asks where to place them.

**Rationale**: Zero-argument commands feel more natural; explicit arguments remain available for precise control.

### Agent Structure Enforcement

**Discovery**: Agent files in `.claude/agents/` were missing sections mandated by `agent-development` skill.

**Required agent sections**:

- `<mission_control>` with objective and success_criteria
- `## Overview` - What the agent does
- `## Autonomous Capability` - How it operates independently
- `## Trigger Conditions` - When to spawn and when NOT to
- `## Philosophy Bundle` - Behavioral guidance for context fork

**Resolution**: Added missing sections to agents.

### Command Description Convention

**Discovery**: Commands were using non-infinitive voice in descriptions, violating What-When-Not-Includes format.

**Required pattern**: "Verb + object. Use when [condition]. Includes [key features]. Not for [exclusion]."

**Examples**:

```
✅ Correct: "Analyze issues, explore context, or reason through problems. Use when user needs diagnosis, investigation, or decision framework. Includes pattern matching, evidence gathering, and structured output. Not for simple lookups or well-understood issues."
❌ Incorrect: "Unified analysis command that routes to appropriate workflow..."

✅ Correct: "Execute quality verification with flexible modes. Use when validating code changes before commit."
❌ Incorrect: "Comprehensive verification workflow..."
```

**Resolution**: Updated `commands/analyze.md` and `commands/verify.md` to use infinitive voice.

### Reference File Navigation

**Discovery**: Reference files in skill folders lacked "Use when" navigation tables required by progressive disclosure patterns.

**Required structure for each reference file**:

- "If you need..." navigation table (section lookup)
- "Context Condition" table (when to load)

**Resolution**: Added navigation tables to:

- `agent-development/references/copy_agent_patterns.md`
- `hook-development/references/quality.md`

### Content Injection Patterns

**Discovery**: Commands were using bash file existence checks (`[ -f file ] && echo`) and explicit bash calls for git state, cluttering the command body.

**Resolution**: Implemented content injection patterns:

- `@path` - Auto-injects file content at invocation time
- `!`command`` - Auto-executes bash and inlines output
- `<injected_content>` - Semantic wrapper for @ references
- "(if exists)" headers - Graceful handling of non-existent files

**Affected commands**: handoff:resume, handoff:diagnostic, plan:create, ops:reflect, ops:drift, learning:archive, learning:refine-rules, jules:docsync

### Reference Lookup Pattern

**Discovery**: Long reference files needed better internal navigation without spoiling content.

**Resolution**: Added navigation tables to reference files:

```markdown
| If you need... | Read this section... |
| :------------- | :------------------- |
| Topic A        | Section X            |

---

| Context Condition | Action |
| :---------------- | :----- |
| Situation A       | Do X   |
```

**Resolution**: Created `invocable-development/references/lookup_content_injection.md` with full patterns.

### XML Simplification Refactor (2026-01-29)

**Discovery:** Excessive XML tags created technical documentation feel rather than architectural success framework.

**Resolution:**

- Kept only 2 XML tags: `<mission_control>` and `<critical_constraint>` (for low-freedom workflows)
- Removed: `<guiding_principles>`, `<trigger>`, `<philosophy_bundle>`, `<interaction_schema>`, `<thinking>`, `<execution_plan>`, `<router>`, `<rule_category>`, `<anti_pattern>`, `<pattern>`
- Replaced XML wrappers with Markdown sections
- Adopted skill-creator patterns: ✅/❌ emoji anchors, recognition questions, navigation tables

**Style Changes:**
| Before | After |
| :----- | :---- |
| `<guiding_principles>` sections | `## The Path to...` Markdown sections |
| `<trigger>` tags | Inline `> **When:**` callouts |
| `<philosophy_bundle>` | Inline critical content only |
| Long XML tables | Markdown tables with ✅/❌ examples |

**New Skills Created:**

- `skill-authoring` - Create portable skills with SKILL.md + references/
- `skill-iterate` - Audit and improve existing skills
- `command-authoring` - Create single-file commands with @/! injection
- `command-iterate` - Audit commands with injection patterns

### Semantic Bridge Refactoring (2026-01-29)

**Discovery**: Bridge file and hardcoded tool syntax created portability issues and potential confusion.

**Resolution**:

- Deleted `bridge.md` entirely
- Replaced with semantic directives in principles.md
- Skills use "Delegate to X specialist" patterns
- Commands keep Claude-specific syntax
- Agents provide philosophy without Task() calls

**Key insight**: Commands are Claude infrastructure—specific syntax is appropriate. Skills must be portable—semantic patterns required. Agents must not spawn other agents—philosophy only.

---

## 4b. Iterative Prompting Framework (2026-01-29)

A self-improving framework for compensating AI agent tool/skill invocation reluctance through explicit mechanisms, quantitative thresholds, and structured reasoning.

### The Core Problem

AI agents exhibit **natural reluctance** to invoke tools/skills. Research shows explicit quantitative enforcement significantly improves tool usage rates (30-50% reduction in unnecessary calls, increased accuracy on complex tasks).

### Framework Components

#### 1. Confidence Rating (0-100)

Before any significant action, explicitly rate confidence:

```
Confidence Scale:
100-95: Certain - proceed without tools
94-90: High - consider tools, likely not needed
89-80: Moderate - invoke tools if relevant
79-70: Low - invoke tools
<70:  Insufficient - invoke tools, gather context
```

**Recognition Question**: "Did I read the actual file, or just see it in grep?"

#### 2. Quantitative Thresholds

Use explicit numbers to reduce ambiguity:

| Threshold           | Meaning                 | Action                       |
| :------------------ | :---------------------- | :--------------------------- |
| **<90% confidence** | Below high confidence   | Invoke tools/skills          |
| **1% chance**       | Even marginal relevance | Absolute rule, no exceptions |
| **10x sensitivity** | Aggressive threshold    | Lower threshold 10x          |

#### 3. The 1% Rule (ABSOLUTE)

> "If there is even the remotest chance a tool/skill applies, invoke it. No exceptions."

This is not guidance—it is enforcement.

#### 4. Chain-of-Thought Enforcement

Force explicit reasoning before actions:

```
BEFORE ACTING:
1. What is the goal?
2. Rate confidence (0-100)
3. What tools/skills might help?
4. Is threshold met?
5. Execute with evidence
```

#### 5. Anti-Laziness Triggers

| Stop Thinking             | Do Instead                  |
| :------------------------ | :-------------------------- |
| "Simple, no tool needed"  | Check for tools first       |
| "I'll just explore first" | Tools tell you HOW          |
| "I know what to do"       | Use tool for best practices |
| "Tools take too long"     | Tools SAVE time             |

### The Mandatory Loop

```
MANDATORY LOOP: CONTEXT → CHECK → EXECUTE

Before EVERY action:
1. Gather relevant context
2. ASK YOURSELF: "Does a tool/skill exist?"
3. If 1% chance applies, invoke it
4. Execute with evidence
5. Loop continues with every new action
```

### Reference Implementation

**SessionStart Hook** (`.claude/scripts/session-start.sh`):

```bash
SKILL SENSITIVITY: 10x ELEVATED

Your skill invocation threshold is now 10x LOWER than normal.
Before EVERY action:

1. Rate confidence (0-100) in completing without a skill
2. If confidence <90%, ASK YOURSELF: "Does a skill exist for this?"
3. If 1% chance applies, invoke it

CONTEXT FIRST. CHECK SKILL. EXECUTE.
```

**Anti-Laziness Reference** (`.claude/skills/skill-iterate/SKILL.md` - search for "Anti-Laziness"):

Comprehensive reference with 8 sections:

- Quick Reference
- Confidence Rating
- Evidence Protocol
- CoT Patterns
- Threshold Gates
- Anti-Laziness Triggers
- Meta-Cognitive Checkpoints
- Uncertainty Protocol

### Iterative Refinement

The framework evolves through observation:

1. **Monitor**: Track tool invocation rates
2. **Measure**: Compare against thresholds
3. **Adjust**: Refine confidence ratings and thresholds
4. **Validate**: Test enforcement effectiveness

**Key Metrics**:

- Tool invocation frequency
- Confidence rating accuracy
- Error rate in tool selection
- Rationalization detection rate

### Integration Points

| Component             | How It Uses the Framework                                                 |
| :-------------------- | :------------------------------------------------------------------------ |
| **SessionStart hook** | Injects discipline content at session start                               |
| **Skills**            | Reference `lookup_anti_laziness_patterns.md` in Dynamic Knowledge Loading |
| **MCP tools**         | Apply confidence rating before tool calls                                 |
| **Agents**            | Include philosophy bundle with threshold enforcement                      |

### Evidence-Based Verification

<critical_constraint>
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
</critical_constraint>

| Instead of...         | Use This Evidence...                           |
| :-------------------- | :--------------------------------------------- |
| "I fixed the bug"     | `Test auth_login_test.ts passed (Exit Code 0)` |
| "TypeScript is happy" | `tsc --noEmit: 0 errors, 0 warnings`           |
| "File exists"         | `Read /path/to/file.ts:47 lines verified`      |

### Confidence Markers

| Marker          | Meaning                 | Action Required        |
| :-------------- | :---------------------- | :--------------------- |
| **✓ VERIFIED**  | Read file, traced logic | Safe to assert         |
| **? INFERRED**  | Based on grep/search    | Verify before claiming |
| **✗ UNCERTAIN** | Haven't checked         | Must investigate       |

### Why This Works

Research (CoT prompting, threshold-based scoring) shows:

1. **Quantitative framing** reduces ambiguity—LLMs respond to explicit numbers
2. **Self-reflection triggers** force reconsideration before action
3. **Anti-laziness tables** catch rationalization patterns
4. **Evidence requirements** prevent false claims
5. **Loop structure** ensures consistent enforcement

### Evolution Pattern

The framework improves through iteration:

1. **Initial**: Strong enforcement language
2. **Observation**: What gets skipped?
3. **Refinement**: Add specific triggers for observed gaps
4. **Validation**: Test and measure improvement
5. **Repeat**: Continuous refinement cycle

---

## 5. Native Integration

The Seed System aligns with Claude Code native capabilities:

| Native Capability                  | Seed System Pattern                                 |
| ---------------------------------- | --------------------------------------------------- |
| `EnterPlanMode`                    | `/strategy:architect` wraps with parallel detection |
| `TodoWrite`                        | Primary task tracking (phase-level)                 |
| `Task()` batching                  | `/strategy:execute` batches parallel tasks          |
| Delegate to exploration specialist | `exploration-guide.md` provides context             |
| Delegate to planning specialist    | `planning-guide.md` provides philosophy             |
| `qa:verify-phase`                  | Build + Type + Test + Conflict gates                |

**Key Principle**: Native tools execute; Seed System provides philosophy and context.

### Guide System

Philosophy guides provide context to native agents:

| Guide               | Purpose                | Provides                                                |
| ------------------- | ---------------------- | ------------------------------------------------------- |
| `planning-guide`    | Planning philosophy    | L'Entonnoir, 2-3 task rule, parallel detection          |
| `exploration-guide` | Exploration philosophy | Verification practice, output standards, tool selection |

### Strategy Orchestration

The Strategic Orchestrator enables parallel execution:

| Command               | Purpose                                         |
| :-------------------- | :---------------------------------------------- |
| `/strategy:architect` | Create STRATEGY.md with parallel detection      |
| `/strategy:execute`   | Execute with parallel Task() batching           |
| `/qa:verify-phase`    | Phase gatekeeper (build, type, test, conflicts) |

**STRATEGY.md Schema**:

```markdown
## Phase 2: Feature Implementation

<phase id="phase-2" type="parallel" gate="qa:verify-phase">
  <task id="2.1" name="API" style="tdd" agent="implementation">...</task>
  <task id="2.2" name="UI" style="tdd">...</task>
</phase>
```

---

<critical_constraint>
MANDATORY: No completion claims without fresh verification evidence
</critical_constraint>

<critical_constraint>
MANDATORY: Use ExitPlanMode before implementation
</critical_constraint>

<critical_constraint>
MANDATORY: Every component MUST work with zero .claude/rules dependencies
</critical_constraint>
