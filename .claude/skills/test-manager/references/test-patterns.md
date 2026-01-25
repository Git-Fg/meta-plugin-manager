# Test Design Patterns

Create effective autonomous tests for .claude/ development.

## Core Principle: Test Real Conditions

**Tests mirror actual production usage, not artificial scenarios.**

**Good test** (real condition):
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
```

**Bad test** (artificial condition):
```yaml
---
name: test-counter
description: "Test file counting"
---

Count the following specific files: file1.txt, file2.txt, file3.txt
```

**Why good**: Tests real-world file organization.
**Why bad**: Tests contrived scenario, not real usage.

## Test Design Recognition

**Recognition questions:**

| Category | Recognition Question | Action |
|----------|---------------------|--------|
| **Real Conditions** | "Could this happen in production?" | If no, redesign test |
| **Realistic Data** | "Am I using 'test1.txt' or real filenames?" | Replace artificial data |
| **Autonomous Execution** | "Will this complete without user input?" | Add completion markers |
| **Appropriate Constraints** | "Does this specify WHAT or HOW?" | Change HOW → WHAT |

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

### Template

```yaml
---
name: <realistic-test-name>
description: "Test <capability> in <real condition>. Use when: <trigger>. Not for: <boundaries>."
context: fork  # For isolation in most tests
---

## TEST_START

You are in a realistic <condition>. Your task is to <outcome>.

**Context**: <real-world scenario>
**Resources available**: <tools, skills, agents>
**Expected output**: <specific format>

Execute autonomously and report findings.
```

## Degrees of Freedom

**High Freedom** (preferred):
- Provide scenario, let Claude decide approach
- Example: "Analyze this codebase for security issues"
- Claude chooses what to check, how to report

**Medium Freedom** (specific validation):
- Suggest structure with flexibility
- Example: "Check for OWASP Top 10 vulnerabilities; adapt based on context"
- Claude can customize checks

**Low Freedom** (deterministic compliance):
- Specific checklist for consistent outcomes
- Example: "Verify these files exist: .env.example, README.md, LICENSE"
- Use sparingly

**Recognition**: "What breaks if Claude chooses differently?" → More breaks = lower freedom.

## Real Condition Examples

**File System Test** (realistic):
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
- Any misplaced files
- Recommendations for improvement
```

**vs Artificial Test** (avoid):
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
```

**Why avoid**: Tests nothing meaningful about real-world organization.

## Prompt Patterns

**Good prompts** (autonomous):
- "Audit this real project for security vulnerabilities"
- "Organize these actual project files by type"
- "Analyze this codebase's architecture patterns"

**Bad prompts** (artificial):
- "Test if skill can count to 5" → Artificial scenario
- "Step 1: Do X. Step 2: Do Y. Step 3: Do Z." → Over-prescriptive
- "Verify exactly these 3 things exist" → Too rigid

**Recognition**: "Would Claude need to think or just recognize?" → Structure for recognition.

## Prescriptive vs Flexible

**Use Low Freedom** (specific steps):
- Critical compliance requirements
- Exact behavior validation
- Reproducibility essential

**Example**:
```yaml
---
name: compliance-checker
description: "Verify required compliance files exist"
context: fork
---

## TEST_START

Verify these files exist (compliance):
- [ ] LICENSE (MIT, Apache, or GPL)
- [ ] .env.example (template)
- [ ] SECURITY.md (policy)
- [ ] CONTRIBUTING.md (guide)

Report missing items with severity.
```

**Use High/Medium Freedom**:
- Exploratory testing
- Creative tasks
- Complex decision-making

## Anti-Pattern Recognition

### Anti-Pattern 1: Artificial Data

❌ **Bad**:
```yaml
---
name: file-counter
---
Count test1.txt, test2.txt, test3.txt
```

✅ **Good**:
```yaml
---
name: project-scanner
---
Scan project for file organization patterns
```

**Recognition**: "Am I testing real capability or contrived scenario?" → Choose real capability.

### Anti-Pattern 2: Over-Prescriptive Steps

❌ **Bad**:
```yaml
---
name: workflow-test
---
Step 1: Read file.txt
Step 2: Count lines
Step 3: Report number
```

✅ **Good**:
```yaml
---
name: code-analyzer
---
Analyze codebase for complexity patterns
Report: Average complexity, outliers, recommendations
```

**Recognition**: "Does this allow Claude's intelligence?" → Remove prescriptive steps.

### Anti-Pattern 3: Trivial Capabilities

❌ **Bad**:
```yaml
---
name: hello-test
---
Say "hello, world"
```

✅ **Good**:
```yaml
---
name: service-health-check
---
Check if services are running and report status
```

**Recognition**: "Does this test meaningful capability?" → If no, redesign.
