# Anti-Patterns Catalog

Common mistakes to avoid when building skills, with recognition questions and fixes.

---

## Architectural Anti-Patterns

### Anti-Pattern 1: Command Wrapper

**Problem**: Skill exists only to invoke a single command

**Recognition**: "Could the description alone suffice?"

**Example**:
```yaml
---
name: run-tests
description: "Run the test suite"
---

# Run Tests
Just run npm test.
```

**Problem**: Skill adds no value over running command directly

**Fix**: Remove the skill - let Claude run commands directly

---

### Anti-Pattern 2: Non-Self-Sufficient Skills

**Problem**: Skill requires constant user hand-holding or external orchestration

**Recognition**: "Can this work standalone?"

**Symptoms**:
- Asks many questions during execution
- Requires external tools/skills to function
- Lacks clear completion criteria

**Example**:
```yaml
---
name: api-helper
description: "Helps with API development"
---

# API Helper

Refer to docs/api-guide.md for everything.
```

**Fix**: Include essential patterns in skill, use references only for deep details

---

### Anti-Pattern 3: Context Fork Misuse

**Problem**: Simple task uses isolation unnecessarily

**Recognition**: "Is the overhead justified?"

**Example**:
```yaml
---
name: simple-counter
description: "Count files in directory"
context: fork
---

Count files.
```

**Problem**: Simple task, no need for fork overhead

**Fix**: Remove `context: fork`, use regular skill

---

### Anti-Pattern 4: Linear Chain Brittleness

**Problem**: Deep skill chains for reasoning tasks create single point of failure

**Recognition**: "Does this workflow have >3 steps with decision points?"

**Bad** (brittle linear chain):
```
[Main] → Step 1 → Step 2 → Step 3 → Step 4 → Step 5
(Context accumulates, becomes noisy)
```

**Good** (hub with forked workers):
```
[Hub]
  ↓ (fork)
[Worker 1] → Result
[Worker 2] → Result
[Worker 3] → Result
```

**Fix**: Use hub-and-spoke for complex workflows (>3 steps)

**Exception**: Linear chains are acceptable for deterministic utility workflows (e.g., validate → format → commit)

---

### Anti-Pattern 5: Regular Skill Chains Expecting Return

**Problem**: Regular→Regular skill chains are PROVEN to be one-way handoff only

**Evidence**: Test 1.2 confirmed execution flow: `User → skill-a → skill-b → END` (skill-a never resumes, skill-c never called)

**Recognition**: "Does the first skill expect results back from the second?"

**Bad**:
```
[Skill A] calls [Skill B] → Skill B completes → Skill A never resumes
```

**Fix**:
- For one-way workflows: Accept the handoff, design accordingly
- For result aggregation: ALL workers MUST use `context: fork`

**Critical**: This is not a limitation - it's the designed behavior. Plan accordingly.

---

## Description Anti-Patterns

### Anti-Pattern 6: "Use to" Language

**Problem**: Description includes "how" instead of what/when/not

**Recognition**: "Does this signal WHAT/WHEN/NOT?"

**Bad**:
```yaml
description: "Use to CREATE APIs by following these steps..."
```

**Good**:
```yaml
description: "Build self-sufficient skills. Use when creating, evaluating, or enhancing skills."
```

---

### Anti-Pattern 7: Vague Purpose

**Problem**: Description too generic to enable auto-discovery

**Recognition**: "Could multiple skills match this description?"

**Bad**:
```yaml
description: "A helpful skill for database work"
```

**Good**:
```yaml
description: "PostgreSQL query optimization patterns. Use when writing complex queries or optimizing performance."
```

---

### Anti-Pattern 8: Missing Triggers

**Problem**: Description lacks specific when-to-use context

**Recognition**: "Would Claude know when to trigger this?"

**Bad**:
```yaml
description: "Security validation patterns"
```

**Good**:
```yaml
description: "Security validation patterns for web applications. Use when reviewing code or auditing security."
```

---

### Anti-Pattern 9: Over-Specified Description

**Problem**: Description includes implementation details

**Recognition**: "Is this >200 characters or >30 words?"

**Bad**:
```yaml
description: "This skill validates YAML by first checking syntax, then verifying required fields like name and description exist, then testing the structure against the schema..."
```

**Good**:
```yaml
description: "Validate YAML structure and required fields. Use when testing skill quality or checking configuration files."
```

---

## Structure Anti-Patterns

### Anti-Pattern 10: Tier 2 Bloat

**Problem**: SKILL.md exceeds 500 lines

**Recognition**: "Could this be a reference file?"

**Bad**:
```markdown
# Security Validator (800 lines)

## OWASP Top 10 Details
[A01 detailed... detailed...]
[10 sections of detailed explanations...]

## Remediation Examples
[100 examples...]

## Testing Strategies
[200 lines of testing details...]
```

**Fix**: Move detailed content to Tier 3 (references/)

---

### Anti-Pattern 11: Unnecessary Tier 3

**Problem**: Creates reference file when content is minimal

**Recognition**: "Is SKILL.md already <200 lines?"

**Bad**:
```markdown
# Simple Skill (50 lines)

## What This Does
Simple description...

See [basic-usage.md](references/basic-usage.md)
```

**Fix**: Keep simple content in Tier 2

---

### Anti-Pattern 12: Nested References

**Problem**: References link to other references, creating navigation complexity

**Recognition**: "Are references more than one level deep?"

**Bad**:
```
SKILL.md → references/advanced.md → advanced/part3.md
```

**Fix**: All references should link directly from SKILL.md

---

## Content Anti-Patterns

### Anti-Pattern 13: Low Knowledge Delta

**Problem**: Skill contains generic tutorials instead of expert knowledge

**Recognition**: "Would Claude already know this?"

**Bad**:
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

---

### Anti-Pattern 14: Low Autonomy

**Problem**: Skill requires too many questions to complete tasks

**Recognition**: "Are there >5 questions in test output?"

**Bad**:
```yaml
---
name: file-helper
description: "Helps organize files"
---

Organize your files.
```
**Questions**: "How?" "What criteria?" "Where?"

**Fix**:
```yaml
---
name: file-organizer
description: "Organize project files by type and purpose"
---

**Organize by**:
- Code (*.js, *.ts) → src/
- Tests (*.test.*) → tests/
- Docs (*.md) → docs/

**Output**: List of files moved.
```

---

### Anti-Pattern 15: Over-Prescriptive Workflows

**Problem**: Skill prescribes HOW instead of WHAT

**Recognition**: "Does this trust AI intelligence?"

**Bad**:
```yaml
---
name: skill-creator
description: "Create skills by following steps"
---

# Create Skill

Step 1: Create directory
Step 2: Write YAML
Step 3: Add description
Step 4: Write content
Step 5: Test skill
```

**Fix**:
```yaml
---
name: skill-architect
description: "Build self-sufficient skills. Use when creating, evaluating, or enhancing skills."
---

## Skill Structure

**Location**: `.claude/skills/{name}/`
**Required**: SKILL.md with YAML (name, description)
**Optional**: references/ for detailed content

Trust your judgment on organization.
```

---

## Workflow Anti-Patterns

### Anti-Pattern 16: Missing Completion Markers

**Problem**: Transitive skills don't output completion markers

**Recognition**: "Is this skill called by other skills?"

**Problem**: Hub skill can't detect when worker finishes

**Fix**: Always include completion marker in transitive skills:
```markdown
## WORKER_SKILL_COMPLETE

Results: [output data]
```

---

### Anti-Pattern 17: No Error Handling

**Problem**: Workflows fail silently without recovery

**Recognition**: "What happens when a step fails?"

**Bad**:
```markdown
## Deploy

Run deployment commands.
```

**Fix**:
```markdown
## Deploy

1. Build: !`npm run build`
2. If build fails → Fix errors, re-run
3. Deploy: !`kubectl apply -f staging.yaml`
4. If deployment fails → Rollback: !`kubectl rollout undo`
5. Verify: !`kubectl rollout status`
```

---

## Documentation Anti-Patterns

### Anti-Pattern 18: Extraneous Documentation Files

**Problem**: Skills contain auxiliary documentation not needed for AI execution

**Recognition**: "Is this for AI agents or human users?"

**Don't create in skills**:
- README.md
- INSTALLATION_GUIDE.md
- QUICK_REFERENCE.md
- CHANGELOG.md
- TUTORIAL.md
- GUIDE.md

**Rationale**: Skills should only contain information needed for an AI agent to do the job.

---

### Anti-Pattern 19: Stale URLs

**Problem**: Documentation links no longer valid

**Recognition**: "Have URLs been validated recently?"

**Fix**: Always verify URLs with web fetch before including in skills

---

## Script Anti-Patterns

### Anti-Pattern 20: Brittle Script Paths

**Problem**: Scripts use relative paths or Windows-style paths

**Recognition**: "Will this work across platforms?"

**Bad**:
```bash
cd ../scripts
./script.sh
```

**Good**:
```bash
./.claude/skills/skill-name/scripts/script.sh
```

---

### Anti-Pattern 21: Missing Script Validation

**Problem**: Scripts don't handle errors explicitly

**Recognition**: "What happens if the script fails?"

**Bad**:
```bash
#!/bin/bash
grep "pattern" file.txt | ./process.py
```

**Good**:
```bash
#!/bin/bash
set -euo pipefail

if ! grep "pattern" file.txt > /dev/null 2>&1; then
    echo "ERROR: Pattern not found"
    exit 1
fi

grep "pattern" file.txt | ./process.py
```

### Anti-Pattern 22: Assuming Context Inheritance in Forked Skills

**Problem**: Expecting forked skills to have access to caller's context

**Evidence**: Tests 2.2, 2.4 confirmed complete context isolation

**Recognition**: "Does the forked skill need conversation history or variables?"

**Bad**:
```yaml
# Hub skill
# Assumes worker has access to project_root variable
Call: worker-skill
```

**Good**:
```yaml
# Hub skill
# Pass everything explicitly
Call: worker-skill with args="project_root=/path/to/project user_preference=dark_mode"
```

**Fix**: Always pass required data via `args` parameter. Forked skills receive NO caller context.

### Anti-Pattern 23: Assuming Nested Forking Doesn't Work

**Problem**: Avoiding nested hub-and-spoke patterns due to unfounded assumptions

**Evidence**: Test 4.2 confirmed nested forking works correctly: forked-outer → forked-inner → forked-outer

**Recognition**: "Is this a complex hierarchical workflow?"

**Bad**:
```
[Root] → [Worker-A] → [Worker-B] → END
(Everything in one level to "avoid complexity")
```

**Good**:
```
[Root Hub]
  ↓
[Mid Hub] (fork)
  ↓
[Worker A] (fork) → Result
[Worker B] (fork) → Result
```

**Fix**: Use nested hub-and-spoke for complex hierarchical workflows. Validated to depth 2+.

### Anti-Pattern 24: Assuming System-Level Error Detection in Forked Skills

**Problem**: Expecting to catch forked skill "failures" at system level

**Evidence**: Test 8.1 confirmed that when forked skills "fail", they complete normally from system perspective

**Recognition**: "Is this checking for errors in a forked skill?"

**Bad**:
```yaml
# This won't work - no system-level error thrown
Call: worker-skill (context: fork)
HandleError: [system error detected]
```

**Good**:
```yaml
# Parse output for error indicators
Call: worker-skill (context: fork)
Parse output for "## WORKER_COMPLETE" or "## WORKER_FAILED"
```

**Fix**: Error detection requires parsing output content, not checking system states.

---

## Quick Recognition Questions

| Anti-Pattern | Recognition Question |
|--------------|---------------------|
| Command Wrapper | Could the description alone suffice? |
| Non-Self-Sufficient | Can this work standalone? |
| Context Fork Misuse | Is the overhead justified? |
| Linear Chain Brittleness | Does this have >3 steps with decisions? |
| Regular Skill Chains | Does the first skill expect results back? |
| Context Inheritance | Does forked skill need caller variables? |
| Nested Forking | Is this a complex hierarchical workflow? |
| Error Detection | Is this checking for errors in forked skills? |
| "Use to" Language | Does this signal WHAT/WHEN/NOT? |
| Vague Purpose | Could multiple skills match this? |
| Missing Triggers | Would Claude know when to trigger this? |
| Tier 2 Bloat | Could this be a reference file? |
| Low Knowledge Delta | Would Claude already know this? |
| Low Autonomy | Are there >5 questions in output? |

---

## See Also

- [quality-framework.md](quality-framework.md) - Quality dimensions and scoring
- [autonomy-design.md](autonomy-design.md) - Improving autonomy scores
- [description-guidelines.md](description-guidelines.md) - What-When-Not framework
- [orchestration-patterns.md](orchestration-patterns.md) - Hub-and-spoke and fork patterns
