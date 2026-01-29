---
description: "Review session history to auto-refine system rules, skills, and configuration. Use when a session had friction, corrections, or novel discoveries. Triggers the meta-learning-extractor skill."
argument-hint: "[focus-area] (optional)"
---

# System Meta-Learner

<mission_control>
<objective>Capture recent experience and transmute it into permanent system improvements</objective>
<success_criteria>Session analyzed, friction points identified, specific rule files patched</success_criteria>
</mission_control>

## 1. Context Capture (The Sensor)

**Recent Transcript**:
<injected_content>
@.claude/transcripts/last-session.jsonl
</injected_content>
*(If empty, use current conversation history)*

**System Map**:
Current Rules: !`ls -F .claude/rules/`
Active Skills: !`ls -F .claude/skills/`
Config State: !`cat CLAUDE.md | grep -A 5 "System Discoveries"`

## 2. Intent Negotiation (The Funnel)

$IF($1, 
    Targeting specific focus area: $1,
    AskUserQuestion: "What type of learning should I extract?"
    [
        "Friction/Repairs (Fix errors encountered)",
        "Novel Patterns (Capture new successful workflows)",
        "Architecture (Refine folder/file structure rules)",
        "Auto-Detect (Analyze entire session for improvements)"
    ]
)

## 3. Execution (The Handover)

Invoke `skills/meta-learning-extractor` skill.
**Input**: Full session context + User Intent.
**Goal**: Update the `.claude/` ecosystem to prevent recurrence of errors or solidify new capabilities.