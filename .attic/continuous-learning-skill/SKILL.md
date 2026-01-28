---
name: continuous-learning
description: "Instinct-based learning system that observes sessions via hooks, creates atomic instincts with confidence scoring, and evolves them into skills/commands/agents. Use when: Learning patterns from sessions, capturing recurring behaviors, or evolving observations into components. Not for: Simple pattern storage or temporary notes."
---

# Continuous Learning v2 - Instinct-Based Architecture

An advanced learning system that turns Claude Code sessions into reusable knowledge through atomic "instincts" - small learned behaviors with confidence scoring.

## What Is an Instinct?

An instinct is a small, atomic learned behavior:

```yaml
---
id: prefer-functional-style
trigger: "when writing new functions"
confidence: 0.7
domain: "code-style"
source: "session-observation"
---

# Prefer Functional Style

## Action
Use functional patterns over classes when appropriate.

## Evidence
- Observed 5 instances of functional pattern preference
- User corrected class-based approach to functional on 2025-01-15
```

**Properties:**

- **Atomic** — one trigger, one action
- **Confidence-weighted** — 0.3 = tentative, 0.9 = near certain
- **Domain-tagged** — code-style, testing, git, debugging, workflow
- **Evidence-backed** — tracks what observations created it

## How It Works

```
Session Activity
      │
      │ Hooks capture prompts + tool use (100% reliable)
      ▼
┌─────────────────────────────────────────┐
│         observations.jsonl              │
│   (prompts, tool calls, outcomes)       │
└─────────────────────────────────────────┘
      │
      │ Observer agent reads (background, Haiku)
      ▼
┌─────────────────────────────────────────┐
│          PATTERN DETECTION              │
│   • User corrections → instinct         │
│   • Error resolutions → instinct        │
│   • Repeated workflows → instinct       │
└─────────────────────────────────────────┘
      │
      │ Creates/updates
      ▼
┌─────────────────────────────────────────┐
│         instincts/personal/             │
│   • prefer-functional.md (0.7)          │
│   • always-test-first.md (0.9)          │
│   • use-zod-validation.md (0.6)         │
└─────────────────────────────────────────┘
      │
      │ /evolve clusters
      ▼
┌─────────────────────────────────────────┐
│              evolved/                   │
│   • commands/new-feature.md             │
│   • skills/testing-workflow.md          │
│   • agents/refactor-specialist.md       │
└─────────────────────────────────────────┘
```

## Why Hooks vs Skills for Observation?

> "v1 relied on skills to observe. Skills are probabilistic—they fire ~50-80% of the time based on Claude's judgment."

Hooks fire **100% of the time**, deterministically. This means:

- Every tool call is observed
- No patterns are missed
- Learning is comprehensive

## Confidence Scoring

Confidence evolves over time:

| Score | Meaning      | Behavior                      |
| ----- | ------------ | ----------------------------- |
| 0.3   | Tentative    | Suggested but not enforced    |
| 0.5   | Moderate     | Applied when relevant         |
| 0.7   | Strong       | Auto-approved for application |
| 0.9   | Near-certain | Core behavior                 |

**Confidence increases** when:

- Pattern is repeatedly observed
- User doesn't correct the suggested behavior
- Similar instincts from other sources agree

**Confidence decreases** when:

- User explicitly corrects the behavior
- Pattern isn't observed for extended periods
- Contradicting evidence appears

## Storage Structure

```
~/.claude/homunculus/
├── observations.jsonl      # Current session observations
├── observations.archive/   # Processed observations
├── instincts/
│   ├── personal/           # Auto-learned instincts
│   └── inherited/          # Imported from others
└── evolved/
    ├── agents/             # Generated specialist agents
    ├── skills/             # Generated skills
    └── commands/           # Generated commands
```

## Pattern Detection

The observer agent looks for these patterns:

### 1. User Corrections

When a user's follow-up message corrects Claude's previous action:

- "No, use X instead of Y"
- "Actually, I meant..."
- Immediate undo/redo patterns

→ Create instinct: "When doing X, prefer Y"

### 2. Error Resolutions

When an error is followed by a fix:

- Tool output contains error
- Next few tool calls fix it
- Same error type resolved similarly multiple times

→ Create instinct: "When encountering error X, try Y"

### 3. Repeated Workflows

When the same sequence of tools is used multiple times:

- Same tool sequence with similar inputs
- File patterns that change together
- Time-clustered operations

→ Create workflow instinct: "When doing X, follow steps Y, Z, W"

### 4. Tool Preferences

When certain tools are consistently preferred:

- Always uses Grep before Edit
- Prefers Read over Bash cat
- Uses specific Bash commands for certain tasks

→ Create instinct: "When needing X, use tool Y"

## Usage Patterns

### Enable Observation Hooks

Hooks are automatically configured in `.claude/settings.json`:

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": ".*",
        "hooks": [
          {
            "type": "command",
            "command": "\"$CLAUDE_PROJECT_DIR\"/.claude/scripts/learning-observer.sh",
            "description": "Capture tool usage for continuous learning"
          }
        ]
      }
    ]
  }
}
```

### Run Observer Agent

Trigger pattern analysis:

```bash
# Run observer manually
claude --agent learning-observer

# Or use the instinct status command
/instinct-status
```

### Evolve Instincts

Cluster related instincts into components:

```bash
/evolve
```

This clusters instincts by domain and creates:

- Skills from workflow instincts
- Commands from user preferences
- Agents from specialized patterns

### Export/Import Instincts

Share learned patterns:

```bash
# Export instincts
/instinct-export my-patterns.json

# Import instincts
/instinct-import shared-patterns.json
```

## Integration with Seed System

### Instincts vs Ralph Memories

| Aspect      | Instincts               | Ralph Memories              |
| ----------- | ----------------------- | --------------------------- |
| Source      | Auto-evolved from hooks | Curated manually            |
| Confidence  | Weighted (0.3-0.9)      | Binary (present/absent)     |
| Granularity | Atomic behaviors        | Explicit patterns/decisions |
| Evolution   | Automatic               | Manual                      |

**Integration:** High-confidence instincts (0.8+) can evolve into curated Ralph memories.

### Instincts vs Skills

| Aspect   | Instincts                    | Skills                        |
| -------- | ---------------------------- | ----------------------------- |
| Size     | Atomic (1 trigger, 1 action) | Comprehensive (full workflow) |
| Creation | Automatic (observation)      | Manual (skill-development)    |
| Format   | YAML frontmatter             | XML-based SKILL.md            |

**Integration:** Related instincts cluster into full skills via `/evolve`.

## Privacy Considerations

- Observations stay **local** on your machine
- Only **instincts** (patterns) can be exported
- No actual code or conversation content is shared
- You control what gets exported

## Best Practices

1. **Be Conservative**: Only create instincts for clear patterns (3+ observations)
2. **Be Specific**: Narrow triggers are better than broad ones
3. **Track Evidence**: Always include what observations led to the instinct
4. **Respect Privacy**: Never include actual code snippets, only patterns
5. **Merge Similar**: If a new instinct is similar to existing, update rather than duplicate

## Configuration

Optional configuration in `~/.claude/homunculus/config.json`:

```json
{
  "version": "2.0",
  "observation": {
    "enabled": true,
    "store_path": "~/.claude/homunculus/observations.jsonl",
    "max_file_size_mb": 10,
    "archive_after_days": 7
  },
  "instincts": {
    "personal_path": "~/.claude/homunculus/instincts/personal/",
    "inherited_path": "~/.claude/homunculus/instincts/inherited/",
    "min_confidence": 0.3,
    "auto_approve_threshold": 0.7,
    "confidence_decay_rate": 0.05
  },
  "observer": {
    "enabled": true,
    "model": "haiku",
    "run_interval_minutes": 5,
    "patterns_to_detect": [
      "user_corrections",
      "error_resolutions",
      "repeated_workflows",
      "tool_preferences"
    ]
  },
  "evolution": {
    "cluster_threshold": 3,
    "evolved_path": "~/.claude/homunculus/evolved/"
  }
}
```

## Related Skills

- **ralph-memories**: Curated pattern storage for Ralph orchestration
- **filesystem-context**: Persistent storage patterns for observations
- **create-agent-skills**: Evolving instincts into full agents

## Key Principle

Hook-based observation creates 100% reliable pattern capture. Instincts evolve from observations into reusable components through confidence-weighted learning.
