---
name: learn-mdrules
description: This skill should be used when the user asks to "diagnose conversation issues", "improve project rules", "analyze what went wrong", "propose rules for CLAUDE.md", or needs guidance on preventing future issues through better project rules in CLAUDE.md or .claude/rules/.
user-invocable: true
---

# MD Metacritic

Think of MD Metacritic as a **diagnostic detective**—investigating conversations to identify patterns of mistakes, extracting root causes, and proposing specific rules to prevent future issues.

## Core Directive

**Execute autonomously:**
1. Investigate conversation and context
2. Diagnose preventable issues
3. Propose specific, actionable rules
4. Apply selected improvements

**You must NOT use "agents"** - when users ask to read history, examine the actual conversation.

## Recognition Patterns

**When to use learn-mdrules:**
```
✅ Good: "What went wrong in our conversation?"
✅ Good: "How can we prevent these issues?"
✅ Good: "Improve project rules"
✅ Good: "Analyze recurring mistakes"
❌ Bad: Simple file edits
❌ Bad: Single-purpose tool requests

Why good: Pattern-based diagnosis requires systematic investigation and rule formulation.
```

**Pattern Match:**
- User mentions "diagnose", "analyze what went wrong", "improve rules"
- Recurring issues or repeated questions
- Mistakes that could be prevented
- Need to propose rules for CLAUDE.md

**Recognition:** "Do you need systematic diagnosis of conversation issues?" → Use learn-mdrules.

## The Loop

Execute this iterative process:

### Phase 1: Autonomous Investigation
1. **Scan Context**
   - Previous conversation history
   - Project structure (.claude/, CLAUDE.md)
   - User remarks about issues
   - Error logs or patterns

2. **Identify Issues**
   - Mistakes or errors made
   - Repeated questions needed
   - Suboptimal approaches taken
   - User corrections or interventions
   - Time wasted on obvious things
   - Assumptions that led to errors

3. **Extract Patterns**
   - What could have been known from project rules?
   - What repeated explanations were needed?
   - What context was missing?
   - What assumptions caused problems?

4. **Determine Root Cause**
   - **Project-specific** (CLAUDE.md)
   - **Universal principle** (.claude/rules/)
   - **Tool pattern** (documentation)
   - **Workflow guidance** (project memory)

### Phase 2: Iterative Clarification

**Ask targeted questions when:**
- Investigation reveals ambiguity
- User preference needed on approach
- Understanding needs confirmation
- Priorities or context unclear

**Question Strategy:**
- Ask one question at a time
- Build on previous answers
- Research between questions
- Continue until sufficient clarity

**Ask when NOT needed:**
- Investigation provides complete clarity
- Issue has one obvious solution
- Autonomous action explicitly requested

### Phase 3: Rule Formulation

**After investigation** (and optional questions):

1. **Analyze Findings** - Synthesize investigation results
2. **Craft Specific Rules** - Create actionable text for insertion
3. **Ensure Actionability** - Each rule must be immediately implementable
4. **Prepare Proposals** - Format for user selection

**Rule**: Propositions must be SPECIFIC and ACTIONABLE.

**Each proposition must be:**
- Actual text to insert into files
- Specific rule or constraint
- Concrete example or pattern
- Immediately implementable via Edit

**Format:**
```
**Proposition A**: [2-3 word summary]
[Concrete rule text to add]

**Proposition B**: [2-3 word summary]
[Concrete rule text to add]
```

**Contrast:**
```
✅ Good: "Add testing framework constraint" - Clear action
❌ Bad: "Add Documentation" - Too vague

Why good: Specific rules are immediately implementable.
```

### Phase 4: Application

1. **Present Propositions** - Show all options with clear explanations
2. **Apply Selected Rules**
   - Individual changes: Use Edit tool
   - Comprehensive changes: Create TaskList plan
3. **Verify** - Read files to confirm changes
4. **Continue Loop** - Return to Phase 1 for remaining issues
5. **Exit** - When user confirms resolution

## Issue Categories

### 1. Missing Project Knowledge
- Technology stack confusion
- Undocumented architecture decisions
- Missing file structure guidance
- Configuration quirks

### 2. Workflow Inefficiencies
- Repeated clarification questions
- Wrong tool selection
- Suboptimal execution order
- Missing automation opportunities

### 3. Command & Pattern Gaps
- Wrong commands attempted
- Missing quick-reference commands
- Outdated documentation
- Missing gotchas or warnings

### 4. Rule Violations
- Actions against project standards
- Missing validation steps
- Wrong tool for job
- Ignored best practices

### 5. Communication Breakdowns
- Assumptions not validated
- Missing context in explanations
- User corrections avoidable
- Clarification patterns repeat

## Critical Rules

### Investigation
- **Investigate thoroughly** - Scan conversation, context, files before asking
- **Diagnose first** - Understand root causes before proposing
- **Reason about patterns** - Each issue reveals missing knowledge
- **Focus on preventability** - What rule would stop this issue?

### Questions
- **Investigate first** - Build understanding through scanning
- **Ask what matters** - Determine relevance based on investigation
- **Ask one at a time** - Use AskUserQuestions when needed
- **Build understanding** - Questions should help resolve issues

### Propositions
- **Show actual text** - Display exact words to insert
- **No abstract categories** - Don't use "Add Documentation"
- **Immediately actionable** - Show exactly what will be written
- **Tailored to issue** - Targeted fixes beat generic boilerplate

### Quality
- **One issue per iteration** - Surgical fixes, not rewrites
- **No hallucination** - Only critique what actually happened
- **User-guided refinement** - Incorporate user input
- **Ensure persistent value** - Each rule prevents recurring issues

**Recognition:** "Does this investigation reveal preventable patterns?" → Extract root causes and propose specific rules.
