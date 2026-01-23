# Active Learning Integration

Capturing and persisting conversation insights into CLAUDE.md.

---

## What is Active Learning?

Active Learning is the process of:
1. **Identifying** valuable insights during a conversation
2. **Extracting** non-obvious knowledge from discoveries
3. **Integrating** learnings into CLAUDE.md
4. **Preserving** knowledge for future sessions

**Goal**: Transform ephemeral conversation discoveries into persistent project memory.

---

## Learning Types

### 1. Command Discoveries

**What**: Working commands, scripts, or operations

**Example**:
```
User: The build keeps failing
Claude: Check if you need to run `npm run build:clean` first
User: That worked! I didn't know about the clean command
```

**Integration**:
```markdown
## Commands
- `npm run build:clean` - Required before build to avoid caching issues
```

---

### 2. Architecture Insights

**What**: How the codebase is structured, module relationships

**Example**:
```
User: I can't import from the auth module
Claude: Check if crypto is initialized first - it's a dependency
User: Ah, that makes sense. Import order matters here
```

**Integration**:
```markdown
## Dependencies
The `auth` module depends on `crypto` being initialized first.
Import order matters: initialize crypto before auth in `src/bootstrap.ts`.
```

---

### 3. Gotchas and Workarounds

**What**: Non-obvious issues and their solutions

**Example**:
```
User: Tests pass locally but fail in CI
Claude: Check if you're using --runInBand flag
User: Yes! That's the issue. Tests interfere without sequential execution
```

**Integration**:
```markdown
## Testing
- Tests must run sequentially (`npm test -- --runInBand`)
- Without flag: race conditions cause random CI failures
```

---

### 4. Configuration Quirks

**What**: Environment-specific or unusual configuration requirements

**Example**:
```
User: Redis connection keeps timing out
Claude: Try adding ?family=0 to the connection string
User: That fixed it! Required for IPv6 support
```

**Integration**:
```markdown
## Configuration
Redis: Connection requires `?family=0` suffix for IPv6 support
Example: `redis://localhost:6379?family=0`
```

---

## Learning Extraction Process

### Step 1: Identify Valuable Learnings

**What to Capture**:
- ✅ Non-obvious solutions
- ✅ Working commands/scripts
- ✅ Architecture relationships
- ✅ Configuration quirks
- ✅ Workflow steps
- ✅ Performance optimizations

**What NOT to Capture**:
- ❌ Generic troubleshooting steps
- ❌ Well-documented features
- ❌ Personal preferences
- ❌ One-off mistakes
- ❌ Obvious observations

---

### Step 2: Extract Learning Components

For each learning, identify:

1. **Insight** (what was learned)
2. **Context** (when it applies)
3. **Solution** (how to apply it)
4. **Impact** (why it matters)
5. **Section** (where to add it)

---

### Step 3: Prioritize Learnings

**Priority Levels**:

**HIGH (must add)**:
- Blocking issues with solutions
- Critical workflow steps
- Security-related discoveries
- Performance bottlenecks

**MEDIUM (should add)**:
- Useful commands
- Architecture insights
- Configuration tips
- Testing patterns

**LOW (nice to add)**:
- Optimization tips
- Nice-to-know facts
- Alternative approaches
- Personal preferences

---

## What TO Add

### 1. Commands/Workflows Discovered

```markdown
## Build

`npm run build:prod` - Full production build with optimization
`npm run build:dev` - Fast dev build (no minification)
```

**Why**: Saves future sessions from discovering these again.

**Example**:
```
User: The build keeps failing
Claude: Try `npm run clean` first
User: That worked! I didn't know about that command
```

**Integration**:
```markdown
## Commands
- `npm run clean` - Clear cache and reinstall (use when build fails)
```

### 2. Gotchas and Non-Obvious Patterns

```markdown
## Gotchas

- Tests must run sequentially (`--runInBand`) due to shared DB state
- `yarn.lock` is authoritative; delete `node_modules` if deps mismatch
```

**Why**: Prevents repeating debugging sessions.

**Example**:
```
User: Tests pass locally but fail in CI
Claude: Check if you're using --runInBand flag
User: Yes! That's the issue. Tests interfere without sequential execution
```

**Integration**:
```markdown
## Testing
- Tests must run sequentially (`npm test -- --runInBand`)
- Without flag: race conditions cause random CI failures
```

### 3. Package Relationships

```markdown
## Dependencies

The `auth` module depends on `crypto` being initialized first.
Import order matters in `src/bootstrap.ts`.
```

**Why**: Architecture knowledge that isn't obvious from code.

**Example**:
```
User: I can't import from the auth module
Claude: Check if crypto is initialized first - it's a dependency
User: Ah, that makes sense. Import order matters here
```

**Integration**:
```markdown
## Dependencies
The `auth` module depends on `crypto` being initialized first.
Import order matters: initialize crypto before auth in `src/bootstrap.ts`.
```

### 4. Testing Approaches That Worked

```markdown
## Testing

For API endpoints: Use `supertest` with the test helper in `tests/setup.ts`
Mocking: Factory functions in `tests/factories/` (not inline mocks)
```

**Why**: Establishes patterns that work.

**Example**:
```
User: How do I test the API endpoints?
Claude: Use supertest with the helper in tests/setup.ts
User: Perfect! That saved me hours of setup
```

**Integration**:
```markdown
## Testing
- API tests: Use supertest with setup in `tests/setup.ts`
- Mocking: Factory functions in `tests/factories/` (not inline mocks)
```

### 5. Configuration Quirks

```markdown
## Config

- `NEXT_PUBLIC_*` vars must be set at build time, not runtime
- Redis connection requires `?family=0` suffix for IPv6
```

**Why**: Environment-specific knowledge.

**Example**:
```
User: Redis connection keeps timing out
Claude: Try adding ?family=0 to the connection string
User: That fixed it! Required for IPv6 support
```

**Integration**:
```markdown
## Configuration
Redis: Connection requires `?family=0` suffix for IPv6 support
Example: `redis://localhost:6379?family=0`
```

---

## What NOT to Add

### 1. Obvious Code Info

**Bad**:
```markdown
The `UserService` class handles user operations.
```

**Why**: The class name already tells us this.

### 2. Generic Best Practices

**Bad**:
```markdown
Always write tests for your code.
Use meaningful variable names.
```

**Why**: This is universal advice, not project-specific.

### 3. One-Off Fixes

**Bad**:
```markdown
We fixed a bug in commit abc123 where the login button didn't work.
```

**Why**: Won't recur; clutters the file.

**Better**:
```markdown
## Deployment
If build fails after Docker updates, restart daemon:
`sudo systemctl restart docker`
```

**Why**: Reusable troubleshooting knowledge.

### 4. Verbose Explanations

**Bad**:
```markdown
The authentication system uses JWT tokens. JWT (JSON Web Tokens) are
an open standard (RFC 7519) that defines a compact and self-contained
way for securely transmitting information between parties as a JSON
object. In our implementation, we use the HS256 algorithm which...
```

**Good**:
```markdown
Auth: JWT with HS256, tokens in `Authorization: Bearer <token>` header.
```

---

## Integration Strategies

### 1. Add to Existing Section

**Best for**: Learnings that fit existing structure

**Example**:
```
Existing section:
## Commands
- npm run dev
- npm test

Learning:
Add to Commands section:
## Commands
- npm run dev
- npm test
- npm run build:clean  # Required before build
```

---

### 2. Create New Section

**Best for**: Discoveries that don't fit existing sections

**Example**:
```
New section:
## Common Issues

### Build Failures
- Run `npm run build:clean` first
- Check that NODE_ENV=production
- Clear .cache if issues persist
```

---

### 3. Update Existing Content

**Best for**: Corrections or enhancements to current documentation

**Example**:
```
Before:
## Testing
Run `npm test` to run all tests.

After:
## Testing
- Run `npm test` to run all tests
- Must use `--runInBand` flag for CI to avoid race conditions
- Tests require sequential execution due to shared DB state
```

---

## Diff Format for Updates

For each suggested change:

### 1. Identify the File

```
File: ./CLAUDE.md
Section: Commands (new section after ## Architecture)
```

### 2. Show the Change

```diff
 ## Architecture
 ...

+## Commands
+
+| Command | Purpose |
+|---------|---------|
+| `npm run dev` | Dev server with HMR |
+| `npm run build` | Production build |
+| `npm test` | Run test suite |
```

### 3. Explain Why

> **Why this helps:** The build commands weren't documented, causing
> confusion about how to run the project. This saves future sessions
> from needing to inspect `package.json`.

---

## Quality Criteria for Learnings

### Good Learning (Add)

✅ **Non-obvious**: Not documented elsewhere
✅ **Actionable**: Provides specific steps
✅ **Tested**: Verified to work
✅ **Specific**: Project-contextual
✅ **Impactful**: Solves real problems

```markdown
## Redis Connection
Add `?family=0` suffix for IPv6 support
redis://localhost:6379?family=0
```

### Bad Learning (Don't Add)

❌ **Generic**: Applies to all projects
❌ **Vague**: No specific steps
❌ **Obvious**: Already documented
❌ **Hypothetical**: Not verified
❌ **Personal**: Team-specific preferences

```markdown
## Development
Always test your code before deploying.
(Generic, obvious, not actionable)
```

---

## Validation Checklist

Before finalizing an update, verify:

- [ ] Each addition is project-specific
- [ ] No generic advice or obvious info
- [ ] Commands are tested and work
- [ ] File paths are accurate
- [ ] Would a new Claude session find this helpful?
- [ ] Is this the most concise way to express the info?

---

## Measuring Success

### Metrics

**Learning Capture Rate**:
- % of valuable insights captured
- Target: >80% of high-priority learnings

**Integration Quality**:
- % of learnings that follow Delta Standard
- Target: >90%

**Improvement Score**:
- Quality score improvement per integration
- Target: +10 points minimum

**Future Utility**:
- % of added learnings used in future sessions
- Target: >70%
