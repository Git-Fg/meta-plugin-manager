---
name: brainstorming-together
description: This skill should be used when users ask to "explore problems", "evaluate options", "reach actionable conclusions", "analyze complex decisions", or "brainstorm solutions" through the Guided Deductive Navigation methodology.
user-invocable: true
---

# Guided Deductive Navigation

This skill implements a reasoning approach that shifts cognitive load from the User to the AI through **Recognition over Generation** by systematically exploring ALL possibilities and using iterative AskUserQuestion to converge on the most relevant solution.

## About This Approach

Instead of asking users to generate answers (requiring lengthy typing), this approach:
1. **Maps comprehensive possibilities** using analytical frameworks
2. **Generates structured hypotheses** covering the full problem space
3. **Asks users to validate** through quick recognition selections
4. **Iterates drilling down** until the optimal path is evident

**The Core Shift**:
- **Old Way**: User thinks → AI questions → User explains more → AI reflects
- **New Way**: AI maps ALL possibilities → User recognizes patterns → AI navigates → Action

## The Comprehensive Thinking Framework

This methodology uses an explicit thinking framework to systematically explore ALL possibilities:

### Framework Steps

1. **Deep Context Analysis**
   - Scan all provided information, files, history, and context
   - Identify key variables, constraints, stakeholders, and objectives
   - Map the problem landscape comprehensively

2. **Exhaustive Possibility Mapping**
   - Generate 3-4 distinct categories that partition the problem space
   - Ensure categories are mutually exclusive and collectively exhaustive
   - Cover ALL possible scenarios, not just obvious ones
   - Use analytical frameworks (e.g., root cause analysis, decision trees, constraint mapping)

3. **Structured Hypothesis Generation**
   - Create specific hypotheses for each category
   - Include concrete evidence and context clues
   - Make hypotheses actionable and distinct
   - Prioritize hypotheses based on likelihood and impact

4. **Iterative AskUserQuestion Navigation**
   - Present options using structured AskUserQuestion format
   - Ask ONE question at a time to avoid overwhelming
   - Drill down based on user selection
   - Continue until solution becomes evident

5. **Convergence to Action**
   - Synthesize insights from the navigation path
   - Generate specific, actionable recommendations
   - Validate with user before proceeding

**Use AskUserQuestion iteratively, one question at a time. Trust the AI agent to apply analytical frameworks comprehensively and generate ALL relevant hypotheses.**

---

## The Interaction Loop

This approach follows a systematic flow to map ALL possibilities and guide users from "Confused" to "Clear" with minimal typing:

### Phase 1: Comprehensive Context Analysis

**Apply Deep Context Analysis**:
- Review all available information (files, history, user input)
- Identify key variables, constraints, stakeholders, objectives
- Map the problem landscape comprehensively
- Determine problem type (Decision, Debugging, Strategy, Creative, Planning)

**Example**: "I'm analyzing your situation to map all possibilities. Are we facing a **Decision** (choosing between options), **Debugging** (identifying root cause), **Strategy** (planning approach), or **Creative** (generating new solutions)?"

### Phase 2: Exhaustive Possibility Mapping

**Generate Comprehensive Options**:
- Apply analytical frameworks to partition the problem space
- Create 3-4 distinct categories covering ALL possibilities
- Ensure categories are mutually exclusive and collectively exhaustive
- Include concrete evidence and context clues for each

**The Structured Recognition Menu**:
```
"I've mapped [number] comprehensive patterns covering ALL possibilities in [problem type]. Which aligns best with your situation?"

1. [Category A - with specific evidence and context]
2. [Category B - with specific evidence and context]
3. [Category C - with specific evidence and context]
4. Something else entirely
```

**Requirements**:
- Use `AskUserQuestion` tool with structured options
- Maximum 4 primary options (plus "something else")
- Natural, conversational language with evidence
- Include specific context clues that help user recognize
- Always offer "Something else" escape hatch

### Phase 3: Iterative Deductive Drilling

**Continue Mapping Based on Selection**:
- Analyze user's selection as a constraint
- Generate next level of sub-possibilities
- Apply analytical frameworks to split remaining space
- Drill down until options become actionable

**Pattern**:
```
"Based on your selection of [Category X], I've analyzed the sub-patterns. Which feels most accurate?"

1. [Sub-category 1 with evidence]
2. [Sub-category 2 with evidence]
3. [Sub-category 3 with evidence]
```

### Phase 4: Solution Synthesis & Validation

**Converge to Actionable Path**:
- Synthesize insights from the navigation path
- Generate 2-3 specific, actionable recommendations
- Present as concrete next steps
- Use AskUserQuestion for final validation

**Example**: "Based on our path through [Category X] → [Sub-category Y], I see two targeted approaches:
1. **Approach 1**: [Specific action with benefits]
2. **Approach 2**: [Specific alternative]

Which feels more achievable for you?"

**Use AskUserQuestion iteratively throughout. Trust the AI agent to apply analytical frameworks comprehensively to generate ALL relevant hypotheses.**

---

## Analytical Frameworks for Possibility Mapping

Apply these frameworks to ensure ALL possibilities are explored:

### 1. Root Cause Analysis
**For debugging and problem-solving:**
- Technical factors (code, infrastructure, dependencies)
- Process factors (workflows, approvals, handoffs)
- Human factors (skills, communication, incentives)
- Environmental factors (timing, external constraints)

### 2. Decision Tree Framework
**For choice-based problems:**
- Evaluate all options against key criteria
- Consider short-term vs. long-term implications
- Map risk/benefit for each path
- Include hidden costs and opportunity costs

### 3. Constraint Mapping
**For strategic and planning problems:**
- Hard constraints (cannot change)
- Soft constraints (can be negotiated)
- Resources available (time, budget, people)
- Success metrics and definitions

### 4. Stakeholder Analysis
**For organizational and team problems:**
- Who is affected? (primary, secondary)
- What do they want? (stated vs. unstated)
- What power do they have?
- What are their constraints?

### 5. Timeline Perspective
**For decisions affecting future:**
- Immediate (0-3 months)
- Short-term (3-12 months)
- Long-term (1-3 years)
- Legacy impact (3+ years)

**Always apply at least one framework. When in doubt, use multiple frameworks to ensure comprehensive coverage.**

---

## Execution Examples

These examples demonstrate how the comprehensive thinking framework generates ALL possibilities and uses iterative AskUserQuestion:

### Example 1: Team Velocity Problem

**User**: "My team is moving too slowly and I feel stuck."

**Application of Framework**:
1. **Context Analysis**: Identify this as a team performance problem
2. **Constraint Mapping**: Team has 6 engineers, current sprint has 14 points velocity
3. **Apply Root Cause Analysis Framework**:
   - Technical: Dependencies, tool issues
   - Process: Meetings, reviews, handoffs
   - Human: Skills, motivation, communication
   - Environmental: External blockers, timeline pressure

**Question 1**: "I've analyzed your team situation using root cause framework. The data shows four distinct bottleneck patterns. Which feels most accurate?
1. **Calendar Fragmentation**: 14 hours/week in meetings (66% of work time)
2. **Review Bottleneck**: PRs averaging 2.3 days, creating wait states
3. **Task Switching**: 23 open tickets creating context switching overhead
4. **External Dependencies**: 8 tickets blocked by other teams/systems"

**User**: 1 (Calendar Fragmentation)

**Application of Framework**:
- Drill down using Constraint Mapping on calendar issues
- Analyze recurring vs. ad-hoc, necessary vs. unnecessary meetings

**Question 2**: "Breaking down your 14 hours/week of meetings, the pattern reveals three primary drivers. Which resonates most?
1. **Recurring Rituals**: 4 weekly scheduled meetings (7 hours)
2. **Ad-hoc Coordination**: 3-5 unscheduled syncs/week (4 hours)
3. **Daily Standups**: 15-min meetings that drift to 30+ (3.5 hours/week)"

**User**: 3 (Daily Standups)

**Application of Framework**:
- Root cause analysis on standup duration
- Consider meeting structure, participation, facilitation

**Question 3**: "Analyzing the standup drift from 15 to 30+ minutes, I see three common patterns. Which matches your experience?
1. **Agenda Hijacking**: Problem-solving derails the update format
2. **Over-Sharing**: Everyone reports on all tasks vs. blockers only
3. **Decision Capture**: Using standup for decisions that need dedicated time"

**User**: 2 (Over-Sharing)

**Solution Synthesis**: "Based on our path - calendar fragmentation driven by standup over-sharing - I see two targeted interventions:
1. **Format Reinforcement**: Strict "blocker-only" updates with async follow-ups
2. **Information Architecture**: Move updates to Slack/Notion, keep standup for blockers

Which feels more immediately implementable for your team?"

### Example 2: Job Decision (Time Perspective)

**User**: "Should I take the higher-paying job with long commute or lower-paying remote job?"

**Application of Framework**:
1. **Decision Tree Framework**: Map all options with criteria
2. **Timeline Perspective**: Immediate vs. long-term implications
3. **Constraint Mapping**: Hard constraints (salary, commute), soft constraints (negotiation)
4. **Root Cause Analysis**: Underlying motivations (security, growth, lifestyle)

**Variables Identified**:
- Salary difference: $20K gross, $12K net after commute costs
- Commute: 3 hours/day = 32 full work days per year
- Remote flexibility: Controls gym, cooking, evening classes
- Growth trajectory: Role A has clear promotion path

**Question 1**: "Analyzing this decision through multiple frameworks (time cost, lifestyle control, career trajectory), I see four primary decision drivers. Which resonates most?
1. **Time Economy**: 32 days/year commuting for $12K net = poor time ROI
2. **Lifestyle Sovereignty**: Remote preserves your gym/cooking/learning routines
3. **Career Acceleration**: Role A offers clearer advancement path
4. **Financial Security**: Higher salary provides stronger safety net"

**User**: 2 (Lifestyle Sovereignty)

**Application of Framework**:
- Drill down using Timeline Perspective on lifestyle control
- Consider immediate happiness vs. long-term financial goals

**Question 2**: "Focusing on lifestyle control, the salary gap presents three strategic approaches. Which aligns with your values?
1. **Outsource for Balance**: Use $12K to buy back time (meal prep, cleaning)
2. **Negotiate Hybrid**: Propose 3-2 split (remote-office) with $10K compromise
3. **Prove Then Position**: Start remote, demonstrate value, renegotiate after 6 months"

**User**: 3 (Prove Then Position)

**Solution Synthesis**: "Based on our path - lifestyle sovereignty through timeline optimization - here's a concrete strategy:
1. **Accept Remote Role**: Start with strong remote presence and performance
2. **Document Impact**: Track productivity, collaboration, output quality
3. **Market Positioning**: After 6-month review, present data + market comps for salary adjustment

This approach protects your lifestyle while creating a path to financial goals. Ready to structure the negotiation plan?"

### Example 3: Refactoring Decision

**User**: "I need to refactor this codebase but don't know where to start."

**Application of Framework**:
1. **Constraint Mapping**: Codebase has 247 files, timeline pressure, team size
2. **Root Cause Analysis**: Technical debt categories
3. **Risk-Benefit Analysis**: Which debt causes most friction vs. easiest to fix

**Variables Identified**:
- Oversized files: 89 functions over 100 lines
- Duplicated code: 156 blocks across 34 files
- Circular dependencies: 34 import cycles
- Complexity hotspots: 12 files with cyclomatic complexity >15

**Question 1**: "I've analyzed your codebase using technical debt framework. Four patterns emerge that drive maintenance friction. Which creates the most day-to-day pain?
1. **Oversized Monoliths**: utils/helpers.js at 1,847 lines (impossible to reason about)
2. **Duplication Explosion**: 156 repeated code blocks creating inconsistency risk
3. **Import Labyrinth**: 34 circular dependencies breaking module isolation
4. **Complexity Clusters**: 12 files with cognitive complexity >15"

**User**: 2 (Duplication Explosion)

**Application of Framework**:
- Drill down using Risk-Benefit Analysis on duplication patterns
- Consider frequency, impact, and ease of extraction

**Question 2**: "Analyzing the duplication patterns, three categories account for 57% of all duplication. Which offers the best ROI to tackle first?
1. **API Validation**: 32 instances of response checking logic (high risk if inconsistent)
2. **Date Formatting**: 28 instances of date manipulation (medium risk, frequent changes)
3. **Data Transformation**: 29 instances of object reshaping (low risk, library could solve)"

**User**: 1 (API Validation)

**Solution Synthesis**: "Based on our path - API validation duplication elimination - here's a concrete refactor plan:
1. **Pattern Extraction**: Audit all 32 instances to identify exact validation logic variations
2. **Utility Creation**: Build validateResponse(status, data, schema) with type safety
3. **Gradual Migration**: Replace instances in batches of 5 files with tests between each batch

This approach reduces inconsistency risk while maintaining stability. Ready to start with the validation logic audit?"

## When NOT to Use Hypothesis Generation

When users provide clear, specific requests:
- "I need a summary of these three documents"
- "Which of these two libraries is better for X?"
- "How do I fix this specific error?"

Skip hypothesis generation and provide direct synthesis or solution.

---

## Quick Reference: Framework Application Checklist

Use this checklist to ensure comprehensive possibility mapping:

### Before Asking First Question
- [ ] Deep context analysis completed (files, history, constraints)
- [ ] Problem type identified (Decision, Debugging, Strategy, Creative, Planning)
- [ ] At least one analytical framework selected
- [ ] Key variables and constraints mapped

### When Generating Options
- [ ] 3-4 distinct categories covering ALL possibilities
- [ ] Categories are mutually exclusive and collectively exhaustive
- [ ] Each option includes specific evidence and context clues
- [ ] "Something else" escape hatch provided

### For Each AskUserQuestion Iteration
- [ ] ONE question at a time
- [ ] Options numbered clearly (1, 2, 3, 4)
- [ ] Natural, conversational language
- [ ] Evidence-based reasoning for each option
- [ ] Progressive drilling down based on previous selections

### Before Solution Synthesis
- [ ] Path through possibilities documented
- [ ] Insights synthesized from navigation
- [ ] 2-3 actionable recommendations generated
- [ ] Final validation question asked

### AskUserQuestion Structure Template
```
"I've analyzed [context] using [framework]. [Number] patterns emerge covering ALL possibilities in [problem type]. Which aligns best?

1. [Option 1 - with specific evidence]
2. [Option 2 - with specific evidence]
3. [Option 3 - with specific evidence]
4. Something else entirely"
```

**Remember**: Trust the analytical frameworks. They exist to ensure ALL possibilities are explored systematically.
