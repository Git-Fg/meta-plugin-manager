# Meta Plugin Manager

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Plugin Architecture](#plugin-architecture)
- [Domain Hub Skills](#domain-hub-skills)
- [Skills Interface](#skills-interface)
- [Quality Scoring](#quality-scoring)
- [Best Practices](#best-practices)
- [Workflow Examples](#workflow-examples)
- [Troubleshooting](#troubleshooting)
- [Advanced Usage](#advanced-usage)
- [Contributing](#contributing)
- [License](#license)
- [Support](#support)
- [Related Plugins](#related-plugins)
- [Changelog](#changelog)

A comprehensive meta-management plugin for orchestrating the creation, review, audit, and refinement of Claude Code plugins using skills-first domain hubs and a single plugin-worker for noisy analysis.

## Overview

The Meta Plugin Manager is a skill-centric plugin that provides complete lifecycle management for Claude Code plugins using domain hub architecture. It consolidates 3 plugin orchestrators into 5 domain router skills that delegate to knowledge skills, with plugin-worker as the single noisy-analysis worker.

## Features

### 🎯 Core Capabilities

- **Plugin Creation**: Orchestrate complete plugin creation with proper architecture
- **Plugin Review**: Conduct comprehensive audits with quality scoring
- **Plugin Refinement**: Improve plugins based on audit findings
- **Component Management**: Manage skills, hooks, MCP servers, and subagents (commands are legacy-only)
- **Quality Enforcement**: Ensure all operations follow domain hub standards

### 📚 Domain Hub Architecture

This plugin uses 5 domain hub skills for complete plugin lifecycle management:

1. **plugin-architect** - Complete plugin lifecycle router (create/audit/refine)
2. **skills-architect** - Skills domain specialist with progressive disclosure
3. **hooks-architect** - Hooks domain specialist with security focus
4. **mcp-architect** - MCP domain specialist with protocol compliance
5. **subagents-architect** - Subagents domain specialist with isolation focus

**Knowledge Skills** (specialized guidance):
- **skills-knowledge** - Skills development best practices
- **hooks-knowledge** - Event automation patterns
- **mcp-integration** - Protocol compliance
- **subagents-when** - Context fork decisions
- **subagents-coordination** - Coordination patterns
- **plugin-quality-validator** - Standards enforcement

### 📜 Legacy Commands (Reference Only)

Commands (`.claude/commands/*.md`) are **legacy-only** in v6.0+. They are supported for backwards compatibility but **new plugin development should use Skills exclusively**.

**Why commands are legacy**:
- Skills are self-sufficient and auto-discoverable
- Skills support progressive disclosure
- Skills work with subagents for complex workflows
- Commands add unnecessary orchestration layer

### 🚨 Mandatory URL Fetching

All components created, reviewed, or refined include:
- Mandatory URL fetching sections
- Strong language requirements (MUST/REQUIRED/MANDATORY)
- Tool-specific guidance (simpleWebFetch/WebFetch/agent-browser)
- Clear activation conditions
- Hard preconditions and blocking rules

## Installation

```bash
# Install the plugin
# (Installation method depends on your Claude Code setup)

# Verify installation
ls -la ~/.claude/plugins/meta-plugin-manager
```

## Quick Start

### 1. Create a New Plugin

```bash
# Create a basic plugin using plugin architect
/plugin-architect create plugin my-plugin

# Create with specific components
/plugin-architect create skill codebase-audit --context-fork
```

### 2. Audit an Existing Plugin

```bash
# Comprehensive audit
/plugin-architect audit plugin path/to/plugin-name

# Quick audit
/plugin-architect audit plugin path/to/plugin-name --quick

# Detailed audit
/plugin-architect audit plugin path/to/plugin-name --detailed
```

### 3. Refine a Plugin

```bash
# Refine based on audit findings
/plugin-architect refine plugin path/to/plugin-name

# Refine with specific priorities
/plugin-architect refine plugin path/to/plugin-name --priority high

# Preview changes
/plugin-architect refine plugin path/to/plugin-name --preview
```

## Plugin Architecture

```
meta-plugin-manager/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── skills/                   # Domain hub skills (PRIMARY)
│   ├── plugin-architect/     # Complete plugin lifecycle router
│   ├── skills-architect/     # Skills domain specialist
│   ├── hooks-architect/      # Hooks domain specialist
│   ├── mcp-architect/         # MCP domain specialist
│   └── subagents-architect/   # Subagents domain specialist
├── agents/                   # Specialized workers
│   └── plugin-worker.md       # Single noisy-analysis worker
├── hooks/                   # Validation hooks
│   └── hooks.json
└── README.md               # This file
```

## Domain Hub Skills

### plugin-architect

Single router for complete plugin lifecycle management.

**When to use**: Creating, auditing, or refining plugins

**Features**:
- Routes to specialized knowledge skills
- plugin-worker for noisy analysis
- Quality validation gates
- Comprehensive lifecycle management

### skills-architect

Domain router for skills development with progressive disclosure.

**When to use**: Creating, auditing, or refining skills

**Features**:
- Routes to skills-knowledge
- Progressive disclosure optimization
- Autonomy-first design
- Auto-discovery enhancement

### hooks-architect

Domain router for hooks development with event automation focus.

**When to use**: Creating, auditing, or refining hooks

**Features**:
- Routes to hooks-knowledge
- Security-first approach
- Event matching optimization
- Infrastructure integration

### mcp-architect

Domain router for MCP integrations with external service access focus.

**When to use**: Creating, auditing, or refining MCP integrations

**Features**:
- Routes to mcp-* knowledge skills
- Protocol compliance
- Transport optimization
- Component validation

### subagents-architect

Domain router for subagent development with isolation focus.

**When to use**: Creating, auditing, or refining subagents

**Features**:
- Routes to subagents-* knowledge skills
- Context fork optimization
- Coordination patterns
- Autonomy definition

## Skills Interface

### /plugin-architect

Complete plugin lifecycle router with create, audit, and refine actions.

**Actions**:
- `create`: Create new plugins with skills-first architecture
- `audit`: Comprehensive plugin audits with quality scoring
- `refine`: Improve plugins based on audit findings

**Examples**:
```bash
# Create a new plugin
/plugin-architect create plugin my-plugin

# Create a skill with context: fork
/plugin-architect create skill codebase-audit --context-fork

# Audit an existing plugin
/plugin-architect audit plugin ./my-plugin

# Refine based on audit
/plugin-architect refine plugin ./my-plugin --priority high
```

### /skills-architect

Skills domain specialist with progressive disclosure focus.

**Actions**:
- `create`: Create new skills with autonomy
- `audit`: Audit skills for quality and autonomy
- `refine`: Improve skills based on findings

**Examples**:
```bash
# Create a new skill
/skills-architect create skill data-processor

# Audit existing skills
/skills-architect audit skill my-skill

# Refine for better autonomy
/skills-architect refine skill my-skill
```

### /hooks-architect

Hooks domain specialist with security and automation focus.

**Actions**:
- `create`: Create hooks for event automation
- `audit`: Audit hooks for security and effectiveness
- `refine`: Improve hooks based on findings

**Examples**:
```bash
# Create a session hook
/hooks-architect create hook session-validator

# Audit existing hooks
/hooks-architect audit hook my-hook

# Enhance security
/hooks-architect refine hook my-hook
```

### /mcp-architect

MCP domain specialist with protocol compliance focus.

**Actions**:
- `create`: Create MCP integrations for external services
- `audit`: Audit MCP integrations for compliance
- `refine`: Improve MCP integrations

**Examples**:
```bash
# Create MCP tools
/mcp-architect create tool api-wrapper

# Audit MCP server
/mcp-architect audit server my-server

# Improve protocol compliance
/mcp-architect refine server my-server
```

### /subagents-architect

Subagents domain specialist with isolation and parallelism focus.

**Actions**:
- `create`: Create subagents for specialized work
- `audit`: Audit subagents for appropriate usage
- `refine`: Improve subagents for better effectiveness

**Examples**:
```bash
# Create a subagent
/subagents-architect create agent data-analyzer

# Audit context: fork usage
/subagents-architect audit agent my-agent

# Optimize isolation
/subagents-architect refine agent my-agent
```

## Quality Scoring

### Scoring Breakdown (0-10 scale)

**Structural (30%)**:
- Architecture compliance (10)
- Directory structure (10)
- Progressive disclosure (10)

**Components (50%)**:
- Skill quality (20)
- Subagent quality (15)
- Hook quality (10)
- MCP quality (5)
- Architecture compliance (legacy commands excluded)

**Standards (20%)**:
- URL currency (10)
- Best practices (10)

### Score Interpretation

- **9-10**: Excellent - Production ready, follows all best practices
- **7-8**: Good - Minor improvements needed
- **5-6**: Fair - Significant improvements recommended
- **3-4**: Poor - Major rework required
- **0-2**: Failing - Complete rebuild recommended

## Best Practices

### 1. Start with Domain Hubs

Use the appropriate *-architect skill for your domain:
- **plugin-architect**: Complete plugin lifecycle
- **skills-architect**: Skills development
- **hooks-architect**: Event automation
- **mcp-architect**: External integrations
- **subagents-architect**: Isolation and parallelism

This ensures:
- Skills-first approach
- Proper routing to knowledge skills
- Domain expertise
- Quality standards

### 2. Regular Audits

Audit plugins regularly using `/plugin-architect audit`:
- After major changes
- Before deployment
- Quarterly reviews
- When adding new features

### 3. Continuous Refinement

Refine plugins based on audit findings:
- Fix high-priority issues immediately
- Plan medium-priority improvements
- Consider low-priority enhancements
- Always validate changes

### 4. Use Knowledge Skills

Domain hubs route to specialized knowledge skills:
- skills-knowledge: Skill development best practices
- hooks-knowledge: Event automation patterns
- mcp-integration: Protocol compliance
- subagents-when: Context fork decisions
- plugin-quality-validator: Standards enforcement

## Workflow Examples

### Example 1: New Plugin Creation

```bash
# Step 1: Create plugin
/plugin-architect create plugin api-client

# Step 2: Audit quality
/plugin-architect audit plugin ./api-client --detailed

# Step 3: Refine if needed
/plugin-architect refine plugin ./api-client --priority high

# Step 4: Verify improvements
/plugin-architect audit plugin ./api-client
```

### Example 2: Existing Plugin Audit

```bash
# Step 1: Quick audit
/plugin-architect audit plugin ./legacy-plugin --quick

# Step 2: Detailed audit
/plugin-architect audit plugin ./legacy-plugin --detailed

# Step 3: Refine based on findings
/plugin-architect refine plugin ./legacy-plugin --priority high

# Step 4: Final validation
/plugin-architect audit plugin ./legacy-plugin
```

### Example 3: Skill Development

```bash
# Create a new skill
/skills-architect create skill data-processor

# Audit the skill
/skills-architect audit skill data-processor

# Refine for autonomy
/skills-architect refine skill data-processor
```

## Troubleshooting

### Plugin Creation Fails

**Symptoms**: Command errors, incomplete structure

**Solutions**:
- Verify plugin name is valid (kebab-case)
- Check description is provided
- Ensure plugin type is supported
- Confirm components exist

### Review Shows Poor Quality

**Symptoms**: Low scores, many issues

**Solutions**:
- Use `/refine-plugin` to fix high-priority issues
- Check for mandatory URL sections
- Verify progressive disclosure
- Review architecture compliance

### Refinement Introduces Regressions

**Symptoms**: Quality score decreases, broken functionality

**Solutions**:
- Restore from backup
- Review applied changes
- Use `/preview` mode
- Apply changes incrementally

## Advanced Usage

### Custom Workflows

Create custom plugin management workflows:

```bash
# Custom audit and fix
/plugin-architect audit plugin ./plugin --detailed && /plugin-architect refine plugin ./plugin --priority high

# Batch processing
for plugin in plugins/*/; do
    /plugin-architect audit plugin "$plugin" --quick
done

# Domain-specific management
/plugin-architect audit plugin ./plugin
/skills-architect audit skill my-skill
/hooks-architect audit hook my-hook
```

### Integration with CI/CD

Integrate plugin management into your workflow:

```yaml
# Example CI/CD integration
steps:
  - name: Audit Plugin
    run: /plugin-architect audit plugin ./my-plugin --quick

  - name: Quality Gate
    run: |
      SCORE=$(/plugin-architect audit plugin ./my-plugin --quick | grep "Quality Score:" | sed 's/.*Quality Score: \([0-9.]*\)\/10.*/\1/')
      if [ "$SCORE" -lt 7 ]; then
        echo "Quality score $SCORE below threshold"
        exit 1
      fi

  - name: Refine if Needed
    run: |
      if [ "$SCORE" -lt 9 ]; then
        /plugin-architect refine plugin ./my-plugin --priority high
      fi
```

## Contributing

To contribute to the Meta Plugin Manager:

1. **Follow domain hub patterns**
2. **Include mandatory URL sections**
3. **Maintain quality standards**
4. **Add comprehensive tests**
5. **Update documentation**

## License

MIT License - see LICENSE file for details

## Support

For issues and questions:
- Review this README
- Check skill documentation
- Use `/plugin-architect audit` for diagnostics
- File issues with detailed reports

## Related Plugins

- **plugin-quality-validator**: Standards enforcement
- **skills-knowledge**: Skill development guidance
- **hooks-knowledge**: Hook automation patterns
- **subagents-when**: Context fork decisions

## Changelog

### Version 6.0.0
- **MAJOR**: Domain hub architecture
- Consolidated 3 orchestrators into 5 domain router skills
- plugin-worker as single noisy-analysis worker
- Skills-first routing pattern
- Reduced cognitive load (5 hubs vs 3 orchestrators)

### Version 5.0.0
- Skills-first architecture enforcement
- Subagent consolidation
- Quality validation framework
- Progressive disclosure patterns

### Version 1.0.0
- Initial release
- Plugin creation orchestration
- Plugin review orchestration
- Plugin refinement orchestration
- Enhanced meta-skills integration
- Mandatory URL fetching enforcement
