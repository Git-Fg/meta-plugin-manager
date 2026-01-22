# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# MANDATORY: Read Official Documentation First using mcp__simplewebfetch__simpleWebFetch tool and/or agent-browser skill

**BEFORE STARTING ANY TASK**, fetch and study the official documentation from these sources:

## Core Agent Skills Documentation
Fetch from: https://agentskills.io/home

**CRITICAL CONCEPTS TO UNDERSTAND:**
- **Agent Skills Open Standard**: https://agentskills.io/what-are-skills
  - Skills are the fundamental building blocks
  - Self-sufficient, reusable units of expertise
  - Standalone invocation OR orchestration through commands/subagents
- **Complete Specification**: https://agentskills.io/specification
  - YAML frontmatter format (name, description)
  - Progressive disclosure structure
  - Description formula: WHAT + WHEN + NOT
- **Integration Patterns**: https://agentskills.io/integrate-skills
  - Adding skills support to agents
  - Auto-discovery mechanisms
  - Skill chaining and orchestration

## Claude Code Platform Documentation
Fetch from: https://code.claude.com/docs/en/

**ESSENTIAL GUIDES:**
- **Skills Development**: https://code.claude.com/docs/en/skills
  - Building skills with progressive disclosure
  - Context: fork vs context: default patterns
  - Skill autonomy principles
- **Plugins Architecture**: https://code.claude.com/docs/en/plugins
  - Plugin structure and organization
  - Component patterns (skills, commands, hooks, subagents)
  - Plugin marketplace integration
- **Subagents**: https://code.claude.com/docs/en/sub-agents
  - Isolation and parallelism patterns
  - Context: fork triggers
  - Coordination patterns

## Additional Platform Features
Fetch based on your needs:
- **CLI Reference**: https://code.claude.com/docs/en/cli-reference
- **Hooks**: https://code.claude.com/docs/en/hooks
- **MCP Integration**: https://code.claude.com/docs/en/mcp
- **Plugin Reference**: https://code.claude.com/docs/en/plugins-reference
- **Interactive Mode**: https://code.claude.com/docs/en/interactive-mode
- **Output Styles**: https://code.claude.com/docs/en/output-styles
- **Headless Mode**: https://code.claude.com/docs/en/headless
- **Troubleshooting**: https://code.claude.com/docs/en/troubleshooting
- **Plugin Marketplaces**: https://code.claude.com/docs/en/plugin-marketplaces

---

# Project Overview

**The Cat Toolkit v3** is a project scaffolding toolkit for Claude Code. It provides comprehensive guidance for enhancing **current projects** via `.claude/` directory configuration using Skills, MCP, Hooks, and Subagents with 2026 best practices.

**Architecture Philosophy**: Local-first configuration with skills-first approach, progressive disclosure, minimum complexity, and price optimization.

## Local-First Configuration Philosophy

**Target**: `${CLAUDE_PROJECT_DIR}/.claude/`

The toolkit empowers users to:
- Add skills to their current project via `.claude/skills/`
- Configure MCP servers in project root `.mcp.json`
- Create project-specific agents in `.claude/agents/`
- Add scoped hooks where needed (global or component-scoped)

**Zero Active Hooks**: This toolkit contains NO active hooks. It teaches users how to create their own.

---

## Core Principles

### 1. Skills-First Architecture (PRIMARY Layer)

**Skills are the FUNDAMENTAL BUILDING BLOCKS** — self-sufficient, reusable units of expertise. Every Skill must be self-sufficient, autonomous, valuable, and reusable.

**Use Skills for**: Domain expertise, complex workflows, discoverable capabilities.

**Reference**: https://agentskills.io/what-are-skills and https://code.claude.com/docs/en/skills

### 2. Progressive Disclosure

Fetch: https://agentskills.io/specification

**Tier Structure**:
- **Tier 1** (~100 tokens): Metadata (name + description) — Always loaded
- **Tier 2** (<35,000 chars): SKILL.md — Loaded on activation
- **Tier 3** (on-demand): references/, scripts/ — Loaded when needed

### 3. Autonomy-First Design

Skills must complete without questions in 80-95% of cases. Implement "explore first" before "ask".

**Question Burst Criteria** (ALL 3 required):
- Information NOT inferrable from repo/tools
- High impact if wrong choice
- Small set (3-7 questions) unlocks everything

### 4. NO Model-Specific Code

Never reference, optimize for, or hardcode specific models. All guidance must be model-agnostic.

### 5. 2026 Best Practices

Fetch: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices

**Key Standards**:
- **Skill-Centric by Default**: Skills should be the PRIMARY interface
- **Cost Optimization**: Target <$50 per 5-hour rotation through progressive disclosure
- **Quality Enforcement**: Multi-stage validation, mandatory URL fetching
- **Plugin Lifecycle**: Create → Review → Refine patterns

### 6. Plugin Quality Framework

**Scoring System (0-10 scale)**:
- **Structural (30%)**: Architecture compliance, directory structure, progressive disclosure
- **Components (50%)**: Skill quality (15), Command quality (10), Agent quality (10), Hook quality (10), MCP quality (5)
- **Standards (20%)**: URL currency (10), Best practices (10)

**Score Interpretation**:
- **9-10**: Excellent - Production ready, all best practices
- **7-8**: Good - Minor improvements needed
- **5-6**: Fair - Significant improvements recommended
- **3-4**: Poor - Major rework required
- **0-2**: Failing - Complete rebuild recommended

---

## Layer Selection Guide

Fetch: https://code.claude.com/docs/en/sub-agents

**Quick Decision Tree**:
```
START: What do you need?
│
├─ "Persistent project norms" → CLAUDE.md rules
├─ "Domain expertise to discover" → Skill
│  ├─ "Simple task" → Skill (regular)
│  └─ "Complex workflow" → Skill (context: fork)
├─ "Explicit workflow I trigger" → Slash Command
└─ "Isolation/parallelism" → Subagent
```

**Context: Fork Triggers**:
- High-volume output (extensive grep, repo traversal)
- Noisy exploration that clutters conversation
- Log analysis, full codebase audits
- Tasks benefiting from separate context window

---

## Skill Standards

### Core Principle: Self-Sufficient Building Blocks

Fetch: https://agentskills.io/specification

**Every Skill MUST be usable in ANY context:**
- **Standalone Invocation**: Model discovers or user manually invokes
- **Command Orchestration**: Called as part of larger workflow
- **Subagent Integration**: Provides expertise to Subagents
- **Skill Chaining**: Calls other Skills while remaining autonomous
  - **Best for**: Deterministic utility chains (e.g., validate → format → validate)
  - **Avoid for**: Complex reasoning flows where output is unpredictable (Linear Chain Brittleness)
  - **Alternative**: Use Hub-and-Spoke pattern with `context: fork` (Clean Fork Pattern) for dynamic workflows

### Frontmatter Format

```yaml
---
name: skill-name              # Lowercase, gerund form, ≤64 chars
description: "{{CAPABILITY}}. Use when {{TRIGGERS}}. Do not use for {{EXCLUSIONS}}."
user-invocable: true          # Optional, default: true (model can invoke)
disable-model-invocation: true # Optional, manual-only (user-triggered)
context: fork                 # Optional, for worker isolation
agent: Explore                # Optional, when context: fork
---
```

**Description Formula**: WHAT + WHEN + NOT

**IMPORTANT**: Only these frontmatter fields are supported. Custom fields like `output-contract`, `stop-conditions`, or `error-handling` are NOT valid. Document output contracts in the SKILL.md body instead.

### Skill Design Principles

Fetch: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices

Skills should embody specific values based on task needs:
- **Reliability**: Deterministic execution with validation
- **Wisdom**: Expert judgment and decision frameworks
- **Consistency**: Standardized output from templates
- **Coordination**: Orchestration of multiple workflows
- **Simplicity**: Direct path with minimal overhead

### Output Contracts for Orchestrator and Worker Skills

**Orchestrator Skills** (`disable-model-invocation: true`):
- Document output format in SKILL.md body: `## Output Format`
- Include routing decision logic: "Route to {skill}" or "Delegate to {worker} (context: fork)"
- Add fork decision matrix based on output volume
- Parse worker output for explicit completion markers

**Worker Skills** (`context: fork`):
- MUST include `## Output Format` with exact template
- MUST include `## STOP WHEN` section with explicit conditions
- MUST include error handling: "If validation fails, return ERROR status, never loop"
- Reference: `meta-architect-claudecode/references/output-contracts.md`

---

## Plugin Architecture

Fetch: https://code.claude.com/docs/en/plugins

**Standard Structure**:
```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── skills/                   # PRIMARY: Self-sufficient skills
│   └── skill-name/
│       ├── SKILL.md         # Core skill definition
│       └── references/      # Supporting docs (Tier 3)
├── commands/                 # Orchestration workflows
│   └── command-name.md
├── agents/                   # Specialized subagents
│   └── agent-name.md
├── hooks/                   # Event automation
│   └── hooks.json
└── mcp/                     # MCP server configs
    └── server-config.json
```

**Plugin Types**:
- **minimal**: Skills only
- **toolkit**: Skills + Commands + Hooks
- **integration**: Skills + MCP + Commands + Hooks
- **workflow**: Commands + Agents + Skills
- **analysis**: Agents + Skills + Commands

---

## Command Basics

Fetch: https://code.claude.com/docs/en/cli-reference

**What are Slash Commands?** Markdown files that Claude executes when invoked. Commands provide reusability, consistency, and efficiency.

**File Format**:
```
.claude/commands/
├── review.md           # /review command
├── test.md             # /test command
└── deploy.md           # /deploy command
```

**Basic Command:**
```markdown
Review this code for security vulnerabilities including:
- SQL injection
- XSS attacks
- Authentication issues
```

**When to Use Commands**:
- Explicit user-controlled workflows
- Multi-step processes requiring user confirmation
- Coordination of multiple skills
- Complex decision points

---

## Hooks

Fetch: https://code.claude.com/docs/en/hooks

**Hooks** provide infrastructure integration for MCP servers, LSP configuration, and event-driven automation.

**When to use**: Infrastructure integration, event automation, MCP/LSP configuration

**Anti-Pattern**: SessionStart hooks that only print cosmetic messages (echo/logging without functional behavior). These add noise without value.

**Structure**:
```
hook-name/
├── SKILL.md              # Event handling logic
└── scripts/              # Execution logic (if needed)
```

---

## Subagents

Fetch: https://code.claude.com/docs/en/sub-agents

**Subagents** provide isolation and parallelism for complex tasks.

**When to Use**:
- Context: fork scenarios
- High-volume operations
- Isolated exploration
- Parallel task execution

**Pattern Selection**:
- **Pipeline Pattern**: Sequential processing stages
- **Router + Worker Pattern**: Task distribution and execution
- **Handoff Pattern**: Coordination between specialized agents

---

## MCP Integration

Fetch: https://code.claude.com/docs/en/mcp

**MCP (Model Context Protocol)** servers provide external tool integration (Context7, DeepWiki, DuckDuckGo, Web Reader, etc.).

**Configuration**: Use `${CLAUDE_PLUGIN_ROOT}` for paths in MCP server configs

**Common MCP Servers**:
- DuckDuckGo search
- Web fetching tools
- Code analysis services
- External APIs

---

## Anti-Patterns to Avoid

### 1. Command Wrapper Anti-Pattern
**Violation**: Creating Commands that wrap Skills (metadata bloat, redundant interface)
**Correct**: Use Skills directly. Auto-discovery finds skills by description keywords.

### 2. Non-Self-Sufficient Skills
**Violation**: Skills that require a Command or Subagent to function
**Correct**: Every Skill must work standalone AND enhance other workflows.

### 3. Script Envy
**Violation**: Scripts for operations Claude handles natively (read, grep, bash)
**Correct**: Use scripts ONLY for API calls, data transformations, specialized tools.

### 4. Architecture Violations
**Violation**: Commands/Skills without proper progressive disclosure
**Correct**: Follow https://agentskills.io/specification for mandatory structure

### 5. Missing Quality Validation
**Violation**: No URL fetching, poor documentation, missing standards
**Correct**: Use create → review → refine lifecycle with quality scoring

---

## Price Optimization

### 5-Hour Rotation Cost Management

**Budget Targets**:
- **Target**: <$50 per 5-hour session
- **Warning**: >$75 per 5-hour session
- **Critical**: >$100 per 5-hour session

**Key Tactics**:
1. **Progressive Disclosure**: Load heavy content only when needed
2. **Skill Autonomy**: 80-95% of tasks complete without questions
3. **Batch Operations**: Group related actions
4. **Context Reuse**: Avoid redundant file reads
5. **Deterministic Commands**: Use validation scripts over exploration

---

## Project Configuration Lifecycle

### Create → Review → Refine Pattern

**1. Component Creation**
```bash
# Use toolkit-architect to scaffold .claude/ components
# Ensure: Skills-first architecture, progressive disclosure, URL fetching
```

**2. Quality Review**
- Fetch: https://agentskills.io/specification
- Check: .claude/ architecture compliance, component quality, standards adherence
- Score: Use 0-10 quality framework with toolkit-quality-validator
- Validate: URL currency, best practices

**3. Refinement**
- Fix high-priority issues immediately
- Plan medium-priority improvements
- Consider low-priority enhancements
- Always validate after changes

### Quality Validation Checklist

**Structural (30%)**:
- [ ] Architecture follows skills-first approach
- [ ] Directory structure is standard
- [ ] Progressive disclosure implemented (Tier 1/2/3)

**Components (50%)**:
- [ ] Skills are self-sufficient and autonomous
- [ ] Commands orchestrate, don't wrap
- [ ] Subagents used for isolation/parallelism
- [ ] Hooks handle events properly
- [ ] MCP integration configured correctly

**Standards (20%)**:
- [ ] All components include URL fetching sections
- [ ] Strong language (MUST/REQUIRED) used
- [ ] Tool-specific guidance included
- [ ] Activation conditions defined
- [ ] Hard preconditions specified

---

## Skills Index

**Project Scaffolding Skills**:

Use the meta-plugin-manager toolkit to enhance your current project:

1. **Skill Development**
   - Fetch: https://agentskills.io/home
   - Focus: Self-sufficient building blocks, progressive disclosure

2. **Command Development**
   - Fetch: https://code.claude.com/docs/en/cli-reference
   - Focus: Orchestration, not wrapper patterns

3. **Hook Development**
   - Fetch: https://code.claude.com/docs/en/hooks
   - Focus: Event automation, infrastructure integration

4. **Agent Development**
   - Fetch: https://code.claude.com/docs/en/sub-agents
   - Focus: Isolation, parallelism, context: fork

5. **MCP Integration**
   - Fetch: https://code.claude.com/docs/en/mcp
   - Focus: External tool integration

6. **Plugin Structure**
   - Fetch: https://code.claude.com/docs/en/plugins
   - Focus: Architecture, organization, patterns

7. **Plugin Settings**
   - Fetch: https://code.claude.com/docs/en/plugins-reference
   - Focus: Configuration, state management

---

## Platform-Specific Features

### Interactive Mode
Fetch: https://code.claude.com/docs/en/interactive-mode
- Use for exploration and iterative development
- Not for production workflows
- Helps with debugging and learning

### Headless Mode
Fetch: https://code.claude.com/docs/en/headless
- Programmatic plugin usage
- CI/CD integration
- Automated testing

### Output Customization
Fetch: https://code.claude.com/docs/en/output-styles
- Format consistency
- User experience optimization
- Context-aware responses

---

## Troubleshooting

Fetch: https://code.claude.com/docs/en/troubleshooting

**Common Issues**:
1. **Skills not discovered**: Check description keywords and frontmatter format
2. **Poor quality scores**: Review progressive disclosure and URL fetching
3. **Architecture violations**: Ensure skills-first approach
4. **Performance issues**: Implement progressive disclosure properly

**Diagnostic Steps**:
1. Fetch specification: https://agentskills.io/specification
2. Check best practices: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
3. Review plugin structure: https://code.claude.com/docs/en/plugins
4. Validate against quality framework

---

## When in Doubt

**Layer Selection Decision Tree**:
```
Need persistent project norms? → CLAUDE.md rules
Need domain expertise? → Skill
  Simple task? → Skill (regular)
  Complex workflow? → Skill (context: fork)
Need explicit workflow? → Command
Need isolation/parallelism? → Subagent
```

**Common Paths**:
1. **Building first skill** → Fetch https://agentskills.io/home → https://agentskills.io/what-are-skills
2. **Choosing context: fork** → Fetch https://code.claude.com/docs/en/sub-agents
3. **Evaluating quality** → Fetch https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices
4. **Learning fundamentals** → Fetch https://agentskills.io/integrate-skills

**Remember**: Most customization needs are met by CLAUDE.md + one Skill.

**Skills-First Mantra**:
> "Build from skills up. Every capability should be a Skill first.
> Commands and Subagents are orchestrators, not creators."

---

## Working with Skills

**Path Resolution**: When a skill is invoked, SKILL.md is the absolute root. All paths must be relative to SKILL.md location - cannot use `../` to navigate above skill root.

**Link Validation**:
- Example links in markdown code blocks should be skipped during validation (they're documentation examples)
- Anchor links starting with `#` should be skipped
- Use validation script: `scripts/validate-links.sh` to check all internal links

**Legacy File Management**: When archiving files to `.attic/`, immediately remove ALL references to them to prevent broken link debt.

**Directory Hygiene**: Remove empty scaffolding directories (`references/`, `scripts/`) rather than leaving technical debt.

**Refactoring check**: When reviewing skills, if total content (SKILL.md + references) <500 lines, consider merging into self-contained skill.

**Reference Links**: Use simple relative paths from SKILL.md:
- `references/file.md` (for files in references/)
- `examples/file.md` (for files in examples/)
- Avoid `../` paths within skill context
- **Anti-pattern**: Cross-skill links like `../other-skill/SKILL.md` - skills should be self-contained or use routing language

**Router/Orchestrator Skills**: Skills with `disable-model-invocation: true` should route to knowledge skills, not reference external docs:
- Route: "Load: {knowledge-skill}" for implementation details
- Anti-pattern: "Refer to CLAUDE.md X section" - creates external dependency
- Exception: Teaching ABOUT CLAUDE.md as a layer concept (educational, not dependency)

**Fork Decision Matrix** (when calling other skills):
- Small tasks, direct routing → Load knowledge skill directly
- Large/complex tasks, noisy output → Delegate to worker (context: fork)
- Parse worker output for explicit completion markers
- On ERROR: Log and abort, never continue blindly

---

## Working with Multiple Components

**Refactoring Multiple Components**: When renaming multiple directories/files, combine `mv` commands: `mv old1 new1 && mv old2 new2 && mv old3 new3` - single bash call more efficient than multiple separate calls.

**Edit Tool for Cross-References**: Use `replace_all=true` parameter when updating same text across multiple occurrences: `Edit(file, old_string, new_string, replace_all=true)` - replaces all instances in one operation.

**TodoWrite for Large Tasks**: Use TodoWrite to track multi-phase work (e.g., 7-8 phase refactor). Update status: pending → in_progress → completed. Provides visibility and prevents lost steps.

**Phase-Based Commits**: For large refactors, commit after each logical phase rather than one mega-commit. Makes review easier and enables selective rollback.

**Verify with Grep**: After updating cross-references, verify: `grep -r "old-pattern" --include="*.md" . | wc -l` - should return 0 if all references updated.

**Read Before Edit**: Must read file with Read tool before Edit tool can modify it (system constraint).

---

## Claude Code Plugin Engineering (2026)

### Skills-First Architecture

**Skills are the primary building block** for all plugins. Commands unified with Skills in 2026.

**Modern patterns**:
- `user-invocable: true` (default) = model can invoke autonomously
- `disable-model-invocation: true` = manual-only (user-triggered workflows)
- Legacy commands = Skills with `disable-model-invocation: true`

**Why Skills**: Support progressive disclosure, component-scoped hooks, context forking, auto-discovery.

### Progressive Disclosure (Three-Tier)

1. **Tier 1**: YAML frontmatter (~100 tokens) - metadata, triggers
2. **Tier 2**: SKILL.md body (~3,500 tokens) - overview, decision logic, examples
3. **Tier 3**: references/ subdirectories - detailed guides loaded on-demand

**Self-contained threshold**: If SKILL.md + all references would be <500 lines total, merge into single self-contained SKILL.md instead of using progressive disclosure.

**Anti-pattern**: Everything in SKILL.md or deeply nested sub-skills instead of references.

### Component Auto-Discovery

Claude automatically discovers:
- Plugin manifest: `.claude-plugin/plugin.json`
- Commands: `commands/*.md` (legacy)
- Agents: `agents/*.md`
- Skills: `skills/*/SKILL.md`
- Hooks: `hooks/hooks.json` or inline in manifest
- MCP servers: `.mcp.json` or manifest

### Subagents & Context Fork

**Use subagents for isolation/parallelism**:
- High-volume/noisy operations (repo audits, log analysis)
- Parallel execution of independent tasks
- Security isolation (untrusted code)
- **Prevention of Context Rot**: Long linear chains accumulate noise. Forking ensures zero context pollution.

**Context fork requirements**: Always inject **dynamic context** for self-contained execution. Forked contexts don't inherit conversation history.

**Anti-pattern**: Using subagents for simple routing or tight coupling with parent.

### Hooks Architecture

**Hook Event Types**: PreToolUse, PostToolUse, Stop, SubagentStop, SessionStart, SessionEnd, PermissionRequest, Notification

**Implementation Types**:
- **Prompt hooks** (type: `prompt`): Only for Stop/SubagentStop, context-aware, risk of infinite loops
- **Command hooks** (type: `command`): All events, fast/deterministic, exit codes (0=allow, 2=block, 1=error)

**Scoping Hierarchy**:
- **Component-scoped** (best): Defined in Skill/agent frontmatter, only active during execution, auto-cleanup
- **Plugin-level** (sparingly): Always active when plugin enabled, good for infrastructure
- **Project/User-level**: Highest precedence, organizational policies

**Best practice**: Prefer component-scoped hooks to avoid "always-on" noise.

### Quality Standards

**Scoring Framework** (0-10):
- Structural (30%): Architecture compliance, directory structure, progressive disclosure
- Components (50%): Skills (15%), Subagents (10%), Hooks (10%), MCP (5%), Architecture (10%)
- Standards (20%): URL currency (10%), Best practices (10%)

**Production threshold**: Score ≥ 8/10

### URL Fetching Requirements

Knowledge skills MUST include mandatory URL fetching sections:

```markdown
## MANDATORY: Read Before Creating Skills

- **MUST READ**: [Official Skills Guide](https://code.claude.com/docs/en/skills)
  - Tool: `mcp__simplewebfetch__simpleWebFetch`
  - Cache: 15 minutes minimum

**BLOCKING RULES**:
- DO NOT proceed without understanding skill structure
```

**Key elements**: Strong language (MUST, REQUIRED), explicit tool name, cache duration, blocking conditions.

### Hub-and-Spoke Pattern

**Hub Skills** (task routers):
- `disable-model-invocation: true` (manual-only)
- Minimal routing logic
- Delegate to knowledge skills
- Enforce quality gates

**Knowledge Skills** (reference libraries):
- `user-invocable: true` (model can reference)
- Teach concepts and patterns
- Single source of truth per domain
- No direct edits/actions

**Anti-drift**: One knowledge skill per domain (not fragments), hubs reference knowledge, don't duplicate.

### Path Resolution

**Environment Variables**:
- `${CLAUDE_PLUGIN_ROOT}`: Plugin installation directory
- `${CLAUDE_PROJECT_DIR}`: Current project directory

**Usage**:
```yaml
# In component files:
command: "${CLAUDE_PLUGIN_ROOT}/scripts/helper.py"

# In hub logic (development only):
path: "${CLAUDE_PROJECT_DIR}/.claude-plugin/"
```

**Note**: Only use `${CLAUDE_PROJECT_DIR}/.claude-plugin/` in development/testing scenarios. For production plugins, reference specific files or use explicit project paths.

### Autonomy Levels

**Fully autonomous** (`user-invocable: true`, default):
- Model decides when to invoke
- Good for: knowledge references, utility functions

**Manual-trigger only** (`disable-model-invocation: true`):
- User must explicitly invoke
- Good for: high-impact operations, workflows

**Hybrid pattern**: Hub is manual-only, delegates to autonomous knowledge skills.

### Common Anti-Patterns

**Architectural**:
- Command wrapper (Skills that just invoke commands)
- **Orchestration Complexity** (Managers managing managers)
- **Indecisive Orchestrator** (Ambiguous handoffs/Too many paths)
- **Linear Chain Brittleness** (Long chains for reasoning tasks)
- Empty scaffolding (directories with no content)
- Skill fragmentation (many tiny skills instead of one with references)
- **Cosmetic hooks** (SessionStart hooks that only echo/print without functional behavior)

**Documentation**:
- Stale URLs (outdated documentation)
- Missing URL sections (knowledge skills without mandatory fetches)
- Drift (same concept in multiple places)

**Operational**:
- Global hooks abuse (plugin-level hooks for component concerns)
- Prompt hooks for PreToolUse (use command hooks instead)
- Missing quality gates

### Best Practices Checklist

✅ Skills-first architecture
✅ Progressive disclosure (SKILL.md → references/)
✅ Component-scoped hooks only
✅ Hub-and-spoke organization
✅ Context fork for isolation
✅ Mandatory URL fetching
✅ Quality validation gates
✅ One knowledge skill per domain
✅ Single source of truth per concept

---

## Reference

**Official Agent Skills**:
- Home: https://agentskills.io/home
- What are Skills: https://agentskills.io/what-are-skills
- Specification: https://agentskills.io/specification
- Integration: https://agentskills.io/integrate-skills

**Claude Code Platform**:
- Platform Skills: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview
- Quickstart: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/quickstart
- Best Practices: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices

**Core Documentation**:
- Skills: https://code.claude.com/docs/en/skills
- Plugins: https://code.claude.com/docs/en/plugins
- Subagents: https://code.claude.com/docs/en/sub-agents
- Hooks: https://code.claude.com/docs/en/hooks
- MCP: https://code.claude.com/docs/en/mcp

**Additional Resources**:
- CLI Reference: https://code.claude.com/docs/en/cli-reference
- Plugin Reference: https://code.claude.com/docs/en/plugins-reference
- Interactive Mode: https://code.claude.com/docs/en/interactive-mode
- Headless Mode: https://code.claude.com/docs/en/headless
- Output Styles: https://code.claude.com/docs/en/output-styles
- Troubleshooting: https://code.claude.com/docs/en/troubleshooting
- Plugin Marketplaces: https://code.claude.com/docs/en/plugin-marketplaces

**External References**:
- GitHub: https://github.com/agentskills/agentskills - Open standard
- GitHub: https://github.com/anthropics/skills - Example skills
