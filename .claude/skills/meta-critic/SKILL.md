---
name: meta-critic
description: "Audit conversation alignment between requests, actions, and knowledge standards. Use when: quality check needed, workflow validation, standards compliance review, detecting drift. Not for creating content or executing tasks."
user-invocable: true
---

# Meta-Critic

You are an **execution skill** that audits conversation alignment and validates workflow quality against knowledge standards.

**Execution Mode**: You will be manually invoked when quality validation is needed. Your job is to:
1. **Autonomously investigate** the conversation history and execution outcomes
2. **Perform three-way comparison**: Request vs Delivery vs Standards
3. **Intelligently determine** which questions to ask and when
4. **Provide specific, actionable feedback** for improvement

## RECOMMENDED: Context Validation

Read these URLs when accuracy matters for quality validation work:

### Primary Documentation
- **Agent Skills Specification**: https://code.claude.com/docs/en/skills
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Skill structure, quality standards, best practices

- **Quality Framework**: https://code.claude.com/docs/en/skills
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: 11-dimensional quality framework, autonomy scoring

### When to Fetch vs Skip
**Fetch when**:
- Documentation may have changed since last validation
- User requests verification of quality standards
- Starting complex quality audit
- Uncertain about current best practices

**Skip when**:
- Simple validation based on known standards
- Local-only work without external dependencies
- Working offline
- Recently read and documentation is stable

**Trust your judgment**: You know when validation is needed for accurate quality assessment.

## The Loop

Execute this iterative loop. Each iteration may stop for user input — resume from that point on next turn.

### Phase 1: Autonomous Investigation & Analysis

1. **Scan Context**: Review all available information:
   - User's original request and intent
   - Actions taken by the agent
   - Outputs delivered (files created, code written, etc.)
   - Relevant knowledge-skills standards

2. **Extract Request**: Identify:
   - What was explicitly asked for
   - What constraints were specified
   - What preferences were stated
   - What goals were implied

3. **Analyze Delivery**: Review:
   - What was actually implemented
   - How it was executed
   - What deviations occurred
   - What assumptions were made

4. **Compare with Standards**: Check against:
   - knowledge-skills: Structure, Progressive Disclosure, descriptions
   - knowledge-mcp: MCP configuration patterns
   - knowledge-hooks: Hook implementation standards
   - knowledge-subagents: Agent configuration rules

5. **Identify Gaps**: Find:
   - Intent misalignment (what was asked vs what was done)
   - Standards violations (deviations from knowledge-skills)
   - Completeness issues (missing requirements)
   - Quality concerns (fragility, maintainability)

**Concrete Analysis Format**:
```markdown
## Investigation Summary

**Original Request**: [What user asked for]

**What Was Delivered**: [What agent implemented]

**Standards Check**:
- knowledge-skills: [Pass/Fail] [Specific observations]
- [Other relevant standards]: [Pass/Fail] [Notes]

**Alignment Assessment**:
- Intent: [Match/Mismatch] [Details]
- Completeness: [Complete/Incomplete] [What's missing]
- Quality: [Score/10] [Rationale]
```

### Phase 2: Iterative Clarification

**Goal**: Ask targeted questions to refine your understanding through iterative dialogue.

**When to Ask Questions**:
- Investigation reveals multiple interpretation possibilities
- Need user perspective on priorities or severity
- Want confirmation of issue classification
- Need clarification on acceptance criteria

**Question Strategy**:
- Use `AskUserQuestions` tool to ask one question at a time
- Ask questions iteratively, building on previous answers
- Allow for intermediary research or analysis between questions
- Continue asking until you have sufficient clarity to formulate feedback

**Question Flow**:
- Start with severity/prioritization if multiple issues found
- Drill down into specific issues as needed
- Ask for preferences on remediation approach
- Seek clarification on acceptance criteria
- Continue until clear direction emerges

**When NOT to Ask Questions**:
- Investigation provides complete clarity on issues
- Standards violations are unambiguous
- User explicitly requested autonomous audit
- Findings are straightforward and actionable

### Phase 3: Specific Feedback Formulation

**After Investigation** (and optional questions), formulate specific feedback:

1. **Synthesize Findings**: Organize issues by priority
2. **Classify Severity**: Critical / High / Medium / Low
3. **Craft Specific Recommendations**: Create actionable feedback
4. **Ensure Actionability**: Each recommendation must be immediately implementable

**Rule**: Recommendations must be SPECIFIC and ACTIONABLE — not abstract suggestions.

**Each recommendation must be**:
- Specific file or section to modify
- Actual text to insert or change
- Concrete example of correct pattern
- Reference to applicable knowledge-skills standard

**Format for presenting recommendations**:
```markdown
## Meta-Critic Review

### Critical Issues (Blocking)
[Specific issues with exact file locations and what to fix]

### High Priority Issues
[Specific issues with actionable recommendations]

### Medium Priority Issues
[Specific issues with improvement suggestions]

### Low Priority Issues
[Minor improvements or optimizations]
```

**Anti-pattern** — Do NOT use abstract labels:
- ❌ "Fix description" — Too vague
- ✅ "SKILL.md line 5: Change description to follow What-When-Not format" — Specific
- ❌ "Improve structure" — Category not action
- ✅ "Move this content to references/ to meet Progressive Disclosure" — Specific

### Phase 4: User Confirmation & Exit

1. **Present Findings**: Show organized review with clear severity classification
2. **Offer Next Steps**: Ask if user wants immediate fixes or just feedback
3. **Apply Changes** (if requested):
   - For individual fixes: Use Edit tool directly
   - For comprehensive fixes: Create orchestration plan using TaskList tools
4. **Verify**: Read files to confirm changes are correct
5. **Exit**: When user confirms review is complete

**Completion Marker**: `## META_CRITIC_COMPLETE`

## Analysis Dimensions

### 1. Intent Alignment

**Question**: Did the execution match what was originally requested?

**Scoring**:
- 10/10: Perfect alignment, exact match
- 8-9/10: Minor variations, core intent met
- 6-7/10: Some drift, mostly aligned
- <6/10: Significant misalignment

**Check Process**:
1. Extract user's original request
2. Identify stated goals and constraints
3. Compare actual deliverable against intent
4. Note any scope drift or misinterpretation

### 2. Standards Compliance

**Question**: Does the output comply with relevant knowledge-skills?

**Scoring**:
- 10/10: Full compliance, all standards met
- 8-9/10: Minor deviations, non-critical
- 6-7/10: Some violations, needs attention
- <6/10: Major standard violations

**Check Process**:
1. Identify applicable knowledge-skills
2. Extract relevant standards
3. Validate deliverable against standards
4. Note any violations or deviations

### 3. Completeness

**Question**: Were all requirements addressed?

**Scoring**:
- 10/10: All requirements met, plus enhancements
- 8-9/10: All explicit requirements met
- 6-7/10: Minor gaps, mostly complete
- <6/10: Significant missing requirements

**Check Process**:
1. List explicit requirements from request
2. List implicit requirements (inferred from context)
3. Verify each requirement has deliverable
4. Identify missing or incomplete items

### 4. Quality

**Question**: Is the work production-ready?

**Scoring**:
- 10/10: Production-ready, best practices
- 8-9/10: High quality, minor polish needed
- 6-7/10: Functional, needs improvement
- <6/10: Poor quality, significant work needed

**Check Process**:
1. Evaluate code quality (structure, naming, patterns)
2. Check documentation completeness
3. Verify testing/verification performed
4. Assess maintainability

## Issue Classification

### Critical (Blocking)
- Security vulnerabilities
- Standard violations that break functionality
- Complete misalignment with request
- Missing core requirements

### High Priority
- Significant drift from standards
- Incomplete implementation
- Quality issues affecting reliability

### Medium Priority
- Minor standard deviations
- Documentation gaps
- Code quality improvements

### Low Priority
- Cosmetic issues
- Nice-to-have enhancements
- Minor optimizations

## Critical Rules

### Autonomous Investigation
- **Investigate thoroughly**: Scan conversation, context, and standards before asking questions
- **Compare three ways**: Request vs Delivery vs Standards
- **Focus on alignment**: Did execution match intent and standards?
- **Be comprehensive**: Check all applicable knowledge-skills
- **Be intelligent**: Use your judgment to determine what questions to ask and when

### Question Strategy
- **Investigate first**: Build understanding through thorough scanning
- **Ask what matters**: Determine which questions are relevant based on your investigation
- **Use AskUserQuestions**: Ask one question at a time when you need clarification
- **Adapt to context**: Let the situation guide your questioning approach
- **Trust your judgment**: Ask questions that will genuinely help resolve the issues
- **Be flexible**: Adjust strategy based on what you learn from each response

### Feedback Quality
- **Show the exact issue**: Recommendations must identify specific files and lines
- **No abstract categories**: Don't use "Improve quality" — describe the actual fix
- **Immediately actionable**: User should see exactly what needs to change
- **Reference standards**: Cite applicable knowledge-skills for context
- **Prioritize issues**: Organize by severity (Critical/High/Medium/Low)

### Quality Standards
- **Evidence-based**: Only critique what actually happened
- **Standards-referenced**: Cite specific knowledge-skills when applicable
- **Constructive tone**: Focus on improvement, not criticism
- **Actionable output**: Every issue should have clear remediation steps

## Examples

### Example 1: Post-Factory Review

**Context**: After create-skill execution for Docker log scanner

**Phase 1: Autonomous Investigation**

**Original Request**: "I need a skill to scan my Docker logs and alert on critical errors."

**What Was Delivered**:
- Skill: docker-log-scanner
- Context: fork (appropriate for verbose task)
- Scripts: scripts/scan_logs.py
- Structure: Valid YAML, <500 lines

**Standards Check**:
- knowledge-skills: ✅ Pass - Valid structure, proper description
- knowledge-subagents: ✅ Pass - Correct use of fork context
- Script quality: ⚠️ Missing error handling

**Alignment Assessment**:
- Intent: ✅ Match - Docker log scanning capability created
- Completeness: ⚠️ Alert mechanism mentioned but not implemented
- Quality: 7/10 - Good structure, script needs validation

**Phase 2: Iterative Clarification**

Only one issue (alert mechanism), so proceed directly to feedback.

**Phase 3: Specific Feedback**

```markdown
## Meta-Critic Review

### High Priority Issues

**Missing Alert Implementation**
- **File**: docker-log-scanner/SKILL.md
- **Issue**: Alert mechanism mentioned in description but not implemented
- **Fix**: Either:
  1. Remove "alert on critical errors" from description, OR
  2. Add alert configuration and delivery mechanism

**Recommendation**: Since alerting is core to user's request, implement it:
- Add alert configuration parameters (webhook URL, email, etc.)
- Document alert delivery mechanism in scripts/scan_logs.py
- Add example alert configuration

### Medium Priority Issues

**Script Error Handling**
- **File**: scripts/scan_logs.py
- **Issue**: No input validation or error handling
- **Standard**: knowledge-skills references/script-best-practices.md
- **Fix**: Add:
  - File existence validation
  - Permission checks
  - Error handling with meaningful messages
  - Exit codes (0=success, 1=input error, 2=system error)
```

### Example 2: Standards Drift Detection

**Context**: MCP server configuration for web search

**Phase 1: Autonomous Investigation**

**Original Request**: "Add an MCP server for web search capabilities."

**What Was Delivered**:
- .mcp.json updated with exa MCP
- Transport: stdio
- Command: npx

**Standards Check**:
- knowledge-mcp: ⚠️ Fail - stdio used for cloud service
- Standard specifies: "Use streamable-http for cloud/production"
- stdio intended for local development

**Alignment Assessment**:
- Intent: ✅ Match - Web search capability added
- Completeness: ✅ Complete
- Quality: 6/10 - Functional but not optimal for production

**Phase 2: Iterative Clarification**

Unambiguous standards violation, proceed to feedback.

**Phase 3: Specific Feedback**

```markdown
## Meta-Critic Review

### High Priority Issues

**Suboptimal Transport Choice**
- **File**: .mcp.json
- **Issue**: stdio transport used for cloud service (exa MCP)
- **Standard**: knowledge-mcp references/transport-mechanisms.md
- **Correct Pattern**: "Use streamable-http for cloud/production services"

**Specific Fix**:
```json
{
  "mcpServers": {
    "exa": {
      "transport": {
        "type": "streamable-http",
        "url": "https://api.exa.ai"
      }
    }
  }
}
```

**Rationale**: stdio has higher latency and resource usage for cloud services. streamable-http is designed for production cloud integrations.

### Quality Impact
- Current: Functional but slower
- After fix: Optimized for production use
```

### Example 3: Intent Misalignment

**Context**: API development workflow

**Phase 1: Autonomous Investigation**

**Original Request**: "Create RESTful API endpoints for user management."

**What Was Delivered**:
- GraphQL endpoints instead of RESTful
- Agent reasoned: "GraphQL is more modern"

**Standards Check**: N/A - wrong technology entirely

**Alignment Assessment**:
- Intent: ❌ Complete mismatch
- Completeness: Functional but wrong architecture
- Quality: 8/10 - Good GraphQL, but not what was asked

**Phase 2: Iterative Clarification**

**Q1**: "I notice GraphQL was implemented instead of RESTful API as requested. Should I:"
- A) Rebuild as RESTful API per original request
- B) Keep GraphQL and document the architectural change
- C) Discuss the trade-offs between both approaches

→ User selects A

**Phase 3: Specific Feedback**

```markdown
## Meta-Critic Review

### Critical Issues (Blocking)

**Technology Mismatch**
- **Issue**: GraphQL implemented when RESTful API was requested
- **Root Cause**: Agent made architectural decision without consultation
- **Impact**: Delivered solution does not match user's intent

**Required Action**: Rebuild as RESTful API per original request

**Process Improvement**:
When architectural alternatives exist, ASK USER before deviating from request.
- Trust user's stated requirements
- Offer alternatives as questions, not decisions
- Implement what was requested, not what agent prefers

### Quality Standards Referenced
- knowledge-skills: "What-When-Not descriptions must signal purpose"
- learn-skill: "Identify where skill instructions allowed misinterpretation"
```

## META_CRITIC_COMPLETE
