---
name: first-principles-thinking
description: "Break down problems to fundamental truths and rebuild innovative solutions. Use when conventional solutions fail, innovation is needed, or assumptions must be challenged. Includes problem decomposition, truth identification, and solution reconstruction. Not for standard problems with known solutions, minor optimizations, or when established patterns suffice."
---

<mission_control>
<objective>Break down complex problems to fundamental truths and rebuild innovative solutions from first principles.</objective>
<success_criteria>Problem stripped to fundamentals, novel solution rebuilt from truths, assumptions challenged</success_criteria>
</mission_control>

<guiding_principles>

## The Path to High-Impact Innovation Success

### 1. Challenge Before Building

Innovation requires questioning what "everyone knows." When you accept assumptions as truths, you optimize within constraints that may not exist. By challenging assumptions first, you open solution space that conventional thinking cannot access.

**Practice**: Before accepting any constraint, ask whether it's a fundamental truth or just conventional wisdom.

### 2. Truth Is Physics, Not Opinion

Fundamental truths are physical laws, resource constraints, or unchangeable facts. Industry standards, best practices, and common approaches are assumptions—even when widely adopted. Building from truths ensures solutions withstand reality; building from opinions inherits others' constraints.

**Practice**: Test each "fact" by asking whether it could be false in a different context or with different technology.

### 3. Novelty Emerges from Fundamentals

When you rebuild only from fundamental truths, solutions emerge that weren't visible when constrained by "how things are done." This isn't just optimization—it's discovering entirely different approaches to problems.

**Practice**: After identifying truths, ask "what becomes possible when we ignore all conventional approaches?"

### 4. Depth Before Speed

First principles thinking is cognitively expensive but yields insights that assumption-based thinking cannot. Superficial analysis leads to superficial solutions—variations of existing approaches rather than genuine innovation.

**Practice**: Continue breaking down problems until you reach truths that cannot be decomposed further.

### 5. Document to Surface Assumptions

Writing down assumptions and why they might be wrong makes hidden constraints visible. This documentation isn't bureaucracy—it's a tool for revealing what you've unconsciously accepted as immutable.

**Practice**: List every assumption alongside the question "why might this be wrong?" to expose hidden constraints.

</guiding_principles>

Break down complex problems to their fundamental truths and rebuild from scratch. Strip away assumptions and existing solutions to find root causes and innovative approaches.

## Core Pattern

Apply first principles reasoning in four steps:

```
1. DEFINE → Problem Statement
2. STRIP → Assumptions
3. TRUTH → Fundamental Truths
4. REBUILD → Novel Solutions
```

## Workflow

**DEFINE:** State the problem clearly, strip to essentials

**STRIP:** Remove all assumptions, existing solutions, conventional approaches

**TRUTH:** Identify fundamental truths that cannot be questioned

**REBUILD:** Construct novel solutions from first principles

**Why:** Conventional solutions optimize for the past—first principles find novel approaches for unprecedented problems.

## Navigation

| If you need...          | Read...                                |
| :---------------------- | :------------------------------------- |
| Define problem          | ## Workflow → DEFINE                   |
| Strip assumptions       | ## Workflow → STRIP                    |
| Find fundamental truths | ## Workflow → TRUTH                    |
| Rebuild novel solution  | ## Workflow → REBUILD                  |
| Core pattern            | ## Core Pattern                        |
| Problem definition      | ## Implementation Patterns → Pattern 1 |

## Operational Patterns

- **Tracking**: Maintain a visible task list for first principles analysis
- **Management**: Manage task lifecycle for solution reconstruction

Trust native tools to fulfill these patterns. The System Prompt selects the correct implementation based on semantic directives.

## Implementation Patterns

### Pattern 1: Problem Definition

```typescript
function defineProblem(statement: string): ProblemDefinition {
  return {
    original: statement,
    coreIssue: extractCoreIssue(statement),
    constraints: [],
    assumptions: [],
  };
}
```

### Pattern 2: Assumption Stripping

```typescript
// BAD: Accepting industry norms
const badAssumptions = [
  "Microservices are the answer to scaling",
  "We need Kubernetes for container orchestration",
  "REST is the standard for APIs",
];

// GOOD: Questioning everything
function stripAssumptions(solution: string): string[] {
  return solution
    .split("\n")
    .filter((line) => isAssumptionNotTruth(line))
    .map((line) => `${line} - WHY is this true?`);
}
```

### Pattern 3: Finding Fundamental Truths

```typescript
// Truths are physics, constraints, or unchangeable facts
const fundamentalTruths = [
  "Code executes on CPUs", // Physical constraint
  "Memory is finite", // Resource constraint
  "Network has latency", // Physics of distance
  "Users have limited attention", // Human factor
];
```

### Pattern 4: Rebuilding from Truths

```typescript
function rebuildFromTruths(truths: string[]): Solution[] {
  return truths.map((truth) => {
    return {
      basedOn: truth,
      possibility: derivePossibility(truth),
      innovation: findNonObviousApproach(truth),
    };
  });
}
```

## Troubleshooting

### Issue: Not Going Deep Enough

| Symptom                      | Solution                                    |
| ---------------------------- | ------------------------------------------- |
| "Best practices" as answer   | Question WHY they're best                   |
| "Industry standard" as truth | What physics/constraint makes it necessary? |

### Issue: Confusing Assumptions with Truths

| Symptom                      | Solution                          |
| ---------------------------- | --------------------------------- |
| "Microservices scale better" | That's an assumption, not a truth |
| "React is the best frontend" | That's opinion, not physics       |

### Issue: Rebuilding with Same Assumptions

| Symptom                  | Solution                              |
| ------------------------ | ------------------------------------- |
| "Better microservices"   | Still constrained by same assumptions |
| "Optimized version of X" | Not a fundamental rebuild             |

### Issue: No Novel Solutions Emerging

| Symptom                        | Solution                                         |
| ------------------------------ | ------------------------------------------------ |
| Still thinking conventionally  | Ask "What would physics allow that we don't do?" |
| Solutions look like variations | Go deeper - find more fundamental truths         |

## Workflows

### When Stuck with Conventional Solutions

1. **DEFINE** → State problem without solution language
2. **STRIP** → List all "the way things are done" assumptions
3. **TRUTH** → Identify physical/constraint truths only
4. **REBUILD** → What becomes possible from truths?

### Example Application

```
Problem: "How do we reduce API latency?"

Assumptions:
- HTTP is required
- Synchronous responses needed
- Single region deployment

Truths:
- Speed of light limits network latency
- Caching eliminates repeated work
- Parallel processing reduces total time

Rebuilt Solutions:
- Cache at edge locations
- Use async processing
- Move computation closer to data
```

## Step-by-Step Process

### Step 1: Define the Problem

Clearly state what you're trying to solve:

```
**Problem Statement:**
[What is the core issue or challenge?]
```

**Example**: "How do we reduce the cost of space travel?"

### Step 2: Strip Assumptions

List all assumptions and existing "solutions":

```
**Current Assumptions:**
- [Assumption 1]
- [Assumption 2]
- [Existing solution 1]
- [Industry standard approach]
```

**Example**:

- Space travel requires rockets
- Rockets are expensive because they're single-use
- Fuel costs are the main expense
- We need NASA-level budgets

**Recognition**: What do we accept as "the way things are done" without questioning?

### Step 3: Find Fundamental Truths

Break down to what is fundamentally true (cannot be argued):

```
**Fundamental Truths:**
- [Truth 1] (physics law, constraint, etc.)
- [Truth 2]
- [Truth 3]
```

**Example**:

- Rockets are physics (action/reaction)
- Materials have mass
- Gravity exists
- We need to get payloads to orbit

**Recognition**: What remains when we strip away all conventions and assumptions?

### Step 4: Rebuild from Fundamentals

Create new solutions starting from fundamental truths only:

```
**Rebuilt Solutions:**
1. [Solution based on truth 1]
2. [Solution based on truth 2]
3. [Novel approach not constrained by assumptions]
```

**Example**: If rockets are physics, can we make them reusable? If materials have mass, can we use lighter materials? If we need orbit, can we refuel there?

**Recognition**: What solutions become possible when we ignore "how it's done"?

## Application Examples

### Example 1: Software Architecture

**Problem**: "Our monolith is too slow, how do we scale?"

**Assumptions**:

- Microservices are the answer
- Need to break everything into services
- Must use Kubernetes
- Need complex orchestration

**Fundamental Truths**:

- Code executes on CPUs
- Memory is finite
- Network has latency
- Some operations depend on others

**Rebuilt Solutions**:

- Identify actual bottleneck (is it CPU, memory, or I/O?)
- Can we optimize the slow parts without splitting everything?
- Maybe we need modular monolith, not microservices
- Perhaps we just need better caching

### Example 2: Product Feature

**Problem**: "Users aren't using our reporting feature"

**Assumptions**:

- Need more features in reports
- Need better UI
- Users don't understand how to use it
- Need tutorials

**Fundamental Truths**:

- Users act on what provides value
- Time is limited
- Reports serve decision-making
- Different users need different information

**Rebuilt Solutions**:

- What decisions do users actually make?
- Do we have the RIGHT data, not just MORE data?
- Maybe reports should be actionable, not informational
- Perhaps we need dashboards, not traditional reports

### Example 3: Team Process

**Problem**: "Sprint planning takes too long"

**Assumptions**:

- Need 2-week sprints
- Must estimate every story
- Planning poker is required
- Full team must be present

**Fundamental Truths**:

- Teams need shared understanding
- Some coordination is necessary
- Uncertainty exists in estimates
- Time is valuable

**Rebuilt Solutions**:

- Do we need sprints at all? (continuous delivery?)
- Can we estimate only larger items?
- Maybe planning should be just-in-time, not batched
- Perhaps only relevant people attend

## Output Format

After analysis, produce structured output:

```markdown
# First Principles Analysis: [Problem]

## Problem Statement

[What we're trying to solve]

## Assumptions Identified

- [Assumption 1] - [why this might be wrong]
- [Assumption 2] - [why this might be wrong]

## Fundamental Truths

1. [Truth that cannot be broken down further]
2. [Another fundamental truth]
3. [Another fundamental truth]

## Rebuilt Solutions

1. [Novel solution based on truth 1]
2. [Alternative approach based on truth 2]
3. [Non-obvious insight from rebuilding]

## Key Insight

[The most important realization from this analysis]

## Next Steps

1. [Action to explore solution 1]
2. [Experiment to test assumption]
```

## Recognition Questions

**Before applying**:

- "Am I starting from existing solutions or fundamental truths?"
- "Which of my 'facts' are actually assumptions?"

**During analysis**:

- "Can this be broken down further?"
- "Is this true by definition or just conventional wisdom?"

**After rebuilding**:

- "Does this solution challenge conventional approaches?"
- "Is this truly novel or just a variation of existing solutions?"

## Common Mistakes

**❌ Wrong**: Stopping at "best practices" instead of going deeper
**✅ Correct**: Question why best practices are best

**❌ Wrong**: Accepting industry constraints as fundamental truths
**✅ Correct**: Distinguish between real constraints and self-imposed ones

**❌ Wrong**: Rebuilding with the same assumptions in different words
**✅ Correct**: Start only from what is provably true

## Key Innovation

First principles thinking bypasses conventional thinking to find innovative solutions that aren't constrained by existing approaches.

**The breakthrough**: When you strip away assumptions, solutions emerge that were invisible when constrained by "how things are done."

**Trust intelligence** - First principles thinking is cognitively expensive but yields insights that assumption-based thinking cannot.

---

<critical_constraint>
Portability invariant: This skill must work with zero external dependencies or .claude/rules references.
</critical_constraint>

---
