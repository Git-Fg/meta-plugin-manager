---
name: intent-router
description: "Route user intent to the correct Engine (Skill) or Interface (Command). Use when the task scope is broad, ambiguous, or when the agent is unsure which component applies. Keywords: route, dispatch, which skill, which command, what should I use."
---

<mission_control>
<objective>Identify and invoke the optimal component for a task with minimal human interruption.</objective>
<success_criteria>Intent mapped to a specific skill/command; Autonomous invocation of the Engine; Escalation to human only on 50%+ ambiguity.</success_criteria>
</mission_control>

## Quick Start

**If task is clear and matches a skill:** Invoke the skill directly.

**If task needs runtime context:** Use a Context Injector command first (git diff, file content).

**If task is ambiguous:** Use an Interactive Liaison command to clarify with the user.

## Navigation

| If you need... | Read this section... |
| :------------- | :------------------- |
| Decision matrix | ## PATTERN: Decision Matrix |
| Autonomous inference | ## PATTERN: Autonomous Inference |
| 3 archetypes reference | ## PATTERN: The 3 Archetypes |
| Examples | ## PATTERN: Routing Examples |

## PATTERN: Decision Matrix

Route intent based on task properties:

| Task Property | Structural Requirement | Recommended Path |
| :--- | :--- | :--- |
| **Deep Knowledge** (Checklists, API Specs, Logic) | Engine (Skill) | Invoke Skill directly |
| **Runtime State** (Git diffs, File content, Logs) | Context Injector (Command) | Run Command first |
| **Iterative Logic** (Multi-step verification/TDD) | Engine (Skill) | Delegate to Skill |
| **Ambiguous/Vague** (User hasn't defined "What") | Liaison (Command) | Run Command to clarify |

### Decision Rules

| Scenario | Action |
| :-------- | :----- |
| User asks "How do I implement X?" | Invoke skill with pattern for X |
| User says "Check my PR" | Run Context Injector (git diff) → invoke pr-reviewer |
| User says "I want to plan feature" | Run Interactive Liaison (ask questions) → invoke planning-guide |
| User asks "What's in the toolkit?" | Scan skill descriptions → suggest top 3 |

## PATTERN: Autonomous Inference

### Step 1: Scan
Read `SKILL.md` frontmatter descriptions across the toolkit:
```yaml
name: skill-name
description: "Brief description. Use when [condition]. Keywords: [auto-discovery phrases]."
```

### Step 2: Match
Compare user's latest message against "Use when" conditions in descriptions.

### Step 3: Weight

| Match Confidence | Action |
| :--------------- | :------|
| > 80% | **Invoke immediately** |
| 50-80% | **Propose via text** ("I'll use [Skill] for this...") |
| < 50% | **Escalate to human** (Run Liaison or ask clarifying question) |

## PATTERN: The 3 Archetypes

### 1. Context Injector (Auto-Invocable)

Uses `!` or `@` to dump runtime state into context.

**Frontmatter:** No special field needed (default auto-invocable)

**Example:**
```yaml
---
name: audit
description: "Review all components, architecture, or trust. Use when auditing project health. Keywords: review, audit, quality, components, architecture, trust, conciseness."
---
```

**Invocation:** Model can invoke autonomously to gather context.

### 2. Interactive Liaison (User-Invoked Only)

Uses `AskUserQuestion` to run L'Entonnoir before calling Engine.

**Frontmatter:**
```yaml
disable-model-invocation: true
```

**Example:**
```yaml
---
name: strategy-architect
description: "Create STRATEGY.md with dependency graph. Use when starting new projects or continuing from brief/roadmap. Includes dependency analysis and parallel execution planning. Not for simple tasks - use native planning."
disable-model-invocation: true
---
```

**Invocation:** Waits for human to invoke.

### 3. Atomic Macro (Auto-Invocable)

Utility shortcuts too simple for Skill folder structure.

**Characteristics:**
- 3-line prompt maximum
- High-frequency, low-complexity
- No references/ needed

**Example:**
```yaml
---
name: git-cleanup
description: "Delete local branches merged to main. Use when cleaning up repository. Not for remote branches."
---
```

## PATTERN: Routing Examples

### Example 1: Security Audit
```
User: "I want to make sure my project is secure."

Route:
1. intent-router scans → matches "security audit" → selects quality-standards
2. quality-standards invokes → runs security gate

Result: Skill invoked autonomously.
```

### Example 2: PR Review with Context
```
User: "Review my changes."

Route:
1. intent-router detects need for git diff → selects audit command
2. audit runs → injects `!git diff main...HEAD`
3. audit delegates → invokes pr-reviewer skill with diff context

Result: Command gathers context → Skill analyzes.
```

### Example 3: New Feature Planning
```
User: "I have an idea for a new feature."

Route:
1. intent-router detects ambiguity → selects strategy:architect
2. strategy:architect has disable-model-invocation: true
3. User invokes → Liaison runs L'Entonnoir questions
4. Liaison compiles intent → invokes planning-guide

Result: Human negotiation first → Engine executes.
```

## Recognition Questions

| Question | Check |
| :------- | :---- |
| Task mapped to skill or command? | Yes, specific component selected |
| Confidence > 50%? | Yes, or escalated |
| Context Injector used when needed? | Yes, for runtime state |
| Liaison used when ambiguous? | Yes, for unclear intent |

---

<critical_constraint>
**Task-First Routing:**

NEVER ask "Which skill should I use?" Provide options that represent the TASK, not the tool:

❌ Wrong: "Should I use skill-security or quality-standards?"
✅ Correct: "Do you want to audit security, or review overall code quality?"

NEVER invoke a Liaison for clear intent. Only escalate when match < 50%.
</critical_constraint>
