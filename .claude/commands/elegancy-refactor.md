---
description: "Refactor all commands and skills (excluding xxx-development and meta-critic) to elegant, autonomous teaching. Use when: improving component quality, reducing verbosity, enhancing autonomy. Not for: creating new components, simple edits."
---

# Elegancy Refactor

Think of elegant refactoring as **distilling complexity into clarity**—transforming verbose, dependent components into self-contained, autonomous teaching through pattern-based refinement.

## Target Components

**Refactor these components:**
- All skills except xxx-development (skill-development, command-development, agent-development, hook-development, mcp-development)
- All commands except this one
- meta-critic excluded (already a quality validator)

**Preserve these as-is:**
- xxx-development meta-skills (they teach how to build components)
- meta-critic (quality validation, not a target)

## Refactoring Workflow

**Execute sequentially:**
1. List available components via tree commands
2. Create TaskList for all target components
3. For each component:
   - Mark task in_progress
   - Invoke refactor-elegant-teaching skill
   - Mark task completed
4. Continue until all tasks complete

**Remember:** Proceed fully autonomously - do not stop until all tasks completed.

## Expected Transformations

**What changes:**
- Remove dependency language ("you/your")
- Convert recognition patterns to binary tests
- Improve progressive disclosure
- Make content more pattern-based
- Ensure self-containment

**What stays:**
- Core functionality
- Essential examples
- Key concepts
- Component purpose

**Binary test:** "Component works standalone with zero external dependencies?" → If yes, refactoring successful.

## Completion Criteria

**All refactoring complete when:**
- All target components processed
- Each component uses natural imperative form
- Recognition patterns are binary tests
- No "you/your" dependency language
- Progressive disclosure properly applied
- Components are self-contained

**Use TaskList tools to efficiently organize and track progress throughout.**
