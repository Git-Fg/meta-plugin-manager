---
name: test-coverage
description: "Analyze test coverage and generate missing tests when coverage is below 80%, adding new features, or improving test quality. Ensures comprehensive test coverage."
disable-model-invocation: true
---

<mission_control>
<objective>Analyze test coverage and generate missing tests to reach 80%+ threshold</objective>
<success_criteria>Coverage gaps identified, tests generated, coverage increased to target</success_criteria>
</mission_control>

# Test Coverage Command

Analyze test coverage and generate missing tests to reach 80%+ coverage threshold.

## What This Command Does

Execute coverage analysis and test generation:

1. **Run tests with coverage** - Execute test suite with coverage flags
2. **Parse coverage report** - Read coverage/coverage-summary.json or similar
3. **Identify gaps** - Find files below 80% coverage threshold
4. **Analyze untested paths** - Determine missing test scenarios
5. **Generate tests** - Create unit, integration, and E2E tests
6. **Verify and report** - Run new tests, show before/after metrics

## Coverage Thresholds

| Coverage Level | Status    | Action            |
| -------------- | --------- | ----------------- |
| 90-100%        | Excellent | Maintain          |
| 80-89%         | Good      | Acceptable        |
| 70-79%         | Fair      | Needs improvement |
| < 70%          | Poor      | Requires action   |

## Test Generation Process

### Step 1: Run Coverage

- `Bash: npm run test:coverage` → Run coverage with npm
- `Bash: pnpm test --coverage` → Run coverage with pnpm
- `Bash: bun test --coverage` → Run coverage with bun

### Step 2: Analyze Report

Parse coverage report (coverage/coverage-summary.json or similar):

```json
{
  "total": {
    "lines": { "total": 1000, "covered": 850, "skipped": 0, "pct": 85 },
    "statements": { "pct": 82 },
    "functions": { "pct": 88 },
    "branches": { "pct": 75 }
  }
}
```

### Step 3: Identify Under-Covered Files

List files below 80% threshold:

```
src/utils/formatters.ts - 65% (needs +15%)
src/api/handlers.ts - 50% (needs +30%)
src/components/Button.tsx - 72% (needs +8%)
```

### Step 4: Generate Tests by Category

**Unit Tests** (for functions and classes):

- Happy path scenarios
- Error handling
- Edge cases (null, undefined, empty)
- Boundary conditions

**Integration Tests** (for APIs and services):

- End-to-end flows
- Database interactions
- External service calls
- Error responses

**E2E Tests** (for critical user flows):

- Login/logout
- Checkout process
- Data submission
- Navigation flows

### Step 5: Test Coverage Categories

**Line Coverage** - Each executable line tested
**Statement Coverage** - Each statement executed
**Function Coverage** - Each function called
**Branch Coverage** - Each branch (if/else) taken

### Step 6: Verify and Report

Before and after comparison:

```
BEFORE:
Total Coverage: 72%
Lines: 75%, Functions: 80%, Branches: 65%

AFTER:
Total Coverage: 86%
Lines: 88%, Functions: 92%, Branches: 82%
```

## Test Generation Patterns

### Happy Path Tests

```typescript
describe("calculateTotal", () => {
  it("calculates total for valid inputs", () => {
    expect(calculateTotal([10, 20, 30])).toBe(60);
  });
});
```

### Error Handling Tests

```typescript
describe("calculateTotal", () => {
  it("throws on empty array", () => {
    expect(() => calculateTotal([])).toThrow("Empty array");
  });

  it("throws on non-array input", () => {
    expect(() => calculateTotal(null)).toThrow("Invalid input");
  });
});
```

### Edge Case Tests

```typescript
describe("calculateTotal", () => {
  it("handles null values", () => {
    expect(calculateTotal([10, null, 20])).toBe(30);
  });

  it("handles undefined values", () => {
    expect(calculateTotal([10, undefined, 20])).toBe(30);
  });

  it("handles negative numbers", () => {
    expect(calculateTotal([10, -5, 20])).toBe(25);
  });
});
```

### Boundary Tests

```typescript
describe("calculateTotal", () => {
  it("handles single element", () => {
    expect(calculateTotal([42])).toBe(42);
  });

  it("handles large numbers", () => {
    expect(calculateTotal([Number.MAX_SAFE_INTEGER])).toBe(
      Number.MAX_SAFE_INTEGER,
    );
  });

  it("handles zero", () => {
    expect(calculateTotal([0, 0, 0])).toBe(0);
  });
});
```

## Integration

This command integrates with:

- `engineering-lifecycle` - Ensure tests pass before committing
- `code-review` - Check test coverage during review
- `verify` - Complete quality check including coverage

## Arguments

This command does not interpret special arguments. Everything after `qa/test-coverage` is treated as additional context for coverage analysis.

**Optional context you can provide**:

- Target threshold ("target 90% coverage")
- Specific files ("only test src/api/")
- Test type ("only generate unit tests")

---

<critical_constraint>
MANDATORY: Flag files below 80% coverage threshold
MANDATORY: Generate tests that cover actual gaps, not boilerplate
MANDATORY: Run tests to verify new tests pass
MANDATORY: Report before/after coverage metrics
No exceptions. Coverage analysis must drive actual improvement.
</critical_constraint>
