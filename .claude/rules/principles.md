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
- Keep SKILL.md under 450 lines
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

### Three Levels

**Tier 1: Metadata** (~100 tokens, always loaded)
- Frontmatter: `name`, `description`, `user-invocable`
- Purpose: Trigger discovery, convey WHAT/WHEN/NOT
- Recognition: This is Claude's first impression - make it count

**Tier 2: SKILL.md** (400-450 lines max, loaded on activation)
- Core implementation with workflows and examples
- Purpose: Enable task completion
- Recognition: If approaching 450 lines, move content to Tier 3

**Tier 3: References/** (on-demand, loaded when needed)
- Deep details, troubleshooting, comprehensive guides
- Purpose: Specific use cases without cluttering Tier 2
- Recognition: Create only when SKILL.md + references >500 lines total

### Pattern Recognition

**Pattern 1: High-level guide with references**
```markdown
## Quick start
[Basic usage]
## Advanced features
- **Feature X**: See [X.md](X.md) for complete guide
```

**Pattern 2: Domain-specific organization**
```
bigquery-skill/
├── SKILL.md (overview and navigation)
└── references/
    ├── finance.md
    ├── sales.md
    └── product.md
```

**Pattern 3: Conditional details**
```markdown
Basic content here.
**For advanced**: See [ADVANCED.md](ADVANCED.md)
```

**Recognition**: If SKILL.md is bloated with domain-specific or situational content, split it into references/.

---

## Skill Self-Containment Principle

Skills must be completely autonomous and self-contained. Never reference external files, directories, or other skills within skill content.

**Rationale**: Skills are atomic units that must work standalone. External references create coupling, break during refactoring, and violate single-source-of-truth principles.

**Recognition**: "Does this skill reference files outside itself?" If yes, inline the content or remove the reference.

**Application**:
- Inline all examples directly within skill content
- Never reference other skills as "see X skill"
- Never reference directories like `official_example_skills/`
- Each skill owns all its content completely

---

**Teaching > Prescribing**: Philosophy enables intelligent adaptation. Process prescriptions create brittle systems.

**Trust > Control**: Claude is smart. Provide principles, not recipes.

**Less > More**: Context is expensive. Every token must earn its place.

For implementation patterns, see [`patterns.md`](patterns.md). For anti-patterns, see [`anti-patterns.md`](anti-patterns.md). For project-specific guidance, see [`CLAUDE.md`](../CLAUDE.md).
