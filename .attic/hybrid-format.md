# Rule: Unified Hybrid Protocol (UHP) - 3-Layer Architecture

**The Standard:** XML for the Machine (Control), Markdown for the Human (Content), State for Interaction.

---

## The Principle: Architecting Latent Space

<thinking*protocol>
<principle>
This protocol implements a **3-Layer Architecture** that combats Context Rot through Latent Space Segmentation: - **Layer 1: Control Plane (XML)** - Steering, constraints, rules, patterns → Creates "Attention Sinks" - **Layer 2: Data Plane (Markdown)** - Content \_inside* XML tags → Token density (45% savings vs pure XML) - **Layer 3: Interaction Plane (State)** - State transitions, schema definitions → Cognitive flow management
</principle>

<research_benefit> - **15% performance boost** on Claude when XML is used for steering/instructions - **45% token savings** when Markdown is used inside XML tags (vs pure XML) - **Semantic Anchors** combat "Context Rot" - tags remain visible even in "Lost in the Middle" scenarios - **Attention Sinks** - XML tags create high-signal anchors that the model can "latch onto" during generation
</research_benefit>

<teaching_logic>
**Why XML Creates Attention Sinks:**

    XML tags are distinct, high-contrast markers in the token stream. When a model processes a 100K token context:
    - Plain text blends together (low contrast)
    - XML tags stand out (high contrast)
    - The model can "jump" to these anchors during generation

    **Example:**
    Without XML: "Always validate before save. Never skip tests. Ensure quality..." (blends in)
    With XML: `<critical_constraint>ALWAYS validate before save</critical_constraint>` (stands out)

    **The 45% XML Tax:**
    Every XML tag costs tokens. Use them strategically:
    - **Control Layer**: Pay the tax for steering (worth it)
    - **Data Layer**: Use Markdown for bulk content (avoid tax)
    - **Calculate**: If section is "Data" (examples, code, logs), use Markdown. If "Instruction" (rules, constraints), use XML.

</teaching_logic>
</thinking_protocol>

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
| `<thinking_protocol>`   | Reasoning process documentation          | `<thinking_protocol><process>...</process></thinking_protocol>`          |
| `<router>`              | Complex branching logic                  | `<router>[Mermaid flowchart]</router>`                                   |

### When to Use Control Plane (XML)

<rule_category name="xml_control_plane_usage">
<use_case>
<scenario>Mission definition and success criteria</scenario>
<example><mission_control>Create portable, self-sufficient component</mission_control></example>
</use_case>

<use_case>
<scenario>Critical rules that must not be ignored</scenario>
<example><critical_constraint>ALWAYS validate before save</critical_constraint></example>
</use_case>

<use_case>
<scenario>Trigger conditions for rules</scenario>
<example><trigger>When handling PII data</trigger></example>
</use_case>

<use_case>
<scenario>Implementation patterns needing semantic anchoring</scenario>
<example><pattern name="self_containment"></pattern></example>
</use_case>

<use_case>
<scenario>Anti-patterns requiring recognition triggers</scenario>
<example><anti_pattern name="command_wrapper"></anti_pattern></example>
</use_case>
</rule_category>

---

## Layer 2: Data Plane (Markdown) - Token Density

**Purpose:** Maximize information density for bulk content. Use Markdown as the default for content; wrap with XML only when semantic anchoring adds value.

### Default: Markdown Content

- **Lists**: `-` for bullet points, `1.` for numbered lists
- **Headers**: `#`, `##`, `###` for structure (no XML wrapper needed)
- **Tables**: For structured data comparisons
- **Code blocks**: ` ``` ` for code examples
- **Bold/Italic**: `**bold**`, `*italic*` for emphasis

### When to Add XML Wrapper

<pattern name="xml_wrapper_decision">
<use_xml_wrapper>
- Critical constraints that need attention anchoring
- Patterns requiring semantic recognition
- Triggers with specific activation conditions
- State transitions needing clear boundaries
</use_xml_wrapper>

<skip_xml_wrapper>

- Standard instructional prose
- Code examples and logs
- Tables and structured data
- Navigation and references
  </skip_xml_wrapper>
  </pattern>

### The 45% XML Tax: When to Pay It

<pattern name="xml_tax_calculation">
  <principle>XML adds tokens but provides semantic anchoring. Default to markdown.</principle>

  <benefit>
    - **Attention Anchoring**: XML tags create high-contrast markers that stand out in long contexts
    - **Recency Bias Advantage**: Critical constraints at bottom get maximum visibility
    - **Cognitive Clarity**: Clear boundaries between instruction and data
  </benefit>

  <cost>
    - **Token Overhead**: Every XML tag pair costs ~15-20 tokens
    - **Context Rot Risk**: Excessive XML wrapping fills context with structural noise
    - **Cognitive Load**: More tags = more parsing = reduced signal-to-noise
  </cost>

<decision_guide>
**Use XML when**: - Content is a non-negotiable rule or constraint - Pattern needs semantic recognition triggers - State transitions need clear boundaries - Content must "pop" at bottom of file (recency bias)

    **Skip XML when**:
    - Standard instructional prose
    - Code examples and logs
    - Navigation and references
    - Content that doesn't need special attention

</decision_guide>

<calculation_example>
Inefficient (paying tax unnecessarily):
<instructions>

## Step 1

Create the directory structure

## Step 2

Create the SKILL.md file
</instructions>

Efficient (default to markdown):

## Step 1

Create the directory structure

## Step 2

Create the SKILL.md file

Only wrap when critical:
<critical_constraint>
ALWAYS validate before save
</critical_constraint>
</calculation_example>
</pattern>

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

<interaction_schema>
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
  </interaction_schema>

---

## Recency Bias: The Final Token Rule

<critical_constraint>
**MANDATORY: All constraint-related content must be at the very bottom of files.**

**Recency Bias Layout Rule:**

Models exhibit "recency bias" - recent tokens have higher activation during generation.

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

<rule_category name="component_mandatory_structure">
<layer_1_control_plane> 1. `<mission_control>` - Define objective and success criteria 2. `<trigger>` - Define when this component applies 3. Use XML tags for metadata and critical sections
</layer_1_control_plane>

<layer*2_data_plane> 1. Use Markdown \_inside* XML tags for content 2. Keep prose in Markdown for flow 3. Code examples in Markdown code blocks
</layer_2_data_plane>

<layer_3_interaction_plane> 1. `<interaction_schema>` - Define state flow for reasoning tasks 2. Use `<thinking>` for analysis sandbox 3. Use state transitions to signal cognitive shifts
</layer_3_interaction_plane>

<footer_recency_bias> 1. Place `<critical_constraint>` blocks at very bottom 2. These are the final tokens - highest priority during generation
</footer_recency_bias>
</rule_category>

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

## Anti-Patterns (What NOT to do)

<rule_category name="uhp_anti_patterns">
<anti_pattern name="xml_for_everything">
<definition>Wrapping all content in XML tags (paying 45% tax unnecessarily)</definition>
<recognition_trigger>
Question: "Am I wrapping standard instructions in <instructions> tags?"
</recognition_trigger>
<fix>
Use XML only for Control Plane (steering, constraints, patterns).
Use Markdown for Data Plane (content inside XML tags).
</fix>
</anti_pattern>

<anti_pattern name="markdown_for_critical_rules">
<definition>Critical constraints not at bottom, buried in bullets</definition>
<recognition_trigger>
Question: "Is this a MUST/NEVER rule NOT in the footer?"
</recognition_trigger>
<fix>
Use <critical_constraint> tags at very bottom of file.
XML anchors attention + Recency Bias = maximum visibility.
</fix>
</anti_pattern>

<anti_pattern name="missing_interaction_plane">
<definition>Complex reasoning tasks without state management</definition>
<recognition_trigger>
Question: "Does this task involve multiple steps or decisions?"
</recognition_trigger>
<fix>
Add <interaction_schema> and use <thinking> → <execution_plan> flow.
State transitions prevent analysis paralysis.
</fix>
</anti_pattern>

<anti_pattern name="mixed_data_and_instruction">
<definition>Pasting dynamic data directly in Markdown flow</definition>
<recognition_trigger>
Question: "Is this git diff, file content, or state data?"
</recognition_trigger>
<fix>
Always isolate dynamic data in <context_payload> tags.
Prevents confusion between instructions and data.
</fix>
</anti_pattern>
</rule_category>

---

## Semantic Anchoring Examples

### Example 1: Complete UHP Structure

```xml
<mission_control>
  <objective>Create portable authentication skill</objective>
  <success_criteria>Works without external dependencies</success_criteria>
</mission_control>

<trigger>When implementing user authentication</trigger>

<pattern name="pattern_based_auth">
  <principle>Use pattern matching instead of JWT for local CLI tools</principle>
  <instructions>
    - Validate triggers within skill
    - Use environment variables for secrets
    - Provide clear error messages
  </instructions>
</pattern>

<thinking>
  Task: Implement auth
  Constraints: Portable, zero external deps
  Approach: Pattern-based validation
  Selected: Trigger validation
</thinking>

<critical_constraint>
  MANDATORY: NEVER log secrets or tokens
  MANDATORY: ALWAYS validate before action
</critical_constraint>
```

### Example 2: State Management

```xml
<interaction_schema>
  thinking → diagnose → plan → execute → verify
</interaction_schema>

<thinking>
[Analyzing the problem...]
</thinking>

<state_transition>from="thinking" to="diagnose"</state_transition>

<diagnostic_matrix>
[Root cause analysis...]
</diagnostic_matrix>

<state_transition>from="diagnose" to="plan"</state_transition>

<execution_plan>
[Action steps...]
</execution_plan>
```

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

## Reference
