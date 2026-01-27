---
name: subagent-driven-development
description: "Execute plans with subagents. Use when: Executing independent tasks in the current session with fresh subagents and two-stage reviews. Not for: Sequential dependencies or manual execution."
---

# Subagent-Driven Development

Execute plan by dispatching fresh subagent per task, with two-stage review after each: spec compliance review first, then code quality review.

**Core principle:** Fresh subagent per task + two-stage review (spec then quality) = high quality, fast iteration

## When to Use

**Use when:**
- Implementation plan exists with independent tasks
- Want fresh subagent per task (no context pollution)
- Need two-stage review (spec compliance + quality)
- Stay in current session (no handoff)

**Don't use when:**
- Tasks are tightly coupled (use sequential execution)
- Prefer parallel session (use `executing-plans` instead)
- Want batch execution (use `executing-plans` instead)

## The Process

### Overview

<logic_flow>
digraph SubagentLoop {
    rankdir=TB;
    Implement -> SpecReview;
    SpecReview -> FixSpec [label="Issues"];
    FixSpec -> SpecReview;
    SpecReview -> QualityReview [label="Pass"];
    QualityReview -> FixQuality [label="Issues"];
    FixQuality -> QualityReview;
    QualityReview -> MarkComplete [label="Pass"];
}
</logic_flow>

## Step-by-Step Workflow

### Step 1: Load Plan

Read plan and extract tasks:

```bash
# Load implementation plan
cat docs/plans/2026-01-27-feature-plan.md

# Extract task list
grep "^### Task" docs/plans/feature-plan.md

# Create TaskList for tracking
TaskCreate for each task
```

### Step 2: Per Task - Dispatch Implementer

Use `component-builder-prompt.md` template:

```typescript
Task("Implement Task N: [task name]", {
  prompt: render_template("component-builder-prompt.md", {
    task_name: "[task name]",
    task_description: "[full text from plan]",
    context: "[architectural context]",
    directory: "[workspace path]"
  })
})
```

**Expected from implementer:**
- What they implemented
- What they tested and results
- Files changed
- Self-review findings
- Any issues or concerns

### Step 3: Answer Questions

If implementer asks questions:

**Always answer clearly and completely:**
- Provide additional context if needed
- Don't rush them into implementation
- Clarify requirements

**Then re-dispatch implementer**

### Step 4: Stage 1 - Spec Compliance Review

Use `spec-reviewer-prompt.md` template:

```typescript
Task("Review Spec Compliance: Task N", {
  prompt: render_template("spec-reviewer-prompt.md", {
    task_name: "[task name]",
    requirements: "[full requirements text]",
    builder_report: "[what implementer claims]",
    component_files: "[actual implementation]"
  })
})
```

**CRITICAL: Do not trust the report**
- Verify everything independently
- Read actual code
- Compare line by line
- Check for missing/extra work

**Report:**
- ✅ Spec compliant (if all matches)
- ❌ Issues found (list with file:line)

### Step 5: Fix Spec Issues

If spec reviewer finds issues:

```typescript
Task("Fix Spec Issues: Task N", {
  prompt: `
    Fix the spec compliance issues found:

    Issues:
    ${spec_issues}

    Please fix these issues and report back.
  `
})
```

**Then re-review (back to Step 4)**

### Step 6: Stage 2 - Code Quality Review

Use `quality-reviewer-prompt.md` template:

```typescript
Task("Review Quality: Task N", {
  prompt: render_template("quality-reviewer-prompt.md", {
    task_name: "[task name]",
    spec_compliance_results: "[compliance outcome]",
    component_files: "[implementation]",
    seed_standards: "[quality criteria]"
  })
})
```

**Report:**
- Strengths
- Issues (Critical/Important/Minor)
- Assessment (Approved/Needs fixes)

### Step 7: Fix Quality Issues

If quality reviewer finds issues:

```typescript
Task("Fix Quality Issues: Task N", {
  prompt: `
    Fix the quality issues found:

    Issues:
    ${quality_issues}

    Please fix these issues and report back.
  `
})
```

**Then re-review (back to Step 6)**

### Step 8: Mark Complete

After both stages pass:

```markdown
Task N: ✅ COMPLETE

Spec Compliance: ✅ Pass
Quality Review: ✅ Pass

Files modified:
- [file 1]
- [file 2]

Tests: [N/N passing]

Ready for next task.
```

### Step 9: Next Task

Repeat Steps 2-8 for next task.

### Step 10: Final Review

After all tasks complete:

```typescript
Task("Final Code Review: [Feature]", {
  prompt: `
    Review the entire implementation:

    Tasks completed:
    ${all_tasks_summary}

    Please review the overall implementation and provide final assessment.
  `
})
```

### Step 11: Completion

Use `finishing-a-development-branch` skill to complete work.

## Advantages

### vs Manual Execution

**Subagents follow TDD naturally:**
- Fresh context per task
- No confusion from previous tasks
- Can ask questions

**Parallel-safe:**
- Subagents don't interfere
- Fresh subagent per task

**Systematic review:**
- Two-stage review catches issues
- Review loops until approved

### vs Executing Plans

**Same session:**
- No handoff to new session
- Continuous progress

**Fresh context:**
- Each task starts fresh
- No pollution from previous tasks

**Review checkpoints:**
- Automatic after each task
- Spec compliance first
- Quality review second

**Efficiency gains:**
- No file reading overhead (controller provides context)
- Subagent gets complete information upfront
- Questions surfaced before work begins

**Quality gates:**
- Self-review catches issues
- Two-stage review (spec + quality)
- Review loops ensure fixes work
- Spec compliance prevents over/under-building
- Code quality ensures well-built

## Red Flags

**Never:**
- Skip reviews (spec compliance OR code quality)
- Proceed with unfixed issues
- Dispatch multiple implementation subagents in parallel
- Make subagent read plan files
- Skip context for subagent
- Ignore subagent questions
- Accept "close enough" on spec compliance
- Skip review loops (reviewer found issues = fix = re-review)
- Let implementer self-review replace actual review
- Start quality review before spec compliance passes
- Move to next task while either review has open issues

**If subagent asks questions:**
- Answer clearly and completely
- Provide additional context if needed
- Don't rush into implementation

**If reviewer finds issues:**
- Implementer (same subagent) fixes them
- Reviewer reviews again
- Repeat until approved
- Don't skip the re-review

**If subagent fails task:**
- Dispatch fix subagent with specific instructions
- Don't try to fix manually

## Integration

**Required workflow skills:**
- **writing-plans** - Creates the plan this skill executes
- **finishing-a-development-branch** - Complete development after tasks
- **meta-critic templates** - Prompt templates for reviews

**Subagents should use:**
- **tdd-workflow** - Subagents follow TDD for each task

**Alternative workflow:**
- **executing-plans** - Use for parallel session instead of same-session execution

## Example Workflow

```
You: I'm using subagent-driven-development to execute this plan.

[Read plan file once: docs/plans/feature-plan.md]
[Extract all 5 tasks with full text and context]
[Create TaskList with all tasks]

Task 1: Hook installation script

[Get Task 1 text and context]
[Dispatch implementation subagent with full task text + context]

Implementer: "Before I begin - should the hook be installed at user or system level?"

You: "User level (~/.config/project/hooks/)"

Implementer: "Got it. Implementing now..."
[Later] Implementer:
  - Implemented install-hook command
  - Added tests, 5/5 passing
  - Self-review: Found I missed --force flag, added it
  - Committed

[Dispatch spec compliance reviewer]
Spec reviewer: ✅ Spec compliant - all requirements met, nothing extra

[Get git SHAs, dispatch code quality reviewer]
Code reviewer: Strengths: Good test coverage, clean. Issues: None. Approved.

[Mark Task 1 complete]

Task 2: Recovery modes

[Get Task 2 text and context]
[Dispatch implementation subagent]

Implementer: [No questions, proceeds]
Implementer:
  - Added verify/repair modes
  - 8/8 tests passing
  - Self-review: All good
  - Committed

[Dispatch spec compliance reviewer]
Spec reviewer: ❌ Issues:
  - Missing: Progress reporting (spec says "report every 100 items")
  - Extra: Added --json flag (not requested)

[Implementer fixes issues]
Implementer: Removed --json flag, added progress reporting

[Spec reviewer reviews again]
Spec reviewer: ✅ Spec compliant now

[Dispatch code quality reviewer]
Code reviewer: Strengths: Solid. Issues (Important): Magic number (100)

[Implementer fixes]
Implementer: Extracted PROGRESS_INTERVAL constant

[Code reviewer reviews again]
Code reviewer: ✅ Approved

[Mark Task 2 complete]

...

[After all tasks]
[Dispatch final code-reviewer]
Final reviewer: All requirements met, ready to merge

Done!
```

## Cost Considerations

**More subagent invocations:**
- Implementer + 2 reviewers per task
- But catches issues early (cheaper than debugging later)

**Controller does more prep work:**
- Extracting all tasks upfront
- Curating context for each subagent

**Review loops add iterations:**
- Spec issues → fix → re-review
- Quality issues → fix → re-review

**But benefits outweigh costs:**
- Higher quality output
- Fewer bugs
- Better adherence to spec
- Systematic review process

## Quick Reference

| Step | Action | Output |
|------|--------|--------|
| 1 | Load plan | Task list |
| 2 | Dispatch implementer | Implementation |
| 3 | Answer questions | Clarified requirements |
| 4 | Spec compliance review | Pass/Fail + issues |
| 5 | Fix spec issues | Fixed implementation |
| 6 | Quality review | Assessment + issues |
| 7 | Fix quality issues | Improved implementation |
| 8 | Mark complete | Task done |
| 9 | Next task | Repeat 2-8 |
| 10 | Final review | Overall assessment |
| 11 | Complete | Finished work |

## Key Principles

1. **Fresh subagent per task** - No context pollution
2. **Two-stage review** - Spec compliance first, quality second
3. **Review loops** - Issues must be fixed, not ignored
4. **Complete context** - Provide everything subagent needs
5. **Systematic approach** - Same process every task

Subagent-driven development ensures high-quality implementation through systematic review and fresh context per task.
