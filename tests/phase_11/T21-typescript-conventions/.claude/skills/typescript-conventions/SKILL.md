---
name: typescript-conventions
description: >
  TypeScript code standards for this team. Use when writing TypeScript,
  reviewing types, or architecting modules. Apply these patterns
  automatically whenever writing TypeScript.
user-invocable: false
disable-model-invocation: false
allowed-tools: Read
---

# TypeScript Conventions

When writing TypeScript, follow these conventions:

## Type Strictness

- Always use strict mode: `"strict": true` in tsconfig.json
- Never use `any` (use `unknown` instead)
- Define explicit return types for functions
- Prefer interfaces over types for object shapes

## Module Organization

- File structure: `src/<domain>/<feature>/<File.ts>`
- Export only public interfaces from index.ts
- Keep files under 300 lines
- Use named exports, avoid default exports

## Error Handling

- Never throw bare errors; use typed error classes
- Always include context: `new ValidationError('message', { context })`
- Use Result<T> pattern for operations that can fail
- Handle async errors with try/catch in async functions

## Naming Conventions

- Interfaces: PascalCase with descriptive names (e.g., `UserRepository`)
- Types: PascalCase (e.g., `UserId`, `ApiResponse<T>`)
- Enums: PascalCase (e.g., `UserRole`, `HttpStatus`)
- Variables/functions: camelCase (e.g., `getUserById`, `userData`)
- Constants: UPPER_SNAKE_CASE (e.g., `MAX_RETRIES`, `DEFAULT_TIMEOUT`)

## Code Organization

- Group related functionality into classes or modules
- Use dependency injection for services
- Keep pure functions separate from side-effect code
- Prefer composition over inheritance

## Testing

- Write tests for all public functions
- Use descriptive test names: `should_return_user_when_id_exists`
- Mock external dependencies
- Aim for 80%+ code coverage

## Examples

### Good Function Signature
```typescript
function validateEmail(email: string): Result<Email, ValidationError> {
  // implementation
}
```

### Good Interface
```typescript
interface UserRepository {
  findById(id: UserId): Promise<Result<User, NotFoundError>>;
  save(user: User): Promise<Result<void, DatabaseError>>;
}
```

### Good Error Class
```typescript
class ValidationError extends Error {
  constructor(
    message: string,
    public readonly field?: string,
    public readonly context?: Record<string, unknown>
  ) {
    super(message);
    this.name = 'ValidationError';
  }
}
```

## Anti-Patterns to Avoid

- ❌ Using `any` for types
- ❌ Default exports
- ❌ Bare `throw new Error()`
- ❌ Mixed concerns in single file
- ❌ Magic numbers without constants
