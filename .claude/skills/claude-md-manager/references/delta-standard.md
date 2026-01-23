# The Delta Standard

Methodology for writing effective project memory by focusing only on what Claude doesn't already know.

---

## Core Principle

> **Good Customization = Expert-only Knowledge − What Claude Already Knows**

The Delta Standard filters content to include only:
- **Project-specific decisions** (not universal best practices)
- **Non-obvious insights** (not common knowledge)
- **Expert knowledge** (not beginner explanations)

---

## Content Filters

### KEEP: Project-Specific Knowledge

#### 1. Unique Decisions

**Example**:
```markdown
## Auth Strategy
We use JWT with short-lived tokens (15 min) + refresh tokens
Why: API accessed by mobile apps, need balance of security and UX
Refresh flow: POST /auth/refresh (automatic on 401)
```

**Why Keep**: Project-specific architectural decision

---

#### 2. Non-Obvious Patterns

**Example**:
```markdown
## Import Order
⚠️ CRITICAL: Initialize crypto BEFORE importing auth module
crypto.init() → auth.activate() (order matters)

Reason: Auth module checks crypto state during bootstrap
Error if out of order: "Crypto not ready"
```

**Why Keep**: Non-obvious requirement not in docs

---

#### 3. Working Commands

**Example**:
```bash
# These commands work:
npm run dev          # Hot reload dev server (port 3000)
npm run dev:debug   # With Node inspector (port 9229)

# This one DOESN'T work:
npm start            # Uses old webpack, deprecated
```

**Why Keep**: Actual working commands, not documented elsewhere

---

### REMOVE: Generic Knowledge

#### 1. Basic Tutorials

**Remove**:
```markdown
## React
React is a JavaScript library for building user interfaces.
Components are the building blocks...
[200 lines of React tutorial]
```

**Why Remove**: Claude already knows React basics

---

#### 2. Universal Best Practices

**Remove**:
```markdown
## Code Quality
Always write tests for your code.
Use meaningful variable names.
Write clean code.
```

**Why Remove**: Universal advice, not project-specific

---

#### 3. Library Documentation

**Remove**:
```markdown
## Express
Express is a web framework for Node.js.
You can create routes using app.get(), app.post(), etc.
```

**Why Remove**: Available in official docs

---

## Before → After Examples

### Example 1: Database Section

**Before (Bad)**:
```markdown
## Database
Our application uses PostgreSQL, which is a powerful, open-source
object-relational database system. PostgreSQL has been actively
developed for over 15 years and has a strong reputation for
reliability, feature robustness, and performance.

To connect to the database, we use Prisma, which is a modern
database toolkit. Prisma allows you to define your schema using
a declarative data modeling language...

[continues with 150 lines of tutorial]
```

**After (Delta)**:
```markdown
## Database

Schema: `prisma/schema.prisma`
Generate client: `npx prisma generate`
Migrations: `npx prisma migrate dev`
Reset DB: `npx prisma migrate reset`

⚠️ Migrations fail on CI: Use `npx prisma migrate deploy`
```

---

### Example 2: Testing Section

**Before (Bad)**:
```markdown
## Testing
Testing is important for ensuring code quality. We use Jest,
which is a delightful JavaScript testing framework. Jest provides
a great developer experience and includes features like test
watching, mocking, and coverage reports.

To write a test, create a file with .test.js extension.
You can use describe() to group tests and it() to write individual
test cases...

[continues with 100 lines of tutorial]
```

**After (Delta)**:
```markdown
## Testing

```bash
npm test                    # Run all tests
npm run test:watch         # Watch mode
npm run test:coverage      # Generate coverage report
```

- API tests: Use supertest with setup in `tests/setup.ts`
- React tests: Use @testing-library/react
- Mocking: Factory functions in `tests/factories/` (not inline)
- CI: MUST use `--runInBand` (sequential) to avoid race conditions
```

---

## The Delta Standard Checklist

### For Each Section, Ask:

1. **Is this project-specific?**
   - YES → Keep
   - NO → Remove

2. **Would Claude know this without me telling them?**
   - YES → Remove
   - NO → Keep

3. **Is this actionable (copy-paste ready)?**
   - YES → Keep
   - NO → Improve or remove

4. **Does this add unique value?**
   - YES → Keep
   - NO → Remove

5. **Is this concise?**
   - YES → Keep
   - NO → Condense

---

## Delta Refactoring Process

### Step 1: Inventory All Content

```bash
# Count sections and lines
wc -l CLAUDE.md
grep -E "^##" CLAUDE.md | wc -l
```

---

### Step 2: Identify Violations

| Marker | Check | Action |
|--------|-------|--------|
| "What is" | Tutorial content | Remove |
| "Tutorial" | How-to guides | Remove |
| "Always" | Best practices | Make specific |
| "Should" | Vague advice | Make actionable |
| "Learn more" | External links | Keep if project-specific |

---

### Step 3: Apply Filters

1. **Remove** generic content
2. **Condense** verbose sections
3. **Focus** on project specifics
4. **Verify** actionability

---

### Step 4: Measure Improvement

| Metric | Before | After | Target |
|--------|--------|-------|--------|
| Lines | 500 | 200 | <300 |
| Generic content | 40% | 5% | <10% |
| Actionable commands | 5 | 15 | >10 |
| Project-specific | 30% | 90% | >80% |

---

## Writing Techniques

### 1. Be Specific, Not General

❌ **Bad**:
```markdown
Use a good testing framework.
```

✅ **Good**:
```markdown
Use Jest for unit tests, React Testing Library for components.
```

---

### 2. Show, Don't Tell

❌ **Bad**:
```markdown
Database connections can be tricky.
```

✅ **Good**:
```markdown
⚠️ DB connection fails on Docker: Use `host.docker.internal` instead of `localhost`
```

---

### 3. Provide Context, Not Explanation

❌ **Bad**:
```markdown
We use Redis because it's fast and in-memory databases are great for caching.
```

✅ **Good**:
```markdown
Cache layer: Redis on port 6379
Invalidation: Tags expire every 30 minutes
Fallback: Cache miss → DB query → Cache set
```

---

## Delta Score Calculation

### Scoring Formula

```
Delta Score = (Project-Specific Content / Total Content) × 100
```

### Score Ranges

- **A (90-100)**: Excellent Delta, minimal generic content
- **B (75-89)**: Good Delta, some generic content
- **C (60-74)**: Moderate Delta, noticeable generic content
- **D (40-59)**: Poor Delta, mostly generic content
- **F (0-39)**: Failing Delta, no filtering applied

---

## Anti-Patterns

### ❌ Anti-Pattern 1: Explanations

**Wrong**:
```markdown
We use Redis because it's fast and provides persistence.
```

**Right**:
```markdown
Redis cache: 30-min expiry, invalidation via tags
```

---

### ❌ Anti-Pattern 2: Definitions

**Wrong**:
```markdown
TypeScript is a typed superset of JavaScript that compiles to plain JavaScript.
```

**Right**:
```markdown
TypeScript config: strict mode enabled in tsconfig.json
```

---

### ❌ Anti-Pattern 3: Preaching

**Wrong**:
```markdown
Always write tests for your code.
```

**Right**:
```markdown
Testing: Jest + React Testing Library, >80% coverage required
```

---

### ❌ Anti-Pattern 4: Hand-holding

**Wrong**:
```markdown
To run the application, first make sure you have Node.js installed...
```

**Right**:
```bash
npm run dev  # Starts app on port 3000
```

---

## Real-World Examples

### Example 1: React Testing Section

**Before (300 lines - BAD)**:
```markdown
## Testing

Testing is a crucial part of software development that ensures your code works as expected. In our React application, we use several testing tools to verify component behavior.

Jest is a delightful JavaScript testing framework created by Facebook. It provides a great developer experience with features like test watching, snapshot testing, and built-in code coverage. Jest runs tests in parallel by default, which makes it very fast.

React Testing Library is a solution for testing React components without testing implementation details. It provides utility functions that encourage good testing practices. The library focuses on testing components the same way a user would interact with them.

To write a test, you create a file with .test.js or .spec.js extension. You can use the describe() function to group related tests and the it() function for individual test cases. Each test should be independent and not rely on the results of other tests.

For component testing, you would typically import the render function from @testing-library/react, render your component, and use queries like getByText or getByRole to interact with the rendered output.

Here's an example of a simple component test:

```javascript
import { render, screen } from '@testing-library/react';
import MyComponent from './MyComponent';

describe('MyComponent', () => {
  it('renders a heading', () => {
    render(<MyComponent />);
    const heading = screen.getByText('Hello World');
    expect(heading).toBeInTheDocument();
  });
});
```

Snapshot testing is another feature of Jest that allows you to capture the rendered output of a component and compare it in future tests. This is useful for detecting unexpected changes to your component's structure.

[continues with 250 more lines...]
```

**After (15 lines - GOOD)**:
```markdown
## Testing

```bash
npm test                    # Run all tests
npm run test:watch         # Watch mode
npm run test:coverage      # Generate coverage report
```

- Unit tests: Jest + React Testing Library
- Component tests: @testing-library/react, avoid implementation details
- Snapshot tests: Use sparingly (only for stable UIs)
- Pattern: Factory functions in `tests/factories/` (not inline mocks)
- CI: MUST use `--runInBand` to avoid race conditions
```

---

### Example 2: Database Section

**Before (180 lines - BAD)**:
```markdown
## Database

Our application uses PostgreSQL, which is a powerful, open-source object-relational database system. PostgreSQL has been actively developed for over 15 years and has a strong reputation for reliability, feature robustness, and performance.

PostgreSQL is ACID compliant, which means it ensures Atomicity, Consistency, Isolation, and Durability of database transactions. This makes it an excellent choice for applications that require data integrity, such as financial systems or applications handling critical business data.

To connect to PostgreSQL from Node.js, we use the 'pg' library, which is a pure JavaScript implementation of the PostgreSQL protocol. The library provides both a synchronous API for scripts and an asynchronous API for applications.

Here's how you would establish a connection:

```javascript
const { Pool } = require('pg');
const pool = new Pool({
  user: 'username',
  host: 'localhost',
  database: 'mydatabase',
  password: 'password',
  port: 5432,
});
```

Connection pooling is important for performance. A connection pool maintains a set of reusable database connections that can be shared across multiple queries. This avoids the overhead of creating a new connection for each request.

[continues with 140 more lines about PostgreSQL basics...]
```

**After (12 lines - GOOD)**:
```markdown
## Database

PostgreSQL with Prisma ORM

Schema: `prisma/schema.prisma`
Generate client: `npx prisma generate`
Migrations: `npx prisma migrate dev`
Reset DB: `npx prisma migrate reset`

⚠️ Prisma migrate fails on CI: Use `npx prisma migrate deploy`
⚠️ Connection pool: Set `max_connections=20` in production
```

---

### Example 3: API Auth Section

**Before (220 lines - BAD)**:
```markdown
## Authentication

Authentication is the process of verifying the identity of a user. In web applications, this typically involves a user providing credentials (username and password) which are then validated against a database.

JSON Web Tokens (JWT) are a compact, URL-safe means of representing claims to be transferred between two parties. JWTs are commonly used for authentication because they are self-contained and don't require a database lookup on every request.

A JWT consists of three parts: a header, a payload, and a signature. The header typically contains the type of token and the algorithm used for signing. The payload contains the claims, which are statements about an entity (typically the user) and additional data.

The signature is created by taking the encoded header, the encoded payload, and a secret key, then applying the algorithm specified in the header. This signature is used to verify that the token hasn't been tampered with.

When a user logs in, the server validates their credentials and creates a JWT with a short expiration time (typically 15 minutes). This token is then returned to the client, which stores it (usually in localStorage or a secure cookie).

On subsequent requests, the client includes this token in the Authorization header. The server then validates the token by checking the signature. If valid, the server can trust the claims in the payload and authorize the request.

For added security, we can use refresh tokens. A refresh token is a long-lived token (typically 7 days) that can be exchanged for a new access token when the current one expires. This allows us to have short-lived access tokens while still maintaining user sessions.

[continues with 180 more lines about JWT mechanics...]
```

**After (20 lines - GOOD)**:
```markdown
## Auth

JWT with short-lived tokens (15 min) + refresh tokens (7 days)

Access token: `Authorization: Bearer <token>`
Refresh endpoint: `POST /auth/refresh` (automatic on 401)

Storage: httpOnly cookies (secure: true, sameSite: strict)

⚠️ Middleware runs before ALL routes except /auth/login
⚠️ Refresh token rotation: New refresh token issued on each refresh
```

---

### Example 4: Redux State Management (Bad vs Good)

**Before (150 lines - BAD)**:
```markdown
## State Management

State management is a critical aspect of building modern web applications. As your application grows in complexity, managing state across multiple components becomes increasingly challenging. This is where Redux comes in.

Redux is a predictable state container for JavaScript applications. It helps you write applications that behave consistently, run in different environments, and are easy to test. Redux is based on three fundamental principles:

1. Single Source of Truth: The state of your entire application is stored in an object tree within a single store.

2. State is Read-Only: The only way to change the state is to emit an action, an object describing what happened.

3. Changes are Made with Pure Functions: To specify how the state tree is transformed by actions, you write pure reducers.

Redux middleware provides a third-party extension point between dispatching an action and the moment it reaches the reducer. Middleware is used for logging, crash reporting, talking to an asynchronous API, routing, and more.

Redux Toolkit is the official, opinionated, batteries-included toolset for efficient Redux development. It simplifies the most common Redux tasks, including store setup, defining reducers, immutable update logic, and even creating entire "slices" of state.

[continues with 120 more lines about Redux basics...]
```

**After (10 lines - GOOD)**:
```markdown
## State Management

Redux Toolkit with RTK Query

Store config: `src/store/index.ts`
Slice pattern: `src/features/*/slice.ts`
API integration: RTK Query (replaces thunks)

⚠️ NEVER use dispatch in React components directly - use hooks
⚠️ RTK Query: Cache invalidation via `tags` option
```

---

### Example 5: Git Workflow (Bad vs Good)

**Before (200 lines - BAD)**:
```markdown
## Git Workflow

Git is a distributed version control system that tracks changes in source code during software development. Git was created by Linus Torvalds in 2005 and has become the industry standard for version control.

The Git workflow we're using is based on the Git Flow methodology. Git Flow defines a strict branching model designed around the project release. This provides a robust framework for managing larger projects.

In Git Flow, you have a main branch (master) and a develop branch. The master branch stores the official release history, while the develop branch integrates features. Additionally, you can create feature branches for new features, release branches for preparing releases, and hotfix branches for emergency fixes.

When starting a new feature, you branch from develop:

```bash
git checkout develop
git pull origin develop
git checkout -b feature/new-feature-name
```

After making your changes and committing them, you push the feature branch to the remote repository:

```bash
git push origin feature/new-feature-name
```

Then, you create a pull request on GitHub for code review. After the code is reviewed and approved, it can be merged into the develop branch. When the develop branch has enough features for a release, you create a release branch from develop.

[continues with 160 more lines about Git commands and workflow...]
```

**After (18 lines - GOOD)**:
```markdown
## Git Workflow

Branching model: Git Flow (feature/*, release/*, hotfix/*)

```bash
git flow init                    # Initialize (done once)
git flow feature start NAME      # Start feature branch
git flow feature finish NAME     # Merge to develop
git flow release start v1.0      # Prepare release
git flow hotfix start NAME       # Emergency fix
```

- PRs: Required for master/develop
- Squash merges: Keep history clean
- Commit messages: Conventional Commits format
```

---

## Quick Reference: What to Cut

### Immediately Remove These Phrases

| Generic Phrase | Delta-Compliant Alternative |
|----------------|----------------------------|
| "X is a Y that..." | Remove entirely |
| "To use X, you need..." | Keep only if project-specific |
| "First, second, third..." | Bullet points only |
| "Here's an example:" | Just show the code |
| "This is important because..." | Only if unique to project |
| "What is X?" | Never include |
| "Learn more about..." | Remove or make specific |

### Kill List (100% Removal)

- [ ] Technology tutorials ("What is React?")
- [ ] Best practice lectures ("Always write tests")
- [ ] Generic explanations ("JSON is a format...")
- [ ] Library documentation links
- [ ] Step-by-step tutorials
- [ ] Conceptual overviews
- [ ] "Why we chose X" (unless architectural decision)
- [ ] Definition of terms

### Keep List (100% Retention)

- [ ] Project-specific commands that work
- [ ] Non-obvious patterns and gotchas
- [ ] Architectural decisions and rationale
- [ ] Configuration quirks
- [ ] Working code examples
- [ ] Import/export patterns
- [ ] Testing commands and strategies
- [ ] Deployment procedures
