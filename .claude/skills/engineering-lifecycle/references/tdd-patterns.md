# TDD Patterns Reference

Test-Driven Development discipline for implementation.

## The Iron Law

NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST

Write code before the test? Delete it. Start over. No exceptions.

## The Three Laws of TDD

1. **Write failing test before production code** - No code without a failing test
2. **Write only enough test to fail** - Minimize test code
3. **Write only enough code to pass** - Minimize production code

## RED → GREEN → REFACTOR Cycle

### RED - Write Failing Test

Write one minimal test showing what should happen.

Requirements:

- One behavior
- Clear name
- Real code (no mocks unless unavoidable)

Example:

```typescript
test("retries failed operations 3 times", async () => {
  let attempts = 0;
  const operation = () => {
    attempts++;
    if (attempts < 3) throw new Error("fail");
    return "success";
  };

  const result = await retryOperation(operation);

  expect(result).toBe("success");
  expect(attempts).toBe(3);
});
```

### Verify RED - Watch It Fail

MANDATORY. Never skip.

```bash
npm test path/to/test.test.ts
```

Confirm:

- Test fails (not errors)
- Failure message is expected
- Fails because feature missing (not typos)

### GREEN - Minimal Code

Write simplest code to pass the test.

Don't add features, refactor other code, or "improve" beyond the test.

### Verify GREEN - Watch It Pass

MANDATORY.

```bash
npm test path/to/test.test.ts
```

Confirm:

- Test passes
- Other tests still pass
- Output pristine (no errors, warnings)

### REFACTOR - Clean Up

After green only:

- Remove duplication
- Improve names
- Extract helpers

Keep tests green. Don't add behavior.

## Coverage Requirements

- **80% code coverage** (branches, functions, lines, statements)
- **All edge cases covered** (null, undefined, empty, boundary)
- **All error paths tested** (not just happy paths)
- **E2E tests for critical user flows**

## Test Types

### Unit Tests (Fast, Isolated)

Purpose: Test individual functions and components in isolation

When to use:

- Pure functions (no side effects)
- Component logic (state, props)
- Utilities and helpers
- Business logic

### Integration Tests (Connected)

Purpose: Test how components work together

When to use:

- API endpoints with database
- Service interactions
- External API calls
- Database operations

### E2E Tests (Critical Flows)

Purpose: Test complete user workflows

When to use:

- Critical user flows (login, checkout)
- Cross-component interactions
- Browser automation

## Common Rationalizations to Reject

| Rationalization              | Reality                                       |
| ---------------------------- | --------------------------------------------- |
| "Too simple to test"         | Simple code breaks. Test takes 30 seconds.    |
| "I'll test after"            | Tests passing immediately prove nothing.      |
| "Already manually tested"    | Ad-hoc ≠ systematic. No record, can't re-run. |
| "Keep as reference"          | You'll adapt it. Delete means delete.         |
| "TDD will slow me down"      | TDD faster than debugging.                    |
| "Test hard = design unclear" | Listen to test. Hard to test = hard to use.   |

## Red Flags - STOP and Start Over

- Code before test
- Test after implementation
- Test passes immediately
- Can't explain why test failed
- Rationalizing "just this once"

## Verification Checklist

- [ ] Tests written FIRST (TDD cycle followed)
- [ ] All tests passing (green)
- [ ] 80%+ coverage achieved
- [ ] Edge cases covered (null, empty, boundary)
- [ ] Error paths tested
- [ ] No skipped or disabled tests
