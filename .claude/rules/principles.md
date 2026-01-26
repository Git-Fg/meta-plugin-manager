# Core Principles

Think of this as the "why" behind skill creation. Understanding principles enables intelligent adaptation; recipes only work for specific situations.

---

## Context Window as Public Good

The context window is a shared resource. Everything loaded competes for space: system prompt, conversation history, skill metadata, other skills, and the actual user request.

Think of it like a shared refrigerator - everything you put in takes space others could use. Be a good roommate.

**Principle**: Challenge every piece of information. "Does Claude really need this?" and "Does this justify its token cost?"

**Application**:
- Prefer concise examples over verbose explanations
- Remove Claude-obvious content (what training already covers)
- Keep descriptions concise with exact trigger phrases
- Keep SKILL.md focused and lean (~1,500-2,000 words)
- Move detailed content to references/

**Recognition**: If you're explaining something Claude already knows from training, delete it.

---

## Trust AI Intelligence

**Default assumption**: Claude is already very smart. Only add context Claude doesn't already have.

Think of it this way: You're talking to a senior engineer who joined your team. You don't need to explain how to write code, use Git, or read files. You only need to explain what makes YOUR project unique.

**What this means**:
- Don't explain basic programming concepts
- Don't prescribe every step of obvious workflows
- Don't provide exhaustive examples for simple patterns
- DO provide expert-only knowledge
- DO document project-specific decisions
- DO explain non-obvious trade-offs

**Recognition**: If you're writing "how to use Python" or "what YAML is," delete it.

---

## Local Project Autonomy

Project-specific configuration belongs in the project, not in global settings or external systems.

**Principle**: Start with local project configuration. Expand scope only when needed.

**Hierarchy** (from most local to most global):
1. **Project directory** (`.claude/`): Default for project-specific skills
2. **Project local overrides** (`.claude/settings.local.json`): Personal customization
3. **User-wide settings** (`~/.claude/settings.json`): Cross-project standards
4. **Legacy global hooks** (`.claude/hooks.json`): Deprecated, avoid

**Recognition**: If configuration applies only to this project, keep it in `.claude/`. If it's a personal preference, use `settings.local.json`. If it's a universal standard, consider user-wide settings.

---

## Cognitive Load Distribution

**Think Akinator, not consultant.** The AI does systematic thinking internally; the user only recognizes.

**Principle**: Heavy cognition happens inside the AI. Only crafted questions emerge externally.

**What this means**:
- AI internally: brainstorming, framework application, systematic elimination
- User sees: only the next clever question, based on internal synthesis
- User's job: recognize the correct option, not generate from scratch

**Recognition**: Are you showing internal thinking process? Hide it. Only the question should be visible.

---

## The Delta Standard

> **Good Customization = Expert-only Knowledge − What Claude Already Knows**

Only provide information that has a "knowledge delta" - the gap between what Claude knows from training and what it needs to know for this specific project.

**Positive Delta** (keep these):
- Project-specific architecture decisions
- Domain expertise not in general training
- Business logic and constraints
- Non-obvious bug workarounds
- Team-specific conventions
- Local environment quirks

**Zero/Negative Delta** (remove these):
- General programming concepts
- Standard library documentation
- Common patterns Claude already knows
- Generic tutorials
- Obvious best practices
- Universal truths

**Recognition**: For each piece of content, ask "Would Claude know this without me being told?" If yes, delete it.

---

## Progressive Disclosure Philosophy

Information architecture as cognitive load management. Reveal complexity progressively, not all at once.

**Principle**: Not everything belongs in the main content. Core content for most users; details for specific cases.

**Recognition**: "Is this information needed by most users?" Keep in main. "Is this for specific cases?" Move to references/.

**For implementation**: See component-specific meta-skills (skill-development, command-development, agent-development) for detailed tier structures.

---

**Teaching > Prescribing**: Philosophy enables intelligent adaptation. Process prescriptions create brittle systems.

**Trust > Control**: Claude is smart. Provide principles, not recipes.

**Less > More**: Context is expensive. Every token must earn its place.

For implementation patterns, see [`patterns.md`](patterns.md). For anti-patterns, see [`anti-patterns.md`](anti-patterns.md). For project-specific guidance, see [`CLAUDE.md`](../CLAUDE.md).
