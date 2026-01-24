# Validation Checklist

## Table of Contents

- [Pre-Review Validation](#pre-review-validation)
- [Structural Validation](#structural-validation)
- [Skills Validation](#skills-validation)
- [RECOMMENDED: Context Validation](#recommended-context-validation)
- [Commands Validation](#commands-validation)
- [Agents Validation](#agents-validation)
- [Hooks Validation](#hooks-validation)
- [MCP Validation](#mcp-validation)
- [Standards Compliance](#standards-compliance)
- [Quality Metrics](#quality-metrics)
- [Validation Scripts](#validation-scripts)
- [Review Completion Checklist](#review-completion-checklist)

## Pre-Review Validation

### Plugin Existence
- [ ] Plugin directory exists
- [ ] Plugin path is accessible
- [ ] Read permissions granted
- [ ] Plugin.json present

**Verification**:
```bash
ls -la /path/to/plugin/
# Should show: .claude-plugin/, skills/, etc.

cat /path/to/plugin/.claude-plugin/plugin.json
# Should show valid JSON
```

### Environment Readiness
- [ ] Review tools available
- [ ] No active modifications
- [ ] Backup created (recommended)
- [ ] Review mode selected

---

## Structural Validation

### Plugin Manifest
- [ ] `.claude-plugin/plugin.json` exists
- [ ] Valid JSON format
- [ ] Required fields present
- [ ] Version specified
- [ ] Description included

**Checklist**:
```json
{
  "name": "plugin-name",           ✅ Present
  "version": "X.Y.Z",              ✅ Present
  "description": "...",            ✅ Present
  "repository": "URL",            ✅ Present
  "license": "MIT",               ✅ Present
  "category": "development",      ✅ Present
  "keywords": [...]               ✅ Present
}
```

### Directory Structure
- [ ] Skills directory present
- [ ] Commands directory (if needed)
- [ ] Agents directory (if needed)
- [ ] Hooks directory (if needed)
- [ ] MCP directory (if needed)

**Standard Structure**:
```
plugin/
├── .claude-plugin/
│   └── plugin.json               ✅ Required
├── skills/                       ✅ Required
│   ├── skill-1/
│   └── skill-2/
├── commands/                     ⚠️ Optional
├── agents/                       ⚠️ Optional
├── hooks/                        ⚠️ Optional
└── mcp/                          ⚠️ Optional
```

### Naming Conventions
- [ ] Lowercase directory names
- [ ] Hyphenated compound names
- [ ] No spaces or special chars
- [ ] Consistent naming pattern

---

## Skills Validation

### YAML Frontmatter
- [ ] Name field present
- [ ] Description field present
- [ ] Valid YAML syntax
- [ ] Description follows WHAT + WHEN + NOT

**Template**:
```yaml
---
name: skill-name                     ✅ Required
description: "Create X using Y. Use when Z. Do not use for W."
user-invocable: true                 ⚠️ Optional
disable-model-invocation: true       ⚠️ Optional
---
```

## RECOMMENDED: Context Validation

### Recommended URLs
- [ ] URL sections present (RECOMMENDED pattern)
- [ ] 2026-compliant URLs
- [ ] Official documentation links
- [ ] Cache time specified
- [ ] "When to Fetch vs Skip" guidance included
- [ ] Trust AI judgment statement present

**Recommended Sections**:
```markdown
## RECOMMENDED: Context Validation

Read these URLs when accuracy matters for skill work:

### Primary Documentation
- **Official Skills Guide**: https://code.claude.com/docs/en/skills
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Skills architecture, progressive disclosure

### When to Fetch vs Skip
**Fetch when**: Documentation may have changed, user requests verification
**Skip when**: Simple modifications, local-only work, recently read

**Trust your judgment**: You know when validation is needed.
```

### Trigger Quality
- [ ] Specific and actionable
- [ ] Uses WHAT + WHEN + NOT formula
- [ ] Avoids generic terms
- [ ] Clear activation conditions

**Good Trigger**:
```
"Create skills following Agent Skills open standard.
Use when building self-sufficient, autonomous capabilities.
Do not use for general programming or non-Claude contexts."
```

**Bad Trigger**:
```
"Helps with coding"
```

### Progressive Disclosure
- [ ] Tier 1: Metadata (~100 tokens)
- [ ] Tier 2: Core instructions (<35k chars)
- [ ] Tier 3: Supporting files (unlimited)
- [ ] Content appropriately tiered

**Structure**:
```
Tier 1 (SKILL.md top):
- Name, description
- Key concepts (brief)
- Quick decision tree

Tier 2 (SKILL.md body):
- Implementation workflow
- Detailed instructions
- Examples

Tier 3 (references/):
- Supporting documentation
- Additional resources
- Historical context
```

### Autonomy
- [ ] Can complete 80-95% autonomously
- [ ] Clear success criteria
- [ ] Minimal user interaction
- [ ] Self-contained logic

---

## Commands Validation

### Format Compliance
- [ ] Markdown format
- [ ] Proper headers
- [ ] Code blocks formatted
- [ ] Links functional

### Auto-Discovery
- [ ] Discoverable via /menu
- [ ] Clear command name
- [ ] Useful description
- [ ] Example usage provided

### Workflow Clarity
- [ ] Step-by-step instructions
- [ ] Clear action items
- [ ] Expected outcomes defined
- [ ] Error handling included

---

## Agents Validation

### System Prompts
- [ ] Well-defined prompts
- [ ] Clear role definition
- [ ] Specific capabilities
- [ ] Boundaries specified

### Coordination Patterns
- [ ] Pattern appropriate for use case
- [ ] Context: fork used correctly
- [ ] Isolation justified
- [ ] Parallelism beneficial

### Autonomy Definition
- [ ] Agent independence clear
- [ ] Decision-making authority
- [ ] Escalation criteria
- [ ] Success metrics

---

## Hooks Validation

### Configuration
- [ ] Valid hooks.json
- [ ] Event types correct
- [ ] Triggers appropriate
- [ ] Actions defined

### Security
- [ ] Input validation
- [ ] Output sanitization
- [ ] Permission checks
- [ ] Error handling

### Effectiveness
- [ ] Automation valuable
- [ ] Event matching precise
- [ ] Performance acceptable
- [ ] Necessary integration

---

## MCP Validation

### Protocol Compliance
- [ ] MCP version specified
- [ ] Transport configured
- [ ] Tools defined
- [ ] Resources listed

### Integration
- [ ] Server configuration
- [ ] Connection tested
- [ ] Error handling
- [ ] Performance acceptable

---

## Standards Compliance

### URL Currency
- [ ] All URLs current (2026)
- [ ] Official documentation
- [ ] No broken links
- [ ] Cache times specified

**Required URLs**:
- Skills: https://code.claude.com/docs/en/skills
- Commands: https://code.claude.com/docs/en/cli-reference
- Subagents: https://code.claude.com/docs/en/sub-agents
- Hooks: https://code.claude.com/docs/en/hooks
- Plugins: https://code.claude.com/docs/en/plugins

### Best Practices
- [ ] Follows official standards
- [ ] Implements security measures
- [ ] Uses recommended patterns
- [ ] Avoids anti-patterns

---

## Quality Metrics

### Structural (30 points)
- [ ] Architecture compliance (10/10)
- [ ] Directory structure (10/10)
- [ ] Progressive disclosure (10/10)

### Components (50 points)
- [ ] Skill quality (15/15)
- [ ] Command quality (10/10)
- [ ] Agent quality (10/10)
- [ ] Hook quality (10/10)
- [ ] MCP quality (5/5)

### Standards (20 points)
- [ ] URL currency (10/10)
- [ ] Best practices (10/10)

### Total Score
- [ ] 9.0-10.0: Excellent
- [ ] 7.0-8.9: Good
- [ ] 5.0-6.9: Fair
- [ ] 3.0-4.9: Poor
- [ ] 0.0-2.9: Failing

---

## Validation Scripts

**Use the toolkit-quality-validator skill for automated validation:**

```bash
/toolkit-quality-validator /path/to/project
```

This provides comprehensive quality scoring (0-10 scale) with:
- Structural compliance assessment
- Component quality evaluation
- Standards adherence checking
- Actionable recommendations

For CI/CD integration, use the audit command:

```bash
/toolkit-architect audit .claude/ --quick
```

# Standards (30 points)
VALID_URLS=$(find skills -maxdepth 1 -type d -not -name "skills" -exec sh -c 'if grep -q "https://code.claude.com\|https://agentskills.io" "$1/SKILL.md" 2>/dev/null; then echo 1; fi' _ {} \; | wc -l)
if [ $TOTAL_SKILLS -gt 0 ]; then
    URL_SCORE=$(($VALID_URLS * 30 / $TOTAL_SKILLS))
    ((SCORE+=URL_SCORE))
fi

QUALITY_SCORE=$(echo "scale=1; $SCORE / 10" | bc)
echo "Quality Score: $QUALITY_SCORE/10"
```

---

## Review Completion Checklist

### Pre-Review
- [ ] Plugin exists and accessible
- [ ] Review mode selected
- [ ] Tools ready
- [ ] Environment prepared

### During Review
- [ ] All components checked
- [ ] Issues documented
- [ ] Score calculated
- [ ] Recommendations generated

### Post-Review
- [ ] Report generated
- [ ] Findings reviewed
- [ ] Actions prioritized
- [ ] Next steps defined

### Validation Passed
- [ ] All checks complete
- [ ] Score >= 7.0
- [ ] No critical issues
- [ ] Ready for use
