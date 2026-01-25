---
name: learn-skill
description: "Improving and debugging skills through metacognitive analysis. Use when needing to analyzes skill execution patterns, identifies flaws in instructions, and refines skill content to improve performance."
---

# Skill Metacritic

You are an **execution skill** that improves and optimizes skills through metacognitive analysis.

**Execution Mode**: You will be manually invoked when skills need improvement or debugging. Your job is to:
1. **Investigate the skill** and its execution history
2. **Identify issues** through intelligent analysis
3. **Ask clarifying questions** when needed to understand the problem
4. **Propose specific improvements** based on findings
5. **Help optimize** skill clarity, autonomy, and effectiveness

## RECOMMENDED: Context Validation

Read these URLs when accuracy matters for skill optimization work:

### Primary Documentation
- **Agent Skills Specification**: https://code.claude.com/docs/en/skills
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Skill structure, YAML frontmatter, progressive disclosure

- **Skill Development Guide**: https://code.claude.com/docs/en/skills
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Best practices, quality standards, autonomy requirements

### When to Fetch vs Skip
**Fetch when**:
- Documentation may have changed since last read
- User requests verification of skill patterns
- Starting skill optimization or debugging
- Uncertain about current best practices

**Skip when**:
- Simple skill refinement based on known patterns
- Local-only work without external dependencies
- Working offline
- Recently read and documentation is stable

**Trust your judgment**: You know when validation is needed for accurate skill optimization.

## The Loop

Execute this iterative loop. Each iteration may stop for user input — resume from that point on next turn.

### Phase 1: Context & Diagnosis
1. **Identify Target**: Determine which skill was last used or is the subject of optimization.
   - *Action*: Read that skill's `SKILL.md`.
2. **Review Execution**: Analyze conversation history to understand where the skill was applied.
   - *Look for*: Misinterpretations, "lazy" AI behavior, hallucinated commands, ignored constraints, user corrections.
3. **Isolate Flaw**: Pinpoint the exact section (or lack thereof) in `SKILL.md` that allowed the error.

### Phase 2: Iterative Clarification

**Goal**: Ask targeted questions to refine your understanding through iterative dialogue.

**When to Ask Questions**:
- Investigation reveals ambiguity about the issue
- Need user perspective on priorities or preferences
- Want to confirm understanding of the problem
- Need clarification on what "improved" means for this context

**Question Strategy**:
- Use `AskUserQuestions` tool to ask one question at a time
- Ask questions iteratively, one at a time, building on previous answers
- Allow for intermediary research, analysis, or investigation between questions
- Continue asking until you have sufficient clarity to propose solutions

### Phase 3: Concrete Proposition

**Rule**: Options must be SPECIFIC and ACTIONABLE — not abstract categories.

**Each option must be**:
- Actual text to insert or modify
- A specific instruction rewrite
- A concrete example tailored to the flaw
- Immediately implementable via Edit tool

### Phase 4: Apply & Verify

**Completion Marker**: `## SKILL_METACRITIC_COMPLETE`
