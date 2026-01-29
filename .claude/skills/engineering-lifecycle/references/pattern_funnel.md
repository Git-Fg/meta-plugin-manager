# Funnel Pattern Reference

Iterative narrowing of problem space through intelligent batching.

## Core Principles

1. **Continuous Exploration** - Investigate at ANY time, don't wait for user response
2. **One Question at a Time** - Every question offers 2-4 recognition-based options
3. **Efficient Funneling** - Each round reduces uncertainty

## Interaction Schema

EXPLORE → ASK ONE → EXPLORE RESPONSE → ASK AGAIN (if needed) → WRITE PLAN → CONFIRM

## Flow

1. **EXPLORE** - view_file codebase, check git history, identify constraints
2. **INFER** - Try to infer answers from exploration
3. **ASK ONE** - Focused question with 2-4 options
4. **EXPLORE RESPONSE** - Use tools to verify user's answer
5. **IF UNCLEAR** → Explore more → Ask next focused question
6. **WHEN CLEAR** → STOP asking → WRITE PLAN
7. **CONFIRM** - Single final question about invoking execution

## Batching Guidelines

DO batch together:

- Questions sharing the same context
- Questions where earlier answers inform later options
- Questions about the same topic/decision area
- 2-4 questions max per call

DON'T batch together:

- Unrelated topics
- Questions requiring separate investigation phases
- More than 4 questions (overwhelming)

## Question Structure Patterns

| Pattern                   | Flow                                                |
| ------------------------- | --------------------------------------------------- |
| Broad → Specific → Action | Categorize → Identify → Confirm → Execute           |
| Dependency Chain          | Q1: Language? Q2: Framework? Q3: Library? → Execute |
| Elimination               | Q1: X/Y/Z? Q2: Y/Z? Q3: Confirm → Execute           |
