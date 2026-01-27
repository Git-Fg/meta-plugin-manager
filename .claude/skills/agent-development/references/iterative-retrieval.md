# Iterative Retrieval Pattern

Solves the "context problem" in multi-agent workflows where subagents don't know what context they need until they start working.

---

## The Problem

Subagents are spawned with limited context. They don't know:
- Which files contain relevant code
- What patterns exist in the codebase
- What terminology the project uses

**Standard approaches fail:**
- **Send everything**: Exceeds context limits
- **Send nothing**: Agent lacks critical information
- **Guess what's needed**: Often wrong

**Result**: Agents ask unnecessary questions, miss important files, or fail completely.

---

## The Solution: Iterative Retrieval

A 4-phase loop that progressively refines context until the agent has sufficient information to work autonomously.

```
┌─────────────────────────────────────────────┐
│                                             │
│   ┌──────────┐      ┌──────────┐            │
│   │ DISPATCH │─────▶│ EVALUATE │            │
│   └──────────┘      └──────────┘            │
│        ▲                  │                 │
│        │                  ▼                 │
│   ┌──────────┐      ┌──────────┐            │
│   │   LOOP   │◀─────│  REFINE  │            │
│   └──────────┘      └──────────┘            │
│                                             │
│        Max 3 cycles, then proceed           │
└─────────────────────────────────────────────┘
```

### Phase 1: DISPATCH

Initial broad query to gather candidate files.

**Start with high-level intent:**
- Use broad file patterns (`src/**/*.ts`, `lib/**/*.py`)
- Include domain keywords (`auth`, `payment`, `user`)
- Exclude obvious non-matches (`*.test.ts`, `*.spec.py`, `node_modules/**`)

**Example:**
```javascript
// Initial dispatch query
const initialQuery = {
  patterns: ['src/**/*.ts', 'lib/**/*.ts'],
  keywords: ['authentication', 'user', 'session', 'token'],
  excludes: ['*.test.ts', '*.spec.ts', '**/*.mock.ts']
};

// Use available tools to retrieve
const candidates = await retrieveFiles(initialQuery);
```

### Phase 2: EVALUATE

Assess retrieved content for relevance to the task.

**Score each file on relevance (0-1 scale):**

| Score | Label | Meaning | Action |
|-------|-------|---------|--------|
| 0.8-1.0 | High | Directly implements target functionality | Keep, prioritize |
| 0.5-0.7 | Medium | Contains related patterns or types | Keep, secondary priority |
| 0.2-0.4 | Low | Tangentially related | Exclude unless no better options |
| 0-0.2 | None | Not relevant | Exclude immediately |

**Evaluation function:**
```javascript
function evaluateRelevance(files, task) {
  return files.map(file => ({
    path: file.path,
    relevance: scoreRelevance(file.content, task),
    reason: explainRelevance(file.content, task),
    missingContext: identifyGaps(file.content, task)
  }));
}

function scoreRelevance(content, task) {
  // Check for direct keyword matches
  const keywordScore = countKeywordMatches(content, task.keywords);

  // Check for pattern matches (imports, function calls, type usage)
  const patternScore = identifyPatterns(content, task.patterns);

  // Check for semantic relevance (domain concepts, terminology)
  const semanticScore = semanticAnalysis(content, task.domain);

  return weightedAverage({
    keywords: keywordScore * 0.4,
    patterns: patternScore * 0.4,
    semantic: semanticScore * 0.2
  });
}
```

### Phase 3: REFINE

Update search criteria based on evaluation findings.

**Extract patterns from high-relevance files:**
- Import patterns (what modules are used)
- Type patterns (what types are referenced)
- Function call patterns (what functions are commonly called)
- Terminology (what naming conventions are used)

**Update query:**
```javascript
function refineQuery(evaluation, previousQuery) {
  const highRelevance = evaluation.filter(e => e.relevance >= 0.7);
  const mediumRelevance = evaluation.filter(e => e.relevance >= 0.5 && e.relevance < 0.7);

  return {
    // Add new patterns discovered in high-relevance files
    patterns: [
      ...previousQuery.patterns,
      ...extractImportPatterns(highRelevance),
      ...extractTypeReferences(highRelevance)
    ],

    // Add terminology found in codebase
    keywords: [
      ...previousQuery.keywords,
      ...extractFunctionNames(highRelevance),
      ...extractVariablePatterns(highRelevance)
    ],

    // Exclude confirmed irrelevant paths
    excludes: [
      ...previousQuery.excludes,
      ...evaluation
        .filter(e => e.relevance < 0.2)
        .map(e => e.path)
    ],

    // Target specific gaps identified
    focusAreas: highRelevance
      .flatMap(e => e.missingContext)
      .filter(unique)
  };
}
```

### Phase 4: LOOP

Repeat with refined criteria (maximum 3 cycles).

**Termination conditions:**
```javascript
async function iterativeRetrieve(task, maxCycles = 3) {
  let query = createInitialQuery(task);
  let bestContext = [];

  for (let cycle = 0; cycle < maxCycles; cycle++) {
    // Phase 1: DISPATCH
    const candidates = await retrieveFiles(query);

    // Phase 2: EVALUATE
    const evaluation = evaluateRelevance(candidates, task);

    // Check if we have sufficient context
    const highRelevance = evaluation.filter(e => e.relevance >= 0.7);
    const hasCriticalGaps = evaluation.some(e =>
      e.missingContext && e.missingContext.length > 0
    );

    if (highRelevance.length >= 3 && !hasCriticalGaps) {
      return highRelevance; // Sufficient context found
    }

    // Phase 3: REFINE
    query = refineQuery(evaluation, query);
    bestContext = mergeContext(bestContext, highRelevance);

    // Phase 4: LOOP
    // Continue to next iteration
  }

  return bestContext; // Return best found after max cycles
}
```

---

## Practical Examples

### Example 1: Bug Fix Context

**Task:** "Fix the authentication token expiry bug"

**Cycle 1:**
- **DISPATCH**: Search for "token", "auth", "expiry" in `src/**`
- **EVALUATE**:
  - `src/auth/auth.ts`: 0.9 (token handling)
  - `src/auth/tokens.ts`: 0.8 (token utilities)
  - `src/auth/user.ts`: 0.3 (user management, not token-related)
- **REFINE**: Add "refresh", "jwt", "expiration" keywords; exclude `user.ts`

**Cycle 2:**
- **DISPATCH**: Search refined terms
- **EVALUATE**:
  - `src/auth/session-manager.ts`: 0.95 (session expiration)
  - `src/auth/jwt-utils.ts`: 0.85 (JWT token parsing)
- **REFINE**: Sufficient context (4 high-relevance files)

**Result:** `auth.ts`, `tokens.ts`, `session-manager.ts`, `jwt-utils.ts`

### Example 2: Feature Implementation

**Task:** "Add rate limiting to API endpoints"

**Cycle 1:**
- **DISPATCH**: Search "rate", "limit", "api" in `routes/**`
- **EVALUATE**:
  - No matches - codebase uses "throttle" terminology instead
- **REFINE**: Add "throttle", "middleware", "express" keywords

**Cycle 2:**
- **DISPATCH**: Search refined terms
- **EVALUATE**:
  - `src/middleware/throttle.ts`: 0.9 (throttling middleware)
  - `src/middleware/index.ts`: 0.7 (middleware registration)
- **REFINE**: Need router integration patterns

**Cycle 3:**
- **DISPATCH**: Search "router", "app" patterns
- **EVALUATE**:
  - `src/router-setup.ts`: 0.8 (router configuration)
- **REFINE**: Sufficient context

**Result:** `throttle.ts`, `middleware/index.ts`, `router-setup.ts`

### Example 3: Code Quality Audit

**Task:** "Review error handling patterns across the codebase"

**Cycle 1:**
- **DISPATCH**: Search "error", "catch", "throw" in `src/**`
- **EVALUATE**:
  - `src/utils/errors.ts`: 0.9 (error utilities)
  - `src/api/*.ts`: 0.6-0.7 (mixed error handling)
  - `src/services/*.ts`: 0.5-0.7 (various patterns)
- **REFINE**: Look for error classes, custom error types

**Cycle 2:**
- **DISPATCH**: Search "Error", "Exception", "class" in error-related files
- **EVALUATE**:
  - `src/utils/errors.ts`: 0.95 (custom error classes)
  - `src/middleware/error-handler.ts`: 0.85 (error handling middleware)
- **REFINE**: Sufficient context

**Result:** Complete picture of error handling patterns

---

## Integration with Agent Prompts

Add iterative retrieval instructions to agent system prompts:

```markdown
You are [agent role] specializing in [domain].

**Context Retrieval Process:**
When gathering context for this task, use iterative retrieval:

1. **DISPATCH**: Start with broad keyword search using Glob and Grep
   - Use high-level domain keywords
   - Include common file patterns for this language
   - Exclude test files and dependencies

2. **EVALUATE**: Score each file's relevance (0-1 scale):
   - **High (0.8-1.0)**: Directly relevant, prioritizes
   - **Medium (0.5-0.7)**: Related, secondary priority
   - **Low (0.2-0.4)**: Tangential, likely exclude
   - **None (0-0.2)**: Not relevant, exclude

3. **REFINE**: Identify what context is still missing
   - What terminology does the codebase use?
   - What patterns are referenced but not defined?
   - What dependencies exist?

4. **LOOP**: Repeat with refined search criteria (max 3 cycles)
   - Add discovered terminology to search
   - Follow import/type references
   - Exclude confirmed irrelevant paths

5. **PROCEED**: When you have 3+ high-relevance files and no critical gaps

**Then continue with your primary process.**
```

---

## Best Practices

### 1. Start Broad, Narrow Progressively

**Don't over-specify initial queries:**
- ✅ Good: `src/**/*.ts` with keywords ["auth", "token"]
- ❌ Bad: `src/auth/v2/jwt/**/access-token*.ts` (too specific initially)

**Let the evaluation phase guide refinement:**
- First cycle often reveals correct terminology
- Second cycle refines based on discovered patterns
- Third cycle fills remaining gaps

### 2. Learn Codebase Terminology

**First cycle often reveals naming conventions:**

*Example: Agent searches for "rate limit" but codebase uses "throttle"*

**Cycle 1:**
- Search: "rate", "limit"
- Result: No matches
- Learning: Codebase doesn't use "rate limit" terminology

**Cycle 2:**
- Search: "throttle", "middleware"
- Result: Found throttle.ts
- Success: Correct terminology discovered

### 3. Track What's Missing

**Explicit gap identification drives refinement:**

```javascript
// In evaluation phase
const gaps = [];

if (hasTokenHandling(content) && !hasTokenValidation(content)) {
  gaps.push("token validation logic");
}

if (hasDatabaseQueries(content) && !hasConnectionPooling(content)) {
  gaps.push("database connection setup");
}

// In refine phase, add gap keywords
query.focusAreas = gaps;
```

### 4. Stop at "Good Enough"

**3 high-relevance files beats 10 mediocre ones:**

**Acceptable stopping conditions:**
- 3+ files with relevance >= 0.7
- No critical gaps (missing essential components)
- Clear understanding of codebase patterns

**Don't over-retrieve:**
- Context windows are expensive
- More files ≠ better understanding
- Diminishing returns after 3-5 relevant files

### 5. Exclude Confidently

**Low-relevance files won't become relevant:**

If a file scores < 0.2 in cycle 1:
- It's not relevant to the current task
- Later cycles won't change this
- Exclude permanently to reduce noise

**Exception:** If you find ZERO high-relevance files, reconsider search terms.

---

## Implementing Iterative Retrieval

### For Agent Creators

**Add to agent system prompt:**

```markdown
**Context Gathering:**
Use iterative retrieval to find relevant files:
1. Start with broad search (domain keywords + file patterns)
2. Score relevance (0-1 scale) based on keyword/pattern matches
3. Refine search with discovered terminology
4. Repeat max 3 cycles or until 3+ high-relevance files found
```

### For Agent Users

**When an agent seems to lack context:**

1. **Request context refresh**: "Search for more files related to X"
2. **Provide specific files**: "Also check src/auth/jwt.ts"
3. **Clarify terminology**: "The codebase uses 'throttle' not 'rate limit'"

---

## Common Pitfalls

### Pitfall 1: Single-Cycle Retrieval

**❌ Bad:**
```markdown
Search for files matching "auth" and "token".
Read them and proceed.
```

**Problem:** Misses files using different terminology, lacks pattern discovery.

**✅ Good:**
```markdown
Cycle 1: Search for "auth", "token"
Evaluate: Found jwt.ts (0.9), but missing session management
Cycle 2: Add "session", "refresh" keywords
Evaluate: Found session-manager.ts (0.95)
Proceed: Sufficient context
```

### Pitfall 2: No Relevance Scoring

**❌ Bad:**
```markdown
Find all files with "error" keyword.
Read all 50 files.
```

**Problem:** Overwhelming, wastes context, includes irrelevant files.

**✅ Good:**
```markdown
Find files with "error" keyword.
Score relevance:
- error-utils.ts: 0.95 (keep)
- api-route-1.ts: 0.3 (error handling, but not core)
- test-file.test.ts: 0.1 (exclude)
Read top 5 high-relevance files.
```

### Pitfall 3: Fixed Terminology

**❌ Bad:**
```markdown
Search for "rate limiting" patterns.
```

**Problem:** Assumes codebase uses specific terminology.

**✅ Good:**
```markdown
Cycle 1: Search for "rate", "limit", "throttle", "middleware"
Discover: Codebase uses "throttle"
Cycle 2: Refine with "throttle" and related patterns
```

---

## Summary

**Iterative retrieval solves the subagent context problem through:**

1. **DISPATCH**: Broad initial search
2. **EVALUATE**: Relevance scoring (0-1 scale)
3. **REFINE**: Learn terminology, follow patterns
4. **LOOP**: Max 3 cycles, stop when sufficient

**Success criteria:**
- 3+ files with relevance >= 0.7
- No critical gaps in understanding
- Clear grasp of codebase terminology

**Benefits:**
- Agents find relevant files autonomously
- Reduces unnecessary questions
- Adapts to codebase terminology
- Efficient context window usage

**When to use:**
- Agent needs to discover context
- Unfamiliar codebase
- Complex, multi-file tasks
- When terminology is uncertain

**When NOT to use:**
- User provides specific files
- Simple, single-file tasks
- Well-known, documented codebase
- Quick lookups
