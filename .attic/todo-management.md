# Todo Management Pattern

**Adapted from TÂCHES Claude Code Resources**

Capture ideas mid-conversation without derailing your current work.

---

## The Problem

When you're deep in work and spot a bug, think of a new feature, or notice something to refactor - but don't want to lose focus on what you're doing NOW - you need a way to capture that thought with full context.

## The Solution

Use `/add-to-todos` to capture the idea, file paths, and reasoning in the moment. Later, `/check-todos` brings it all back with zero context loss.

## Commands

### `/add-to-todos [optional description]`

Captures the current conversation context as a structured todo item in `TO-DOS.md`.

**What it captures:**

- Specific problem or task from conversation
- File paths with line numbers
- Technical details (error messages, root causes, constraints)
- Timestamp and context title
- Solution approach hints (optional)

**Format:**

```markdown
## Brief Context Title - YYYY-MM-DD HH:MM

- **[Action] [Component]** - Brief description. **Problem:** What's wrong/why needed. **Files:** path/to/file.ts:123-145. **Solution:** Approach hints.
```

**Usage:**

- `/add-to-todos` - Infers todo from current conversation
- `/add-to-todos fix authentication bug` - Uses provided description as focus

### `/check-todos`

Lists todos, lets you select one, loads full context, and removes it from the list.

**What it does:**

1. Shows compact numbered list of todos with dates
2. Waits for selection
3. Loads full todo context (Problem/Files/Solution)
4. Checks for project workflows (CLAUDE.md, skills)
5. Suggests relevant workflow if found
6. Removes todo from list
7. Ready to start work

## Why This Works

**Stay focused:**

- Don't derail current work to chase every idea
- Capture inspiration the moment it strikes
- Build a backlog of improvements without breaking flow

**Never lose ideas:**

- "Should refactor this..." → captured with context
- "This could be a feature..." → saved with reasoning
- "Need to investigate..." → logged with file paths

**Resume with full context:**

- Claude gets the full picture weeks later
- No "what was I thinking?" moments
- Exact files, line numbers, and reasoning intact

## Usage Workflow

**Mid-conversation capture:**

```
You: "Fix the login redirect bug"
Claude: [investigating auth.ts, finds the issue]
You: "Actually, I notice the error handling here is messy too.
      Let's just fix the redirect for now."
You: /add-to-todos refactor error handling

[stays focused on login redirect, doesn't derail]
```

**Later that week:**

```
You: /check-todos

Outstanding Todos:

1. Refactor error handling in auth flow (2025-11-15 14:23)
2. Add user preference caching (2025-11-14 09:30)
3. Research Redis vs Memcached (2025-11-12 16:45)

Reply with number: 1

Claude loads full context and removes from list
```

## Integration with TheSeedSystem

This pattern is critical for TheSeedSystem's health maintenance workflow:

- **Component health**: Capture component improvements while working on other tasks
- **Refactoring**: Log refactor opportunities without derailing current work
- **Documentation**: Note documentation gaps as you discover them
- **Quality**: Track quality issues for future resolution

## Tips

- Use `/add-to-todos` liberally - capture anything you might revisit
- Include specific line numbers when you find them
- The structured format ensures Claude has enough context later
- Todos are removed when work begins - if incomplete, re-add with new context
- Empty sections are automatically cleaned up

## Integration with Workflows

The system checks for established workflows before starting work:

- Plugin development → checks for plugin skill
- MCP servers → checks for MCP workflow
- Generic tasks → works directly

This ensures you follow project-specific patterns and use the right tools automatically.
