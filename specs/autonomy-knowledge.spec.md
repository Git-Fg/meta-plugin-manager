# Autonomy Knowledge Specification

## Summary
This specification defines autonomy requirements for skills, emphasizing 80-95% completion without questions through clear instructions, comprehensive context, and thorough examples.

## Autonomy Definition

### Concept
Autonomy measures a skill's ability to complete tasks independently without requiring user clarification or input beyond the initial invocation.

### Why It Matters
- **User Experience**: Skills should work independently
- **Efficiency**: Reduces back-and-forth communication
- **Reliability**: Consistent execution across contexts
- **Quality**: Higher autonomy indicates better instructions

## Given-When-Then Acceptance Criteria

### G1: Autonomy Scoring
**Given** a skill execution in test environment
**When** autonomy is evaluated
**Then** it MUST calculate based on questions asked:

**Scoring Methodology**:
1. Extract test-output.json line 3
2. Count entries in `permission_denials` array
3. Count AskUserQuestion tool invocations
4. Map to autonomy percentage

**Autonomy Levels**:
- 95% (Excellent): 0-1 questions
- 85% (Good): 2-3 questions
- 80% (Acceptable): 4-5 questions
- <80% (Fail): 6+ questions (requires refactoring)

### G2: What Counts as Question
**Given** a skill execution
**When** evaluating questions
**Then** it MUST distinguish:

**❌ Counts as Question**:
- "Which file should I modify?"
- "What should I name this variable?"
- "Where should I put this code?"
- "Do you want me to continue?"
- "Should I use TypeScript or JavaScript?"
- Any AskUserQuestion invocation requesting user input

**✅ Does NOT Count as Question**:
- Reading files for context (Read tool)
- Running bash commands (Bash tool)
- Using Grep/Glob for search (Grep/Glob tools)
- Writing files (Write/Edit tools)
- Any tool usage for execution
- Self-directed exploration

### G3: Required Context
**Given** a skill requiring autonomy
**When** writing skill description
**Then** it MUST provide:
- Clear task definition
- Expected inputs/outputs
- Examples of usage
- Edge cases and handling
- Context-specific guidance

### G4: Test Execution
**Given** autonomy test scenario
**When** running skill with test prompt
**Then** it MUST achieve:
- ≥80% autonomy (≤5 questions)
- Complete task successfully
- No permission denials blocking execution
- Clear completion marker output

### G5: Autonomy Improvement
**Given** skill scoring <80%
**When** improving autonomy
**Then** it MUST:
- Analyze question patterns
- Add missing context to description
- Provide more examples
- Clarify ambiguous instructions
- Re-test until ≥80%

## Input/Output Examples

### Example 1: Perfect Autonomy (0 Questions)
**Test Prompt**: "Create README with project structure"
**Skill Execution**:
```
[No questions asked]
- Reads project files (tool usage, not question)
- Analyzes structure (tool usage, not question)
- Creates README (tool usage, not question)
- Outputs completion marker
```
**Result**: 0 questions → 100% autonomy ✓

### Example 2: Good Autonomy (2 Questions)
**Test Prompt**: "Set up TypeScript project"
**Skill Execution**:
```
Question 1: "Which directory should I use for the project?" [counts]
Action: Reads current directory structure
Question 2: "Do you want me to install additional dependencies?" [counts]
Action: Installs base dependencies
[Completes successfully]
```
**Result**: 2 questions → 85% autonomy ✓

### Example 3: Failing Autonomy (7 Questions)
**Test Prompt**: "Implement user authentication"
**Skill Execution**:
```
Question 1: "Where should I create the auth files?" [counts]
Question 2: "What auth method do you prefer?" [counts]
Question 3: "Should I use JWT or sessions?" [counts]
Question 4: "Where is your database config?" [counts]
Question 5: "Do you have existing user models?" [counts]
Question 6: "Should I create tests?" [counts]
Question 7: "Do you want documentation?" [counts]
[Task incomplete due to questions]
```
**Result**: 7 questions → <80% autonomy ✗
**Action**: Requires refactoring

## Autonomy Testing Methodology

### Step 1: Prepare Test Environment
```bash
# Create test directory
mkdir test-autonomy
cd test-autonomy

# Create test prompt
echo "Create README with project structure" > prompt.txt

# Run skill with test
claude -p "$(cat prompt.txt)" --output-format stream-json \
  --verbose --debug --no-session-persistence \
  --max-turns 8 > test-output.json 2>&1
```

### Step 2: Analyze Results
```bash
# Extract line 3 (permission_denials)
sed -n '3p' test-output.json

# Count questions
grep -c "AskUserQuestion" test-output.json

# Review execution log
cat test-output.json
```

### Step 3: Calculate Score
```json
# Line 3 structure
{
  "permission_denials": [
    {
      "tool_name": "AskUserQuestion",
      "tool_input": {
        "questions": [...]
      }
    }
  ]
}
```

**Question Count**: Length of permission_denials array
**Autonomy Calculation**:
- 0-1 questions: 95% (Excellent)
- 2-3 questions: 85% (Good)
- 4-5 questions: 80% (Acceptable)
- 6+ questions: <80% (Fail)

### Step 4: Document Results
```
Test: Create README with project structure
Questions: 0
Autonomy: 100% (Excellent)
Status: PASS
```

## Improving Autonomy

### Strategy 1: Add Context
**Problem**: Skill asks for basic context
**Solution**: Provide context in description

**Before**:
```markdown
# Create README
Create a README file for the project.
```

**After**:
```markdown
# Create README
Create a comprehensive README.md file that includes:
- Project description
- Installation instructions
- Usage examples
- Project structure overview

Assume current directory is project root. Use files in current directory for structure analysis.
```

### Strategy 2: Provide Examples
**Problem**: Skill uncertain about format
**Solution**: Add concrete examples

**Before**:
```markdown
# Set up testing
Add testing configuration to the project.
```

**After**:
```markdown
# Set up testing
Add Jest testing configuration:

1. Install jest and @types/jest
2. Create jest.config.js with:
   - testEnvironment: 'node'
   - collectCoverage: true
   - coverageDirectory: 'coverage'
3. Create sample test in __tests__/ directory
4. Add test script to package.json: "test": "jest"

Use TypeScript if tsconfig.json exists, JavaScript otherwise.
```

### Strategy 3: Clarify Edge Cases
**Problem**: Skill asks about variations
**Solution**: Define handling for common cases

**Example**:
```markdown
# Code Review
Perform code review with these rules:

- If no Git repo: Check for .git directory first
- If package.json missing: Flag as incomplete setup
- If TypeScript: Check for tsconfig.json and type safety
- If Node.js: Check for package.json scripts
- Always provide actionable feedback with examples
```

### Strategy 4: Use What-When-Not Framework
**Structure**:
- **WHAT**: What the skill does
- **WHEN**: When to use it
- **NOT**: What it doesn't do

**Example**:
```markdown
# Security Scanner
WHAT: Scans code for common security vulnerabilities
WHEN: Use on any codebase before deployment
NOT: Does not fix issues, only identifies them

Scan for:
- Hardcoded credentials
- SQL injection patterns
- XSS vulnerabilities
- Insecure random number generation
- Missing input validation

Output: List of findings with severity and fix suggestions.
```

## Common Autonomy Failures

### Failure 1: Missing Context
**Symptom**: "Which directory should I use?"
**Cause**: Not specified in description
**Fix**: Add directory guidance

### Failure 2: Ambiguous Instructions
**Symptom**: "What should I name this file?"
**Cause**: Multiple valid options
**Fix**: Specify naming conventions

### Failure 3: Undefined Edge Cases
**Symptom**: "What if X doesn't exist?"
**Cause**: Not covered in instructions
**Fix**: Define handling for edge cases

### Failure 4: Missing Examples
**Symptom**: "How should I format this?"
**Cause**: No format specified
**Fix**: Add concrete examples

### Failure 5: Over-Reliance on User
**Symptom**: "Do you want me to continue?"
**Cause**: Skill not confident
**Fix**: Provide clearer decision criteria

## Autonomy Levels Deep Dive

### Level 1: 95% (Excellent)
**Characteristics**:
- 0-1 questions maximum
- Self-directed decision making
- Comprehensive context provided
- Examples cover all cases

**Example**: Quality Audit Skill
- Analyzes project structure automatically
- Makes decisions based on detected files
- Provides complete output
- Never asks for clarification

### Level 2: 85% (Good)
**Characteristics**:
- 2-3 questions maximum
- Minor clarifications needed
- Most context provided
- Some examples missing

**Example**: Project Setup Skill
- Asks for project type (minor clarification)
- Sets up everything else automatically
- Asks about optional features
- Completes successfully

### Level 3: 80% (Acceptable)
**Characteristics**:
- 4-5 questions maximum
- Basic functionality works
- Some ambiguity remains
- Core use cases covered

**Example**: Code Generator Skill
- Asks about code style preferences
- Asks about framework versions
- Generates code based on input
- Requires some user input

### Level 4: <80% (Fail)
**Characteristics**:
- 6+ questions
- Significant ambiguity
- Incomplete instructions
- Poor user experience

**Example**: Generic Helper Skill
- Asks about every decision
- No clear context provided
- Relies on user for guidance
- Requires extensive interaction

## Quality Framework Integration

### Autonomy Dimension (10 points)
- 10 points: 95% autonomy (0-1 questions)
- 8 points: 85% autonomy (2-3 questions)
- 5 points: 80% autonomy (4-5 questions)
- 0 points: <80% autonomy (6+ questions)

### Impact on Overall Quality
**Total Quality Score**: ≥80/100 required
**Autonomy Weight**: 10% of total score
**Critical**: Below 80 autonomy fails quality gate

## Testing Best Practices

### Test Scenarios
1. **Discovery Test**: "List available skills"
2. **Autonomy Test**: "Create README with project structure"
3. **Forked Test**: "Call forked skill, verify isolation"
4. **Context Test**: "Use skill with minimal input"
5. **Edge Case Test**: "Use skill with incomplete project"

### Test Automation
```bash
#!/bin/bash
# autonomy-test.sh

SKILL_NAME=$1
TEST_PROMPT=$2

echo "Testing: $SKILL_NAME"
echo "Prompt: $TEST_PROMPT"

mkdir -p test-autonomy
cd test-autonomy

claude -p "$TEST_PROMPT" --output-format stream-json \
  --verbose --debug --no-session-persistence \
  --max-turns 8 > test-output.json 2>&1

# Count questions
QUESTIONS=$(sed -n '3p' test-output.json | grep -o '"tool_name": "AskUserQuestion"' | wc -l)

echo "Questions: $QUESTIONS"

if [ $QUESTIONS -le 5 ]; then
  echo "Status: PASS"
else
  echo "Status: FAIL"
fi
```

## Current Implementation Status

### ✅ Excellent Autonomy (100%)
**Evidence**: Test results show "Average Autonomy: 100% (0 permission denials)"
**Skills**: Most skills achieve excellent autonomy
**Tests**: 25 tests analyzed, all passed with 0 questions

### ⚠️ Needs Verification
- Actual autonomy scores for all 18 skills
- Edge case testing for complex workflows
- Forked skill autonomy validation
- Real-world usage patterns

### 📋 Test Coverage
- test_2.3: Independent decision-making validated
- test_10_1: No permission denials
- All 25 completed tests: 0 permission denials

## Fix Priority

### Immediate (Critical)
1. **Audit all skills**: Measure actual autonomy scores
2. **Identify failures**: Find skills <80% autonomy
3. **Refactor low performers**: Improve context and examples
4. **Verify improvements**: Re-test after changes

### Short-term (High)
5. **Standardize testing**: Create autonomy test suite
6. **Add to quality gate**: Require ≥80% autonomy
7. **Train developers**: Teach What-When-Not framework
8. **Create examples**: Provide good autonomy examples

### Medium-term (Medium)
9. **Build automation**: Automated autonomy scoring
10. **Track trends**: Monitor autonomy over time
11. **Create benchmarks**: Set targets for skill types
12. **Publish guidelines**: Best practices documentation

## Autonomy Checklist

### Before Submission
- [ ] Description provides clear context
- [ ] Examples cover common use cases
- [ ] Edge cases are handled
- [ ] No ambiguous instructions
- [ ] Self-directed decision making possible

### Testing
- [ ] Run autonomy test
- [ ] Count questions in test-output.json
- [ ] Verify ≥80% autonomy achieved
- [ ] Check task completion
- [ ] Validate WIN marker present

### If Autonomy <80%
- [ ] Identify question patterns
- [ ] Add missing context
- [ ] Provide more examples
- [ ] Clarify ambiguous sections
- [ ] Re-test until ≥80%

## Out of Scope

### Not Covered by This Specification
- Progressive disclosure details (see progressive-disclosure-knowledge.spec.md)
- Context fork patterns (see hub-and-spoke-knowledge.spec.md)
- Quality framework overall (see quality.spec.md)
- Testing methodologies (see quality.spec.md)

## References
- Quality framework: `.claude/rules/quality-framework.md`
- Test runner: `.claude/skills/test-runner/SKILL.md`
- Test plan: `tests/skill_test_plan.json`
- Autonomy testing: `skills/test-runner/references/autonomy-testing.md`
- Test results: `tests/results/TEST_RESULTS_SUMMARY.md`
