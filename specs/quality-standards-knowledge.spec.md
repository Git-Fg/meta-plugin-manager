# Quality Standards Knowledge Specification

## Summary
This specification defines the comprehensive quality standards, scoring methodology, and validation criteria for the 11-dimensional quality framework, ensuring skills achieve ≥80/100 before production deployment.

## Quality Framework Overview

### Purpose
The 11-dimensional framework provides comprehensive quality assessment across all aspects of skill design, implementation, and value delivery.

### Requirements
- **Minimum Score**: ≥80/100 to pass quality gate
- **Evaluation**: All 11 dimensions must be scored
- **Dimensions**: Each worth 10 points (100 total)
- **No Exceptions**: All skills must meet threshold

## Given-When-Then Acceptance Criteria

### G1: Complete Evaluation
**Given** a skill submitted for production
**When** quality evaluation is performed
**Then** it MUST score all 11 dimensions:
1. Knowledge Delta
2. Autonomy
3. Discoverability
4. Progressive Disclosure
5. Clarity
6. Completeness
7. Standards Compliance
8. Security
9. Performance
10. Maintainability
11. Innovation

### G2: Minimum Threshold
**Given** a skill with completed evaluation
**When** total score is calculated
**Then** it MUST achieve ≥80/100:
- 80-84: Acceptable (requires minor improvements)
- 85-89: Good (meets standard)
- 90-94: Excellent (exceeds standard)
- 95-100: Outstanding (exceptional quality)

### G3: Dimension Scoring
**Given** a specific dimension
**When** scoring from 0-10
**Then** it MUST use rubric:
- 10: Exceptional (exceeds expectations)
- 7-9: Good (meets expectations with minor issues)
- 4-6: Acceptable (meets basic requirements)
- 0-3: Poor (fails to meet requirements)

### G4: Quality Gate
**Given** a skill ready for production
**When** quality gate check occurs
**Then** it MUST:
- Pass all acceptance criteria
- Achieve ≥80/100 total score
- Have no critical violations
- Complete all required tests

### G5: Re-evaluation After Improvements
**Given** a skill fails quality gate
**When** improvements are made
**Then** it MUST:
- Re-score all 11 dimensions
- Address identified deficiencies
- Achieve ≥80/100 before re-submission
- Document changes made

## Dimension Scoring Rubric

### Dimension 1: Knowledge Delta (10 points)
**Measures**: Expert-only knowledge vs Claude-obvious content

**10 points (Exceptional)**:
- Contains expert knowledge not available elsewhere
- Provides unique insights or specialized expertise
- Addresses complex, nuanced scenarios
- Offers non-obvious solutions

**7-9 points (Good)**:
- Mix of expert and common knowledge
- Some unique value
- Addresses moderately complex scenarios
- Provides helpful but not exceptional insights

**4-6 points (Acceptable)**:
- Mostly common knowledge
- Limited unique value
- Basic scenarios covered
- Obvious solutions provided

**0-3 points (Poor)**:
- All Claude-obvious content
- No unique value
- Trivial scenarios only
- Basic information only

**Example Scoring**:
- Skill teaching advanced security patterns: 10/10
- Skill with basic tutorials: 6/10
- Skill with obvious instructions: 3/10

### Dimension 2: Autonomy (10 points)
**Measures**: Ability to complete without questions

**Scoring**: Based on autonomy levels
- 95% autonomy (0-1 questions): 10/10
- 85% autonomy (2-3 questions): 8/10
- 80% autonomy (4-5 questions): 5/10
- <80% autonomy (6+ questions): 0/10

**See**: autonomy-knowledge.spec.md for detailed methodology

### Dimension 3: Discoverability (10 points)
**Measures**: How easily users can find and use skill

**10 points (Exceptional)**:
- Crystal-clear name and description
- Obvious triggers and use cases
- Excellent discoverability through search
- Perfect fit for intended purpose

**7-9 points (Good)**:
- Clear name and description
- Good triggers, mostly discoverable
- Obvious use cases
- Easy to find and use

**4-6 points (Acceptable)**:
- Adequate name and description
- Somewhat discoverable
- Basic use cases clear
- Requires some exploration

**0-3 points (Poor)**:
- Unclear or misleading name
- Poor discoverability
- Use cases not obvious
- Hard to find or understand

**Scoring Criteria**:
- Name clarity (3 points)
- Description quality (3 points)
- Trigger effectiveness (2 points)
- Use case clarity (2 points)

### Dimension 4: Progressive Disclosure (10 points)
**Measures**: Proper tier structure and size limits

**10 points (Exceptional)**:
- Perfect Tier 1/2/3 structure
- SKILL.md <500 lines
- Excellent use of references/
- Optimal token usage

**7-9 points (Good)**:
- Good tier structure
- SKILL.md compliant
- References/ used appropriately
- Minor structural issues

**4-6 points (Acceptable)**:
- Basic tier structure
- SKILL.md may be close to limit
- References/ exists but could be better
- Some structural issues

**0-3 points (Poor)**:
- Poor or missing tier structure
- SKILL.md >500 lines
- No references/ despite size
- Major structural violations

**See**: progressive-disclosure-knowledge.spec.md

### Dimension 5: Clarity (10 points)
**Measures**: Unambiguous, understandable instructions

**10 points (Exceptional)**:
- Crystal clear instructions
- No ambiguity whatsoever
- Perfect understanding possible
- Exemplary clarity

**7-9 points (Good)**:
- Clear instructions
- Minor ambiguity
- Mostly understandable
- Good clarity overall

**4-6 points (Acceptable)**:
- Adequate clarity
- Some confusing sections
- Basic understanding possible
- Acceptable but could be better

**0-3 points (Poor)**:
- Confusing or contradictory
- Major ambiguity
- Difficult to understand
- Poor clarity

**Evaluation Questions**:
- Are instructions unambiguous?
- Can skill be used without confusion?
- Are edge cases clearly handled?
- Is language clear and precise?

### Dimension 6: Completeness (10 points)
**Measures**: Coverage of scenarios and edge cases

**10 points (Exceptional)**:
- All scenarios covered
- Comprehensive edge case handling
- Complete workflow coverage
- Exhaustive examples

**7-9 points (Good)**:
- Most scenarios covered
- Good edge case handling
- Major workflows complete
- Extensive examples

**4-6 points (Acceptable)**:
- Basic scenarios covered
- Some edge cases handled
- Core workflows present
- Basic examples

**0-3 points (Poor)**:
- Incomplete coverage
- Missing edge cases
- Incomplete workflows
- Minimal examples

**Evaluation Areas**:
- Common use cases
- Edge cases
- Error handling
- Alternative workflows

### Dimension 7: Standards Compliance (10 points)
**Measures**: Adherence to Agent Skills specification

**10 points (Exceptional)**:
- Perfect spec compliance
- All requirements met
- Exemplary implementation
- No deviations

**7-9 points (Good)**:
- Good spec compliance
- Minor deviations
- Most requirements met
- Solid implementation

**4-6 points (Acceptable)**:
- Basic compliance
- Some deviations
- Core requirements met
- Acceptable implementation

**0-3 points (Poor)**:
- Poor compliance
- Major deviations
- Missing requirements
- Non-compliant implementation

**Compliance Checklist**:
- YAML frontmatter structure
- WIN CONDITION markers
- Naming conventions
- Directory structure
- File organization

### Dimension 8: Security (10 points)
**Measures**: Safe execution, validation, risk mitigation

**10 points (Exceptional)**:
- Comprehensive validation
- No security risks
- Secure patterns only
- Exemplary security

**7-9 points (Good)**:
- Good validation
- Minimal risks
- Mostly secure
- Good security practices

**4-6 points (Acceptable)**:
- Basic validation
- Some risks present
- Acceptable security
- Adequate practices

**0-3 points (Poor)**:
- Poor validation
- Significant risks
- Insecure patterns
- Poor security

**Security Considerations**:
- Input validation
- Safe execution
- No unauthorized access
- Context isolation (if forked)

### Dimension 9: Performance (10 points)
**Measures**: Efficiency, speed, resource usage

**10 points (Exceptional)**:
- Optimal performance
- Efficient workflows
- Minimal resource usage
- Exemplary efficiency

**7-9 points (Good)**:
- Good performance
- Efficient execution
- Reasonable resource usage
- Solid efficiency

**4-6 points (Acceptable)**:
- Acceptable performance
- Basic efficiency
- Normal resource usage
- Adequate speed

**0-3 points (Poor)**:
- Poor performance
- Inefficient execution
- High resource usage
- Slow operation

**Performance Metrics**:
- Execution time
- Token efficiency
- Tool usage optimization
- Workflow efficiency

### Dimension 10: Maintainability (10 points)
**Measures**: Ease of updates, refactoring, maintenance

**10 points (Exceptional)**:
- Excellent structure
- Easy to maintain
- Clear organization
- Exemplary maintainability

**7-9 points (Good)**:
- Good structure
- Relatively easy to maintain
- Clear organization
- Solid maintainability

**4-6 points (Acceptable)**:
- Adequate structure
- Somewhat maintainable
- Acceptable organization
- Basic maintainability

**0-3 points (Poor)**:
- Poor structure
- Difficult to maintain
- Unclear organization
- Hard to modify

**Maintainability Factors**:
- Code organization
- Documentation quality
- Separation of concerns
- Update ease

### Dimension 11: Innovation (10 points)
**Measures**: Unique value, novel approaches, creative solutions

**10 points (Exceptional)**:
- Highly innovative
- Unique approach
- Novel solution
- Exceptional value

**7-9 points (Good)**:
- Some innovation
- Good approach
- Useful features
- Solid value

**4-6 points (Acceptable)**:
- Basic innovation
- Standard approach
- Common features
- Acceptable value

**0-3 points (Poor)**:
- No innovation
- Generic approach
- Basic features
- Minimal value

**Innovation Indicators**:
- Unique problem-solving
- Creative workflows
- Novel integrations
- Exceptional value proposition

## Scoring Examples

### Example 1: Excellent Skill (95/100)
**Scenario**: High-quality skill with minor issues
```
Knowledge Delta: 9/10 (Expert content)
Autonomy: 10/10 (0 questions)
Discoverability: 9/10 (Clear and obvious)
Progressive Disclosure: 9/10 (Perfect structure)
Clarity: 9/10 (Very clear)
Completeness: 9/10 (Comprehensive)
Standards: 9/10 (Excellent compliance)
Security: 10/10 (Secure)
Performance: 9/10 (Efficient)
Maintainability: 9/10 (Well-structured)
Innovation: 9/10 (Innovative approach)
Total: 95/100 (Outstanding - PASS)
```

### Example 2: Acceptable Skill (82/100)
**Scenario**: Good skill with room for improvement
```
Knowledge Delta: 7/10 (Good content)
Autonomy: 8/10 (2 questions)
Discoverability: 7/10 (Clear)
Progressive Disclosure: 7/10 (Good structure)
Clarity: 7/10 (Mostly clear)
Completeness: 7/10 (Good coverage)
Standards: 8/10 (Good compliance)
Security: 9/10 (Secure)
Performance: 8/10 (Good)
Maintainability: 7/10 (Adequate)
Innovation: 7/10 (Some innovation)
Total: 82/100 (Acceptable - PASS)
```

### Example 3: Failing Skill (76/100)
**Scenario**: Skill needs improvement
```
Knowledge Delta: 6/10 (Basic content)
Autonomy: 5/10 (4 questions)
Discoverability: 6/10 (Adequate)
Progressive Disclosure: 4/10 (Violation)
Clarity: 6/10 (Some confusion)
Completeness: 6/10 (Incomplete)
Standards: 6/10 (Some deviations)
Security: 8/10 (Secure)
Performance: 6/10 (Acceptable)
Maintainability: 6/10 (Adequate)
Innovation: 6/10 (Standard)
Total: 76/100 (Fail - BELOW 80)
```

## Quality Gate Process

### Step 1: Pre-Evaluation
- [ ] Skill complete and ready
- [ ] All tests passing
- [ ] Progressive disclosure compliant
- [ ] WIN marker present

### Step 2: Dimension Scoring
- [ ] Score Knowledge Delta (0-10)
- [ ] Score Autonomy (0-10)
- [ ] Score Discoverability (0-10)
- [ ] Score Progressive Disclosure (0-10)
- [ ] Score Clarity (0-10)
- [ ] Score Completeness (0-10)
- [ ] Score Standards Compliance (0-10)
- [ ] Score Security (0-10)
- [ ] Score Performance (0-10)
- [ ] Score Maintainability (0-10)
- [ ] Score Innovation (0-10)

### Step 3: Calculate Total
- [ ] Sum all dimension scores
- [ ] Verify total is ≥80/100
- [ ] Check for critical violations
- [ ] Document score breakdown

### Step 4: Quality Decision
**If ≥80/100**:
- [ ] Approve for production
- [ ] Document score
- [ ] Note strengths
- [ ] Optional: Suggest improvements

**If <80/100**:
- [ ] Reject for production
- [ ] Identify lowest dimensions
- [ ] Provide improvement recommendations
- [ ] Schedule re-evaluation

### Step 5: Post-Approval (if passed)
- [ ] Publish skill
- [ ] Monitor performance
- [ ] Track quality metrics
- [ ] Collect user feedback

## Common Quality Issues

### Issue 1: Low Autonomy
**Symptom**: Dimension 2 score <5
**Cause**: Skill asks too many questions
**Fix**: Improve instructions, add context
**See**: autonomy-knowledge.spec.md

### Issue 2: Progressive Disclosure Violation
**Symptom**: Dimension 4 score <7
**Cause**: SKILL.md >500 lines
**Fix**: Extract to references/
**See**: progressive-disclosure-knowledge.spec.md

### Issue 3: Poor Discoverability
**Symptom**: Dimension 3 score <7
**Cause**: Unclear name or description
**Fix**: Improve naming, clarify purpose
**Resolution**: Use What-When-Not framework

### Issue 4: Incomplete Coverage
**Symptom**: Dimension 6 score <7
**Cause**: Missing edge cases or scenarios
**Fix**: Add comprehensive examples
**Resolution**: Expand use case coverage

### Issue 5: Standards Non-Compliance
**Symptom**: Dimension 7 score <7
**Cause**: Doesn't follow Agent Skills spec
**Fix**: Align with specification
**Resolution**: Review spec requirements

## Quality Improvement Strategies

### For Low Scores (60-79)
1. **Identify gaps**: Review each dimension
2. **Prioritize**: Focus on lowest scores first
3. **Systematic improvement**: Fix one dimension at a time
4. **Re-evaluate**: Test after each improvement
5. **Document changes**: Track modifications

### For Borderline Scores (80-84)
1. **Fine-tune**: Make minor adjustments
2. **Polish**: Improve clarity and discoverability
3. **Examples**: Add missing edge cases
4. **Validate**: Ensure improvements work

### For Good Scores (85-94)
1. **Optimize**: Push for excellence
2. **Innovate**: Add unique value
3. **Refine**: Perfect clarity
4. **Document**: Share best practices

## Quality Metrics

### Track Over Time
- Average quality scores
- Dimension-specific averages
- Pass/fail rates
- Improvement trends

### Benchmark Targets
- Minimum: 80/100 (quality gate)
- Good: 85/100 (production ready)
- Excellent: 90/100 (high quality)
- Outstanding: 95/100 (exceptional)

## Current Status

### ✅ High Quality Skills
- Most skills achieve ≥85/100
- Excellent autonomy scores (100%)
- Good progressive disclosure compliance

### ❌ Needs Improvement
- test-runner: Progressive disclosure violation
- ralph-orchestrator-expert: Progressive disclosure violation
- Overall: Need full 11-dimensional scoring

### 📋 Verification Needed
- Complete scoring for all 18 skills
- Identify skills below 80/100
- Create improvement plans

## Fix Priority

### Immediate (Critical)
1. Score all skills with 11-dimensional framework
2. Identify skills below 80/100
3. Fix progressive disclosure violations
4. Address autonomy issues

### Short-term (High)
5. Establish quality gate process
6. Train evaluators on scoring rubric
7. Create quality checklist
8. Build scoring automation

### Medium-term (Medium)
9. Track quality metrics over time
10. Create quality dashboard
11. Benchmark against best practices
12. Publish quality guidelines

## Validation Tools

### Automated Checks
```bash
# Progressive disclosure check
find .claude/skills -name "SKILL.md" -exec wc -l {} \;

# WIN marker check
grep -r "## .*_COMPLETE" .claude/skills/*/SKILL.md

# Autonomy check
grep "permission_denials" test-output.json
```

### Manual Evaluation
1. Use scoring rubric
2. Document scores
3. Identify issues
4. Provide feedback
5. Re-evaluate after fixes

## Out of Scope

### Not Covered by This Specification
- Specific skill architectures
- TaskList orchestration
- Testing methodologies
- Security specifics

## References
- Quality framework: `.claude/rules/quality-framework.md`
- Autonomy: `specs/autonomy-knowledge.spec.md`
- Progressive disclosure: `specs/progressive-disclosure-knowledge.spec.md`
- Skills spec: `specs/skills.spec.md`
- Test plan: `tests/skill_test_plan.json`
