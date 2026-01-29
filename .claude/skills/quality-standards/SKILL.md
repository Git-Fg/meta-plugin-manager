---
name: quality-standards
description: "Verify completion with evidence using 6-phase gates and three-way audits. Use when claiming task completion, committing code, or validating components. Includes gate criteria, audit protocols, and evidence requirements. Not for skipping verification, assuming correctness, or bypassing quality gates."
auto_load_mapping:
  - If path contains ".mcp.json" -> load mcp-development
  - If path contains ".claude/skills" -> load invocable-development
  - If path contains ".claude/agents" -> load agent-development
  - If path contains ".claude/commands" -> load invocable-development
  - If path contains "SKILL.md" -> load invocable-development
---

<mission_control>
<objective>Guide verification toward evidence-based completion claims through systematic quality gates and three-way audits</objective>
<success_criteria>All claims backed by fresh verification output; all gates pass sequentially</success_criteria>
</mission_control>

# Quality Standards

**Skill Location**: This file

## Quick Start

**Quick validation:** `/verify --quick` → BUILD → TYPE → LINT → TEST → DIFF

**Security audit:** `/verify --security` → Security scan + vulnerability check

**Full PR review:** `/verify --code-review` → Three-way audit (Request vs Delivery vs Standards)

**Complete audit:** `/verify` → 6-phase gate + audits + portability check

**Why:** Evidence-based verification prevents false completion claims—every gate must pass sequentially.

### Component Type?

1. **MCP server (.mcp.json)** → Auto-loads mcp-development
2. **Skill (SKILL.md)** → Auto-loads invocable-development
3. **Agent (.claude/agents)** → Auto-loads agent-development
4. **Command (.claude/commands)** → Auto-loads invocable-development

## Navigation

| If you need...        | Read...                                      |
| :-------------------- | :------------------------------------------- |
| Quick validation      | ## Quick Start                               |
| Security audit        | ## Quick Start                               |
| Full PR review        | ## Quick Start                               |
| Complete audit        | ## Quick Start                               |
| 6-phase gate details  | ## Implementation Patterns                   |
| Evidence requirements | ## Implementation Patterns                   |
| Component validation  | `references/workflow_component-checklist.md` |

## System Requirements

- **Gate sequence**: BUILD → TYPE → LINT → TEST → SECURITY → DIFF
- **Evidence requirement**: Every claim requires fresh verification output
- **Three-way audit**: Request vs Delivery vs Standards comparison
- **Portability check**: Zero external `.claude/rules` references

## Operational Patterns

This skill follows these behavioral patterns:

- **Tracking**: Maintain a visible task list for quality verification
- **Verification**: Verify code quality using diagnostics and linting
- **Navigation**: Navigate code structure for deep verification

Use native tools to fulfill these patterns. Trust the System Prompt to select the correct implementation.

## Implementation Patterns

### Pattern: 6-Phase Gate System

| Phase | Gate     | What It Checks       | Typical Command |
| ----- | -------- | -------------------- | --------------- |
| 1     | BUILD    | Compilation succeeds | `npm run build` |
| 2     | TYPE     | Type safety          | `tsc --noEmit`  |
| 3     | LINT     | Code style           | `eslint .`      |
| 4     | TEST     | Tests pass           | `npm test`      |
| 5     | SECURITY | No secrets/vulns     | `npm audit`     |
| 6     | DIFF     | Intentional changes  | `git diff`      |

### Pattern: Evidence-Based Verification

| Instead of...           | Use This Evidence...                           |
| ----------------------- | ---------------------------------------------- |
| "I fixed the bug"       | `Test auth_login_test.ts passed (Exit Code 0)` |
| "The build should work" | `Build output: ✅ Built in 2.4s`                |
| "TypeScript is happy"   | `tsc --noEmit: 0 errors, 0 warnings`           |
| "Tests pass"            | `Test suite: 47 passed, 0 failed`              |
| "Linting is clean"      | `ESLint: no errors in src/utils.ts`            |

### Pattern: Three-Way Review

| Dimension     | Question                              |
| ------------- | ------------------------------------- |
| **Request**   | What did the user explicitly ask for? |
| **Delivery**  | What was actually implemented?        |
| **Standards** | What do quality standards specify?    |

### Pattern: Component Validation

| Check                  | How to Verify                             |
| ---------------------- | ----------------------------------------- |
| Structure              | Read frontmatter, confirm valid YAML      |
| Progressive Disclosure | Confirm Tier 1 + Tier 2 + Tier 3 exists   |
| Portability            | Confirm zero external references          |
| Content                | Confirm trigger phrases, imperative voice |

## Troubleshooting

| Issue                 | Symptom                                  | Solution                                   |
| --------------------- | ---------------------------------------- | ------------------------------------------ |
| Gates failing         | BUILD/TYPE/LINT/TEST/SECURITY/DIFF fails | Fix issues before claiming completion      |
| No evidence           | Claims without verification output       | Run commands, capture output               |
| Missing audits        | Three-way review not performed           | Compare Request vs Delivery vs Standards   |
| Portability violation | References `.claude/rules`               | Remove external dependencies               |
| Component not loading | Missing auto_load_mapping                | Add path mapping to frontmatter            |
| False completion      | "Looks complete" without verification    | Follow evidence-based verification pattern |

## The Verification Standard

Replace assertions with evidence. The difference between claiming and proving:

| Instead of...           | Use This Evidence...                           |
| ----------------------- | ---------------------------------------------- |
| "I fixed the bug"       | `Test auth_login_test.ts passed (Exit Code 0)` |
| "The build should work" | `Build output: ✅ Built in 2.4s`                |
| "TypeScript is happy"   | `tsc --noEmit: 0 errors, 0 warnings`           |
| "Tests pass"            | `Test suite: 47 passed, 0 failed`              |
| "Linting is clean"      | `ESLint: no errors in src/utils.ts`            |

**The pattern**: Name the command, report the output, claim the result.

## The 6-Phase Gate System

| Phase | Gate     | What It Checks              | Typical Command |
| ----- | -------- | --------------------------- | --------------- |
| 1     | BUILD    | Compilation succeeds        | `npm run build` |
| 2     | TYPE     | Type safety                 | `tsc --noEmit`  |
| 3     | LINT     | Code style                  | `eslint .`      |
| 4     | TEST     | Tests pass                  | `npm test`      |
| 5     | SECURITY | No secrets, vulnerabilities | `npm audit`     |
| 6     | DIFF     | Intentional changes         | `git diff`      |

Gates pass in sequence. If one fails, subsequent gates do not run.

## The Verification Workflow

Verification follows a simple pattern:

1. **Identify**: What command proves this claim?
2. **Execute**: Run the command fully
3. **Read**: Examine the complete output
4. **Claim**: State the result with the evidence

Example:

```
❌ Assertion: "I fixed the bug."
✅ Evidence: "npm test passed (see test_results.log: 47/47 passed)"
```

## The Three-Way Review

Before claiming completion, compare three dimensions:

| Dimension     | Question                              |
| ------------- | ------------------------------------- |
| **Request**   | What did the user explicitly ask for? |
| **Delivery**  | What was actually implemented?        |
| **Standards** | What do quality standards specify?    |

Identify gaps between these. The goal is alignment, not judgment.

## Component Validation

Use these checks to validate components:

| Check                  | How to Verify                                    |
| ---------------------- | ------------------------------------------------ |
| Structure              | Read frontmatter, confirm valid YAML             |
| Progressive Disclosure | Confirm Tier 1 + Tier 2 + Tier 3 exists          |
| Portability            | Confirm zero external `.claude/rules` references |
| Content                | Confirm trigger phrases, imperative voice        |

## Examples of Good Verification

**Build Verification**:

```
Bash: npm run build
→ Exit code: 0
→ Claim: Build successful
```

**Type Verification**:

```
Bash: npx tsc --noEmit
→ Output: Found 0 errors, 0 warnings
→ Claim: Type-safe
```

**Test Verification**:

```
Bash: npm test
→ Output: Test Suites: 12 passed, 12 total
→ Claim: All tests passing
```

## When Verification Applies

Use this skill when:

- Claiming task completion
- Committing or creating PRs
- Validating component structure
- Auditing code quality
- Before moving to new tasks

## References

| For...                        | See...                              |
| ----------------------------- | ----------------------------------- |
| Gate commands by project type | `references/gates.md`               |
| Three-way audit patterns      | `references/audit-patterns.md`      |
| Component structure checks    | `references/component-checklist.md` |

## Automated Validation (Tool Use Pattern)

Use the validation script for deterministic gate checking:

```bash
# Run all gates
node scripts/validate-gates.js

# Check specific path
node scripts/validate-gates.js /path/to/component
```

**What the script validates:**

| Phase       | Gate            | What It Checks                 |
| ----------- | --------------- | ------------------------------ |
| BUILD       | Compilation     | npm run build succeeds         |
| TYPE        | Type safety     | tsc --noEmit passes            |
| LINT        | Code style      | ESLint passes                  |
| TEST        | Tests           | npm test passes                |
| SECURITY    | Vulnerabilities | npm audit shows no high vulns  |
| DIFF        | Changes         | Git status shows changes       |
| PORTABILITY | Self-contained  | No external .claude/rules refs |

---

## Genetic Code

This component carries essential Seed System principles for context: fork isolation:

<critical_constraint>
All components MUST be self-contained (zero .claude/rules dependency)
All components MUST use What-When-Not-Includes format in third person
Progressive disclosure - core in SKILL.md, details in references/
Use XML for control (mission_control, critical_constraint), Markdown for data
</critical_constraint>

**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows

**Recognition Questions**:

- "Would Claude know this without being told?" → Skip (zero delta)
- "Can this work standalone?" → Fix if no (non-self-sufficient)
- "Did I read the actual file, or just see it in grep?" → Verify before claiming

---

## The Iron Law

<absolute_constraint>
**NO CLAIMS WITHOUT EVIDENCE**

Every assertion requires fresh verification output. Every gate must pass sequentially.

If you haven't run the commands, you haven't verified. If you haven't verified, you haven't completed.

This is not optional. This is how quality is proven.
</absolute_constraint>

### The Evidence Standard

| Instead of...           | Use This Evidence...                           |
| ----------------------- | ---------------------------------------------- |
| "I fixed the bug"       | `Test auth_login_test.ts passed (Exit Code 0)` |
| "The build should work" | `Build output: ✅ Built in 2.4s`                |
| "TypeScript is happy"   | `tsc --noEmit: 0 errors, 0 warnings`           |
| "Tests pass"            | `Test suite: 47 passed, 0 failed`              |
| "Linting is clean"      | `ESLint: no errors in src/utils.ts`            |

**Violating the letter of this standard is violating the spirit of verification.**

---

## Common Rationalizations

| Excuse                                  | Reality                                                |
| --------------------------------------- | ------------------------------------------------------ |
| "Looks complete to me"                  | Completeness requires evidence, not intuition.         |
| "Tests pass locally, should work in CI" | CI environment differs. Verify there too.              |
| "The linter only shows warnings"        | Warnings become errors. Fix them.                      |
| "Security audit takes too long"         | Security vulnerabilities take longer to fix.           |
| "No one will review this anyway"        | You review your own work. Standards apply to yourself. |
| "I can skip one gate just this once"    | Once becomes always. Standards don't bend.             |

**If you catch yourself thinking these, STOP. Run the complete verification.**

---

<critical_constraint>
Gates pass in sequence—stop on first failure
Each claim requires fresh verification output
Compare Request vs Delivery vs Standards in audits
Show evidence (output) for every verification
</critical_constraint>
