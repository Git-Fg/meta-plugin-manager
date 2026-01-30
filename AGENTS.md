# AGENTS.md: The Seed System

**Meta-toolkit for building portable `.claude/` configuration components.**

This project provides factory skills and commands for creating AI agent components that work across multiple platforms (Claude Code, Cursor, Zed, GitHub Copilot, etc.).

---

## Project Overview

A portable toolkit for building `.claude/` configuration with dual-role architecture:
- **Health Maintenance**: Keep your agent configuration lean and effective
- **Portable Component Factory**: Create skills, commands, agents, hooks, and MCP servers

---

## Tech Stack

- **Platform**: Claude Code (primary), compatible with Cursor, Zed, Copilot
- **Format**: Markdown with YAML frontmatter
- **Standard**: Follows [agentskills.io](https://agentskills.io) open standard (December 2025)
- **Language**: TypeScript for any tooling
- **Package Manager**: pnpm (if dependencies needed)

---

## Essential Commands

```bash
# List all available skills
ls .claude/skills/

# Invoke a skill (via Claude Code)
/skill-name

# List all available commands
ls .claude/commands/

# Invoke a command
/command-name

# Verify all components
/verify

# Run E2E tests
/testing-e2e
```

---

## Architecture Principles

### Commander's Intent (Not Scripts)

Define outcomes, not step-by-step mechanics:

```
✅ Intent: "Commit changes once tests pass."
❌ Script: "Run npm test, then git add ., then git commit..."
```

### Unified Hybrid Protocol (UHP)

| Use XML | Use Markdown |
| :------ | :----------- |
| Critical constraints | Informational prose |
| Non-negotiable rules | Data, tables, examples |
| Semantic anchors | Documentation |

**Standard tags:**
- `<mission_control>`: Objective and success criteria
- `<critical_constraint>`: System invariants
- `<injected_content>`: Wrapped references

### Progressive Disclosure

Manage cognitive load through layered information:

| Tier | Content | Target Size |
| :--- | :------ | :---------- |
| Tier 1 | YAML metadata | ~100 tokens |
| Tier 2 | Core workflows | 1.5k-2k words |
| Tier 3 | Deep patterns, examples | Unlimited |

---

## Component Types

| Component | Format | Purpose | Location |
| :--- | :--- | :--- | :------ |
| **Skill** | Folder + SKILL.md | Domain knowledge with progressive disclosure | `.claude/skills/` |
| **Command** | Single `.md` | Intent aliases with @/! injection | `.claude/commands/` |
| **Agent** | Folder + config | Autonomous worker with isolated context | `.claude/agents/` |
| **Hook** | `.md` in hooks/ | Event-driven interception | `.claude/hooks/` |
| **MCP Server** | Server code | External tools and data sources | Separate project |

### Skills vs Commands

**Identical capabilities**—different structure for cognitive load:

| Aspect | Skills | Commands |
| :--- | :--- | :--- |
| **Format** | Folder with optional references/ | Single file |
| **Disclosure** | Progressive (Tier 2/Tier 3) | Flat |
| **Best for** | Reusable knowledge, invoked by others | Quick actions, user interaction |
| **Example** | `engineering-lifecycle` | `/commit` |

---

## Component Structure

### Frontmatter (Required)

```yaml
---
name: component-name
description: "Verb + object. Use when [triggers]. Not for [exclusions]."
---
```

### Skill Opening (Required)

Every skill MUST open with either:
- `## Quick Start` (tool-like skills with scenarios)
- `## Workflow` (process skills with phases)

### Reference Files (Optional)

For skills with extensive content:

| Element | Purpose | Placement |
| :--- | :--- | :------ |
| Navigation table | Quick lookup | After frontmatter |
| Greppable headers | PATTERN:, EDGE:, ANTI-PATTERN: | Throughout |
| Constraints footer | Critical rules | File bottom |

---

## Quality Standards

### The Iron Law

**Execute independently (Trust). Provide evidence before claiming done (Verify).**

### Evidence-Based Claims

| Claim | Evidence Required |
| :--- | :--- |
| "I fixed the bug" | `Test passed (Exit Code 0)` |
| "TypeScript is happy" | `tsc --noEmit: 0 errors` |
| "File exists" | `Read /path/to/file.ts: N lines verified` |

### Portability Invariant

Every component MUST work in a vacuum:
1. Works in project with ZERO config files
2. Carries its own "genetic code" internally
3. Does NOT reference global rules via text/links

### Delta Standard

**Good Component = Expert Knowledge − What Claude Already Knows**

**Keep (Positive Delta):**
- Best practices, not just possibilities
- Modern conventions Claude might not default to
- Project-specific decisions with rationale
- Domain expertise
- Anti-patterns

**Remove (Zero/Negative Delta):**
- Basic programming concepts
- Standard library docs
- Generic tutorials
- Claude-obvious operations

---

## Voice and Tone

### Use Imperative/Infinitive Form

```
✅ "Validate inputs before processing."
✅ "Create the skill directory."
❌ "You should validate inputs..."
❌ "Let's create the skill directory..."
```

### Voice Strength

| Strength | When to Use | Markers |
| :--- | :--- | :------ |
| **Gentle** | Best practices | Consider, prefer |
| **Standard** | Default patterns | Create, use, follow |
| **Strong** | Quality gates | Always, never |
| **Critical** | Security, safety | Mandatory, critical |

### Degrees of Freedom

**Default to HIGH FREEDOM unless clear constraint exists:**

| Freedom | When to Use | Example |
| :--- | :--- | :------ |
| **High** | Multiple valid approaches | "Consider using immutable data" |
| **Medium** | Some guidance needed | "Use this pattern, adapting as needed" |
| **Low** | Fragile/error-prone | "Execute steps 1-3 precisely" |

---

## Content Injection (Commands Only)

Commands can use special injection patterns:

| Pattern | Purpose | Example |
| :--- | :--- | :------ |
| `@path/to/file` | Inject file content | `@README.md` |
| `` !command `` | Execute bash, inline output | `` !git status `` |
| `<injected_content>` | Semantic wrapper | For command content |

**Critical constraint:** Skills MUST NEVER use `@` or `!` syntax.

---

## Factory Skills (Building Components)

| To Build... | Invoke Skill... |
| :--- | :--- |
| Skill | `skill-authoring` or `/create` |
| Command | `command-authoring` |
| Audit Skill | `system-refiner` |
| Audit Command | `command-refine` |
| Agent | `agent-development` |
| MCP Server | `mcp-development` |
| Hook | `hook-development` |

### Big Skills (Software Lifecycle)

| Skill | Purpose |
| :--- | :--- |
| `engineering-lifecycle` | Plan, implement, verify with TDD |
| `quality-standards` | Verify with 6-phase gates |
| `pr-reviewer` | Review PRs for spec, security, quality |
| `finishing-a-development-branch` | Complete branch for merge/PR |

### Cognitive Tools

| Skill | Purpose |
| :--- | :--- |
| `analysis-diagnose` | Root cause investigation |
| `brainstorming` | Design exploration |
| `discovery` | Requirements gathering |
| `premortem` | Risk identification |
| `think-tank` | Unified reasoning framework |

---

## Common Gotchas

### Negative Constraints Without Alternatives

❌ **Avoid:** "Never use inline styles."
✅ **Prefer:** "Use `StyleSheet.create` for performance instead of inline styles."

### Verification Without Evidence

❌ **Avoid:** "The tests pass."
✅ **Prefer:** "All tests pass (Exit Code 0)."

### Context Fork Misuse

❌ **Avoid:** Creating subagents for simple tasks
✅ **Prefer:** Let the main agent use Task() to spawn clones

### External References in Components

❌ **Avoid:** "See CLAUDE.md for more details"
✅ **Prefer:** Component carries its own complete instructions

---

## Progressive Disclosure References

For detailed information on specific topics:

- **Skill Authoring**: See `skill-authoring` skill or `.claude/skills/skill-authoring/SKILL.md`
- **Command Creation**: See `command-authoring` skill
- **Agent Development**: See `agent-development` skill
- **Quality Verification**: See `quality-standards` skill
- **Testing Patterns**: See `testing-e2e` command

---

## File Locations

| Content | Location |
| :--- | :------ |
| Skills | `.claude/skills/*/SKILL.md` |
| Commands | `.claude/commands/*.md` |
| Agents | `.claude/agents/*/` |
| Hooks | `.claude/hooks/*.md` |
| Project Rules | `.claude/rules/` (if needed) |
| Session Data | `.claude/workspace/sessions/` |

---

## Workflow

1. **Identify Need**: What component do you need?
2. **Choose Type**: Skill, Command, Agent, Hook, or MCP?
3. **Invoke Factory**: Use appropriate skill or `/create`
4. **Verify**: Run `/verify` to check quality
5. **Test**: Use in real session to validate
6. **Iterate**: Refine based on usage

---

## Cross-Platform Compatibility

This AGENTS.md follows universal standards for compatibility across:

- ✅ Claude Code (native)
- ✅ Cursor
- ✅ Zed
- ✅ GitHub Copilot
- ✅ Any agent reading project markdown

For Claude-specific features, see `CLAUDE.md`.
