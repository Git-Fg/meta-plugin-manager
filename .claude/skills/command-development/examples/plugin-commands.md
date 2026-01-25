# Plugin Command Examples

Practical examples of commands designed for Claude Code plugins, demonstrating plugin-specific patterns and features.

**Design Philosophy:** These examples demonstrate high-trust commands that specify WHAT to achieve, then let Claude determine HOW based on context.

## Table of Contents

1. [Simple Plugin Command](#1-simple-plugin-command)
2. [Script-Based Analysis](#2-script-based-analysis)
3. [Template-Based Generation](#3-template-based-generation)
4. [Multi-Script Workflow](#4-multi-script-workflow)
5. [Configuration-Driven Deployment](#5-configuration-driven-deployment)
6. [Agent Integration](#6-agent-integration)
7. [Skill Integration](#7-skill-integration)
8. [Multi-Component Workflow](#8-multi-component-workflow)

---

## 1. Simple Plugin Command

**Use case:** Basic command that uses plugin script

**File:** `commands/analyze.md`

```markdown
---
description: Analyze code quality using plugin tools
argument-hint: [file-path]
allowed-tools: Bash(node:*), Read
---

Analysis results:
!`node ${CLAUDE_PLUGIN_ROOT}/scripts/quality-check.js $1`

Review the analysis output above and provide:
1. Summary of findings
2. Priority issues to address
3. Suggested improvements
4. Code quality score interpretation
```

**Key features:**
- Uses `${CLAUDE_PLUGIN_ROOT}` for portable path
- Gathers context with `!` then trusts Claude to interpret
- Simple single-purpose command

---

## 2. Script-Based Analysis

**Use case:** Run comprehensive analysis using multiple plugin scripts

**File:** `commands/full-audit.md`

```markdown
---
description: Complete code audit using plugin suite
argument-hint: [directory]
model: sonnet
---

Running complete audit on $1:

**Analysis results:**
!`bash ${CLAUDE_PLUGIN_ROOT}/scripts/security-scan.sh $1`
!`bash ${CLAUDE_PLUGIN_ROOT}/scripts/perf-analyze.sh $1`
!`bash ${CLAUDE_PLUGIN_ROOT}/scripts/best-practices.sh $1`

Analyze all results above and create comprehensive report including:
- Critical issues requiring immediate attention
- Performance optimization opportunities
- Security vulnerabilities and fixes
- Overall health score and recommendations
```

**Key features:**
- Multiple script executions for context gathering
- Trusts Claude to synthesize results
- Clear reporting structure

---

## 3. Template-Based Generation

**Use case:** Generate documentation following plugin template

**File:** `commands/gen-api-docs.md`

```markdown
---
description: Generate API documentation from template
argument-hint: [api-file]
---

Template structure: @${CLAUDE_PLUGIN_ROOT}/templates/api-documentation.md
API implementation: @$1

Generate complete API documentation following the template structure above.

Ensure documentation includes:
- Endpoint descriptions with HTTP methods
- Request/response schemas
- Authentication requirements
- Error codes and handling
- Usage examples with curl commands
- Rate limiting information

Format output as markdown suitable for README or docs site.
```

**Key features:**
- Uses plugin template via file reference
- Combines template with source file
- Standardized output format
- Trusts Claude to follow template structure

---

## 4. Multi-Script Workflow

**Use case:** Orchestrate build, test, and deploy workflow

**File:** `commands/release.md`

```markdown
---
description: Execute complete release workflow
argument-hint: [version]
---

Executing release workflow for version $1:

**Workflow status:**
!`bash ${CLAUDE_PLUGIN_ROOT}/scripts/pre-release-check.sh $1`
!`bash ${CLAUDE_PLUGIN_ROOT}/scripts/build-release.sh $1`
!`bash ${CLAUDE_PLUGIN_ROOT}/scripts/run-tests.sh`
!`bash ${CLAUDE_PLUGIN_ROOT}/scripts/package.sh $1`

Based on the outputs above, report:
1. Any failures or warnings
2. Build artifacts location
3. Test results summary
4. Next steps for deployment
5. Rollback plan if needed
```

**Key features:**
- Multi-step workflow
- Sequential script execution for context gathering
- Trusts Claude to interpret results and guide next steps

---

## 5. Configuration-Driven Deployment

**Use case:** Deploy using environment-specific plugin configuration

**File:** `commands/deploy.md`

```markdown
---
description: Deploy application to environment
argument-hint: [environment]
---

Deployment configuration for $1: @${CLAUDE_PLUGIN_ROOT}/config/$1-deploy.json

Current context:
!`git rev-parse --short HEAD`
!`cat package.json | grep -E '(name|version)'`

Deploy to $1 environment using the configuration above.

Determine and execute appropriate deployment steps, then verify success.
```

**Key features:**
- Environment-specific configuration via file reference
- Dynamic config file loading
- Context gathering via `!`
- Trusts Claude to execute deployment appropriately

---

## 6. Agent Integration

**Use case:** Command that launches plugin agent for complex task

**File:** `commands/deep-review.md`

```markdown
---
description: Deep code review using plugin agent
argument-hint: [file-or-directory]
---

Initiate comprehensive code review of @$1 using the code-reviewer agent.

The agent will perform:
1. **Static analysis** - Check for code smells and anti-patterns
2. **Security audit** - Identify potential vulnerabilities
3. **Performance review** - Find optimization opportunities
4. **Best practices** - Ensure code follows standards
5. **Documentation check** - Verify adequate documentation

The agent has access to:
- Plugin's linting rules: ${CLAUDE_PLUGIN_ROOT}/config/lint-rules.json
- Security checklist: ${CLAUDE_PLUGIN_ROOT}/checklists/security.md
- Performance guidelines: ${CLAUDE_PLUGIN_ROOT}/docs/performance.md

Note: This uses the Task tool to launch the plugin's code-reviewer agent for thorough analysis.
```

**Key features:**
- Delegates to plugin agent
- Documents agent capabilities
- References plugin resources
- Clear scope definition

---

## 7. Skill Integration

**Use case:** Command that leverages plugin skill for specialized knowledge

**File:** `commands/document-api.md`

```markdown
---
description: Document API following plugin standards
argument-hint: [api-file]
---

API source code: @$1

Generate API documentation following the plugin's API documentation standards.

Use the api-docs-standards skill to ensure:
- **OpenAPI compliance** - Follow OpenAPI 3.0 specification
- **Consistent formatting** - Use plugin's documentation style
- **Complete coverage** - Document all endpoints and schemas
- **Example quality** - Provide realistic usage examples
- **Error documentation** - Cover all error scenarios

The skill provides:
- Standard documentation templates
- API documentation best practices
- Common patterns for this codebase
- Quality validation criteria

Generate production-ready API documentation.
```

**Key features:**
- Invokes plugin skill by name
- Documents skill purpose
- Clear expectations
- Leverages skill knowledge

---

## 8. Multi-Component Workflow

**Use case:** Complex workflow using agents, skills, and scripts

**File:** `commands/complete-review.md`

```markdown
---
description: Comprehensive review using all plugin components
argument-hint: [file-path]
allowed-tools: Bash(node:*), Read
---

Target file: @$1

Execute comprehensive review:

**Static Analysis Results:**
!`node ${CLAUDE_PLUGIN_ROOT}/scripts/lint.js $1`

**Phase 1:** Static analysis complete above

**Phase 2:** Launch the code-quality-reviewer agent for detailed analysis.

**Phase 3:** Use the coding-standards skill to validate adherence to standards.

**Phase 4:** Report Template
Template: @${CLAUDE_PLUGIN_ROOT}/templates/review-report.md

Compile all findings into comprehensive report following the template above.
```

**Key features:**
- Multi-phase workflow
- Combines scripts, agents, skills
- Template-based reporting
- Trusts Claude to coordinate components

---

## Common Patterns Summary

### Pattern: Plugin Script Execution (Context Gathering)
```markdown
!`node ${CLAUDE_PLUGIN_ROOT}/scripts/script-name.js $1`

Review the output above and...
```
Use for: Running plugin scripts to gather context for Claude to interpret

### Pattern: Plugin Configuration Loading (File Reference)
```markdown
@${CLAUDE_PLUGIN_ROOT}/config/config-name.json

Use the configuration above to...
```
Use for: Loading plugin configuration files as context

### Pattern: Plugin Template Usage (File Reference)
```markdown
@${CLAUDE_PLUGIN_ROOT}/templates/template-name.md

Generate documentation following the template above.
```
Use for: Using plugin templates for generation

### Pattern: Agent Invocation
```markdown
Launch the [agent-name] agent for [task description].
```
Use for: Delegating complex tasks to plugin agents

### Pattern: Skill Reference
```markdown
Use the [skill-name] skill to ensure [requirements].
```
Use for: Leveraging plugin skills for specialized knowledge

---

## Development Tips

### Testing Plugin Commands

1. **Test with plugin installed:**
   ```bash
   cd /path/to/plugin
   claude /command-name args
   ```

2. **Verify ${CLAUDE_PLUGIN_ROOT} expansion:**
   ```bash
   # Add debug output to command
   !`echo "Plugin root: ${CLAUDE_PLUGIN_ROOT}"`
   ```

3. **Test across different working directories:**
   ```bash
   cd /tmp && claude /command-name
   cd /other/project && claude /command-name
   ```

### Common Mistakes to Avoid

1. **Using relative paths instead of ${CLAUDE_PLUGIN_ROOT}:**
   ```markdown
   # Wrong
   !`node ./scripts/analyze.js`

   # Correct
   !`node ${CLAUDE_PLUGIN_ROOT}/scripts/analyze.js`
   ```

2. **Over-orchestrating with bash:**
   ```markdown
   # Wrong - Scripts entire workflow
   !`bash ${CLAUDE_PLUGIN_ROOT}/scripts/step1.sh`
   !`bash ${CLAUDE_PLUGIN_ROOT}/scripts/step2.sh`
   !`bash ${CLAUDE_PLUGIN_ROOT}/scripts/step3.sh`
   Now compile results...

   # Better - Gather context, trust Claude
   !`bash ${CLAUDE_PLUGIN_ROOT}/scripts/gather-context.sh`

   Analyze the output above and determine next steps...
   ```

3. **Hardcoding framework detection:**
   ```markdown
   # Wrong - Assumes npm
   !`npm test $1`

   # Better - Adaptive
   Identify the testing framework used, then run appropriate tests for $1.
   ```

---

For detailed plugin-specific features, see `references/plugin-features-reference.md`.
For general command development, see main `SKILL.md`.
