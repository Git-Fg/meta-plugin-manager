# Feature: User Authentication

## Overview

Implement JWT-based user authentication for the API, enabling users to login, logout, and access protected resources.

## Tasks

### Task 1: Implement auth service

- [ ] Create `src/auth/auth-service.ts` with login/logout methods
- [ ] Add JWT token generation and validation
- [ ] Write unit tests for token generation (80%+ coverage)
- [ ] Implement refresh token rotation

### Task 2: Add middleware

- [ ] Create `src/auth/auth-middleware.ts` for protected routes
- [ ] Add error handling for expired/invalid tokens
- [ ] Write integration tests for middleware
- [ ] Document API endpoints requiring authentication

### Task 3: Update user model

- [ ] Add password hash field to User entity
- [ ] Create migration for password_hash column
- [ ] Add password validation logic
- [ ] Write database tests

## Verification

- [ ] All tests pass (npm test)
- [ ] TypeScript compiles without errors (tsc --noEmit)
- [ ] ESLint reports no issues (eslint .)
- [ ] API endpoints tested with Postman
- [ ] Security audit passes (npm audit)
