# Skill Quality Framework

11-dimensional scoring for skill quality assessment.

---

## Scoring Dimensions

### 1. Knowledge Delta (20 points)
**CRITICAL: Expert-only vs Claude-obvious**

| Score | Criteria |
|-------|----------|
| 17-20 | 100% Project-Specific. Zero tutorials. |
| 13-16 | Mostly expert knowledge. |
| 8-12  | Contains some generic info. |
| 0-7   | Fails Delta Principle (Tutorials found). |

### 2. Autonomy (10 points)
**80-95% completion without questions**

| Score | Criteria |
|-------|----------|
| 9-10  | 90-95% autonomous |
| 7-8   | 85-89% autonomous |
| 5-6   | 80-84% autonomous |
| 0-4   | <80% autonomous |

### 3. Discoverability (15 points)
**Clear description with triggers**

| Score | Criteria |
|-------|----------|
| 13-15 | Clear triggers, discoverable |
| 10-12 | Good triggers |
| 7-9 | Adequate triggers |
| 4-6 | Unclear triggers |
| 0-3 | No clear triggers |

### 4. Progressive Disclosure (15 points)
**Tier 1/2/3 properly organized**

| Score | Criteria |
|-------|----------|
| 13-15 | Perfect tier structure |
| 10-12 | Good tier structure |
| 7-9 | Adequate tiers |
| 4-6 | Poor tiers |
| 0-3 | No tiers |

### 5. Clarity (15 points)
**Unambiguous instructions**

| Score | Criteria |
|-------|----------|
| 13-15 | Crystal clear |
| 10-12 | Very clear |
| 7-9 | Mostly clear |
| 4-6 | Somewhat unclear |
| 0-3 | Confusing |

### 6. Completeness (15 points)
**Covers all scenarios**

| Score | Criteria |
|-------|----------|
| 13-15 | Comprehensive coverage |
| 10-12 | Good coverage |
| 7-9 | Adequate coverage |
| 4-6 | Limited coverage |
| 0-3 | Poor coverage |

### 7. Standards Compliance (15 points)
**Follows Agent Skills spec**

| Score | Criteria |
|-------|----------|
| 13-15 | Perfect compliance |
| 10-12 | Good compliance |
| 7-9 | Adequate compliance |
| 4-6 | Some violations |
| 0-3 | Major violations |

### 8. Security (10 points)
**Validation, safe execution**

| Score | Criteria |
|-------|----------|
| 9-10 | Secure implementation |
| 7-8 | Mostly secure |
| 5-6 | Some security issues |
| 3-4 | Security concerns |
| 0-2 | Major security issues |

### 9. Performance (10 points)
**Efficient workflows**

| Score | Criteria |
|-------|----------|
| 9-10 | Highly efficient |
| 7-8 | Efficient |
| 5-6 | Adequate efficiency |
| 3-4 | Inefficient |
| 0-2 | Very inefficient |

### 10. Maintainability (10 points)
**Well-structured**

| Score | Criteria |
|-------|----------|
| 9-10 | Highly maintainable |
| 7-8 | Maintainable |
| 5-6 | Somewhat maintainable |
| 3-4 | Hard to maintain |
| 0-2 | Not maintainable |

### 11. Innovation (5 points)
**Unique value**

| Score | Criteria |
|-------|----------|
| 5     | Highly innovative |
| 3-4   | Innovative |
| 1-2   | Standard approach |
| 0     | No unique value |

---

## Quality Grades

| Grade | Score Range | Description |
|-------|-------------|-------------|
| A | 144-160 | Exemplary skill |
| B | 128-143 | Good skill |
| C | 112-127 | Adequate skill |
| D | 96-111 | Poor skill |
| F | 0-95 | Failing skill |

---

## EVALUATE Workflow

**Purpose**: Score skill quality

**Process**:
1. Evaluate each dimension
2. Calculate total score
3. Assign grade
4. Generate report
5. Suggest improvements

---

## ENHANCE Workflow

**Purpose**: Improve quality score

**Process**:
1. Identify weak dimensions
2. Prioritize improvements
3. Implement fixes
4. Re-evaluate
5. Achieve target grade

---

## Success Criteria

**Production Ready**: ≥128/160 (Grade B)

**Minimum Scores**:
- Knowledge Delta: ≥16/20 (CRITICAL)
- Autonomy: ≥8/10
- Discoverability: ≥12/15
- Progressive Disclosure: ≥12/15
- Clarity: ≥12/15
- Completeness: ≥12/15
- Standards Compliance: ≥12/15
- Security: ≥8/10
- Performance: ≥8/10
- Maintainability: ≥8/10
- Innovation: ≥3/5

See also: progressive-disclosure.md, autonomy-design.md, extraction-methods.md
