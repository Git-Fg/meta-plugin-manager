---
name: refine-rules
description: "Analyze CLAUDE.md and .claude/rules for quality, consistency, and best practices. Identify gaps, redundancies, and alignment issues with prioritized recommendations."
disable-model-invocation: true
---

<mission_control>
<objective>Analyze CLAUDE.md and .claude/rules for quality, consistency, and best practices</objective>
<success_criteria>Prioritized refinement report with critical/high/medium/low issues and specific file:line references</success_criteria>
</mission_control>

# Refine Rules Command

Global analysis and refinement of project rules (CLAUDE.md and .claude/rules).

## What This Command Does

Perform comprehensive analysis of all project memory files:

1. **Discovery Phase** - Find all CLAUDE.md and .claude/rules files
2. **Quality Analysis** - Check each file against best practices
3. **Consistency Check** - Identify contradictions and overlaps
4. **Gap Analysis** - Find missing critical content
5. **Delta Assessment** - Identify zero/negative delta content
6. **Refinement Plan** - Generate prioritized recommendations

## How It Works

### Phase 1: Discovery

Scan the project for all memory files:

- `Bash: find . -name "CLAUDE.md" -type f 2>/dev/null` → Find all CLAUDE.md locations
- `Bash: find .claude/rules -name "*.md" -type f 2>/dev/null` → Find all .claude/rules files
- `Bash: find .claude/rules -type l 2>/dev/null` → Check for symlinks

### Phase 2: Quality Analysis

For each file, analyze:

**CLAUDE.md checks**:

- [ ] Length: 40-150 lines (beyond whitespace/tables)
- [ ] Answers WHAT (project structure), WHY (purpose), HOW (commands)
- [ ] Uses progressive disclosure (pointers to docs)
- [ ] No duplication of README or generic tutorials
- [ ] Includes verification criteria
- [ ] Tables for rules/skills overview (if applicable)
- [ ] No linter-style rules (use real tools instead)

**.claude/rules checks**:

- [ ] One topic per file
- [ ] Descriptive filename
- [ ] Self-contained (no external references)
- [ ] Paths frontmatter only if truly path-specific
- [ ] Examples included directly
- [ ] Focused and specific

### Phase 3: Consistency Check

Identify issues across all files:

**Content conflicts**:

- Contradictory rules (e.g., "use 2-space indent" vs "use 4-space indent")
- Overlapping coverage (same concept documented multiple times)
- Outdated information (commands that no longer work, changed paths)

**Structural issues**:

- Deep nesting in .claude/rules/ (consider flattening)
- Mixed conventions (some files use paths frontmatter, similar ones don't)
- Inconsistent formatting or voice

### Phase 4: Gap Analysis

Identify missing critical content:

**Common gaps**:

- No CLAUDE.md at all
- CLAUDE.md missing HOW (commands for test/lint/build)
- No security rule for projects handling sensitive data
- No testing rule for test-heavy projects
- Missing verification criteria in CLAUDE.md

**Priority gaps** (by project type):

- Backend projects: API rules, security requirements
- Frontend projects: Component conventions, accessibility
- Full-stack: Both sets, plus data flow rules

### Phase 5: Delta Assessment

Apply the Delta Standard:

> Good project memory = Project-specific knowledge − What Claude Already Knows

**Zero/Negative Delta (remove)**:

- General programming concepts ("how to write a function")
- Standard library documentation ("what Array.map does")
- Common patterns Claude already knows
- Generic tutorials or how-to guides
- Obvious best practices

**Positive Delta (keep)**:

- Project-specific architecture decisions
- Domain expertise not in general training
- Non-obvious bug workarounds
- Team-specific conventions
- Local environment quirks
- Tech stack choices (bun vs node, pnpm vs npm)

### Phase 6: Refinement Plan

Generate prioritized recommendations:

**Priority Levels**:

- **CRITICAL**: Security issues, destructive operations, broken workflows
- **HIGH**: Quality issues, significant gaps, major contradictions
- **MEDIUM**: Minor inconsistencies, missing helpful content
- **LOW**: Nice-to-haves, polish, organization improvements

**Output Format**:

```
# Rules Refinement Report

## Summary
- Total files analyzed: X
- CLAUDE.md files: X
- .claude/rules files: X
- Issues found: X (Y critical, Z high)

## Critical Issues (Fix Immediately)
1. [Issue] - File:line - Impact and recommendation

## High Priority Issues
1. [Issue] - File:line - Impact and recommendation

## Medium Priority Issues
1. [Issue] - File:line - Impact and recommendation

## Low Priority Issues
1. [Issue] - File:line - Impact and recommendation

## Content to Remove (Zero/Negative Delta)
1. [Content] - File:line - Why it's zero delta

## Gaps Identified
1. [Missing content] - Recommended location

## Positive Patterns Found
1. [Good pattern] - File - Consider replicating

## Recommended Actions
1. [Action] - Priority - Estimated effort
```

## Example Usage

```
User: /refine-rules

Agent:
# Rules Refinement Report

## Summary
- Total files analyzed: 8
- CLAUDE.md files: 1 (./CLAUDE.md)
- .claude/rules files: 7
- Issues found: 12 (1 critical, 4 high, 5 medium, 2 low)

## Critical Issues (Fix Immediately)

1. **Security rule missing**
   - Impact: Project handles PII but has no security requirements
   - Recommendation: Create .claude/rules/security.md with:
     - Secrets handling requirements
     - PII data handling checklist
     - Auth/authorization patterns
   - Reference: claude-md-development skill for examples

## High Priority Issues

1. **CLAUDE.md too long**
   - File: ./CLAUDE.md (247 lines)
   - Impact: Claude ignores verbose context
   - Recommendation: Reduce to 80-100 lines, move details to docs/

2. **Duplicate content: testing patterns**
   - Files: CLAUDE.md:45-60, .claude/rules/testing.md:10-25
   - Impact: Maintenance burden, content drift risk
   - Recommendation: Keep in .claude/rules/testing.md, reference from CLAUDE.md

3. **Zero delta content in api-style.md**
   - File: .claude/rules/api-style.md:30-45
   - Content: "What is REST API" (generic explanation)
   - Recommendation: Remove generic content, keep project-specific patterns only

## Medium Priority Issues

1. **Inconsistent indentation rules**
   - Files: typescript.md says "2 spaces", react.md says "4 spaces"
   - Recommendation: Standardize on one convention

2. **Missing verification criteria**
   - File: CLAUDE.md
   - Recommendation: Add section with commands for test/lint/typecheck

## Content to Remove (Zero/Negative Delta)

1. **Generic TypeScript tutorial**
   - File: .claude/rules/typescript.md:1-40
   - Why: Claude knows TypeScript basics from training
   - Keep: Project-specific type patterns only

2. **How to write unit tests**
   - File: .claude/rules/testing.md:5-20
   - Why: Claude knows testing fundamentals
   - Keep: Project-specific test organization and MSW patterns

## Gaps Identified

1. **No API design rule**
   - Current: API endpoints implemented inconsistently
   - Recommended: .claude/rules/api-design.md with error response format, versioning

2. **No file size limits**
   - Current: Some files > 1000 lines
   - Recommended: .claude/rules/file-size-limits.md with ~300 line target

## Positive Patterns Found

1. **Security rule with specific checklist**
   - File: .claude/rules/security.md
   - Pattern: Concrete PII handling steps
   - Consider: Replicating for other domains (testing, API design)

2. **CLAUDE.md uses tables effectively**
   - File: ./CLAUDE.md
   - Pattern: Clear rules/skills overview table
   - Consider: Maintaining this format

## Recommended Actions

1. Create .claude/rules/security.md - CRITICAL - 30 min
2. Reduce CLAUDE.md to 100 lines - HIGH - 1 hour
3. Remove duplicate testing content - HIGH - 15 min
4. Standardize indentation rules - MEDIUM - 15 min
5. Add verification criteria to CLAUDE.md - MEDIUM - 10 min
6. Create .claude/rules/api-design.md - LOW - 30 min
7. Create .claude/rules/file-size-limits.md - LOW - 15 min

Total estimated effort: ~3 hours

Would you like me to implement any of these recommendations?
```

## Important Notes

- **CRITICAL**: This command only analyzes and reports. It does NOT modify files.
- **Manual review required**: Always review recommendations before applying.
- **Context dependencies**: Some rules may reference external docs - flag these for portability review.
- **Team decisions**: Some inconsistencies may be intentional (different conventions for different parts of codebase).

## Integration with Other Commands

After refinement:

- Use `/refine-prompts` to improve any vague rule language
- Use claude-md-development skill for detailed guidance on specific improvements
- Use `qa/verify` to ensure changes don't break existing workflows

## Related Skills

This command uses knowledge from:

- `claude-md-development` - CLAUDE.md and rules best practices
- `quality-standards` - Quality validation framework
- `refine-prompts` - L1/L2/L3/L4 prompt refinement

## Arguments

This command does not interpret special arguments. Everything after `/refine-rules` is treated as additional context for the analysis.

**Optional context you can provide**:

- Specific concerns ("focus on security rules")
- Scope limits ("only analyze backend rules")
- Priority areas ("emphasize testing gaps")

---

<critical_constraint>
MANDATORY: Never modify files during analysis - only report findings
MANDATORY: Provide file:line references for every issue identified
MANDATORY: Prioritize issues by severity (Critical/High/Medium/Low)
MANDATORY: Apply Delta Standard - flag zero/negative delta content
No exceptions. Analysis must be comprehensive, accurate, and non-destructive.
</critical_constraint>
