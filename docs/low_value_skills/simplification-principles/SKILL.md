---
name: simplification-principles
description: "Apply Occam's Razor to debug issues, evaluate theories, and simplify designs. Use when debugging, choosing solutions, or reducing complexity. Not for verifying facts, implementing solutions, or creating new designs from scratch. Keywords: simplify, debug, occam's razor."
keywords: simplify, debug, occam's razor, debugging, complexity
---

## Quick Start

| If you need... | Read this section... |
| :------------- | :------------------- |
| Core workflow | ## PATTERN: Core Workflow |
| Anti-patterns | ## ANTI-PATTERN: Common Mistakes |
| Examples | ## EDGE: Worked Examples |
| Self-check | ## Recognition Questions |

<mission_control>
<objective>Apply Occam's Razor: prefer explanation with fewest assumptions that accounts for all facts</objective>
<success_criteria>Simplest valid explanation chosen, all facts explained, unnecessary complexity eliminated</success_criteria>
</mission_control>

## Quick Start

**Debug:** Collect facts → Generate explanations → Count assumptions → Choose simplest → Verify

**Evaluate designs:** Count assumptions per design → Choose fewest → Ensure it meets all requirements

**Simplify code:** Identify unnecessary complexity → Remove layers that don't add value

## PATTERN: Core Workflow

1. **Collect Facts** - Observable, verifiable only
2. **Generate Explanations** - At least 3 competing hypotheses
3. **Count Assumptions** - Each independent assumption counts separately
4. **Rank by Simplicity** - Fewest assumptions first
5. **Verify** - Must explain ALL facts, not just convenient ones
6. **Act** - Implement based on simplest valid explanation

## ANTI-PATTERN: Oversimplification

Choosing simplest explanation that doesn't account for all facts. The simplest explanation MUST explain everything.

## ANTI-PATTERN: Assumption Grouping

Counting multiple related assumptions as one. Each independent assumption counts separately, even when related.

## ANTI-PATTERN: Ignoring Evidence

Forcing facts to fit a simple explanation. If evidence contradicts, choose different explanation.

## EDGE: Inherent Complexity

Some systems ARE complex. Don't oversimplify when multiple interacting causes are required to explain facts.

## EDGE: Worked Examples

**Facts:**
- API returns 500 for >100 items
- Started after deployment
- Only one endpoint affected

**Explanations:**
- A) Hacker attack (4 assumptions)
- B) Config change (3 assumptions)
- C) Simple bug (2 assumptions) ← Winner

**Action:** Review recent code changes for array operations.

## EDGE: User Behavior Drop

**Facts:**
- 30% drop in signups Tuesday
- Mobile users only
- iOS only

**Explanations:**
- A) Market saturation (3 assumptions)
- B) iOS update broke flow (2 assumptions) ← Winner
- C) Competitor launched (4 assumptions)

**Action:** Test signup flow on latest iOS.

## PATTERN: Output Format

```markdown
## Known Facts
[Observable facts only]

## Possible Explanations
[At least 3, with assumption counts]

## Simplest Explanation
[Fewest assumptions that fits ALL facts]

## Recommended Action
[Concrete next step]
```

## Recognition Questions

| Question | Check |
| :--- | :--- |
| All facts collected first? | Observable facts listed before explanations |
| Multiple explanations generated? | At least 3 hypotheses with assumption counts |
| Simplest explains ALL facts? | No cherry-picking, all facts accounted for |
| Assumptions counted separately? | Each independent assumption counted |

---

<critical_constraint>
**Portability Invariant**: Zero external dependencies. Works standalone.
**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows
</critical_constraint>
