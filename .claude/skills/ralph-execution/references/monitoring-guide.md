# Ralph CLI: Event-Driven Monitoring Guide

Complete guide to monitoring Ralph orchestrations using events, session recording, and state inspection.

## Monitoring Overview

| Monitoring Type | Tool | Use Case |
|----------------|------|----------|
| **Real-time Events** | `ralph events --topic` | Phase-specific tracking |
| **Session Recording** | `--record-session` | Parseable telemetry |
| **State Inspection** | `ralph tools task/memory` | Queue/memory state |
| **Loop Monitoring** | `ralph loops` | Parallel execution |
| **Log Parsing** | `jq`, `grep` | Validation and debugging |

## Event-Driven Monitoring

### Understanding Ralph Events

Ralph publishes events for every state transition. Each event has:
- **Topic**: Event category (e.g., `workflow.start`, `test.passed`)
- **Data**: Event payload (JSON or string)
- **Iteration**: Loop iteration number
- **Timestamp**: When event occurred

### Event Topic Patterns

| Pattern | Purpose | Examples |
|---------|---------|----------|
| `workflow.*` | Workflow lifecycle | `workflow.start`, `workflow.complete` |
| `design.*` | Design phase | `design.tests`, `design.specs` |
| `execution.*` | Execution phase | `execution.ready`, `execution.done` |
| `test.*` | Test results | `test.passed`, `test.failed` |
| `confession.*` | Validation issues | `confession.clean`, `confession.issues_found` |
| `LOOP_COMPLETE` | Workflow completion | Final completion event |

### Phase-Specific Monitoring

```bash
# Monitor design phase
ralph events --topic "design" --last 20

# Monitor execution phase
ralph events --topic "execution" --last 20

# Monitor validation phase
ralph events --topic "confession" --last 20

# Monitor test results
ralph events --topic "test.passed" --last 10
ralph events --topic "test.failed" --last 10

# Export phase events for analysis
ralph events --topic "execution" --format json > execution-events.json
```

### Iteration-Level Debugging

```bash
# What happened in specific iteration?
ralph events --iteration 15

# Track hat switching over time
ralph events --format json | jq '.[] | {iteration, topic}'

# Find same-iteration switching (BAD)
ralph events --format json | jq -r '.iteration' | sort | uniq -c | grep -v '^ *1'

# Count events per iteration
ralph events --format json | jq -r '.iteration' | sort | uniq -c
```

**Expected pattern**: 1 event per iteration (iterations ≈ events)
**Bad pattern**: 2-3 iterations but 5+ events (same-iteration switching)

### Event Flow Validation

```bash
# Check complete event chain
ralph events --format json | jq -r '.topic' | sort -u

# Should show:
# workflow.start
# design.tests
# tests.designed
# execution.ready
# test.passed
# LOOP_COMPLETE

# Find missing events in chain
ralph events --format json | jq -r '.topic' | sort > /tmp/actual.txt
cat <<'EOF' > /tmp/expected.txt
workflow.start
design.tests
tests.designed
execution.ready
test.passed
LOOP_COMPLETE
EOF
diff /tmp/expected.txt /tmp/actual.txt
```

### Real-Time Event Monitoring

```bash
# Terminal 1: Run Ralph
ralph run --record-session .ralph/session.jsonl

# Terminal 2: Watch events
watch -n 5 'ralph events --last 10'

# Terminal 3: Watch specific topic
watch -n 5 'ralph events --topic "execution" --last 5'

# Terminal 4: Count events
watch -n 5 'ralph events --format json | jq -s | length'
```

## Session Recording Monitoring

### Understanding Session Format

Session recording produces JSONL with structured telemetry:

```json
{"type":"message","content":"Starting orchestration...","timestamp":"..."}
{"type":"tool_use","tool":"Read","input":{"file_path":"..."},"timestamp":"..."}
{"type":"error","error":"File not found","timestamp":"..."}
```

### Session Parsing Commands

```bash
# Check component loaded
cat .ralph/session.jsonl | jq -r '.content' | grep -iE "skill|command|agent"

# Count tool usage
cat .ralph/session.jsonl | jq -s 'map(select(.type == "tool_use")) | length'

# Find errors
cat .ralph/session.jsonl | jq -s 'map(select(.type == "error"))'

# Extract specific tool usage
cat .ralph/session.jsonl | jq -s 'map(select(.type == "tool_use" and .tool == "Write"))'

# Timeline of events
cat .ralph/session.jsonl | jq -s 'map({type, timestamp}) | .[0:10]'
```

### Log-First Validation

**CRITICAL**: Always parse session before claiming success.

```bash
# Validation checklist
# 1. Component loaded
cat .ralph/session.jsonl | jq -r '.content' | grep -i "skill-name" | head -1

# 2. Tools used (not 0)
cat .ralph/session.jsonl | jq -s 'map(select(.type == "tool_use")) | length'

# 3. No errors
cat .ralph/session.jsonl | jq -s 'map(select(.type == "error")) | length'

# 4. Completion event
ralph events --last 5 | grep "LOOP_COMPLETE"
```

### Session Replay for Debugging

```bash
# Record session
ralph run --record-session .ralph/session.jsonl

# Analyze session
cat .ralph/session.jsonl | jq -s 'map(select(.type == "tool_use")) | .[0:5]'

# Compare sessions
diff <(cat session1.jsonl | jq -s 'map(select(.type == "tool_use"))') \
     <(cat session2.jsonl | jq -s 'map(select(.type == "tool_use"))')
```

## State Inspection Monitoring

### Task Queue Monitoring

```bash
# List all tasks
ralph tools task list

# Show ready tasks (unblocked)
ralph tools task ready

# Show blocked tasks
ralph tools task list | grep blocked

# Show task hierarchy
ralph tools task list --format json | jq '.[] | {id, title, blocked_by}'
```

### Memory State Monitoring

```bash
# List all memories
ralph tools memory list

# Show recent memories
ralph tools memory list --last 10

# Search by type
ralph tools memory list -t pattern

# Search by tags
ralph tools memory search --tags api,auth

# Prime context (what would be injected)
ralph tools memory prime --budget 2000
```

## Parallel Loop Monitoring

### Loop Lifecycle Monitoring

```bash
# List all loops
ralph loops list

# Output:
# LOOP_ID              STATUS      WORKTREE
# ralph-0126-ab12       running     /path/to/.git/worktrees/ralph-0126-ab12
# ralph-0126-cd34       completed   /path/to/.git/worktrees/ralph-0126-cd34
# ralph-0126-ef56       failed      /path/to/.git/worktrees/ralph-0126-ef56

# Monitor running loop
ralph loops logs ralph-0126-ab12 -f

# Check loop history
ralph loops history ralph-0126-ab12

# Review changes before merge
ralph loops diff ralph-0126-ab12
```

### Loop Event Monitoring

```bash
# Events for specific loop
ralph loops history ralph-0126-ab12 --json

# Filter loop events by topic
ralph loops history ralph-0126-ab12 --json | jq '.[] | select(.topic | contains("test"))'

# Count loop iterations
ralph loops history ralph-0126-ab12 --json | jq -s 'map(select(.topic == "_meta.loop_start")) | length'
```

## Monitoring Patterns by Workflow Type

### Simple Workflow Monitoring

**For**: feature-minimal, docs, simple refactor

```bash
# Run with recording
ralph run --record-session .ralph/session.jsonl

# Monitor events periodically
watch -n 10 'ralph events --last 5'

# Validate on completion
cat .ralph/session.jsonl | jq -s 'map(select(.type == "tool_use")) | length'
```

### Complex Workflow Monitoring

**For**: confession-loop, adversarial-review, mob-programming

```bash
# Terminal 1: Run with recording
ralph run --record-session .ralph/session.jsonl

# Terminal 2: Monitor by phase
watch -n 5 'ralph events --topic "confession" --last 5'

# Terminal 3: Monitor state
watch -n 5 'ralph tools task ready'

# Terminal 4: Monitor memories (for confessions)
watch -n 10 'ralph tools memory search --tags confession --format quiet | wc -l'
```

### Batch Workflow Monitoring

**For**: Testing multiple components in parallel

```bash
# Start batch run
ralph run --no-auto-merge -p "test all components"

# Monitor all loops
ralph loops list

# Monitor specific loop
ralph loops logs <LOOP_ID> -f

# Review and merge
for loop in $(ralph loops list | grep completed | awk '{print $1}'); do
  ralph loops diff $loop
  ralph loops merge $loop
done
```

## Troubleshooting via Monitoring

### Deadlock Detection

```bash
# Symptoms: Active iteration but no new events

# 1. Check iteration count
grep -c "ITERATION" .ralph/events.jsonl

# 2. Check last event time
ralph events --last 1 --format json | jq '.[0].timestamp'

# 3. Check if iteration is active
ralph events --last 5 | grep "_meta.loop_start"

# 4. Check task queue for stuck task
ralph tools task list | grep "in_progress"
```

### Same-Iteration Switching Detection

```bash
# Symptoms: Multiple hats activate in same iteration

# 1. Count iterations vs events
ITERATIONS=$(grep -c "_meta.loop_start\|ITERATION" .ralph/events.jsonl)
EVENTS=$(grep -c "bus.publish" .ralph/events.jsonl)

echo "Iterations: $ITERATIONS"
echo "Events: $EVENTS"

# 2. Find problematic iterations
ralph events --format json | jq -r '.iteration' | sort | uniq -c | grep -v '^ *1'

# 3. Investigate specific iteration
ralph events --iteration 15
```

### Component Loading Failure Detection

```bash
# Symptoms: Component never executes

# 1. Parse session for component
cat .ralph/session.jsonl | jq -r '.content' | grep -iE "skill|command|agent"

# 2. Check for error messages
cat .ralph/session.jsonl | jq -s 'map(select(.type == "error"))'

# 3. Verify component file exists
cat .claude/skills/skill-name/SKILL.md | head -5

# 4. Check for loading errors in events
ralph events --format json | jq '.[] | select(.data | test("not found|no such"))'
```

## Monitoring Quick Reference

| Monitoring Need | Command |
|-----------------|---------|
| Recent events | `ralph events --last 20` |
| Phase monitoring | `ralph events --topic "<phase>"` |
| Iteration debug | `ralph events --iteration <N>` |
| Component loaded | `cat .ralph/session.jsonl \| jq -r '.content' \| grep -iE "skill\|command\|agent"` |
| Tool count | `cat .ralph/session.jsonl \| jq -s 'map(select(.type == "tool_use")) \| length'` |
| Task queue | `ralph tools task ready` |
| Confession search | `ralph tools memory search --tags confession` |
| Loop status | `ralph loops list` |
| Loop logs | `ralph loops logs <LOOP_ID>` |
| Loop diff | `ralph loops diff <LOOP_ID>` |

## Best Practices

### 1. Always Use Session Recording

```bash
# Good: Record for validation
ralph run --record-session .ralph/session.jsonl

# Bad: No recording, can't validate
ralph run
```

### 2. Monitor by Phase, Not Just Events

```bash
# Good: Phase-specific monitoring
ralph events --topic "design"
ralph events --topic "execution"

# Less useful: All events mixed
ralph events --last 50
```

### 3. Parse Before Claiming

```bash
# Good: Validate via parsing
cat .ralph/session.jsonl | jq -s 'map(select(.type == "tool_use")) | length'

# Bad: Claim success without evidence
# "The workflow completed successfully" (how do you know?)
```

### 4. Use JSON Output for Scripting

```bash
# Good: Parseable JSON
ralph events --format json | jq '.[] | select(.topic == "test.passed")'

# Bad: Parse text table
ralph events | grep "test.passed"
```

### 5. Monitor Multiple Aspects

```bash
# Comprehensive monitoring:
# - Events (workflow progress)
# - Session (tool usage, errors)
# - Tasks (queue state)
# - Memories (accumulated learning)

# Terminal 1: Events
watch -n 5 'ralph events --last 10'

# Terminal 2: Tasks
watch -n 5 'ralph tools task ready'

# Terminal 3: Session growth
watch -n 5 'wc -l .ralph/session.jsonl'
```
