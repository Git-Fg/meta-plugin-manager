---
name: iterative-retrieval
description: "Execute 4-phase loop for progressive context refinement. Use when complex searches require multiple refinement cycles, context gaps exist, or information location is unknown. Includes dispatch, evaluate, refine, and loop phases with evidence-based refinement. Not for simple file searches, known file locations, or single-query lookups."
---

<mission_control>
<objective>Execute 4-phase loop for progressive context refinement when information location is unknown.</objective>
<success_criteria>DISPATCH → EVALUATE → REFINE → LOOP completes with sufficient context (max 3 iterations)</success_criteria>
</mission_control>

<guiding_principles>

## The Path to High-Quality Retrieval Success

### 1. Progressive Refinement Yields Higher Relevance

Starting broad and narrowing progressively through multiple iterations produces better results than single-pass searches. Each iteration learns from the previous one, refining the search criteria based on actual file content rather than assumptions.

**Why this works:** Unknown terminology becomes known through exploration. Initial queries are either too broad (finding irrelevant files) or too narrow (missing relevant files). The 4-phase loop adapts based on evidence.

### 2. Relevance Scoring Enables Data-Driven Decisions

Scoring files on a 0-1 scale with consistent criteria transforms subjective relevance into objective rankings. This enables systematic comparison and data-driven refinement decisions.

**Why this works:** Quantitative scores eliminate guesswork. Files can be ranked, compared, and selected based on evidence rather than intuition. The 0.8 threshold provides clear convergence criteria.

### 3. Query Evolution Creates Traceable Refinement

Documenting how search terms change across iterations creates an audit trail of the discovery process. This traceability enables understanding what worked and what didn't.

**Why this works:** Explicit documentation prevents circular refinements. Seeing the query evolution ("context" → "React useContext" → "createContext") reveals what vocabulary the codebase actually uses.

### 4. Termination Gates Prevent Infinite Loops

Clear stopping conditions (max 3 iterations, 3+ high-relevance files, diminishing returns) ensure convergence without wasting cycles on unproductive searches.

**Why this works:** Without explicit gates, refinement can continue indefinitely without improvement. The 3-iteration limit balances thoroughness with efficiency. The 3-file threshold ensures sufficient context without over-collection.

### 5. Multi-Modal Discovery Increases Coverage

Combining pattern-based discovery (Glob) with content-based search (Grep) captures files that match either naming conventions or actual usage patterns.

**Why this works:** Some relevant files have clear naming (auth.ts) while others reveal relevance only through content. Multi-modal discovery ensures neither category is missed.

</guiding_principles>

## Workflow

**Phase 1: DISPATCH** → Broad initial query to find candidate files

**Phase 2: EVALUATE** → Score relevance 0-1 for each candidate

**Phase 3: REFINE** → Update search criteria based on evaluation

**Phase 4: LOOP** → Max 3 iterations, exit when converged

**Why:** Complex searches need progressive refinement—when location is unknown, single-query searches fail.

```python
# Iterative Retrieval 4-Phase Loop
for iteration in range(max_iterations=3):
    candidates = DISPATCH(broad_search_query)
    scored = EVALUATE(candidates, target_query)
    if CONVERGED(scored):
        return HIGH_RELEVANCE_FILES
    search_query = REFINE(scored, target_query)
```

## Navigation

| If you need...       | Read...                                         |
| :------------------- | :---------------------------------------------- |
| Dispatch phase       | ## Workflow → Dispatch                          |
| Evaluate phase       | ## Workflow → Evaluate                          |
| Refine phase         | ## Workflow → Refine                            |
| Loop control         | ## Workflow → Loop Control                      |
| 4-phase loop code    | ## Workflow → code block                        |
| Basic implementation | ## Implementation Patterns → Basic 4-Phase Loop |

---

## Implementation Patterns

### Basic 4-Phase Loop

```python
# Phase 1: DISPATCH - Broad initial query
files = glob("**/*auth*.ts") + glob("**/*login*.ts")
files += grep("authenticate|login|signup", "**/*.ts")

# Phase 2: EVALUATE - Score relevance 0-1
scored_files = []
for file in files:
    score = 0
    if "auth" in file.name: score += 0.3
    if "authenticate" in file.content: score += 0.4
    if file.content.count("login") > 3: score += 0.2
    scored_files.append((file, score))

# Phase 3: REFINE - Update search criteria
if len([f for f, s in scored_files if s >= 0.8]) >= 3:
    return [f for f, s in scored_files if s >= 0.8]
else:
    refined_query = add_specific_terms(search_query, scored_files)

# Phase 4: LOOP - Repeat with refined criteria
# (max 3 iterations)
```

### React Context Discovery Example

**Task**: Find React context patterns in a large codebase

**Iteration 1:**

- **DISPATCH**: Search for "context"
- **EVALUATE**: 50 files found, mostly React createContext
- **REFINE**: Add "React useContext" to narrow
- **LOOP**: Continue

**Iteration 2:**

- **DISPATCH**: Search for "React useContext useContext"
- **EVALUATE**: 15 files, mostly usage patterns
- **REFINE**: Add "createContext" to find definitions
- **LOOP**: Continue

**Iteration 3:**

- **DISPATCH**: Search for "createContext useContext React"
- **EVALUATE**: 8 files, 4 with high relevance (0.8+)
- **CONVERGED**: Sufficient high-relevance files found

### Result Format

```markdown
## Iterative Retrieval Results

### Summary

- **Iterations**: 3
- **Total files evaluated**: 73
- **High-relevance files**: 4
- **Search query evolution**: "context" → "React useContext" → "createContext"

### High-Relevance Files (0.8+)

1. **src/context/AuthContext.tsx** (score: 0.95)
2. **src/context/ThemeContext.tsx** (score: 0.88)
```

---

## Troubleshooting

**Issue**: No results found

- **Symptom**: Initial query returns empty
- **Solution**: Refine search terms, expand file types, check directory scope

**Issue**: Too many results

- **Symptom**: Hundreds of matches
- **Solution**: Narrow scope, add path filters, increase specificity

**Issue**: Convergence not reached

- **Symptom**: Scores not improving after 3 iterations
- **Solution**: Change terminology entirely, try different search patterns

**Issue**: Wrong domain found

- **Symptom**: Found frontend files when needing backend
- **Solution**: Add domain-specific terms (e.g., "server", "api", "backend")

---

## The Problem

Subagents don't know what they need until they start searching:

- Initial queries are too broad or too narrow
- Codebase terminology is unknown upfront
- Context gaps emerge during exploration
- Single-pass search misses relevant files

## The Solution: 4-Phase Loop

```
┌─────────────────────────────────────────────────────────────┐
│                  ITERATIVE RETRIEVAL LOOP                   │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. DISPATCH       ──► Broad initial query to gather files  │
│         │                                                     │
│         ▼                                                     │
│  2. EVALUATE      ──► Score relevance 0-1 for each file     │
│         │                                                     │
│         ▼                                                     │
│  3. REFINE        ──► Update search criteria based on scores│
│         │                                                     │
│         ▼                                                     │
│  4. LOOP          ──► Repeat with refined criteria (max 3) │
│         │                                                     │
│         ▼                                                     │
│    HIGH RELEVANCE FILES FOUND ✓                             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Phase 1: DISPATCH

**Purpose**: Cast a wide net to gather candidate files.

**Approach:**

- Start with broad search terms
- Use multiple search patterns (Glob + Grep)
- Gather 10-20 candidate files
- Don't worry about relevance yet

**Example:**

```python
# Searching for "authentication patterns"
files = glob("**/*auth*.ts") + glob("**/*login*.ts")
files += grep("authenticate|login|signup", "**/*.ts")
```

**Output**: List of candidate files (unordered, broad)

## Phase 2: EVALUATE

**Purpose**: Score each file's relevance to the actual query.

**Scoring System (0-1):**

| Score   | Relevance | Action                           |
| ------- | --------- | -------------------------------- |
| 0.8-1.0 | High      | Read immediately, use in context |
| 0.5-0.7 | Medium    | Skim first, read if relevant     |
| 0.2-0.4 | Low       | Skip unless no high/medium found |
| 0-0.2   | None      | Ignore                           |

**Scoring Criteria:**

- Filename match: +0.3
- Import/usage match: +0.4
- Multiple keyword occurrences: +0.2
- Recent modification: +0.1
- Project type match (e.g., frontend/backend): +0.1

**Example:**

```python
# Score each candidate file
for file in candidates:
  score = 0
  if "auth" in file.name: score += 0.3
  if "authenticate" in file.content: score += 0.4
  if file.content.count("login") > 3: score += 0.2
  # ... store score
```

**Output**: Files with relevance scores

## Phase 3: REFINE

**Purpose**: Update search criteria based on evaluation results.

**Refinement Strategies:**

| Situation                       | Refinement                      |
| ------------------------------- | ------------------------------- |
| Too many high scores (0.8+)     | Narrow by adding specific terms |
| No high scores, many medium     | Add domain-specific terms       |
| All low scores                  | Change terminology entirely     |
| Found right domain, wrong files | Add file extension filters      |

**Example:**

```python
# Initial: "authentication"
# Result: Many frontend auth files, need backend

# Refined: "authentication server api"
# Result: Backend auth endpoints found
```

**Output**: Updated search query for next iteration

## Phase 4: LOOP

**Purpose**: Repeat with refined criteria until convergence.

**Termination Conditions:**

1. **Max iterations reached** (3 cycles maximum)
2. **Sufficient high-relevance files** (3+ files with 0.8+ score)
3. **Diminishing returns** (scores not improving between iterations)
4. **Context gap identified and filled** (specific question answered)

**Example:**

```python
max_iterations = 3
high_relevance_files = []

for iteration in range(max_iterations):
  candidates = dispatch(search_query)
  scored = evaluate(candidates, target_query)
  high_relevance_files.extend([f for f in scored if f.score >= 0.8])

  if len(high_relevance_files) >= 3:
    break  # Converged

  search_query = refine(search_query, scored)
```

**Output**: Final set of high-relevance files

## Usage Pattern

### When to Use Iterative Retrieval

✅ **Use when:**

- Searching for concepts with unknown terminology
- Initial search returns too many results (>20 files)
- Initial search returns too few results (<3 files)
- Domain-specific jargon is unknown
- Context gap is unclear

❌ **Don't use when:**

- File location is known
- Simple search will suffice
- Single-pass search finds relevant files
- Working with well-documented codebase

### Integration with File-Search

**file-search**: Basic search capability (find files by pattern)

**iterative-retrieval**: Advanced refinement (relevance scoring, progressive narrowing)

```
For simple searches:
→ Use file-search directly

For complex searches:
→ Use iterative-retrieval (uses file-search as initial dispatch)
```

### Example Workflow

**Task**: Find React context patterns in a large codebase

**Iteration 1:**

- **DISPATCH**: Search for "context"
- **EVALUATE**: 50 files found, mostly React createContext, some unrelated
- **REFINE**: Add "React useContext" to narrow
- **LOOP**: Continue

**Iteration 2:**

- **DISPATCH**: Search for "React useContext useContext"
- **EVALUATE**: 15 files, mostly usage patterns, few definitions
- **REFINE**: Add "createContext" to find definitions
- **LOOP**: Continue

**Iteration 3:**

- **DISPATCH**: Search for "createContext useContext React"
- **EVALUATE**: 8 files, 4 with high relevance (0.8+)
- **CONVERGED**: Sufficient high-relevance files found

**Result**: 4 context definition files with usage patterns identified

## Output Format

Return results as:

```markdown
## Iterative Retrieval Results

### Summary

- **Iterations**: 3
- **Total files evaluated**: 73
- **High-relevance files**: 4
- **Search query evolution**: "context" → "React useContext" → "createContext useContext"

### High-Relevance Files (0.8+)

1. **src/context/AuthContext.tsx** (score: 0.95)
   - Defines AuthContext with provider
   - Exports useAuth hook
   - 15 usages across codebase

2. **src/context/ThemeContext.tsx** (score: 0.88)
   - Defines ThemeContext with dark/light mode
   - Exports useTheme hook
   - 8 usages across codebase

### Medium-Relevance Files (0.5-0.7)

- **src/hooks/useContext.ts** (score: 0.65) - Utility hook, not context definition

### Context Gap Analysis

**Initial query**: "React context patterns"
**Gap**: Need both definitions and usage patterns
**Filled**: Found 4 definitions, usage patterns documented

### Next Steps

Use high-relevance files as context for understanding React context patterns in this codebase.
```

## Best Practices

1. **Start broad, narrow progressively** - Don't over-constrain initial query
2. **Score objectively** - Use consistent criteria across iterations
3. **Track query evolution** - Document how search terms change
4. **Know when to stop** - Don't iterate beyond 3 cycles
5. **Combine with other patterns** - Use filesystem-context for storage

## Integration with Seed System

### File-Search Integration

- **file-search**: Basic file finding by pattern
- **iterative-retrieval**: Progressive refinement with relevance scoring

**Integration**: iterative-retrieval uses file-search as initial dispatch mechanism.

### Filesystem-Context Integration

- **iterative-retrieval**: Discovers relevant files
- **filesystem-context**: Stores discovered files for selective retrieval

**Integration**: Use iterative-retrieval for discovery, filesystem-context for persistent access.

## Related Skills

- **file-search**: Basic file search capability
- **filesystem-context**: Persistent storage for discovered context

## Key Principle

Progressive refinement through 4-phase loop (DISPATCH → EVALUATE → REFINE → LOOP) yields higher relevance than single-pass search, especially when terminology is unknown upfront.

---

## Genetic Code

This component carries essential Seed System principles for context: fork isolation:

**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows

**Recognition Questions**:

- "Would Claude know this without being told?" → Delete (zero delta)
- "Can this work standalone?" → Fix if no (non-self-sufficient)
- "Did I read the actual file, or just see it in grep?" → Verify before claiming

---

<critical_constraint>
**Portability Invariant:**

This component MUST work in a project containing ZERO config files. It carries its own genetic code and references no external rules or paths.
</critical_constraint>

---
