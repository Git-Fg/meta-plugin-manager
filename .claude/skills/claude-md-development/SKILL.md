---
name: claude-md-development
description: This skill should be used when the user wants to "create a CLAUDE.md", "write project rules", "set up .claude/rules", "improve CLAUDE.md", "organize project memory", or needs guidance on structuring CLAUDE.md, creating .claude/rules files, progressive disclosure for project memory, or Claude Code project memory best practices.
---

# CLAUDE.md and Rules Development Guide

**Purpose**: Help you create effective project memory (CLAUDE.md) and modular rules (.claude/rules/) that onboard Claude to your codebase

---

## What CLAUDE.md and Rules Are

CLAUDE.md and .claude/rules/ constitute project-local memory that automatically loads into Claude's context. They serve different but complementary purposes.

**CLAUDE.md** (./CLAUDE.md or ./.claude/CLAUDE.md):
- Small, "always-on" project onboarding document
- Answers: WHAT is this project, WHY does it exist, HOW do I work in it
- Universal scope - applies to all files in the project

**.claude/rules/*.md** (modular, topic-specific):
- Fine-grained instructions for specific domains or file paths
- Examples: testing.md, security.md, api-design.md
- Can be path-scoped to specific file patterns

**Key point**: CLAUDE.md is the "hub" (high-level overview + pointers), .claude/rules/ is the "spokes" (per-topic, per-language instructions).

**Question**: Is this information universal for the project? Keep in CLAUDE.md. Is it topic-specific or path-specific? Move to .claude/rules/.

---

## Philosophy Foundation

Project memory follows these core principles for effectiveness.

### Progressive Disclosure for Project Memory

**CLAUDE.md stays concise (40-100 "real" lines)**:
- Aim for 40-100 lines beyond whitespace and tables for most projects
- Very large ecosystems can be longer but must remain structured
- Use pointers to docs or file:line references instead of copying code
- Tell Claude WHERE to find critical info, not include it all

**.claude/rules/ use focused topics**:
- One topic per file (testing.md, api-development.md, security-requirements.md)
- Use descriptive filenames that clearly signal coverage
- Optionally scope with paths frontmatter when truly path-specific
- Organize with subdirectories to mirror code structure (frontend/, backend/)

**Recognition**: "Is this information needed by most users of this project?" Keep in CLAUDE.md. "Is this for specific scenarios or file types?" Move to .claude/rules/.

### The Delta Standard for Project Memory

> Good project memory = Project-specific knowledge − What Claude Already Knows

Include in CLAUDE.md/rules (Positive Delta):
- Project-specific architecture decisions
- Domain expertise not in general training
- Tech stack and tooling choices (bun vs node, pnpm vs npm)
- Non-obvious bug workarounds
- Team-specific conventions
- Local environment quirks
- Invariants Claude must never violate

Exclude from CLAUDE.md/rules (Zero/Negative Delta):
- General programming concepts
- Standard library documentation
- Common patterns Claude already knows
- Generic tutorials
- Obvious best practices
- Linter-style rules (use real tools instead)

**Recognition**: For each piece of content, ask "Would Claude know this without being told?" If yes, delete it.

### Self-Containment for Project Memory

**CLAUDE.md and .claude/rules must be version-controlled code, not static text.**

**For CLAUDE.md**:
- Keep it short and universal
- Don't duplicate content from README or docs
- Don't make it a giant style guide
- Use @imports and file:line references instead of copying code

**For .claude/rules/**:
- Each rule file should be self-contained for its topic
- Don't reference other rule files for critical information
- Include examples directly in the rule file
- Use symlinks for shared rules across repos (with caution)

**Recognition**: "Does this file reference outside itself for critical info?" If yes, include that information directly.

**Portability test**: Would this project memory work if moved to a fresh repo? If not, it has external dependencies.

---

## What Good Project Memory Has

### 1. CLAUDE.md Structure

**Good CLAUDE.md answers these questions**:
- **WHAT**: What is this project? What are the main pieces and how do they fit together?
- **WHY**: Purpose and function of each part
- **HOW**: Tooling (bun vs node), how to verify changes, test/lint/typecheck commands

**Good sections for project-local CLAUDE.md**:

```markdown
# CLAUDE.md

## Project overview (1-3 paragraphs)
- What the system does
- Main technologies and platforms
- Any invariants Claude must never violate

## Project map (WHAT)
- Short structural overview: apps/, packages/, services/, docs/
- For monorepos: explicitly explain which apps/packages exist

## How to work in this repo (HOW)
- Commands: Build, Test, Lint/typecheck
- Verification: How to know if something works

## Rules & skills overview
- Table summarizing rules and skills
- Rule name | Scope | Description

## Pointers to deeper docs
- Use @imports and regular links
- "See docs/testing.md for test organization"

## Personal overrides (optional)
- Mention CLAUDE.local.md and @~/.claude/... patterns
```

**Question**: Is CLAUDE.md approaching 150+ lines? Move content to docs or .claude/rules/.

### 2. .claude/rules Structure

**Good rule files are focused and self-contained**:

```markdown
---
paths:
  - "src/api/**/*.ts"
---
# API Development Rules

## Handler requirements
- All endpoint handlers must validate input
- Return responses using standard format
- Include OpenAPI documentation

## Error handling
- Use AppError from lib/AppError.ts
- Never expose stack traces to clients
- Log structured errors

## Security
- Endpoints must check authentication/authorization
- For PII operations, consult SECURITY.md
```

**Common rule categories**:
- Testing: test organization, coverage, mocking strategies
- Security: OWASP Top 10, secret handling, input validation
- Code quality: Types and patterns, file-size limits
- API/backend: Error response format, versioning, documentation
- Workflows: Release steps, PR etiquette, how to propose changes
- Process/discipline: "Guardian" rules for quality gates

**Question**: Is this rule truly universal? If yes, consider moving to CLAUDE.md. Is it path-specific? Add paths frontmatter.

### 3. Path-Specific Rules

**Use paths frontmatter when the rule is truly path-specific**:

```yaml
---
paths:
  - "src/api/**/*.ts"
  - "src/**/*.{ts,tsx}"
  - "{src,lib}/**/*.ts"
---
```

**Good use cases for paths**:
- TypeScript patterns that only apply under src/ or for *.ts/*.tsx
- API rules only for src/api/**/*.ts
- Database migration rules only for migrations/**/*.sql

**Poor use cases for paths**:
- Universal preferences like "always write tests"
- General quality guidelines like "be conservative with refactors"

**Recognition**: "Does this rule apply to ALL files, or only specific patterns?" Use paths only when truly specific.

### 4. Imports and References

**CLAUDE.md can import other files using @path syntax**:

```markdown
## Project memory imports

- See @README for project overview
- Git workflow @docs/git-instructions.md
- Security policy @SECURITY.md
```

**Key benefits**:
- Keep CLAUDE.md short while pulling in context when needed
- Support relative paths (@docs/...) or absolute paths (@~/.claude/...)
- Enable progressive disclosure

**Recognition**: "Is this context critical for quality? Make the import clear. Can users skip it? Move to docs."

---

## How to Structure Project Memory

### CLAUDE.md Frontmatter and Structure

**CLAUDE.md doesn't require frontmatter** (it's automatically discovered), but you can organize it with clear sections:

```markdown
# CLAUDE.md

This file onboards Claude Code to this project.

## Project overview

[1-3 paragraphs describing the project]

## How to work in this repo

[Commands for build, test, lint, typecheck]

## Rules and skills

[Table summarizing .claude/rules/ and .claude/skills/]

## Important docs

[Pointers to deeper documentation]
```

**Key elements**:
- No frontmatter required (unlike skills/commands)
- Start with purpose statement
- Use tables for rules/skills overview
- Use @imports for referencing other files

### .claude/rules Frontmatter and Structure

**.claude/rules files use YAML frontmatter for path scoping**:

```yaml
---
paths:
  - "src/api/**/*.ts"
  - "src/**/*.{ts,tsx}"
---
# Rule Title

[Content]
```

**If no paths field**, the rule applies to all files.

**Paths support**:
- Glob patterns: **/*.ts, src/**/*, *.md
- Multiple patterns: src/**/*.{ts,tsx}
- Brace expansion: {src,lib}/**/*.ts

**Key elements**:
- paths: Array of glob patterns (optional)
- Clear topic-based filename
- Self-contained content for that topic

### Organization Options

**Subdirectories**:
- .claude/rules/frontend/, backend/, infra/
- All .md files discovered recursively
- Mirrors code structure for clarity

**Symlinks**:
- Symlink shared rules directories into multiple repos
- Symlink individual shared rule files
- Ensure every linked rule is universally applicable

**User-level vs project-level**:
- ~/.claude/rules/*.md: Personal preferences and workflows
- ./.claude/rules/*.md: Team-shared, project-specific
- Project rules override user rules where they conflict

**Recognition**: "Is this rule personal preference or team decision?" User rules for personal, project rules for team.

---

## Execution and Loading

### How Claude Loads Project Memory

**Loading order**:
1. Higher-level memories (managed policy, user, etc.) load first
2. Project memory (CLAUDE.md) and rules build on top
3. All .md files under ./.claude/rules/ load automatically
4. Rules with paths frontmatter apply only to matching files

**Lookup behavior**:
- Claude reads CLAUDE.md recursively up from cwd (stops at filesystem root)
- Nested CLAUDE.md under subtrees only used when reading those subtrees
- Each rule file loaded with same priority as .claude/CLAUDE.md

**Recognition**: "Does Claude need this information for EVERY file in the project?" If no, use paths frontmatter.

### When Project Memory Applies

**CLAUDE.md**: Always applies (project-level onboarding)

**.claude/rules**:
- Without paths: Always applies (universal conventions)
- With paths: Applies only when working with matching files

**Example**:
```yaml
# testing.md (no paths)
# Applies to all files

---
paths:
  - "src/api/**/*.ts"
---
# api-style.md
# Applies only when working with src/api/**/*.ts files
```

**Recognition**: "Is this convention truly universal, or specific to certain file types?"

---

## Common Mistakes

### Mistake 1: Auto-Generating CLAUDE.md

❌ Bad: Auto-generate CLAUDE.md and never revisit it
✅ Good: Treat CLAUDE.md as highest-leverage workflow point, craft each line carefully

**Why**: CLAUDE.md is the only thing that goes into every conversation by default. It deserves manual curation.

### Mistake 2: Using CLAUDE.md as Linter

❌ Bad: Encode style rules as prompt instructions
✅ Good: Use real linters/formatters, have Claude fix their output

**Why**: Tools are deterministic. Prompt instructions are unreliable for style enforcement.

### Mistake 3: Dumping Everything into CLAUDE.md

❌ Bad: Copy entire security manuals, coding standards, or command references
✅ Good: "See docs/testing.md for test organization" or "Run pnpm test"

**Why**: CLAUDE.md should say "how to find" critical info, not include it all.

### Mistake 4: Overusing Path-Specific Rules

❌ Bad: Add paths frontmatter "just in case"
✅ Good: Only add paths when rule is truly path-specific

**Why**: Universal preferences belong in global rules or CLAUDE.md, not path-scoped.

### Mistake 5: Duplicating Content

❌ Bad: Same concept in CLAUDE.md AND .claude/rules/
✅ Good: Single source of truth, cross-reference from other locations

**Why**: Content drift creates maintenance burden and inconsistency.

### Mistake 6: Ignoring the "May Not Be Relevant" Warning

❌ Bad: Include niche/one-off instructions in CLAUDE.md
✅ Good: Move non-universal stuff to docs or skills, keep short pointer in CLAUDE.md

**Why**: CLAUDE.md is wrapped in system reminder saying context "may or may not be relevant." Overly specific instructions get ignored.

---

## Best Practices

### Writing Style

**Use imperative but natural language**:
- "Run pnpm test to run unit tests"
- "See docs/testing.md for test organization strategies"
- "For PII operations, consult SECURITY.md"

**Be specific but brief**:
- "Use 2-space indentation in TS files" not "Format properly"
- "Run pnpm test" not "There are tests; figure out commands"

### Progressive Disclosure

**Prefer pointers over dumping**:
- "Test organization in docs/testing.md" (not entire test manual)
- "Security policies in SECURITY.md" (not every security rule)
- "Release process in docs/releases.md" (not entire release playbook)

**Recognition**: "Is this context needed for the standard 80% use case?" Keep in main. "Specific scenarios?" Reference docs.

### Verification and Validation

**Include verification criteria**:
- "Before marking work complete: run pnpm typecheck, pnpm lint, pnpm test"
- "For UI changes, manually test in dev and ensure no console errors"
- "Ensure test coverage remains above 80%"

**Recognition**: "How does Claude know if changes are correct?"

### Maintenance and Iteration

**Start minimal, grow by pain**:
- Begin with one-page CLAUDE.md and few essential rules
- When Claude repeatedly misunderstands, add short, specific rule
- When team frequently explains same thing, codify as rule or doc reference

**Prune aggressively**:
- Every 2-4 weeks, review CLAUDE.md and .claude/rules
- Remove outdated commands
- Remove rules now handled by tooling
- Split files that drifted into multiple topics

**Verify in real sessions**:
- Run typical Claude Code sessions
- Check whether Claude consistently references CLAUDE.md and .claude/rules
- Check whether it ignores critical instructions
- If ignored: ask if instruction is truly universal, move to docs/skills

**Recognition**: "When did we last review this? Is it still accurate?"

---

## Concrete Examples

### Example 1: Minimal CLAUDE.md for Node/TS Project

```markdown
# CLAUDE.md

This file onboards Claude Code to this project.

## Project overview

Monorepo with:
- packages/api – Express backend
- packages/web – React frontend
- packages/shared – shared TS types & utilities

Target: Node.js 20+; pnpm as package manager.

## How to work in this repo

Install: pnpm install
Development: pnpm dev (starts API and web dev servers)
Build: pnpm build
Tests: pnpm test (unit tests, Vitest)
Lint/typecheck: pnpm lint && pnpm typecheck

## Verification rules

Before marking work complete:
- Run pnpm typecheck and ensure no errors
- Run pnpm lint and fix any issues
- Run pnpm test and ensure unit tests pass
- For UI changes, manually test in dev and ensure no console errors

## Rules and skills

| Rule | Applies To | Description |
| testing.md | all files | How to write and organize tests |
| api-style.md | packages/api/**/*.ts | API handler patterns & errors |
| react-style.md | packages/web/**/*.tsx | React component conventions |
| security.md | all files | Secrets, auth, and data handling |

## Important docs

- Architecture: docs/architecture.md
- Security policy: SECURITY.md (always consult for auth & PII)
- API design: docs/api-design.md
- Releases: docs/releases.md
```

### Example 2: Topic-Focused Rule (testing.md)

```markdown
# Testing Rules

## Test organization

Unit tests:
- Co-located: src/module/example.test.ts
- Focus on single functions/classes

Integration tests:
- Under tests/integration/
- Use test databases and services

## Writing tests

Given-When-Then:
- Use three-act structure: setup, action, assertions

Naming:
- describe("feature name", ...)
- it("should do X when Y", ...)

## Coverage and style

- Maintain at least 80% coverage for new code
- Avoid external network calls in unit tests; use MSW mocks

## Running tests

- All tests: pnpm test
- Watch mode: pnpm test:watch
- E2E tests: pnpm test:e2e (Playwright)
```

### Example 3: Path-Specific Rule (api-style.md)

```yaml
---
paths:
  - "packages/api/**/*.ts"
---
# API Style Rules

## Handlers

All endpoint handlers must:
- Validate input with shared schema function (src/api/lib/validate.ts)
- Return responses using jsonSuccess, jsonError, or jsonValidationFailed
- Include OpenAPI comment above handler (example in src/api/users/list.ts)

## Errors

- Use AppError from src/api/lib/AppError.ts
- Never expose stack traces to clients
- Log structured errors with shared logger

## Security

- Endpoints must check authentication/authorization unless explicitly marked public
- For PII operations, consult SECURITY.md
```

### Example 4: Using Imports in CLAUDE.md

```markdown
# CLAUDE.md

## Project memory imports

- See @README for project overview
- Git workflow @docs/git-instructions.md
- Security policy @SECURITY.md

## Core instructions

Before proposing changes:
- Read @docs/design-principles.md for architectural guidelines
- Consult @SECURITY.md for security rules

Always run pnpm typecheck && pnpm lint && pnpm test before marking work done.

## Individual preferences (optional)

# Uncomment and personalize:
# - @~/.claude/my-workflow.md
```

### Example 5: CLAUDE.md Focused on Rules Index

```markdown
# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Rules and Skills Structure

- Rules (.claude/rules/): Automatically loaded based on file paths. Source of truth for project conventions.
- Skills (.claude/skills/): Manually invoked for specific integrations

## Available Rules

| Rule | Applies To | Description |
| pnpm-usage | all files | pnpm commands and troubleshooting |
| git-workflow | all files | Commit conventions and PR guidelines |
| typescript | **/*.ts | Types and TS patterns |
| react | **/*.tsx | React component conventions |
| testing | **/*.test.ts | Test organization and running |
| security | all files | Security and secrets handling |

## Frequently used commands

- Install: pnpm install
- Build: pnpm build
- Test: pnpm test
- Lint/typecheck: pnpm lint && pnpm typecheck

## Key docs

- Architecture: docs/architecture.md
- Security: SECURITY.md
- Release process: docs/releases.md
```

---

## Quality Checklist

A good CLAUDE.md:

- [ ] Answers WHAT (project structure), WHY (purpose), HOW (commands)
- [ ] Stays under 100-150 lines for most projects
- [ ] Uses tables for rules/skills overview
- [ ] Uses @imports and file:line references instead of copying code
- [ ] Doesn't duplicate README or generic tutorials
- [ ] Includes verification criteria (test, lint, typecheck)
- [ ] Provides pointers to deeper docs
- [ ] Reviewed and updated periodically

A good .claude/rules file:

- [ ] One topic per file with descriptive filename
- [ ] Self-contained (no external references for critical info)
- [ ] Uses paths frontmatter only when truly path-specific
- [ ] Includes examples directly in the file
- [ ] Focused and specific (not trying to cover everything)
- [ ] Universal applicability (no paths) or clear path scoping

**Self-check**: Could a fresh Claude instance work effectively with this project using only CLAUDE.md and .claude/rules?

---

## Summary

CLAUDE.md and .claude/rules are project-local memory that automatically load into Claude's context.

**CLAUDE.md**:
- Small, "always-on" project onboarding
- Answers WHAT, WHY, minimal HOW
- Uses progressive disclosure (pointers to docs)

**.claude/rules/**:
- Modular, topic-specific instructions
- Optional path scoping for file-specific rules
- Self-contained rule files

**Core principles**:
- Progressive disclosure over completeness
- Project-specific knowledge over generic tutorials
- Real tools over prompt-encoded linters
- Version-controlled code over static text
- Pointers over dumping

**Recognition**: Is this information universal? CLAUDE.md. Topic-specific? .claude/rules. Path-specific? Add paths frontmatter.

**Question**: Is your project memory clear enough that Claude could onboard and work effectively with this codebase?

---

**Final tip**: The best project memory is like a good onboarding manual - it answers the right questions at the right time, and points to deeper resources when needed. Focus on that.
