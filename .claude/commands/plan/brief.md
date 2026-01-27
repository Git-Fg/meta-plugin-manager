---
description: "Create BRIEF.md project vision document. Use when starting new projects or clarifying project direction."
argument-hint: [project description]
---

# Brief Creation

<mission_control>
<objective>Create project vision document capturing what, why, and success criteria</objective>
<success_criteria>BRIEF.md created with name, description, problem, success criteria, constraints, under 50 lines</success_criteria>
</mission_control>

## Purpose

Create a project vision document that captures what we're building and why. This is the ONLY human-focused document - everything else is for Claude.

## Process

### EXPLORE

Analyze user's original request for implicit context:

| What to Explore  | How                             | Goal                      |
| ---------------- | ------------------------------- | ------------------------- |
| User request     | Analyze original message        | Extract requirements      |
| Project name     | Infer from request or ask       | Naming the project        |
| Tech stack       | Check request for hints         | Understanding constraints |
| Similar projects | Check git history if applicable | Avoid duplicates          |

### INFER

Try to infer from request:

| Question      | Can Infer If...                   | Won't Ask If...      |
| ------------- | --------------------------------- | -------------------- |
| Project name  | Request mentions name             | Request is clear     |
| What building | Request describes functionality   | Clearly stated       |
| Why           | Request mentions problem/solution | Obvious from context |
| Constraints   | Request mentions tech stack       | Explicitly stated    |

### ASK ONE

Only if context is unclear after EXPLORE + INFER, ask ONE focused question.

**Provide actionable propositions** - numbered options the user can select.

**If all inferred**: Proceed to write_brief without asking.

### Write Brief

Use template from `create-plans/templates/brief.md`.

Write to `.claude/workspace/planning/BRIEF.md` with:

- Project name
- One-line description
- Problem statement (why this exists)
- Success criteria (measurable outcomes)
- Constraints (if any)
- Out of scope (what we're NOT building)

**Keep it SHORT.** Under 50 lines.

### CONFIRM

After creating brief:

```
Brief created: .claude/workspace/planning/BRIEF.md

NOTE: Brief will be committed with roadmap as project initialization.

Invoke /plan:roadmap to create phases? (yes / review / later)
```

## Anti-Patterns

- Don't write a business plan
- Don't include market analysis
- Don't add stakeholder sections
- Don't create executive summaries
- Don't add timelines (that's roadmap's job)

Keep it focused: What, Why, Success, Constraints.

## Success Criteria

- [ ] EXPLORE + INFER attempted
- [ ] 0 questions asked if all inferred (max 1 if needed)
- [ ] `.claude/workspace/planning/BRIEF.md` exists
- [ ] Contains: name, description, problem, success criteria
- [ ] Under 50 lines
- [ ] CONFIRM asked: "Invoke /plan:roadmap?"

<critical_constraint>
MANDATORY: Use EXPLORE → INFER → ASK ONE pattern

MANDATORY: Keep brief under 50 lines (human-focused reference)

MANDATORY: Defer to create-plans skill for detailed guidance

No exceptions. Brief is a vision document, not a novel.
</critical_constraint>
