# Quick Reference

**Navigation guide for this project's architecture. Use to find what you need.**

---

## Decision Tree

```
Need to build something?
│
├─ "Create a skill" → Load knowledge-skills + use create-skill factory
├─ "Add MCP server" → Load knowledge-mcp + use create-mcp-server factory
├─ "Add a hook" → Load knowledge-hooks + use create-hook factory
├─ "Create subagent" → Load knowledge-subagents + use create-subagent factory
│
├─ "Quality assessment" → Load knowledge-skills → quality-framework.md
├─ "Write description" → Load knowledge-skills → description-guidelines.md
├─ "Script patterns" → Load knowledge-skills → script-patterns.md (if exists)
│
└─ "Complex multi-session project" → Use TaskList
```

---

## Where to Find Technical Specifications

**For skill/command/hook/subagent creation:**
- **knowledge-skills**: Agent Skills standard, YAML format, tier structure, quality checklist
- **knowledge-mcp**: MCP integration patterns, server types, configuration
- **knowledge-hooks**: Event types, security patterns, prompt-based vs command hooks
- **knowledge-subagents**: Agent types, frontmatter fields, coordination patterns

**For philosophical foundation:**
- **principles.md**: Core philosophy (Context Window, Trust AI, Delta Standard, Progressive Disclosure)

**For project-specific rules:**
- **CLAUDE.md**: v4 architecture, local conventions, this project's approach

---

## Project Structure Quick Reference

```
.claude/
├── skills/                      # Skills are PRIMARY building blocks
│   └── skill-name/
│       ├── SKILL.md            # <500 lines (Tier 2)
│       └── references/          # On-demand (Tier 3)
├── agents/                      # Context fork isolation
├── hooks/                       # Event automation
├── rules/                       # Core philosophy + navigation
│   ├── principles.md           # Philosophical foundation
│   ├── quick-reference.md      # This file (navigation)
│   └── anti-patterns.md        # Common mistakes to avoid
├── settings.json                # Project-wide hooks & configuration
├── settings.local.json          # Local overrides (gitignored)
└── .mcp.json                   # MCP server configuration
```

---

## Recognition Questions

Use these questions to navigate to the right knowledge:

**"What am I trying to build?"**
- Skill → knowledge-skills
- MCP integration → knowledge-mcp
- Hook → knowledge-hooks
- Subagent → knowledge-subagents

**"How do I assess quality?"**
- Load knowledge-skills → quality-framework.md

**"How do I write a good description?"**
- Load knowledge-skills → description-guidelines.md

**"What's the philosophical approach?"**
- Read principles.md

---

## Project-Specific Patterns (v4 Architecture)

This project uses **Knowledge-Factory architecture**:

**Knowledge Skills** (passive reference): knowledge-skills, knowledge-mcp, knowledge-hooks, knowledge-subagents

**Factory Skills** (script-based execution): create-skill, create-mcp-server, create-hook, create-subagent

**Meta-Critic**: Quality validation and alignment checking

**Usage**: Load knowledge skills to understand concepts, then use factory skills to execute operations.

---

## Anti-Pattern Quick Recognition

**"Could the description alone suffice?"** → Command wrapper anti-pattern

**"Can this work standalone?"** → Non-self-sufficient skills

**"Is the overhead justified?"** → Context fork misuse

**"Would Claude know this without being told?"** → Zero/negative delta

See **anti-patterns.md** for complete catalog with recognition patterns and fixes.

---

## Quality Gate

All skills should achieve 80-95% autonomy (0-5 questions per session).

See **knowledge-skills → quality-framework.md** for complete quality assessment checklist.
