# Workflow Examples and Edge Cases

Detailed examples and edge cases for each workflow.

---

## ASSESS Workflow Examples

### Example 1: New Project with Complex Workflows

```
User: "I have a project with multiple deployment environments and testing phases"
→ ASSESS detects: deploy-skill, test-automation-skill, environment-manager
→ Autonomy Level: High (90-95%)
→ Suggested Tier: 3 (references needed for deployment patterns)
```

### Example 2: Existing Project Needs Analysis

```
User: "Check what skills would benefit my React project"
→ ASSESS scans: package.json, component structure, build scripts
→ Detects: component-pattern-analyzer, build-optimizer, test-runner
→ Autonomy Level: Medium (85-89%)
→ Suggested Tier: 2 (moderate complexity)
```

### ASSESS Edge Cases

#### Case: Empty Project
```
Action: Scan for common patterns
→ Detect: language from file extensions, framework from structure
→ Suggest: language-specific starter skills
```

#### Case: Legacy Project
```
Action: Identify legacy patterns
→ Detect: makefiles, older frameworks, custom build systems
→ Suggest: migration skills with context detection
```

#### Case: Hybrid Project
```
Action: Detect multiple technologies
→ Scan: frontend (React), backend (Node), deployment (Docker)
→ Suggest: multi-tier skill architecture
```

---

## CREATE Workflow Examples

### Decision Tree Variations

**Tier Selection Decision Tree:**
```
├─ Simple task (read files, run command)?
│  └─ Yes → Tier 2 (SKILL.md only)
│
├─ Complex workflow (5+ steps)?
│  └─ Yes → Tier 3 (references needed)
│
├─ Domain expertise required?
│  └─ Yes → Tier 3 (deep patterns)
│
└─ Standard automation?
   └─ Yes → Tier 2 (core workflows)
```

**Autonomy Level Decision Tree:**
```
├─ Clear triggers (user can specify exact actions)?
│  └─ Yes → High autonomy (90-95%)
│
├─ Multiple decision points?
│  └─ Yes → Medium autonomy (85-89%)
│
├─ Context detection required?
│  └─ Yes → Medium autonomy (85-89%)
│
└─ Expert domain knowledge?
   └─ Yes → Medium autonomy (80-85%)
```

### Concrete Examples

#### Example 1: PDF Analysis Skill

```
User: "I need a skill for PDF analysis"

CREATE generates:
- Skill Name: pdf-analyzer
- Tier: 3 (references for extraction patterns)
- Autonomy: 85%
- References: extraction-methods.md, format-handling.md

Validation:
✓ YAML frontmatter validated
✓ URL fetching sections included
✓ Autonomy score: 13/15 (87%)
✓ Quality score: 142/160 (Grade B+)
```

#### Example 2: Simple Deploy Skill

```
User: "Create a deployment skill"

CREATE generates:
- Skill Name: deploy-skill
- Tier: 2 (no references needed)
- Autonomy: 92%
- References: None (SKILL.md <500 lines)

Validation:
✓ YAML frontmatter validated
✓ Completion marker: ## DEPLOY_SKILL_COMPLETE
✓ Autonomy score: 14/15 (93%)
✓ Quality score: 148/160 (Grade A-)
```

### CREATE Edge Cases

#### Case: Empty Skill Request

```
Action: Request clarification via user_input
→ Gather: purpose, triggers, context
→ THEN: Proceed with CREATE
```

#### Case: Duplicate Skill Request

```
Action: Detect existing skill
→ Check: .claude/skills/* for similar names
→ Action: Suggest ENHANCE instead
→ OR: Create with unique name if truly new
```

#### Case: Complex Multi-Task Skill

```
Action: Break into multiple skills
→ Pattern: Hub-and-spoke architecture
→ Create: 1 hub skill + N worker skills
→ Validate: Each skill autonomy ≥80%
```

---

## EVALUATE Workflow Examples

### Evaluation Checklist

**Dimension-by-Dimension Assessment:**
```
1. Knowledge Delta (20 pts)
   □ Zero generic tutorials
   □ 100% project-specific content
   □ Expert-level constraints only

2. Autonomy (15 pts)
   □ Examples provided
   □ Context included
   □ Decision logic clear
   □ Questions minimized

3. Discoverability (15 pts)
   □ Clear WHAT/WHEN/NOT
   □ Under ~200 characters
   □ No "how" language
   □ Discoverable keywords

4. Progressive Disclosure (15 pts)
   □ Tier 1: Metadata (~100 tokens)
   □ Tier 2: SKILL.md (<500 lines)
   □ Tier 3: references/ (on-demand)
   □ Proper structure

5-11. Additional Dimensions
   □ Clarity, Completeness, Standards
   □ Security, Performance
   □ Maintainability, Innovation
```

### Concrete Examples

#### Example 1: Grade A Skill Evaluation

```
Skill: deploy-skill
Score: 148/160 (Grade A)

Breakdown:
- Knowledge Delta: 18/20
- Autonomy: 14/15 (93%)
- Discoverability: 14/15
- Progressive Disclosure: 15/15
- Standards Compliance: 15/15
[...]

Action: PRODUCTION READY ✓
No changes required
```

#### Example 2: Grade C Skill Evaluation

```
Skill: data-processor
Score: 118/160 (Grade C)

Critical Issues:
- Autonomy: 7/15 (too many questions)
- Discoverability: 9/15 (verbose description)
- Knowledge Delta: 12/20 (generic content)

Action: ENHANCE REQUIRED
Priority: Fix autonomy (improve by +8 points)
Expected improvement: +16-24 points total
```

### EVALUATE Edge Cases

#### Case: No Skills Found

```
Action: ASSESS workflow instead
→ Analyze project structure
→ Suggest skill creation
→ THEN: Evaluate suggested skills
```

#### Case: Skills in Wrong Location

```
Action: Detect and report
→ Check: .claude/skills/* structure
→ Action: Suggest moving to correct location
→ OR: Evaluate where they are
```

#### Case: Incomplete Skill

```
Action: Validate structure
→ Check: YAML frontmatter
→ Check: Completion markers
→ Action: Report missing components
→ Suggest: Complete before evaluation
```

---

## ENHANCE Workflow Examples

### Enhancement Priorities

**High Impact Improvements (+16-32 points):**
```
1. Description Fix (+4 points)
   → Apply What-When-Not framework
   → Remove "how" language
   → Reduce to ~200 characters

2. Security Validation (+3 points)
   → Add validation hooks
   → Include safe execution patterns
   → Document input sanitization

3. Autonomy Enhancement (+8 points)
   → Add concrete examples
   → Include context detection
   → Provide decision trees

4. Progressive Disclosure (+4 points)
   → Optimize tier structure
   → Extract to references/ if needed
   → Ensure proper loading

5. Standards Compliance (+2 points)
   → Validate YAML frontmatter
   → Check completion markers
   → Verify structure
```

### Enhancement Strategies by Dimension

**Autonomy (15 pts):**
```
Low (0-5): Add examples, context, decision logic
Medium (6-10): Enhance with edge cases, troubleshooting
High (11-15): Optimize for 90-95% autonomy
```

**Discoverability (15 pts):**
```
Rewrite description using What-When-Not:
- WHAT: Action + object
- WHEN: Context/triggers
- NOT: Exclusion criteria
- Remove: Implementation details
```

**Knowledge Delta (20 pts):**
```
Remove: Generic tutorials, obvious content
Keep: Expert constraints, project-specific patterns
Add: Blocking rules, architecture decisions
```

### Concrete Examples

#### Example 1: Low to High Autonomy Enhancement

```
BEFORE: Score 7/15 (Low autonomy)
- Too many questions
- Insufficient context

ENHANCEMENTS:
1. Add concrete examples (+3 pts)
   Example: "For PDF: ./analyze.py file.pdf --format=json"

2. Include context detection (+2 pts)
   Detect: project type, file format, framework

3. Provide decision trees (+3 pts)
   If X → Do Y
   If A → Do B
   Else → Do C

AFTER: Score 15/15 (High autonomy)
Improvement: +8 points
```

#### Example 2: Progressive Disclosure Optimization

```
BEFORE: SKILL.md = 520 lines (exceeds limit)

ENHANCEMENT:
1. Extract to references/:
   - extraction-methods.md (180 lines)
   - troubleshooting.md (150 lines)
   - examples.md (200 lines)

2. SKILL.md becomes: 340 lines ✓

AFTER: Proper tier structure
Tier 1: Metadata (~100 tokens)
Tier 2: SKILL.md (340 lines)
Tier 3: references/ (3 files)
Improvement: +4 points
```

### ENHANCE Troubleshooting Scenarios

#### Scenario 1: Score Not Improving

```
Problem: Applied ENHANCE but score stuck

Diagnosis:
- Check: Quality gates applied correctly
- Verify: Dimension scoring accurate
- Ensure: Changes actually implemented

Solution:
- Re-run EVALUATE to confirm baseline
- Apply targeted improvements
- Re-evaluate with specific focus
```

#### Scenario 2: Autonomy Still Low

```
Problem: Autonomy score <80%

Actions:
1. Audit question frequency
   → Count questions in test output
   → Identify question triggers

2. Enhance examples
   → Add 3+ concrete examples
   → Include edge cases

3. Add context detection
   → Auto-detect project type
   → Provide relevant options

4. Implement decision trees
   → If/then/else logic
   → Clear pathways
```

#### Scenario 3: Discoverability Issues

```
Problem: Description not clear

Actions:
1. Apply What-When-Not framework
   - WHAT: "Build skills" (not "Create skills by...")
   - WHEN: "Use when creating skills"
   - NOT: "Not for general programming"

2. Remove implementation details
   - Delete: "router", "orchestrates", "routes"
   - Keep: Core purpose and triggers

3. Optimize length
   - Target: ~200 characters
   - Count: Words and characters
```

