---
name: refine-prompts
description: "Refine vague or unclear prompts into precise, actionable instructions using L1/L2/L3/L4 methodology"
user-invocable: true
---

# Prompt Refinement Expert

Think of prompt refinement as **distilling muddy water**—filtering out the mud (fluff, vagueness) while preserving the pure essence (constraints, context, goals) to create crystal-clear instructions.

## Core Methodology

**FROM_SCRATCH method**: Convert user's goal/topic into outcome + minimal context + hard constraints
**REFINE method**: Delete fluff, keep only constraints that actually change the answer

**Default**: Produce prompts as a single plain-text paragraph (no Markdown)
**Escalate**: Use keypoints (L3) and templates (L4) only when justified

## Recognition Patterns

**When to use refine-prompts:**
```
✅ Good: "Make this prompt clearer"
✅ Good: "Refine these instructions"
✅ Good: "Convert vague request to actionable"
❌ Bad: Already precise prompts
❌ Bad: Simple tool requests

Why good: Prompt refinement transforms unclear requests into structured, actionable instructions.
```

**Pattern Match:**
- User mentions "refine", "clarify", "make better"
- Vague or unclear instructions
- Need structured, actionable format

**Recognition:** "Do you need to transform vague prompts into precise instructions?" → Use refine-prompts.

## Non-Negotiables to Preserve

**Always keep:**
- Tech stack/platform/environment constraints
- Forbidden approaches ("no external deps", "no web calls")
- Compliance requirements
- Hard output format requirements (must be JSON / must be ≤N words)
- Measurable success targets (latency, accuracy, coverage)

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

## Critical Rules

- **Output ONLY the refined prompt** - never the methodology
- **Use L4 template** only for complex or reusable scenarios
- **Maintain all non-negotiable constraints** from original input
- **Ask at most ONE question** if ambiguity blocks producing useful refinement

**Contrast:**
```
✅ Good: Output L1→L2→L3→L4→Rationale format
✅ Good: Remove fluff, keep constraints that change answers
❌ Bad: Include methodology explanation in output
❌ Bad: Use L4 when simple prompt

Why good: Structured output ensures clarity while maintaining efficiency.
```

**Recognition:** "Does this refinement provide clear, actionable instructions?" → Check: 1) L1 outcome statement, 2) L2 context with constraints, 3) L3 structure, 4) L4 template if needed.

**For additional examples:**
- `examples/basic-usage.md` - Simple refinement patterns
- `examples/l1-l4-output-examples.md` - Full L1-L4 format examples
