# Workflow: Research Phase

## Purpose

Create and execute a research prompt for phases with unknowns.
Produces FINDINGS.md that informs PLAN.md creation.

## When to Use

- Technology choice unclear
- Best practices needed
- API/library investigation required
- Architecture decision pending

## Process

#### identify_unknowns

Ask: What do we need to learn before we can plan this phase?

- Technology choices?
- Best practices?
- API patterns?
- Architecture approach?

#### create_research_prompt

Use templates/research-prompt.md.
Write to `.claude/workspace/planning/phases/XX-name/RESEARCH.md`

Include:

- Clear research objective
- Scoped include/exclude lists
- Source preferences (official docs, Context7, 2024-2025)
- Output structure for FINDINGS.md

#### execute_research

Run the research prompt:

- Use web search for current info
- Use Context7 MCP for library docs
- Prefer 2024-2025 sources
- Structure findings per template

#### create_findings

Write `.claude/workspace/planning/phases/XX-name/FINDINGS.md`:

- Summary with recommendation
- Key findings with sources
- Code examples if applicable
- Metadata (confidence, dependencies, open questions, assumptions)

#### confidence_gate

After creating FINDINGS.md, check confidence level.

If confidence is LOW:
Ask user how to proceed with actionable options: dig deeper, proceed with caveats, or pause to think.

If confidence is MEDIUM:
Inline: "Research complete (medium confidence). [brief reason]. Proceed to planning?"

If confidence is HIGH:
Proceed directly, just note: "Research complete (high confidence)."

#### open_questions_gate

If FINDINGS.md has open_questions:

Present them inline:
"Open questions from research:

- [Question 1]
- [Question 2]

These may affect implementation. Acknowledge and proceed? (yes / address first)"

If "address first": Gather user input on questions, update findings.

#### offer_next

```
Research complete: .claude/workspace/planning/phases/XX-name/FINDINGS.md
Recommendation: [one-liner]
Confidence: [level]

What's next?
1. Create phase plan (PLAN.md) using findings
2. Refine research (dig deeper)
3. Review findings
```

NOTE: FINDINGS.md is NOT committed separately. It will be committed with phase completion.

## Success Criteria

- RESEARCH.md exists with clear scope
- FINDINGS.md created with structured recommendations
- Confidence level and metadata included
- Ready to inform PLAN.md creation
