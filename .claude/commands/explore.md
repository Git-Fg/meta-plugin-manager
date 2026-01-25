---
description: Explore and analyze a skill/command through guided questioning
argument-hint: [skill-or-command-path]
---

# Exploratory Analysis

Think of exploratory analysis as **walking through a maze with a flashlight**—each question illuminates another section, gradually revealing the complete picture. The goal isn't to rush through, but to explore what matters and uncover assumptions through guided dialogue.

## Recognition Patterns

**When to use explore:**
```
✅ Good: "Analyze a skill through guided questioning"
✅ Good: "Explore a command through dialogue"
✅ Good: "Understand context before proceeding"
❌ Bad: Quick, direct answers needed
❌ Bad: Simple tool execution

Why good: Exploratory analysis uncovers assumptions and context through dialogue.
```

**Pattern Match:**
- User mentions "explore", "analyze", "guided questioning"
- Need to understand context before proceeding
- Uncovering assumptions and insights

**Recognition:** "Do you need to explore and understand context through dialogue?" → Use explore.

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
- A clear direction emerges without prompting
- The same insight surfaces across multiple questions
- Confidence is expressed about the path forward
- New questions no longer yield new information

**Recognition:** "Do questions still reveal new insights?" → If no, stop and conclude.

## Contrast

```
✅ Good: Ask one question at a time
✅ Good: Build on previous responses
✅ Good: Let dialogue shape direction
❌ Bad: Rush to answers
❌ Bad: Ask multiple questions simultaneously

Why good: Guided exploration reveals context gradually.

✅ Good: Understand context before proceeding
❌ Bad: Dive into analysis without understanding

Why good: Context illuminates what actually matters.
```

**Recognition:** "Does this exploration uncover meaningful insights?" → Check: 1) Questions reveal context, 2) Dialogue shapes direction, 3) Assumptions questioned.

## Moving Forward

Begin by understanding what matters most about `$ARGUMENTS`, then explore from there. Trust the process—let questions lead where they need to go.

**Key Question**: "What assumptions are we making that might not be true?" Ask this to uncover hidden context.
