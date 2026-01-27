---
name: brainstorm
description: Guided decision-making for complex problems with multiple variables. Investigate first, then use structured questions to help user recognize the right path. Not for simple tasks.
disable-model-invocation: false
---

# Brainstorm

Guided decision-making for complex problems using INVESTIGATE → ASK → REFLECT → REPEAT methodology.

## How It Works

Execute guided decision-making in four phases:

### Phase 1: INVESTIGATE
Use tools first, never ask blind:
- Read files, grep patterns, run commands
- Apply analytical frameworks
- Map the full possibility space

**Investigation Matrix:**

| Type | Tools | What to Find |
|------|-------|--------------|
| Context | `Read`, `Grep` | Existing code, configuration, documentation |
| Structure | `Glob`, `Grep` | File patterns, architecture, dependencies |
| State | `Bash` | Running processes, errors, logs, environment |
| History | `Bash` (git log) | Recent changes, commit patterns |
| Analysis | Apply frameworks | Variables, constraints, stakeholders |

**Recognition test:** "Could I find this with tools instead of asking?"

### Phase 2: ASK
Use AskUserQuestion iteratively:
- Single-choice or multiple-choice questions
- ONE question at a time
- Recognition-based: user recognizes, doesn't generate
- Each question eliminates a large problem space

**High-quality questions (use these):**
- "I've analyzed [evidence]. Which pattern matches?"
- "Based on investigation, issue appears to be X, Y, or Z. Which resonates?"
- "Which constraint feels most binding right now?"

**Low-quality questions (avoid these):**
- "What do you think is wrong?" ❌
- "How should we approach this?" ❌
- "What's the best solution?" ❌

### Phase 3: REFLECT
Mirror back what you're learning:
- "So what I'm hearing is..."
- "Based on our exploration, the pattern seems to be..."
- Help user see their own thinking clarified

### Phase 4: REPEAT
Continue until convergence:
- User recognizes their path
- Decision becomes clear
- User states what they want to do

## Critical Principles

### Investigate First, Never Ask Blind
Before asking anything, gather information using tools.

### Recognition Over Generation
Structure questions so users recognize, not generate.

### One Question at a Time
Each question must eliminate a massive section of the problem space.

**Wrong:** Stack multiple questions
```
"Is it frontend or backend?"
"Is it the API or database?"
"Is it auth or data processing?"
```

**Right:** One comprehensive question
```
"I've traced the issue to three potential root causes. Which matches what you're observing?
1. Database timeout (errors in logs around 30s mark)
2. N+1 query pattern (specific endpoints slow, others fast)
3. Connection pool exhaustion (gradual slowdown over time)"
```

### User Owns the Decision
Guide; they decide. Help them think through it.

**Wrong:** Make recommendations
```
"I recommend we use Redux Toolkit." ❌
```

**Right:** Help them explore until it's obvious
```
"Based on our exploration: medium team, e-commerce domain, need for structure.
Given these constraints, which approach feels right?
1. Redux Toolkit with standard patterns
2. Zustand for simplicity
3. Something else" ✅
```

## Analytical Frameworks

Apply frameworks during investigation:

| Framework | Strategy | Use When |
|-----------|----------|----------|
| Root Cause (5 Whys) | Distinguish symptoms from systems | Debugging, recurring problems |
| Decision Tree | Evaluate options against criteria | Choice-based decisions |
| Constraint Mapping | Hard vs. soft constraints | Strategy, resource allocation |
| Stakeholder Analysis | Who is affected, what they want | Organizational decisions |
| Timeline Perspective | Immediate vs. short vs. long-term | Future impact analysis |
| Pareto (80/20) | Group by impact | Prioritization, triage |
| RICE Score | Reach, Impact, Confidence, Effort | Feature prioritization |
| First Principles | Strip away assumptions | Innovation, challenging conventions |

## Usage Checklist

**Before asking any question:**
- [ ] Have I used available tools to investigate?
- [ ] Can the user recognize the answer (not generate)?
- [ ] Does this eliminate a large problem space?
- [ ] Is this ONE question (not stacked)?
- [ ] Will the answer help us converge?

**Question design:**
- Use AskUserQuestion with single or multiple choices
- ONE question at a time
- Options include evidence from investigation
- Natural language, numbered options
- Always include escape option ("Something else")

**Reflection patterns:**
- "So what I'm hearing is..." (mirror back understanding)
- "Based on our exploration..." (synthesize findings)
- "Does this align, or should we explore further?" (validation)
- "What feels like the right next step?" (user decides)

**Binary tests:**
- "Multiple paths unclear?" → Use /brainstorm
- "Request already specific?" → Direct action, no brainstorming needed
- "Can I investigate this?" → Do that first

## Example Usage

**Context:** Working on a React app, user asks "Should we use Redux or Zustand?"

**Cycle 1: INVESTIGATE**
```
[Read package.json] → react, react-dom, no state library
[Glob src/components/] → 50+ components, nested props visible
[Read README.md] → E-commerce dashboard
[Scan recent commits] → Team of 3-4 developers
```

**Cycle 1: ASK**
```
"I've analyzed your codebase. For a 50+ component e-commerce dashboard with a small team,
what matters most for your state management choice?

1. Simplicity and quick setup (lighter learning curve, less boilerplate)
2. Structure and standardization (clear patterns, easier onboarding)
3. Something else is the priority"
```

**User selects:** "2"

**Cycle 2: INVESTIGATE**
```
[Inference] → Structure matters, team will grow, patterns help
[Analysis] → Redux Toolkit provides standardized patterns, RTK Query for server state
[Consideration] → Zustand simpler but less prescriptive
```

**Cycle 2: REFLECT**
```
"So structure is the priority. Given that:
- You have 50+ components and growing
- Team values standardized patterns
- E-commerce means significant server state

Redux Toolkit with RTK Query would give you the structure you're looking like:
- Prescriptive patterns (ducks, slices)
- Built-in data fetching
- Strong typing support

Does this align with what you had in mind, or should we explore tradeoffs further?"
```

**User:** "That sounds right"

**Cycle 3: REFLECT (convergence)**
```
"Great. So the path forward is Redux Toolkit with RTK Query.
Ready to implement, or do you want to explore any specific aspects first?"
```

## Integration

This command helps with decision points in workflows. After brainstorming:
- Use `/plan` for implementation planning
- Use `qa/code-review` for reviewing decisions
- Use `/tdd` for test-driven implementation
