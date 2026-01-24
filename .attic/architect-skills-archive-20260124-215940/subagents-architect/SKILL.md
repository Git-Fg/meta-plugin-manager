---
name: subagents-architect
description: "Creates, audits, and refines subagent files with multi-workflow orchestration. Automatically detects DETECT/CREATE/VALIDATE/OPTIMIZE workflows. Context-aware routing for projects and plugins."
user-invocable: false
---

# Subagents Domain

## WIN CONDITION

**Called by**: User directly (no intermediate router needed)
**Purpose**: Create, audit, or refine subagent files with quality validation and proper configuration

**Output**: Must output completion marker

```markdown
## SUBAGENTS_DOMAIN_COMPLETE

Workflow: [DETECT|CREATE|VALIDATE|OPTIMIZE]
Quality Score: XX/100
Configuration: [Valid|Invalid]
Location: [.claude/agents/|plugin/agents/]
Improvements: [+XX points]
Context Applied: [Summary]
```

**Completion Marker**: `## SUBAGENTS_DOMAIN_COMPLETE`

## Dependencies

This skill is self-contained and does not depend on other skills for execution. It includes all necessary knowledge for subagent configuration, context isolation, and coordination patterns.

**May be called by**:
- User requests for subagent creation, validation, or optimization
- Other skills seeking subagent configuration guidance

**Does not call other skills** - all functionality is self-contained.

## Routing Guidance

**Use this skill when**:
- "I need subagents" or "Create an agent"
- "Configure subagent" or "Set up agent isolation"
- "Audit agents" or "Validate agent configuration"
- Need context: fork isolation or parallel processing

**Do not use for**:
- Skill creation (use skills-domain)
- MCP configuration (use mcp-domain)
- Hook setup (use hooks-domain)
- General workflow without subagent focus

## Quality Integration

Apply quality framework during subagent work:

**Validate subagent configuration**:
- Context: fork usage appropriate
- Dynamic context injection present
- Clear coordination patterns
- Specialization appropriate

**Check for anti-patterns**:
- Context: fork misuse (simple tasks using fork)
- Missing dynamic context injection
- Unclear coordination patterns
- Over-use of subagents for simple tasks

**Report quality in completion**:
```markdown
## SUBAGENTS_DOMAIN_COMPLETE

Workflow: [DETECT|CREATE|VALIDATE|OPTIMIZE]
Quality Score: XX/100
Configuration: [Valid|Invalid]
Location: [.claude/agents/|plugin/agents/]
Improvements: [+XX points]
Context Applied: [Summary]
```

## RECOMMENDED: Context Validation

Read these URLs when accuracy matters for subagent development work:

### Reference Files (read as needed):
1. `references/configuration-guide.md` - Valid frontmatter fields and patterns
2. `references/context-detection.md` - Project vs plugin vs user context
3. `references/coordination-patterns.md` - Multi-agent orchestration patterns
4. `references/validation-framework.md` - 6-dimensional quality scoring

### Primary Documentation
- **Subagents Documentation**: https://code.claude.com/docs/en/sub-agents
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Subagent configuration, supported frontmatter fields

- **Plugin Architecture**: https://code.claude.com/docs/en/plugins
  - **Tool**: `mcp__simplewebfetch__simpleWebFetch`
  - **Cache**: 15 minutes minimum
  - **Content**: Plugin structure, component organization

### When to Fetch vs Skip
**Fetch when**:
- Documentation may have changed since last read
- User requests verification of subagent patterns
- Starting new subagent creation or audit
- Uncertain about frontmatter field validity

**Skip when**:
- Simple subagent modifications based on known patterns
- Local-only work without external dependencies
- Working offline
- Recently read and documentation is stable

**Trust your judgment**: You know when validation is needed for accurate subagent work.

## Multi-Workflow Detection Engine

Automatically detects and executes appropriate workflow:

```python
def detect_subagent_workflow(project_state, user_request):
    context_type = detect_context_type(project_state)
    has_existing = exists_subagents(context_type)
    validation_requested = "validate" in user_request.lower() or "check" in user_request.lower()

    if "create" in user_request or (not has_existing and "agent" in user_request.lower()):
        return "CREATE"  # Generate new subagent
    elif validation_requested:
        return "VALIDATE"  # Check existing configuration
    elif has_existing and has_issues():
        return "OPTIMIZE"  # Fix configuration problems
    else:
        return "DETECT"  # Analyze needs
```

**Detection Logic**:
1. **Create request OR no existing agents** → **CREATE mode** (generate new subagent)
2. **Validation/audit requested** → **VALIDATE mode** (check configuration)
3. **Existing agents with issues** → **OPTIMIZE mode** (fix problems)
4. **Default analysis** → **DETECT mode** (analyze needs and suggest)

## Context Detection

Automatically detect working context before any action:

```python
def detect_context_type(project_state):
    if exists(".claude-plugin/plugin.json") or exists("plugin/agents/"):
        return "plugin"
    elif exists(".claude/agents/"):
        return "project"
    elif exists("~/.claude/agents/"):
        return "user"
    else:
        return "undetermined"
```

**Context Types**:
1. **Plugin Context**: `.claude-plugin/plugin.json` exists → Use `plugin/agents/`
2. **Project Context**: `.claude/agents/` exists → Use `.claude/agents/`
3. **User Context**: `~/.claude/agents/` exists → Use user-level agents
4. **Undetermined**: Ask user for clarification

## Core Philosophy

**Trust in AI Reasoning**:
- Provides context and examples, trusts AI to make intelligent decisions
- Uses clear detection logic instead of asking questions upfront
- Relies on completion markers for workflow verification

**Context-Aware Routing**:
- Automatically detects project vs plugin vs user context
- Creates subagents in appropriate directory
- Validates configuration based on context

## Agent Types Quick Reference

| Agent Type | Tools | Purpose | Use When |
|------------|-------|---------|----------|
| **general-purpose** | All tools | Default, full capability | Most tasks, no specialization needed |
| **bash** | Bash only | Command execution specialist | Pure shell workflows, no file operations |
| **explore** | All except Task | Fast codebase exploration | Quick navigation, no nested TaskList |
| **plan** | All except Task | Architecture design | Complex decision-making, planning |

## Agent Selection Decision Tree

```
Need command execution only?
└─ Yes → bash agent
└─ No
   └─ Need architecture design?
      └─ Yes → plan agent
      └─ No
         └─ Fast exploration without TaskList?
            └─ Yes → explore agent
            └─ No → general-purpose agent
```

## Model Selection for Subagents

Explicit model selection affects cost and performance:

| Model | Use Case | When to Specify | Cost Factor |
|-------|----------|-----------------|-------------|
| **haiku** | Fast, straightforward tasks | Simple analysis, quick operations | 1x (baseline) |
| **sonnet** | Default | Balanced performance, most cases | 3x haiku |
| **opus** | Complex reasoning | Architecture design, complex decisions | 10x haiku |

**Guidance**:
- Default to sonnet (inherited from parent)
- Use haiku for: Simple grep, basic file operations, quick validation
- Use opus for: Architecture design, complex refactoring, multi-stage planning

**Cost Optimization Strategy**:
1. Start with haiku for simple exploration
2. Escalate to sonnet for standard workflows
3. Use opus only when complex reasoning is critical

## Four Workflows

### DETECT Workflow - Analyze Subagent Needs

**Use When:**
- Unclear what subagents are needed
- Project analysis phase
- Before creating any subagents
- Understanding current agent landscape

**Why:**
- Identifies automation opportunities
- Maps existing subagents
- Suggests optimal agent configuration
- Prevents unnecessary agent creation

**Process:**
1. Scan project structure for automation candidates
2. List existing subagents (if any)
3. Identify patterns suitable for agents
4. Suggest context-appropriate configurations
5. Generate recommendation report

### CREATE Workflow - Generate New Subagents

**Use When:**
- Explicit create request
- No existing subagents found
- New automation needed
- User asks for agent creation

**Why:**
- Creates properly configured subagents
- Follows best practices for frontmatter
- Validates configuration
- Sets up in correct context location

**Process:**
1. Detect working context (project/plugin/user)
2. Determine appropriate directory
3. Generate subagent file with:
   - Valid YAML frontmatter only
   - Clear system prompt
   - Appropriate tool restrictions
   - Proper skills injection (if needed)
4. Save to correct location
5. Validate configuration

### VALIDATE Workflow - Configuration Compliance Check

**Use When:**
- Audit or validation requested
- Before deployment to production
- After agent configuration changes
- Regular compliance check

**Why:**
- Ensures configuration correctness
- Validates frontmatter fields
- Checks for anti-patterns
- Provides compliance score

**Process:**
1. Scan all subagent files
2. Validate frontmatter structure
3. Check required fields present
4. Verify valid fields only
5. Generate compliance report

### OPTIMIZE Workflow - Performance Improvements

**Use When:**
- VALIDATE found issues (score <75)
- Performance problems detected
- Configuration optimization needed
- Best practices not followed

**Why:**
- Fixes configuration issues
- Improves performance
- Enhances maintainability
- Ensures best practices

**Process:**
1. Review validation findings
2. Prioritize issues by severity
3. Fix configuration problems
4. Optimize for performance
5. Re-validate improvements

## Quality Framework (6 Dimensions)

Scoring system (0-100 points):

| Dimension | Points | Focus |
|-----------|--------|-------|
| **1. Configuration Validity** | 20 | Valid YAML, required fields |
| **2. Frontmatter Correctness** | 15 | Valid fields only, no invalid entries |
| **3. Context Appropriateness** | 15 | Correct directory selection |
| **4. Tool Restrictions** | 15 | Appropriate allow/deny lists |
| **5. Skills Integration** | 15 | Proper skill injection |
| **6. Documentation Quality** | 20 | Clear description and prompts |

**Quality Thresholds**:
- **A (90-100)**: Exemplary configuration
- **B (75-89)**: Good configuration with minor gaps
- **C (60-74)**: Adequate configuration, needs improvement
- **D (40-59)**: Poor configuration, significant issues
- **F (0-39)**: Failing configuration, critical errors

## Common Context Patterns

### Project-Level Subagent
**Location**: `${CLAUDE_PROJECT_DIR}/.claude/agents/<name>.md`
**Scope**: Current project only
**Use when**: Project-specific workflow automation

**Example**:
```yaml
---
name: deploy-agent
description: "Automates deployment workflow for this project"
model: haiku
tools:
  - Bash
  - Read
permissionMode: default
---
```

### Plugin-Level Subagent
**Location**: `<plugin>/agents/<name>.md`
**Scope**: Where plugin is enabled
**Use when**: Shared across multiple projects

**Example**:
```yaml
---
name: code-review-agent
description: "Reviews code changes for quality and security"
model: sonnet
disallowedTools:
  - Write
  - Edit
hooks:
  PostToolUse:
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./scripts/log-review.sh"
---
```

### User-Level Subagent
**Location**: `~/.claude/agents/<name>.md`
**Scope**: All projects on machine
**Use when**: Personal automation workflows

## Supported Frontmatter Fields

### Valid Fields Only
- ✅ `name` - Required, unique identifier
- ✅ `description` - Required, when to delegate
- ✅ `tools` - Optional, tool allowlist
- ✅ `disallowedTools` - Optional, tool denylist
- ✅ `model` - Optional, sonnet/opus/haiku/inherit
- ✅ `permissionMode` - Optional, permission handling
- ✅ `skills` - Optional, inject skill content
- ✅ `hooks` - Optional, lifecycle hooks

### Invalid Fields (Don't Use)
- ❌ `context: fork` - This is for **skills**, not subagents
- ❌ `agent: Explore` - This field doesn't exist
- ❌ `user-invocable` - Subagents aren't user-invocable
- ❌ `disable-model-invocation` - Not a subagent field

## Context: Fork - Use Sparingly

**⚠️ WARNING**: Subagents already run in forked contexts by definition. Skills use `context: fork` to spawn subagents.

### When Forking is DANGEROUS

**DON'T FORK if you need**:
- Conversation history
- User preferences
- Project-specific decisions
- Previous workflow steps
- Main context decisions

**Example of Dangerous Fork**:
```yaml
# ❌ BAD - Makes decisions based on context
---
name: workflow-decider
description: "Makes workflow decisions based on project state"
context: fork  # LOSES PROJECT CONTEXT!
---

# This will fail - no access to main conversation context!
```

### When Forking is SAFE

**Fork ONLY if**:
- Isolated analysis work (no context needed)
- Noisy operations (want isolation from main conversation)
- Clear, self-contained tasks

**Example of Safe Fork**:
```yaml
# ✅ GOOD - Isolated analysis
---
name: log-analyzer
description: "Analyzes log files for patterns"
context: fork
agent: Explore
---

# WIN CONDITION:
## LOG_ANALYSIS_COMPLETE

{"patterns": [...], "count": X}

# Isolated work - no context needed
```

## When Skills Call Subagents

### Pattern: Hub Skill → Subagent

**When a skill delegates to a subagent**:

```yaml
# Hub Skill
---
name: workflow-orchestrator
description: "Orchestrates multi-step analysis"
---

# Delegate to subagent
Call: toolkit-worker (subagent)
Input: [What to analyze]
Wait for: "## .claude/ Analysis Report" marker
Extract: Quality score, findings, recommendations

# Continue workflow with results
Based on results:
  If score < 8.0: Recommend improvements
  Else: Report success
```

### Multi-Subagent Workflows

```yaml
# Hub Skill
---
name: multi-agent-workflow
---

# Parallel execution possible
Call: subagent-1 (isolated)
Call: subagent-2 (isolated)

Wait for both completion markers
Aggregate results
Make decision
```

## Common Anti-Patterns

**Configuration Anti-Patterns:**
- ❌ Using `context: fork` in subagents - This is for **skills**, not subagents
- ❌ Using `agent: Explore` in subagents - This field **doesn't exist** for subagents
- ❌ Using `model:` or `permissionMode:` inappropriately - Keep simple unless needed
- ❌ Using `user-invocable` in subagents - Subagents aren't skills
- ❌ Using `disable-model-invocation` in subagents - For skills, not subagents

**Context Detection Anti-Patterns:**
- ❌ Not detecting project vs plugin vs user context
- ❌ Creating subagents in wrong directory
- ❌ Mixing project-level and plugin-level agent patterns

**Tool Restriction Anti-Patterns:**
- ❌ Over-restricting tools without clear reason
- ❌ Not specifying tool restrictions for security-sensitive agents
- ❌ Using both tools and disallowedTools without clear rationale

## Workflow Selection Quick Guide

**"I need a subagent"** → CREATE
**"Check my agent configurations"** → VALIDATE
**"Fix agent issues"** → OPTIMIZE
**"What agents do I need?"** → DETECT

## Output Contracts

### DETECT Output
```markdown
## Subagent Analysis Complete

### Context: [project|plugin|user]
### Existing Agents: [count]
### Recommendations: [count]

### Suggested Subagents
1. [Name]: [Purpose] - Priority: [High|Medium|Low]
2. [Name]: [Purpose] - Priority: [High|Medium|Low]

### Automation Opportunities
- [Pattern 1]: Suitable for subagent
- [Pattern 2]: Suitable for subagent
```

### CREATE Output
```markdown
## Subagent Created: {agent_name}

### Context
- Type: {project|plugin|user}
- Location: {full_path}
- Model: {sonnet|opus|haiku|inherited}

### Configuration
- Name: {name} ✅
- Description: Clear ✅
- Tools: {count} tools restricted
- Skills: {count} preloaded

### Quality Score: XX/100
### Configuration: Valid ✅
```

### VALIDATE Output
```markdown
## Subagent Validation Complete

### Quality Score: XX/100 (Grade: [A/B/C/D/F])

### Breakdown
- Configuration Validity: XX/20
- Frontmatter Correctness: XX/15
- Context Appropriateness: XX/15
- Tool Restrictions: XX/15
- Skills Integration: XX/15
- Documentation Quality: XX/20

### Issues
- [Count] critical issues
- [Count] warnings
- [Count] recommendations

### Recommendations
1. [Action] → Expected improvement: [+XX points]
2. [Action] → Expected improvement: [+XX points]
```

### OPTIMIZE Output
```markdown
## Subagent Optimized: {agent_name}

### Quality Score: XX → YY/100 (+ZZ points)

### Improvements Applied
- {improvement_1}: [Before] → [After]
- {improvement_2}: [Before] → [After]

### Configuration Enhanced
- {field_1}: [status]
- {field_2}: [status]

### Status: [Production Ready|Needs More Work]
```
