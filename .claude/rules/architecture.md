# Architecture: The Navigator's Map

**The "Map" for where information lives - Cognitive Load Management through Progressive Disclosure**

This document defines the structural patterns for building components. It covers how to format content (UHP), how to organize information (Progressive Disclosure), how to interact with users (L'Entonnoir), and how to structure complete capability packages (Rooter Pattern).

**Philosophy**: Architecture is the Map, not the Script. We provide well-organized information so intelligent agents can make their own decisions about how to reach the goal.

---

## The Unified Hybrid Protocol (UHP)

**The Standard:** XML for the Machine (Control), Markdown for the Human (Content), State for Interaction.

### The Principle: Architecting Latent Space

This protocol implements a **3-Layer Architecture** that combats Context Rot through Latent Space Segmentation:

- **Layer 1: Control Plane (XML)** - Steering, constraints, rules, patterns → Creates "Attention Sinks"
- **Layer 2: Data Plane (Markdown)** - Content inside XML tags → Token density (45% savings vs pure XML)
- **Layer 3: Interaction Plane (State)** - State transitions, schema definitions → Cognitive flow management

**Research Benefits:**

- **15% performance boost** on Claude when XML is used for steering/instructions
- **45% token savings** when Markdown is used inside XML tags (vs pure XML)
- **Semantic Anchors** combat "Context Rot" - tags remain visible even in "Lost in the Middle" scenarios
- **Attention Sinks** - XML tags create high-signal anchors that the model can "latch onto" during generation

**Why XML Creates Attention Sinks:**

XML tags are distinct, high-contrast markers in the token stream. When a model processes a 100K token context:

- Plain text blends together (low contrast)
- XML tags stand out (high contrast)
- The model can "jump" to these anchors during generation

**Example:**

- Without XML: "Always validate before save. Never skip tests. Ensure quality..." (blends in)
- With XML: `<critical_constraint>ALWAYS validate before save</critical_constraint>` (stands out)

---

## Layer 1: Control Plane (XML) - The Attention Sinks

**Purpose:** Create semantic anchors that "steer" the model's attention. These are your "high-signal" tokens.

### Standard Control Plane Tags

| Tag                     | Purpose                                  | Example                                                                  |
| ----------------------- | ---------------------------------------- | ------------------------------------------------------------------------ |
| `<mission_control>`     | Top-level objective and success criteria | `<mission_control>Create portable skill</mission_control>`               |
| `<context_payload>`     | Wrapped data/state injection             | `<context_payload>[git diff output]</context_payload>`                   |
| `<interaction_schema>`  | State transition definitions             | `<interaction_schema>thinking → execution → output</interaction_schema>` |
| `<rule_category>`       | Wraps related guidelines                 | `<rule_category name="code_quality">`                                    |
| `<critical_constraint>` | High-priority inviolable rules           | `<critical_constraint>NEVER expose secrets</critical_constraint>`        |
| `<trigger>`             | Defines when a rule applies              | `<trigger>When writing TypeScript</trigger>`                             |
| `<pattern>`             | Implementation patterns                  | `<pattern name="progressive_disclosure">`                                |
| `<anti_pattern>`        | Anti-patterns with recognition           | `<anti_pattern name="command_wrapper">`                                  |
| `<router>`              | Complex branching logic                  | `<router>[Mermaid flowchart]</router>`                                   |

### When to Use Control Plane (XML)

**Use XML when:**

- Mission definition and success criteria
- Critical rules that must not be ignored
- Trigger conditions for rules
- Implementation patterns needing semantic anchoring
- Anti-patterns requiring recognition triggers

**Skip XML when:**

- Standard instructional prose
- Code examples and logs
- Tables and structured data
- Navigation and references

---

## Layer 2: Data Plane (Markdown) - Token Density

**Purpose:** Maximize information density for bulk content. Use Markdown as the default for content; wrap with XML only when semantic anchoring adds value.

### Default: Markdown Content

- **Lists**: `-` for bullet points, `1.` for numbered lists
- **Headers**: `#`, `##`, `###` for structure (no XML wrapper needed)
- **Tables**: For structured data comparisons
- **Code blocks**: ` ``` ` for code examples
- **Bold/Italic**: `**bold**`, `*italic*` for emphasis

### The 45% XML Tax: When to Pay It

**Use XML when**:

- Content is a non-negotiable rule or constraint
- Pattern needs semantic recognition triggers
- State transitions need clear boundaries
- Content must "pop" at bottom of file (recency bias)

**Skip XML when**:

- Standard instructional prose
- Code examples and logs
- Navigation and references
- Content that doesn't need special attention

**Rule of Thumb:** If it's "Data" → Markdown. If it's "Instruction" → XML.

**Example:**

Inefficient (paying tax unnecessarily):

```xml
<instructions>
## Step 1
Create the directory structure
## Step 2
Create the SKILL.md file
</instructions>
```

Efficient (default to markdown):

```markdown
## Step 1

Create the directory structure

## Step 2

Create the SKILL.md file
```

Only wrap when critical:

```xml
<critical_constraint>
ALWAYS validate before save
</critical_constraint>
```

---

## Layer 3: Interaction Plane (State) - Cognitive Flow

**Purpose:** Manage cognitive state transitions and schema definitions for complex reasoning tasks.

### State Management Tags

| Tag                    | Purpose                       | Example                                                                             |
| ---------------------- | ----------------------------- | ----------------------------------------------------------------------------------- |
| `<interaction_schema>` | Define state flow             | `<interaction_schema>thinking → planning → execution → output</interaction_schema>` |
| `<state_transition>`   | Mark state changes            | `<state_transition>from="thinking" to="execution"</state_transition>`               |
| `<thinking>`           | Internal reasoning sandbox    | `<thinking>[analysis here]</thinking>`                                              |
| `<execution_plan>`     | Action steps                  | `<execution_plan>[steps here]</execution_plan>`                                     |
| `<watchdog_report>`    | High-signal validation output | `<watchdog_report>[validation here]</watchdog_report>`                              |

### State Transition Flow

**Standard Reasoning Flow:**

1. `<thinking>` - Analyze constraints, identify approaches, weigh trade-offs
2. `</thinking>` - **Hard Stop** - State transition signal
3. `<execution_plan>` - Outline concrete steps
4. `</execution_plan>` - Transition to output
5. Output generation

**Why `</thinking>` as Hard Stop:**

- The closing tag signals "analysis complete, proceed to execution"
- Prevents "analysis paralysis" - infinite refinement loops
- Creates clear boundary between reasoning and action

---

## Recency Bias: The Final Token Rule

<critical_constraint>
**MANDATORY: All constraint-related content must be at the very bottom of files.**

**File Structure (Bottom = Highest Priority):**

1. Header (Identity/Trigger)
2. Body (Patterns, Examples, Data)
3. **Footer (Constraints & Rules)** ← Place non-negotiable rules here

**What belongs in the footer:**

- `<critical_constraint>` - Non-negotiable rules (MUST, NEVER, MANDATORY)
- `<trigger>` - When this component applies
- `<success_criteria>` - How to verify completion
- Any content that must not be missed or forgotten

**Why this matters:**

- During generation, the last tokens in context are "freshest" in attention
- Critical rules buried in the middle get "Lost in the Middle"
- This is NOT aesthetic - it's cognitive architecture for reliability
- Human readers also scan bottom first for constraints
  </critical_constraint>

### Footer Template

```markdown
---

## Constraints & Rules

<trigger>When [specific condition]</trigger>

<success_criteria>

- [ ] Criterion 1
- [ ] Criterion 2
      </success_criteria>

<critical_constraint>
MANDATORY: [Critical Rule 1]
MANDATORY: [Critical Rule 2]
No exceptions. No "looks complete" rationalization.
</critical_constraint>
```

**All constraint-related content belongs at the very bottom.**

---

## When to Use Each Layer

| Use Case            | Layer             | Tag Example                                                       |
| ------------------- | ----------------- | ----------------------------------------------------------------- |
| Mission/Objective   | Control (XML)     | `<mission_control>Create portable skill</mission_control>`        |
| Critical rules      | Control (XML)     | `<critical_constraint>NEVER expose secrets</critical_constraint>` |
| Pattern definitions | Control (XML)     | `<pattern name="progressive_disclosure">`                         |
| State transitions   | Interaction (XML) | `<state_transition>thinking → execution</state_transition>`       |
| Reasoning sandbox   | Interaction (XML) | `<thinking>[analysis]</thinking>`                                 |
| Instructions        | Data (Markdown)   | `- Prefer interfaces over types`                                  |
| Examples            | Data (Markdown)   | `## Example\ninterface User {...}`                                |
| Lists               | Data (Markdown)   | `- Item 1\n- Item 2`                                              |
| Tables              | Data (Markdown)   | `\| Header \|...`                                                 |

---

## Mandatory Structure for Components

**Layer 1: Control Plane**

- `<mission_control>` - Define objective and success criteria
- `<trigger>` - Define when this component applies
- Use XML tags for metadata and critical sections

**Layer 2: Data Plane**

- Use Markdown inside XML tags for content
- Keep prose in Markdown for flow
- Code examples in Markdown code blocks

**Layer 3: Interaction Plane**

- `<interaction_schema>` - Define state flow for reasoning tasks
- Use `<thinking>` for analysis sandbox
- Use state transitions to signal cognitive shifts

**Footer: Recency Bias**

- Place `<critical_constraint>` blocks at very bottom
- These are the final tokens - highest priority during generation

---

## UHP-Compliant Component Template

```markdown
# Component Name

<mission_control>
<objective>[What this component achieves]</objective>
<success_criteria>[How to verify success]</success_criteria>
</mission_control>

<trigger>When [specific condition]</trigger>

## Core Content

<pattern name="pattern_name">
  <principle>[Explanation of principle]</principle>
  <instructions>
    - Step 1
    - Step 2
    - Step 3
  </instructions>
  <example type="positive">
    ## Good Example
    [Concise example in Markdown]
  </example>
</pattern>

## Reasoning Process

<interaction_schema>
thinking → analysis → planning → execution → output
</interaction_schema>

<thinking>
[Task analysis and approach selection here]
</thinking>

<execution_plan>
[Concrete steps to execute]
</execution_plan>

---

## Absolute Constraints

<critical_constraint>
MANDATORY: [Non-negotiable rule 1]
MANDATORY: [Non-negotiable rule 2]
No exceptions. No "looks complete" rationalization.
</critical_constraint>
```

---

## Core Implementation Patterns

Generic patterns applicable across all components. Component-specific patterns live in their respective meta-skills.

### Progressive Disclosure

<pattern name="progressive_disclosure">
  <principle>Reveal complexity progressively. Core content for most users; details for specific cases.</principle>

  <recognition>
    Question: "Is this information required for the standard 80% use case?"
  </recognition>

  <instructions>
    - Keep in main content: Core content used 80% of the time
    - Move to references/: Specific case content used 20% of the time
  </instructions>

  <example type="positive">
    MANDATORY READ: references/advanced.md for edge cases
  </example>

  <example type="negative">
    [Pastes 500 lines of reference content directly in main document]
  </example>
</pattern>

### Self-Containment

<pattern name="self_containment">
  <principle>Components should work without depending on external files.</principle>

  <recognition>
    Question: "Would this component work in a project with zero rules dependencies?"
  </recognition>

  <instructions>
    - Include everything needed directly
    - Don't reference external files or directories
    - Bundle philosophy with component
  </instructions>

  <implementation>
    See component-specific meta-skills for self-containment patterns.
  </implementation>
</pattern>

### Clear Examples

<pattern name="clear_examples">
  <principle>Show, don't just tell. Users recognize patterns faster than they generate them from scratch.</principle>

  <recognition>
    Question: "Can users copy this example and use it immediately?"
  </recognition>

  <instructions>
    - Include concrete examples that users can copy
    - Show both positive and negative examples when helpful
    - Use real code, not pseudocode
  </instructions>
</pattern>

### Degrees of Freedom

<pattern name="degrees_of_freedom">
  <principle>Match specificity to how fragile the task is. Multiple valid approaches → high freedom. Fragile operations → low freedom.</principle>

  <recognition>
    Question: "What breaks if Claude chooses differently?" The more that breaks, the lower the freedom.
  </recognition>

  <instructions>
    - High freedom: Multiple valid approaches exist
    - Medium freedom: Some guidance needed
    - Low freedom: Fragile or error-prone operations
  </instructions>

  <implementation>
    See component-specific meta-skills for freedom level guidance.
  </implementation>
</pattern>

---

## Content Organization

### Single Source of Truth

**Each concept should be documented once:**

- Component-specific patterns → component's meta-skill
- Generic patterns → this file

**Question**: Is this concept already documented elsewhere? Cross-reference instead of duplicating.

### Reference Files

**Keep references clean:**

Tier 2 (SKILL.md) - Navigation:

```markdown
| If you are...           | Read...                               |
| ----------------------- | ------------------------------------- |
| Creating commands       | `references/executable-examples.md`   |
| Configuring frontmatter | `references/frontmatter-reference.md` |
```

Tier 3 (reference file):

```markdown
# Reference Title

[Content only - no meta-instructions about when to read]
```

**Question**: Does this reference explain why to read it? Remove meta-instructions.

---

## The Rooter Pattern: Complete Capability Packages

**The Rooter Pattern is the ultimate expression of High Trust** - you're treating the AI like a Senior Partner who needs a well-organized library, not a Script Interpreter who needs linear commands.

<pattern name="rooter_architecture">
  <principle>
    Provide a "Map" (Router) instead of a "Script" (Linear Instructions).
    This empowers the Agent to select the specific expertise needed for the task.
  </principle>

  <philosophy>
    **Rooter = Cognitive Load Management**

    When you provide a rigid 50-step linear list, you treat the AI like a "Script Interpreter" (Low Trust).
    When you provide a Rooter Pattern, you treat the AI like a "Senior Partner" who needs a well-organized library.

    **Rationale**: "We route to keep your context window pristine. A clean context = a smarter Agent."

  </philosophy>

  <workflow>
    1. **INTAKE**: Ask 1-3 batched questions to narrow intent (L'Entonnoir)
    2. **ROUTE**: Load the specific Workflow file based on user response
    3. **EXECUTE**: Apply expert patterns from the Reference tier
  </workflow>

  <implementation>
    See `/toolkit:rooter` command for creating complete capability packages.
  </implementation>
</pattern>

### Rooter Archetype Structure

A complete Rooter package contains multiple entry points:

| Component      | Purpose                        | When Used                    |
| -------------- | ------------------------------ | ---------------------------- |
| **Command**    | Quick intent invocation        | User knows what they want    |
| **Skill**      | Comprehensive domain knowledge | Deep understanding needed    |
| **Workflows**  | Guided step-by-step processes  | User needs hand-holding      |
| **References** | Expert patterns and examples   | AI needs technical specifics |
| **Examples**   | Working demonstrations         | Concrete validation needed   |

### Why Rooter is High Trust

1. **Freedom Preserved**: The AI decides _how_ to write code, solve bugs, implement features
2. **Clarity Maximized**: You're not giving "instructions" - you're providing "Domain Expertise" organized to respect context window
3. **Cognitive Load Managed**: Progressive disclosure keeps context window clean = smarter Agent

### Genetic Code Injection

Rooter components bundle their own philosophy for portability:

- **Condensed principles** in metadata section
- **Success Criteria** for self-validation
- **No external dependencies** - works in isolation

This "genetic code" ensures components survive being moved to any environment.

---

## L'Entonnoir Pattern: User Interaction Protocol

**Core Principle: L'Entonnoir (The Funnel) - Iterative Narrowing Through Intelligent Batching**

**Core principle**: Use multiple AskUserQuestion rounds to iteratively narrow the problem space. Each round batches 1-4 relevant questions based on current investigation. After each response, investigate further before the next round.

### The Funnel Flow

```
┌─────────────────────────────────────────────────────┐
│              ITERATIVE FUNNELING PATTERN            │
│                                                     │
│  Investigate → AskUserQuestion (batch Q1-Q3)        │
│       ↓                                            │
│  Analyze response → Narrow investigation            │
│       ↓                                            │
│  AskUserQuestion (batch Q4-Q5 based on previous)    │
│       ↓                                            │
│  Analyze response → Final investigation             │
│       ↓                                            │
│  AskUserQuestion (final confirmation Q6)            │
│       ↓                                            │
│  Execute                                            │
└─────────────────────────────────────────────────────┘
```

### Recognition Over Generation

Users recognize faster than they generate. Structure questions in each round for recognition.

**Recognition Question**: "Would the user need to think to answer this, or can they just recognize/validate?"

**Batching Principle**: Each AskUserQuestion call should batch 1-4 questions that:

- Share the same investigation context
- Are related to each other
- Can be answered together without additional context

### Intelligent Batching Per Round

**DO batch together:**

- Questions that share the same context/investigation phase
- Questions where earlier answers inform later options
- Questions about the same topic/decision area
- 2-4 questions max per AskUserQuestion call

**DON'T batch together:**

- Unrelated topics (database vs UI vs deployment)
- Questions that require separate investigation phases
- More than 4 questions in one call (overwhelming)

### Interleaving Investigation and Questions

After each AskUserQuestion response:

1. **Analyze answers** - What did the user tell us?
2. **Narrow investigation** - Use answers to focus next investigation
3. **Run targeted diagnostics** - Check specific things based on answers
4. **Determine next questions** - What else do we need to know?
5. **Ask again** - Batch next set of questions (1-4)
6. **Repeat** - Until ready to execute

### Question Structure Patterns

**Pattern 1: Broad → Specific → Action**

Round 1: Broad categorization
Round 2: Specific identification
Round 3: Action confirmation
Execute

**Pattern 2: Dependency Chain**

Round 1: "Q1: Language? Q2: Framework?"
Round 2: [Investigate based on language/framework] "Q3: Which [framework] library?"
Round 3: [Investigate library options] "Q4: Which version?"
Execute

**Pattern 3: Elimination**

Round 1: "Q1: Is it X, Y, or Z?"
Round 2: [Eliminate X based on investigation] "Q2: Is it Y or Z?"
Round 3: [Eliminate Y] "Q3: Confirm Z?"
Execute

### Anti-Patterns

**Anti-Pattern 1: Single-Question obsession**

Wrong: Asking one question per round-trip when 2-4 related questions exist

Right: Batch related questions

**Anti-Pattern 2: Over-batching**

Wrong: 5+ questions or unrelated topics
Right: 2-4 related questions per round

**Anti-Pattern 3: No Investigation Between Rounds**

Wrong: Ask → Ask → Ask without investigating
Right: Investigate → Ask → Investigate → Ask

### Context-Specific Patterns

**Debugging: Funneling to Root Cause**
Round 1: Symptom categorization
Round 2: Component identification
Round 3: Root cause confirmation
Round 4: Fix approach selection
Execute

**Feature Implementation: Requirements Gathering**
Round 1: Feature scope and priority
Round 2: Technical decisions (batch related)
Round 3: Edge cases and constraints
Round 4: Implementation approach
Execute

**Setup/Configuration: Layered Decisions**
Round 1: High-level architecture
Round 2: Specific technologies (batch by layer)
Round 3: Configuration values
Round 4: Confirmation
Execute

---

## Verification Checklist

Before finalizing any component, verify:

- [ ] **Header**: Has `<mission_control>` and `<trigger>` tags
- [ ] **Middle**: Bulk content in Markdown (Data Plane) inside XML
- [ ] **Footer**: `<critical_constraint>` at very bottom (Recency Bias)
- [ ] **State**: `<interaction_schema>` defined for reasoning tasks
- [ ] **Tags**: Using "Strong Tags" for Control Plane
- [ ] **Transitions**: `</thinking>` Hard Stop used before execution

---

## Linting Delegation

<critical_constraint>
MANDATORY: Code formatting and style are enforced by linters, not documentation.
</critical_constraint>

- **TypeScript/JavaScript**: Use project linter (ruff, eslint, biome)
- **Shell scripts**: Use shellcheck
- **Python**: Use ruff
- **Markdown**: Use project linter (markdownlint, textlint)

The hybrid format rules in this file cover **structure** (XML/Markdown separation), not code style. Code style is delegated to appropriate linters.

---

## Summary

**The L'Entonnoir Protocol:**

1. **Investigate** - Gather information
2. **Ask** - Batch 1-4 relevant questions based on investigation
3. **Analyze** - Use answers to narrow investigation scope
4. **Repeat** - Investigate → Ask until ready to execute
5. **Execute** - Complete the task

**Key distinctions:**

- **Multiple rounds encouraged** - Funnel toward execution efficiently
- **Batch intelligently per round** - Group related questions (1-4 max)
- **Interleave investigation** - Investigate between rounds, not just before first round
- **Recognition over generation** - Users select from options, don't generate from scratch

**Remember**: L'entonnoir (the funnel) - each round narrows the problem space through intelligent questioning and investigation.

---

<critical_constraint>
MANDATORY: Batch 1-4 related questions per AskUserQuestion call
MANDATORY: Investigate between rounds to narrow scope
MANDATORY: Use answers from previous rounds to inform next investigation
MANDATORY: Each round should funnel toward execution
MANDATORY: Critical constraints at bottom of files (recency bias)
MANDATORY: Use XML for control, Markdown for data
No exceptions. Efficient funneling through iterative narrowing.
</critical_constraint>
