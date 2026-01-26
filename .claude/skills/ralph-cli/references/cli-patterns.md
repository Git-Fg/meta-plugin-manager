# CLI Patterns Reference

Common CLI usage patterns and workflows for Ralph.

## Initialization Patterns

### Pattern 1: Quick Start

```bash
# List available presets
ralph init --list-presets

# Initialize from preset
ralph init --preset feature

# Run immediately
ralph run
```

**Use when:** Standard feature development with proven patterns.

### Pattern 2: Backend-Specific Setup

```bash
# Initialize with specific backend
ralph init --preset debug --backend gemini

# Verify backend
ralph run --dry-run
```

**Use when:** Need specific model capabilities (e.g., Gemini for research).

### Pattern 3: Custom Configuration

```bash
# Initialize with force overwrite
ralph init --preset feature --force

# Edit configuration
vim ralph.yml

# Validate configuration
ralph run --dry-run
```

**Use when:** Customizing preset for specific needs.

## Execution Patterns

### Pattern 4: Standard Run

```bash
# Run with TUI
ralph run

# Or run in background
ralph run --no-tui
```

**Use when:** Normal orchestration with visual feedback.

### Pattern 5: Session Recording

```bash
# Record for debugging
ralph run --record-session .ralph/session.jsonl

# Parse session later
cat .ralph/session.jsonl | jq -s 'map(select(.type == "tool_use"))'
```

**Use when:** Need to debug or validate execution.

### Pattern 6: Resume Workflow

```bash
# Resume from checkpoint
ralph run --continue

# Resume with recording
ralph run --continue --record-session .ralph/resume-session.jsonl
```

**Use when:** Continuing interrupted workflow.

### Pattern 7: Autonomous Run

```bash
# Headless execution
ralph run --autonomous

# With timeout
ralph run --autonomous --idle-timeout 60
```

**Use when:** CI/CD, automation, or no user interaction available.

## Monitoring Patterns

### Pattern 8: Real-Time Event Monitoring

```bash
# Terminal 1: Run
ralph run --record-session .ralph/session.jsonl

# Terminal 2: Watch events
watch -n 5 'ralph events --last 10'

# Terminal 3: Monitor specific topic
watch -n 5 'ralph events --topic "test.passed" --last 5'
```

**Use when:** Tracking workflow progress in real-time.

### Pattern 9: Event Filtering

```bash
# Show recent events
ralph events --last 20

# Filter by topic
ralph events --topic "execution"

# Filter by iteration
ralph events --iteration 15

# JSON output for parsing
ralph events --format json | jq '.[] | {iteration, topic}'
```

**Use when:** Debugging specific phase or iteration.

### Pattern 10: Loop Monitoring

```bash
# List all loops
ralph loops list

# Monitor specific loop
ralph loops logs ralph-20250126-a3f2 -f

# Check loop history
ralph loops history ralph-20250126-a3f2

# Review changes
ralph loops diff ralph-20250126-a3f2
```

**Use when:** Managing parallel loop workflows.

## Task Management Patterns

### Pattern 11: Task Workflow

```bash
# Create tasks
ralph tools task add "Implement feature X" -p 1
ralph tools task add "Add tests" -p 2 --blocked-by <task_id>

# Check ready tasks
ralph tools task ready

# Monitor task progress
ralph tools task list -s open

# Close completed tasks
ralph tools task close <task_id>
```

**Use when:** Managing work items during orchestration.

### Pattern 12: Task Dependency Management

```bash
# Create parent task
ralph tools task add "Implement API" -p 1

# Get task ID
PARENT=$(ralph tools task list --format quiet | head -1)

# Create dependent task
ralph tools task add "Test API" -p 2 --blocked-by $PARENT
```

**Use when:** Managing task dependencies.

## Memory Patterns

### Pattern 13: Pattern Discovery

```bash
# Discover pattern
ralph tools memory add "API routes use kebab-case" -t pattern --tags api,routing

# Search patterns
ralph tools memory search -t pattern

# Prime context
ralph tools memory prime -t pattern --tags api --budget 1500
```

**Use when:** Learning and documenting patterns.

### Pattern 14: Fix Documentation

```bash
# Document fix
ralph tools memory add "ECONNREFUSED means run docker-compose up" -t fix --tags docker,postgres

# Search fixes
ralph tools memory search -t fix "postgres"

# Use in troubleshooting
ralph tools memory prime -t fix --budget 1000
```

**Use when:** Recording solutions for recurring problems.

### Pattern 15: Decision Tracking

```bash
# Record decision
ralph tools memory add "Chose PostgreSQL for concurrent writes" -t decision --tags database,architecture

# Search decisions
ralph tools memory search -t decision

# Review before similar decision
ralph tools memory search "database"
```

**Use when:** Tracking architectural decisions.

## Batch Patterns

### Pattern 16: Parallel Execution

```bash
# Start batch
ralph run --no-auto-merge -p "test all components"

# Monitor loops
ralph loops list

# Review and merge
for loop in $(ralph loops list --format quiet); do
  ralph loops diff $loop
  read -p "Merge $loop? " answer
  if [ "$answer" = "y" ]; then
    ralph loops merge $loop
  else
    ralph loops discard $loop -y
  fi
done
```

**Use when:** Testing multiple components in parallel.

### Pattern 17: Loop Lifecycle Management

```bash
# Start multiple loops
ralph run --no-auto-merge -p "test component A" &
ralph run --no-auto-merge -p "test component B" &

# Monitor all
ralph loops list

# Clean up failed loops
ralph loops prune

# Merge successful ones
for loop in $(ralph loops list | grep completed | awk '{print $1}'); do
  ralph loops merge $loop
done
```

**Use when:** Managing multiple parallel workflows.

## Error Handling Patterns

### Pattern 18: Error Recovery

```bash
# Diagnose via events
ralph events --last 20

# Check session for errors
cat .ralph/session.jsonl | jq -s 'map(select(.type == "error"))'

# Clear events
ralph events --clear

# Retry
ralph run --continue
```

**Use when:** Recovering from errors.

### Pattern 19: State Injection

```bash
# Check task queue
ralph tools task list

# Find stuck task
STUCK=$(ralph tools task list --format json | jq -r '.[] | select(.status == "blocked") | .id' | head -1)

# Inject fix
ralph tools task add "Fix: missing dependency" -p 1 --blocked-by $STUCK

# Monitor
ralph tools task ready
```

**Use when:** Injecting fixes without restarting workflow.

### Pattern 20: Cleanup and Restart

```bash
# Clean state
ralph clean --diagnostics

# Fresh start
ralph run --record-session .ralph/fresh-session.jsonl

# Monitor progress
watch -n 10 'ralph events --last 5'
```

**Use when:** Starting from clean state.

## Scripting Patterns

### Pattern 21: Automation Script

```bash
#!/bin/bash
# Auto-run feature development

# Initialize
ralph init --preset feature --force

# Create prompt
cat > PROMPT.md <<EOF
Build user authentication system
EOF

# Run with recording
ralph run --record-session .ralph/automation-session.jsonl

# Check results
if ralph events --last 1 --format json | jq -e '.[] | select(.topic == "LOOP_COMPLETE")' > /dev/null; then
  echo "Workflow completed successfully"
  exit 0
else
  echo "Workflow failed"
  exit 1
fi
```

**Use when:** Automating standard workflows.

### Pattern 22: Monitoring Script

```bash
#!/bin/bash
# Monitor workflow progress

LOOP_ID=$1
if [ -z "$LOOP_ID" ]; then
  LOOP_ID=$(ralph loops list --format quiet | head -1)
fi

echo "Monitoring loop: $LOOP_ID"

while true; do
  STATUS=$(ralph loops list | grep $LOOP_ID | awk '{print $2}')
  echo "[$(date)] Status: $STATUS"

  if [ "$STATUS" = "completed" ]; then
    echo "Loop completed!"
    ralph loops diff $LOOP_ID
    break
  elif [ "$STATUS" = "failed" ]; then
    echo "Loop failed!"
    ralph loops logs $LOOP_ID | tail -20
    break
  fi

  sleep 10
done
```

**Use when:** Automated monitoring of long-running workflows.

### Pattern 23: Health Check Script

```bash
#!/bin/bash
# Check Ralph orchestration health

# Check active loops
ACTIVE=$(ralph loops list --format quiet | wc -l)
echo "Active loops: $ACTIVE"

# Check recent events
RECENT=$(ralph events --last 1 --format json | jq -r '.[0].timestamp')
echo "Last event: $RECENT"

# Check stuck tasks
STUCK=$(ralph tools task list --format json | jq -r '.[] | select(.status == "blocked") | .id')
if [ -n "$STUCK" ]; then
  echo "Stuck tasks: $STUCK"
else
  echo "No stuck tasks"
fi

# Check errors in session
ERRORS=$(cat .ralph/session.jsonl 2>/dev/null | jq -s 'map(select(.type == "error")) | length')
if [ -n "$ERRORS" ] && [ "$ERRORS" -gt 0 ]; then
  echo "Errors in session: $ERRORS"
fi
```

**Use when:** Automated health monitoring.

## Advanced Patterns

### Pattern 24: Multi-Backend Workflow

```bash
# Design phase with Gemini
ralph init --preset design --backend gemini
ralph run -p "Design API schema"

# Implementation with Claude
ralph init --preset feature --backend claude
ralph run -p "Implement API based on schema"

# Review with fresh model
ralph init --preset review --backend gemini
ralph run -p "Review API implementation"
```

**Use when:** Leveraging different model strengths.

### Pattern 25: Checkpoint Management

```bash
# Create checkpoint
ralph run --record-session .ralph/checkpoint-1.jsonl

# Checkpoint at milestone
ralph emit "milestone.reached" "phase: design complete"

# Resume from checkpoint
ralph run --continue --record-session .ralph/checkpoint-2.jsonl

# Merge checkpoints
cat .ralph/checkpoint-*.jsonl > .ralph/full-session.jsonl
```

**Use when:** Managing workflow checkpoints.

### Pattern 26: Context Priming

```bash
# Prime with relevant memories
ralph tools memory prime -t pattern --tags api --budget 1500

# Run with primed context
ralph run -p "Implement API following patterns"

# Record session for learning
ralph run --record-session .ralph/session.jsonl

# Extract new patterns
cat .ralph/session.jsonl | jq -s 'map(select(.type == "message")) | .[] | select(.content | contains("pattern"))'
```

**Use when:** Leveraging accumulated knowledge.

## Pattern Selection Guide

| Need | Pattern | Commands |
|------|---------|----------|
| Quick start | Pattern 1 | `ralph init --preset feature` |
| Debug execution | Pattern 5 | `ralph run --record-session` |
| Resume workflow | Pattern 6 | `ralph run --continue` |
| Monitor progress | Pattern 8 | `watch ralph events` |
| Manage tasks | Pattern 11 | `ralph tools task` |
| Document learnings | Pattern 13 | `ralph tools memory add` |
| Parallel testing | Pattern 16 | `ralph run --no-auto-merge` |
| Error recovery | Pattern 18 | `ralph events` + `ralph run --continue` |
| Automation | Pattern 21 | Shell script with Ralph commands |
| Health check | Pattern 23 | Script to check status |

## Best Practices

1. **Always use session recording** for debugging
2. **Monitor events** during long-running workflows
3. **Document patterns** with memory system
4. **Use task management** for complex workflows
5. **Leverage parallel loops** for batch processing
6. **Clear state** before fresh starts
7. **Validate configuration** with `--dry-run`
8. **Save logs** for later analysis
9. **Use appropriate backends** for different phases
10. **Script common workflows** for automation
