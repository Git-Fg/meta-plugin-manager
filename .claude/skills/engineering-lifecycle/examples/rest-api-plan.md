# Feature: REST API for Users

## Overview

Create a RESTful API for user management with CRUD operations, pagination, and filtering.

## Tasks

### Task 1: Create User model

- [ ] Define `User` interface with id, name, email, role, createdAt
- [ ] Create `UserRepository` interface
- [ ] Implement in-memory repository for testing
- [ ] Write tests for User model

### Task 2: Implement CRUD endpoints

- [ ] GET /users - List all users (with pagination)
- [ ] GET /users/:id - Get single user
- [ ] POST /users - Create user
- [ ] PUT /users/:id - Update user
- [ ] DELETE /users/:id - Delete user

### Task 3: Add validation

- [ ] Validate email format
- [ ] Validate required fields
- [ ] Add error responses (400, 404)

## TDD Cycle Example

```typescript
// RED: Write failing test first
describe("User API", () => {
  it("returns users with pagination", async () => {
    const result = await getUsers({ page: 1, limit: 10 });
    expect(result.users).toHaveLength(10);
    expect(result.total).toBe(100);
  });
});

// GREEN: Minimal code to pass
function getUsers({ page, limit }: PaginationParams): PaginatedResult {
  return { users: [], total: 0 };
}

// REFACTOR: Add real implementation
```

## Verification

- [ ] All tests pass (npm test)
- [ ] TypeScript compiles (tsc --noEmit)
- [ ] ESLint clean (eslint .)
- [ ] Coverage >80%
