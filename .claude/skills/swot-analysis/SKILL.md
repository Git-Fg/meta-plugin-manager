---
name: swot-analysis
description: "Analyze Strengths, Weaknesses, Opportunities, and Threats for strategic decision-making. Use when making strategic decisions, evaluating positions, or planning initiatives. Includes quadrant analysis, internal/external factor identification, and action item derivation. Not for simple technical choices, debugging, or tactical execution."
---

<mission_control>
<objective>Analyze internal Strengths/Weaknesses and external Opportunities/Threats for strategic decision-making.</objective>
<success_criteria>All four quadrants populated, strategic insights derived, action items identified</success_criteria>
</mission_control>

## The Path to Strategic Clarity

### 1. Four Dimensions Reveal Hidden Connections

Linear thinking misses strategic relationships. Mapping factors across Strengths, Weaknesses, Opportunities, and Threats reveals connections invisible to single-variable analysis. **Why**: Complete strategic awareness requires seeing internal capabilities alongside external realities—each quadrant illuminates the others.

### 2. Specificity Fuels Actionable Strategy

Vague factors ("good team") produce vague strategies. Specific, evidence-based factors ("team has 5 years React experience") enable precise action planning. **Why**: Strategy requires concrete footing—you can't leverage or address what you can't see clearly.

### 3. Internal/External Distinction Enables Control

Distinguishing what you control (S/W) from what you don't (O/T) clarifies strategic agency. Focus resources on leveraging strengths and addressing weaknesses; position for opportunities and defend against threats. **Why**: Strategic power comes from knowing what you can change versus what you must navigate.

### 4. Strategy Emerges from Quadrant Intersections

The real value lies in combining quadrants: SO (leverage strengths for opportunities), ST (use strengths against threats), WO (overcome weaknesses for opportunities), WT (minimize weaknesses to avoid threats). **Why**: Strategic thinking is inherently multidimensional—isolated factors inform; combined factors guide action.

### 5. Prioritization Prevents Analysis Paralysis

Not all factors matter equally. Prioritize by impact and feasibility to focus on what moves the needle. **Why**: Unlimited analysis capacity doesn't exist—strategic clarity comes from distinguishing critical from trivial.

### 6. Honest Assessment Enables Real Strategy

Overoptimism about strengths or minimizing weaknesses produces fantasy, not strategy. Honest assessment of all four quadrants—especially weaknesses and threats—creates realistic strategic foundations. **Why**: Strategy based on false assumptions fails when reality intrudes.

---

# SWOT Analysis

Analyze internal Strengths and Weaknesses, plus external Opportunities and Threats to develop strategic insights.

## Core Pattern

Apply SWOT analysis by:

1. Identifying internal Strengths (what you do well)
2. Identifying internal Weaknesses (what you lack)
3. Identifying external Opportunities (what could help)
4. Identifying external Threats (what could hurt)
5. Developing strategies from these insights

**Key Innovation**: Mapping factors across four dimensions reveals strategic connections and action items that aren't obvious from linear thinking.

## Workflow

**Strengths:** What internal factors work in your favor?

**Weaknesses:** What internal factors work against you?

**Opportunities:** What external factors could help?

**Threats:** What external factors could hurt?

**Why:** Four-dimensional analysis reveals strategic connections invisible to linear thinking—maps complete position.

## Navigation

| If you need...         | Read...                     |
| :--------------------- | :-------------------------- |
| Analyze strengths      | ## Workflow → Strengths     |
| Analyze weaknesses     | ## Workflow → Weaknesses    |
| Identify opportunities | ## Workflow → Opportunities |
| Identify threats       | ## Workflow → Threats       |
| Core pattern           | ## Core Pattern             |
| Strategic insights     | ## Implementation Patterns  |

## Operational Patterns

- **Tracking**: Maintain a visible task list for SWOT analysis
- **Management**: Manage task lifecycle for action item derivation

## Implementation Patterns

### Pattern 1: SWOT Mapping

```typescript
interface SWOT {
  strengths: string[]; // Internal advantages
  weaknesses: string[]; // Internal limitations
  opportunities: string[]; // External possibilities
  threats: string[]; // External risks
}

function analyzeSWOT(context: AnalysisContext): SWOT {
  return {
    strengths: analyzeInternal("advantage"),
    weaknesses: analyzeInternal("limitation"),
    opportunities: analyzeExternal("possibility"),
    threats: analyzeExternal("risk"),
  };
}
```

### Pattern 2: Prioritization Matrix

```typescript
// Prioritize based on impact and actionability
function prioritizeSWOT(swot: SWOT): PrioritizedSWOT {
  return {
    criticalStrengths: swot.strengths.filter((s) => s.impact > 0.8),
    keyWeaknesses: swot.weaknesses.filter((w) => w.impact > 0.6),
    topOpportunities: swot.opportunities.filter((o) => o.feasibility > 0.7),
    urgentThreats: swot.threats.filter((t) => t.likelihood > 0.7),
  };
}
```

### Pattern 3: Strategic Actions

```typescript
// Derive actions from SWOT
function deriveActions(swot: SWOT): StrategicAction[] {
  return [
    // Leverage strengths
    ...swot.strengths.map((s) => ({
      type: "leverage",
      source: s,
      action: `Use ${s} to capture opportunity`,
    })),
    // Address weaknesses
    ...swot.weaknesses.map((w) => ({
      type: "mitigate",
      source: w,
      action: `Fix ${w} to reduce threat`,
    })),
  ];
}
```

## Troubleshooting

### Issue: Confusing Internal/External

| Symptom                                | Solution            |
| -------------------------------------- | ------------------- |
| "Our team is small" - weakness         | Internal (weakness) |
| "Competitor launched feature" - threat | External (threat)   |

### Issue: Too Generic

| Symptom                        | Solution                                         |
| ------------------------------ | ------------------------------------------------ |
| "Good team" as strength        | Be specific: "Team has 5 years React experience" |
| "Competition exists" as threat | Be specific: "Competitor X has 70% market share" |

### Issue: Not Actionable

| Symptom                  | Solution                     |
| ------------------------ | ---------------------------- |
| Listed but no priorities | Use prioritization matrix    |
| No strategic actions     | Derive actions from analysis |

### Issue: Missing Dimension

| Symptom                       | Solution                               |
| ----------------------------- | -------------------------------------- |
| Only strengths and weaknesses | Don't forget opportunities and threats |
| All items in one category     | Distinguish all four dimensions        |

## Workflows

### Strategic Decision Process

1. **ANALYZE** → Map all four SWOT dimensions
2. **PRIORITIZE** → Focus on critical/key/top/urgent items
3. **DERIVE ACTIONS** → What should we do?
4. **SET STRATEGY** → Based on analysis

## The Four Dimensions

**Internal Factors (What you control)**

- **Strengths**: What you do well, advantages you have
- **Weaknesses**: What you lack, areas for improvement

**External Factors (What you don't control)**

- **Opportunities**: External situations you could leverage
- **Threats**: External risks that could hurt you

## Step-by-Step Process

### Step 1: List Strengths (S)

```
What do we do better than anyone else?
What unique resources do we have?
What do others see as our strengths?
```

### Step 2: List Weaknesses (W)

```
What could we improve?
What do we do poorly?
What resources are we missing?
```

### Step 3: List Opportunities (O)

```
What trends could we benefit from?
What changes are coming?
What competitors are vulnerable?
```

### Step 4: List Threats (T)

```
What competitors are strong?
What trends work against us?
What could go wrong?
```

### Step 5: Develop Strategies

```
- SO: Use Strengths to capture Opportunities
- ST: Use Strengths to address Threats
- WO: Overcome Weaknesses to pursue Opportunities
- WT: Minimize Weaknesses to avoid Threats
```

## Application Examples

### Example 1: Software Project

**Strengths**:

- Experienced team with deep domain knowledge
- Existing user base for feedback
- Clean codebase with good test coverage

**Weaknesses**:

- Limited budget for infrastructure
- Small team (can't scale quickly)
- No marketing expertise

**Opportunities**:

- Market trend toward our solution space
- Competitor recently raised prices (created gap)
- New technology enables better UX

**Threats**:

- Large competitor entering our space
- Economic downturn affecting customers
- Key dependency on third-party API

**Strategies**:

- **SO**: Leverage domain expertise to build better UX than competitor using new technology
- **ST**: Use existing user base loyalty to defend against large competitor
- **WO**: Partner with marketing-savvy company to overcome marketing weakness
- **WT**: Reduce dependency on third-party API to avoid vendor risk

### Example 2: Career Decision

**Strengths**:

- Strong technical skills
- Good communication ability
- Network in the industry

**Weaknesses**:

- Limited management experience
- Prefer technical work over meetings
- Not interested in politics

**Opportunities**:

- Company growing rapidly
- New product line launching
- Remote work options expanding

**Threats**:

- Industry consolidating
- Ageism in tech
- Skills becoming commoditized

**Strategies**:

- **SO**: Use technical skills to lead new product line
- **ST**: Deepen specialization to differentiate
- **WO**: Develop technical leadership (not management) path
- **WT**: Build independent income streams to reduce job dependency

### Example 3: Product Feature Decision

**Strengths**:

- Fast development team
- Existing infrastructure
- User data and analytics

**Weaknesses**:

- Limited design resources
- No mobile expertise
- Spaghetti code in some areas

**Opportunities**:

- Mobile usage increasing
- AI/ML becoming accessible
- Competitors slow to adapt

**Threats**:

- Platform changes (API deprecations)
- User privacy concerns increasing
- Attention spans decreasing

**Strategies**:

- **SO**: Use fast development to ship AI feature before competitors
- **ST**: Leverage user data to build better experience despite platform changes
- **WO**: Partner with design agency for mobile, don't build in-house
- **WT**: Refactor spaghetti code before it becomes critical

## Output Format

After analysis, produce structured output:

```markdown
# SWOT Analysis: [Subject]

## Internal Strengths (S)

1. [Strength 1] - [Why this matters]
2. [Strength 2] - [Why this matters]
3. [Strength 3] - [Why this matters]

## Internal Weaknesses (W)

1. [Weakness 1] - [Why this is a problem]
2. [Weakness 2] - [Why this is a problem]
3. [Weakness 3] - [Why this is a problem]

## External Opportunities (O)

1. [Opportunity 1] - [Potential impact]
2. [Opportunity 2] - [Potential impact]
3. [Opportunity 3] - [Potential impact]

## External Threats (T)

1. [Threat 1] - [Potential impact]
2. [Threat 2] - [Potential impact]
3. [Threat 3] - [Potential impact]

## Strategic Matrix

### SO Strategies (Strengths + Opportunities)

1. [Strategy] - Use [strength] to capture [opportunity]
2. [Strategy] - Leverage [strength] for [opportunity]

### ST Strategies (Strengths + Threats)

1. [Strategy] - Use [strength] to defend against [threat]
2. [Strategy] - Leverage [strength] despite [threat]

### WO Strategies (Weaknesses + Opportunities)

1. [Strategy] - Overcome [weakness] to pursue [opportunity]
2. [Strategy] - Address [weakness] to capture [opportunity]

### WT Strategies (Weaknesses + Threats)

1. [Strategy] - Minimize [weakness] to avoid [threat]
2. [Strategy] - Mitigate [weakness] despite [threat]

## Priority Actions

1. [Most important action from strategies]
2. [Second priority action]
3. [Third priority action]

## Key Insights

- [Most important realization]
- [Another critical insight]
```

## Recognition Questions

**When identifying factors**:

- "Is this truly internal (we control) or external (we don't)?"
- "Is this specific or too vague?"
- "Do we have evidence for this, or is it speculation?"

**When developing strategies**:

- "Does this strategy combine factors from two quadrants?"
- "Is this actionable, not just theoretical?"
- "Does this play to our strengths or address real threats?"

## Common Mistakes

**❌ Wrong**: Vague, generic statements ("We have good team")
**✅ Correct**: Specific, evidence-based ("Team has 10 years domain expertise")

**❌ Wrong**: Confusing internal/external (opportunities should be external)
**✅ Correct**: Opportunities are external factors you can leverage

**❌ Wrong**: Listing without developing strategies
**✅ Correct**: Use SWOT to generate actionable strategies (SO, ST, WO, WT)

**❌ Wrong**: Treating all factors as equal
**✅ Correct**: Prioritize by impact and feasibility

## Validation Checklist

Before claiming SWOT analysis complete:

**Analysis Scope:**
- [ ] All four quadrants populated (S, W, O, T)
- [ ] Internal factors distinguished from external factors
- [ ] Factors are specific, not vague/generic
- [ ] Evidence or reasoning supports each factor

**Strategic Depth:**
- [ ] Quadrant intersections analyzed (SO, ST, WO, WT)
- [ ] Actionable strategies derived from analysis
- [ ] Priorities assigned by impact and feasibility
- [ ] Honest assessment of weaknesses and threats

**Quality:**
- [ ] No factor listed in multiple quadrants
- [ ] Factors are actionable (can be leveraged or addressed)
- [ ] Analysis leads to concrete next steps

---

## Best Practices Summary

✅ **DO:**
- Be specific and evidence-based in each factor
- Distinguish internal (S/W) from external (O/T) factors
- Analyze quadrant intersections for strategic insights
- Prioritize by impact and feasibility
- Be honest about weaknesses and threats
- Derive actionable strategies from the analysis

❌ **DON'T:**
- Use vague statements ("good team", "strong culture")
- List factors in wrong quadrants
- Stop at listing without developing strategies
- Treat all factors as equally important
- Overoptimize strengths while minimizing weaknesses
- Ignore threats or pretend they don't exist

---

## Advanced: TOWS Analysis

For deeper analysis, consider all four strategic combinations:

1. **SO (Maxi-Max)**: Maximum strengths, maximum opportunities
   - Aggressive growth strategies

2. **ST (Maxi-Min)**: Maximum strengths, minimum threats
   - Defensive strategies using strengths

3. **WO (Mini-Max)**: Minimum weaknesses, maximum opportunities
   - Build capabilities to capture opportunities

4. **WT (Mini-Min)**: Minimum weaknesses, minimum threats
   - Survival or retrenchment strategies

**Trust intelligence** - SWOT is only as good as your honesty about weaknesses and threats. Be real, not optimistic.

---

<critical_constraint>
Portability invariant: This component works standalone (zero external dependencies).
</critical_constraint>
