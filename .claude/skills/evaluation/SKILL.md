---
name: evaluation
description: "Evaluate agent systems with quality gates and LLM-as-judge pattern. Use when measuring component quality, implementing quality gates, or scoring system outputs. Includes multi-dimensional rubrics, nuanced quality assessment, and improvement recommendations. Not for simple unit testing, binary pass/fail checks, or manual review without automation."
---

<mission_control>
<objective>Evaluate agent systems using multi-dimensional rubrics and LLM-as-judge pattern for nuanced quality measurement.</objective>
<success_criteria>Quality gates passed, rubric scores documented, improvement recommendations provided</success_criteria>
</mission_control>

## The Path to High-Quality Evaluation Success

### 1. Multi-Dimensional Assessment Captures True Quality

Quality is composite, not singular. Single metrics (like accuracy alone) miss critical aspects like completeness, portability, and efficiency. Multi-dimensional rubrics with weighted scores provide nuanced assessment that reflects real-world quality.

**Success pattern**: Design rubrics with 4-6 dimensions covering functional, structural, and performance aspects. Weight dimensions by importance to your use case.

### 2. Evidence-Based Assessment Prevents Hallucination

Scores without justification are opinions, not measurements. Requiring evidence for each dimension forces objective evaluation and provides audit trails for improvement.

**Success pattern**: For every score, document specific evidence: "Portability: 0.8 - Self-contained with zero external dependencies" rather than just "Portability: 0.8".

### 3. LLM-as-Judge Enables Nuanced Automation

Binary pass/fail cannot capture quality gradients. LLM judges applying structured rubrics automate nuanced assessment while maintaining consistency. Position swapping in pairwise comparisons reduces bias.

**Success pattern**: Implement judge prompts with clear rubric dimensions, scoring scales, and evidence requirements. Use position swapping when comparing outputs.

### 4. Quality Gates Enable Confident Progression

Thresholds block substandard work while allowing valid variation. Production gates (≥0.7) ensure baseline quality, while experimental gates (≥0.6) permit innovation with guardrails.

**Success pattern**: Set thresholds based on risk tolerance. Track scores over time to detect regressions before they reach production.

### 5. Outcome-Focused Evaluation Accepts Multiple Paths

Valid solutions take different routes. Judging specific implementation steps fails valid alternatives. Evaluating outcomes rather than paths preserves creativity while ensuring quality.

**Success pattern**: Define rubrics around results (correctness, completeness, efficiency) rather than methods (specific functions, tools, or approaches).

### 6. Test Set Stratification Ensures Coverage

Simple cases don't reveal complex failures. Stratifying test sets across complexity levels (simple, moderate, extended interaction) catches edge cases before production.

**Success pattern**: Build test sets representing real usage patterns. Include edge cases, multi-turn interactions, and boundary conditions.

</guiding_principles>

## Workflow

**Design rubric:** Create multi-dimensional scoring criteria with weights

**Implement LLM judge:** Automate scoring using rubric dimensions

**Build test set:** Select representative test cases

**Create quality gate:** Block substandard work with threshold

**Why:** LLM-as-judge provides nuanced assessment beyond binary pass/fail—multi-dimensional rubrics capture quality.

## Operational Patterns

This skill follows these behavioral patterns:

- **Tracking**: Maintain a visible task list throughout evaluation phases
- **Consultation**: Consult the user when evaluation criteria needs clarification

## Navigation

| If you need...           | Read...                                           |
| :----------------------- | :------------------------------------------------ |
| Design rubric            | ## Workflow → Design rubric                       |
| Implement LLM judge      | ## Workflow → Implement LLM judge                 |
| Build test set           | ## Workflow → Build test set                      |
| Create quality gate      | ## Workflow → Create quality gate                 |
| Multi-dimensional rubric | ## Implementation Patterns → Pattern 1            |
| LLM judge pattern        | ## Implementation Patterns → LLM-as-Judge Pattern |

### What Type of Evaluation?

| If you need to...                                | Read this section           |
| ------------------------------------------------ | --------------------------- |
| **Design rubric** → Create scoring criteria      | Multi-Dimensional Rubrics   |
| **Implement LLM judge** → Automate scoring       | LLM-as-Judge Pattern        |
| **Build test set** → Select test cases           | Test Set Design             |
| **Create quality gate** → Block substandard work | Quality Gate Implementation |

## Implementation Patterns

### Pattern 1: Multi-Dimensional Rubric

```python
# Define quality dimensions with weights
rubric = {
    "factual_accuracy": {"weight": 0.25, "description": "Claims match ground truth"},
    "completeness": {"weight": 0.25, "description": "Covers all requested aspects"},
    "portability": {"weight": 0.25, "description": "Zero external dependencies"},
    "context_efficiency": {"weight": 0.15, "description": "Optimal context usage"},
    "tool_efficiency": {"weight": 0.10, "description": "Appropriate tool selection"}
}

def calculate_overall(scores, rubric):
    return sum(scores[dim] * rubric[dim]["weight"] for dim in rubric)
```

### Pattern 2: LLM-as-Judge Prompt

```typescript
const judgePrompt = `
Task: Evaluate the component output
Agent Output: {output}
Evaluation Criteria:
- Factual Accuracy (0.0-1.0): Claims match ground truth
- Completeness (0.0-1.0): Covers all requirements
- Portability (0.0-1.0): Zero external dependencies

Evaluate each dimension with score and evidence:
1. Factual Accuracy: [score] - [evidence]
2. Completeness: [score] - [evidence]
3. Portability: [score] - [evidence]

Overall Score: [weighted average]
Pass/Fail: [>=0.7 for production]
`;
```

### Pattern 3: Pairwise Comparison with Position Swapping

```python
def evaluate_pairwise(output_a, output_b):
    # Compare A vs B
    result_1 = judge_evaluate(output_a, output_b)

    # Compare B vs A (swap positions)
    result_2 = judge_evaluate(output_b, output_a)

    # Reconcile results to reduce position bias
    return reconcile_comparisons(result_1, result_2)
```

### Pattern 4: Validation Report

```yaml
# Validation Report
component: my-skill
timestamp: 2026-01-29
overall_score: 0.82
threshold: 0.70
passed: true

dimensions:
  factual_accuracy: 0.90
    evidence: "All technical claims verified"
  completeness: 0.85
    evidence: "Covers all requirements with minor gaps"
  portability: 0.80
    evidence: "Self-contained, zero external dependencies"

recommendations:
  - "Consider further context optimization"
```

## Troubleshooting

### Issue: Overfitting to Specific Paths

| Symptom                              | Solution                     |
| ------------------------------------ | ---------------------------- |
| Evaluating specific steps taken      | Judge outcomes, not paths    |
| Failing valid alternative approaches | Accept multiple valid routes |

### Issue: Single-Metric Obsession

| Symptom                       | Solution                                 |
| ----------------------------- | ---------------------------------------- |
| Only measuring accuracy       | Use multi-dimensional rubrics            |
| Missing other quality aspects | Add dimensions: completeness, efficiency |

### Issue: Position Bias in Comparisons

| Symptom                            | Solution                       |
| ---------------------------------- | ------------------------------ |
| A always beats B when listed first | Implement position swapping    |
| Inconsistent pairwise results      | Swap and reconcile comparisons |

### Issue: Ignoring Edge Cases

| Symptom                     | Solution                           |
| --------------------------- | ---------------------------------- |
| Tests pass on simple cases  | Add complexity stratification      |
| Failures only in production | Include extended interaction tests |

### Issue: No Evidence for Scores

| Symptom                            | Solution                        |
| ---------------------------------- | ------------------------------- |
| "Score: 0.8" without justification | Require evidence for all scores |
| Subjective judgments               | Use explicit rubric levels      |

### Issue: Threshold Too Strict/Relaxed

| Symptom            | Solution                                |
| ------------------ | --------------------------------------- |
| Everything failing | Lower threshold (≥0.6 for experimental) |
| Everything passing | Raise threshold (≥0.8 for production)   |

## Workflows

### Building Quality Gates

1. **Define Rubric** → Create multi-dimensional scoring criteria
2. **Build Test Set** → Sample from real usage, include edge cases
3. **Implement Evaluation** → LLM-as-judge with position swapping
4. **Set Threshold** → ≥0.7 for production, ≥0.6 for experimental
5. **Track Metrics** → Store results, detect regressions

### Continuous Evaluation Pipeline

```bash
# Run on component changes
npm run evaluate -- --component=my-skill
# Output: validation report with scores
```

---

## Guidelines

1. **Judge outcomes, not paths** - Multiple valid routes to goals
2. **Use multi-dimensional rubrics** - Quality is composite
3. **Test across complexity levels** - Simple ≠ Complex
4. **Implement position swapping** - Mitigate pairwise bias
5. **Require evidence** - Justify all scores
6. **Track over time** - Detect regressions
7. **Combine automated and human** - Catch what automation misses
8. **Test context strategies** - Validate progressive disclosure

---

## Genetic Code

This component carries essential Seed System principles for context: fork isolation:

**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows

**Recognition Questions**:

- "Would Claude know this without being told?" → Delete (zero delta)
- "Can this work standalone?" → Fix if no (non-self-sufficient)
- "Did I read the actual file, or just see it in grep?" → Verify before claiming

<critical_constraint>
**Portability Invariant**: All components MUST be self-contained with zero .claude/rules dependency. This ensures the component works when copied to other projects.

**Autonomy Standard**: Achieve 80-95% autonomy (0-5 AskUserQuestion rounds per session).

**Frontmatter Format**: Description MUST use What-When-Not-Includes format in third person (bare infinitive).

**Progressive Disclosure**: Use references/ folder for detailed content to keep SKILL.md lean.

**Unified Hybrid Protocol**: Use XML for control (mission_control, critical_constraint), Markdown for data.
</critical_constraint>
