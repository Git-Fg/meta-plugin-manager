# Refactoring Methodology

Step-by-step process for refining CLAUDE.md files.

---

## Phase 1: Audit

### Initial Assessment

```bash
# Count total lines
wc -l CLAUDE.md .claude/CLAUDE.md .claude/rules/*.md 2>/dev/null

# Find section headers
grep -E "^#{1,3} " CLAUDE.md | head -50

# Check for duplicate headers
grep -E "^##" CLAUDE.md | sort | uniq -c | sort -rn | head -10

# Find potential dead references
grep -oE '\[.*?\]\(.*?\)' CLAUDE.md | grep -v "http" | while read link; do
  file=$(echo "$link" | sed 's/.*(\(.*\))/\1/')
  [ ! -f "$file" ] && echo "Broken: $link"
done
```

### Checklist

- [ ] Total line count documented
- [ ] All sections identified
- [ ] Duplicate headers flagged
- [ ] Broken references found
- [ ] Outdated content marked
- [ ] Redundant explanations noted

---

## Phase 2: Categorize

### Where Content Belongs

| Content Type | Location | Example |
|--------------|----------|---------|
| Project overview | Root CLAUDE.md | Tech stack, purpose |
| Implementation details | .claude/CLAUDE.md | Complex patterns |
| Coding style | .claude/rules/coding-style.md | Indentation, naming |
| Security rules | .claude/rules/security.md | Auth, secrets |
| Testing patterns | .claude/rules/testing.md | Coverage, mocking |
| Path-specific | .claude/rules/{path}.md | API rules for src/api/ |
| Cross-platform | AGENTS.md | Universal agent guidance |

### Decision Tree

```
Is this content project-specific?
├─ NO → Remove (Claude knows)
└─ YES
   ├─ Is it path-specific?
   │  ├─ YES → .claude/rules/{topic}.md with paths: frontmatter
   │  └─ NO
   │     ├─ Is it reusable across projects?
   │     │  ├─ YES → ~/.claude/CLAUDE.md
   │     │  └─ NO → ./CLAUDE.md or .claude/CLAUDE.md
   └─ Size > 50 lines?
      ├─ YES → Split into @imported file
      └─ NO → Keep inline
```

---

## Phase 3: Apply Delta Standard

### The Filter Questions

For each section, answer:

1. **"Does Claude already know this?"**
   - YES → Remove entirely
   - NO → Continue

2. **"Is this generic best practice?"**
   - YES → Remove (e.g., "write clean code")
   - NO → Continue

3. **"Does this justify its token cost?"**
   - 1 line of value / 10 lines of text → Condense
   - 1 line of value / 1 line of text → Keep

4. **"Can this be a bullet instead of paragraph?"**
   - YES → Convert to bullet
   - NO → Keep paragraph

### Before → After Transformations

**Generic explanation → Removed**:
```diff
- ## Error Handling
- Error handling is an important aspect of software development. Proper
- error handling helps prevent crashes and provides better user experience.
- In JavaScript, we use try-catch blocks to handle errors. The try block
- contains code that might throw an error, and the catch block handles it.
+ (entirely removed - Claude knows what error handling is)
```

**Verbose tutorial → Concise rule**:
```diff
- ## Database Queries
- When working with our database, you'll want to use Prisma as the ORM.
- Prisma is a modern database toolkit that makes database access easy.
- To create a query, you first import the prisma client, then you can
- use methods like findMany(), create(), update(), and delete() to
- interact with the database.
+ ## Database
+ Use Prisma ORM. For bulk operations, use `prisma.$transaction()`.
+ Never use raw SQL in application code.
```

**Redundant context → Essential only**:
```diff
- ## Authentication
- Authentication is how we verify user identity. Our app uses JWT tokens
- for authentication. JWT (JSON Web Tokens) are a compact, URL-safe means
- of representing claims to be transferred between two parties.
- 
- When a user logs in, we generate a JWT token that contains their user ID.
- This token is sent with every subsequent request in the Authorization header.
- The token expires after 1 hour for security reasons.
+ ## Auth
+ JWT with 1h expiry. User ID in payload. Stored in httpOnly cookie.
+ Refresh token rotation on each use.
```

---

## Phase 4: Extract to Modules

### Creating Rule Files

For reusable content, create modular files:

```markdown
# .claude/rules/typescript.md

- Strict mode enabled
- No `any` types (use `unknown` + type guards)
- Prefer `satisfies` over `as` for type assertions
- Use discriminated unions for state machines
```

### Adding Path Specificity

```markdown
# .claude/rules/api.md

---
paths:
  - "src/api/**/*.ts"
  - "src/routes/**/*.ts"
---

- All handlers must validate input with zod
- Use `ApiResponse<T>` wrapper for all returns
- Log all errors to observability stack
```

### Updating CLAUDE.md with Imports

```markdown
# CLAUDE.md

## Project: MyApp

## Standards
@.claude/rules/typescript.md
@.claude/rules/api.md
@.claude/rules/testing.md

## Project-Specific Context
[Only content that doesn't fit in rules]
```

---

## Phase 5: Validate

### Completeness Check

```bash
# Verify all original topics still exist
diff <(grep -E "^##" CLAUDE.md.backup | sort) <(grep -E "^##" CLAUDE.md | sort)

# Check @imports resolve
grep -oE "@[^ ]+" CLAUDE.md | while read import; do
  file=$(echo "$import" | sed 's/@//')
  [ ! -f "$file" ] && echo "Missing: $import"
done
```

### Information Loss Test

For each removed section, verify:
- [ ] The information was truly generic
- [ ] No project-specific details were lost
- [ ] No critical warnings were removed
- [ ] No decision context was lost

### Regression Test

After refactoring, test with prompts that previously worked:
- [ ] "How do I add a new API endpoint?" → Still answers correctly
- [ ] "What's the testing strategy?" → Still answers correctly
- [ ] "What auth system do we use?" → Still answers correctly

---

## Phase 6: Iterate

### Schedule Regular Audits

| Trigger | Action |
|---------|--------|
| Lines > 500 | Consider modularization |
| New feature added | Update relevant sections |
| Quarterly | Full audit for staleness |
| After major refactor | Verify all references valid |

### Version Notes

Consider adding version/date to sections that change:

```markdown
## Auth System (updated 2026-01)
[Current auth documentation]
```

---

## Quick Reference

### Commands

```bash
# Line count overview
wc -l CLAUDE.md .claude/**/*.md 2>/dev/null | sort -n

# Find TODO/FIXME
grep -rn "TODO\|FIXME" CLAUDE.md .claude/

# Validate links
grep -oE '\(file://[^)]+\)' CLAUDE.md | while read f; do
  path=$(echo "$f" | sed 's/(file:\/\/\(.*\))/\1/')
  [ ! -e "$path" ] && echo "Dead: $path"
done
```

### Metrics to Track

| Metric | Target | Action |
|--------|--------|--------|
| Total lines | < 300 | Modularize if exceeded |
| Avg section length | < 20 lines | Condense verbose |
| Broken refs | 0 | Fix immediately |
| Generic content | 0 | Remove in audit |
