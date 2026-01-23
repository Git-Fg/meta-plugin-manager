# Quality Framework

Detailed scoring system for evaluating CLAUDE.md quality.

---

## 7-Dimension Scoring (0-100 points)

### 1. Delta Compliance (20 pts)

**Measures**: Only includes knowledge Claude doesn't already have.

| Score | Criteria |
|-------|----------|
| 20 | Zero generic content, all expert-level |
| 16 | Minimal generic, mostly project-specific |
| 12 | Mixed generic and specific |
| 8 | Mostly generic tutorials |
| 4 | Kitchen sink, extensive tutorials |
| 0 | Everything included, no filtering |

**Check**: For each section, ask "Would a senior dev need to tell Claude this?"
- YES → Keep
- NO → Remove

**Examples**:

✅ **Good** (20):
```markdown
## Build Process
`npm run build` bundles assets with webpack
`npm run analyze` opens bundle analyzer (port 8888)
```

❌ **Bad** (4):
```markdown
## Build Process
Webpack is a module bundler that creates a dependency graph.
It processes your project files and generates optimized bundles.
```

---

### 2. Structure (15 pts)

**Measures**: Logical organization and navigation.

| Score | Criteria |
|-------|----------|
| 15 | Clear hierarchy, @imports used, modular |
| 12 | Good sections, some could be extracted |
| 9 | Basic sections, no modularity |
| 6 | Flat structure, hard to navigate |
| 3 | No organization, wall of text |
| 0 | Completely unstructured |

**Check**:
- Clear section headers (##, ###)
- Related content grouped logically
- Modular rules in `.claude/rules/`
- @imports for reusable content

---

### 3. Clarity (15 pts)

**Measures**: How unambiguous and executable instructions are.

| Score | Criteria |
|-------|----------|
| 15 | All instructions specific and actionable |
| 12 | Most clear, few vague statements |
| 9 | Some ambiguity, needs interpretation |
| 6 | Vague, open to interpretation |
| 3 | Contradictory or confusing |
| 0 | Completely unclear |

**Check**:
- Uses "ALWAYS" / "NEVER" for absolutes
- Provides examples for complex patterns
- No "should consider" or "might want to"
- Commands are copy-pasteable

---

### 4. Completeness (15 pts)

**Measures**: Covers all project-specific needs.

| Score | Criteria |
|-------|----------|
| 15 | Comprehensive coverage, handles edge cases |
| 12 | Core topics covered, minor gaps |
| 9 | Basic coverage, missing some areas |
| 6 | Significant gaps |
| 3 | Missing critical information |
| 0 | Bare minimum or empty |

**Essential Coverage**:
- Project overview / tech stack
- Code organization rules
- Testing patterns
- Security constraints
- Key commands
- Common patterns
- What NOT to do

---

### 5. Commands/Workflows (10 pts)

**Measures**: Essential operations are documented.

| Score | Criteria |
|-------|----------|
| 10 | All essential commands documented with context |
| 8 | Most commands present, some missing context |
| 6 | Basic commands only, no workflow |
| 4 | Few commands, many missing |
| 2 | Minimal command documentation |
| 0 | No commands documented |

**Essential Commands**:
- Build
- Test
- Dev/start
- Lint
- Deploy (if applicable)

---

### 6. Patterns & Gotchas (10 pts)

**Measures**: Non-obvious knowledge is captured.

| Score | Criteria |
|-------|----------|
| 10 | Gotchas and quirks captured comprehensively |
| 8 | Some patterns documented |
| 6 | Minimal pattern documentation |
| 4 | Few gotchas noted |
| 2 | Missing critical gotchas |
| 0 | No patterns or gotchas documented |

**Common Gotchas**:
- Known issues and workarounds
- Edge cases and special handling
- "Why we do it this way" explanations
- Configuration quirks
- Dependency issues

---

### 7. Maintainability (15 pts)

**Measures**: How easy it is to keep updated.

| Score | Criteria |
|-------|----------|
| 15 | Modular, no redundancy, versioned |
| 12 | Easy to update, minor redundancy |
| 9 | Some duplicate content to maintain |
| 6 | Hard to find what to update |
| 3 | Massive file, extensive duplication |
| 0 | Completely unmaintainable |

**Check**:
- Single source of truth for each topic
- No copy-paste between files
- Clear ownership of each section
- Dead references cleaned up
- @imports for modularity

---

## Grade Thresholds

| Grade | Score | Description |
|-------|-------|-------------|
| **A** | 90-100 | Exemplary |
| **B** | 75-89 | Good |
| **C** | 60-74 | Adequate |
| **D** | 40-59 | Poor |
| **F** | 0-39 | Failing |

---

## Common Failure Patterns

### Kitchen Sink (Delta: 0-8)

**Symptom**: File contains everything the author knows about the topic.

```markdown
## React Best Practices
React is a JavaScript library for building user interfaces. Components
are the building blocks of React applications...
[continues for 200 lines]
```

**Fix**: Remove all generic content, keep only project-specific decisions.

---

### Instruction Drift (Clarity: 0-6)

**Symptom**: Rules no longer match actual codebase.

```markdown
## Styling
Use CSS Modules for all components.
# But codebase has switched to Tailwind
```

**Fix**: Regular audits, post-refactor reviews.

---

### Duplicate Content (Maintainability: 0-9)

**Symptom**: Same information in multiple places.

```markdown
# CLAUDE.md
Use ESLint with our .eslintrc config.

# .claude/rules/linting.md (same content)
Use ESLint with our .eslintrc config.
```

**Fix**: Single source, use @imports for references.

---

## Quick Audit Checklist

### Pass/Fail Criteria

| Check | Pass | Fail |
|-------|------|------|
| Total lines | < 300 | > 300 |
| Generic content | < 10% | > 30% |
| Broken references | 0 | Any |
| Duplicate sections | 0 | Any |
| Vague instructions | < 5% | > 20% |

### Scoring Shortcut

1. **Skim for tutorials** → Each found: -3 Delta
2. **Count sections** → < 10 with clear hierarchy: +5 Structure
3. **Find "should" / "might"** → Each found: -2 Clarity
4. **Check for gaps** → Missing core topic: -5 Completeness
5. **Search for duplicates** → Each found: -3 Maintainability

---

## Red Flags

These issues immediately reduce quality:

- **Commands that would fail** (wrong paths, missing deps)
- **References to deleted files/folders**
- **Outdated tech versions**
- **Copy-paste from templates without customization**
- **Generic advice not specific to the project**
- **"TODO" items never completed**
- **Duplicate info across multiple CLAUDE.md files**

---

## Examples

### Example 1: Excellent CLAUDE.md (Grade: A)

```markdown
# TaskTracker API

Express + PostgreSQL REST API

## Commands
| Command | Purpose |
|---------|---------|
| `npm start` | Dev server (port 3000) |
| `npm test` | Run tests (Jest + supertest) |
| `npm run migrate` | Apply Prisma migrations |

## Architecture
```
/src
  /routes (REST endpoints)
  /services (business logic)
  /middleware (auth, validation)
```

## Endpoints
- `POST /auth/login` - Authenticate user
- `GET /tasks` - List tasks (auth required)
- `POST /tasks` - Create task

## Auth
JWT with 15min access + 7day refresh tokens
Stored in httpOnly cookies

## Database
Schema: `prisma/schema.prisma`
ORM: Prisma
Migrations: `npm run migrate`

## Testing
- Unit: Jest (src/**/*.{test,spec}.ts)
- Integration: supertest (tests/integration/*.test.ts)
- Coverage: >80% required

## Gotchas
- Tests use `--runInBand` in CI (sequential execution)
- Prisma migrate fails on CI: use `npx prisma migrate deploy`
- Auth middleware runs before ALL routes except /auth/login
```

**Quality Assessment**:
- **Delta Compliance** (20/20): 100% project-specific commands and patterns
- **Structure** (15/15): Clear sections, logical hierarchy
- **Clarity** (15/15): Copy-paste ready commands, specific tech versions
- **Completeness** (15/15): All essential topics covered
- **Commands** (10/10): All workflows documented with context
- **Patterns** (10/10): Critical gotchas captured
- **Maintainability** (15/15): Dense, actionable, no duplication
**Total: 100/100 (Grade A)**

---

### Example 2: Poor CLAUDE.md (Grade: F)

```markdown
# My Application

This is an application built with modern web technologies.

## What is React?

React is a JavaScript library for building user interfaces. It was created
by Facebook and is now maintained by Meta and the community. React makes it
painful to create interactive UIs. Design simple views for each state in
your application, and React will efficiently update and render the right
components when your data changes.

React is based on components. Components are JavaScript functions that
return markup. When you create a component, you can give it data by
creating props. Props are like arguments to a function - they get passed
in and you can use them in your JSX.

JSX is a syntax extension to JavaScript. It resembles a template language,
but it has the full power of JavaScript. JSX produces React "elements".
We use Babel to transform JSX into JavaScript that browsers can understand.

[... continues for 200 lines explaining React basics ...]

## Best Practices

Always write clean code. Clean code is code that is easy to read and
understand. It should be self-documenting. Use meaningful variable names.
Don't use magic numbers. Keep your functions small and focused. Apply
the single responsibility principle. Don't repeat yourself.

Write tests for your code. Testing is important because it ensures that
your code works as expected. It also serves as documentation. When you
write tests, you should test the behavior, not the implementation.

[... 150 more lines of generic advice ...]

## Database

Our application uses PostgreSQL, which is a powerful, open-source
object-relational database system. PostgreSQL has been actively
developed for over 15 years and has a strong reputation for
reliability, feature robustness, and performance.

[... 100 more lines about PostgreSQL ...]
```

**Quality Assessment**:
- **Delta Compliance** (0/20): 90% generic tutorial content
- **Structure** (3/15): No clear organization, wall of text
- **Clarity** (2/15): Vague instructions, no actionable commands
- **Completeness** (0/15): No project-specific information
- **Commands** (0/10): No commands documented
- **Patterns** (0/10): No gotchas or workarounds
- **Maintainability** (0/15): Massive duplication, no structure
**Total: 5/100 (Grade F)**

---

### Example 3: Mediocre CLAUDE.md (Grade: C)

```markdown
# My Project

A web application.

## Commands

- npm start - Start the app
- npm test - Run tests

## Architecture

The project has a frontend and backend.

## Database

We use a database.

## Testing

Write tests for your code.

## Best Practices

Use clean code principles.
```

**Quality Assessment**:
- **Delta Compliance** (8/20): Some project-specific but mostly vague
- **Structure** (6/15): Basic sections but shallow
- **Clarity** (6/15): Vague descriptions, no specific commands
- **Completeness** (8/15): Missing critical information
- **Commands** (3/10): No context, missing key workflows
- **Patterns** (2/10): No gotchas documented
- **Maintainability** (12/15): No duplication but lacks detail
**Total: 45/100 (Grade C)**

**Issues**:
- No specific tech stack mentioned
- Commands lack context (port numbers, environment)
- No gotchas or troubleshooting
- Generic best practices instead of project-specific rules
- Missing architecture details
