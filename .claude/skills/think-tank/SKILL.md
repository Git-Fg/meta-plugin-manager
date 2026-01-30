---
name: think-tank
description: "Apply reasoning frameworks to any problem. Use when analyzing decisions, brainstorming solutions, identifying root causes, or thinking through tradeoffs. Includes 12 techniques: 5 Whys, Pareto, Inversion, SWOT, 10/10/10, The One Thing, Occam's Razor, Second Order, Eisenhower Matrix, Opportunity Cost, Via Negativa, First Principles."
---

<mission_control>
<objective>Route to optimal reasoning framework(s) and execute analysis for any problem</objective>
<success_criteria>Technique matched to intent, analysis applied, actionable insight delivered</success_criteria>
</mission_control>

## Quick Start

**If you need to analyze something:** State your problem → Technique selected → Analysis delivered.

**If unsure which to use:** State your problem → Best techniques proposed → You choose.

**If you want multiple approaches:** Request combination → Multiple analyses provided.

## Navigation

| If you need... | Read this section... |
| :------------- | :------------------- |
| Route to best technique | ## PATTERN: Intent Router |
| Ask which to use | ## PATTERN: Technique Proposer |
| Root cause analysis | ## PATTERN: 5 Whys |
| Vital few vs trivial many | ## PATTERN: Pareto |
| What would guarantee failure? | ## PATTERN: Inversion |
| Internal/external factors | ## PATTERN: SWOT |
| Time-horizon evaluation | ## PATTERN: 10/10/10 |
| Single leverage point | ## PATTERN: The One Thing |
| Simplest explanation | ## PATTERN: Occam's Razor |
| Consequences of consequences | ## PATTERN: Second Order |
| Urgent/important prioritization | ## PATTERN: Eisenhower Matrix |
| Tradeoff analysis | ## PATTERN: Opportunity Cost |
| Improve by removing | ## PATTERN: Via Negativa |
| Rebuild from fundamentals | ## PATTERN: First Principles |

---

## PATTERN: Intent Router

Analyze the user's input and map to the most relevant technique(s):

| User Intent | Best Technique |
| :---------- | :------------- |
| "Why is this happening?" / "Root cause" | 5 Whys |
| "What matters most?" / "Focus on what?" | Pareto |
| "What could go wrong?" / "Avoid failure" | Inversion |
| "Pros and cons" / "Strategic position" | SWOT |
| "How will I feel about this?" / "Long-term" | 10/10/10 |
| "What's the one thing?" / "Leverage point" | The One Thing |
| "Simplest explanation" / "What's really happening" | Occam's Razor |
| "And then what?" / "Long-term effects" | Second Order |
| "What should I do first?" / "Prioritize" | Eisenhower Matrix |
| "What am I giving up?" / "Cost of this choice" | Opportunity Cost |
| "What should I remove?" / "Simplify" | Via Negativa |
| "First principles" / "Fundamental truth" | First Principles |

### Routing Process

1. Extract intent from user input
2. Match against routing table
3. If single match → execute that technique
4. If multiple matches → propose via AskUserQuestion
5. If ambiguous → ask clarifying question

---

## PATTERN: Technique Proposer

When multiple techniques apply, present options to the user:

```markdown
Based on your question, these approaches seem most relevant:

1. **[Technique A]:** Brief description of what it does
2. **[Technique B]:** Brief description of what it does
3. **[Combine]:** Run both analyses together

Which approach would you like? Or specify a different technique.
```

**When to propose:**
- Multiple valid techniques exist for the intent
- User explicitly asks "what should I think about?"
- Analysis would benefit from complementary angles

---

## PATTERN: 5 Whys

Drill to root cause by asking "why" repeatedly.

<mission_control>
<objective>Move from symptoms to actionable root cause</objective>
<success_criteria>Root cause identified with specific intervention that prevents recurrence</success_criteria>
</mission_control>

### Process

1. State the problem clearly
2. Ask "Why does this happen?" → Answer 1
3. Ask "Why?" about Answer 1 → Answer 2
4. Ask "Why?" about Answer 2 → Answer 3
5. Continue until actionable root cause
6. Define intervention at the root level

### Output Format

**Problem:** [clear statement]

**Why 1:** [surface cause]
**Why 2:** [deeper cause]
**Why 3:** [even deeper]
**Why 4:** [approaching root]
**Why 5:** [root cause]

**Root Cause:** [the actual thing to fix]

**Intervention:** [specific action at root level]

### Success Criteria

- Each "why" digs genuinely deeper (not rephrasing)
- Stops at actionable root (not infinite regress)
- Intervention addresses root, not symptoms
- Prevents same problem from recurring

<critical_constraint>
MANDATORY: Each "why" must dig genuinely deeper
MANDATORY: Stop at actionable root
MANDATORY: Intervention must address root cause
No exceptions. The goal is prevention, not symptom management.
</critical_constraint>

---

## PATTERN: Pareto

Apply 80/20 rule to identify vital few factors.

<mission_control>
<objective>Identify vital few factors (~20%) that drive majority of results (~80%)</objective>
<success_criteria>High-impact factors separated from low-impact, clear focus recommendations</success_criteria>
</mission_control>

### Process

1. Identify all factors in scope
2. Estimate relative impact of each
3. Rank by impact (highest to lowest)
4. Identify cutoff where ~20% accounts for ~80%
5. Present vital few with specific actions
6. Note what can be deprioritized

### Output Format

**Vital Few (focus here):**

- Factor 1: [why it matters, specific action]
- Factor 2: [why it matters, specific action]
- Factor 3: [why it matters, specific action]

**Trivial Many (deprioritize):**

- Brief list of what can be deferred or ignored

**Bottom Line:**

Single sentence on where to focus effort for maximum results.

### Success Criteria

- Clearly separates high-impact from low-impact
- Provides specific, actionable recommendations
- Explains why each vital factor matters
- Gives clear direction on what to ignore

<critical_constraint>
MANDATORY: Separate vital few from trivial many based on impact
MANDATORY: Provide specific actionable recommendations
MANDATORY: Explain why each vital factor matters
Pareto analysis must drive clear prioritization.
</critical_constraint>

---

## PATTERN: Inversion

Solve backwards—what would guarantee failure?

<mission_control>
<objective>Identify failure modes and build success through avoidance</objective>
<success_criteria>Failure modes identified, avoidance strategies defined, clear boundaries established</success_criteria>
</mission_control>

### Process

1. State the goal or desired outcome
2. Invert: "What would guarantee I fail at this?"
3. List all failure modes (be thorough)
4. For each failure mode, identify avoidance strategy
5. Build success plan by systematically avoiding failure

### Output Format

**Goal:** [what success looks like]

**Guaranteed Failure Modes:**

1. [Way to fail]: Avoid by [specific action]
2. [Way to fail]: Avoid by [specific action]
3. [Way to fail]: Avoid by [specific action]

**Anti-Goals (Never Do):**

- [Behavior to eliminate]
- [Behavior to eliminate]

**Success By Avoidance:**

By simply not doing [X, Y, Z], success becomes much more likely because...

**Remaining Risk:**

[What's left after avoiding obvious failures]

### Success Criteria

- Failure modes are specific and realistic
- Avoidance strategies are actionable
- Surfaces risks that optimistic planning misses
- Creates clear "never do" boundaries

<critical_constraint>
MANDATORY: Identify specific, realistic failure modes
MANDATORY: Provide actionable avoidance strategies
MANDATORY: Establish clear "never do" boundaries
Inversion works by being thorough about what NOT to do.
</critical_constraint>

---

## PATTERN: SWOT

Map strengths, weaknesses, opportunities, threats.

<mission_control>
<objective>Map internal strengths/weaknesses and external opportunities/threats</objective>
<success_criteria>Factors correctly categorized, strategic moves developed, clear direction provided</success_criteria>
</mission_control>

### Process

1. Define the subject being analyzed
2. Identify internal strengths (advantages you control)
3. Identify internal weaknesses (disadvantages you control)
4. Identify external opportunities (favorable conditions you don't control)
5. Identify external threats (unfavorable conditions you don't control)
6. Develop strategies for each quadrant combination

### Output Format

**Subject:** [what's being analyzed]

**Strengths (Internal +)**

- [Strength]: How to leverage...

**Weaknesses (Internal -)**

- [Weakness]: How to mitigate...

**Opportunities (External +)**

- [Opportunity]: How to capture...

**Threats (External -)**

- [Threat]: How to defend...

**Strategic Moves:**

- **SO Strategy:** Use [strength] to capture [opportunity]
- **WO Strategy:** Address [weakness] to enable [opportunity]
- **ST Strategy:** Use [strength] to counter [threat]
- **WT Strategy:** Minimize [weakness] to avoid [threat]

### Success Criteria

- Correctly categorizes internal vs. external factors
- Strategic moves leverage quadrants together

<critical_constraint>
MANDATORY: Distinguish internal (controlled) from external (uncontrolled) factors
MANDATORY: Develop strategic moves for each quadrant combination
MANDATORY: Provide actionable mitigation/capture strategies
SWOT must lead to strategic clarity, not just categorization.
</critical_constraint>

---

## PATTERN: 10/10/10

Evaluate decisions across three time horizons.

<mission_control>
<objective>Evaluate decisions across immediate, medium-term, and long-term horizons</objective>
<success_criteria>Time conflicts revealed, long-term consequences made visceral, decision weighted by duration</success_criteria>
</mission_control>

### Process

1. State the decision clearly with options
2. For each option, evaluate impact at:
   - 10 minutes (immediate reaction)
   - 10 months (medium-term consequences)
   - 10 years (long-term life impact)
3. Identify where short-term and long-term conflict
4. Make recommendation based on time-weighted analysis

### Output Format

**Decision:** [what you're choosing between]

**Option A:**

- 10 minutes: [immediate feeling/consequence]
- 10 months: [medium-term reality]
- 10 years: [long-term impact on life]

**Option B:**

- 10 minutes: [immediate feeling/consequence]
- 10 months: [medium-term reality]
- 10 years: [long-term impact on life]

**Time Conflicts:**

[Where short-term pain leads to long-term gain, or vice versa]

**Recommendation:**

[Which option, weighted toward longer time horizons]

### Success Criteria

- Distinguishes temporary discomfort from lasting regret
- Reveals when short-term thinking hijacks decisions
- Makes long-term consequences visceral
- Helps overcome present bias

<critical_constraint>
MANDATORY: Evaluate each option at all three time horizons
MANDATORY: Identify where short-term and long-term interests conflict
MANDATORY: Weight decisions toward longer time horizons
10/10/10 exposes present bias by making future visceral.
</critical_constraint>

---

## PATTERN: The One Thing

Identify the single highest-leverage action.

<mission_control>
<objective>Identify the single highest-leverage action that makes everything else easier or unnecessary</objective>
<success_criteria>Genuine leverage point identified, causal chain explained, immediately actionable next step defined</success_criteria>
</mission_control>

### Process

1. Clarify the ultimate goal or desired outcome
2. List all possible actions that could contribute
3. For each action, ask: "Does this make other things easier or unnecessary?"
4. Identify the domino that knocks down others
5. Define the specific next action for that one thing

### Output Format

**Goal:** [what you're trying to achieve]

**Candidate Actions:**

- Action 1: [downstream effect]
- Action 2: [downstream effect]
- Action 3: [downstream effect]

**The One Thing:**

[The action that enables or eliminates the most other actions]

**Why This One:**

By doing this, [specific things] become easier or unnecessary because...

**Next Action:**

[Specific, concrete first step to take right now]

### Success Criteria

- Identifies genuine leverage point (not just important task)
- Shows causal chain (this enables that)
- Reduces overwhelm to single focus
- Next action is immediately actionable

<critical_constraint>
MANDATORY: Identify genuine leverage point
MANDATORY: Explain causal chain
MANDATORY: Define immediately actionable next step
The One Thing must reduce overwhelm to single focus.
</critical_constraint>

---

## PATTERN: Occam's Razor

Find the simplest explanation that fits all facts.

<mission_control>
<objective>Find simplest explanation that fits all facts with fewest assumptions</objective>
<success_criteria>All explanations enumerated, assumptions made explicit, unsupported assumptions eliminated</success_criteria>
</mission_control>

### Process

1. List all possible explanations or approaches
2. For each, count the assumptions required
3. Identify which assumptions are supported by evidence
4. Eliminate explanations requiring unsupported assumptions
5. Select the simplest that still explains all observed facts

### Output Format

**Candidate Explanations:**

1. [Explanation]: Requires assumptions [A, B, C]
2. [Explanation]: Requires assumptions [D, E]
3. [Explanation]: Requires assumptions [F]

**Evidence Check:**

- Assumption A: [supported/unsupported]
- Assumption B: [supported/unsupported]
  ...

**Simplest Valid Explanation:**

[The one with fewest unsupported assumptions]

**Why This Wins:**

[What it explains without extra machinery]

### Success Criteria

- Enumerates all plausible explanations
- Makes assumptions explicit and countable
- Distinguishes supported from unsupported
- Doesn't oversimplify (must fit ALL facts)

<critical_constraint>
MANDATORY: Enumerate all plausible explanations
MANDATORY: Make assumptions explicit and countable
MANDATORY: Eliminate explanations requiring unsupported assumptions
Simplest must still explain ALL observed facts.
</critical_constraint>

---

## PATTERN: Second Order

Think through consequences of consequences.

<mission_control>
<objective>Trace causal chains beyond immediate effects</objective>
<success_criteria>Chain traced to second/third order, delayed consequences identified, revised assessment provided</success_criteria>
</mission_control>

### Process

1. State the action or decision
2. Identify first-order effects (immediate, obvious)
3. For each first-order effect, ask "And then what happens?"
4. Continue to third-order if significant
5. Identify delayed consequences that change the calculus
6. Assess whether the action is still worth it

### Output Format

**Action:** [what's being considered]

**First-Order Effects:** (Immediate)

- [Effect 1]
- [Effect 2]

**Second-Order Effects:** (And then what?)

- [Effect 1] → leads to → [Consequence]
- [Effect 2] → leads to → [Consequence]

**Third-Order Effects:** (And then?)

- [Key downstream consequences]

**Delayed Consequences:**

[Effects that aren't obvious initially but matter long-term]

**Revised Assessment:**

After tracing the chain, this action [is/isn't] worth it because...

### Success Criteria

- Traces causal chains beyond obvious effects
- Identifies feedback loops and unintended consequences
- Reveals delayed costs or benefits
- Distinguishes actions that compound well from those that don't

<critical_constraint>
MANDATORY: Trace beyond first-order effects ("And then what?")
MANDATORY: Identify delayed consequences that change calculus
MANDATORY: Assess whether action is worth it after full chain analysis
Second-order thinking reveals unintended consequences.
</critical_constraint>

---

## PATTERN: Eisenhower Matrix

Prioritize by urgent/important.

<mission_control>
<objective>Categorize tasks by urgent/important for clear prioritization</objective>
<success_criteria>All items placed in correct quadrants with specific actions for each</success_criteria>
</mission_control>

### Process

1. List all tasks, decisions, or items in scope
2. Evaluate each on two axes:
   - Important: Contributes to long-term goals/values
   - Urgent: Requires immediate attention, has deadline pressure
3. Place each item in appropriate quadrant
4. Provide specific action for each quadrant

### Output Format

**Q1: Do First** (Important + Urgent)

- Item: [specific action, deadline if applicable]

**Q2: Schedule** (Important + Not Urgent)

- Item: [when to do it, why it matters long-term]

**Q3: Delegate** (Not Important + Urgent)

- Item: [who/what can handle it, or how to minimize time spent]

**Q4: Eliminate** (Not Important + Not Urgent)

- Item: [why it's noise, permission to drop it]

**Immediate Focus:**

Single sentence on what to tackle right now.

### Success Criteria

- Every item clearly placed in one quadrant
- Q1 items have specific next actions
- Q4 items explicitly marked as droppable
- Reduces overwhelm by creating clear action hierarchy

<critical_constraint>
MANDATORY: Place every item in exactly one quadrant
MANDATORY: Q1 items have specific immediate actions
MANDATORY: Q4 items explicitly marked as droppable
Eisenhower matrix must create clear action hierarchy.
</critical_constraint>

---

## PATTERN: Opportunity Cost

Analyze what you give up by choosing.

<mission_control>
<objective>Analyze opportunity cost by comparing chosen option to best alternative use of resources</objective>
<success_criteria>Hidden costs made explicit, all resource types accounted for, genuine value comparison provided</success_criteria>
</mission_control>

### Process

1. State the choice being considered
2. List what resources it consumes (time, money, energy, attention)
3. Identify the best alternative use of those same resources
4. Compare value of chosen option vs. best alternative
5. Determine if the tradeoff is worth it

### Output Format

**Choice:** [what you're considering doing]

**Resources Required:**

- Time: [hours/days/weeks]
- Money: [amount]
- Energy/Attention: [cognitive load]
- Other: [relationships, reputation, etc.]

**Best Alternative Uses:**

- With that time, could instead: [alternative + value]
- With that money, could instead: [alternative + value]
- With that energy, could instead: [alternative + value]

**True Cost:**

Choosing this means NOT doing [best alternative], which would have provided [value].

**Verdict:**

[Is the chosen option worth more than the best alternative?]

### Success Criteria

- Makes hidden costs explicit
- Compares to best alternative, not just any alternative
- Accounts for all resource types
- Reveals when "affordable" things are actually expensive

<critical_constraint>
MANDATORY: Compare to best alternative, not just any alternative
MANDATORY: Account for all resource types (time, money, energy, attention)
MANDATORY: Make hidden costs explicit
Every yes is a no to something - make that explicit.
</critical_constraint>

---

## PATTERN: Via Negativa

Improve by removing rather than adding.

<mission_control>
<objective>Identify what should be removed rather than added</objective>
<success_criteria>Subtraction candidates identified, essential elements preserved, improved state described</success_criteria>
</mission_control>

### Process

1. State the current situation or goal
2. List everything currently present (activities, features, commitments, beliefs)
3. For each item, ask: "Does removing this improve the outcome?"
4. Identify what to stop, eliminate, or say no to
5. Describe the improved state after subtraction

### Output Format

**Current State:**

[What exists now - activities, features, commitments]

**Subtraction Candidates:**

- [Item]: Remove because [reason] → Impact: [what improves]
- [Item]: Remove because [reason] → Impact: [what improves]
- [Item]: Remove because [reason] → Impact: [what improves]

**Keep (Passed the Test):**

- [Item]: Keep because [genuine value]

**After Subtraction:**

[Description of leaner, better state]

**What to Say No To:**

[Future additions to reject]

### Success Criteria

- Identifies genuine bloat vs. essential elements
- Removes without breaking core function
- Creates space and simplicity
- Improves by doing less, not more

<critical_constraint>
MANDATORY: Identify genuine bloat vs. essential elements
MANDATORY: Remove without breaking core function
MANDATORY: Create space and simplicity through subtraction
Improvement through addition is easier but via negativa is more elegant.
</critical_constraint>

---

## PATTERN: First Principles

Break down to fundamentals and rebuild.

<mission_control>
<objective>Strip assumptions and rebuild from fundamental truths</objective>
<success_criteria>Hidden assumptions surfaced, base truths identified, new solution paths opened</success_criteria>
</mission_control>

### Process

1. State the problem or belief being examined
2. List all current assumptions (even "obvious" ones)
3. Challenge each assumption: "Is this actually true? Why?"
4. Identify base truths that cannot be reduced further
5. Rebuild solution from only these fundamentals

### Output Format

**Current Assumptions:**

- Assumption 1: [challenged: true/false/partially]
- Assumption 2: [challenged: true/false/partially]

**Fundamental Truths:**

- Truth 1: [why this is irreducible]
- Truth 2: [why this is irreducible]

**Rebuilt Understanding:**

Starting from fundamentals, here's what we can conclude...

**New Possibilities:**

Without legacy assumptions, these options emerge...

### Success Criteria

- Surfaces hidden assumptions
- Distinguishes convention from necessity
- Identifies irreducible base truths
- Opens new solution paths not visible before

<critical_constraint>
MANDATORY: Challenge every assumption, even "obvious" ones
MANDATORY: Identify truly irreducible base truths
MANDATORY: Avoid reasoning by analogy or convention
First principles requires intellectual honesty about what we actually know.
</critical_constraint>

---

<critical_constraint>
**Execution Rules:**

1. Route to technique using Intent Router table
2. When multiple techniques apply, propose via AskUserQuestion
3. Execute selected technique with full output format
4. If user requests combination, run multiple analyses sequentially
5. Always deliver actionable insight, not just analysis

**All 12 techniques must remain available even when unified under this skill.**
</critical_constraint>
