---
name: skill-development
description: This skill should be used when the user wants to "create a skill", "add a skill to plugin", "write a new skill", "improve skill description", "organize skill content", or needs guidance on skill structure, progressive disclosure, or skill development best practices for Claude Code plugins.
---

# Skill Development Guide

**Purpose**: Help you create clear, self-contained skills

---

## What Skills Are

Skills are self-contained packages that extend Claude's capabilities. They provide specialized knowledge, workflows, and tools without depending on external files or documentation.

**Key point**: Good skills work on their own. Don't make users hunt through multiple files to understand how to use them.

✅ Good: Skill includes clear examples and guidance
❌ Bad: Skill references other files for important information

**Question**: Would this skill make sense if someone only read this one file? If not, include more context.

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

**Self-check**: If you were new to this skill, would the content be enough to succeed?

---

## Common Mistakes

### Mistake 1: Reference Fragmentation

❌ Bad: "For examples, see examples/basic.md"
✅ Good: Include examples directly in SKILL.md

**Why**: Users shouldn't need to open multiple files to understand your skill.

### Mistake 2: Unclear Purpose

❌ Bad: "This skill helps with development"
✅ Good: "This skill creates automated tests for React components"

**Why**: Specific beats vague every time.

### Mistake 3: No Examples

❌ Bad: "Use the API to get data"
✅ Good: "Call the API like this: `fetch('/api/data')`"

**Why**: Users need to see what success looks like.

### Mistake 4: Too Much Detail

❌ Bad: 8000-word skill covering every possible scenario
✅ Good: Core guidance in SKILL.md, details in references/

**Why**: Progressive disclosure prevents overwhelming users.

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
