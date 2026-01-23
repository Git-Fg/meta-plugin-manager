# Autonomy Design Guide

80-95% completion without questions through context and examples.

---

## Autonomy Principles

### Target: 80-95% Completion

**High Autonomy (90-95%)**:
- Clear examples provided
- Specific commands included
- Context is comprehensive
- Few questions needed

**Medium Autonomy (80-89%)**:
- Good examples
- Most scenarios covered
- Some questions acceptable

**Low Autonomy (<80%)**:
- Too many questions
- Insufficient context
- Needs improvement

---

## Autonomy Patterns

### Pattern 1: Example-Rich
```markdown
## Usage Examples

**Example 1: Basic Use**
```bash
# Don't document `ls -la` (Obvious)
# Do document:
./bin/processor --mode=fast --shards=4
```

**Example 2: Advanced Use**
```bash
# Complex piping workflow
cat logs.txt | ./bin/analyzer --format=json > report.json
```
```

### Pattern 2: Context-Aware
```markdown
## Context Requirements

**Project Type**: Detected from package.json
**Language**: Auto-detected from file extensions
**Framework**: Identified from imports
```

### Pattern 3: Decision Trees
```markdown
## Decision Logic

**If X** → Do Y
**If A** → Do B
**Else** → Do C
```

---

## ASSESS Workflow

**Purpose**: Evaluate autonomy potential

**Process**:
1. Analyze task complexity
2. Identify decision points
3. Suggest autonomy level
4. Recommend improvements

---

## EVALUATE Workflow

**Purpose**: Score autonomy achievement

**Scoring**:
- Examples provided: +5 points
- Context included: +5 points
- Decision logic: +5 points
- Questions reduced: +5 points

---

## ENHANCE Workflow

**Purpose**: Improve autonomy score

**Strategies**:
1. Add concrete examples
2. Include context detection
3. Provide decision trees
4. Reduce ambiguity

---

## Success Criteria

**Autonomy Score ≥80%**:
- Examples are specific
- Context is comprehensive
- Decision logic is clear
- Questions are minimized

See also: progressive-disclosure.md, extraction-methods.md, quality-framework.md
