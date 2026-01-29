---
name: simplification-principles
description: "Apply simplification principles (Occam's Razor) to debug complex issues, evaluate competing theories, and simplify designs. Use when debugging complex problems, choosing between solutions, or reducing design complexity. Includes assumption identification, evidence weighting, and complexity reduction patterns. Not for ignoring necessary complexity, oversimplifying valid complexity, or when straightforward solutions exist."
---

# Simplification Principles

<mission_control>
<objective>Apply simplification principles (Occam's Razor) to debug complex issues, evaluate competing theories, and simplify designs.</objective>
<success_criteria>Explanation with fewest assumptions chosen, all facts accounted for, unnecessary complexity eliminated</success_criteria>
</mission_control>

Find the simplest explanation that accounts for all the facts. Among competing hypotheses, prefer the one with the fewest assumptions.

---

## The Path to High-Impact Simplification

<guiding_principles>

### 1. Simplicity Creates Actionable Solutions

Simple explanations lead to actionable fixes. When you choose the explanation with fewer assumptions, you reduce unknowns and increase confidence. This means faster implementation, fewer edge cases, and more predictable outcomes.

**Why this works**: Each assumption introduces risk. Fewer assumptions mean fewer things that can go wrong when you implement the solution.

### 2. Test Before Trusting the Simple Answer

Verification confirms that simplicity hasn't become oversimplification. The simplest explanation must account for ALL facts, not just the convenient ones. When evidence contradicts the simple answer, seek a different explanation.

**Why this works**: Einstein's principle—"as simple as possible, but not simpler"—guards against the trap of choosing easy answers over correct ones.

### 3. Count Every Independent Assumption

Explicit counting prevents hidden complexity. Each independent assumption counts separately, even when they seem related. This systematic counting surfaces where complexity truly lives.

**Why this works**: Grouping assumptions masks the true complexity. Explicit counting reveals which explanations are genuinely simpler.

### 4. Complexity Has Its Place

Some systems are inherently complex. When a simple explanation doesn't fit all facts, the correct answer may involve multiple interacting causes. Don't force simplicity where complexity exists.

**Why this works**: Real systems have real complexity. Acknowledging this prevents wasting time on overly simple fixes that can't possibly work.

### 5. Facts First, Explanations Second

Separate what you observe from what you infer. Facts are observable and verifiable. Assumptions are required to connect facts to explanations. Starting with facts grounds the analysis in reality.

**Why this works**: Building explanations from verified facts prevents speculation from driving the investigation.

</guiding_principles>

---

## Core Pattern

Apply Occam's Razor by:

1. Identifying the problem or phenomenon to explain
2. Listing all possible explanations
3. Counting assumptions required for each explanation
4. Preferring the explanation with the fewest assumptions
5. Verifying the simple explanation actually explains everything

**Key Innovation**: Avoid overcomplicating problems. Simple explanations are more likely to be correct and more likely to be actionable.

## Workflow

**Identify problem:** State what needs explanation

**List explanations:** Generate all possible hypotheses

**Count assumptions:** Weight each by number of assumptions required

**Select simplest:** Choose explanation with fewest assumptions

**Verify fit:** Confirm simple explanation accounts for all facts

**Why:** Simpler explanations are more likely correct and actionable—Occam's Razor cuts through complexity.

## Navigation

| If you need...    | Read...                         |
| :---------------- | :------------------------------ |
| Identify problem  | ## Workflow → Identify problem  |
| List explanations | ## Workflow → List explanations |
| Count assumptions | ## Workflow → Count assumptions |
| Select simplest   | ## Workflow → Select simplest   |
| Verify fit        | ## Workflow → Verify fit        |
| Core pattern      | ## Core Pattern                 |

## Implementation Patterns

### Pattern 1: Facts Collection

```typescript
function collectFacts(observation: Observation): Fact[] {
  return [
    "API returns 500 error",
    "Error occurs only for requests with > 100 items",
    "Error started after recent deployment",
    "No other endpoints are affected",
  ];
}
```

### Pattern 2: Explanation Comparison

```typescript
interface Explanation {
  name: string;
  description: string;
  assumptions: string[];
}

function countAssumptions(explanation: Explanation): number {
  return explanation.assumptions.length;
}

function rankExplanations(explanations: Explanation[]): Explanation[] {
  return explanations.sort((a, b) => countAssumptions(a) - countAssumptions(b));
}
```

### Pattern 3: Verification

```typescript
function verifyExplanation(
  explanation: Explanation,
  facts: Fact[],
): { valid: boolean; gaps: string[] } {
  const gaps = facts.filter((fact) => !explains(fact, explanation));
  return {
    valid: gaps.length === 0,
    gaps,
  };
}
```

## Troubleshooting

### Issue: Oversimplifying

| Symptom                                  | Solution                                   |
| ---------------------------------------- | ------------------------------------------ |
| Simple explanation doesn't fit all facts | Don't force fit - explanation may be wrong |
| Ignoring necessary complexity            | Some problems ARE inherently complex       |

### Issue: Wrong Assumption Count

| Symptom                                | Solution                                      |
| -------------------------------------- | --------------------------------------------- |
| Grouping multiple assumptions into one | Each independent assumption counts separately |
| Not counting implicit assumptions      | Count ALL assumptions, explicit and implicit  |

### Issue: Evidence Doesn't Fit

| Symptom                                 | Solution                      |
| --------------------------------------- | ----------------------------- |
| Evidence contradicts simple explanation | Choose different explanation  |
| Forcing facts to fit                    | If it doesn't fit, it's wrong |

### Issue: Ignoring Complexity When Needed

| Symptom                                 | Solution                                           |
| --------------------------------------- | -------------------------------------------------- |
| Using simplification to avoid hard work | Some systems ARE complex - don't oversimplify      |
| "Simpler is always better"              | Einstein: "as simple as possible, but not simpler" |

### Issue: Confusing Facts with Assumptions

| Symptom                          | Solution                                     |
| -------------------------------- | -------------------------------------------- |
| Treating assumptions as facts    | Verify before including in fact list         |
| Mixing evidence with speculation | Separate observed facts from inferred causes |

## Workflows

### When Debugging Complex Issues

1. **COLLECT FACTS** → What is actually happening?
2. **GENERATE EXPLANATIONS** → What could cause this?
3. **COUNT ASSUMPTIONS** → How many for each?
4. **RANK BY SIMPLICITY** → Fewest assumptions first
5. **VERIFY** → Does it explain ALL facts?
6. **ACT** → Fix based on simplest valid explanation

### Example Application

```
Facts:
- API returns 500 for >100 items
- Started after recent deployment
- Only affects this endpoint

Explanations:
A) Complex conspiracy (4 assumptions) - Unlikely
B) Configuration issue (3 assumptions) - Possible
C) Simple bug (2 assumptions) - Most likely

Winner: C - Recent deployment added code that crashes on large arrays
```

### Step 1: List all facts

```
**Known Facts:**
1. [Observable fact 1]
2. [Observable fact 2]
3. [Observable fact 3]
```

### Step 2: Generate explanations

```
**Explanation A**: [Description]
Assumptions: [List assumptions]

**Explanation B**: [Description]
Assumptions: [List assumptions]

**Explanation C**: [Description]
Assumptions: [List assumptions]
```

### Step 3: Count assumptions

- Fewer assumptions = more likely to be correct

### Step 4: Verify the simple explanation

- Does it actually explain all the facts?
- Any contradictions or gaps?

### Step 5: Choose the simplest sufficient explanation

## Application Examples

### Example 1: Debugging

**Facts**:

1. API returns 500 error
2. Error occurs only for requests with > 100 items
3. Error started after recent deployment
4. No other endpoints are affected

**Explanations**:

_A) Complex conspiracy_:

- Database was compromised
- Hacker is targeting large requests specifically
- Security team knows and hasn't told us
  Assumptions: 4 (very unlikely)

_B) Configuration issue_:

- Request size limit was lowered in recent deployment
- Large requests exceed new limit
- Error handler returns 500 for size limit
  Assumptions: 3 (possible)

_C) Simple bug_:

- Recent deployment added code that crashes on large arrays
- The bug is in the endpoint handler only
- No other endpoints have this code path
  Assumptions: 2 (most likely)

**Winner**: Explanation C - Simple bug in recent deployment

**Action**: Review recent code changes to the endpoint, look for array operations.

### Example 2: User Behavior

**Facts**:

1. Users are abandoning checkout at payment step
2. Abandonment rate increased last week
3. No UI changes were made
4. Competitors haven't changed pricing

**Explanations**:

_A) Market shift_:

- Economy changed last week
- Users suddenly can't afford products
- This affects only checkout step
  Assumptions: 4 (unconvincing)

_B) Technical issue_:

- Payment provider had outage last week
- Some users experienced errors
- They're now hesitant to complete payment
  Assumptions: 3 (possible)

_C) Simple change_:

- Payment processing time increased last week
- Users think it's broken and leave
- Nothing else changed
  Assumptions: 2 (most likely)

**Winner**: Explanation C - Payment got slower

**Action**: Check payment provider logs for processing time changes.

### Example 3: System Design

**Problem**: We need to send notifications to users

**Explanations**:

_A) Build notification microservice with queue, workers, retry logic, multiple channels, templates, preferences, scheduling, analytics_:

- Complex architecture
- Multiple systems to build and maintain
- Many moving parts
  Assumptions: Many (complexity for its own sake)

_B) Use existing email service, add simple notification table_:

- Single database table
- Simple cron job to send
- Email service handles delivery
  Assumptions: Few (sufficient for current needs)

**Winner**: Explanation B - Simple solution

**Action**: Start simple, add complexity only when needed.

## Output Format

After analysis, produce structured output:

```markdown
# Occam's Razor Analysis: [Problem]

## Known Facts

1. [Observable fact 1]
2. [Observable fact 2]
3. [Observable fact 3]

## Possible Explanations

### Explanation A: [Name]

**Description**: [What this explanation proposes]
**Assumptions** (count: N):

- [Assumption 1]
- [Assumption 2]
- [Assumption 3]

### Explanation B: [Name]

**Description**: [What this explanation proposes]
**Assumptions** (count: M):

- [Assumption 1]
- [Assumption 2]

### Explanation C: [Name]

**Description**: [What this explanation proposes]
**Assumptions** (count: P):

- [Assumption 1]

## Simplest Explanation

**[Winning explanation]** - [X assumptions]

**Why it's simplest**: [Fewest assumptions, most direct]

**Verification**:

- ✓ Explains fact 1
- ✓ Explains fact 2
- ✓ Explains fact 3

## Recommended Action

[What to do based on this explanation]

## Confidence

[High/Medium/Low] - [Reason for confidence level]
```

## Recognition Questions

**Before applying**:

- "What are the observable facts?"
- "Am I distinguishing facts from assumptions?"

**During analysis**:

- "How many assumptions does this explanation require?"
- "Is there evidence for each assumption?"

**After choosing**:

- "Does this actually explain ALL the facts?"
- "Am I choosing simple because it's easy or because it's correct?"

## Common Mistakes

**❌ Wrong**: Choosing the simplest explanation that doesn't actually explain everything
**✅ Correct**: Simplest explanation that accounts for ALL facts

**❌ Wrong**: Ignoring evidence to fit a simple explanation
**✅ Correct**: If evidence doesn't fit, explanation is wrong (no matter how simple)

**❌ Wrong**: Using Occam's Razor to avoid necessary complexity
**✅ Correct**: Some problems are inherently complex - don't oversimplify

**❌ Wrong**: Counting assumptions incorrectly (grouping many assumptions into one)
**✅ Correct**: Each independent assumption counts separately

## When NOT to Use

Don't use this principle when:

- You have clear evidence of complex causes
- The simple explanation leaves important facts unexplained
- Time horizons are long (complex systems emerge over time)
- Human behavior is involved (often irrational, not simple)

## Related Principles

**Hanlon's Razor**: Never attribute to malice what can be explained by stupidity (or error)

**Hume's Razor**: Explanation must be based on evidence, not speculation

**Popper's Falsifiability**: Explanations must be testable

**Pareto Principle**: 80% of effects come from 20% of causes (related simplicity)

## Quotes

"Simplicity is the ultimate sophistication." - Leonardo da Vinci

"Everything should be made as simple as possible, but not simpler." - Albert Einstein

"If you can't explain it simply, you don't understand it well enough." - Albert Einstein

**Trust intelligence** - Occam's Razor is a heuristic, not a law. Simple explanations are usually right, but not always. Verify before committing.

---

<critical_constraint>
**Portability Invariant**: This skill works standalone with zero external dependencies. No references to CLAUDE.md, .claude/rules/, or other components by file path or name.
</critical_constraint>
