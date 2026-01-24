# CLAUDE.md Best Practices

Comprehensive guide for organizing and optimizing memory files.

---

## Memory Hierarchy

### Tier System

| Tier | Location | Scope | Priority |
|------|----------|-------|----------|
| Enterprise | `/Library/Application Support/ClaudeCode/policies/` | Organization-wide | Highest |
| Project | `./CLAUDE.md` or `./.claude/CLAUDE.md` | Per repository | Medium |
| User | `~/.claude/CLAUDE.md` | Personal defaults | Lowest |

**Resolution**: Later tiers override earlier ones. Enterprise policies take precedence.

### Which File to Use

- **Root `CLAUDE.md`**: Visible to humans, quick reference, project overview
- **`.claude/CLAUDE.md`**: More structured, longer content, implementation details
- **`.claude/rules/*.md`**: Modular, reusable, path-specific rules

---

## Import System

Use `@` syntax for modular organization:

```markdown
# CLAUDE.md (main file)

# Architecture
@docs/architecture.md

# Coding Standards
@docs/typescript-conventions.md
@docs/react-patterns.md
```

**Rules**:
- Paths are relative to the importing file
- Imported files inherit the scope of the parent
- Circular imports are ignored

---

## Recommended Structure

### CLAUDE.md Template

```markdown
## Project Overview
[1-2 sentences: what it does, tech stack]

## Critical Rules

### Code Organization
- Many small files over few large files
- 200-400 lines typical, 800 max per file
- Organize by feature/domain, not by type

### Coding Style
- [Project-specific conventions]
- [Non-obvious patterns and reasons]

### Testing
- [Required coverage, test patterns]
- [Integration vs unit test split]

### Security
- [Sensitive paths, auth patterns]
- [What NOT to expose]

## Key Patterns
- [Pattern 1]: When to use, how to apply
- [Pattern 2]: When to use, how to apply

## Available Commands
- `npm run dev`: Start development server
- `npm test`: Run test suite

## References
- [Architecture](docs/architecture.md)
- [API Docs](docs/api.md)
```

---

## .claude/rules/ Patterns

### Basic Rule File

```markdown
# Coding Style Rules

- Use 2-space indentation
- Prefer const over let
- No default exports except for React components
```

### Path-Specific Rules

Add YAML frontmatter to apply rules only to matching paths:

```markdown
---
paths:
  - "src/api/**/*.ts"
---
# API Development Rules

- All endpoints must include input validation
- Use the standard error response format
- Include OpenAPI documentation comments
```

### Glob Patterns

```markdown
---
paths:
  - "**/*.test.ts"
  - "**/*.spec.ts"
---
# Testing Rules

- Every test file must have at least 3 test cases
- Use descriptive test names: "should [action] when [condition]"
```

### Directory Organization

```
.claude/rules/
├── coding-style.md      # General style rules
├── security.md          # Security-sensitive paths
├── testing.md           # Test file conventions
├── api/                  # API-specific rules
│   ├── rest.md
│   └── graphql.md
└── components/           # Frontend rules
    ├── react.md
    └── styling.md
```

### Shared Rules with Symlinks

```bash
# Share enterprise rules across projects
ln -s ~/.claude/enterprise-rules.md .claude/rules/enterprise.md
```

---

## Context Engineering 2026

### Attention Budget

LLMs have finite "attention budgets." As context grows, performance decreases (context rot). Effective memory files:

- **Minimize tokens** while maximizing signal
- **Front-load** critical information
- **Use structure** (headers, bullets) for scanability
- **Avoid repetition** across files

### Context Rot Prevention

| Problem | Solution |
|---------|----------|
| Growing context | Summarize, don't append |
| Stale instructions | Regular audits, timestamp sections |
| Redundant content | Deduplicate, use @imports |
| Generic explanations | Apply Delta Standard |

### Signal-to-Noise Optimization

**High Signal**:
- "NEVER use raw SQL queries in controllers"
- "All API errors must use ErrorResponse type"
- Decision trees for complex choices

**Low Signal** (remove):
- "Clean code is important"
- "Always write tests"
- Generic best practices

---

## Long-Horizon Techniques

### Compaction

Periodically summarize accumulated context:

```markdown
## Accumulated Context (v3)
- Auth system uses JWT with 1h expiry
- Database: PostgreSQL with Prisma ORM
- Deploy: Vercel with preview branches
```

### Structured Note-Taking

For complex multi-step tasks, use external notes:

```markdown
## NOTES.md (persistent memory)

### Current State
- Completed: Auth, User profiles
- In Progress: Payment integration
- Blocked: Awaiting API keys

### Key Decisions
- Chose Stripe over PayPal (better DX)
- Using webhooks, not polling
```

### Sub-Agent Context Isolation

For noisy operations, use `context: fork`:

```yaml
---
context: fork
agent: analysis-worker
---
```

This runs in isolated context, returns clean summary.

---

## AGENTS.md Compatibility

AGENTS.md is a vendor-neutral standard for AI coding agents.

### When to Use Both

| Standard | Use For |
|----------|---------|
| CLAUDE.md | Claude-specific memory, @imports, enterprise policy |
| AGENTS.md | Universal agent guidance, cross-platform teams |

### Compatibility Strategy

1. **Maintain both** for maximum compatibility
2. **Cross-reference** common content
3. **AGENTS.md** for universal rules
4. **CLAUDE.md** for Claude-specific optimizations

### Symlink Pattern

```bash
# Keep both in sync
ln -s CLAUDE.md AGENTS.md
# OR create minimal AGENTS.md that @imports CLAUDE.md content
```

---

## Anti-Patterns to Avoid

| Anti-Pattern | Why Bad | Fix |
|--------------|---------|-----|
| Kitchen Sink | Too much irrelevant context | Apply Delta Standard |
| Stale References | Links to deleted files | Regular audits |
| Instruction Drift | Outdated guidance | Timestamp sections |
| Duplicate Content | Wastes tokens | Use @imports |
| Generic Tutorials | Claude already knows | Remove completely |
| Verbose Explanations | Context rot | Condense to bullets |
