# Troubleshooting Guide

Use this guide when Ralph behaves unexpectedly or has errors. Fresh context reveals state, backpressure reveals quality issues.

---

## Common Issues & Solutions

### Configuration Problems

#### Symptom: Config errors
**Root Cause**: Invalid YAML or missing file
**Solution**:
```bash
# Regenerate baseline configuration
ralph init --preset feature

# Validate YAML syntax
python -c "import yaml; yaml.safe_load(open('ralph.yml'))"

# Check for unknown fields
ralph init --help
```

#### Symptom: "Unknown field" errors
**Root Cause**: Using fields that don't exist in the configuration schema
**Solution**:
- Check CLI help: `ralph <subcommand> --help`
- Compare with known working configuration
- Ensure field names match the schema exactly

#### Symptom: Preset not found
**Root Cause**: Typo in preset name or preset doesn't exist
**Solution**:
```bash
# List all available presets
ralph init --list-presets

# Use exact name from list
ralph init --preset feature  # NOT "feature-workflow"
```

### Event Coordination Problems

#### Symptom: Hat never publishes
**Root Cause**: Missing `publishes` field or wrong event names
**Solution**:
1. Check hat configuration:
```yaml
hats:
  my_hat:
    triggers: ["event.in"]    # What activates this hat
    publishes: ["event.out"]  # What this hat emits (REQUIRED)
```

2. Verify event flow:
```bash
ralph events --help
ralph run --verbose  # See what events are being published
```

3. Check event history for actual published events

#### Symptom: Workflow stops too early
**Root Cause**: Missing `starting_event` or incorrect first trigger
**Solution**:
```yaml
event_loop:
  starting_event: "workflow.started"  # Must match first hat's trigger

hats:
  first_hat:
    triggers: ["workflow.started"]  # Must match starting_event
```

#### Symptom: Workflow runs forever
**Root Cause**: Wrong `completion_promise` or events not publishing
**Solution**:
1. Verify completion event name:
```yaml
event_loop:
  completion_promise: "LOOP_COMPLETE"  # Must match event name

# Hat must publish this exact event
hats:
  final_hat:
    publishes: ["task.complete", "LOOP_COMPLETE"]  # Include completion promise
```

2. Check event flow:
```bash
ralph run --verbose
ralph events --watch
```

### Hat Coordination Problems

#### Symptom: "No hat triggered" errors
**Root Cause**: Event doesn't match any hat's triggers
**Solution**:
1. Review trigger patterns:
```yaml
hats:
  hat_a:
    triggers: ["event.one", "event.two"]  # Must match published events exactly

# Publishing wrong event
# BAD: Publish event.three
# GOOD: Publish event.one
```

2. Check event naming:
- Use exact strings in triggers and publishes
- No wildcards in trigger matching
- Events are case-sensitive

#### Symptom: Multiple hats triggered by same event
**Root Cause**: Event matches multiple hat triggers
**Solution**:
- Each trigger should map to exactly ONE hat
- Review trigger patterns for overlaps
- Use more specific event names

```yaml
# BAD - both hats trigger on "work.done"
hats:
  hat_a:
    triggers: ["work.done"]
  hat_b:
    triggers: ["work.done"]

# GOOD - distinct triggers
hats:
  hat_a:
    triggers: ["build.complete"]
  hat_b:
    triggers: ["review.complete"]
```

### Execution Problems

#### Symptom: Ralph rejects work
**Root Cause**: Quality gates (tests/lint/typecheck) failed
**Solution**:
- **DO NOT** change the workflow
- **FIX** the actual code quality issues
- Check what failed:
```bash
# Ralph runs these backpressure checks
cargo check && cargo test && cargo clippy -- -D warnings
# OR
npm test && npm run lint
# OR
python -m pytest && flake8 .
```

- Fix failing tests, linting errors, or type errors
- Ralph will automatically retry after fixes

#### Symptom: Backpressure keeps rejecting
**Root Cause**: Quality standards not met OR wrong quality gates configured
**Solution**:
1. Fix actual code issues:
   - Write passing tests
   - Fix linting errors
   - Resolve type errors

2. Adjust quality gates if inappropriate:
```yaml
hats:
  builder:
    instructions: |
      # Custom quality checks
      - Run your project-specific tests
      - Verify against your standards
      - Only publish build.done if quality is acceptable
```

#### Symptom: "Re-reading files" seems inefficient
**Root Cause**: Fresh context philosophy confusion
**Solution**:
- **This is intentional and correct**
- Fresh context = reliability through explicit state
- Prevents assumptions and hidden dependencies
- Every iteration re-reads files to ensure accuracy
- This is a feature, not a bug

### Runtime Problems

#### Symptom: Runs forever / Never stops
**Root Cause**: Infinite loop in workflow logic
**Solution**:
1. Check completion promise:
```yaml
# Must eventually publish this event
event_loop:
  completion_promise: "LOOP_COMPLETE"
```

2. Add debug output:
```bash
ralph run --verbose  # See decision-making process
ralph run --iterations 10  # Limit iterations for testing
```

3. Check hat logic for missing exit conditions

#### Symptom: Out of memory / OOM errors
**Root Cause**: Large files, memory leaks, or inefficient processing
**Solution**:
1. Limit iteration scope:
```yaml
event_loop:
  max_iterations: 10  # Reasonable limit

# In hat instructions
hats:
  builder:
    instructions: |
      # Process in chunks
      # Don't load entire files into memory
      # Use streaming for large datasets
```

2. Monitor memory usage:
```bash
top -p $(pgrep -f ralph)
```

#### Symptom: Slow performance
**Root Cause**: Large context, inefficient prompts, too many iterations
**Solution**:
1. Optimize prompts:
   - Be specific and concise
   - Avoid redundant instructions
   - Focus on essential information

2. Limit scope:
```yaml
event_loop:
  max_iterations: 5  # Reasonable limit

# In instructions
hats:
  builder:
    instructions: |
      # Focus on one task at a time
      # Don't try to solve everything
      # Be incremental
```

### Backend Problems

#### Symptom: Claude backend issues
**Root Cause**: Tried different backend without reason OR API issues
**Solution**:
- Use default Claude: `ralph init --preset <name>` (no --backend flag)
- Check API key configuration
- Verify network connectivity

#### Symptom: Backend authentication errors
**Root Cause**: Missing or invalid API credentials
**Solution**:
1. Check environment variables:
```bash
echo $ANTHROPIC_API_KEY
```

2. Verify configuration:
```bash
ralph config list
```

3. Set credentials:
```bash
export ANTHROPIC_API_KEY="your-key-here"
```

### Event Flow Debugging

#### Symptom: Can't understand event flow
**Solution**:
1. Monitor events in real-time:
```bash
# Terminal 1: Run Ralph
ralph run

# Terminal 2: Watch events
ralph events --watch
```

2. Understand event structure:
- Events have a topic (event name)
- Events have data (payload)
- Events have timestamp

3. Trace event flow:
- Hats trigger on `topic` matching their `triggers`
- Hats publish new events via their `publishes`

### File System Problems

#### Symptom: "Permission denied" errors
**Root Cause**: Ralph can't write to required directories
**Solution**:
```bash
# Ensure write permissions
chmod -R 755 .

# Check directory structure
ls -la .agent/  # Should exist and be writable
```

#### Symptom: Missing .agent directory
**Root Cause**: Ralph wasn't properly initialized
**Solution**:
```bash
# Re-initialize
ralph init --preset feature

# Directory should be created automatically
ls -la .agent/
```

## Debugging Approach

### When Issues Arise

**1. Check events**: Understand what happened in the orchestration flow
```bash
# View event history
ralph events list

# Or in real-time
ralph events --watch
```

**2. Enable verbose output**: See Ralph's decision-making process
```bash
ralph run --verbose
```

**3. Test with limits**: Try a dry run or single iteration first
```bash
ralph run --iterations 1
ralph run --dry-run
```

**4. Reset if needed**: Clean state when troubleshooting gets complex
```bash
ralph clean
ralph init --preset feature
```

### Systematic Debugging

**Principle**: Use debugging tools to understand, not to guess. Each tool reveals specific information about Ralph's state.

**Step-by-step approach**:
1. Start with visibility: `ralph run --verbose`
2. Check the flow: Review event history
3. Test incrementally: `--iterations 1`
4. Consult documentation: `ralph <subcommand> --help`

### Debugging Checklist

- [ ] Check event history for event flow
- [ ] Run with `--verbose` for decision visibility
- [ ] Try `--iterations 1` to isolate issues
- [ ] Verify YAML syntax with a validator
- [ ] Check hat triggers match published events
- [ ] Ensure completion promise is eventually published
- [ ] Review quality gates (backpressure) aren't too strict
- [ ] Verify API credentials for backend
- [ ] Check file permissions for .agent directory
- [ ] Ensure workflow follows clean publishes pattern (see [prompt-engineering.md](prompt-engineering.md#testing-your-preset))

## Emergency Procedures

### Stop a Runaway Workflow
```bash
# Ctrl+C to stop current run
# Or kill the process
pkill -f ralph

# Check event history
ralph events list

# Reset state if needed
ralph clean
```

### Reset to Known Good State
```bash
# Remove Ralph-specific files
rm -rf .agent/
rm -f ralph.yml

# Re-initialize
ralph init --preset feature
```

### Backup Before Troubleshooting
```bash
# Backup current configuration
cp ralph.yml ralph.yml.backup

# Backup event history
cp -r .agent/ .agent.backup
```

## Prevention Strategies

### Configuration Management
1. **Version control**: Keep `ralph.yml` in git
2. **Test changes**: Use `--iterations 1` before full runs
3. **Document customizations**: Comment why you changed things

### Quality Gates
1. **Start strict**: Better to reject bad work than accept it
2. **Adjust carefully**: Only loosen if genuinely inappropriate
3. **Test gates**: Verify quality checks work as expected

### Event Design
1. **Be explicit**: Use clear, specific event names
2. **One-to-one mapping**: Each trigger → one hat
3. **Document flow**: Comment the event flow in YAML

## Getting Help

### Self-Diagnosis Questions

**Ask yourself**:
1. What changed since it last worked?
2. What is the exact error message?
3. What does event history show?
4. Does `ralph run --verbose` reveal anything?
5. Can I reproduce with `--iterations 1`?

### Information to Gather

When seeking help, provide:
- Output of `ralph run --verbose`
- Event history
- The `ralph.yml` configuration
- Steps to reproduce the issue
- Expected vs actual behavior

### Resources

1. **CLI help**: `ralph <subcommand> --help`
2. **This troubleshooting guide**: Current document
3. **Ralph documentation**: Official docs
4. **Community**: Ralph Discord/Forum

## Advanced Debugging

### Custom Event Logging
```yaml
# Add to hat instructions
instructions: |
  # Debug logging
  Publish debug.info with step information

  # Your normal instructions...
  analyze_code()

  Publish debug.info when complete
```

### Manual Event Emission
**Note**: For debugging only - normal workflows use clean publishes. This is an exception, not the rule.

For proper workflow creation, see [prompt-engineering.md](prompt-engineering.md#v2-architecture-event-data-handling-patterns) for clean publishes pattern guidance.

When debugging, use Ralph's event commands:
```bash
# Emit event manually (debugging only)
ralph events emit custom.event --data '{"key": "value"}'
```

### Inspect State
```bash
# Check Ralph's understanding
cat .agent/scratchpad.md

# View last N events
ralph events list --last 50

# Count events by type
ralph events list | jq -r '.topic' | sort | uniq -c
```

Remember: Backpressure is intentional. Don't "work around" quality gate rejections. Fix the code that fails tests/lint/typecheck. Ralph enforces reliability through backpressure.
