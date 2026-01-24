# Quality Specification

## Summary
This specification defines the quality framework, standards, and validation criteria for skills, ensuring ≥80/100 scores on the 11-dimensional framework before production deployment.

## Given-When-Then Acceptance Criteria

### G1: 11-Dimensional Quality Framework
**Given** a skill submitted for production
**When** evaluated against quality framework
**Then** it MUST score ≥80/100 across all dimensions:

1. **Knowledge Delta** (10 points)
   - 10: Expert-only knowledge not Claude-obvious
   - 7: Mix of expert and obvious
   - 4: Mostly obvious content
   - 0: Claude knows already

2. **Autonomy** (10 points)
   - 10: 95% autonomous (0-1 questions)
   - 8: 85% autonomous (2-3 questions)
   - 5: 80% autonomous (4-5 questions)
   - 0: <80% autonomous (6+ questions)

3. **Discoverability** (10 points)
   - 10: Clear triggers, actionable description
   - 7: Good triggers, mostly clear
   - 4: Vague triggers or descriptions
   - 0: No clear triggers

4. **Progressive Disclosure** (10 points)
   - 10: Tier 1/2/3 perfect, SKILL.md <500 lines
   - 7: Minor violations, references/ used appropriately
   - 4: Major violations, oversized SKILL.md
   - 0: No progressive disclosure

5. **Clarity** (10 points)
   - 10: Unambiguous instructions
   - 7: Mostly clear with minor ambiguity
   - 4: Some unclear sections
   - 0: Confusing or contradictory

6. **Completeness** (10 points)
   - 10: All scenarios covered
   - 7: Most scenarios covered
   - 4: Basic scenarios only
   - 0: Incomplete coverage

7. **Standards Compliance** (10 points)
   - 10: Perfect Agent Skills spec compliance
   - 7: Minor non-compliance
   - 4: Major non-compliance
   - 0: Does not follow spec

8. **Security** (10 points)
   - 10: Safe execution, validation, no risks
   - 7: Safe with minor issues
   - 4: Some security concerns
   - 0: Unsafe or risky

9. **Performance** (10 points)
   - 10: Efficient workflows, optimal
   - 7: Good performance
   - 4: Acceptable performance
   - 0: Poor performance

10. **Maintainability** (10 points)
    - 10: Well-structured, easy to maintain
    - 7: Good structure
    - 4: Acceptable structure
    - 0: Hard to maintain

11. **Innovation** (10 points)
    - 10: Unique value, novel approach
    - 7: Some innovation
    - 4: Standard implementation
    - 0: No unique value

### G2: Progressive Disclosure Compliance
**Given** a skill in `.claude/skills/skill-name/SKILL.md`
**When** evaluated for progressive disclosure
**Then** it MUST:
- SKILL.md <500 lines OR have references/ directory
- Tier 1: YAML frontmatter (~100 tokens)
- Tier 2: SKILL.md <500 lines (workflows, examples)
- Tier 3: references/ loaded on-demand (deep details)

**Current Violations**:
- test-runner/SKILL.md: 845 lines (VIOLATION)
- ralph-orchestrator-expert/SKILL.md: 573 lines (VIOLATION)

### G3: WIN CONDITION Markers
**Given** a skill execution
**When** skill completes successfully
**Then** it MUST output:
- `## SKILL_NAME_COMPLETE` (PascalCase from skill name)
- Marker appears at end of execution
- Format: ## [SKILL_NAME_IN_PASCAL_CASE]_COMPLETE

**Naming Rules**:
- skill-name → SKILL_NAME_COMPLETE
- cat-detector → CAT_DETECTOR_COMPLETE
- ralph-orchestrator-expert → RALPH_ORCHESTRATOR_EXPERT_COMPLETE

**Missing Marker**:
- cat-detector skill (needs ## CAT_DETECTOR_COMPLETE)

### G4: Autonomy Scoring
**Given** a skill execution in test environment
**When** autonomy is evaluated
**Then** it MUST count questions in test-output.json:

**Scoring Methodology**:
1. Extract line 3 from test-output.json
2. Count entries in `permission_denials` array
3. Each AskUserQuestion = 1 question
4. Calculate autonomy percentage

**Autonomy Levels**:
- 95% (Excellent): 0-1 questions
- 85% (Good): 2-3 questions
- 80% (Acceptable): 4-5 questions
- <80% (Fail): 6+ questions (requires refactoring)

**What Counts as Question**:
- ❌ "Which file should I modify?"
- ❌ "What should I name this variable?"
- ❌ "Where should I put this code?"
- ✅ Reading files for context (tool usage)
- ✅ Running bash commands (execution)
- ✅ Using Grep/Glob (file operations)

### G5: Quality Gate
**Given** a skill ready for production
**When** quality gate check is performed
**Then** it MUST:
- Score ≥80/100 on 11-dimensional framework
- Pass progressive disclosure check
- Have WIN CONDITION marker
- Achieve ≥80% autonomy in testing
- Pass all acceptance criteria

## Input/Output Examples

### Example 1: Perfect Quality Score
**Input**: Skill with all dimensions optimal
**Evaluation**:
```
Knowledge Delta: 10/10 (Expert-only content)
Autonomy: 10/10 (0 questions)
Discoverability: 10/10 (Clear triggers)
Progressive Disclosure: 10/10 (Perfect Tier 1/2/3)
Clarity: 10/10 (Unambiguous)
Completeness: 10/10 (All scenarios)
Standards: 10/10 (Perfect compliance)
Security: 10/10 (Safe)
Performance: 10/10 (Optimal)
Maintainability: 10/10 (Well-structured)
Innovation: 10/10 (Unique value)
Total: 110/100 (Exceeds requirements)
```

### Example 2: Acceptable Quality Score
**Input**: Skill with minor issues
**Evaluation**:
```
Knowledge Delta: 7/10 (Mix of expert and obvious)
Autonomy: 8/10 (2 questions)
Discoverability: 7/10 (Good triggers)
Progressive Disclosure: 7/10 (Minor violations)
Clarity: 7/10 (Mostly clear)
Completeness: 7/10 (Most scenarios)
Standards: 7/10 (Minor non-compliance)
Security: 10/10 (Safe)
Performance: 7/10 (Good)
Maintainability: 7/10 (Good structure)
Innovation: 4/10 (Standard)
Total: 78/100 (BELOW THRESHOLD - requires improvement)
```

### Example 3: Progressive Disclosure Refactor
**Given**: SKILL.md with 600 lines
**Action**:
```
Step 1: Count lines = 600 (EXCEEDS LIMIT)
Step 2: Create references/ directory
Step 3: Move detailed sections to references/:
        - troubleshooting.md (150 lines)
        - patterns.md (100 lines)
        - examples.md (120 lines)
Step 4: Keep SKILL.md with core workflows = 450 lines
Step 5: Verify <500 lines ✓
```

**Result**:
```
SKILL.md: 450 lines (COMPLIANT)
references/
├── troubleshooting.md (150 lines)
├── patterns.md (100 lines)
└── examples.md (120 lines)
Progressive Disclosure: PASS (10/10)
```

## Edge Cases and Error Conditions

### E1: Quality Score Below 80
**Condition**: Skill scores <80/100
**Error**: `QUALITY_GATE_FAIL` - Score below threshold
**Resolution**:
1. Identify lowest-scoring dimensions
2. Improve each dimension by at least 2 points
3. Re-evaluate until ≥80/100

### E2: Progressive Disclosure Violation
**Condition**: SKILL.md >500 lines, no references/
**Error**: `PROGRESSIVE_DISCLOSURE_VIOLATION`
**Resolution**:
1. Create references/ directory
2. Extract detailed content to reference files
3. Maintain SKILL.md <500 lines
4. Verify Tier 1/2/3 structure

### E3: Missing WIN CONDITION Marker
**Condition**: Skill completes without marker
**Error**: `SKILL_COMPLETION_ERROR` - Missing required marker
**Resolution**:
1. Add `## SKILL_NAME_COMPLETE` at end
2. Use PascalCase from skill name
3. Verify marker format matches convention

### E4: Autonomy Failure
**Condition**: Skill requires 6+ questions
**Error**: `AUTONOMY_FAIL` - <80% autonomy
**Resolution**:
1. Review test-output.json for question patterns
2. Provide more context in skill description
3. Add examples and edge cases
4. Reduce ambiguity in instructions
5. Re-test until 4-5 questions max

### E5: Oversized SKILL.md
**Condition**: SKILL.md significantly over limit
**Example**: test-runner with 845 lines (169% over)
**Resolution**:
1. Audit content for Tier 2 vs Tier 3
2. Extract troubleshooting to references/
3. Extract examples to references/
4. Extract patterns to references/
5. Keep only core workflows in SKILL.md
6. Verify each reference file is <500 lines

## Non-Functional Requirements

### Performance
- Quality evaluation completes in <5 minutes
- Automated checks run in <30 seconds
- Progressive disclosure reduces token load
- Efficient workflow execution

### Security
- Skills validate inputs before execution
- Safe execution without side effects
- No unauthorized access or modifications
- Context isolation for forked skills

### Maintainability
- Clear quality criteria and scoring
- Automated validation where possible
- Easy identification of violations
- Simple refactoring guidance

## Behavioral Standards

### B1: Quality Before Quantity
**Principle**: Better to have 1 excellent skill than 5 mediocre ones
**Application**:
- Enforce ≥80/100 quality gate
- No exceptions for "good enough"
- Quality improves with each iteration

### B2: Progressive Disclosure First
**Principle**: Structure before content
**Application**:
- Verify Tier 1/2/3 before adding content
- Maintain SKILL.md <500 lines
- Extract to references/ when exceeded

### B3: Autonomy as Primary Metric
**Principle**: Skills should work independently
**Application**:
- Minimize questions to users
- Provide complete context in descriptions
- Add examples for edge cases

## Validation Process

### Step 1: Pre-Submission Checklist
- [ ] 11-dimensional framework evaluated
- [ ] Score ≥80/100 confirmed
- [ ] Progressive disclosure compliant
- [ ] WIN CONDITION marker present
- [ ] Autonomy ≥80% verified
- [ ] Standards compliance checked

### Step 2: Automated Validation
```bash
# Check progressive disclosure
find .claude/skills -name "SKILL.md" -exec wc -l {} | awk '$1 > 500 {print}'

# Verify WIN markers
grep -r "## .*_COMPLETE" .claude/skills/*/SKILL.md

# Check autonomy
grep "permission_denions" test-output.json
```

### Step 3: Manual Review
- Review lowest-scoring dimensions
- Verify quality improvements
- Check progressive disclosure refactoring
- Validate WIN marker format

### Step 4: Production Approval
- Quality gate: PASS/FAIL
- Issues identified: [List]
- Required improvements: [List]
- Approved for production: YES/NO

## Quality Framework Scoring Examples

### Example: Perfect Score (110/100)
**Scenario**: Exceptional skill with all dimensions optimal
**Score Breakdown**:
- Expert knowledge: 10
- Zero questions: 10
- Perfect triggers: 10
- Perfect structure: 10
- Crystal clear: 10
- Complete coverage: 10
- Spec compliance: 10
- Secure: 10
- Optimal performance: 10
- Excellent structure: 10
- Highly innovative: 10
**Total**: 110/100

### Example: Acceptable Score (82/100)
**Scenario**: Good skill with minor issues
**Score Breakdown**:
- Mix of knowledge: 7
- Few questions: 8
- Good triggers: 7
- Minor structure issues: 7
- Mostly clear: 7
- Good coverage: 7
- Minor compliance: 7
- Secure: 10
- Good performance: 7
- Good structure: 7
- Some innovation: 8
**Total**: 82/100 (PASS - above 80)

### Example: Failing Score (76/100)
**Scenario**: Skill needs improvement
**Score Breakdown**:
- Obvious content: 4
- Many questions: 5
- Vague triggers: 4
- Major violations: 4
- Unclear sections: 4
- Incomplete: 4
- Non-compliance: 4
- Secure: 10
- Poor performance: 4
- Hard to maintain: 4
- No innovation: 4
**Total**: 76/100 (FAIL - below 80)

## Implementation Guidelines

### For Skill Developers
1. **Start with structure**: Tier 1/2/3 first
2. **Write clear descriptions**: Use What-When-Not framework
3. **Add examples**: Cover edge cases
4. **Test autonomy**: Minimize questions
5. **Validate quality**: Use framework checklist

### For Quality Reviewers
1. **Score all dimensions**: Don't skip any
2. **Identify specific issues**: Point to exact problems
3. **Suggest improvements**: Actionable feedback
4. **Re-evaluate**: After improvements made
5. **Document decisions**: Maintain quality records

## Current Status

### ✅ Compliant Skills (Examples)
- toolkit-architect: Good progressive disclosure
- skills-architect: Has WIN marker
- Most skills: Achieve ≥95% autonomy

### ❌ Non-Compliant (Requires Fix)
- test-runner: 845 lines (needs references/)
- ralph-orchestrator-expert: 573 lines (needs references/)
- cat-detector: Missing WIN marker

### ⚠️ Needs Verification
- All skills: Quality framework scores
- Autonomy levels: Actual measurement
- Progressive disclosure: Full audit

## Fix Priority

### Immediate (Critical)
1. Refactor test-runner SKILL.md (845 → <500 lines)
2. Refactor ralph-orchestrator-expert (573 → <500 lines)
3. Add WIN marker to cat-detector
4. Score all skills with framework

### Short-term (High)
5. Establish quality gate process
6. Create automated validation tools
7. Train developers on framework
8. Set quality requirements for new skills

### Medium-term (Medium)
9. Build quality dashboard
10. Track quality trends over time
11. Create quality improvement guidelines
12. Establish quality review process

## Out of Scope

### Not Covered by This Specification
- Skill architecture details (see skills.spec.md)
- TaskList orchestration (see tasklist.spec.md)
- Testing methodologies (see testing.spec.md)
- Security specifics (see security.spec.md)

## References
- Quality framework: `.claude/rules/quality-framework.md`
- Progressive disclosure: `.claude/rules/architecture.md`
- Test plan: `tests/skill_test_plan.json`
- Autonomy testing: `skills/test-runner/references/autonomy-testing.md`
