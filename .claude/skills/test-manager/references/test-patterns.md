# Test Design Patterns and Principles

Detailed guidance for creating effective autonomous tests for .claude/ development.

## Core Principle: Test Real Conditions

**Tests should mirror actual production usage**, not artificial scenarios.

**Good test** (represents real condition):
```yaml
---
name: file-organizer
description: "Organize project files by type following conventions"
---

You are organizing a real project with mixed file types.

Execute autonomously:
1. Scan for all source files (*.js, *.ts, *.py, *.go)
2. Scan for test files (*.test.*, *.spec.*)
3. Scan for documentation (*.md, *.txt)
4. Report current organization state

## ORGANIZER_COMPLETE
```

**Bad test** (artificial condition):
```yaml
---
name: test-counter
description: "Test file counting"
---

Count the following specific files: file1.txt, file2.txt, file3.txt
```
→ Tests contrived scenarios, not real usage

## Test Design Checklist

Before creating a test, verify:

**Representative of Real Conditions**:
- [ ] Tests actual workflow, not contrived scenario
- [ ] Uses realistic data/fixtures (not "test1", "test2")
- [ ] Mirrors production environment structure
- [ ] Exercises real tool capabilities

**Autonomous Execution**:
- [ ] Skill can complete without user intervention
- [ ] Clear completion marker present
- [ ] No decision points that require user input
- [ ] Self-contained (no external dependencies)

**Appropriate Constraints**:
- [ ] Specifies WHAT to achieve, not HOW
- [ ] Provides context/purpose, not step-by-step
- [ ] Allows Claude's intelligence to work
- [ ] Includes examples for style-dependent tasks

## Sandbox Structure

```
tests/<test_name>/
├── .claude/
│   ├── skills/          # For skill tests
│   │   └── <skill>/SKILL.md
│   ├── agents/          # For subagent tests
│   │   └── <agent>.md
│   ├── commands/        # For command tests
│   │   └── <command>.md
│   ├── settings.json    # Configuration tests
│   └── .mcp.json        # MCP tests
└── test_fixtures/       # Realistic test data
```

## Autonomous Test Skill Pattern

### Template for Real-Condition Tests

```yaml
---
name: <realistic-test-name>
description: "Test <capability> in <real condition>. Use when: <trigger>. Not for: <boundaries>."
context: fork  # For isolation in most tests
---

## TEST_START

You are in a realistic <condition>. Your task is to <outcome>.

**Context**: <real-world scenario description>
**Resources available**: <tools, skills, agents>
**Expected output**: <specific format>

Execute autonomously and report findings.

## TEST_COMPLETE
```

### Degrees of Freedom in Test Design

**High Freedom** (Preferred for most tests):
- Provide scenario and let Claude decide approach
- "Analyze this codebase for security issues"
- Claude chooses what to check, how to report

**Medium Freedom** (When specific validation needed):
- Suggest structure with flexibility
- "Check for OWASP Top 10 vulnerabilities; adapt based on what you find"
- Claude can add/remove checks based on context

**Low Freedom** (Only for deterministic compliance):
- Specific checklist when outcome must be consistent
- "Verify these specific files exist: .env.example, README.md, LICENSE"
- Use sparingly - only when reproducibility matters

### Real Condition Examples

**File System Test** (not "test1.txt", "test2.txt"):
```yaml
---
name: project-file-scanner
description: "Scan real project for file organization patterns"
context: fork
---

## TEST_START

You are analyzing a real project's file organization.

**Scan for**:
- Source files in common locations (src/, lib/, app/)
- Test files (test/, tests/, *.test.*, *.spec.*)
- Configuration (*.config.*, *.env.*, settings.*)
- Documentation (README*, *.md, docs/)

**Report**:
- Organization pattern used
- Any misplaced files (sources in wrong locations)
- Recommendations for improvement

## TEST_COMPLETE
```

**vs** Artificial Test (AVOID):
```yaml
---
name: file-counter-bad
description: "Count files"
---

## TEST_START

Count these files:
1. test1.txt
2. test2.txt
3. test3.txt

## TEST_COMPLETE
```

### Prompt Patterns for Autonomous Execution

**Good prompts** (real conditions, autonomous):
- `"Audit this real project for security vulnerabilities"`
- `"Organize these actual project files by type"`
- `"Analyze this codebase's architecture patterns"`

**Bad prompts** (artificial, over-prescriptive):
- `"Test if skill can count to 5"` → Artificial scenario
- `"Step 1: Do X. Step 2: Do Y. Step 3: Do Z."` → Over-prescriptive
- `"Verify that exactly these 3 things exist"` → Too rigid

### When to Be Prescriptive

**Use Low Freedom (specific steps) when**:
- Testing critical compliance requirements
- Validating exact behavior matters
- Reproducibility is essential

**Example**:
```yaml
---
name: compliance-checker
description: "Verify required compliance files exist"
context: fork
---

## TEST_START

Verify these files exist (compliance requirement):
- [ ] LICENSE (MIT, Apache, or GPL)
- [ ] .env.example (environment template)
- [ ] SECURITY.md (security policy)
- [ ] CONTRIBUTING.md (contributor guide)

Report missing items with severity.

## TEST_COMPLETE
```

**Use High/Medium Freedom when**:
- Exploratory testing (code analysis, architecture review)
- Creative tasks (documentation generation, design)
- Complex decision-making (refactoring strategies)

## Test Anti-Patterns

**Anti-Pattern 1: Artificial Test Data**
```yaml
# BAD
---
name: file-counter
---
Count test1.txt, test2.txt, test3.txt
```
→ Tests contrived scenario, not real usage

**Fix**: Use real project structure
```yaml
# GOOD
---
name: project-scanner
---
Scan project for file organization patterns
```

**Anti-Pattern 2: Over-Prescriptive Steps**
```yaml
# BAD
---
name: workflow-test
---
Step 1: Read file.txt
Step 2: Count lines
Step 3: Report number
```
→ No room for Claude's intelligence

**Fix**: Provide outcome, let Claude decide approach
```yaml
# GOOD
---
name: code-analyzer
---
Analyze codebase for complexity patterns
Report: Average complexity, outliers, recommendations
```

**Anti-Pattern 3: Testing Trivial Capabilities**
```yaml
# BAD
---
name: hello-test
---
Say "hello, world"
```
→ Tests nothing meaningful

**Fix**: Test real capability in realistic context
```yaml
# GOOD
---
name: service-health-check
---
Check if services are running and report status
```
