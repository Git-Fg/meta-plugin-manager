---
name: command-development
description: This skill should be used when the user asks to "create a slash command", "add a command", "write a custom command", "define command arguments", "use command frontmatter", "organize commands", "create command with file references", "interactive command", "use AskUserQuestion in command", or needs guidance on slash command structure, YAML frontmatter fields, dynamic arguments, bash execution in commands, user interaction patterns, or command development best practices for Claude Code.
---

# Command Development Guide

**Purpose**: Help you create clear, reusable commands

---

## What Commands Are

Commands are Markdown files that Claude executes when invoked. They provide reusable workflows, consistency across team usage, and efficient access to complex prompts.

**Key point**: Commands are instructions FOR Claude, not messages TO users. Write what Claude should do, not what will happen for the user.

✅ Good: "Review this code for security vulnerabilities..."
❌ Bad: "This command will review your code for security issues..."

**Question**: Would this command make sense if someone only read this one file? If not, include more context.

---

## What Good Commands Have

### 1. Self-Containment

**Good commands don't reference external files for critical information.**

Include everything users need:
- Complete examples embedded directly
- Clear explanations
- What users need to know to succeed

✅ Good: Examples shown inline with full context
❌ Bad: "See reference files for examples"

**Question**: Does this command reference files outside itself? If yes, include that information directly.

### 2. Clear Purpose

**Every command should have one clear job.**

Be specific:
- What does it do?
- When should someone use it?
- What will happen?

✅ Good: "Review code for security issues"
❌ Bad: "Use this to check code"

### 3. Working Examples

**Users should be able to copy and adapt examples.**

Show:
- Complete command structure
- What the output looks like
- Common variations

**Question**: Can users copy this command and use it immediately? If not, make it more complete.

---

## How to Structure a Command

### Basic Command (No Frontmatter)

Simple commands just need the prompt:

```markdown
Review this code for security vulnerabilities including:
- SQL injection
- XSS attacks
- Authentication bypass
- Insecure data handling
```

### With YAML Frontmatter

Add configuration using YAML frontmatter:

```markdown
---
description: Review code for security issues
model: sonnet
---

Review this code for security vulnerabilities including:
- SQL injection
- XSS attacks
- Authentication bypass
- Insecure data handling
```

**Key elements**:
- **description**: Brief description shown in `/help`
- **model**: Optional model specification
- **allowed-tools**: Specify which tools command can use

---

## Frontmatter Fields

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
allowed-tools: ["Read", "Write", "Bash"]
---

[Command prompt]
```

**Best practice:** Only specify if command needs specific tools.

### model

**Purpose:** Override conversation default model
**Type:** String

```yaml
---
model: sonnet
---

[Command prompt]
```

**Best practice:** Only use if command needs specific model.

---

## Dynamic Features

### Arguments ($1, $2)

Pass parameters to commands:

```yaml
---
argument-hint: "file or directory to review"
---

Review this $1 for security vulnerabilities.
```

**Usage:**
- `$1` - First argument
- `$2` - Second argument
- `$3` - Third argument

**Best practice:** Document arguments with `argument-hint`

### Bash Injection (!command)

Execute commands and inject output:

```yaml
---
allowed-tools: ["Bash"]
---

Check if tests pass:
!npm test

Review the test results.
```

**Usage:**
- `!command` - Execute command
- Output becomes part of command prompt

**Best practice:** Test bash injection before using

### File References (@file)

Reference files in project:

```yaml
---
allowed-tools: ["Read"]
---

Review this code:
@src/index.js

Check for security issues.
```

**Usage:**
- `@file` - Reference file
- File contents become part of command prompt

**Best practice:** Use project-relative or absolute paths

---

## Command Organization

### Project Commands

Location: `.claude/commands/`

Scope: Available in current project

```markdown
.claude/commands/
├── review.md           # /review command
├── test.md             # /test command
└── deploy.md           # /deploy command
```

### Personal Commands

Location: `~/.claude/commands/`

Scope: Available in all projects

```markdown
~/.claude/commands/
├── personal-helper.md
└── universal-reviewer.md
```

### Plugin Commands

Location: `plugin-name/commands/`

Scope: Available when plugin installed

```markdown
plugin-name/
├── commands/
│   ├── foo.md              # /foo
│   ├── bar.md              # /bar
│   └── utils/
│       └── helper.md       # /utils/helper
└── plugin.json
```

---

## Command Types

### Simple Commands

Just provide instructions to Claude:

```markdown
Review this code for bugs:

1. Check for syntax errors
2. Look for logic issues
3. Verify edge cases
```

**Best for:** Straightforward tasks, one-time operations

### Interactive Commands

Use AskUserQuestion for user input:

```yaml
---
allowed-tools: ["AskUserQuestion"]
---

Ask the user: "What type of code review do you want?"
- Security focus
- Performance focus
- General review

Based on their answer, provide tailored review guidance.
```

**Best for:** Commands that need user input or customization

### Script Commands

Combine with bash injection:

```yaml
---
allowed-tools: ["Bash", "Read"]
---

Check the project structure:
!find . -name "*.js" -type f

Review the main files:
@src/index.js
@src/app.js

Provide feedback on code quality.
```

**Best for:** Commands that benefit from automated checks

---

## Best Practices

### Writing Style

**Use imperative voice:**

✅ Good: "Review this code for..."
✅ Good: "Check the test results..."
✅ Good: "Provide suggestions for..."

❌ Bad: "This will review your code..."
❌ Bad: "You should check..."

### Frontmatter

**Keep it simple:**

✅ Good:
```yaml
---
description: Review code for security issues
---

[Command prompt]
```

❌ Bad: Overly complex frontmatter with unnecessary fields

### Examples

**Include working examples:**

✅ Good:
```markdown
Review this code for security vulnerabilities:

!find . -name "*.js" -type f

Check each file for:
1. SQL injection risks
2. XSS vulnerabilities
3. Authentication issues
```

❌ Bad: Examples that don't show real usage

### Error Handling

**Anticipate common issues:**

```markdown
Review this code. If you encounter:
- Permission errors: Skip those files
- Large files: Focus on key functions
- Unknown syntax: Note the issue and continue

Provide a summary of findings.
```

---

## Common Mistakes

### Mistake 1: Messages to Users

❌ Bad:
```markdown
This command will review your code for security issues.
You'll receive a report with vulnerability details.
```

✅ Good:
```markdown
Review this code for security vulnerabilities including:
- SQL injection
- XSS attacks
- Authentication bypass
- Insecure data handling

Provide specific line numbers and severity ratings.
```

**Why**: Commands are instructions FOR Claude, not messages TO users.

### Mistake 2: Vague Descriptions

❌ Bad:
```yaml
---
description: Helpful code tool
---
```

✅ Good:
```yaml
---
description: Review code for security issues
---
```

**Why**: Specific descriptions help users find and use commands.

### Mistake 3: No Examples

❌ Bad:
```markdown
Review code.
```

✅ Good:
```markdown
Review this code for security vulnerabilities:

!find . -name "*.js" -type f

Check each file systematically.
```

**Why**: Users need to see what good looks like.

### Mistake 4: Missing allowed-tools

❌ Bad:
```yaml
---
description: Run tests
---

!npm test
```

✅ Good:
```yaml
---
description: Run tests
allowed-tools: ["Bash"]
---

!npm test
```

**Why**: Claude needs permission to use tools.

---

## Advanced Features

### Skill Orchestration

Commands can invoke skills:

```yaml
---
allowed-tools: ["Skill(skill-development)"]
---

Use the skill-development skill to create a new skill for code review automation.
```

**Best practice**: Use natural language to invoke skills.

### Agent Launch

Commands can launch agents:

```yaml
---
allowed-tools: ["Agent(code-reviewer)"]
---

Launch the code-reviewer agent to conduct a comprehensive security audit.
```

**Best practice**: Specify what the agent should accomplish.

### Multi-Step Workflows

Combine features:

```yaml
---
description: Complete code review
allowed-tools: ["Read", "Bash", "AskUserQuestion"]
---

1. Ask user: "What type of review?"
   - Security
   - Performance
   - General

2. Scan codebase:
   !find . -name "*.js" -type f

3. Review key files:
   @src/index.js
   @src/app.js

4. Provide comprehensive feedback.
```

---

## Testing Commands

### Test Triggering

1. Write command with specific examples
2. Use similar phrasing to examples
3. Check Claude loads the command
4. Verify command provides expected functionality

### Test Features

**Arguments:**
```bash
/command-name test-file.js
```

**Bash injection:**
```bash
!npm test
```

**File references:**
```bash
@src/index.js
```

**Best practice**: Test all features before sharing command.

---

## Quality Checklist

A good command:

- [ ] Has clear description
- [ ] Uses imperative voice
- [ ] Includes working examples
- [ ] Specifies allowed-tools when needed
- [ ] Has one clear purpose
- [ ] Doesn't reference external files
- [ ] Uses natural language
- [ ] Balances detail (not too much, not too little)

**Self-check**: If you were new to this command, would the content be enough to succeed?

---

## Remember

Commands are for:
- Reusable workflows
- Consistency across team
- Efficiency in complex tasks

Keep the focus on:
- Clarity over cleverness
- Examples over explanations
- Self-contained over scattered
- Specific over vague

Good commands are obvious. When someone reads them, they know exactly what to do.

**Question**: Is your command clear enough that a stranger could use it successfully?

---

**Final tip**: The best command is one that helps someone accomplish their goal with less confusion and friction. Focus on that.
