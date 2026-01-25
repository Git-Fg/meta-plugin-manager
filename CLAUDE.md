# CLAUDE.md

Project scaffolding toolkit for Claude Code focused on .claude/ configuration with skills-first architecture and progressive disclosure.

**For philosophical foundation and meta-skill creation principles**, see [`.claude/rules/principles.md`](.claude/rules/principles.md)

---

# Project Operational Rules

**When working on THIS project, apply these rules:**

## Local Project Conventions

This project uses **Knowledge-Factory architecture (v4)** - clean separation of knowledge and execution.

**Knowledge Skills** (passive reference): knowledge-skills, knowledge-mcp, knowledge-hooks, knowledge-subagents

**Factory Skills** (script-based execution): create-skill, create-mcp-server, create-hook, create-subagent

**Meta-Critic**: Quality validation and alignment checking

**Usage pattern**: Load knowledge skills to understand concepts, then use factory skills to execute operations.

**test-manager** is the reference pattern for script-based skills.

## Working Patterns

- **Test commands**: Use `claude --dangerously-skip-permissions` with stream-json output
- **Context fork**: Use for isolation, parallel processing, or untrusted code
- **Completion markers**: Skills should output `## SKILL_NAME_COMPLETE`
- **Quality standard**: All skills should achieve 80-95% autonomy (0-5 questions per session)

## Key Reference Files

| File | Purpose |
|------|---------|
| [`.claude/rules/principles.md`](.claude/rules/principles.md) | Philosophical foundation (Context Window, Delta Standard, Progressive Disclosure) |
| [`.claude/rules/quick-reference.md`](.claude/rules/quick-reference.md) | Navigation guide and decision trees |
| [`.claude/rules/anti-patterns.md`](.claude/rules/anti-patterns.md) | Common mistakes and recognition patterns |
