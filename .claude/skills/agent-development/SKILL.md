---
name: agent-development
description: This skill should be used when the user asks to "create an agent", "add an agent", "write a subagent", "agent frontmatter", "when to use description", "agent examples", "agent tools", "agent colors", "autonomous agent", or needs guidance on agent structure, system prompts, triggering conditions, or agent development best practices. Focuses on project agents (.claude/agents/) with guidance for global (~/.claude/agents/) and plugin (plugin/agents/) locations.
---

# Agent Development Guide

**Purpose**: Help you create autonomous agents that handle complex tasks independently

---

## What Agents Are

Agents are autonomous subprocesses that handle complex, multi-step tasks in an isolated context window. They work independently without depending on conversation history or external documentation.

**Key point**: Good agents don't need hand-holding. They include everything needed to operate autonomously.

✅ Good: Agent includes specific triggering examples with <example> blocks
❌ Bad: Agent references external documentation for triggering
Why good: Agents must self-trigger without external dependencies

**Question**: Would this agent work if moved to a project with no rules? If no, include the necessary context directly.

---

## What Good Agents Have

### 1. Clear Triggering

**Good agents tell Claude exactly when to use them.**

Include specific triggering conditions with concrete examples:

```yaml
description: Use this agent when user asks to "analyze code for security". Examples:

<example>
Context: User wants security review
user: "Analyze this code for vulnerabilities"
assistant: "I'll use the security-analyzer agent to conduct a comprehensive review"
<commentary>
Agent should trigger when user asks for security analysis
</commentary>
</example>
```

✅ Good: Specific triggering examples with context, user request, and assistant response
❌ Bad: Vague descriptions like "use for code help"
Why good: Specific triggers enable autonomous decision-making

### 2. Complete System Prompt

**Good agents include everything needed to operate independently.**

Structure the system prompt with clear sections:

```markdown
You are [agent role description]...

**Your Core Responsibilities:**
1. [Responsibility 1]
2. [Responsibility 2]

**Analysis Process:**
1. [Step 1]
2. [Step 2]

**Output Format:**
[What to return]
```

✅ Good: Complete prompt with responsibilities, process, and output format
❌ Bad: "See external documentation for prompt details"
Why good: Self-contained agents work without external references

### 3. No External Dependencies

**Good agents work in isolation.**

Include all necessary context directly:

- Don't reference .claude/rules/ files
- Don't link to external documentation
- Bundle any needed philosophy or principles
- Include all examples inline

✅ Good: Self-contained with all context included
❌ Bad: References external files for critical information
Why good: Agents must work anywhere without depending on project setup

### 4. Isolated Operation

**Good agents don't need conversation history.**

Since agents don't inherit caller context:
- Include all necessary background in the system prompt
- Define clear input/output formats
- Specify what tools are available
- Don't assume knowledge from previous messages

**Example**:
```yaml
tools: ["Read", "Write", "Grep"]
color: blue
model: inherit
```

**Question**: Does this agent assume knowledge from the conversation? If yes, include that context in the system prompt.

---

## How to Structure an Agent

### Basic Agent Structure

Agents use YAML frontmatter followed by a system prompt:

```markdown
---
name: agent-identifier
description: Use this agent when [specific triggering conditions]. Examples:

<example>
Context: [Situation description]
user: "[User request]"
assistant: "[How assistant should respond]"
<commentary>
[Why this agent should be triggered]
</commentary>
</example>

model: inherit
color: blue
tools: ["Read", "Write", "Grep"]
---

You are [agent role description]...

**Your Core Responsibilities:**
1. [Responsibility 1]
2. [Responsibility 2]

**Analysis Process:**
1. [Step 1]
2. [Step 2]

**Output Format:**
[What to return]
```

### Frontmatter Fields

**name** (required):
- Agent identifier for invocation
- Format: lowercase, numbers, hyphens
- Length: 3-50 characters

**description** (required):
- Defines when Claude should trigger this agent
- Include <example> blocks with triggering scenarios
- Each example needs: Context, user request, assistant response, commentary

**model** (optional):
- Override conversation default
- Default: inherit

**color** (optional):
- Visual identifier
- Default: blue

**tools** (optional):
- Specify available tools
- Default: inherits from conversation

---

## Common Patterns

### When to Use Agents

Use agents when:
- Task would clutter the conversation
- Need isolated context for noisy operations
- Require specialized expertise consistently
- Handling multi-step workflows

Don't use agents when:
- Simple one-time operations
- Native tools would work fine
- Overhead exceeds benefit

**Example**:
```yaml
# Good use case: Complex code analysis
name: code-analyzer
description: "Use when user asks to 'analyze code for security issues'"

# Poor use case: Simple file reading
# Just use Read tool directly
```

### Triggering Examples

Make triggering concrete and specific:

✅ Good:
```yaml
description: "Use when user asks to 'review pull request for bugs'"

<example>
Context: Developer submitted PR
user: "Can you review this PR?"
assistant: "I'll use the code-reviewer agent to analyze it"
</example>
```

❌ Bad:
```yaml
description: "Use for code review tasks"
```

---

## Common Mistakes

### Mistake 1: Vague Triggering

❌ Bad:
```yaml
description: "Use for code help"
```

✅ Good:
```yaml
description: "Use when user asks to 'analyze code for security vulnerabilities'"

<example>
Context: User wants security review
user: "Check this code for issues"
assistant: "I'll use the security-analyzer agent"
</example>
```

**Why**: Specific triggering enables autonomous decision-making.

### Mistake 2: Incomplete System Prompt

❌ Bad:
```markdown
You are a code analyzer.
```

✅ Good:
```markdown
You are a code security analyzer.

**Your Core Responsibilities:**
1. Identify security vulnerabilities
2. Provide specific remediation guidance

**Analysis Process:**
1. Scan for common security issues
2. Check input validation
3. Review authentication logic

**Output Format:**
- List each vulnerability
- Include severity rating
- Provide fix recommendations
```

**Why**: Complete prompts enable autonomous operation.

### Mistake 3: Using Skill Fields in Agents

❌ Bad:
```yaml
context: fork
user-invocable: true
```

✅ Good:
```yaml
model: inherit
color: blue
tools: ["Read", "Write"]
```

**Why**: Agents and skills have different field requirements.

### Mistake 4: Assuming Conversation Context

❌ Bad:
```markdown
Review the changes we discussed...
```

✅ Good:
```markdown
Review the provided code for security issues...

[Include all necessary context in the prompt]
```

**Why**: Agents don't inherit conversation history.

---

## Best Practices

### Writing Style

**Use clear, specific language:**

✅ Good:
- "Use this agent when user asks to..."
- "Include specific examples..."
- "Provide step-by-step process..."

❌ Bad:
- "This agent helps with..."
- "You should include..."
- "Make sure to..."

### Examples

**Include working examples:**

Show complete, real examples that users can copy and adapt:

```yaml
description: "Use when user asks to 'refactor Python code for performance'"

<example>
Context: User has slow Python code
user: "Make this code faster"
assistant: "I'll use the performance-refactorer agent to analyze and optimize it"
</example>
```

### Organization

**Structure for scanning:**

- Clear headers
- Bullet points for lists
- Code blocks for examples
- Short paragraphs

**Question**: Is the structure easy to scan? If not, simplify it.

---

## Quality Checklist

A good agent:

- [ ] Has clear description with specific triggering examples
- [ ] Includes <example> blocks with context, user request, and assistant response
- [ ] Has complete system prompt with responsibilities and process
- [ ] Works in isolation without external references
- [ ] Includes all necessary context (no conversation history dependency)
- [ ] Uses appropriate fields (name, description, model, color, tools)

**Self-check**: Could this agent work if moved to a fresh project? If not, it needs more context.

---

## Summary

Agents are autonomous subprocesses that handle complex tasks independently. Good agents:

- **Trigger clearly** - Specific examples with context
- **Stand alone** - No external dependencies
- **Work independently** - Complete system prompt with all context
- **Stay focused** - Clear responsibilities and process

Keep the focus on:
- Clarity over complexity
- Examples over explanations
- Self-contained over scattered
- Specific over vague

**Question**: Is your agent clear enough that Claude would know exactly when and how to use it?

---

**Final tip**: The best agent is one that handles its task completely without needing hand-holding. Focus on that.
