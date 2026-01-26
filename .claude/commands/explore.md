---
description: "Explore and analyze a skill/command through guided questioning. Use when: user mentions 'explore', 'analyze', 'guided questioning'; need to understand context before proceeding; uncovering assumptions and insights. Not for: quick direct answers, simple tool execution."
argument-hint: [skill-or-command-path]
---

# Exploratory Analysis

Explore and analyze a skill/command through guided questioning.

## Starting Point

**Target**: $ARGUMENTS

**Files present:**
!`TARGET="$ARGUMENTS"; if [ -n "$TARGET" ] && [ -d "$TARGET" ]; then find "$TARGET" -name "*.md" -type f | sort; elif [ -n "$TARGET" ] && [ -f "$TARGET" ]; then echo "$TARGET"; else echo "No valid target provided"; fi`

**Content:**
!`TARGET="$ARGUMENTS"; if [ -d "$TARGET" ]; then find "$TARGET" -name "*.md" -type f -exec echo "=== {} ===" \; -exec cat {} \; -exec echo "" \; | head -c 50000; elif [ -f "$TARGET" ]; then cat "$TARGET"; else echo "# No valid target provided\n\nPlease provide a path to a skill folder or command file.\n\nUsage:\n  /explore .claude/skills/skill-name\n  /explore .claude/commands/command-name.md"; fi`

## The Approach

**Work through this iteratively:**

1. **Understand context** — What are we looking at and why does it matter?
2. **Explore dimensions** — What aspects deserve attention?
3. **Question assumptions** — What seems obvious but might not be?
4. **Reach conclusions** — What should actually happen?

**Use AskUserQuestion** to guide exploration—ask one question at a time, build on responses, and let the dialogue shape the direction. Continue until clarity emerges naturally.

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
