# Quality Framework

11-dimensional scoring system for skill quality assessment and production readiness.

---

## Scoring Dimensions

### 1. Knowledge Delta (20 points)

**CRITICAL: Expert-only vs Claude-obvious**

| Score | Criteria |
|-------|----------|
| 17-20 | 100% Project-Specific. Zero tutorials. |
| 13-16 | Mostly expert knowledge. |
| 8-12  | Contains some generic info. |
| 0-7   | Fails Delta Principle (tutorials found). |

**Recognition Questions**:
- Would Claude know this without being told?
- Is this expert-only or generic information?
- Does this justify its token cost?

**High Score Indicators**:
- 100% project-specific
- No generic tutorials
- Expert patterns only
- Non-obvious insights

**Example**:
```markdown
# API Convention Skill

## Our Pattern
- Routes: `/api/users` (plural)
- Response: `{ data, error, meta }`
- Error codes: 400 (validation), 401 (auth), 404 (not found)

## Why This Matters
Plural routes support HATEOAS. Separate error field prevents data pollution.
```

**Low Score (0-8)**:
- Generic programming concepts
- Tutorial-style content
- Information Claude already knows

### 2. Autonomy (15 points)

**80-95% completion without questions**

| Score | Criteria |
|-------|----------|
| 13-15 | 90-95% autonomous |
| 10-12 | 85-89% autonomous |
| 8-9   | 80-84% autonomous |
| 0-7   | <80% autonomous |

**How to measure**:
```bash
# Test skill execution
claude --dangerously-skip-permissions -p "Use skill-name" \
  --output-format stream-json \
  > test-output.json

# Check for permission denials
grep '"permission_denials":\s*\[\]' test-output.json && echo "100% autonomy"
```

**Recognition**: Count questions in test output. 0-1 questions = 95%, 2-3 = 85-90%, 6+ = <80%

**High Score Indicators**:
- 0-2 questions asked
- Completes tasks independently
- Clear decision criteria
- Concrete patterns provided

**Example**:
```markdown
# Security Scanner

Scan for:
1. SQL injection (string concat in queries)
2. XSS (no output encoding)
3. Auth bypass (missing checks)

Generate report with severity.
```

**Low Score (0-7)**:
- 6+ questions needed
- Requires constant guidance
- Vague instructions

### 3. Discoverability (15 points)

**Clear description with triggers (What-When-Not framework)**

| Score | Criteria |
|-------|----------|
| 13-15 | Clear WHAT/WHEN/NOT, discoverable, concise |
| 10-12 | Good triggers, minor verbosity |
| 7-9   | Adequate triggers, some ambiguity |
| 4-6   | Unclear triggers, verbose |
| 0-3   | No clear triggers, or includes "how" language |

**See**: [description-guidelines.md](description-guidelines.md) for complete What-When-Not framework.

**High Score Example**:
```yaml
---
name: api-conventions
description: "API design patterns for this codebase. Use when writing endpoints, modifying existing endpoints, or reviewing API changes."
---
```

**Low Score Example**:
```yaml
---
name: api-helper
description: "Helps with API development"
---
```

### 4. Progressive Disclosure (15 points)

**Tier 1/2/3 properly organized**

| Score | Criteria |
|-------|----------|
| 13-15 | Perfect tier structure |
| 10-12 | Good tier structure |
| 7-9   | Adequate tiers |
| 4-6   | Poor tiers |
| 0-3   | No tiers |

**Targets**:
- Tier 1: ~100 tokens (metadata)
- Tier 2: <500 lines (SKILL.md)
- Tier 3: Unlimited (references/)

**See**: [progressive-disclosure.md](progressive-disclosure.md) for complete guide.

**High Score Indicators**:
- Tier 1: ~100 token description
- Tier 2: <500 lines core content
- Tier 3: references/ for deep details

**Low Score Indicators**:
- Everything in one tier
- Missing references when needed
- Tier 2 too long (>500 lines)

### 5. Clarity (15 points)
**Focus**: Unambiguous instructions

**High Score (14-15)**:
- Clear, concise language
- Specific examples
- No jargon
- Scannable structure

**Example**:
```markdown
## When to Use
- New API endpoints
- Modifying existing endpoints
- Code reviews

## Pattern
- Route: `/api/{resource}` (plural)
- Methods: get, post, put, delete
```

### 6. Completeness (15 points)
**Focus**: Covers all scenarios

**High Score (14-15)**:
- Main use cases covered
- Edge cases addressed
- Error handling included
- Integration points clear

### 7. Standards Compliance (15 points)
**Focus**: Follows Agent Skills spec

**High Score (14-15)**:
- Valid YAML frontmatter
- Proper structure
- Completion markers
- Agent Skills features used correctly

### 8. Security (10 points)
**Focus**: Validation, safe execution

**High Score (9-10)**:
- Input validation
- Safe defaults
- No dangerous operations
- Clear security guidance

### 9. Performance (10 points)
**Focus**: Efficient workflows

**High Score (9-10)**:
- Minimal context needed
- Fast execution
- Parallelizable when possible
- No unnecessary operations

### 10. Maintainability (10 points)
**Focus**: Well-structured

**High Score (9-10)**:
- Modular design
- Clear organization
- Easy to update
- Minimal dependencies

### 11. Innovation (5 points)
**Focus**: Unique value

**High Score (5)**:
- Novel approach
- Unique insights
- Creative problem-solving
- Adds genuine value

## Quality Assessment Example

### Skill: "api-conventions"

**YAML Frontmatter**:
```yaml
---
name: api-conventions
description: "RESTful API design patterns for this project. Use when creating, modifying, or reviewing endpoints."
user-invocable: false
---
```
**Score**: 15/15 (Perfect)

**Tier 1**: ✅ Clear description, proper length

**Tier 2** (SKILL.md):
```markdown
# API Conventions

## Our Standards
- Base: `/api/v1/{resource}`
- Plural resources: `/api/v1/users` not `/api/v1/user`
- Methods: GET (read), POST (create), PUT (replace), PATCH (update), DELETE (remove)
- Response: `{ data, error, meta }`

## Examples

**Create User**:
```http
POST /api/v1/users
Content-Type: application/json

{ "email": "user@example.com", "name": "User Name" }

Response:
{
  "data": { "id": 1, "email": "user@example.com", "name": "User Name" },
  "error": null,
  "meta": { "version": "v1" }
}
```

## Error Handling
- 400: Validation error (missing fields, invalid format)
- 401: Authentication required
- 403: Insufficient permissions
- 404: Resource not found
- 409: Conflict (duplicate email)
- 500: Server error

See [errors.md](references/errors.md) for complete error catalog.
```
**Score**: 12/15 (Good - some scenarios missing)

**Progressive Disclosure**:
- Tier 1: ✅ ~80 tokens
- Tier 2: ✅ ~150 lines
- Tier 3: ✅ references/errors.md
**Score**: 14/15 (Excellent)

**Total Score**: 14+12+14+... = 140/160 (Grade: B+, Production Ready)

## Common Quality Issues

### Issue 1: Generic Knowledge (Low Delta)
**Problem**:
```markdown
# API Skill

APIs are how applications communicate...

REST uses HTTP methods:
GET - Read data
POST - Create data
...
```

**Fix**:
```markdown
# API Conventions

## Our Pattern
- Base: `/api/v1/{resource}`
- Response: `{ data, error, meta }`

## Why This Matters
Separate error field prevents data pollution...
```

### Issue 2: Low Autonomy
**Problem**:
```markdown
# File Organizer

Organize files.
```
Questions: "How?" "What criteria?" "Where?"

**Fix**:
```markdown
# File Organizer

Organize by type:
- Code: *.js, *.ts → src/
- Tests: *.test.* → tests/
- Docs: *.md → docs/

Output: List of moves.
```
Questions: 0

### Issue 3: Poor Discoverability
**Problem**:
```yaml
---
name: helper
description: "A helpful skill for development"
---
```

**Fix**:
```yaml
---
name: api-standards
description: "API design standards for this project. Use when creating, modifying, or reviewing endpoints."
---
```

### Issue 4: Missing Progressive Disclosure
**Problem**:
```markdown
# API Skill (800 lines)

Everything: basics, advanced, examples, troubleshooting, error handling, testing, deployment...
```

**Fix**:
```markdown
# API Skill (200 lines)

Core patterns and examples.

See [advanced.md](references/advanced.md) for advanced scenarios.
See [troubleshooting.md](references/troubleshooting.md) for issues.
```

## Quick Assessment Checklist

**Before production, verify**:
- [ ] Knowledge Delta: Is this expert-only? (18-20/20)
- [ ] Autonomy: 0-3 questions? (12-15/15)
- [ ] Discoverability: Clear triggers? (12-15/15)
- [ ] Progressive Disclosure: Proper tiers? (12-15/15)
- [ ] Clarity: Unambiguous? (12-15/15)
- [ ] Completeness: All scenarios? (12-15/15)
- [ ] Standards: Agent Skills spec? (12-15/15)
- [ ] Security: Safe execution? (8-10/10)
- [ ] Performance: Efficient? (8-10/10)
- [ ] Maintainability: Well-structured? (8-10/10)
- [ ] Innovation: Unique value? (4-5/5)

**Total Score**: ≥128/160 (8.0/10) for production

## Improving Low Scores

### If Knowledge Delta <15:
- Remove generic content
- Add project-specific patterns
- Include expert insights
- Focus on non-obvious decisions

### If Autonomy <12:
- Add concrete patterns
- Define clear outputs
- Include decision criteria
- Provide examples

### If Discoverability <12:
- Rewrite description with WHAT/WHEN/NOT
- Use specific triggers
- Avoid vague language
- Be explicit about use cases

### If Progressive Disclosure <12:
- Split into tiers
- Move details to references/
- Keep Tier 2 <500 lines
- Create references/ when needed

## Quality Grades

| Grade | Score Range | Description | Production Ready |
|-------|-------------|-------------|------------------|
| **A** | 144-160 | Exemplary skill | Yes |
| **B** | 128-143 | Good skill | Yes |
| **C** | 112-127 | Adequate skill | No (needs work) |
| **D** | 96-111 | Poor skill | No (major issues) |
| **F** | 0-95 | Failing skill | No (critical errors) |

---

## Success Criteria

**Production Ready**: ≥128/160 (Grade B)

**Minimum Scores for Production**:
- Knowledge Delta: ≥16/20 (CRITICAL)
- Autonomy: ≥10/15
- Discoverability: ≥12/15
- Progressive Disclosure: ≥12/15
- Clarity: ≥12/15
- Completeness: ≥12/15
- Standards Compliance: ≥12/15
- Security: ≥8/10
- Performance: ≥8/10
- Maintainability: ≥8/10
- Innovation: ≥3/5

---

## Enhancement Priorities

**High Impact Improvements (+16-32 points)**:

| Improvement | Points Impact | Dimension |
|-------------|---------------|-----------|
| Fix description (What-When-Not) | +4 | Discoverability |
| Add concrete examples | +8 | Autonomy |
| Implement progressive disclosure | +4 | Progressive Disclosure |
| Remove generic content | +6 | Knowledge Delta |
| Add validation | +3 | Security |

**Quick Reference - What to prioritize first**:
1. **Knowledge Delta** (20 pts) - Remove all generic/tutorial content
2. **Autonomy** (15 pts) - Add examples, reduce questions
3. **Discoverability** (15 pts) - Fix description using What-When-Not
4. **Progressive Disclosure** (15 pts) - Ensure proper tier structure

**See also**:
- [autonomy-design.md](autonomy-design.md) - Improving autonomy scores
- [description-guidelines.md](description-guidelines.md) - What-When-Not framework
- [progressive-disclosure.md](progressive-disclosure.md) - Tier structure patterns
- [anti-patterns.md](anti-patterns.md) - Common quality issues

---

## Summary

**Quality is about**:
1. **Value**: Expert knowledge Claude can't get elsewhere
2. **Autonomy**: Completes tasks independently
3. **Clarity**: Easy to understand and apply
4. **Structure**: Well-organized and maintainable

**Target**: 8.0/10 (128/160) for production readiness
