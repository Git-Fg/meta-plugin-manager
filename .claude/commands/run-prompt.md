---
name: run-prompt
description: Delegate one or more prompts to fresh sub-task contexts with parallel or sequential execution
argument-hint: <prompt-number(s)-or-name> [--parallel|--sequential]
allowed-tools: [Read, Task, Bash(find:*), Bash(ls:*), Bash(mv:*), Bash(git:*)]
---

<mission_control>
<objective>Execute prompts from .claude/workspace/prompts/ as delegated sub-tasks</objective>
<success_criteria>All prompts executed, results captured, sub-task contexts created</success_criteria>
</mission_control>

<context>
Git status: !`git status --short`
Recent prompts: !`find .claude/workspace/prompts -name "*.md" -type f -printf '%T@ %p\n' | sort -rn | head -5 | cut -d' ' -f2-`
</context>

## Objective

Execute one or more prompts from `.claude/workspace/prompts/` as delegated sub-tasks with fresh context. Supports single prompt execution, parallel execution of multiple independent prompts, and sequential execution of dependent prompts.

## Input

The user will specify which prompt(s) to run via $ARGUMENTS, which can be:

**Single prompt:**

- Empty (no arguments): Run the most recently created prompt (default behavior)
- A prompt number (e.g., "001", "5", "42")
- A partial filename (e.g., "user-auth", "dashboard")

**Multiple prompts:**

- Multiple numbers (e.g., "005 006 007")
- With execution flag: "005 006 007 --parallel" or "005 006 007 --sequential"
- If no flag specified with multiple prompts, default to --sequential for safety
  </input>

## Process

### Step 1: Parse Arguments

Parse $ARGUMENTS to extract:

- Prompt numbers/names (all arguments that are not flags)
- Execution strategy flag (--parallel or --sequential)

**Examples:**

- "005" → Single prompt: 005
- "005 006 007" → Multiple prompts: [005, 006, 007], strategy: sequential (default)
- "005 006 007 --parallel" → Multiple prompts: [005, 006, 007], strategy: parallel
- "005 006 007 --sequential" → Multiple prompts: [005, 006, 007], strategy: sequential

### Step 2: Resolve Files

For each prompt number/name:

- If empty or "last": Find with `!find .claude/workspace/prompts -name "*.md" -type f -printf '%T@ %p\n' | sort -rn | head -1 | cut -d' ' -f2-`
- If a number: Find file matching that zero-padded number in subdirectories (e.g., "5" matches "001-auth-research/005-PROMPT.md")
- If text: Find files containing that string in the path (searches subdirectories recursively)

**Matching Rules:**

- If exactly one match found: Use that file
- If multiple matches found: List them and ask user to choose
- If no matches found: Report error and list available prompts

### Step 3: Execute

#### Single Prompt

1. Read the complete contents of the prompt file
2. Delegate as sub-task using Task tool with subagent_type="general-purpose"
3. Wait for completion
4. Archive prompt to `.claude/workspace/prompts/completed/` with metadata
5. Commit all work:
   - Stage files YOU modified with `git add [file]` (never `git add .`)
   - Determine appropriate commit type based on changes (fix|feat|refactor|style|docs|test|chore)
   - Commit with format: `[type]: [description]` (lowercase, specific, concise)
6. Return results

#### Parallel Execution

1. Read all prompt files
2. **Spawn all Task tools in a SINGLE MESSAGE** (this is critical for parallel execution):
   - Use Task tool for prompt 005
   - Use Task tool for prompt 006
   - Use Task tool for prompt 007
     (All in one message with multiple tool calls)
3. Wait for ALL to complete
4. Archive all prompts with metadata
5. Commit all work:
   - Stage files YOU modified with `git add [file]` (never `git add .`)
   - Determine appropriate commit type based on changes (fix|feat|refactor|style|docs|test|chore)
   - Commit with format: `[type]: [description]` (lowercase, specific, concise)
6. Return consolidated results

#### Sequential Execution

1. Read first prompt file
2. Spawn Task tool for first prompt
3. Wait for completion
4. Archive first prompt
5. Read second prompt file
6. Spawn Task tool for second prompt
7. Wait for completion
8. Archive second prompt
9. Repeat for remaining prompts
10. Archive all prompts with metadata
11. Commit all work:
    - Stage files YOU modified with `git add [file]` (never `git add .`)
    - Determine appropriate commit type based on changes (fix|feat|refactor|style|docs|test|chore)
    - Commit with format: `[type]: [description]` (lowercase, specific, concise)
12. Return consolidated results

## Context Strategy

By delegating to a sub-task, the actual implementation work happens in fresh context while the main conversation stays lean for orchestration and iteration.

## Output

### Single Prompt Output

✓ Executed: .claude/workspace/prompts/005-implement-feature.md
✓ Archived to: .claude/workspace/prompts/completed/005-implement-feature.md

**Results:**
[Summary of what the sub-task accomplished]

### Parallel Output

✓ Executed in PARALLEL:

- .claude/workspace/prompts/005-implement-auth.md
- .claude/workspace/prompts/006-implement-api.md
- .claude/workspace/prompts/007-implement-ui.md

✓ All archived to .claude/workspace/prompts/completed/

**Results:**
[Consolidated summary of all sub-task results]

### Sequential Output

✓ Executed SEQUENTIALLY:

1. .claude/workspace/prompts/005-setup-database.md → Success
2. .claude/workspace/prompts/006-create-migrations.md → Success
3. .claude/workspace/prompts/007-seed-data.md → Success

✓ All archived to .claude/workspace/prompts/completed/

**Results:**
[Consolidated summary showing progression through each step]
</output>

## Critical Notes

- For parallel execution: ALL Task tool calls MUST be in a single message
- For sequential execution: Wait for each Task to complete before starting next
- Archive prompts only after successful completion
- If any prompt fails, stop sequential execution and report error
- Provide clear, consolidated results for multiple prompt execution

---

<critical_constraint>
MANDATORY: Parallel execution - all Task calls in single message
MANDATORY: Sequential execution - wait for each completion before next
MANDATORY: Archive prompts only after successful completion
MANDATORY: Stop on first failure in sequential mode
No exceptions. Sub-task execution must follow parallel/sequential constraints.
</critical_constraint>
