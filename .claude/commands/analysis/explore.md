---
description: "Explore and analyze a skill or command through guided questioning to understand context before proceeding and uncover assumptions. Not for quick direct answers or simple tool execution."
argument-hint: [skill-or-command-path]
---

<mission_control>
<objective>Explore and analyze skill/command through guided questioning to understand context and assumptions</objective>
<success_criteria>Clarity emerges through iterative questioning, user validates findings</success_criteria>
</mission_control>

<interaction_schema>
understand_context → explore_dimensions → question_assumptions → reach_conclusions
</interaction_schema>

# Exploratory Analysis

Explore and analyze a skill/command through guided questioning.

## Starting Point

**Target**: $ARGUMENTS

**Files present:**
!`TARGET="$ARGUMENTS"; if [ -n "$TARGET" ] && [ -d "$TARGET" ]; then find "$TARGET" -name "*.md" -type f | sort; elif [ -n "$TARGET" ] && [ -f "$TARGET" ]; then echo "$TARGET"; else echo "No valid target provided"; fi`

**Content:**
!`TARGET="$ARGUMENTS"; if [ -d "$TARGET" ]; then find "$TARGET" -name "*.md" -type f -exec echo "=== {} ===" \; -exec cat {} \; -exec echo "" \; | head -c 50000; elif [ -f "$TARGET" ]; then cat "$TARGET"; else echo "# No valid target provided\n\nPlease provide a path to a skill folder or command file.\n\nUsage:\n  /explore .claude/skills/skill-name\n  /explore .claude/commands/command-name.md"; fi`

## The Approach

**L'Entonnoir pattern applied:**

```
AskUserQuestion (batch of 2-4 options, recognition-based)
     ↓
User selects from options (no typing)
     ↓
Explore based on selection
     ↓
AskUserQuestion (narrower batch)
     ↓
Repeat until ready → Conclude
```

**Core principles:**

1. **Continuous exploration** — Investigate at ANY time, not just between rounds
2. **Recognition-based questions** — User selects from 2-4 options, never types
3. **Progressive narrowing** — Each round reduces uncertainty
4. **Exit criteria** — Stop when clarity emerges

## Recognition Questions

**Ask these binary questions as you explore:**

- **"What would Claude know without being told?"** → Delta Standard
  - Yes = Remove (Claude already knows)
  - No = Keep (project-specific knowledge)

- **"Can this work standalone?"** → Autonomy
  - Yes = Good (self-sufficient)
  - No = Add Success Criteria

- **"Is the overhead justified?"** → Context cost
  - Yes = Keep
  - No = Remove or move to references/

- **"Does this earn its token cost?"** → Value
  - Yes = Keep
  - No = Streamline

## When to Stop Questioning

**Stop when:**

- Clear direction emerges without prompting
- Same insight surfaces across multiple questions
- Confidence expressed about path forward
- New questions no longer yield new information

**Binary test:** "Do questions still reveal new insights?" → If no, stop and conclude.

## Moving Forward

Begin by understanding what matters most about `$ARGUMENTS`, then explore from there. Trust the process—let questions lead where they need to go.

**Key Question**: "What assumptions are we making that might not be true?" Ask this to uncover hidden context.

<critical_constraint>
MANDATORY: Use tools first, never ask blind
MANDATORY: Ask recognition-based questions, not open-ended generation
MANDATORY: Batch 1-4 related questions per AskUserQuestion call, investigate between rounds
No exceptions. Guided exploration requires disciplined questioning.
</critical_constraint>
