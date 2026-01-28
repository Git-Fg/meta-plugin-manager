# Workflow: Create Brief

## Required Reading

**Read these files NOW:**

1. templates/brief.md

## Purpose

Create a project vision document that captures what we're building and why.
This is the ONLY human-focused document - everything else is for Claude.

## Process

#### EXPLORE

Analyze user's original request for implicit context:

| What to Explore  | How                             | Goal                          |
| ---------------- | ------------------------------- | ----------------------------- |
| User request     | Analyze original message        | Extract implicit requirements |
| Project name     | Infer from request or ask       | Naming the project            |
| Tech stack       | Check request for stack hints   | Understanding constraints     |
| Similar projects | Check git history if applicable | Avoid duplicates              |

#### INFER

Try to infer from request:

| Question      | Can Infer If...                   | Won't Ask If...      |
| ------------- | --------------------------------- | -------------------- |
| Project name  | Request mentions name             | Request is clear     |
| What building | Request describes functionality   | Clearly stated       |
| Why           | Request mentions problem/solution | Obvious from context |
| Constraints   | Request mentions tech stack       | Explicitly stated    |

#### ASK ONE

Only if context is unclear after EXPLORE + INFER, ask ONE focused question with numbered options the user can select.

**Provide actionable propositions** - present inferred project context and let user confirm/adjust by selection, not typing.

**If all inferred**: Proceed to write_brief without asking.

#### create_structure

Create the planning directory:

```bash
mkdir -p .planning
```

#### write_brief

Use the template from `templates/brief.md`.

Write to `.claude/workspace/planning/BRIEF.md` with:

- Project name
- One-line description
- Problem statement (why this exists)
- Success criteria (measurable outcomes)
- Constraints (if any)
- Out of scope (what we're NOT building)

**Keep it SHORT.** Under 50 lines. This is a reference, not a novel.

#### CONFIRM

After creating brief:

```
Brief created: .claude/workspace/planning/BRIEF.md

NOTE: Brief is NOT committed yet. It will be committed with the roadmap as project initialization.

Invoke /create-roadmap to create phases? (yes / review / later)
```

## Anti-Patterns

- Don't write a business plan
- Don't include market analysis
- Don't add stakeholder sections
- Don't create executive summaries
- Don't add timelines (that's roadmap's job)
- Don't scatter questions throughout

Keep it focused: What, Why, Success, Constraints.

## Success Criteria

Brief is complete when:

- [ ] EXPLORE + INFER attempted
- [ ] 0 questions asked if all inferred (max 1 if needed)
- [ ] `.claude/workspace/planning/BRIEF.md` exists
- [ ] Contains: name, description, problem, success criteria
- [ ] Under 50 lines
- [ ] CONFIRM asked: "Invoke /create-roadmap?"
