---
name: search
description: "Execute iterative retrieval search with progressive refinement. Use 4-phase loop: DISPATCH → EVALUATE → REFINE → LOOP to find high-relevance files. Not for simple file searches - use Glob for that."
---

<mission_control>
<objective>Execute iterative retrieval with 4-phase loop to find high-relevance files</objective>
<success_criteria>High-relevance files (0.8+ score) identified with relevance scores and iteration summary</success_criteria>
</mission_control>

<interaction_schema>
dispatch → evaluate → refine → loop → converge
</interaction_schema>

# Search Command (Iterative Retrieval)

Execute progressive refinement search to find high-relevance files for complex queries.

## What This Does

Implements 4-phase iterative retrieval:

1. **DISPATCH** - Broad initial query to gather candidate files
2. **EVALUATE** - Score relevance (0-1) for each file
3. **REFINE** - Update search criteria based on scores
4. **LOOP** - Repeat with refined criteria (max 3 cycles)

## Usage

```
/search <query>
```

## Example

```
/search "authentication patterns in backend API"
```

## Process

**Iteration 1:**

- Search for "authentication patterns backend API"
- Score each file's relevance
- Identify top candidates and missing context

**Iteration 2:**

- Refine search based on evaluation
- Add domain-specific terms
- Score again with narrower criteria

**Iteration 3:**

- Final refinement if needed
- Converge on high-relevance files

## Output

```markdown
## Iterative Retrieval Results

### Summary

- **Iterations**: 2
- **Total files evaluated**: 27
- **High-relevance files**: 5

### High-Relevance Files (0.8+)

1. **src/api/auth.ts** (score: 0.92)
   - Authentication endpoint definitions
   - JWT token validation logic

2. **src/middleware/auth.ts** (score: 0.88)
   - Auth middleware for route protection

...
```

## When to Use

- Searching for concepts with unknown terminology
- Initial search returns too many/too few results
- Domain-specific jargon is unknown
- Complex context discovery needed

## Integration

This command integrates with:

- `iterative-retrieval` skill - Full documentation
- `file-search` - Basic search capability
- `filesystem-context` - Persistent storage for discovered files

---

<critical_constraint>
MANDATORY: Maximum 3 iterations - stop when converged
MANDATORY: Score files on 0-1 scale for relevance
MANDATORY: Report high-relevance files (0.8+) with scores
MANDATORY: Show iteration summary (total files evaluated, iterations run)
No exceptions. Progressive refinement must converge efficiently.
</critical_constraint>
