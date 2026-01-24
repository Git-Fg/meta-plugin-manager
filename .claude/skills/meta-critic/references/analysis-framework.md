# Meta-Critic Analysis Framework

Detailed framework for performing meta-critic reviews of conversations and workflows.

## Three-Way Comparison Model

Meta-critic performs a triangular analysis between three reference points:

```
        REQUEST (User Intent)
              /    \
             /      \
            /        \
           /          \
     STANDARDS      DELIVERED
    (Knowledge)    (Execution)
```

## Analysis Dimensions

### 1. Intent Alignment

**Question**: Did the execution match what was originally requested?

**Check Process**:
1. Extract user's original request from conversation
2. Identify stated goals, constraints, preferences
3. Compare actual deliverable against original intent
4. Identify any scope drift or misinterpretation

**Scoring**:
- 10/10: Perfect alignment, exact match
- 8-9/10: Minor variations, core intent met
- 6-7/10: Some drift, mostly aligned
- <6/10: Significant misalignment

### 2. Standards Compliance

**Question**: Does the output comply with relevant knowledge-skills?

**Check Process**:
1. Identify applicable knowledge-skills
2. Extract relevant standards from each
3. Validate deliverable against standards
4. Note any violations or deviations

**Common Standards**:

| Standard | Validation Points |
|----------|-------------------|
| Skill Structure | YAML frontmatter, description format, <500 lines |
| Progressive Disclosure | Tier 1/2/3 properly organized |
| Factory Pattern | Scripts directory, executable, documented |
| Knowledge Purity | No execution logic in knowledge skills |

**Scoring**:
- 10/10: Full compliance, all standards met
- 8-9/10: Minor deviations, non-critical
- 6-7/10: Some violations, needs attention
- <6/10: Major standard violations

### 3. Completeness

**Question**: Were all requirements addressed?

**Check Process**:
1. List explicit requirements from request
2. List implicit requirements (inferred from context)
3. Verify each requirement has corresponding deliverable
4. Identify missing or incomplete items

**Scoring**:
- 10/10: All requirements met, plus enhancements
- 8-9/10: All explicit requirements met
- 6-7/10: Minor gaps, mostly complete
- <6/10: Significant missing requirements

### 4. Quality

**Question**: Is the work production-ready?

**Check Process**:
1. Evaluate code quality (structure, naming, patterns)
2. Check documentation completeness
3. Verify testing/verification performed
4. Assess maintainability and extensibility

**Scoring**:
- 10/10: Production-ready, best practices
- 8-9/10: High quality, minor polish needed
- 6-7/10: Functional, needs improvement
- <6/10: Poor quality, significant work needed

## Issue Classification

### Critical (Blocking)
- Security vulnerabilities
- Standard violations that break functionality
- Complete misalignment with request
- Missing core requirements

### High Priority
- Significant drift from standards
- Incomplete implementation
- Quality issues affecting reliability

### Medium Priority
- Minor standard deviations
- Documentation gaps
- Code quality improvements

### Low Priority
- Cosmetic issues
- Nice-to-have enhancements
- Minor optimizations

## Critique Output Structure

### Executive Summary
- Overall assessment (Pass/Fail/Conditional)
- Total quality score
- Critical issues (if any)

### Detailed Analysis
- Intent alignment breakdown
- Standards compliance check
- Completeness verification
- Quality assessment

### Findings
- Strengths (what went well)
- Issues (problems found, by priority)
- Recommendations (actionable steps)

## Usage Examples

### Example 1: Skill Creation Review

**Request**: "Create a skill for analyzing Docker logs"

**Deliverable**:
- Skill: `docker-log-analyzer`
- Context: fork
- Includes: `scripts/parse_logs.py`

**Analysis**:
- Intent: ✅ Docker log analysis
- Standards: ✅ Proper structure, fork for verbose task
- Completeness: ✅ Core capability present
- Quality: ✅ Script-based execution, documented

**Score**: 38/40 - Pass

### Example 2: MCP Configuration Review

**Request**: "Add web search MCP server"

**Deliverable**:
- `.mcp.json` updated with exa MCP
- Transport: stdio
- Command: npx

**Analysis**:
- Intent: ✅ Web search capability
- Standards: ⚠️ stdio used for cloud service (should be streamable-http)
- Completeness: ✅ Functional
- Quality: ⚠️ Not optimal for production

**Score**: 32/40 - Conditional (recommend transport change)

### Example 3: Workflow Drift Detection

**Request**: "Create RESTful API endpoints for user management"

**Deliverable**:
- API endpoints created
- Inconsistent response formats
- No error handling pattern

**Analysis**:
- Intent: ⚠️ Partial - endpoints exist but not RESTful
- Standards: ❌ Response format not standardized
- Completeness: ⚠️ Missing error handling
- Quality: ❌ Inconsistent, hard to maintain

**Score**: 24/40 - Fail (needs refactoring)

## Continuous Improvement

Meta-critic itself should evolve based on:
- Pattern recognition in common issues
- Feedback on critique quality
- Changes in knowledge-skills standards
- Evolving best practices

## References

See [workflow-examples.md](workflow-examples.md) for detailed meta-critic session examples.
