# Context Handoff Pattern

**Adapted from TÂCHES Claude Code Resources**

Structured handoff documents to continue work in a fresh context without losing progress.

---

## The Problem

Context windows fill up during long conversations. When you need to start fresh (context getting full, switching tasks, or wanting a clean slate), you lose all context about what was done, what remains, and why decisions were made.

## The Solution

Use `/whats-next` to create a structured handoff document (`whats-next.md`) that preserves:

- Original task scope
- Work completed with file paths and line numbers
- Work remaining with specific next steps
- Attempted approaches (including failures)
- Critical context and decisions
- Current state of deliverables

## Command

### `/whats-next`

Analyzes the current conversation and creates a comprehensive handoff document.

**Usage:**

```bash
/whats-next
```

**Output format:**

```xml
<original_task>
[What was initially requested]
</original_task>

<work_completed>
[Everything accomplished with file paths and line numbers]
</work_completed>

<work_remaining>
[Specific tasks with precise locations]
</work_remaining>

<attempted_approaches>
[What was tried, including failures and why]
</attempted_approaches>

<critical_context>
[Key decisions, constraints, discoveries, gotchas]
</critical_context>

<current_state>
[Exact status of all deliverables]
</current_state>
```

## Why This Works

**Preserves progress:**

- Exact file paths and line numbers
- Comprehensive work completed with reasoning
- Clear remaining tasks with precise locations
- Current state tracking for all deliverables

**Prevents wasted effort:**

- Documents attempted approaches and failures
- Captures dead ends to avoid repeating
- Records what didn't work and why

**Prevents scope creep:**

- Focuses only on completing the original request
- Maintains task boundaries across context switches

**Transfers critical knowledge:**

- Key decisions and trade-offs
- Technical constraints and gotchas
- Environment details and assumptions
- References to documentation consulted

## Usage Workflow

**End of current conversation:**

```
You: /whats-next
Claude: [Analyzes conversation, writes whats-next.md]
✓ Created whats-next.md - reference with @whats-next.md in a new chat
```

**Start of new conversation:**

```
You: @whats-next.md continue this work
Claude: [Reads handoff document, understands context, resumes work]
```

## Integration with TheSeedSystem

This pattern is critical for TheSeedSystem's health maintenance workflow:

- **Plan Mode handoff**: When Plan Mode reaches token limits, use `/whats-next` to preserve the plan state
- **Component development**: When building complex components, use handoffs to maintain progress across sessions
- **Refactoring**: During large refactors, handoffs prevent losing track of changes made

## Tips

- Use `/whats-next` when context feels full or cluttered
- Reference with `@whats-next.md` in new chats for seamless continuation
- The file is overwritten each time - it's a snapshot, not a log
- Delete `whats-next.md` when work is complete
- Works great with `/add-to-todos` for long-term task tracking

## Integration

**Combine with todo management:**

- `/whats-next` for immediate continuation (same session/day)
- `/add-to-todos` for longer-term backlog (weeks/months)

Use whats-next.md for "I'll finish this after lunch" and TO-DOS.md for "I'll get to this eventually."
