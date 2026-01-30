---
name: memory-persistence
description: "Provide session lifecycle hooks for cross-platform context persistence and handoff. Use when maintaining state across sessions, creating handoff documents, or resuming work later. Includes session metadata capture, handoff document creation, and context restoration. Not for in-memory variables, temporary state, or single-session workflows."
---

<mission_control>
<objective>Provide session lifecycle hooks for cross-platform context persistence and handoff between sessions.</objective>
<success_criteria>Session metadata captured, handoff document created, context restored in next session</success_criteria>
</mission_control>

# Memory Persistence

Session lifecycle hooks that maintain context and knowledge across Claude Code sessions.

## What This Does

Captures session metadata and context:

- **Session Start**: Initialize session directory, record metadata
- **Session End**: Generate summary, prepare for next session
- **Session Logging**: Track session activity for pattern extraction

## Quick Start

**Session start:** Initialize directory, record metadata (branch, recent changes)

**Session end:** Generate summary, capture lessons learned

**Resume next session:** Load handoff document, restore context

**Why:** Cross-session continuity prevents knowledge loss—handoff documents preserve decisions.

---

## The Path to High-Autonomy Success

### 1. Capture Metadata Automatically

Session metadata (branch, working directory, environment) provides essential context for resuming work. When this information is captured at session boundaries, future sessions can reconstruct the working state without asking redundant questions.

**Why it works:** Automatic capture eliminates the need to manually remember or restate context—sessions become self-documenting.

### 2. Create Handoff Documents

Handoff documents bridge sessions by recording what was being worked on, current state, and next steps. When each session creates its own handoff, the next session can load and continue seamlessly.

**Why it works:** Written context survives session boundaries better than memory—decisions and progress remain accessible.

### 3. Track Session Activity

Session logging creates a searchable history of what happened during each session. When patterns are logged consistently, valuable workflows and discoveries can be extracted later.

**Why it works:** Written logs enable pattern recognition—repeated successful workflows become reusable knowledge.

### 4. Trust Native Task Tracking

TodoWrite handles task tracking natively with CLI status line visibility. Sessions should use TodoWrite for progress tracking rather than custom ID persistence.

**Why it works:** Native tool integration provides better visibility—CLI status line shows progress without hidden state files.

## Navigation

| If you need...      | Read...                                |
| :------------------ | :------------------------------------- |
| Session start       | ## Quick Start → Session start         |
| Session end         | ## Quick Start → Session end           |
| Resume next session | ## Quick Start → Resume next session   |
| What this does      | ## What This Does                      |
| Hook configuration  | ## Implementation Patterns → Pattern 1 |
| Context restoration | See filesystem-context skill           |

## Implementation Patterns

### Pattern 1: Hook Configuration

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/scripts/session-start.sh",
            "description": "Initialize session logging"
          }
        ]
      }
    ],
    "SessionEnd": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/scripts/session-end.sh",
            "description": "Finalize session summary"
          }
        ]
      }
    ]
  }
}
```

### Pattern 2: Session Directory Structure

```bash
~/.claude/sessions/<session-id>/
├── start.jsonl    # Session start metadata
├── end.jsonl      # Session end metadata
├── session.log    # Activity log
└── summary.md     # Human-readable summary
```

### Pattern 3: Handoff Document

```yaml
goal: [What was being worked on]
now: [Current state]
context:
  session_id: [Previous session ID]
  session_summary: [Link to session summary]
  files_modified: [List of files changed]
next_steps: [What to do next]
```

## Troubleshooting

### Issue: Session Not Persisted

| Symptom                       | Solution                                     |
| ----------------------------- | -------------------------------------------- |
| Context lost between sessions | Verify hooks are configured in settings.json |
| No session directory created  | Check session-start script execution         |

### Issue: Missing Metadata

| Symptom                    | Solution                            |
| -------------------------- | ----------------------------------- |
| Incomplete session records | Ensure all required fields captured |
| No git branch information  | Add git commands to session-start   |

### Issue: Handoff Not Working

| Symptom                     | Solution                               |
| --------------------------- | -------------------------------------- |
| Next session has no context | Check handoff document format          |

### Issue: Cross-Platform Compatibility

| Symptom                 | Solution                         |
| ----------------------- | -------------------------------- |
| Scripts fail on Windows | Use POSIX-compliant bash         |
| Path issues             | Use proper quoting and expansion |

## Workflows

### Session Lifecycle

1. **Session Start** → Initialize directory, record metadata
2. **Work Session** → Normal development work
3. **Session End** → Generate summary, create handoff
4. **Next Session** → Load handoff for continuity

### Session Management

```bash
# List all sessions
ls ~/.claude/sessions/

# View recent sessions
ls -lt ~/.claude/sessions/ | head -10

# Count total sessions
ls ~/.claude/sessions/ | wc -l
```

## Architecture

```
Session Start → Initialize → Capture Metadata
     │
     │ (work session)
     │
     ▼
Session End → Generate Summary → Extract Patterns
     │
     ▼
~/.claude/sessions/<session-id>/
├── start.jsonl    # Session start metadata
├── end.jsonl      # Session end metadata
├── session.log    # Activity log
└── summary.md     # Human-readable summary
```

## Session Structure

Each session creates a directory in `~/.claude/sessions/`:

```
~/.claude/sessions/
├── 20250127-143022-12345/
│   ├── start.jsonl    # {"timestamp":"...","event":"session_start",...}
│   ├── end.jsonl      # {"timestamp":"...","event":"session_end",...}
│   ├── session.log    # Activity log
│   └── summary.md     # Session summary
├── 20250127-154530-12346/
│   ├── ...
```

## Hooks Configuration

Configure in `.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/scripts/session-start.sh",
            "description": "Initialize session logging"
          }
        ]
      }
    ],
    "SessionEnd": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/scripts/session-end.sh",
            "description": "Finalize session summary"
          }
        ]
      }
    ]
  }
}
```

## Session Metadata

**Session Start Records:**

- Timestamp
- Session ID (YYYYMMDD-HHMMSS-PID)
- Working directory
- Git branch
- Environment variables

**Session End Records:**

- Timestamp
- Session duration (calculated)
- Working directory
- Final state

## Integration with Handoff

Memory persistence integrates with the `/handoff` command:

**Session End → Handoff Generation:**

1. Session ends (hook triggers)
2. Summary generated automatically
3. Handoff document created with session context
4. Next session loads handoff for continuity

**Handoff Document Structure:**

```yaml
goal: [What was being worked on]
now: [Current state]
context:
  session_id: [Previous session ID]
  session_summary: [Link to session summary]
  files_modified: [List of files changed]
next_steps: [What to do next]
```

## Cross-Platform Compatibility

Hooks use POSIX-compliant bash for cross-platform support:

- macOS: Works natively
- Linux: Works natively
- Windows: Works via Git Bash or WSL

## Session Management

**View Sessions:**

```bash
# List all sessions
ls ~/.claude/sessions/

# View recent sessions
ls -lt ~/.claude/sessions/ | head -10

# Count total sessions
ls ~/.claude/sessions/ | wc -l
```

**Clean Old Sessions:**

```bash
# Remove sessions older than 30 days
find ~/.claude/sessions/ -type d -mtime +30 -exec rm -rf {} \;
```

**Archive Important Sessions:**

```bash
# Archive specific session
cp -r ~/.claude/sessions/20250127-143022-12345 ~/archive/sessions/
```

## Common Mistakes to Avoid

### Mistake 1: No Session Start Hook

❌ **Wrong:**
Session starts without metadata capture → Context lost

✅ **Correct:**
Configure SessionStart hook in settings.json to initialize logging

### Mistake 2: No Session End Hook

❌ **Wrong:**
Session ends without summary → No handoff document created

✅ **Correct:**
Configure SessionEnd hook to generate summary and handoff

### Mistake 3: Custom Task Tracking

❌ **Wrong:**
Implementing custom TaskList ID persistence → Hidden state, no CLI visibility

✅ **Correct:**
Use TodoWrite natively → CLI status line tracks progress automatically

### Mistake 4: Cross-Platform Incompatibility

❌ **Wrong:**
Using Windows-specific scripts → Fails on macOS/Linux

✅ **Correct:**
Use POSIX-compliant bash for cross-platform support

---

## Validation Checklist

Before claiming memory persistence configured:

**Hooks Configuration:**
- [ ] SessionStart hook configured in settings.json
- [ ] SessionEnd hook configured in settings.json
- [ ] Hook scripts are executable

**Session Lifecycle:**
- [ ] Session start creates session directory
- [ ] Metadata captured (timestamp, branch, working directory)
- [ ] Session end generates summary
- [ ] Handoff document created correctly

**Context Preservation:**
- [ ] Previous session context can be loaded
- [ ] Files modified list captured

**Cross-Platform:**
- [ ] Scripts use POSIX-compliant bash
- [ ] Path handling is cross-platform compatible

---

## Best Practices Summary

✅ **DO:**
- Configure both SessionStart and SessionEnd hooks for full lifecycle
- Use POSIX-compliant bash scripts for cross-platform support
- Capture all required metadata (timestamp, branch, working directory)
- Use TodoWrite for native task tracking
- Review session summaries before starting new sessions
- Archive important sessions for future reference
- Clean old sessions periodically to manage disk space

❌ **DON'T:**
- Skip SessionStart or SessionEnd hooks (loses context)
- Use platform-specific scripts (breaks portability)
- Implement custom task tracking (use TodoWrite natively)
- Skip handoff generation (breaks session continuity)
- Ignore cross-platform path handling
- Leave old sessions unarchived (disk space bloat)
- Skip pattern extraction from valuable sessions

---

## Privacy Considerations

- **Local storage only** - Sessions stored on your machine
- **No cloud sync** - Session data never uploaded
- **No conversation content** - Only metadata and summaries
- **User control** - You decide when to archive or delete

## Integration with Seed System

### Handoff Command

Session hooks integrate with `/handoff`:

- Session end → Generate handoff document automatically
- Next session → Load previous handoff for continuity
- Seamless transition between sessions

## Related Skills

- **handoff** - Session continuity and context transfer
- **filesystem-context** - Persistent storage patterns

## Key Principle

Session lifecycle hooks maintain context continuity across sessions, enable pattern extraction, and integrate with handoff for seamless workflow transitions.

---

<critical_constraint>
Portability invariant: Zero external dependencies - this skill must work in projects with no .claude/rules/ files.
Session hooks require POSIX-compliant bash for cross-platform compatibility.
</critical_constraint>
