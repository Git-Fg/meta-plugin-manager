# Skill Creation Principles

## Core Formula

**Good Customization = Expert-only Knowledge − What Claude Already Knows**

Focus on knowledge delta, not tutorials.

## Design for Autonomy

**Target**: 80-95% completion without questions

**Autonomy Checklist**:
- [ ] Ambiguity resolved through exploration (read/grep)
- [ ] User input only for truly ambiguous cases
- [ ] Explicit success/stop criteria
- [ ] Fork pattern when appropriate

**Question Burst Test** (only if ALL 3 true):
1. Information NOT inferrable from repo/tools
2. High impact if wrong choice
3. Small set (3-7 max) unlocks everything

## The Delta Principle

**Redundant** → Delete (Claude already knows)
**Expert-only** → Keep (this is the value)

**Content Types**:
- Decision trees for non-obvious choices
- Trade-offs only experts know
- Edge cases from real-world experience
- "NEVER do X because [specific reason]"

## Progressive Disclosure

**Rule of Three**:
- Mentioned once → Keep in SKILL.md
- Mentioned twice → Reference it
- Mentioned three times → Extract to file

**Structure**:
- SKILL.md: Core workflow (<500 lines)
- references/: Supporting knowledge
- examples/: Concrete patterns
- scripts/: Reusable code

## Content Organization

**Golden Path Method**:
1. Find the main workflow (what practitioners actually use)
2. Extract the Delta (unique insights)
3. Organize by intention (core workflow vs supporting knowledge)

**Description Format**:
"What this does + when to use it + when not to use it"

**Example Requirement**:
One concrete example worth 100 explanations

## Quality Indicators

**Good Signs**:
- SKILL.md focused and clear
- Users can succeed with it
- Extracted golden path
- Captured unique insights

**Red Flags**:
- Explaining basics (what is X, how to use library)
- SKILL.md 1000+ lines
- Copying entire documents
- Multiple approaches included

## Archetypes

| Content Type | Structure | Focus |
|--------------|-----------|-------|
| **Single objective** | Minimalist | One clear workflow |
| **Process with verification** | Executor | Reliable steps |
| **Knowledge sharing** | Consultant | Sharing expertise |
| **Multiple workflows** | Orchestrator | Coordination |
| **Standardized outputs** | Generator | Consistent results |

## Common Mistakes

1. **Tutorial Trap**: Explaining what Claude already knows
2. **Dump Pattern**: Everything in SKILL.md
3. **Vague Warning**: "Be careful" without specifics
4. **Orphan References**: Files never loaded
5. **Checkbox Procedure**: Mechanical steps instead of thinking frameworks

## Validation

**Test**:
1. Start new conversation
2. Ask skill to do its job
3. Does it work?

**Success Metrics**:
- Prompt budget: ≤2 top-level prompts
- Subagent fan-out: ≤3 subagents
- Correction cycles: ≤1 per file
- Work unit completed in single session
