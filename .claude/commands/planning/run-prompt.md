---
name: run-prompt
description: Execute saved prompts in fresh sub-agent contexts. Provides clean execution environment for meta-prompts created by /create-prompt.
disable-model-invocation: false
allowed-tools: ["Read", "Task", "Bash"]
---

# Run Prompt: Execute Saved Prompts

Execute structured prompts created by `/create-prompt` in fresh sub-agent contexts for clean execution.

## What This Command Does

Execute saved prompts using a fresh context window:
- Load prompt from file
- Spawn sub-agent with clean context
- Provide isolated execution environment
- Return results to main context

**Key Innovation**: Clean execution context prevents context pollution and enables focused work.

## How It Works

### Phase 1: Load Prompt

Read the prompt file and validate structure:

```bash
# Verify prompt file exists
PROMPT_FILE="$1"

if [[ ! -f "$PROMPT_FILE" ]]; then
  echo "ERROR: Prompt file not found: $PROMPT_FILE"
  exit 1
fi

# Read prompt content
cat "$PROMPT_FILE"
```

**Validation checklist**:
- [ ] Prompt file exists
- [ ] Has required sections (Objective, Requirements, Success Criteria)
- [ ] Success criteria are measurable
- [ ] Output format is specified

**Recognition**: "Is this prompt complete enough for autonomous execution?"

### Phase 2: Spawn Sub-Agent

Launch fresh sub-agent with the prompt:

```
Use Task tool with subagent_type="general-purpose"

Provide the prompt content as the task description.
```

**Sub-agent configuration**:
- Fresh context (no conversation history pollution)
- Full tool access (Read, Write, Bash, etc.)
- Isolated working directory
- Independent token budget

### Phase 3: Monitor Execution

Monitor for semantic errors during execution:

| Error Type | Pattern | Action |
|------------|---------|--------|
| Context Access | "I don't have access", "no such file" | Provide missing context |
| Intent Drift | "I'll try instead", "Let me do this" | Realign to original objective |
| Logic Failure | Tests fail, assertions break | Debug and fix |
| Tool Failure | Commands fail, permissions | Fix tool issues |

**Recognition**: "Is the sub-agent staying aligned with the prompt's objective?"

### Phase 4: Collect Results

After sub-agent completes, collect results:

```bash
# Results are returned via TaskOutput
# Verify against success criteria
# Document any deviations
```

**Validation checklist**:
- [ ] All success criteria met
- [ ] Output format matches specification
- [ ] No semantic errors occurred
- [ ] Deviations documented (if any)

### Phase 5: Archive Prompt

After successful execution, archive the prompt:

```bash
# Archive with timestamp
ARCHIVE_PATH=".agent/prompts/archive/$(date +%Y/%m)/"
mkdir -p "$ARCHIVE_PATH"
mv "$PROMPT_FILE" "$ARCHIVE_PATH/"
```

**Recognition**: "Should this prompt be kept for reference or archived?"

## Output Format

After execution completes, provide summary:

```
PROMPT EXECUTION SUMMARY
========================

Prompt File:     [path]
Status:          [COMPLETED/FAILED/DEVIATED]
Duration:        [time]

Success Criteria:
✓ [criterion 1]
✓ [criterion 2]
✗ [criterion 3] - [reason]

Deviations:
- [any deviations from original prompt]

Results:
[output location, files created, etc.]

Next Steps:
- Archive prompt: /archive-prompt [file]
- Re-run if needed: /run-prompt [file]
- Review results manually
```

## Best Practices

### Before Execution
- Verify prompt completeness
- Check success criteria are measurable
- Ensure all required context is included
- Verify output format is specified

### During Execution
- Monitor for semantic errors
- Check alignment with original objective
- Verify tool usage is appropriate
- Watch for context access issues

### After Execution
- Validate against success criteria
- Document any deviations
- Archive completed prompts
- Review results for quality

## Integration with Create-Prompt

This command completes the meta-prompting workflow:

```
/create-prompt  →  Generate structured prompt
/run-prompt     →  Execute in fresh context
/archive        →  Archive completed work
```

## Related Commands

This command integrates with:
- `/create-prompt` - Generate structured prompts
- `/handoff` - Create context handoff for long-running work
- Task tool - Spawns sub-agents for execution

## Arguments

First argument: Path to prompt file (required)

```
/run-prompt .agent/prompts/20260126_143000-add-auth.md
/run-prompt .agent/prompts/latest-prompt.md
```

Optional arguments: Additional context or overrides

```
/run-prompt [file] "with additional note"
```

## Recognition Questions

Before execution, ask:
- "Is this prompt complete and validated?"
- "Are success criteria measurable?"
- "Will a fresh context have everything needed?"

After execution, ask:
- "Were all success criteria met?"
- "Did any deviations occur?"
- "Should this prompt be archived?"

**Trust intelligence** - Fresh contexts enable focused execution, but prompt quality determines success.
