# Content Injection: Command-Only Patterns

<mission_control>
<objective>Document content injection as a command-only feature, distinguishing it from skill patterns</objective>
<success_criteria>Commands have clear reference for @ and ! patterns; skills know to use semantic alternatives</success_criteria>
</mission_control>

## Navigation

| If you need... | Read... |
| :------------- | :------ |
| @ pattern usage | ## @ Pattern: File Injection |
| ! pattern usage | ## ! Pattern: Command Execution |
| Wrapper pattern | ## <injected_content> Wrapper |
| Command vs skill | ## The Three Boundaries |
| Quick reference | ## Quick Reference |

## Overview

Content injection (`@` and `!`) is a **command-only feature**. Skills must NOT use these patterns.

| Pattern              | Component     | Purpose                           |
| -------------------- | ------------- | --------------------------------- |
| `@path`              | Commands only | File injection at invocation time |
| `!`command``         | Commands only | Execute bash, inline output       |
| `<injected_content>` | Commands only | Semantic wrapper                  |

## Why Commands Only

Commands are infrastructure that runs in the current Claude session with access to the filesystem and shell. Skills are portable components that may run in forked contexts where injection doesn't apply.

**Commands use injection** to gather dynamic state (Git status, current branch, file contents).
**Skills use instructions** ("Read `references/x.md`") because they must work standalone.

---

## @ Pattern: File Injection

### Usage in Commands

```markdown
<injected_content>
@.claude/workspace/handoffs/diagnostic.yaml
</injected_content>
```

Or inline:

```
Current handoff: @.claude/workspace/handoffs/latest.yaml
```

### What This Does

At invocation time, the file content replaces the `@path` pattern. This captures the **current state** of files that change between sessions.

### Error Handling

| Scenario     | Behavior                                  |
| ------------ | ----------------------------------------- |
| File exists  | Injects content                           |
| File missing | Empty result (command handles gracefully) |

### In Skills: Use Instructions

```markdown
Read `references/configuration.md` to understand the schema.
```

---

## ! Pattern: Command Execution

### Usage in Commands

```markdown
Current branch: !`git branch --show-current`
CI Status: !`gh run list --limit 1 --json conclusion`
```

### What This Does

At invocation time, the bash command executes and its output replaces the `` !`command` `` pattern. This captures **runtime state** that changes between invocations.

### Error Handling

| Scenario         | Behavior                                  |
| ---------------- | ----------------------------------------- |
| Command succeeds | Injects stdout                            |
| Command fails    | Empty result (command handles gracefully) |

### In Skills: Use Semantic Descriptions

```markdown
Determine the current Git branch.
Check CI status using gh CLI.
```

---

## <injected_content> Wrapper

### Purpose

Semantic grouping for related @ injections:

```markdown
<injected_content>
@.claude/workspace/handoffs/diagnostic.yaml
@.claude/workspace/handoffs/handoff.yaml
</injected_content>
```

This signals to readers that multiple files are being injected together for a cohesive context.

---

## The Three Boundaries

| Boundary        | Commands (Adapter)           | Skills (Logic Core) |
| --------------- | ---------------------------- | ------------------- |
| **Context**     | Active injection (@, !)      | Passive reading     |
| **Tooling**     | Hard binding (Bash, MCP)     | Semantic intent     |
| **Interaction** | Negotiator (AskUserQuestion) | Executor (headless) |

---

## Quick Reference

| If you need...                | Use this pattern                    |
| :---------------------------- | :---------------------------------- |
| Inject file content           | `@path` in commands                 |
| Execute shell command         | `` !`command` `` in commands        |
| Group multiple injections     | `<injected_content>` wrapper        |
| Reference static content      | "Read `references/x.md`" in skills  |
| Delegate to another component | "Delegate to X specialist" (skills) |

---

## Recognition Questions

| Question                        | Answer Means...                        |
| :------------------------------ | :------------------------------------- |
| "Is this a portable component?" | Skills use instructions, not injection |
| "Does this need runtime state?" | Commands use @ or !                    |
| "Is this for user interaction?" | Commands use AskUserQuestion           |
| "Is this headless execution?"   | Skills use semantic patterns           |

---

## Command Patterns: When to Use

Commands have infrastructure access and can leverage dynamic injection:

- `@path` captures current file state at invocation
- `!`command`` captures runtime state that changes between invocations
- `<injected_content>` groups related injections semantically

This keeps commands DRY while maintaining current context.

## Skill Patterns: Semantic Alternatives

Skills must work standalone, so use text instructions:

- "Read `references/x.md`" for static content
- "Determine the current branch" for runtime state
- "Delegate to X specialist" for capability invocation

---

<critical_constraint>
**Injection Boundaries:**

- Skills MUST NEVER use `@` or `!` syntax
- Commands MAY use `@` and `!` freely
  </critical_constraint>
