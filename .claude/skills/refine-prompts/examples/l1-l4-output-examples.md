# Refine Prompts - L1-L4 Level Examples

## L1: One-Sentence Outcome Statement

The L1 level captures the essential outcome in a single, clear sentence.

**Examples:**

| Vague Input | L1 Output |
|------------|-----------|
| "Create a website" | "Create a conversion-optimized landing page for [PRODUCT]" |
| "Fix performance" | "Optimize database query performance for <100ms response time" |
| "Add authentication" | "Implement JWT-based authentication with refresh tokens" |
| "Write tests" | "Achieve 80%+ test coverage with unit and integration tests" |
| "Deploy app" | "Containerize and deploy application to AWS ECS with CI/CD" |

**Key Pattern:** `[Action verb] + [specific outcome] + [measurable target]`

## L2: Context-Rich Paragraph

The L2 level provides necessary context without step-by-step instructions.

**Good L2 Example:**
```
Implement a REST API using Express.js with PostgreSQL database and JWT authentication.
Design CRUD endpoints with proper HTTP status codes, input validation using Zod schemas,
error handling middleware with logging, and OpenAPI documentation. Ensure database
migrations are versioned, queries use prepared statements, and the API follows RESTful
conventions. Deploy with Docker containers to AWS ECS using environment-based configuration.
```

**Bad L2 Example (too prescriptive):**
```
First, create the database models. Then add routes for GET/POST/PUT/DELETE. Add authentication
middleware to protect routes. Use Zod for validation. Add error handling. Write tests.
Deploy to AWS.
```

**Key Pattern:** [Tech stack] + [key requirements] + [constraints] + [deliverables]

## L3: Structured Bullets

The L3 level organizes requirements into clear categories.

**L3 Template:**
```
L3:
- **Task:** [What to build]
- **Constraints:** [Technical limits, requirements, forbidden approaches]
- **Output:** [Deliverables, success criteria]
```

**Example:**
```
L3:
- **Task:** Build file upload service with drag-and-drop interface
- **Constraints:** Max 100MB per file; virus scan uploads; S3 storage; progress indicators; support pdf, png, jpg
- **Output:** React component + Node.js upload handler + S3 integration + virus scanning + tests
```

**Key Pattern:** Organize into Task/Constraints/Output for maximum clarity

## L4: Template/Framework (Use Sparingly)

Only use L4 when:
1. The task is complex and multi-step
2. The output format must be consistent across uses
3. A template provides real value (not just boilerplate)

**When L4 IS justified:**
```
L4:
## API Endpoint Template
- **Route**: `METHOD /path/:param`
- **Description**: [What it does]
- **Auth**: [Required/Optional]
- **Request**: { schema }
- **Response**: { schema }
- **Errors**: [error cases]
```

**When L4 is NOT justified:**
- Simple CRUD operations (obvious pattern)
- One-off tasks (no reusability)
- Well-established patterns (REST, MVC)

**Key Pattern:** Use L4 only when template provides structure that improves consistency

## Complete Examples at Each Level

### Example: Build Contact Form

**Input:** "Create a contact form"

**L1 Only:**
```
L1: Create a responsive contact form with validation and spam protection
```

**L1 + L2:**
```
L1: Create a responsive contact form with validation and spam protection

L2: Build a contact form using React with Formik for state management and Yup validation.
Implement responsive layout with CSS Grid/Flexbox for mobile-first design. Add honeypot
field for spam protection and rate limiting on submit endpoint. Store submissions in PostgreSQL
with notification email to admin. Ensure WCAG 2.1 AA accessibility compliance and
cross-browser compatibility. Output complete form component, validation schema, backend
endpoint, and database migration.
```

**L1 + L2 + L3:**
```
L1: Create a responsive contact form with validation and spam protection

L2: Build a contact form using React with Formik for state management and Yup validation.
Implement responsive layout with CSS Grid/Flexbox for mobile-first design. Add honeypot
field for spam protection and rate limiting on submit endpoint. Store submissions in PostgreSQL
with notification email to admin. Ensure WCAG 2.1 AA accessibility compliance and
cross-browser compatibility.

L3:
- **Task:** Create contact form with spam protection and email notifications
- **Constraints:** React + Formik + Yup; mobile-first responsive; honeypot anti-spam; rate limiting; WCAG 2.1 AA
- **Output:** Form component + validation schema + POST endpoint + database schema + email notification
```

**L1 + L2 + L3 + L4 (for complex multi-field form):**
```
L1: Create a responsive contact form with validation and spam protection

L2: [same as above]

L3:
- **Task:** Create contact form with spam protection and email notifications
- **Constraints:** React + Formik + Yup; mobile-first responsive; honeypot anti-spam; rate limiting; WCAG 2.1 AA
- **Output:** Form component + validation schema + POST endpoint + database schema + email notification

L4:
## Contact Form Fields
- **Name**: Required, text input, max 100 chars
- **Email**: Required, email validation, unique check
- **Subject**: Required, dropdown with 5 options
- **Message**: Required, textarea, 10-1000 chars
- **Honeypot**: Hidden field, reject if filled
## Validation Rules
- Name: No special characters, trim whitespace
- Email: Valid email format, MX record check
- Subject: Must select from predefined options
- Message: Strip HTML, detect profanity, trim whitespace
## API Endpoint
- POST /api/contact
- Rate limit: 5 requests per hour per IP
- Response: { success: boolean, message: string }
```

**Progression Note:** L4 was added because the form has 5+ fields with specific validation rules and a structured API contract - this justifies a template for consistency.
