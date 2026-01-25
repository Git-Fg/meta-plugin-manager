# Refine Prompts - Basic Usage Examples

## Example 1: Vague to Precise

**Input:**
```
"Create a website"
```

**Output:**
```
L1: Create a responsive landing page for [PRODUCT/SERVICE]

L2: Build a conversion-optimized single-page website using semantic HTML5, CSS Grid/Flexbox for mobile-first responsive design, and vanilla JavaScript for interactivity. Implement clear value proposition headline, benefit-focused sections with social proof testimonials, prominent CTA buttons with hover states, contact form with validation, and footer with essential links. Ensure WCAG 2.1 AA accessibility compliance, <3s initial load time, and SEO-ready meta tags. Output complete deployable code with semantic structure, optimized assets, and performance audit.

L3:
- Task: Create responsive landing page with conversion focus
- Constraints: Mobile-first responsive; WCAG 2.1 AA; <3s load time; semantic HTML5; SEO meta tags
- Output: Complete HTML/CSS/JS files + accessibility report + performance metrics

Rationale: The refined prompt specifies technical stack (HTML5/CSS Grid/vanilla JS), measurable performance targets (<3s load), accessibility standard (WCAG 2.1 AA), and clear deliverables while maintaining flexibility for visual design choices.
```

## Example 2: Over-Prescriptive to Minimal

**Input:**
```
"Create a REST API. First, define the data models. Then create the routes. Make sure to add authentication middleware. Use Express.js. Connect to PostgreSQL. Add error handling. Write tests. Deploy to AWS."
```

**Output:**
```
L1: Build a RESTful API with Express.js, PostgreSQL, and JWT authentication

L2: Design and implement a REST API using Express.js framework with PostgreSQL database via Prisma ORM. Implement JWT-based authentication middleware for protected routes, comprehensive error handling with proper HTTP status codes, input validation using Zod schemas, and automated testing with Jest. Deploy containerized application to AWS ECS with environment-based configuration. Ensure endpoint security, data validation at boundaries, proper indexing for performance, and API documentation with OpenAPI spec.

L3:
- Task: Build REST API with authentication and testing
- Constraints: Express.js + PostgreSQL + Prisma; JWT auth; Zod validation; Jest testing; containerized deployment
- Output: Complete API codebase + migrations + tests + deployment config + API documentation

Rationale: Removed step-by-step instructions (models→routes→middleware) which are obvious best practices. Kept only actual constraints (specific tech stack, auth method, validation library, testing framework, deployment target) that change implementation decisions.
```

## Example 3: Missing Context to Complete Specification

**Input:**
```
"Fix the bug in the login"
```

**Output:**
```
L1: Diagnose and fix authentication failure in login flow

L2: Investigate the login endpoint to identify the authentication failure. Check password hashing comparison, JWT token generation, database query for user lookup, session handling, and error propagation. Implement fix with proper error messages for debugging (without exposing security details), add logging for authentication attempts, and verify fix with unit tests for successful and failed login scenarios.

L3:
- Task: Fix authentication bug in login flow
- Constraints: Preserve existing user database; maintain JWT session format; add security-focused logging; test both success and failure paths
- Output: Bug fix commit + test coverage + security audit of authentication flow

Rationale: Expanded vague "fix the bug" to specify investigation areas (password hashing, JWT, database query, session handling) and security requirements (proper error messages, logging, tests). This provides enough context for autonomous diagnosis while allowing flexibility in the specific fix approach.
```

## Example 4: Adding Outcome Focus

**Input:**
```
"Write code to parse JSON files"
```

**Output:**
```
L1: Create robust JSON file parser with validation and error recovery

L2: Implement a JSON file parsing utility that handles malformed JSON with detailed error reporting including line/column numbers. Support streaming for large files (>100MB), schema validation using JSON Schema drafts, custom error types for different failure modes (syntax, schema, I/O), and recovery options (skip invalid entries, attempt repair, fail-fast). Output both parsed data and validation report with all errors/warnings.

L3:
- Task: Create production-ready JSON parser with validation
- Constraints: Stream large files; JSON Schema validation; detailed error location reporting; recovery options
- Output: Parser module + test suite + documentation + examples

Rationale: Transformed trivial task ("parse JSON") into production-ready specification by adding real-world requirements (large files, validation, error recovery, detailed reporting) that would actually be needed for a robust implementation.
```
