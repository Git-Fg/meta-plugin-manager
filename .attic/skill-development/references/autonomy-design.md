# Autonomy Design

Design skills that complete 80-95% of tasks without asking questions.

## The Autonomy Principle

**Target**: 80-95% completion without user questions

- **95% (Excellent)**: 0-1 AskUserQuestion rounds
- **85% (Good)**: 2-3 AskUserQuestion rounds
- **80% (Acceptable)**: 4-5 AskUserQuestion rounds
- **<80% (Fail)**: 6+ AskUserQuestion rounds

**Important**: Each AskUserQuestion round can contain 1-4 questions. The round-trip count matters, not the per-question count.

**Example**:

- 1 round with 4 questions = 1 round-trip (excellent autonomy)
- 4 rounds with 1 question each = 4 round-trips (good autonomy)

**What counts as a question round-trip**:

- ❌ "Which file should I modify?" (should have been discovered)
- ❌ "What should I name this variable?" (should use intelligent naming)
- ❌ "How do you want this formatted?" (should follow patterns)

**What doesn't count**:

- ✅ Reading files for context
- ✅ Running commands as part of workflow
- ✅ Making intelligent decisions based on patterns
- ✅ Multiple questions batched in one AskUserQuestion call (this is efficient)

## High-Autonomy Patterns

### Pattern 1: Clear Input/Output Contract

**Low autonomy** (vague):

```yaml
---
name: file-helper
description: "Helps organize files"
---
Organize your project files.
```

**Questions**: "How?" "What criteria?" "Where to put what?"

**High autonomy** (clear contract):

```yaml
---
name: file-organizer
description: "Organize project files by type and purpose"
---

# File Organizer

**Organize by**:
- Code (*.js, *.ts, *.py) → src/
- Tests (*.test.*, *.spec.*) → tests/
- Docs (*.md) → docs/
- Config (*.config.*, *.rc) → config/

**Output**: List of files moved with source → destination.
```

**Questions**: 0 (100% autonomy)

### Pattern 2: Specific Decision Criteria

**Low autonomy** (ambiguous):

```yaml
---
name: code-reviewer
description: "Review code for issues"
---
Check the code for problems.
```

**Questions**: "What problems?" "What standards?" "How strict?"

**High autonomy** (clear criteria):

```yaml
---
name: code-reviewer
description: "Review code for common issues and patterns"
---

# Code Reviewer

**Check for**:
1. **Security Issues**
   - SQL injection (string concat in queries)
   - XSS (no output encoding)
   - Hardcoded secrets

2. **Code Quality**
   - Unused imports
   - Unreachable code
   - Missing error handling

3. **Patterns**
   - Follow project conventions
   - Consistent naming
   - Proper documentation

**Output**: Issues found with severity (critical/warning/info) and line numbers.
```

**Questions**: 0-1 (95-100% autonomy)

### Pattern 3: Examples for Style-Dependent Tasks

**Low autonomy** (no examples):

```yaml
---
name: api-designer
description: "Design RESTful API endpoints"
---
Create API endpoints following REST principles.
```

**Questions**: "What format?" "What fields?" "How to structure?"

**High autonomy** (concrete examples):

````yaml
---
name: api-designer
description: "RESTful API design patterns for this codebase"
---

# API Designer

## Endpoint Structure

**Route**: `/api/v1/{resource}` (plural)

**Methods**:
- GET /api/v1/users - List all users
- POST /api/v1/users - Create user
- GET /api/v1/users/1 - Get specific user
- PUT /api/v1/users/1 - Replace user
- DELETE /api/v1/users/1 - Delete user

## Response Format

```json
{
  "data": { "id": 1, "name": "User" },
  "error": null,
  "meta": { "version": "v1" }
}
````

## Error Codes

- 400: Validation error
- 401: Authentication required
- 404: Resource not found
- 500: Server error

````
**Questions**: 0-1 (95-100% autonomy)

### Pattern 4: Intelligent Defaults

**Low autonomy** (requires choices):
```yaml
---
name: test-generator
description: "Generate tests for code"
---

What testing framework? What coverage level? What style?
````

**Questions**: 3-4 (75-85% autonomy)

**High autonomy** (sensible defaults):

````yaml
---
name: test-generator
description: "Generate tests following project conventions"
---

# Test Generator

**Framework**: Jest (project standard)
**Coverage**: Target 80% (project goal)
**Style**: Arrange-Act-Assert (project convention)

## Test Template

```javascript
describe('FeatureName', () => {
  // Arrange
  const input = { /* test data */ };

  it('should do X', () => {
    // Act
    const result = functionUnderTest(input);

    // Assert
    expect(result).toBe(expected);
  });
});
````

**Output**: Test file with complete test cases for the function.

````
**Questions**: 0-1 (95-100% autonomy)

## Low-Autonomy Anti-Patterns

### Anti-Pattern 1: Vague Instructions

**Bad**:
```yaml
---
name: optimizer
description: "Optimize code"
---

Make the code faster and better.
````

**Questions**: "What optimization?" "What metrics?" "What's the baseline?"

**Fix**:

```yaml
---
name: query-optimizer
description: "Optimize PostgreSQL queries for performance"
---

# Query Optimizer

**Optimization Targets**:
1. Add indexes on foreign keys
2. Use JOIN instead of subqueries
3. Select specific columns, not SELECT *
4. Add LIMIT for large result sets
5. Use EXPLAIN ANALYZE to verify

**Output**: Optimized query with explanation of changes.
```

### Anti-Pattern 2: Open-Ended Questions

**Bad**:

```yaml
---
name: api-validator
description: "Validate API design"
---
Is this API design good? What would make it better?
```

**Questions**: "What's good?" "What standards apply?"

**Fix**:

```yaml
---
name: api-validator
description: "Validate RESTful API design against project standards"
---

# API Validator

**Checklist**:
- [ ] Route uses plural resource name
- [ ] Response includes data/error/meta
- [ ] Uses appropriate HTTP verbs
- [ ] Error codes follow standard (400/401/404/500)
- [ ] Pagination for list endpoints

**Output**: Pass/fail with specific issues found.
```

### Anti-Pattern 3: Missing Context

**Bad**:

```yaml
---
name: component-builder
description: "Build React components"
---
Create a component for the user's needs.
```

**Questions**: "What component?" "What props?" "What style?"

**Fix**:

````yaml
---
name: component-builder
description: "Build React components following project patterns"
---

# Component Builder

**Component Structure**:
```typescript
interface ComponentNameProps {
  // prop definitions
}

export function ComponentName({ prop1, prop2 }: ComponentNameProps) {
  return (
    <div className="component-name">
      {/* component content */}
    </div>
  );
}
````

**Patterns**:

- Use TypeScript
- Use styled-components or CSS modules
- Include PropTypes or TypeScript interfaces
- Follow naming: PascalCase for components
- Add default exports

**Output**: Complete component file with TypeScript, styles, and export.

````

## Designing for Autonomy

### Step 1: Define Clear Output

**Questions to answer**:
- What exactly will be produced?
- What format will it be in?
- Where will it be created?

**Example**:
```yaml
---
name: migration-generator
description: "Generate database migration files"
---

**Output**: Migration file in `migrations/` with:
- Timestamp prefix: YYYYMMDDHHMMSS
- Descriptive name: describe_change.js
- Up and down functions
````

### Step 2: Specify Decision Criteria

**Questions to answer**:

- What rules govern decisions?
- How should conflicts be resolved?
- What takes priority?

**Example**:

```yaml
---
name: conflict-resolver
description: "Resolve merge conflicts in code"
---

**Resolution Priority**:
1. Incoming changes (unless breaking)
2. Current changes (if tests pass)
3. Manual resolution (if both pass tests)

**Resolution Strategy**:
- Keep both if compatible
- Prefer incoming if current is default/placeholder
- Flag for manual review if both are substantial
```

### Step 3: Provide Concrete Examples

**Questions to answer**:

- What does good output look like?
- What are the common patterns?
- How should edge cases be handled?

**Example**:

````yaml
---
name: error-handler
description: "Add error handling to functions"
---

## Pattern

**Before**:
```javascript
function getData(id) {
  return db.query('SELECT * FROM users WHERE id = ?', [id]);
}
````

**After**:

```javascript
async function getData(id) {
  try {
    const result = await db.query("SELECT * FROM users WHERE id = ?", [id]);
    return result;
  } catch (error) {
    logger.error("Failed to get user", { id, error });
    throw new Error("User not found");
  }
}
```

**Output**: Modified function with try-catch, logging, and error messages.

````

### Step 4: Include Intelligent Defaults

**Questions to answer**:
- What's the most common case?
- What should happen if not specified?
- What are reasonable assumptions?

**Example**:
```yaml
---
name: config-generator
description: "Generate configuration files"
---

**Defaults**:
- Environment: development
- Port: 3000
- Database: PostgreSQL (localhost:5432)
- Logging: info level

**Overrides available**: Pass environment-specific values via arguments.
````

## Testing Autonomy

### Test Method

```bash
# Run skill with test scenario
claude --dangerously-skip-permissions \
  -p "Use skill-name with [test scenario]" \
  --output-format stream-json \
  > test-output.json

# Count questions
grep -c '"tool_name": "AskUserQuestion"' test-output.json
```

### Autonomy Scoring

**Calculate autonomy**:

```
Autonomy % = (1 - questions / expected_interactions) * 100

0 questions → 100% autonomy
1 question in 10 interactions → 90% autonomy
3 questions in 10 interactions → 70% autonomy (fail)
```

### Test Scenarios

**Scenario 1: Common Case**

- Test typical use case
- Expected: 0-1 questions
- Pass if: ≥95% autonomy

**Scenario 2: Edge Case**

- Test unusual but valid scenario
- Expected: 1-2 questions
- Pass if: ≥85% autonomy

**Scenario 3: Ambiguous Input**

- Test unclear request
- Expected: 2-3 questions
- Pass if: ≥80% autonomy

## Quick Autonomy Checklist

**Before publishing, verify**:

- [ ] Clear output format specified
- [ ] Decision criteria defined
- [ ] Concrete examples provided
- [ ] Intelligent defaults included
- [ ] Edge cases addressed
- [ ] No open-ended questions
- [ ] Specific (not vague) instructions
- [ ] Test with common scenarios

**Target**: 0-3 questions in typical use

## Template Patterns for Output

For skills that require specific output formats, provide templates to improve autonomy.

### Strict Template Pattern

**For strict requirements** (API responses, data formats, reports):

```markdown
## Report Structure

ALWAYS use this exact template:

# [Analysis Title]

## Executive Summary

[One-paragraph overview of key findings]

## Key Findings

- Finding 1 with supporting data
- Finding 2 with supporting data
- Finding 3 with supporting data

## Recommendations

1. Specific actionable recommendation
2. Specific actionable recommendation
```

### Flexible Template Pattern

**For flexible guidance** (when adaptation is useful):

```markdown
## Report Structure

Here is a sensible default format, but use your best judgment:

# [Analysis Title]

## Executive Summary

[Overview]

## Key Findings

[Adapt sections based on what you discover]

## Recommendations

[Tailor to the specific context]

Adjust sections as needed for the specific analysis type.
```

### Examples Pattern

**For style-dependent output**, provide input/output pairs:

```markdown
## Commit Message Format

Generate commit messages following these examples:

**Example 1**:
Input: Added user authentication with JWT tokens
Output:
```

feat(auth): implement JWT-based authentication

Add login endpoint and token validation middleware

```

**Example 2**:
Input: Fixed bug where dates displayed incorrectly in reports
Output:
```

fix(reports): correct date formatting in timezone conversion

Use UTC timestamps consistently across report generation

```

Follow this style: type(scope): brief description, then detailed explanation.
```

---

## Ask Once and Efficient Funneling

### Multiple AskUserQuestion Rounds = Efficient, Not Low Autonomy

**Key insight**: Using multiple AskUserQuestion rounds with the l'entonnoir (funnel) pattern is EFFICIENT, not a sign of low autonomy.

**Why multiple rounds are efficient:**

1. **Batching per round** - One round-trip with 2-4 related questions is better than 4 separate round-trips
2. **Interleaved investigation** - Each round narrows the problem space based on answers
3. **Progressive narrowing** - Each round gets closer to execution without fishing
4. **Recognition-based** - Users select from options, don't generate from scratch

### Efficient vs Inefficient Use of AskUserQuestion

**Efficient (good autonomy):**

```
Round 1: [Investigate broadly] "Q1: Category? Q2: Priority?" → User answers
Round 2: [Investigate based on answers] "Q3: Component? Q4: Timeline?" → User answers
Round 3: [Investigate based on answers] "Q5: Confirm approach?" → User answers
Execute

Result: 3 round-trips, but each batched intelligently with investigation between.
This is GOOD autonomy (85%+).
```

**Inefficient (low autonomy):**

```
Round 1: "Q1: What category?" → User answers
Round 2: "Q2: What priority?" → User answers (no investigation between)
Round 3: "Q3: Which component?" → User answers (no investigation)
Round 4: "Q4: When?" → User answers (no investigation)
Round 5: "Q5: How?" → User answers (no investigation)

Result: 5 round-trips, no investigation, no narrowing.
This is LOW autonomy (<80%).
```

**Key distinction:**

- Multiple rounds with funneling = efficient (good)
- Multiple rounds without investigation = inefficient (bad)

### Counting AskUserQuestion Rounds for Autonomy

**How to count:**

```
1 AskUserQuestion call with 1 question = 1 round
1 AskUserQuestion call with 4 questions = 1 round
3 AskUserQuestion calls = 3 rounds total
```

**Autonomy scoring:**

| Rounds | Questions Total | Autonomy | Rating     |
| ------ | --------------- | -------- | ---------- |
| 0-1    | 0-4             | 95-100%  | Excellent  |
| 2-3    | 2-12            | 85-95%   | Good       |
| 4-5    | 4-20            | 80-85%   | Acceptable |
| 6+     | 6+              | <80%     | Fail       |

**Example efficient funneling:**

```
Round 1: AskUserQuestion with 3 questions (tech stack) → 1 round
Round 2: AskUserQuestion with 2 questions (deployment) → 1 round
Round 3: AskUserQuestion with 1 question (confirm) → 1 round
Total: 3 rounds, 6 questions = 85% autonomy (Good)
```

### Funneling vs Fishing

**Funneling (efficient):**

Each round investigates based on previous answers, then asks targeted questions.

```
Round 1: "Q1: Type? Q2: Priority?"
  → [Investigate based on answers]
Round 2: "Q3: Which [type] component? Q4: How urgent?"
  → [Investigate based on answers]
Round 3: "Q5: Confirm [specific approach]?"
Execute
```

**Fishing (inefficient):**

Asking without investigation or narrowing.

```
Round 1: "Q1: What's wrong?"
  → [No investigation]
Round 2: "Q2: More details?"
  → [No investigation]
Round 3: "Q3: Even more details?"
  → [No investigation, just fishing]
```

---

## Summary

**High autonomy** comes from:

1. **Clear contracts** - What goes in, what comes out
2. **Specific criteria** - How decisions are made
3. **Concrete examples** - What good looks like
4. **Sensible defaults** - What to do when uncertain
5. **Template patterns** - Output format guidance

**Trust AI intelligence**: Provide patterns and examples, not micromanagement.

**Result**: Skills that complete 80-95% of tasks independently.

**See also**:

- [quality-framework.md](quality-framework.md) - Autonomy dimension scoring
- [anti-patterns.md](anti-patterns.md) - Common autonomy issues
