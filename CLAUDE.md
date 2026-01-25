# CLAUDE.md

Project scaffolding toolkit for Claude Code focused on .claude/ configuration with skills-first architecture and progressive disclosure.

**For philosophical foundation**, see [`.claude/rules/`](.claude/rules/)

---

# Project Overview

This project provides meta-skills for creating .claude/ components (skills, commands, hooks, agents, MCPs). It demonstrates the **Knowledge-Factory architecture**:

- **Knowledge Skills** (passive reference): Understand concepts, patterns, philosophy
- **Factory Skills** (script-based execution): Create components via automation
- **Meta-Critic**: Quality validation and alignment checking

**Usage pattern**: Load knowledge skills to understand concepts, then use factory skills to execute operations.

---

# Project-Specific Conventions

## V4 Knowledge-Factory Architecture

This project separates knowledge from execution:

**Knowledge Skills**: skill-development, command-development, hook-development, agent-development, mcp-development

**Factory Skills**: Script-based execution for component creation (when implemented)

**Meta-Critic**: meta-critic skill for quality assessment

**Reference pattern**: test-manager demonstrates script-based skill architecture

## Working Patterns

- **Test commands**: Use `claude --dangerously-skip-permissions` with stream-json output
- **Context fork**: Use for isolation, parallel processing, or untrusted code
- **Completion markers**: Skills output `## SKILL_NAME_COMPLETE` when done
- **Quality standard**: All skills should achieve 80-95% autonomy (0-5 questions per session)

## Quality Gate

| Questions per Session | Autonomy | Status |
|----------------------|----------|--------|
| 0-1 | 95-100% | Excellent |
| 2-3 | 85-95% | Good |
| 4-5 | 80-85% | Acceptable |
| 6+ | <80% | Needs improvement |

---

# Navigation Decision Tree

```
Need to build something?
│
├─ "Create a skill" → skill-development
├─ "Add command" → command-development
├─ "Add hook" → hook-development
├─ "Create agent" → agent-development
├─ "Add MCP server" → mcp-development
│
├─ "Quality assessment" → meta-critic
├─ "Refine vague prompt" → refine-prompts
│
└─ "Complex multi-session project" → Use TaskList
```

---

# Philosophy Summary

**For complete philosophy**, see [`.claude/rules/`](.claude/rules/)

## Core Principles

| Principle | Summary |
|-----------|---------|
| **Context Window** | Every token competes for space. Challenge every piece of information. |
| **Delta Standard** | Only provide what Claude doesn't already know from training. |
| **Trust AI** | Claude is smart. Provide principles, not prescriptions. |
| **Local Autonomy** | Project-specific configuration belongs in the project. |
| **Progressive Disclosure** | Reveal complexity progressively, not all at once. |

**Recognition question**: "Would Claude know this without being told?" If yes, delete it.

---

# Generic Recognition Patterns

**Anti-pattern recognition** - Apply these universally:

| Pattern | Recognition Question |
|---------|---------------------|
| Command wrapper | "Could the description alone suffice?" |
| Non-self-sufficient | "Can this work standalone?" |
| Context fork misuse | "Is the overhead justified?" |
| Zero/negative delta | "Would Claude know this without being told?" |

For component-specific patterns, see the relevant meta-skill:
- **skill-development**: Skill structure, description patterns, autonomy design
- **command-development**: Script patterns, bash execution, interactive commands
- **agent-development**: Agent frontmatter, triggering conditions, system prompts
- **hook-development**: Event types, prompt-based hooks, security patterns
- **mcp-development**: Server types, tool definition, transport mechanisms

---

# Project Structure

```
.claude/
├── skills/                      # Skills are PRIMARY building blocks
│   └── skill-name/
│       ├── SKILL.md            # 400-450 lines max (Tier 2)
│       ├── examples/           # Working code examples
│       ├── scripts/            # Executable utilities
│       └── references/          # On-demand (Tier 3)
├── agents/                      # Context fork isolation
├── hooks/                       # Event automation (via settings.json)
├── commands/                    # Slash commands
├── rules/                       # Core philosophy
│   ├── principles.md           # Philosophical foundation
│   ├── anti-patterns.md        # Generic anti-patterns
│   └── patterns.md             # Generic implementation patterns
├── settings.json                # Project-wide hooks & configuration
├── settings.local.json          # Local overrides (gitignored)
└── .mcp.json                   # MCP server configuration
```

---

# Component-Specific Guidance

For detailed guidance on creating specific components, consult the appropriate meta-skill:

| Component | Meta-Skill | Content |
|-----------|------------|---------|
| Skills | skill-development | Structure, descriptions, autonomy, patterns |
| Commands | command-development | Frontmatter, arguments, bash injection, scripts |
| Agents | agent-development | Frontmatter, system prompts, triggering examples |
| Hooks | hook-development | Events, prompt-based hooks, security |
| MCPs | mcp-development | Servers, tools, transports |

Each meta-skill contains:
- Component-specific patterns
- Anti-patterns for that component
- Troubleshooting guidance
- Working examples

**Each meta-skill is the single source of truth for its domain.**

---

# Philosophy Deep Dives

For complete philosophical framework, see [`.claude/rules/`](.claude/rules/):

| File | Content |
|------|---------|
| [`principles.md`](.claude/rules/principles.md) | Context Window, Delta Standard, Trust AI, Progressive Disclosure |
| [`anti-patterns.md`](.claude/rules/anti-patterns.md) | Generic anti-patterns (DO/DON'T, documentation, efficiency) |
| [`patterns.md`](.claude/rules/patterns.md) | Generic patterns (writing style, cross-references, progressive disclosure) |

**Philosophy is universal** - applies to all components, not just one.

---

# Key Meta-Skills Reference

| Meta-Skill | Purpose |
|------------|---------|
| **skill-development** | Creating effective skills with progressive disclosure |
| **command-development** | Slash commands with frontmatter and bash injection |
| **agent-development** | Autonomous agents with proper triggering |
| **hook-development** | Event-driven automation via settings.json |
| **mcp-development** | MCP server integration and tool definition |
| **meta-critic** | Quality validation and alignment checking |
| **refine-prompts** | L1/L2/L3/L4 prompt refinement methodology |

---

# Development Workflow

When contributing to this project:

1. **Understand the architecture**: Read `CLAUDE.md` and relevant meta-skills
2. **Check philosophy**: Consult `.claude/rules/principles.md` for guidance
3. **Avoid duplication**: Each concept has single source of truth
4. **Progressive disclosure**: Tier 2 (SKILL.md) → Tier 3 (references/) when needed
5. **Trust AI intelligence**: Write principles, not prescriptions
6. **Test thoroughly**: Use `claude --dangerously-skip-permissions` for testing

---

# Quality Standards

All components should achieve:
- **80-95% autonomy**: 0-5 questions per session
- **Clear triggering**: Specific description with exact phrases
- **Imperative form**: No "you/your" in instructions
- **Single source of truth**: No duplication across files
- **Progressive disclosure**: Right content at right tier

For quality assessment, use the **meta-critic** skill.
