# CLAUDE.md: The Seed System (Claude-Specific)

**Meta-toolkit for Claude Code focused on `.claude/` configuration.**

---

## Bridge Pattern

Universal project documentation is in `AGENTS.md`. This file contains Claude-specific extensions only.

**For:** Project overview, tech stack, commands, component types → **See `AGENTS.md`**

---

## Claude-Specific Features

### Native Planning

- Use `EnterPlanMode` for non-trivial implementation tasks
- Prefer phase-based dependency graphs when planning

### Claude Code Skills Integration

**Skills in this project use Claude-specific features:**

- **Agent Skills**: Extendable capabilities with progressive disclosure
- **Sub-agents**: Specialized workers with isolated context (use sparingly)
- **MCP Servers**: External tools and data sources
- **Stop Hooks**: Pre-tool-use validation

### Master-Clone Pattern (Preferred)

For complex tasks, prefer letting the main agent spawn clones via `Task()` rather than rigid subagents:

```
✅ Prefer: Main agent uses Task() to delegate to itself
❌ Avoid: Rigid subagent definitions that hide context
```

---

## Claude-Specific Commands

| Intent | Command |
| :--- | :--- |
| Build component | `/create` |
| Analyze | `/analyze` |
| Verify all | `/verify` |
| Phase verify | `/qa:verify-phase` |

---

## Content Injection (Claude Commands Only)

Commands can use Claude-specific injection:

| Pattern | Purpose |
| :--- | :--- |
| `@path/to/file` | Inject file content at invocation |
| `` !command `` | Execute bash, inline output |
| `<injected_content>` | Semantic wrapper for injected content |

**Critical:** Skills MUST NOT use `@` or `!` syntax.

---

## Claude-Specific Quality Standards

### Verification Criteria

**Before claiming task completion, provide evidence:**

| Claim Type | Required Evidence |
| :--- | :--- |
| Code works | Test output with exit code |
| Files changed | Git diff summary |
| Type safety | `tsc --noEmit` output |
| Linting | Linter output (0 errors) |

### Evidence Examples

```
✅ Good: "Tests pass (12/12, Exit Code 0)"
✅ Good: "Read config.ts:47 lines - verified"
❌ Bad: "The code should work"
❌ Bad: "I checked the files"
```

---

## Claude-Specific Patterns

### LSP Tool Usage

When analyzing code, prefer LSP tools over grep:

| Task | Tool |
| :--- | :--- |
| Find definition | `goToDefinition` |
| Find references | `findReferences` |
| Get type info | `hover` |
| Document structure | `documentSymbol` |

### Context Management

For long-running sessions:
- Use `/clear` to wipe conversation state
- Use `/catchup` pattern to read git changes
- Prefer "Document & Clear" for multi-phase tasks

---

## Positive Constraints

When providing guidance, prefer positive framing:

```
✅ "Use StyleSheet.create for better performance"
❌ "Never use inline styles"

✅ "Prefer parameterized queries to prevent injection"
❌ "Never concatenate user input"
```

---

## Progressive Disclosure

Deep patterns are in skill references/ folders:

| Skill | Deep Content Location |
| :--- | :--- |
| `skill-authoring` | `.claude/skills/skill-authoring/references/` |
| `engineering-lifecycle` | `.claude/skills/engineering-lifecycle/references/` |
| `quality-standards` | `.claude/skills/quality-standards/references/` |

---

## Claude-Specific Workflow

1. **Read AGENTS.md** for universal project context
2. **Check CLAUDE.md** for Claude-specific features
3. **Invoke skills** via `/skill-name` or directly
4. **Verify work** with evidence before claiming done
5. **Use LSP tools** for code analysis (not grep)

---

## Key File Locations (Claude)

| Content | Location |
| :--- | :------ |
| Skills | `.claude/skills/*/SKILL.md` |
| Commands | `.claude/commands/*.md` |
| Session data | `.claude/workspace/sessions/` |
| Handoff docs | `.claude/workspace/handoffs/` |

---

## Common Claude Gotchas

| Issue | Solution |
| :--- | :--- |
| Agent ignores CLAUDE.md | Content may not be "highly relevant" - keep it universal |
| Context window full | Use `/clear` and `/catchup` pattern |
| Instruction attrition | File too long - prune to essentials |
| Subagent brittle | Use Master-Clone pattern instead |

---

<critical_constraint>
**Claude-Specific Constraints:**

1. Always provide verification evidence before claiming done
2. Use LSP tools for code analysis, not grep/read when possible
3. Prefer Task() clones over rigid subagents
4. Keep CLAUDE.md lean (<100 lines) - reference AGENTS.md for details
</critical_constraint>
