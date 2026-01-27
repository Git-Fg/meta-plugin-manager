---
name: skill-development
description: This skill should be used when the user wants to "create a skill", "add a skill to plugin", "write a new skill", "improve skill description", "organize skill content", or needs guidance on skill structure, progressive disclosure, or skill development best practices for Claude Code plugins.
---

# Skill Development Guide

**Purpose**: Help you create clear, self-contained skills

---

## Critical References (MANDATORY)

MANDATORY READ BEFORE ANYTHING ELSE: references/quality-framework.md
READ THIS FILE COMPLETELY. DO NOT SKIP. DO NOT SKIM. NO TAIL.

This reference contains success criteria and validation patterns for skills. Without understanding these, you cannot create effective skills that actually activate and provide value.

The reference contains:
- Success criteria for effective skills
- Autonomy targets (80-95% autonomy)
- Validation frameworks
- Common quality issues
- Testing strategies

You cannot create effective skills without understanding these patterns.

---

## Quick Navigation

| If you are... | MANDATORY READ WHEN... | File |
|---------------|------------------------|------|
| Writing skill descriptions | WHEN WRITING DESCRIPTIONS | `references/description-guidelines.md` |
| Designing for autonomy | WHEN DESIGNING AUTONOMY | `references/autonomy-design.md` |
| Creating orchestration skills | WHEN ORCHESTRATING | `references/orchestration-patterns.md` |
| Troubleshooting skill issues | WHEN TROUBLESHOOTING | `references/anti-patterns.md` |
| Organizing skill content | WHEN ORGANIZING | `references/progressive-disclosure.md` |
| Using advanced execution | WHEN USING ADVANCED | `references/advanced-execution.md` |

**CRITICAL REMINDER**: description-guidelines.md contains trigger phrase patterns. Your skill will not activate without proper description. READ COMPLETELY when writing descriptions.

---

## What Skills Are

Skills are self-contained packages that extend Claude's capabilities. They provide specialized knowledge, workflows, and tools without depending on external files or documentation.

**Key point**: Good skills work on their own. Don't make users hunt through multiple files to understand how to use them.

✅ Good: Skill includes clear examples and guidance
❌ Bad: Skill references other files for important information

**Question**: Would this skill make sense if someone only read this one file? If not, include more context.

---

## Philosophy Foundation

Skills follow these core principles that make them portable and effective.

### Progressive Disclosure for Skills

Skills use a three-tier disclosure structure to manage cognitive load:

**Tier 1: Metadata** (~100 tokens, always loaded)
- Frontmatter: `name`, `description`
- Purpose: Trigger discovery, convey WHAT/WHEN/NOT
- Recognition: This is Claude's first impression

**Tier 2: SKILL.md** (~1,500-2,000 words, loaded on activation)
- Core implementation with workflows and examples
- Structure: Overview (100 words) → Core workflows (1,000-1,300 words) → Examples (300-600 words)
- Purpose: Enable task completion
- Recognition: If approaching 2,000 words, move content to Tier 3

**Tier 3: references/** (on-demand, loaded when needed)
- Deep details, troubleshooting, comprehensive guides
- Each file: 500-1,000 words
- Total package: <10,000 words
- Purpose: Specific use cases without cluttering Tier 2

**Question**: Is this information required for the standard 80% use case? Keep in SKILL.md. If only for specific scenarios, move to references/.

### The Delta Standard for Skills

> Good skill = Expert Knowledge − What Claude Does By Default

Include in skills (Positive Delta):
- **Best practices** - Not just what's possible, but what's RECOMMENDED
- **Modern patterns** - Evolving conventions (React 19, Next.js 15, etc.)
- **Explicit conventions** - Ensuring consistency across sessions
- **Rationale** - Teaching WHY patterns are preferred, not just WHAT
- **Project-specific decisions** - Architecture, tech stack choices
- **Domain expertise** - Specialized knowledge not in general training
- **Anti-patterns** - What to avoid, not just what to do
- **Non-obvious trade-offs** - When to use X vs Y (and why)

Exclude from skills (Zero/Negative Delta):
- **Basic definitions** - "What is a function", "What is TypeScript"
- **How-to tutorials** - "How to write a for loop", "How to use npm"
- **Standard library docs** - "What Array.map does"
- **Things Claude does by default** - Obvious operations that require no guidance

**Recognition questions**:
1. "Does this teach BEST PRACTICE, not just possibility?" → Include
2. "Does this explain WHY, not just WHAT?" → Include
3. "Is this a MODERN pattern Claude might not default to?" → Include
4. "Is this just defining basic concepts?" → Delete
5. "Would Claude do this by default without being told?" → Delete

### Voice and Freedom for Skills

**Voice**: Imperative but natural teaching
- Use imperative form for instructions: "Create the skill directory" not "You should create"
- Make it natural: "Think of this as..." "Remember that..." "Consider that..."
- Why imperative works: Clear, direct, efficient
- Why natural matters: Teaching through rationale and metaphors

**Freedom**: Match specificity to task fragility
- **High freedom**: Creative tasks, multiple valid approaches. Trust Claude's judgment.
- **Medium freedom**: Preferred pattern exists, but adaptation allowed. Templates with parameters.
- **Low freedom**: Fragile or error-prone operations. Specific scripts, exact steps.

**Recognition**: "What breaks if Claude chooses differently?" The more that breaks, the lower the freedom.

| Freedom Level | When to Use | Approach |
|---------------|-------------|----------|
| **High** | Creative tasks, exploration | Text-based principles, trust judgment |
| **Medium** | Structured workflows | Templates with parameters |
| **Low** | Fragile operations | Specific scripts, exact steps |

### Self-Containment for Skills

**Skills must be completely autonomous and self-contained.**

Never reference external files:
- ❌ "See `.claude/rules/principles.md` for guidance"
- ❌ "Refer to skill-development for more details"
- ❌ "Check examples/ directory for samples"

Always include everything directly:
- ✅ Clear examples embedded in SKILL.md
- ✅ Complete explanations inline
- ✅ All context users need

**Why**: External references create coupling. Skills break during refactoring. Components must work in isolation.

**Recognition**: "Does this skill reference files outside itself?" If yes, include that information directly.

**Portability test**: Would this skill work in a project with ZERO `.claude/rules/` dependencies?

---

## Skill Description (CRITICAL)

MANDATORY TO READ WHEN WRITING DESCRIPTIONS: references/description-guidelines.md

Your skill description is the ONLY thing Claude sees to decide when to activate. Poor descriptions = skill never used.

The reference contains:
- Exact trigger phrases that work
- WHEN/NOT patterns for specificity
- Description length guidelines
- Common description errors

Your skill will not activate without a proper description. READ THIS when writing descriptions.

---

## What Good Skills Have

### 1. Self-Containment

**Good skills don't reference external files for critical information.**

Include everything users need:
- Clear examples embedded directly
- Complete explanations
- What users need to know to succeed

✅ Good: Examples shown inline with full context
❌ Bad: "See examples/ directory for samples"

**Question**: Does this skill reference files outside itself? If yes, include that information directly.

### 2. Clear Structure

**Skills should be easy to scan and understand.**

Use:
- Clear section headers
- Code examples with explanations
- Natural flow from basic to advanced

### 3. Progressive Disclosure

**Not everything belongs in the main skill file.**

- **Core content**: What most users need most of the time
- **References/**: Detailed information, edge cases, specific domains

**Question**: Is this information needed by most users? Keep in main file. Is it for specific cases? Move to references/.

### 4. Working Examples

**Users should be able to copy and adapt examples.**

Show:
- Complete, runnable code
- What the output looks like
- Common variations

**Question**: Can users copy this example and use it immediately? If not, make it more complete.

---

## How to Structure a Skill

### Required: SKILL.md File

Every skill needs this structure:

```markdown
---
name: skill-name
description: Brief description of what this skill does
---

# Skill Name

[Your content here]
```

**Key elements**:
- **Frontmatter**: Valid YAML with name and description
- **Description**: What the skill does, in plain language
- **Body**: Your guidance, examples, and explanations

### Optional: Supporting Files

**scripts/** - Executable utilities:
- Validation tools
- Helper scripts
- Automation code

**references/** - Detailed documentation:
- Domain-specific information
- API references
- Edge cases and troubleshooting

**examples/** - Working code samples:
- Complete implementations
- Real-world usage
- Before/after comparisons

**Question**: What supporting files actually help users? Don't create directories you won't use.

---

## Executable Capacities

Skills can execute commands and include dynamic context using special syntax.

### Bash Injection with `!` Syntax

**Purpose**: Execute bash commands and inject output into the skill prompt before Claude sees it.

**Syntax**: `` !`command` `` (backticks)

**Key characteristic**: This is **preprocessing** - commands run BEFORE Claude reads the prompt. The shell command output replaces the placeholder, so Claude receives actual data, not the command itself.

**Requires**: `allowed-tools: Bash` in frontmatter

**Examples**:

```yaml
---
name: my-skill
description: Analyze current git state
allowed-tools: Bash
---

Changed files: !`git diff --name-only HEAD`
Current branch: !`git branch --show-current`

Review changes for:
- Security issues
- Code quality
- Best practices
```

```yaml
---
name: test-analyzer
description: Analyze test coverage
allowed-tools: Bash(npm:*)
---

Test coverage: !`npm test -- --coverage --json 2>&1 | head -100`

Identify files below 80% coverage and suggest improvements.
```

**When to use `!`**:
- Pull small, stable artifacts (current branch, changed files, short diffs)
- Dynamic context gathering (git status, environment vars)
- Project/repository state
- Multi-step workflows with bash

**Best practices**:
- **Always add** `allowed-tools: Bash` to frontmatter
- Test bash commands in terminal first
- Avoid dumping huge outputs (use `--stat`, `--name-only`, or limit lines)
- Use error handling: `` !`command 2>&1 || echo "FAILED"` ``
- Keep commands simple and focused

**Important**: `!` is NOT interactive. You can't use it to run an interactive REPL. Interactive flows must be driven by Claude via the Bash tool after preprocessing.

### File References with `@` Syntax

**Purpose**: Include file contents directly in skill execution. Under the hood, this uses the Read tool.

**Syntax**: `@file-path` or `@$1` (with arguments)

**How it works**: The `@` syntax is a UX shorthand that feeds file content into the prompt using the Read tool. It's about reading, not executing.

**Examples**:

```yaml
---
name: config-validator
description: Validate configuration files
---

Compare @package.json and @package-lock.json for consistency:
- Dependency versions match
- No missing dependencies
- Correct resolution
```

```yaml
---
name: doc-generator
description: Generate documentation
argument-hint: [source-file]
---

Generate documentation for @$1 including:
- Function/class descriptions
- Parameter documentation
- Return values
- Usage examples
```

**When to use `@`**:
- Need to analyze specific files
- Static file references in workflows
- Template-based generation
- Configuration comparison

**Best practices**:
- Use project-relative or absolute paths
- Validate file exists before referencing
- Works with arguments: `@$1`, `@$2`
- Useful for code review, documentation generation

**Important**: `@file.ts` doesn't execute that file; it just reads it. For execution, use `!` syntax or the Bash tool during skill execution.

### Allowed Tools Frontmatter

Skills can restrict which tools Claude can use during execution via `allowed-tools` in frontmatter.

**Syntax**:
```yaml
---
allowed-tools: Bash, Read, Edit, Grep
---
```

**Restrict to specific patterns**:
```yaml
---
allowed-tools: Bash(git:*), Bash(npm:test)
---
```

**Common patterns**:
- `Bash` - Allow all bash commands
- `Bash(git:*)` - Allow only git commands
- `Bash(npm:test)` - Allow only specific npm command
- `Read, Edit, Grep` - Allow file operations
- `[name].mcp:*` - Allow specific MCP server tools

**When to use**:
- Security-conscious skills (audit, security-review)
- Skills using `!` syntax (requires Bash permission)
- Skills with specific tool needs
- Isolation and safety requirements

### Context Fork for Subagents

Skills can run in isolated subagents with specific tools and permissions.

**Frontmatter**:
```yaml
---
context: fork
agent: Explore
---
```

**Available agents**:
- `Explore` - Fast agent for codebase exploration
- `Plan` - Software architect for implementation plans
- Custom subagent - Reference to `.claude/agents/` file

**When to use `context: fork`**:
- Isolation needed (read-only exploration, untrusted code)
- Parallel processing of independent tasks
- Specific tool/permission requirements
- Context isolation (forked skills cannot access caller's conversation history)

**Important**: Forked skills have overhead. Only use when isolation or parallel processing provides clear benefit.

### Tool Usage During Execution

Beyond `!` preprocessing, skills have full access to Claude Code tools during normal operation:

**Standard tools** (available by default, subject to permissions):
- `Read` - Read files
- `Edit` - Edit files
- `Grep` - Search code
- `Glob` - Find files by pattern
- `Bash` - Execute shell commands (requires `allowed-tools: Bash`)
- MCP tools - Model Context Protocol servers

**Execution lifecycle**:
```mermaid
flowchart LR
  A[User invokes skill] --> B[Load skill and frontmatter]
  B --> C[Run all !backticks]
  C --> D[Resolve @mentions to file contents]
  D --> E[Render full prompt with outputs]
  E --> F[Claude executes task using tools]
  F --> G[Return output or edits to user]
```

**Summary of execution capacities**:
1. **`!` preprocessing** - Shell commands run before Claude sees prompt
2. **`@` references** - File contents read via Read tool
3. **Tool usage** - Bash, Edit, Read, Grep, MCP tools during execution
4. **Bundled scripts** - Run scripts in `scripts/` directory
5. **Forked subagents** - Isolated execution with specific permissions

---

## Skill Window Lifecycle

**Critical insight**: Skills are stateless invocations. The "skill window" is the execution lifecycle of a single skill call—nothing more.

### What This Means

**Skills have no persistent state**:
- No hidden JSON tracking active skills
- No memory between invocations
- Each skill call is independent
- Permissions apply ONLY during that specific execution

**The skill window**:
```
┌─────────────────────────────────────────────────────────────────┐
│  Skill Invocation (Permissions ACTIVE via frontmatter)          │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │  Processing → AskUserQuestion? → Processing → Return       ││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
                            ↓
                    Permissions INACTIVE
```

### Multi-Turn Interaction: AskUserQuestion vs Natural Conversation

**AskUserQuestion maintains the skill window**:
- When a skill uses `AskUserQuestion`, the skill remains ACTIVE
- Permissions continue to apply while waiting for user response
- After user responds, the SAME skill invocation continues
- This is the ONLY way to maintain permissions across user responses

**Natural conversation closes the skill window**:
- When a skill responds naturally (without `AskUserQuestion`), the skill finishes
- The next turn is a fresh decision point
- The model may or may not re-invoke the skill
- Permissions from the previous invocation NO LONGER apply

| Interaction Type | Skill Window | Next Turn |
|------------------|--------------|-----------|
| `AskUserQuestion` | Remains ACTIVE | Same skill invocation continues, permissions persist |
| Natural conversation | Closes after response | New turn, model decides fresh, no permissions |

### Examples

**Example 1: Using AskUserQuestion (Window stays open)**
```yaml
---
name: file-analyzer
description: Analyze files with permissions
allowed-tools: Bash, Read, Edit
---

# Analyze file structure

AskUserQuestion: Which file should I analyze?
1. package.json
2. tsconfig.json
3. src/index.ts

# ← User responds: "1"
# ← Still SAME skill, Bash/Read/Edit permissions still active

# Skill can now use those tools:
Reading package.json...
Analyzing dependencies...
Proposing fixes...

# ← Skill completes and returns result
# ← Permissions no longer apply
```

**Example 2: Natural conversation (Window closes)**
```yaml
---
name: file-analyzer
description: Analyze files with permissions
allowed-tools: Bash, Read, Edit
---

# Analyze file structure

Which file should I analyze? Please tell me.
# ← Skill finishes here

# User responds: "package.json"
# ← NEW TURN, no active skill, Bash/Read/Edit permissions DON'T apply

# Model decides what to do - may or may not re-invoke the skill
```

### When to Use AskUserQuestion

**Use `AskUserQuestion` when**:
- Skill needs to maintain permissions across user responses
- Skill needs multi-turn interaction with state
- User response should guide subsequent tool usage within same invocation

**Don't use `AskUserQuestion` when**:
- Skill provides one-shot guidance or information
- Skill completes its task in a single response
- User can naturally provide follow-up context

### Recognition Questions

**Ask yourself**:
- "Does this skill need to maintain permissions across user responses?" → Use `AskUserQuestion`
- "Can this skill complete its task in one response?" → Natural response is fine
- "Will the skill use tools AFTER getting user input?" → Use `AskUserQuestion`

### Anti-Pattern: Natural Conversation Skills

**❌ Skills that try to have natural conversations without AskUserQuestion**

Skills that ask questions naturally will close after their first response. Any subsequent permissions or state are lost.

**Recognition**: "Does this skill ask questions and expect answers while needing to use tools afterward?"

**Example**:
❌ Bad:
```yaml
# "Tell me which file to analyze, then I'll use Read to show you contents."
# ← Skill closes here, Read permission lost
```

✅ Good:
```yaml
AskUserQuestion: "Which file should I analyze?"
# ← Skill stays active, can use Read after user answers
```

**Fix**: Use `AskUserQuestion` for any multi-turn interaction where permissions or state must persist.

---

## Writing Tips

### Use Clear Language

✅ Good: "Include these files in your project"
❌ Bad: "Leverage these file-based artifacts"

✅ Good: "Here's what happens when you run this"
❌ Bad: "This will instantiate the following workflow"

### Provide Examples

Show, don't just tell:
```markdown
# Creating a Skill

1. Create the skill directory:
   mkdir -p .claude/skills/my-skill

2. Add SKILL.md with your content

Example:
---
name: my-skill
description: Does something useful
---

This skill helps you do X.

Here's how:
1. Do Y
2. Do Z

Example:
[working code]
```

### Be Specific

❌ Bad: "Use good file names"
✅ Good: "Use kebab-case: my-skill-name.md"

❌ Bad: "Include helpful content"
✅ Good: "Include a 2-3 sentence description and one working example"

---

## Common Patterns

### Pattern 1: Basic Skill Structure

```markdown
---
name: skill-name
description: What this skill does
---

# Skill Name

## What This Does

Brief explanation of purpose and value.

## How to Use

Step-by-step guidance:

1. First step
2. Second step
3. Third step

## Examples

### Example 1: Basic Usage

[Complete example with code]

### Example 2: Advanced Usage

[Complete example with code]

## Tips

- Tip 1
- Tip 2
- Tip 3
```

### Pattern 2: Tool-Based Skill

```markdown
---
name: tool-skill
description: Use tools to accomplish X
---

# Tool Skill

## Overview

This skill helps you accomplish X using tools.

## When to Use

Use this when:
- You need to do X
- Y situation applies
- You want Z result

## How It Works

[Explain the process]

## Example

[Complete working example]
```

---

## Quality Checklist

A good skill:

- [ ] Has clear name and description
- [ ] Includes working examples users can copy
- [ ] Doesn't reference external files for critical info
- [ ] Uses clear, natural language
- [ ] Has logical structure with headers
- [ ] Includes tips or common variations
- [ ] Balances detail (not too much, not too little)
- [ ] Uses `AskUserQuestion` for multi-turn interactions (not natural conversation)
- [ ] Understands skill window lifecycle and statelessness

**Self-check**: If you were new to this skill, would the content be enough to succeed?

---

## Skill Anti-Patterns

Recognition-based patterns to help identify common issues. Think of these as "smell tests" - quick checks that reveal deeper problems.

### Anti-Pattern 1: Command Wrapper Skills

**❌ Creating skills that just invoke commands**

Pure command invocations are anti-patterns for skills. Well-crafted description usually suffices.

**Recognition**: "Could the description alone suffice?"

**Example**:
❌ Bad: Skill that just runs `/test`
✅ Good: Improve the command description instead

**Fix**: If the skill just runs a command, delete it. Improve the command description.

**Exception**: Use `disable-model-invocation: true` only for destructive operations (deploy, delete, send).

### Anti-Pattern 2: Non-Self-Sufficient Skills

**❌ Skills that require constant user hand-holding**

Skills must achieve 80-95% autonomy (0-5 questions per session).

| Questions | Autonomy | Status |
|----------|----------|--------|
| 0 | 95-100% | Excellent |
| 1-3 | 85-95% | Good |
| 4-5 | 80-85% | Acceptable |
| 6+ | <80% | Fail |

**Recognition**: "Can this work standalone?"

**Fix**: Add concrete patterns, examples, and decision criteria.

### Anti-Pattern 3: Context Fork Misuse

**❌ Using context fork when overhead isn't justified**

Forked skills cannot access caller's conversation history.

**Recognition**: "Is the overhead justified?"

**Fix**: Use fork only for isolation, parallel processing, or untrusted code. Otherwise use regular skill invocation.

### Anti-Pattern 4: Zero/Negative Delta

**❌ Providing information Claude already knows**

For each piece of content, ask: "Would Claude know this without being told?"

**Positive Delta (keep)**:
- Project-specific architecture decisions
- Domain expertise not in general training
- Non-obvious bug workarounds
- Team-specific conventions

**Zero/Negative Delta (remove)**:
- General programming concepts
- Standard library documentation
- Common patterns Claude already knows
- Generic tutorials

**Fix**: Delete content that Claude would know from training.

### Anti-Pattern 5: Empty Scaffolding

**❌ Creating directories with no content**

Empty directories create technical debt.

**Recognition**: Is this directory empty with no planned content?

**Fix**: Remove directories with no content immediately after refactoring.

### Anti-Pattern 6: Reference Fragmentation

**❌ Skills that reference external files for critical information**

❌ Bad: "For examples, see examples/basic.md"
✅ Good: Include examples directly in SKILL.md

**Why**: Users shouldn't need to open multiple files to understand your skill.

**Recognition**: "Does this skill reference files outside itself?"

**Fix**: Include all critical information directly in SKILL.md.

### Anti-Pattern 7: Vague Triggering

**❌ Generic descriptions that don't indicate when to use**

❌ Bad: "This skill helps with development"
✅ Good: "This skill creates automated tests for React components"

**Recognition**: "Does the description use specific user queries?"

**Fix**: Use exact phrases: "Use when user asks to 'create a skill', 'add a skill to plugin'..."

### Anti-Pattern 8: Missing Examples

**❌ Skills that explain without showing**

❌ Bad: "Use the API to get data"
✅ Good: "Call the API like this: `fetch('/api/data')`"

**Recognition**: "Can users copy an example and use it immediately?"

**Fix**: Show, don't just tell. Include complete, runnable examples.

### Anti-Pattern 9: Natural Conversation Without AskUserQuestion

**❌ Skills that try to have natural conversations without AskUserQuestion**

Skills that ask questions naturally will close after their first response. Any subsequent permissions or state are lost.

**Recognition**: "Does this skill ask questions and expect answers while needing to use tools afterward?"

**Example**:
❌ Bad: "Tell me which file to analyze, then I'll use Read to show you contents."
✅ Good: Use `AskUserQuestion` with structured options

**Why bad**: Without `AskUserQuestion`, the skill window closes after the first response. The user's answer comes in a new turn where the skill is no longer active, so permissions (like `allowed-tools: Read`) no longer apply.

**Fix**: Use `AskUserQuestion` for any multi-turn interaction where permissions or state must persist. See the "Skill Window Lifecycle" section for details.

---

## Getting Started

1. **Plan your skill**
   - What problem does it solve?
   - Who will use it?
   - What do they need to know?

2. **Create the structure**
   - Make the directory
   - Add SKILL.md
   - Add supporting files if needed

3. **Write the content**
   - Start with what/why
   - Add how with examples
   - Include tips and variations

4. **Review and refine**
   - Read it like a new user
   - Can they succeed with just this file?
   - Is the language clear?

---

## Remember

Skills are for helping people accomplish things. Keep the focus on:
- Clarity over cleverness
- Examples over explanations
- Self-contained over scattered
- Specific over vague

Good skills are obvious. When someone reads them, they know exactly what to do.

**Question**: Is your skill clear enough that a stranger could use it successfully?

---

**Final tip**: The best skill is one that helps someone accomplish their goal with less confusion and friction. Focus on that.
