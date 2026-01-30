---
name: discovery
description: "Conduct discovery interviews to gather requirements, clarify vague ideas, and create detailed specifications. Use when gathering requirements, clarifying vague ideas, or starting new projects. Includes interview guidance, requirement extraction, and specification templates. Not for execution, simple partial updates, or when requirements are already clear."
user-invocable: true
---

<mission_control>
<objective>Conduct discovery interviews to gather requirements, clarify vague ideas, and create detailed specifications through collaborative exploration.</objective>
<success_criteria>
- Ambiguity resolved via AskUserQuestion (2-4 options, recognition-based)
- Codebase context investigated using Explore agent before questioning
- Research loops executed for knowledge gaps with evidence synthesis
- Completeness checklist verified before spec generation
- Specification document created with all TBD items resolved
</success_criteria>
<semantic_anchors>
- **L'Entonnoir**: Sequential narrowing via 2-4 option batches, continuous exploration between questions
- **YAGNI**: Ruthless feature stripping, no speculative requirements
- **Evidence-Based**: Every claim requires file reads or WebSearch verification
</semantic_anchors>
</mission_control>

## Quick Start

Vague idea → Explore agent for context → AskUserQuestion (2-4 options) → Research gaps → Completeness check → Generate spec

## Navigation

| If you need... | Read this section... |
| :--- | :--- |
| Run discovery | ## Quick Start |
| L'Entonnoir pattern | ## Semantic Anchors |
| Spec template | resources/templates/ |
| Troubleshooting | ## Troubleshooting |
| Validation | ## Validation Checklist |

## Semantic Anchors

### L'Entonnoir (The Funnel)

Sequential narrowing pattern for resolving ambiguity:

```
AskUserQuestion (2-4 recognition-based options)
     ↓
User selects (no typing)
     ↓
Explore based on selection (continuous investigation)
     ↓
AskUserQuestion (narrower batch)
     ↓
Repeat until ready
```

**Key principles:**
- Recognition-based options — User selects, never generates
- Continuous exploration — Investigate at ANY time, not just between rounds
- Progressive narrowing — Each round reduces uncertainty
- Actionable tradeoffs — Options have clear implications

**Example:**
```
"What kind of data will you store?"
Options:
- "Simple key-value pairs" (fast, limited queries)
- "Complex relational data" (ACID, joins, schema)
- "Flexible documents" (JSON, schema-less)
- "Research options" (I'll investigate tradeoffs)
```

### YAGNI (You Aren't Gonna Need It)

Ruthless feature stripping. Before finalizing any requirement:

- Is this requirement actually requested?
- Can we deliver value without this?
- Is this speculation about future needs?

If "we might need this later" — remove it.

### Evidence-Based Discovery

Every claim requires verification:
- File reads for codebase patterns
- WebSearch/WebFetch for technology research
- No assumptions about user knowledge

## Discovery Flow

### 1. Initial Orientation (2-3 questions)

Understand project type and core problem. Explore agent should investigate codebase patterns first (git log, CLAUDE.md, existing architecture) to avoid asking about what already exists.

### 2. Targeted Exploration

Use Explore agent to investigate codebase. Ask targeted questions only where context is missing. Let project type determine focus:
- Backend → Data, scaling, integrations
- Frontend → UX, state, responsiveness
- CLI → Ergonomics, composability
- Mobile → Offline, platform, permissions

**Knowledge gap signals**: User says "I think...", "Maybe...", technology buzzwords without context, solution instead of problem.

### 3. Research Loops (Optional)

Offer research when:
- User shows uncertainty
- Technologies are unfamiliar
- Tradeoffs aren't obvious

```
"You mentioned real-time updates. Several approaches exist with different tradeoffs. Would you like me to research this?"
```

If yes: WebSearch/WebFetch → Summarize → Return with informed questions

### 4. Conflict Resolution

Surface impossible requirements explicitly:
```
"I noticed: You want [X] but also [Y]. These typically conflict because [reason]. Which is more important?"
```

Common conflicts: Simple AND feature-rich, Real-time AND cheap, Secure AND frictionless.

### 5. Completeness Check

Before writing spec, verify:

**Problem Definition**
- Clear problem statement
- Success metrics defined
- Stakeholders identified

**User Experience**
- User journey mapped
- Core actions defined
- Error states handled

**Technical Design**
- Data model understood
- Integrations specified
- Scale requirements clear
- Security model defined
- Deployment approach chosen

**Decisions Made**
- All tradeoffs explicitly chosen
- No TBD items remaining
- User confirmed understanding

### 6. Spec Generation

Summarize understanding first, then generate spec to file using template from `resources/templates/`.

## Troubleshooting

| Symptom | Solution |
| :--- | :--- |
| Questions too vague | Narrow to specific domain |
| "I don't know" | Offer options with tradeoffs |
| "I think..." / "Maybe..." | Probe deeper, offer research |
| "Just simple X" | Challenge - define what simple means |
| Solution instead of problem | "What problem does this solve?" |
| "Whatever you think" | That's uncertainty, not delegation |
| Long pauses, short answers | Simplify questions, batch less |

## Research Triggers

Offer research when user:
- "I've heard X is good" → Research X vs alternatives
- "We use Y but I'm not sure" → Research Y capabilities
- Technology mismatch detected → Research correct approaches

## Question Best Practices

**DO:**
- Use AskUserQuestion for ambiguity, not question counts
- Present 2-4 recognition-based options
- Include "I'm not sure" and "Research this" options
- Explore codebase first, ask what's different

**DON'T:**
- Ask "What database?" (assumes knowledge) → Ask "What kind of data?"
- Force questions when answer exists in codebase
- Accept solution descriptions ("Build React app") → Focus on problem
- Accept "whatever you think" as delegation

## Validation Checklist

Before claiming discovery complete:

- [ ] User intent is clear and documented
- [ ] Core problem statement defined
- [ ] Success metrics established
- [ ] Existing codebase patterns investigated
- [ ] Technical constraints identified
- [ ] All significant decisions documented
- [ ] No critical TBD items remaining
- [ ] Spec generated to file
- [ ] User confirmed understanding

---

## Genetic Code

<critical_constraint>
**System Physics:**

1. Zero external dependencies for portable components
2. Achieve 80-95% autonomy (0-5 AskUserQuestion rounds per session)
3. Description uses What-When-Not-Includes format in third person
4. Semantic anchors inline as core content, not external references
5. XML for control (mission_control, critical_constraint), Markdown for data
</critical_constraint>

**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows
