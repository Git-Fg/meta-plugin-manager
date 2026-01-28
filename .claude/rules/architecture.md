# Architecture: The Navigator's Map

**The "Map" for where information lives - Cognitive Load Management through Progressive Disclosure**

Think of this as the structural patterns for building components. We provide the architecture, you navigate the implementation.

---

## The Map vs Script Principle

**The Script (Low Trust):**

- "First create the directory. Then create the SKILL.md file. Then add frontmatter."
- Assumes the agent cannot manage basic operations
- Brittle—breaks when context shifts

**The Map (High Trust):**

- "Here is the directory structure, quality standards, and where patterns live."
- Respects the agent's capability to execute
- Flexible—adapts to context

**Core Principle:** Architecture provides the Map. The Agent remains the Pilot.

---

## The Unified Hybrid Protocol (UHP)

**The Standard:** XML for the Machine (Control), Markdown for the Human (Content), State for Interaction.

### The 3-Layer Architecture

| Layer                 | Purpose  | What It Does                                      |
| --------------------- | -------- | ------------------------------------------------- |
| **Control Plane**     | Steering | Creates "Attention Sinks" with semantic anchors   |
| **Data Plane**        | Content  | Maximizes token density (45% savings vs pure XML) |
| **Interaction Plane** | Flow     | Manages cognitive state transitions               |

**Why This Architecture Works:**

- **Attention Anchors**: XML tags create high-contrast markers in the token stream—the model can "jump" to these anchors during generation
- **Token Efficiency**: Markdown inside XML tags saves 45% of tokens compared to pure XML
- **Context Rot Prevention**: Tags remain visible even in "Lost in the Middle" scenarios

### The 45% XML Tax: When to Pay It

| Pay the Tax (Use XML)          | Skip the Tax (Use Markdown) |
| ------------------------------ | --------------------------- |
| Critical constraints           | Bulk data content           |
| Rules that must not be ignored | Informational prose         |
| State transitions              | Code examples and logs      |
| Semantic anchoring needed      | Tables and structured data  |

**Rule of Thumb:** If it's "Data" → Markdown. If it's "Instruction" → XML.

**Example:**

```
Inefficient: <instructions>## Step 1\nCreate directory</instructions>
Efficient: ## Step 1\nCreate directory

Only wrap when critical: <critical_constraint>ALWAYS validate before save</critical_constraint>
```

---

## Standard Tags Reference

### Control Plane (XML)

| Tag                     | Purpose                                  |
| ----------------------- | ---------------------------------------- |
| `<mission_control>`     | Top-level objective and success criteria |
| `<critical_constraint>` | High-priority inviolable rules           |
| `<trigger>`             | Defines when a rule applies              |
| `<pattern>`             | Implementation patterns                  |
| `<anti_pattern>`        | Anti-patterns with recognition triggers  |
| `<rule_category>`       | Wraps related guidelines                 |
| `<context_payload>`     | Wrapped data/state injection             |
| `<router>`              | Complex branching logic                  |

### Interaction Plane (XML)

| Tag                    | Purpose                      |
| ---------------------- | ---------------------------- |
| `<interaction_schema>` | State transition definitions |
| `<thinking>`           | Internal reasoning sandbox   |
| `<execution_plan>`     | Action steps                 |
| `<state_transition>`   | Mark state changes           |

---

## The Rooter Pattern: Complete Capability Packages

<mission_control>
<objective>Provide a Router (Map) that empowers agents to select specific expertise</objective>
<success_criteria>Components organized for cognitive load management, not linear scripting</success_criteria>
</mission_control>

A **Rooter** is a complete capability package with multiple entry points:

```
my-rooter/
├── command.md              → Quick intent-based invocation
├── skill/
│   └── SKILL.md            → Domain logic and patterns
├── workflows/
│   ├── workflow-1.md       → Guided step-by-step processes
│   └── workflow-2.md
├── references/             → Detailed documentation
├── examples/               (optional) → Working demonstrations
└── scripts/                (optional) → Automation scripts
```

### Why Rooter is High Trust

1. **Freedom Preserved**: The AI decides how to solve problems
2. **Clarity Maximized**: You're providing organized expertise, not linear commands
3. **Cognitive Load Managed**: Progressive disclosure keeps context window clean

### The Rooter Workflow

| Phase       | Purpose                                                  |
| ----------- | -------------------------------------------------------- |
| **Intake**  | Ask 1-3 batched questions to narrow intent (L'Entonnoir) |
| **Route**   | Load the specific Workflow based on user response        |
| **Execute** | Apply expert patterns from the Reference tier            |

---

## L'Entonnoir: The Funnel Pattern

<mission_control>
<objective>Iteratively narrow problem space through intelligent batching</objective>
<success_criteria>Multiple rounds, each funneling toward execution</success_criteria>
</mission_control>

### The Core Principle

Users recognize faster than they generate. Structure questions for recognition, not creation.

### The Funnel Flow

```
AskUserQuestion (batch of 2-4 options, recognition-based)
     ↓
User selects from options (no typing)
     ↓
Explore based on selection → AskUserQuestion (narrower batch)
     ↓
Repeat until ready → Execute
```

### Key Principles

**Continuous Exploration:**

- Investigate at ANY time - before first question, between questions, during questions
- Don't wait for user response to explore context
- Exploration informs the NEXT question, not waits for it

**Actionable Questions:**

- Every question offers 2-4 options (recognition-based)
- User selects, never types free-form text
- Options should narrow scope (funnel effect)

**Efficient Funneling:**

- Each round reduces uncertainty
- Questions build on previous context
- Exit to execution when scope is clear

### Batching Guidelines

**DO batch together:**

- Questions sharing the same context
- Questions where earlier answers inform later options
- Questions about the same topic/decision area
- 2-4 questions max per call

**DON'T batch together:**

- Unrelated topics
- Questions requiring separate investigation phases
- More than 4 questions (overwhelming)

### Question Structure Patterns

| Pattern                       | Flow                                                |
| ----------------------------- | --------------------------------------------------- |
| **Broad → Specific → Action** | Categorize → Identify → Confirm → Execute           |
| **Dependency Chain**          | Q1: Language? Q2: Framework? Q3: Library? → Execute |
| **Elimination**               | Q1: X/Y/Z? Q2: Y/Z? Q3: Confirm → Execute           |

---

## Progressive Disclosure

Think of information architecture as cognitive load management:

| Tier       | Content                            | Tokens        |
| ---------- | ---------------------------------- | ------------- |
| **Tier 1** | YAML metadata (What-When-Not)      | ~100          |
| **Tier 2** | Core workflows, mission, patterns  | 1.5k-2k words |
| **Tier 3** | Deep patterns, API specs, examples | Unlimited     |

**Principle:** Keep Tier 2 lean. Move detailed content to references/.

### Reference File Structure

**Tier 2 (navigation only):**

```
| If you are...           | Read...                               |
| ----------------------- | ------------------------------------- |
| Creating commands       | references/executable-examples.md     |
| Configuring frontmatter | references/frontmatter-reference.md   |
```

**Tier 3 (content only):**

```markdown
# Reference Title

[Content only - no meta-instructions about when to read]
```

---

## Recency Bias: The Final Token Rule

<critical_constraint>
**Place all constraint-related content at the very bottom of files.**

Models attend more strongly to recent tokens during generation.
</critical_constraint>

**File Structure:**

1. Header (identity, mission, trigger)
2. Body (patterns, examples, data)
3. **Footer (constraints)** ← Highest priority

**What belongs in the footer:**

- `<critical_constraint>` - Non-negotiable rules
- `<trigger>` - When this component applies
- `<success_criteria>` - How to verify completion

---

## Component Template

```markdown
# Component Name

<mission_control>
<objective>[What this achieves]</objective>
<success_criteria>[How to verify]</success_criteria>
</mission_control>

<trigger>When [condition]</trigger>

## Core Content

[Patterns, examples, explanations in Markdown]

## Reasoning Process

<interaction_schema>
thinking → planning → execution → output
</interaction_schema>

<thinking>
[Analysis sandbox]
</thinking>

<execution_plan>
[Concrete steps]
</execution_plan>

---

## Absolute Constraints

<critical_constraint>
MANDATORY: [Non-negotiable rule 1]
MANDATORY: [Non-negotiable rule 2]
No exceptions.
</critical_constraint>
```

---

## Self-Containment: The Portability Invariant

<critical_constraint>
**Every component MUST work with zero .claude/rules dependencies.**

Components carry their own "genetic code" for context: fork isolation.
</critical_constraint>

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

## The Deprecation Protocol

<critical_constraint>
**When a component is retired, it must be archived, not just deleted.**
</critical_constraint>

### The Attic Pattern

1. **Use trash**: `trash component.md` (files go to OS trash, recoverable)
2. **Tag Formatting**: If keeping file, add `<deprecated>REASON</deprecated>` at top
3. **Update References**: Remove link from `CLAUDE.md` and indexes
4. **Clean Dependencies**: Remove unused dependencies it introduced

**Why**: Conserves history while cleaning the context window.

---

<critical_constraint>
MANDATORY: Use XML for control, Markdown for data
MANDATORY: Place critical constraints at bottom of files
MANDATORY: Batch 1-4 related questions per AskUserQuestion
MANDATORY: Investigate between rounds to narrow scope
MANDATORY: Keep Tier 2 lean, Tier 3 deep
MANDATORY: Every component MUST be self-contained
No exceptions. Architecture is the Map, not the Script.
</critical_constraint>
