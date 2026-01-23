# Extraction Methods Guide

Golden path extraction from expert workflows to autonomous skills.

---

## Golden Path Extraction

### Step 1: Identify Expert Workflow
1. Observe expert performing task
2. Document decision points
3. Note commands that work
4. Capture gotchas

### Step 2: Extract Patterns
1. Identify common sequences
2. Extract decision logic
3. Document edge cases
4. Note prerequisites

### Step 3: Create Skill Structure
1. Define clear triggers
2. Structure workflows
3. Add examples
4. Include context

---

## CREATE Workflow

**Purpose**: Build skill from golden path

**Process**:
1. Extract expert workflow
2. Structure as skill
3. Add progressive disclosure
4. Validate autonomy

**Templates**:

**Basic Skill**:
```yaml
---
name: skill-name
description: "What it does when X"
user-invocable: true
---

# Skill Name

## Purpose
What it accomplishes

## When to Use
Specific triggers

## Workflow
Step-by-step process
```

---

## Common Patterns

### Pattern 1: Command-Based
```markdown
## Commands

**Install**: `npm install`
**Build**: `npm run build`
**Test**: `npm test`
```

### Pattern 2: Decision-Based
```markdown
## Decision Tree

**Node.js Project?** → Use npm
**Python Project?** → Use pip
**Unknown?** → Detect automatically
```

### Pattern 3: Context-Aware
```markdown
## Context Detection

**Auto-detects**:
- Project type from files
- Language from extensions
- Framework from imports
```

---

## Quality Check

**Golden Path Quality**:
- [ ] All steps documented
- [ ] Decisions explained
- [ ] Examples provided
- [ ] Edge cases noted

See also: progressive-disclosure.md, autonomy-design.md, quality-framework.md
