---
name: typescript-conventions
description: "Apply TypeScript conventions for type safety, consistency, and maintainability. Use when writing or refactoring TypeScript code. Includes explicit types, strict mode, error handling patterns (Result<T>, typed errors), naming conventions, immutability patterns, module organization, and testing standards. Not for JavaScript, non-TypeScript languages, or when project conventions explicitly differ."
user-invocable: false
---

<mission_control>
<objective>Apply TypeScript conventions for type safety, consistency, and maintainability across the codebase.</objective>
<success_criteria>Type strictness enforced, explicit types used, consistent patterns applied</success_criteria>
</mission_control>

## The Path to High-Quality TypeScript Code

### 1. Type Safety Through Strictness

TypeScript's compiler catches bugs at compile-time when configured strictly. The `strict: true` setting enables all type-checking options, making the type system work for you rather than against you.

**Why strict mode matters:**

- Catches null/undefined errors before runtime
- Enforces explicit type annotations
- Prevents implicit any types
- Makes code serve as its own documentation

### 2. Explicit Types Over Convenience

Explicit type annotations create clarity and prevent cascading errors. When you specify input and output types, the compiler verifies your logic at every step.

**Why explicit types help:**

- Functions become self-documenting
- Refactoring becomes safe (compiler catches breaking changes)
- Team onboarding is faster (types show intent)
- IDE autocomplete improves dramatically

### 3. Named Semantics Through Conventions

Consistent naming creates shared understanding across the codebase. When interfaces, types, and constants follow predictable patterns, code becomes readable at a glance.

**Why naming conventions matter:**

- PascalCase for types signals "this is a shape or contract"
- camelCase for functions signals "this is an action"
- UPPER_SNAKE_CASE for constants signals "this never changes"
- Predictable patterns reduce cognitive load

### 4. Immutability for Predictability

Immutable data prevents bugs from unexpected mutations. The spread operator creates new objects and arrays, leaving originals unchanged—critical for React rendering and state management.

**Why immutability prevents bugs:**

- No stale closures from mutated references
- React can efficiently detect changes (reference equality)
- State changes become explicit and traceable
- Time-travel debugging becomes possible

### 5. Typed Errors for Traceability

Typed error classes carry context through the call stack. When operations fail, structured error data enables logging, monitoring, and user-friendly messages.

**Why Result<T> pattern works:**

- Forces explicit error handling at call sites
- Error types prevent silent failures
- Context in errors enables debugging
- Error states become part of the type system

## Quick Start

TypeScript conventions that auto-apply when writing TypeScript code. These conventions ensure consistency, type safety, and maintainability across the codebase.

## Quick Start

**Apply TypeScript conventions systematically:**

1. **If you need type safety:** Enforce strict mode → Use explicit types → Define return types → Result: Compile-time error catching
2. **If you need error handling:** Create typed error classes → Use Result<T> pattern → Include context → Result: Traceable failures
3. **If you need consistent patterns:** Follow naming conventions → Use immutability → Use named constants → Result: Maintainable codebase

**Why:** Conventions prevent bugs at compile-time, serve as documentation, and enable safe refactoring.

## Operational Patterns

This skill follows these behavioral patterns:

- **Verification**: Verify code quality using diagnostics and linting
- **Navigation**: Navigate TypeScript code structure for refactoring
- **Tracking**: Maintain a visible task list for convention enforcement

Trust native tools to fulfill these patterns. The System Prompt selects the correct implementation.

## Navigation

| If you need...          | Read...                              |
| :---------------------- | :----------------------------------- |
| Type safety             | ## Quick Start → type safety         |
| Error handling          | ## Quick Start → error handling      |
| Consistent patterns     | ## Quick Start → consistent patterns |
| Type strictness         | ## Type Strictness                   |
| Error handling patterns | ## Error Handling Patterns           |
| Examples                | examples/                            |

## Type Strictness

**Type safety starts with strict configuration:**

- Enable strict mode: `"strict": true` in tsconfig.json
- Use `unknown` instead of `any` when type is truly unknown
- Define explicit return types for all functions
- Prefer interfaces for object shapes that can be extended

**Example - Good:**

```typescript
interface UserRepository {
  findById(id: UserId): Promise<Result<User, NotFoundError>>;
  save(user: User): Promise<Result<void, DatabaseError>>;
}

function validateEmail(email: string): Result<Email, ValidationError> {
  // implementation
}
```

**Example - Type Safety:**

```typescript
// ❌ Avoid: any disables type checking
function validateEmail(email: any): any {
  // No type safety
}

// ✅ Prefer: unknown + type guards
function validateEmail(email: unknown): Email | null {
  if (typeof email !== "string") return null;
  if (!isValidEmailFormat(email)) return null;
  return email as Email;
}
```

## Error Handling

**Typed errors make failures traceable and actionable:**

- Create typed error classes that extend Error
- Include context in error constructors (field, data, metadata)
- Use Result<T> pattern for operations that can fail
- Handle async errors with try/catch in async functions

**Example - Good:**

```typescript
class ValidationError extends Error {
  constructor(
    message: string,
    public readonly field?: string,
    public readonly context?: Record<string, unknown>,
  ) {
    super(message);
    this.name = "ValidationError";
  }
}

function validateUser(
  user: unknown,
): Result<UserValidationResult, ValidationError> {
  try {
    // validation logic
    return { success: true, data: result };
  } catch (error) {
    return {
      success: false,
      error: new ValidationError("Validation failed", "user", {
        error: error.message,
      }),
    };
  }
}
```

**Example - Error Handling:**

```typescript
// ❌ Avoid: bare errors lose context
function validateUser(user: any) {
  if (!user) throw new Error("Invalid user");
  return user;
}

// ✅ Prefer: typed errors with context
class ValidationError extends Error {
  constructor(
    message: string,
    public readonly field?: string,
    public readonly context?: Record<string, unknown>,
  ) {
    super(message);
    this.name = "ValidationError";
  }
}
```

## Naming Conventions

**Follow these patterns:**

| Type                | Convention                        | Example                          |
| ------------------- | --------------------------------- | -------------------------------- |
| Interfaces          | PascalCase with descriptive names | `UserRepository`, `MarketData`   |
| Types               | PascalCase                        | `UserId`, `ApiResponse<T>`       |
| Enums               | PascalCase                        | `UserRole`, `HttpStatus`         |
| Variables/functions | camelCase                         | `getUserById`, `userData`        |
| Constants           | UPPER_SNAKE_CASE                  | `MAX_RETRIES`, `DEFAULT_TIMEOUT` |

**Examples:**

```typescript
interface UserRepository {} // ✅ Good
type UserId = string; // ✅ Good
enum UserRole {} // ✅ Good
const MAX_RETRIES = 3; // ✅ Good
function getUserById(id: UserId) {} // ✅ Good
```

## Module Organization

**Organize code for discoverability and maintainability:**

- Use domain-driven structure: `src/<domain>/<feature>/<File.ts>`
- Export only public interfaces from index.ts files
- Keep files focused (under 300 lines)
- Use named exports for better tree-shaking
- Reserve default exports for single-export modules

**Example - Good:**

```typescript
// src/user/UserRepository.ts
export interface UserRepository {
  findById(id: UserId): Promise<Result<User, NotFoundError>>;
}

export class DatabaseUserRepository implements UserRepository {
  async findById(id: UserId): Promise<Result<User, NotFoundError>> {
    // implementation
  }
}
```

## Immutability Pattern

**Immutable data prevents bugs from unexpected mutations:**

**Why immutability works:**

- Prevents stale closures from mutated references
- Enables React to efficiently detect changes (reference equality)
- Makes state changes explicit and traceable
- Supports time-travel debugging

**Prefer creating new objects:**

```typescript
// ✅ Good: spread creates new reference
const updatedUser = { ...user, name: "New Name" };
const updatedArray = [...items, newItem];

// ❌ Avoid: direct mutation
user.name = "New Name"; // Causes bugs in closures
items.push(newItem); // Breaks React optimizations
```

## Code Organization

**Structure code for clarity and testability:**

- Group related functionality into cohesive modules
- Use dependency injection for testability
- Separate pure functions from side-effect code
- Prefer composition over inheritance
- Use early returns to reduce nesting

**Example - Good:**

```typescript
function processUser(user: User): Result<ProcessedUser, ValidationError> {
  if (!user) {
    return { success: false, error: new ValidationError("User required") };
  }

  if (!isValidEmail(user.email)) {
    return { success: false, error: new ValidationError("Invalid email") };
  }

  return { success: true, data: process(user) };
}
```

## Testing Standards

**Tests verify behavior and enable safe refactoring:**

- Write tests for all public functions
- Use descriptive test names: `should_return_user_when_id_exists`
- Mock external dependencies for isolation
- Aim for 80%+ code coverage

**Example - Good:**

```typescript
describe("UserRepository", () => {
  describe("findById", () => {
    it("should return user when id exists", async () => {
      const repo = new DatabaseUserRepository(mockDb);
      const result = await repo.findById("user-123");
      expect(result.success).toBe(true);
      expect(result.data).toEqual(expectedUser);
    });

    it("should return error when user not found", async () => {
      const repo = new DatabaseUserRepository(mockDb);
      const result = await repo.findById("non-existent");
      expect(result.success).toBe(false);
    });
  });
});
```

## Type Safety Over Convenience

**Types catch bugs at compile-time and serve as documentation:**

```typescript
// ✅ Good: explicit types enable compiler checking
interface Market {
  id: string;
  name: string;
  status: "active" | "resolved" | "closed";
}

function getMarket(id: string): Promise<Market> {}

// ❌ Avoid: any disables type checking
function getMarket(id: any): Promise<any> {}
```

## Constants Over Magic Numbers

**Named constants reveal intent and enable easy updates:**

```typescript
// ✅ Good: constants are self-documenting
const MIN_AGE = 18;
const MAX_AGE = 120;
const MIN_NAME_LENGTH = 2;
const MAX_NAME_LENGTH = 100;

if (user.age < MIN_AGE || user.age > MAX_AGE) {
  throw new ValidationError("Age out of range");
}

// ❌ Avoid: magic numbers hide intent
if (user.age < 18 || user.age > 120) {
  throw new Error("Invalid age");
}
```

## Performance Best Practices

**Memoization prevents unnecessary re-computation in React:**

- Use `useMemo` for expensive computations
- Use `useCallback` for functions passed to children
- Use `React.memo` for pure components

```typescript
const sortedMarkets = useMemo(() => {
  return markets.sort((a, b) => b.volume - a.volume);
}, [markets]);

const handleSearch = useCallback((query: string) => {
  setSearchQuery(query);
}, []);
```

## Common Mistakes to Avoid

### Mistake 1: Using `any` for Types

❌ **Wrong:**
```typescript
function validateEmail(email: any): any {
  // No type safety
}
```

✅ **Correct:**
```typescript
function validateEmail(email: unknown): Email | null {
  if (typeof email !== "string") return null;
  if (!isValidEmailFormat(email)) return null;
  return email as Email;
}
```

### Mistake 2: Direct Mutation

❌ **Wrong:**
```typescript
user.name = "New Name";
items.push(newItem);
```

✅ **Correct:**
```typescript
const updatedUser = { ...user, name: "New Name" };
const updatedArray = [...items, newItem];
```

### Mistake 3: Magic Numbers

❌ **Wrong:**
```typescript
if (user.age < 18 || user.age > 120) {
  throw new Error("Invalid age");
}
```

✅ **Correct:**
```typescript
const MIN_AGE = 18;
const MAX_AGE = 120;

if (user.age < MIN_AGE || user.age > MAX_AGE) {
  throw new ValidationError("Age out of range");
}
```

### Mistake 4: Bare Error Throws

❌ **Wrong:**
```typescript
throw new Error("Invalid user");
```

✅ **Correct:**
```typescript
class ValidationError extends Error {
  constructor(
    message: string,
    public readonly field?: string,
    public readonly context?: Record<string, unknown>,
  ) {
    super(message);
    this.name = "ValidationError";
  }
}

throw new ValidationError("Invalid user", "user", { attemptedValue });
```

### Mistake 5: Default Exports

❌ **Wrong:**
```typescript
export default function processData() {}
```

✅ **Correct:**
```typescript
export function processData() {}
// Named exports enable tree-shaking and easier refactoring
```

---

## Validation Checklist

Before claiming TypeScript code complete:

**Type Safety:**
- [ ] Strict mode enabled in tsconfig.json
- [ ] Explicit types defined (no `any` unless truly unknown)
- [ ] Return types explicitly declared
- [ ] Use `unknown` instead of `any` for unknown types

**Error Handling:**
- [ ] Typed error classes for domain errors
- [ ] Result<T> pattern for fallible operations
- [ ] Error context includes field and metadata

**Code Quality:**
- [ ] Immutability via spread operators
- [ ] Named constants for business values
- [ ] Consistent naming conventions (PascalCase types, camelCase functions)
- [ ] Files focused and under 300 lines
- [ ] Named exports for better tree-shaking

**Testing:**
- [ ] Tests covering public functions
- [ ] 80%+ code coverage target

---

## Best Practices Summary

✅ **DO:**
- Enable strict mode in tsconfig.json for compile-time error catching
- Use explicit types and return types for all functions
- Prefer `unknown` over `any` with type guards
- Create typed error classes with context (field, metadata)
- Use Result<T> pattern for operations that can fail
- Apply immutability with spread operators
- Use named constants instead of magic numbers
- Follow naming conventions (PascalCase types, camelCase functions)

❌ **DON'T:**
- Use `any` to silence type checking
- Mutate objects/arrays directly
- Use bare `throw new Error()` without typed classes
- Use default exports (breaks tree-shaking)
- Mix concerns in single files
- Leave magic numbers without named constants
- Skip return type annotations
- Ignore TypeScript compiler warnings

---

## Few-Shot Examples

When you work on a pattern matching one from examples, you MUST read `examples/`:

| Example File             | Shows...                                                                   |
| ------------------------ | -------------------------------------------------------------------------- |
| `good-naming.ts`         | Proper naming conventions (interfaces, types, enums, constants, functions) |
| `bad-practices.ts`       | What to avoid (any, bare Error, mutation, magic numbers)                   |
| `good-error-handling.ts` | Typed error classes and Result<T> pattern                                  |
| `good-practices.ts`      | Immutability, early returns, constants                                     |

## Integration

This skill integrates with:

- `coding-standards` - Universal coding best practices
- `engineering-lifecycle` - Testing requirements
- `frontend-patterns` - React/TypeScript patterns
- `backend-patterns` - TypeScript backend patterns

---

## Dynamic Sourcing Protocol

**CONDITIONAL FETCH**: For TypeScript language questions, fetch from:

- https://www.typescriptlang.org/docs/handbook/ (Type fundamentals)

This skill contains Seed System-specific conventions (Result<T> pattern, immutability, naming conventions) that extend TypeScript fundamentals.

---

<critical_constraint>
**Portability Invariant**: Zero external dependencies. Works standalone.
**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows
</critical_constraint>
