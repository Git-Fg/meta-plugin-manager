---
name: command-development
description: This skill should be used when the user asks to "create a slash command", "add a command", "write a custom command", "define command arguments", "use command frontmatter", "organize commands", "create command with file references", "interactive command", "use AskUserQuestion in command", or needs guidance on slash command structure, YAML frontmatter fields, dynamic arguments, bash execution in commands, user interaction patterns, or command development best practices for Claude Code.
---

# Command Development for Claude Code

## Overview

Slash commands are frequently-used prompts defined as Markdown files that Claude executes during interactive sessions. Understanding command structure, frontmatter options, and dynamic features enables creating powerful, reusable workflows.

**Core principle:** Trust AI intelligence. Commands should specify WHAT to achieve and WHY it matters, then let Claude determine HOW based on context.

## Navigation

| If you are... | You MUST read... |
|---------------|------------------|
| **Understanding command basics** | `references/executable-examples.md` |
| **Configuring YAML frontmatter** (all commands) | `references/frontmatter-reference.md` |
| **Building plugin commands** | `references/plugin-features-reference.md` |
| **Working with interactive commands** | `references/interactive-commands.md` |
| **Testing commands** | `references/testing-strategies.md` |
| **Advanced workflows** | `references/advanced-workflows.md` |
| **Writing documentation** | `references/documentation-patterns.md` |
| **Publishing/distribution** | `references/marketplace-considerations.md` |

**Note:** Frontmatter configuration applies to all commands and is fundamental to command structure.

**⚠️ CRITICAL:** Commands with bash injection ("!") or file references (`@`) MUST validate executable syntax in simulated environment before committing. See `references/testing-strategies.md` Level 0.

## Command Philosophy

### Trust AI Intelligence

Commands should leverage Claude's reasoning capabilities rather than treating it as a script executor. The goal is to tell Claude WHAT to achieve and WHY it matters, then let Claude determine HOW based on context.

**Declarative approach** works best for most commands. State the desired outcome and provide relevant context. Claude will determine the appropriate investigation path, tools to use, and execution order.

**Prescriptive approach** is reserved for situations where:
- Destructive operations with irreversible consequences (deploy to production, delete data)
- Single correct sequence required by external systems (specific format requirements)
- Team consistency is critical (everyone must follow exact same process)
- Error consequences are severe (data loss, security breaches)

For most development tasks, trust Claude's judgment. Specify outcomes, not procedures.

## Command Basics

### What is a Slash Command?

A slash command is a Markdown file containing a prompt that Claude executes when invoked. Commands provide:
- **Reusability**: Define once, use repeatedly
- **Consistency**: Standardize common workflows
- **Sharing**: Distribute across team or projects
- **Efficiency**: Quick access to complex prompts

### Critical: Commands are Instructions FOR Claude

**Commands are written for agent consumption, not human consumption.**

When a user invokes `/command-name`, the command content becomes Claude's instructions. Write commands as directives TO Claude about what to do, not as messages TO the user.

**Correct (instructions for Claude):**
```markdown
Review this code for security vulnerabilities including:
- SQL injection
- XSS attacks
- Authentication issues

Provide specific line numbers and severity ratings.
```

**Incorrect (messages to user):**
```markdown
This command will review your code for security issues.
You'll receive a report with vulnerability details.
```

### Command Locations

**Project commands** (shared with team):
- Location: `.claude/commands/`
- Scope: Available in specific project
- Label: Shown as "(project)" in `/help`

**Personal commands** (available everywhere):
- Location: `~/.claude/commands/`
- Scope: Available in all projects
- Label: Shown as "(user)" in `/help`

**Plugin commands** (bundled with plugins):
- Location: `plugin-name/commands/`
- Scope: Available when plugin installed
- Label: Shown as "(plugin-name)" in `/help`

## File Format

### Basic Structure

Commands are Markdown files with `.md` extension:

```
.claude/commands/
├── review.md           # /review command
├── test.md             # /test command
└── deploy.md           # /deploy command
```

**Simple command:**
```markdown
Review this code for security vulnerabilities including:
- SQL injection
- XSS attacks
- Authentication bypass
- Insecure data handling
```

No frontmatter needed for basic commands.

### With YAML Frontmatter

Add configuration using YAML frontmatter:

```markdown
---
description: Review code for security issues
model: sonnet
---

Review this code for security vulnerabilities...
```

## YAML Frontmatter Fields

### description

**Purpose:** Brief description shown in `/help`
**Type:** String
**Default:** First line of command prompt

```yaml
---
description: Review pull request for code quality
---
```

**Best practice:** Clear, actionable description (under 60 characters)

### allowed-tools

**Purpose:** Specify which tools command can use
**Type:** String or Array
**Default:** Inherits from conversation

```yaml
---
allowed-tools: Read, Write, Edit
---
```

**Guidance:** Default to trust. Only restrict tools when:
- Operation is strictly read-only (analysis commands)
- Command is distributed to untrusted environments
- Specific tool requirement for task

**Use when:** Command requires specific tool access

```yaml
---
# Good: Destructive operation, explicit restriction
allowed-tools: Bash(kubectl:*)
disable-model-invocation: true

# Good: Read-only analysis
allowed-tools: Read, Grep

# Unnecessary: Local dev, default to trust
allowed-tools: Read, Write, Edit, Bash
```

### model

**Purpose:** Specify model for command execution
**Type:** String (sonnet, opus, haiku)
**Default:** Inherits from conversation

```yaml
---
model: haiku
---
```

**Use cases:**
- `haiku` - Fast, simple commands
- `sonnet` - Standard workflows
- `opus` - Complex analysis

### argument-hint

**Purpose:** Document expected arguments for autocomplete
**Type:** String
**Default:** None

```yaml
---
argument-hint: [pr-number] [priority] [assignee]
---
```

**Benefits:**
- Helps users understand command arguments
- Improves command discovery
- Documents command interface

### disable-model-invocation

**Purpose:** Prevent SlashCommand tool from programmatically calling command
**Type:** Boolean
**Default:** false

```yaml
---
disable-model-invocation: true
---
```

**Use when:** Command should only be manually invoked (destructive operations, human judgment required)

## Dynamic Arguments

### Using $ARGUMENTS

Capture all arguments as single string:

```markdown
---
description: Fix issue by number
argument-hint: [issue-number]
---

Fix issue #$ARGUMENTS following our coding standards and best practices.
```

**Usage:**
```
> /fix-issue 123
> /fix-issue 456 --urgent
```

### Using Positional Arguments

Capture individual arguments with `$1`, `$2`, `$3`, etc.:

```markdown
---
description: Review PR with priority and assignee
argument-hint: [pr-number] [priority] [assignee]
---

Review pull request #$1 with priority level $2.
After review, assign to $3 for follow-up.
```

**Usage:**
```
> /review-pr 123 high alice
```

### Combining Arguments

Mix positional and remaining arguments:

```markdown
Deploy $1 to $2 environment with options: $3
```

**Usage:**
```
> /deploy api staging --force --skip-tests
```

## File References

### The At Sign Syntax (@)

Commands can include file contents using the at sign followed by a file path. When the command is invoked, the specified files are read and their contents injected into the prompt before Claude processes it.

### File Reference Patterns

The at sign can reference dynamic paths using argument variables (like dollar-sign-one for the first argument) or static paths known in advance. Multiple files can be referenced in a single command.

### Common Use Cases

File references are useful for code review commands (analyze a specific file), comparison commands (compare two versions), configuration validation (review config files), and template-based generation (use a template as starting point).


## Bash Execution in Commands

### The Exclamation Mark Syntax (!)

Commands can inject bash command output into the prompt using the exclamation mark followed by a command in backticks. The syntax is: exclamation mark, opening backtick, bash command, closing backtick.

When a command is invoked, the bash commands execute BEFORE Claude processes the prompt. Their output becomes part of the context Claude reasons about.

### Purpose of Bash Injection

Use bash injection for gathering current state and injecting dynamic context. Common use cases include git status (current branch, changed files), environment variables, file existence checks, and tool availability verification.

### Trust Pattern

Let Claude determine workflows and execution order. Use bash injection to provide context, not to orchestrate multi-step processes. Claude should decide what to do based on the injected context.

For example, instead of scripting build-test-deploy steps with separate bash invocations, provide the current git state and let Claude determine appropriate deployment steps based on that context.


## Command Organization

### Flat Structure

Simple organization for small command sets:

```
.claude/commands/
├── build.md
├── test.md
├── deploy.md
├── review.md
└── docs.md
```

**Use when:** 5-15 commands, no clear categories

### Namespaced Structure

Organize commands in subdirectories:

```
.claude/commands/
├── ci/
│   ├── build.md        # /build (project:ci)
│   ├── test.md         # /test (project:ci)
│   └── lint.md         # /lint (project:ci)
├── git/
│   ├── commit.md       # /commit (project:git)
│   └── pr.md           # /pr (project:git)
└── docs/
    ├── generate.md     # /generate (project:docs)
    └── publish.md      # /publish (project:docs)
```

**Benefits:**
- Logical grouping by category
- Namespace shown in `/help`
- Easier to find related commands

**Use when:** 15+ commands, clear categories

## Command Patterns by Category

### Analysis and Investigation Commands

Analysis commands benefit most from declarative, high-trust patterns. Specify what to investigate and what to look for. Claude will determine the appropriate investigation method, tools to use, and areas to focus on.

Provide context about what matters (security vulnerabilities, performance bottlenecks, code quality issues) but let Claude decide how to find them. Include heuristics like "focus on high-impact areas" or "consider both code and architecture" to guide without prescribing.

### Deployment and Destructive Operations

Commands that deploy to production, delete data, or modify critical systems require prescriptive patterns. Specify exact steps, include validation, and restrict tools appropriately. Use disable-model-invocation for human-only operations.

For these commands, tool restrictions and explicit sequences are appropriate. The consequences of error justify reduced flexibility.

### Refactoring and Improvement Commands

Refactoring commands work well with declarative patterns. Describe what to look for (large functions, duplicate code, complex conditionals) and what outcomes matter (testability, clarity, reduced coupling). Let Claude identify specific opportunities and approaches.


## Best Practices

### Command Design Principles

1. **Trust AI intelligence:** Define outcomes, not steps. Claude can determine appropriate actions based on context.
2. **Clear descriptions:** Make commands self-explanatory when listed in help.
3. **Minimal tool restrictions:** Default to trust. Only restrict tools for destructive operations or specific requirements.
4. **Document arguments:** Always provide argument-hint to guide users.
5. **Consistent naming:** Use verb-noun patterns (review-pr, fix-issue) for clarity.

### Adaptive vs Static Commands

Adaptive commands describe what to achieve and let Claude determine how. Static commands specify exact execution steps. Prefer adaptive commands for flexibility. Use static commands only when consistency is critical (destructive operations, team standards, external system requirements).

### Heuristics Over Validation

Guide behavior with heuristics rather than strict validation. For example, ask Claude to be conservative when deploying to production rather than hardcoding environment names. Use strict validation only when errors are catastrophic.

### Context Gathering

Use bash injection (exclamation mark syntax) to provide context for Claude to reason about. Do not use it to orchestrate multi-step workflows. Claude should determine what to do based on the injected context.

**You MUST read `references/executable-examples.md` before writing commands.** This reference contains working examples you can adapt.

## Troubleshooting

**Command not appearing:**
- Check file is in correct directory
- Verify `.md` extension present
- Ensure valid Markdown format
- Restart Claude Code

**Arguments not working:**
- Verify `$1`, `$2` syntax correct
- Check `argument-hint` matches usage
- Ensure no extra spaces

**Bash execution failing:**
- Check `allowed-tools` includes Bash
- Verify command syntax in backticks
- Test command in terminal first
- Check for required permissions

**File references not working:**
- Verify `@` syntax correct
- Check file path is valid
- Ensure Read tool allowed
- Use absolute or project-relative paths

## Plugin-Specific Features

### CLAUDE_PLUGIN_ROOT Variable

Plugin commands can access the CLAUDE_PLUGIN_ROOT environment variable, which resolves to the plugin's absolute path. This enables portable references to plugin files, scripts, configuration, and templates.

The variable can be used in bash injection for script execution or in file references for loading configuration and templates. This ensures commands work regardless of where the plugin is installed.

**You MUST read `references/executable-examples.md` before writing plugin commands.**

### Plugin Command Organization

Plugin commands discovered automatically from `commands/` directory:

```
plugin-name/
├── commands/
│   ├── foo.md              # /foo (plugin:plugin-name)
│   ├── bar.md              # /bar (plugin:plugin-name)
│   └── utils/
│       └── helper.md       # /helper (plugin:plugin-name:utils)
└── plugin.json
```

**Namespace benefits:**
- Logical command grouping
- Shown in `/help` output
- Avoid name conflicts

### Plugin Command Patterns

Common plugin command patterns include configuration-based commands (load and use plugin configuration), template-based commands (use templates as starting points), and script-based analysis (execute plugin scripts and interpret results).

Prefer trusting AI over script orchestration. Provide script outputs as context and let Claude determine next steps rather than chaining multiple script executions.

**You MUST read `references/executable-examples.md` before writing plugin commands.**

## Integration with Plugin Components

### Agent Integration

Commands can launch plugin agents for complex tasks. Specify the agent name and what it should accomplish. The agent will have access to plugin resources like configuration files and checklists.

### Skill Integration

Commands can orchestrate skills to delegate complex workflows. Understanding allowed-tools configuration and skill invocation patterns is critical for success.

#### allowed-tools for Skill Orchestration

When a command invokes a skill, the allowed-tools field controls what tools are available during command execution. Two patterns work reliably for skill orchestration:

**Pure delegation pattern**: Set allowed-tools to an empty array or only include the Skill tool. This is ideal when the command's sole purpose is invoking a skill with no direct tool access needed.

**Context gathering plus delegation pattern**: Include tools needed for gathering context (Read, Glob, Grep) plus the Skill tool for the skills being invoked. This allows the command to gather information before delegating to the skill.

#### Critical Requirement

When a command invokes a skill, the skill name must be included in allowed-tools using the format Skill(skill-name). Without this, skill invocation will fail silently.

#### Skill Invocation Language

Commands should use clear natural language to invoke skills. Phrases like "invoke the X skill to..." or "use the X skill to..." work reliably. Let the skill handle its own execution rather than trying to micromanage it.

#### Multi-Skill Orchestration

Commands can invoke multiple skills in sequence. Include all required skill names in allowed-tools. Use natural language to specify the sequence and purpose of each skill invocation.

**You MUST read `references/executable-examples.md` before orchestrating skills from commands.**

### Multi-Component Workflows

Commands can combine agents, skills, and scripts for complex workflows. Use allowed-tools to specify which agents and skills are available, use bash injection for script outputs, and use file references for templates and configuration.

These workflows are appropriate when the task requires specialized analysis, leverages multiple plugin capabilities, or needs complex multi-step coordination.

**You MUST read `references/executable-examples.md` before creating multi-component workflow commands.**

---

## Additional References

**You MUST read the appropriate reference before working on that area:**

| Task | Reference |
|------|-----------|
| Creating commands | `references/executable-examples.md` |
| Configuring frontmatter | `references/frontmatter-reference.md` |
| Plugin features | `references/plugin-features-reference.md` |
| Interactive commands | `references/interactive-commands.md` |
| Testing strategies | `references/testing-strategies.md` |
| Documentation patterns | `references/documentation-patterns.md` |
| Advanced workflows | `references/advanced-workflows.md` |
