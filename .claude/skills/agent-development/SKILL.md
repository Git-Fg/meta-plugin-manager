---
name: agent-development
description: This skill should be used when the user asks to "create an agent", "add an agent", "write a subagent", "agent frontmatter", "when to use description", "agent examples", "agent tools", "agent colors", "autonomous agent", or needs guidance on agent structure, system prompts, triggering conditions, or agent development best practices. Focuses on project agents (.claude/agents/) with guidance for global (~/.claude/agents/) and plugin (plugin/agents/) locations.
---

# Agent Development: Architectural Refiner

**Role**: Transform intent into portable, autonomous agents
**Mode**: Architectural pattern application (ensure output has specific traits)

---

## Architectural Pattern Application

When building an agent, apply this process:

1. **Analyze Intent** - What type of agent and what traits needed?
2. **Apply Teaching Formula** - Bundle condensed philosophy into output
3. **Enforce Portability Invariant** - Ensure works in isolation
4. **Verify Traits** - Check autonomy, self-containment, triggering, Success Criteria

---

## Core Understanding: What Agents Are

**Metaphor**: Agents are "autonomous specialists"—they have their own isolated context and expertise, operating independently without polluting the conversation.

**Definition**: Agents are autonomous subprocesses that handle complex, multi-step tasks independently in an isolated context window. They transform Claude into specialized agents equipped with procedural knowledge.

**Key insight**: Agents bundle their own philosophy and triggering logic. They don't depend on external documentation to operate autonomously.

✅ Good: Agent includes bundled triggering examples with <example> blocks
❌ Bad: Agent references external documentation for triggering
Why good: Agents must self-trigger without external dependencies

Recognition: "Would this agent work if moved to a project with no rules?" If no, bundle the philosophy.

---

## Agent Traits: What Portable Agents Must Have

### Trait 1: Portability (MANDATORY)

**Requirement**: Agent works in isolation without external dependencies

**Enforcement**:
- Bundle condensed Seed System philosophy (Delta Standard, Autonomous Context, Teaching Formula)
- Include Success Criteria for self-validation
- Provide complete triggering examples with <example> blocks
- Never reference .claude/rules/ files

**Example**:
```
## Core Philosophy

Think of agents like autonomous specialists: they operate in isolation with their own context.

✅ Good: Include specific triggering examples with <example> blocks
❌ Bad: Vague description without concrete triggers
Why good: Specific triggers enable autonomous decision-making

Recognition: "Could this agent trigger autonomously without external documentation?" If no, add triggering examples.
```

### Trait 2: Teaching Formula Integration

**Requirement**: Every agent must teach through metaphor, contrast, and recognition

**Enforcement**: Include all three elements:
1. **1 Metaphor** - For understanding (e.g., "Think of X like a Y")
2. **2 Contrast Examples** - Good vs Bad with rationale
3. **3 Recognition Questions** - Binary self-checks

**Template**:
```
Metaphor: [Understanding aid]

✅ Good: [Concrete example]
❌ Bad: [Concrete example]
Why good: [Reason]

Recognition: "[Question]?" → [Action]
Recognition: "[Question]?" → [Action]
Recognition: "[Question]?" → [Action]
```

### Trait 3: Self-Containment

**Requirement**: Agent owns all its content

**Enforcement**:
- Include all examples directly in description
- Provide complete system prompt
- Bundle necessary philosophy
- Never reference external files

✅ Good: Complete system prompt with responsibilities and process
❌ Bad: "See external documentation for prompt details"
Why good: Self-contained agents work without external references

Recognition: "Does agent reference files outside itself?" If yes, inline the content.

### Trait 4: Autonomous Context

**Requirement**: Agent operates in isolated context window

**Enforcement**:
- Complete system prompt with clear responsibilities
- Step-by-step analysis process
- Defined output format
- No dependency on conversation history

**Example**:
```markdown
You are [agent role]...

**Your Core Responsibilities:**
1. [Responsibility 1]
2. [Responsibility 2]

**Analysis Process:**
1. [Step 1]
2. [Step 2]

**Output Format:**
[What to return]
```

### Trait 5: Success Criteria Invariant

**Requirement**: Agent includes self-validation logic

**Template**:
```
## Success Criteria

This agent is complete when:
- [ ] Valid YAML frontmatter with name and description
- [ ] Description includes triggering conditions with <example> blocks
- [ ] System prompt has clear responsibilities and process
- [ ] Teaching Formula: 1 Metaphor + 2 Contrasts + 3 Recognition
- [ ] Portability: Works in isolation, bundled philosophy, no external refs
- [ ] Autonomy: Operates without conversation history dependency

Self-validation: Verify each criterion without external dependencies. If all checked, agent meets Seed System standards.
```

**Recognition**: "Could a user validate this agent using only its content?" If no, add Success Criteria.

---

## Anatomical Requirements

### Required: Agent File Structure

**Complete format**:
```markdown
---
name: agent-identifier
description: Use this agent when [triggering conditions]. Examples:

<example>
Context: [Situation description]
user: "[User request]"
assistant: "[How assistant should respond and use this agent]"
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
[Step-by-step workflow]

**Output Format:**
[What to return]
```

### Required Fields

**name** (required):
- Agent identifier for namespacing and invocation
- Format: lowercase, numbers, hyphens only
- Length: 3-50 characters

**description** (required):
- Defines when Claude should trigger this agent
- MUST include triggering conditions
- MUST include <example> blocks
- MUST include context, user request, assistant response

### Optional Fields

**model**:
- Override conversation default
- Default: inherit

**color**:
- Visual identifier in interface
- Default: blue

**tools**:
- Specify available tools
- Default: inherits from conversation

---

## Pattern Application Framework

### Step 1: Analyze Intent

**Question**: What type of agent and what traits needed?

**Analysis**:
- High-volume task? → Agent with isolation
- Noisy exploration? → Agent with dedicated context
- Specialized expertise? → Agent with domain knowledge
- Multi-step workflow? → Agent with clear process

**Example**:
```
Intent: Build agent for code analysis
Analysis:
- Specialized expertise → Need domain knowledge in prompt
- High-volume output → Require isolated context
- Complex workflow → Include step-by-step process
Output traits: Autonomy + Portability + Teaching Formula + Success Criteria
```

### Step 2: Apply Teaching Formula

**Requirement**: Bundle condensed Seed System philosophy

**Elements to include**:
1. **Metaphor**: "Agents are autonomous specialists..."
2. **Delta Standard**: Good Component = Expert Knowledge - What Claude Knows
3. **Autonomous Context**: Isolated operation explained
4. **2 Contrast Examples**: Good vs Bad agent structure
5. **3 Recognition Questions**: Binary self-checks for quality

**Template integration**:
```markdown
## Core Philosophy

Metaphor: "Think of agents like [metaphor]..."

✅ Good: description: "Use this agent when user asks to 'analyze code for security'"
❌ Bad: description: "Use this for code help"
Why good: Specific triggering enables autonomous decision

Recognition: "Does description include concrete triggering examples?" → If no, add <example> blocks
Recognition: "Can agent operate without conversation history?" → If no, include complete context
Recognition: "Could this work without external documentation?" → If no, bundle philosophy
```

### Step 3: Enforce Portability Invariant

**Requirement**: Ensure agent works in isolation

**Checklist**:
- [ ] Condensed philosophy bundled (Delta Standard, Autonomous Context, Teaching Formula)
- [ ] Success Criteria included
- [ ] Complete triggering examples with <example> blocks
- [ ] No external .claude/rules/ references
- [ ] Complete system prompt with process

**Verification**: "Could this agent survive being moved to a fresh project with no .claude/rules?" If no, fix portability issues.

### Step 4: Verify Traits

**Requirement**: Check all mandatory traits present

**Verification**:
- Portability Invariant ✓
- Teaching Formula (1 Metaphor + 2 Contrasts + 3 Recognition) ✓
- Self-Containment ✓
- Autonomous Context ✓
- Success Criteria Invariant ✓

**Recognition**: "Does agent meet all five traits?" If any missing, add them.

---

## Architecture Patterns

### Pattern 1: The Clutter Test

**Trait**: Agents prevent conversation pollution

**Application**: Use agents when task would clutter conversation

**Decision matrix**:
| Answer | Approach | Rationale |
|--------|----------|-----------|
| **Would task clutter conversation?** | Spawn agent | Isolation prevents pollution |
| **Would overhead exceed benefit?** | Use native tools | Agent overhead not justified |

**Recognition**: "Would this task clutter the conversation?" Yes → Agent. No → Native tools.

### Pattern 2: Triggering Examples

**Trait**: Description must include concrete triggering

**Application**: Use <example> blocks with context, user, assistant

**Example**:
```
<example>
Context: User wants security review
user: "Analyze this code for vulnerabilities"
assistant: "I'll use the security-analyzer agent to conduct a comprehensive review"
<commentary>
Agent should trigger when user asks for security analysis
</commentary>
</example>
```

### Pattern 3: Complete System Prompt

**Trait**: Agent has complete context for autonomous operation

**Application**: Include responsibilities, process, output format

**Example**:
```markdown
You are [role]...

**Your Core Responsibilities:**
1. [Responsibility 1]
2. [Responsibility 2]

**Analysis Process:**
1. [Step 1]
2. [Step 2]

**Output Format:**
[What to return]
```

---

## Anti-Pattern Recognition

### Anti-Pattern: Skill Fields in Agents

**Never use skill-specific fields in agents:**

| Field | Valid For | Agent Usage |
|-------|-----------|-------------|
| `context: fork` | Skills only | **Invalid** - causes errors |
| `user-invocable` | Skills only | **Invalid** - meaningless |
| `agent:` prefix | Skills only | **Invalid** - not for agents |
| `disable-model-invocation` | Skills only | **Invalid** - not applicable |

**Agent-only fields:** `name`, `description`, `model`, `color`, `tools`

Recognition: "Am I using skill fields in agent?" If yes, remove them.

### Anti-Pattern: Conversation History Dependency

**Agent limitation**: Agents don't inherit caller context

**Solution**: Complete system prompt with all necessary context

Recognition: "Does agent require conversation history?" If yes, include context in prompt.

---

## Common Transformations

### Transform Tutorial → Architectural

**Before** (tutorial):
```
Step 1: Understand when to use agents
Step 2: Create structure
Step 3: Add triggering
...
```

**After** (architectural):
```
Analyze Intent → Apply Teaching Formula → Enforce Portability → Verify Traits
```

**Why**: Architectural patterns ensure output has required traits, not just follows steps.

### Transform Reference → Bundle

**Before** (referenced):
```
"See agent examples for proper structure"
```

**After** (bundled):
```
## Core Philosophy

Bundle condensed principles directly in agent:

Think of agents like autonomous specialists...

✅ Good: [example]
❌ Bad: [example]
Why good: [reason]
```

**Why**: Agents must work in isolation.

---

## Quality Validation

### Portability Test

**Question**: "Could this agent work if moved to a project with zero .claude/rules?"

**If NO**:
- Bundle condensed philosophy
- Add Success Criteria
- Remove external references
- Include complete triggering examples

### Teaching Formula Test

**Checklist**:
- [ ] 1 Metaphor present
- [ ] 2 Contrast Examples (good/bad) with rationale
- [ ] 3 Recognition Questions (binary self-checks)

**If any missing**: Add them using Teaching Formula Arsenal

### Autonomy Test

**Question**: "Can agent operate without conversation history?"

**If NO**: Include complete context in system prompt

### Triggering Test

**Question**: "Does description include concrete <example> blocks?"

**If NO**: Add triggering examples with context, user, assistant

---

## Success Criteria

This agent-development guidance is complete when:

- [ ] Architectural pattern clearly defined (Analyze → Apply → Enforce → Verify)
- [ ] Teaching Formula integrated (1 Metaphor + 2 Contrasts + 3 Recognition)
- [ ] Portability Invariant explained with enforcement checklist
- [ ] All five traits defined (Portability, Teaching Formula, Self-Containment, Autonomous Context, Success Criteria)
- [ ] Pattern application framework provided
- [ ] Anti-patterns clearly identified
- [ ] Quality validation tests included
- [ ] Success Criteria present for self-validation

Self-validation: Verify agent-development meets Seed System standards using only this content. No external dependencies required.

---

## Reference: The Five Mandatory Traits

Every agent must have:

1. **Portability** - Works in isolation
2. **Teaching Formula** - 1 Metaphor + 2 Contrasts + 3 Recognition
3. **Self-Containment** - Owns all content
4. **Autonomous Context** - Operates without conversation history
5. **Success Criteria** - Self-validation logic

**Recognition**: "Does this agent have all five traits?" If any missing, add them.

---

**Remember**: Agents are autonomous specialists. They operate in isolated contexts with their own expertise. Bundle the philosophy. Enforce the invariants. Verify the traits.
