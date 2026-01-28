---
name: tdd-workflow
description: "Apply Test-Driven Development (TDD) when writing new features, fixing bugs, or refactoring. Not for prototyping, 'test-after' workflows, or skipping the Red-Green-Refactor cycle."
---

# Test-Driven Development Workflow

Test-Driven Development (TDD) with mandatory 80% coverage gate and comprehensive testing strategy.

## The Iron Law

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

Write code before the test? Delete it. Start over.

**No exceptions:**

- Don't keep it as "reference"
- Don't "adapt" it while writing tests
- Don't look at it
- Delete means delete

Implement fresh from tests. Period.

---

## Common Rationalizations

| Rationalization (Stop)                 | Reality                                                                 |
| -------------------------------------- | ----------------------------------------------------------------------- |
| "Too simple to test"                   | Simple code breaks. Test takes 30 seconds.                              |
| "I'll test after"                      | Tests passing immediately prove nothing.                                |
| "Tests after achieve same goals"       | Tests-after = "what does this do?" Tests-first = "what should this do?" |
| "Already manually tested"              | Ad-hoc ≠ systematic. No record, can't re-run.                           |
| "Deleting X hours is wasteful"         | Sunk cost fallacy. Keeping unverified code is technical debt.           |
| "Keep as reference, write tests first" | You'll adapt it. That's testing after. Delete means delete.             |
| "Need to explore first"                | Fine. Throw away exploration, start with TDD.                           |
| "Test hard = design unclear"           | Listen to test. Hard to test = hard to use.                             |
| "TDD will slow me down"                | TDD faster than debugging. Pragmatic = test-first.                      |
| "Manual test faster"                   | Manual doesn't prove edge cases. You'll re-test every change.           |
| "Existing code has no tests"           | You're improving it. Add tests for existing code.                       |

---

## Quick Navigation

| If you need...        | MANDATORY READ WHEN... | File                             |
| --------------------- | ---------------------- | -------------------------------- |
| Testing patterns      | WRITING TESTS          | `references/testing-patterns.md` |
| Mock strategies       | MOCKING EXTERNAL DEPS  | `references/testing-patterns.md` |
| Coverage verification | CHECKING COVERAGE      | `references/testing-patterns.md` |

---

## Core TDD Philosophy

### The Three Laws of TDD

1. **Write failing test before production code** - No code without a failing test
2. **Write only enough test to fail** - Minimize test code
3. **Write only enough code to pass** - Minimize production code

### RED → GREEN → REFACTOR Cycle

<logic_flow>
<tdd_cycle>
digraph TDD {
WriteTest -> RunTest;
RunTest -> WriteCode [label="Fail (Red)"];
RunTest -> RewriteTest [label="Pass (Bad Test)"];
WriteCode -> RunTest2;
RunTest2 -> Refactor [label="Pass (Green)"];
RunTest2 -> WriteCode [label="Fail"];
Refactor -> RunTest3;
RunTest3 -> Done [label="Pass"];
}
</tdd_cycle>
</logic_flow>

**MANDATORY**: Never skip phases. Never write code before tests.

### RED - Write Failing Test

Write one minimal test showing what should happen.

<Good>
```typescript
test('retries failed operations 3 times', async () => {
  let attempts = 0;
  const operation = () => {
    attempts++;
    if (attempts < 3) throw new Error('fail');
    return 'success';
  };

const result = await retryOperation(operation);

expect(result).toBe('success');
expect(attempts).toBe(3);
});

```
Clear name, tests real behavior, one thing
</Good>

<Bad>
```typescript
test('retry works', async () => {
  const mock = jest.fn()
    .mockRejectedValueOnce(new Error())
    .mockRejectedValueOnce(new Error())
    .mockResolvedValueOnce('success');
  await retryOperation(mock);
  expect(mock).toHaveBeenCalledTimes(3);
});
```

Vague name, tests mock not code
</Bad>

**Requirements:**

- One behavior
- Clear name
- Real code (no mocks unless unavoidable)

### Verify RED - Watch It Fail

**MANDATORY. Never skip.**

```bash
npm test path/to/test.test.ts
```

Confirm:

- Test fails (not errors)
- Failure message is expected
- Fails because feature missing (not typos)

**Test passes?** You're testing existing behavior. Fix test.

**Test errors?** Fix error, re-run until it fails correctly.

### GREEN - Minimal Code

Write simplest code to pass the test.

<Good>
```typescript
async function retryOperation<T>(fn: () => Promise<T>): Promise<T> {
  for (let i = 0; i < 3; i++) {
    try {
      return await fn();
    } catch (e) {
      if (i === 2) throw e;
    }
  }
  throw new Error('unreachable');
}
```
Just enough to pass
</Good>

<Bad>
```typescript
async function retryOperation<T>(
  fn: () => Promise<T>,
  options?: {
    maxRetries?: number;
    backoff?: 'linear' | 'exponential';
    onRetry?: (attempt: number) => void;
  }
): Promise<T> {
  // YAGNI
}
```
Over-engineered
</Bad>

Don't add features, refactor other code, or "improve" beyond the test.

### Verify GREEN - Watch It Pass

**MANDATORY.**

```bash
npm test path/to/test.test.ts
```

Confirm:

- Test passes
- Other tests still pass
- Output pristine (no errors, warnings)

**Test fails?** Fix code, not test.

**Other tests fail?** Fix now.

### REFACTOR - Clean Up

After green only:

- Remove duplication
- Improve names
- Extract helpers

Keep tests green. Don't add behavior.

---

## Why Order Matters

**"I'll write tests after to verify it works"**

Tests written after code pass immediately. Passing immediately proves nothing:

- Might test wrong thing
- Might test implementation, not behavior
- Might miss edge cases you forgot
- You never saw it catch the bug

Test-first forces you to see the test fail, proving it actually tests something.

**"I already manually tested all the edge cases"**

Manual testing is ad-hoc. You think you tested everything but:

- No record of what you tested
- Can't re-run when code changes
- Easy to forget cases under pressure
- "It worked when I tried it" ≠ comprehensive

Automated tests are systematic. They run the same way every time.

**"Deleting X hours of work is wasteful"**

Sunk cost fallacy. The time is already gone. Your choice now:

- Delete and rewrite with TDD (X more hours, high confidence)
- Keep it and add tests after (30 min, low confidence, likely bugs)

The "waste" is keeping code you can't trust. Working code without real tests is technical debt.

**"TDD is dogmatic, being pragmatic means adapting"**

TDD IS pragmatic:

- Finds bugs before commit (faster than debugging after)
- Prevents regressions (tests catch breaks immediately)
- Documents behavior (tests show how to use code)
- Enables refactoring (change freely, tests catch breaks)

"Pragmatic" shortcuts = debugging in production = slower.

**"Tests after achieve the same goals - it's spirit not ritual"**

No. Tests-after answer "What does this do?" Tests-first answer "What should this do?"

Tests-after are biased by your implementation. You test what you built, not what's required. You verify remembered edge cases, not discovered ones.

Tests-first force edge case discovery before implementing. Tests-after verify you remembered everything (you didn't).

30 minutes of tests after ≠ TDD. You get coverage, lose proof tests work.

## Red Flags - STOP and Start Over

- Code before test
- Test after implementation
- Test passes immediately
- Can't explain why test failed
- Tests added "later"
- Rationalizing "just this once"
- "I already manually tested it"
- "Tests after achieve the same purpose"
- "It's about spirit not ritual"
- "Keep as reference" or "adapt existing code"
- "Already spent X hours, deleting is wasteful"
- "TDD is dogmatic, I'm being pragmatic"
- "This is different because..."

**All of these mean: Delete code. Start over with TDD.**

---

## Coverage Requirements

### Minimum Thresholds

- **80% code coverage** (branches, functions, lines, statements)
- **All edge cases covered** (null, undefined, empty, boundary)
- **All error paths tested** (not just happy paths)
- **E2E tests for critical user flows**

### What 80% Means

```json
{
  "coverageThreshold": {
    "global": {
      "branches": 80,
      "functions": 80,
      "lines": 80,
      "statements": 80
    }
  }
}
```

**Recognition**: "Does this test cover actual usage, not just implementation?" → Test user-visible behavior.

---

## TDD Workflow Steps

### Step 1: Write User Journey

Define the behavior in user-centric terms:

```
As a [role], I want to [action], so that [benefit]

Example:
As a user, I want to search for markets semantically,
so that I can find relevant markets even without exact keywords.
```

### Step 2: Generate Test Cases

For each user journey, create comprehensive tests:

**Test types to include**:

- ✅ Happy path (expected success)
- ✅ Edge cases (empty, null, boundary values)
- ✅ Error scenarios (API failures, invalid input)
- ✅ Integration points (database, external services)

### Step 3: Run Tests (They MUST Fail)

```bash
npm test
# Tests should fail - we haven't implemented yet
```

**If tests pass**: You wrote too much code or test is broken

### Step 4: Implement Code

Write minimal code to make tests pass:

```typescript
// Implementation guided by tests
export async function searchMarkets(query: string) {
  // Minimal implementation for tests to pass
}
```

### Step 5: Run Tests Again

```bash
npm test
# Tests should now pass
```

### Step 6: Refactor

Improve code quality while keeping tests green:

- Remove duplication
- Improve naming
- Optimize performance
- Enhance readability

**MANDATORY**: Tests must stay green during refactoring

### Step 7: Verify Coverage

```bash
npm run test:coverage
# Verify 80%+ coverage achieved
```

---

## Test Type Strategy

### Unit Tests (Fast, Isolated)

**Purpose**: Test individual functions and components in isolation

**When to use**:

- Pure functions (no side effects)
- Component logic (state, props)
- Utilities and helpers
- Business logic

**Example target**: < 50ms per test

### Integration Tests (Connected)

**Purpose**: Test how components work together

**When to use**:

- API endpoints with database
- Service interactions
- External API calls
- Database operations

**Mock**: External dependencies (APIs, databases)

### E2E Tests (Critical Flows)

**Purpose**: Test complete user workflows

**When to use**:

- Critical user flows (login, checkout)
- Cross-component interactions
- Browser automation
- UI interactions

**Tool**: Playwright or similar

**Example target**: Cover top 5-10 user journeys

---

## Testing Anti-Patterns

### ❌ Testing Implementation Details

```typescript
// BAD: Tests internal state
expect(component.state.count).toBe(5);

// GOOD: Tests user-visible behavior
expect(screen.getByText("Count: 5")).toBeInTheDocument();
```

### ❌ Brittle Selectors

```typescript
// BAD: Breaks easily
await page.click(".css-class-xyz");

// GOOD: Semantic selectors
await page.click('button:has-text("Submit")');
await page.click('[data-testid="submit-button"]');
```

### ❌ Dependent Tests

```typescript
// BAD: Tests depend on each other
test("creates user", () => {
  /* ... */
});
test("updates same user", () => {
  /* depends on previous */
});

// GOOD: Each test is independent
test("creates user", () => {
  const user = createTestUser();
  // Test logic
});

test("updates user", () => {
  const user = createTestUser();
  // Update logic
});
```

---

## Verification Checklist

Before considering work complete:

- [ ] Tests written FIRST (TDD cycle followed)
- [ ] All tests passing (green)
- [ ] 80%+ coverage achieved
- [ ] Edge cases covered (null, empty, boundary)
- [ ] Error paths tested
- [ ] No skipped or disabled tests
- [ ] Tests run quickly (< 30s for unit tests)
- [ ] E2E tests cover critical flows

---

## Integration with Other Workflows

This skill integrates with:

- `verify` command - Comprehensive quality gates
- `meta-critic` - Quality validation framework
- `coding-standards` - Testing conventions

**Recognition**: "Am I following RED→GREEN→REFACTOR?" → If you wrote code before tests, stop and rewrite.

---

<critical_constraint>
MANDATORY: Write failing test BEFORE production code (RED phase)
MANDATORY: Verify test fails before writing code
MANDATORY: Write minimal code to pass test (GREEN phase)
MANDATORY: Run tests after EVERY code change
MANDATORY: Never skip RED or GREEN phases
No exceptions. TDD discipline catches bugs before commit.
</critical_constraint>

```

```

```

```
