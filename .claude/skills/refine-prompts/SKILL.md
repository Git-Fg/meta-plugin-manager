---
name: refine-prompts
description: "Refine vague or unclear prompts into precise, actionable instructions. Use when user asks to clarify or improve instructions or when input is vague. Includes L1/L2/L3/L4 methodology, context enrichment, and intent clarification. Not for already clear prompts, simple questions, or when user explicitly rejects refinement."
user-invocable: true
---

<mission_control>
<objective>Refine vague or unclear prompts into precise, actionable instructions using L1/L2/L3/L4 methodology.</objective>
<success_criteria>Prompt refined to appropriate L-level with sufficient context and clear intent</success_criteria>
</mission_control>

# Prompt Refinement

Refine vague or unclear prompts into precise, actionable instructions using L1/L2/L3/L4 methodology.

---

## Quick Start

**If you need simple clarification:** Use L1 → One-sentence outcome statement

**If you need context-rich refinement (most common):** Use L2 → Single paragraph with constraints woven in

**If you need structured, complex guidance:** Use L3 → Bulleted Task/Constraints/Output format

**If you need reusable patterns:** Use L4 → Template/framework format

**Why:** Matching refinement level to task complexity ensures clarity without token waste. L2 serves 80% of cases—default to it, escalate only when justified.

---

## The Path to High-Quality Prompts

<guiding_principles>

### 1. Match Complexity to Structure

Prompt structure should reflect task complexity. Simple tasks with complex templates waste tokens; complex tasks with simple prompts miss requirements.

**Select L-level by purpose:**

- **L1 (Single-sentence)**: Quick clarifications, straightforward outcomes
- **L2 (Context-rich paragraph)**: Default choice—balances clarity and efficiency
- **L3 (Structured bullets)**: Complex tasks with multiple constraints
- **L4 (Template/framework)**: Reusable patterns, repeatable workflows

**Why this works:** Right-sized structure ensures Claude understands requirements without over-constraining creativity or under-specifying deliverables.

### 2. Enrich Context, Reduce Ambiguity

Add relevant background, technical constraints, and success criteria. Context prevents wrong assumptions and reduces clarification rounds.

**Essential context elements:**

- Technical stack/platform/environment
- Forbidden approaches ("no external deps")
- Compliance requirements
- Output format specifications
- Measurable success targets

**Why this works:** Context acts as guardrails—Claude navigates within boundaries instead of guessing requirements.

### 3. Preserve What Matters, Delete What Doesn't

Keep only constraints that actually change the answer. Remove tone fluff, obvious best practices, and redundant examples.

**Keep these non-negotiables:**

- Tech stack/platform constraints
- Forbidden approaches
- Compliance requirements
- Hard output format (JSON, word limits)
- Measurable success targets

**Delete these inefficiencies:**

- Step-by-step instructions (Claude knows how to work)
- Tone guidance ("be professional," "be creative")
- Obvious best practices
- Redundant examples

**Why this works:** Minimal-yet-sufficient prompts achieve clarity with maximal efficiency. Every word should earn its place.

### 4. Specify Outputs Precisely

Define deliverables explicitly—format, structure, completeness. Ambiguous outputs produce ambiguous results.

**Output specification patterns:**

- "Complete deployable website with HTML/CSS/JS"
- "JSON array with objects containing id, name, timestamp"
- "≤500 words summary with key findings"
- "Unit tests achieving 90%+ coverage"

**Why this works:** Precise output specifications set clear expectations. Claude knows exactly what "done" looks like.

</guiding_principles>

---

## Navigation

| If you need...         | Read...                                   |
| :--------------------- | :---------------------------------------- |
| Understand L-levels    | ## Quick Start → L1/L2/L3/L4 descriptions |
| Core methodology       | ## Core Methodology                       |
| See refinement example | ## Example                                |
| Output format          | ## Execution Process → STEP 4: Deliver    |

## Operational Patterns

- **Tracking**: Maintain a visible task list for prompt refinement
- **Consultation**: Consult the user when L-level is unclear
- **Management**: Manage task lifecycle for context enrichment

---

## Core Methodology

**FROM_SCRATCH method**: Convert user's goal/topic into outcome + minimal context + hard constraints

**REFINE method**: Delete fluff, keep only constraints that actually change the answer

**Default**: Produce prompts as a single plain-text paragraph (L2 format)

**Escalate**: Use keypoints (L3) and templates (L4) only when justified

## Execution Process

**When user provides prompt to refine:**

### STEP 1: Parse Input

- Extract user's raw prompt text
- Determine if FROM_SCRATCH or REFINE scenario
- Identify missing context, constraints, or deliverables

### STEP 2: Apply Refinement

- **FROM_SCRATCH**: Convert goal → outcome + context + hard constraints
- **REFINE**: Remove step-by-step instructions, obvious best practices, tone fluff, redundant examples
- **Keep**: Only constraints that actually change the answer

### STEP 3: Structure Output

Generate exactly:

- **L1**: One-sentence outcome statement
- **L2**: Context-rich paragraph with constraints (no Markdown)
- **L3**: Structured bullets (Task/Constraints/Output)
- **L4**: Template/framework (only if complex/reusable)
- **Rationale**: 2-4 sentences explaining minimal-yet-sufficient approach

### STEP 4: Deliver

Output ONLY the refined prompt in the exact format:

```
L1: [outcome statement]
L2: [context-rich paragraph with constraints]
L3:
- **Task:** [description]
- **Constraints:** [key constraints]
- **Output:** [deliverables]
L4:
```

[TEMPLATE ONLY IF JUSTIFIED - use ```code blocks for templates]

```
Rationale: [2-4 sentences explaining approach]
```

## Example

**Input**: "Create a marketing website"

**Output:**

```
L1: Create a conversion-optimized landing page
L2: You are a senior web developer creating a high-converting landing page for [PRODUCT]. Focus on clear value proposition, social proof placement, and frictionless CTA design. Use modern CSS Grid/Flexbox layouts with mobile-first approach. Ensure WCAG 2.1 AA accessibility compliance. Prioritize page speed optimization and SEO fundamentals. Output a complete, deployable website with semantic HTML, optimized images, and conversion tracking setup.
L3:
- **Task:** Create landing page for [PRODUCT] with conversion optimization
- **Constraints:** Mobile-first responsive design; WCAG 2.1 AA accessibility; <3s load time; semantic HTML; SEO-ready
- **Output:** Complete deployable website with HTML/CSS/JS files + performance audit + accessibility report
L4:
```

# Landing Page Requirements

## Value Proposition

- [Clear benefit statement in headline]
- [Supporting subheading]
- [Visual hero element]

## Conversion Elements

- [Primary CTA placement]
- [Secondary CTA for hesitant users]
- [Social proof testimonials]

## Technical Specs

- Responsive breakpoints: 320px, 768px, 1024px
- Performance budget: <150KB total, <3s load
- Accessibility: WCAG 2.1 AA checklist

```
Rationale: The refined prompt provides clear technical constraints (mobile-first, WCAG compliance, performance budget) while maintaining creative flexibility. The L4 template ensures consistent deliverable structure across different landing pages while allowing product-specific customization.
```

## Execution Best Practices

**Deliver clean, focused output:**

- Output ONLY the refined prompt—never methodology explanations
- Use L4 templates only for complex or reusable scenarios
- Maintain all non-negotiable constraints from original input
- Ask at most ONE question if ambiguity blocks producing useful refinement

**Pattern contrast:**

```
Good: Output L1→L2→L3→L4→Rationale format
Good: Remove fluff, keep constraints that change answers
Bad: Include methodology explanation in output
Bad: Use L4 when simple prompt suffices
```

**Validation check:** Refinement succeeds when it includes: 1) L1 outcome statement, 2) L2 context with constraints, 3) L3 structure, 4) L4 template if needed, 5) Clear rationale.

---

<critical_constraint>
**Portability Invariant:**

This component must work standalone with zero external dependencies. All necessary philosophy and patterns are contained within.
</critical_constraint>
