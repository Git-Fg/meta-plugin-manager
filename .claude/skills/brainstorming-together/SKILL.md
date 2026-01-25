---
name: brainstorming-together
description: This skill should be used when users ask to "explore problems", "evaluate options", "reach actionable conclusions", "analyze complex decisions", or "brainstorm solutions" through the Guided Deductive Navigation methodology.
user-invocable: true
---

# Guided Deductive Navigation

Think of this as **navigating a maze with a map of ALL paths** instead of guessing which way to go. Instead of asking users to generate answers, systematically explore ALL possibilities and let users recognize the right path.

## Core Shift

**Old Way**: User thinks → AI questions → User explains more → AI reflects
**New Way**: AI maps ALL possibilities → User recognizes patterns → AI navigates → Action

## The Framework

Apply this methodology systematically:

1. **Deep Context Analysis** - Scan all information, identify variables, constraints, stakeholders
2. **Exhaustive Possibility Mapping** - Generate 3-4 distinct categories covering ALL possibilities
3. **Structured Hypothesis Generation** - Create specific hypotheses with evidence
4. **Iterative AskUserQuestion Navigation** - Ask ONE question at a time to drill down
5. **Convergence to Action** - Synthesize insights into specific recommendations

**Recognition:** "Is this a complex problem requiring systematic exploration?" → Use this framework.

## Recognition Patterns

**When to use brainstorming-together:**
```
✅ Good: "Should I refactor or rewrite this codebase?"
✅ Good: "My team velocity is low, what's causing it?"
✅ Good: "Which job offer should I take?"
❌ Bad: "Summarize these 3 documents"
❌ Bad: "Fix this specific error"

Why good: Complex decisions with multiple variables benefit from comprehensive mapping.
```

**Pattern Match:**
- User says "evaluate options", "explore problems", "analyze decisions"
- Multiple viable paths exist
- Unclear which direction to take
- Need to reach actionable conclusions

## The Interaction Loop

### Phase 1: Context Analysis
**Apply Deep Context Analysis**:
- Review all available information (files, history, user input)
- Identify problem type: Decision, Debugging, Strategy, Creative, Planning
- Map key variables, constraints, stakeholders, objectives

**AskUserQuestion Structure**:
"I've analyzed your situation. Are we facing a **Decision** (choosing between options), **Debugging** (identifying root cause), **Strategy** (planning approach), or **Creative** (generating new solutions)?"

### Phase 2: Possibility Mapping
**Generate 3-4 distinct categories** covering ALL possibilities:
- Apply analytical frameworks (Root Cause, Decision Tree, Constraint Mapping, Stakeholder Analysis, Timeline Perspective)
- Ensure categories are mutually exclusive and collectively exhaustive
- Include concrete evidence and context clues

**AskUserQuestion Structure**:
```
"I've mapped [number] comprehensive patterns covering ALL possibilities. Which aligns best?

1. [Category A - with specific evidence]
2. [Category B - with specific evidence]
3. [Category C - with specific evidence]
4. Something else entirely"
```

### Phase 3: Iterative Drilling
**Continue mapping based on selection**:
- Analyze user's selection as a constraint
- Generate next level of sub-possibilities
- Apply analytical frameworks to split remaining space
- Ask ONE question at a time

### Phase 4: Solution Synthesis
**Converge to actionable path**:
- Synthesize insights from navigation path
- Generate 2-3 specific, actionable recommendations
- Present as concrete next steps

**AskUserQuestion Structure**:
```
"Based on our path through [Category X] → [Sub-category Y], I see two targeted approaches:
1. **Approach 1**: [Specific action]
2. **Approach 2**: [Specific action]

Which feels more achievable?"
```

## Analytical Frameworks

Apply at least one framework to ensure comprehensive coverage:

1. **Root Cause Analysis** (debugging)
   - Technical factors (code, infrastructure)
   - Process factors (workflows, handoffs)
   - Human factors (skills, communication)
   - Environmental factors (timing, constraints)

2. **Decision Tree** (choice-based)
   - Evaluate all options against criteria
   - Map short vs. long-term implications
   - Include hidden costs and opportunity costs

3. **Constraint Mapping** (strategy)
   - Hard constraints (cannot change)
   - Soft constraints (negotiable)
   - Resources available (time, budget, people)

4. **Stakeholder Analysis** (organizational)
   - Who is affected (primary, secondary)
   - What do they want (stated vs. unstated)
   - What power/constraints do they have?

5. **Timeline Perspective** (future decisions)
   - Immediate (0-3 months)
   - Short-term (3-12 months)
   - Long-term (1-3 years)

## Quick Reference

**Before asking first question:**
- [ ] Deep context analysis completed
- [ ] Problem type identified
- [ ] At least one analytical framework selected
- [ ] Key variables mapped

**When generating options:**
- [ ] 3-4 distinct categories
- [ ] Mutually exclusive, collectively exhaustive
- [ ] Each option includes evidence
- [ ] "Something else" escape hatch provided

**For each AskUserQuestion:**
- [ ] ONE question at a time
- [ ] Options numbered clearly
- [ ] Natural, conversational language
- [ ] Evidence-based reasoning

**Recognition:** "Does this require comprehensive mapping?" → Use brainstorming-together. "Is the request already specific?" → Provide direct synthesis.

**For detailed examples and patterns:**
- `references/comprehensive-examples.md` - Full execution examples
- `references/analytical-frameworks.md` - Framework deep dives
- `references/question-patterns.md` - AskUserQuestion templates and variations
