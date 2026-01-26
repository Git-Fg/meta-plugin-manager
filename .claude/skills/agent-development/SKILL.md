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

## Philosophy Foundation

Agents follow these core principles that enable autonomous operation in isolated contexts.

### Progressive Disclosure for Agents

Agents use condensed disclosure (isolation context requires completeness):

**Tier 1: Metadata** (~100 tokens, always loaded)
- `description`: When to trigger + <example> blocks
- Purpose: Autonomous triggering without human decision

**Tier 2: System Prompt** (1,000-1,500 words, loaded on fork)
- Role, responsibilities, process
- Complete operational context
- All domain knowledge needed
- Purpose: Enable autonomous operation

**Why condensed?** Agents work in isolation without access to caller context. They must be complete.

**Recognition**: "Would this agent work if moved to a project with no rules?"

### The Delta Standard for Agents

> Good agent = Domain-specific knowledge − General agent concepts

Include in agents (Positive Delta):
- Specific domain expertise
- Triggering logic with examples
- Analysis frameworks for the domain
- Output format requirements
- Domain-specific validation criteria

Exclude from agents (Zero/Negative Delta):
- General coding practices
- How to use tools Claude already knows
- Generic "be thorough" instructions
- Obvious task steps

**Recognition**: "Is this knowledge specific to this agent's domain?"

### Voice and Freedom for Agents

**Voice**: Imperative system prompts (clear instructions)

Use imperative form in agent prompts:
- "Analyze the code for X, Y, Z patterns" not "You should analyze..."
- "Return findings in format: [specification]" not "Consider returning..."
- Direct and efficient: "Check X, validate Y, report Z"

**Freedom**: Medium for most agents (autonomy requires some structure)

| Freedom Level | When to Use | Agent Examples |
|---------------|-------------|----------------|
| **High** | Creative exploration, research | Explore agent (read-only analysis) |
| **Medium** | Structured autonomous tasks | Most task-specific agents |
| **Low** | Critical/sensitive operations | Security auditor, deployment agents |

**Recognition**: "Does this agent need predictable consistency or creative flexibility?"

### Self-Containment for Agents (CRITICAL)

**Agents MUST be completely self-contained. This is the most critical principle.**

Never reference external files:
- ❌ "See `.claude/rules/principles.md` for guidance"
- ❌ "Refer to skill-development for patterns"
- ❌ "Check documentation for full context"

Always include everything:
- ✅ Complete system prompt
- ✅ All domain knowledge needed
- ✅ Full examples of expected outputs
- ✅ Complete process instructions

**Why**: Agents fork into isolated contexts without access to project setup or documentation.

**Portability test**: Would this agent work in a project with ZERO `.claude/` configuration?

### Cognitive Load Distribution for Agents

Agents do heavy thinking internally; users only see results.

**Internal cognition (heavy)**:
- Brainstorming and analysis
- Framework application
- Systematic elimination
- Pattern recognition

**External output (light)**:
- Only crafted questions emerge
- Final results and recommendations
- Specific file:line references

**Why**: Agent contexts are expensive - maximize internal cognition, minimize external chatter.

**Recognition**: "Is the agent doing the thinking, or asking the user to think?"

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
disallowedTools: []
permissionMode: default
skills: []
hooks: {}
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
- Model to use: `sonnet`, `opus`, `haiku`, or `inherit`
- Default: inherit (uses same model as main conversation)

**color** (optional):
- Visual identifier for UI
- Default: blue

**tools** (optional):
- Specify available tools (allowlist)
- Default: inherits all tools from conversation

**disallowedTools** (optional):
- Tools to deny (denylist), removed from inherited or specified list
- Example: `["Write", "Edit"]` for read-only agent

**permissionMode** (optional):
- Permission handling mode: `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan`
- Default: default
- Use with caution: `bypassPermissions` skips all permission checks

**skills** (optional):
- Skills to preload into agent's context at startup
- Full skill content is injected, not just made available for invocation
- Agents don't inherit skills from parent conversation
- Example: `["file-search", "domain-knowledge"]`

**hooks** (optional):
- Lifecycle hooks scoped to this agent
- Events: `PreToolUse`, `PostToolUse`, `Stop`
- Example: `PreToolUse: [{matcher: "Bash", hooks: [{type: command, command: "./validate.sh"}]}]`

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

## Advanced Agent Features

### Preloading Skills

Use the `skills` field to inject skill content into an agent's context at startup. This gives agents domain knowledge without requiring them to discover and load skills during execution.

**Example agent with preloaded skills:**
```yaml
---
name: api-developer
description: "Use when implementing API endpoints following team conventions"
skills:
  - api-conventions
  - error-handling-patterns
---

Implement API endpoints. Follow the conventions and patterns from the preloaded skills.
```

**Key points:**
- The full content of each skill is injected into the agent's context
- Not just made available for invocation - the content is loaded directly
- Agents don't inherit skills from the parent conversation
- List them explicitly in the `skills` array

**When to use:**
- Agent needs domain-specific knowledge
- Skills contain critical patterns the agent must follow
- You want the agent to have expertise without asking it to discover skills

**Recognition**: "Does this agent need domain knowledge that exists in skills?"

### Agent Hooks

Agents can define hooks that run during the agent's lifecycle. Configure hooks in two ways:

**1. In agent frontmatter** (runs only while that agent is active):
```yaml
---
name: code-reviewer
description: "Review code with automatic linting"
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "./scripts/validate-command.sh"
  PostToolUse:
    - matcher: "Edit|Write"
      hooks:
        - type: command
          command: "./scripts/run-linter.sh"
---
```

**2. In settings.json** (runs when agent starts/stops):
```json
{
  "hooks": {
    "SubagentStart": [
      {
        "matcher": "code-reviewer",
        "hooks": [
          { "type": "command", "command": "./scripts/setup-review.sh" }
        ]
      }
    ],
    "SubagentStop": [
      {
        "matcher": "code-reviewer",
        "hooks": [
          { "type": "command", "command": "./scripts/cleanup-review.sh" }
        ]
      }
    ]
  }
}
```

**Available hook events:**

| Event | Matcher Input | When it fires |
|-------|---------------|---------------|
| `PreToolUse` | Tool name | Before the agent uses a tool |
| `PostToolUse` | Tool name | After the agent uses a tool |
| `Stop` | (none) | When the agent finishes |

**When to use hooks:**
- Validate operations before they execute
- Run linters after file edits
- Setup/cleanup for specific agents
- Conditional rules based on tool usage

### Execution Modes

Agents can run in **foreground** (blocking) or **background** (concurrent) mode:

**Foreground agents:**
- Block the main conversation until complete
- Permission prompts passed through to user
- Clarifying questions (AskUserQuestion) work normally
- Used for: Interactive tasks, tasks requiring user feedback

**Background agents:**
- Run concurrently while you continue working
- Inherit parent's permissions but auto-deny anything not pre-approved
- If background agent needs permission it doesn't have, the tool call fails but agent continues
- MCP tools not available in background agents
- Used for: Long-running tasks, independent research, parallel operations

**Claude decides the mode** based on the task. You can also:
- Ask Claude to "run this in the background"
- Press Ctrl+B to background a running task

**Recognition**: "Does this task need interactive feedback, or can it run independently?"

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
disable-model-invocation: true
```

✅ Good:
```yaml
model: inherit
color: blue
tools: ["Read", "Write"]
skills: []  # Valid for agents
permissionMode: default  # Valid for agents
```

**Why**: Agents and skills have different field requirements. Valid agent fields: `name`, `description`, `model`, `color`, `tools`, `disallowedTools`, `permissionMode`, `skills`, `hooks`. Valid skill fields include `context`, `user-invocable`, `disable-model-invocation`.

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

### Resuming Agents

Each agent invocation creates a new instance with fresh context. To continue an existing agent's work instead of starting over, ask Claude to resume it. Resumed agents retain their full conversation history, including all previous tool calls, results, and reasoning.

**Example:**
```
User: Use the code-reviewer agent to review the authentication module
[Agent completes]
User: Continue that code review and now analyze the authorization logic
[Claude resumes the agent with full context from previous conversation]
```

**When to resume:**
- Multi-phase workflows that share context
- Follow-up work on previous agent analysis
- When you want to preserve the agent's conversation history

---

## Agent Anti-Patterns

Recognition-based patterns to avoid when creating agents.

### Anti-Pattern 1: Vague Triggering

**❌ Generic descriptions that don't enable autonomous triggering**

❌ Bad: "Use this agent for code help"
✅ Good: "Use this agent when user asks to 'analyze code for security'. Examples: <example>Context: User wants security review. user: 'Analyze this code for vulnerabilities' assistant: 'I'll use the security-analyzer agent'</example>"

**Recognition**: "Does the description include specific <example> blocks?"

**Why**: Agents trigger autonomously. Without specific examples, they won't activate correctly.

### Anti-Pattern 2: Incomplete System Prompts

**❌ Agents that assume context or omit critical instructions**

❌ Bad: "Analyze code for issues" (no process, no output format)
✅ Good: "You are a security analyzer. **Process**: 1) Scan for SQL injection, 2) Check XSS patterns, 3) Validate auth. **Output**: File:line with severity rating."

**Recognition**: "Could a fresh instance follow these instructions without asking questions?"

**Why**: Agents work in isolation. Incomplete prompts cause failures or excessive questions.

### Anti-Pattern 3: Using Skill Fields in Agents

**❌ Applying skill-specific fields to agents**

❌ Bad: Adding `user-invocable` or `disable-model-invocation` to agents
✅ Good: Use only agent-specific fields: `name`, `description`, `model`, `color`, `tools`

**Recognition**: "Is this field valid for agents?"

**Why**: Agents have different fields than skills/commands. Using wrong fields causes silent failures.

### Anti-Pattern 4: Assuming Conversation Context

**❌ Agents that reference the conversation history**

❌ Bad: "As discussed earlier, analyze the code..." or "Continue from where we left off..."
✅ Good: "Analyze this code from scratch assuming no prior context."

**Recognition**: "Does this agent assume it has access to conversation history?"

**Why**: Agents fork into isolated contexts. They cannot access the parent conversation.

### Anti-Pattern 5: External Dependencies

**❌ Agents that reference external files or documentation**

❌ Bad: "See `.claude/rules/` for patterns" or "Check documentation for full context"
✅ Good: Include all necessary information directly in the agent prompt.

**Recognition**: "Does this agent reference files outside itself?"

**Why**: Agents must be completely self-contained. External references break portability.

### Anti-Pattern 6: Missing Output Format

**❌ Agents that don't specify what to return**

❌ Bad: "Find security issues" (no format specified)
✅ Good: "Return findings as: **File:line** - **Issue** (severity): Description"

**Recognition**: "Does the agent know exactly what format to use for output?"

**Why**: Clear output formats enable predictable integration and parsing.

---

## Quality Checklist

A good agent:

- [ ] Has clear description with specific triggering examples
- [ ] Includes <example> blocks with context, user request, and assistant response
- [ ] Has complete system prompt with responsibilities and process
- [ ] Works in isolation without external references
- [ ] Includes all necessary context (no conversation history dependency)
- [ ] Uses appropriate fields (name, description, model, color, tools)
- [ ] Uses `skills` for domain knowledge (not external references)
- [ ] Uses `disallowedTools` for tool restrictions (when needed)
- [ ] Specifies `permissionMode` for permission handling (when needed)
- [ ] Uses `hooks` for lifecycle automation (when needed)

**Self-check**: Could this agent work if moved to a fresh project? If not, it needs more context.

**Frontmatter validation:**
- [ ] Only uses valid agent fields (not skill fields like `context` or `user-invocable`)
- [ ] `model` uses valid value: `sonnet`, `opus`, `haiku`, or `inherit`
- [ ] `permissionMode` uses valid value: `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan`

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
