# Syntax Examples Reference

Detailed syntax examples for Ralph CLI commands.

## ralph run Examples

### Basic Execution
```bash
# Run with default configuration
ralph run

# Run from specific directory
ralph run -c /path/to/ralph.yml

# Run with verbose output
ralph run -v

# Run without TUI
ralph run --no-tui
```

### Prompt Injection
```bash
# Inline prompt
ralph run -p "Build user authentication system"

# From file
ralph run -P PROMPT.md

# With custom prompt and recording
ralph run -p "Debug the login issue" --record-session .ralph/debug-session.jsonl
```

### Session Recording
```bash
# Record to file
ralph run --record-session session.jsonl

# Resume from checkpoint with recording
ralph run --continue --record-session .ralph/resume-session.jsonl

# Autonomous mode with recording
ralph run --autonomous --record-session .ralph/autonomous-session.jsonl
```

### Advanced Options
```bash
# Custom backend
ralph run --backend gemini

# Limited iterations
ralph run --max-iterations 50

# Custom completion promise
ralph run --completion-promise "BUILD_COMPLETE"

# Idle timeout
ralph run --idle-timeout 60
```

## ralph events Examples

### Basic Event Viewing
```bash
# Show last 10 events
ralph events --last 10

# Show all events in JSON format
ralph events --format json

# Clear event history
ralph events --clear
```

### Event Filtering
```bash
# Filter by topic
ralph events --topic "test.passed"

# Filter by iteration
ralph events --iteration 15

# Filter by topic and iteration
ralph events --topic "execution" --iteration 10

# Show last 5 test events
ralph events --last 5 --topic "test"
```

### JSON Parsing
```bash
# Extract topics
ralph events --format json | jq -r '.[].topic'

# Count events by iteration
ralph events --format json | jq -r '.[].iteration' | sort | uniq -c

# Find failed tests
ralph events --format json | jq '.[] | select(.topic == "test.failed")'

# Show event timeline
ralph events --format json | jq -r '.[] | "\(.timestamp): \(.topic)"'
```

## ralph init Examples

### Preset Initialization
```bash
# List all presets
ralph init --list-presets

# Initialize feature preset
ralph init --preset feature

# Initialize with backend
ralph init --preset debug --backend claude

# Force overwrite
ralph init --preset feature --force
```

### Custom Configuration
```bash
# Initialize with custom config file
ralph init -c custom-ralph.yml --preset feature

# Initialize with backend override
ralph init --preset refactor --backend gemini
```

## ralph tools memory Examples

### Adding Memories
```bash
# Simple memory
ralph tools memory add "pattern: API uses kebab-case"

# With type and tags
ralph tools memory add "decision: Chose PostgreSQL for concurrent writes" -t decision --tags database,architecture

# Quiet output
ralph tools memory add "fix: ECONNREFUSED means run docker-compose up" -t fix --tags docker --format quiet
```

### Searching Memories
```bash
# Search by content
ralph tools memory search "api"

# Search by type
ralph tools memory search -t pattern

# Search by tags
ralph tools memory search --tags api,auth

# Search with all results
ralph tools memory search --tags pattern --all

# JSON output
ralph tools memory search "database" --format json
```

### Managing Memories
```bash
# List all memories
ralph tools memory list

# List last 10
ralph tools memory list --last 10

# List by type
ralph tools memory list -t fix

# Show specific memory
ralph tools memory show mem-1737372000-a1b2

# Delete memory
ralph tools memory delete mem-1737372000-a1b2

# Prime for context
ralph tools memory prime --budget 2000

# Prime with filters
ralph tools memory prime -t pattern --tags api --recent 7
```

## ralph tools task Examples

### Creating Tasks
```bash
# Simple task
ralph tools task add "Implement authentication"

# With priority
ralph tools task add "Add tests" -p 1

# With description
ralph tools task add "Fix bug" -d "Login fails with special chars" -p 1

# With dependencies
ralph tools task add "Add tests" --blocked-by task-abc123
```

### Managing Tasks
```bash
# List all tasks
ralph tools task list

# List by status
ralph tools task list -s open

# Show ready tasks
ralph tools task ready

# Show specific task
ralph tools task show task-abc123

# Close task
ralph tools task close task-abc123

# JSON output
ralph tools task list --format json
```

## ralph loops Examples

### Loop Management
```bash
# List all loops
ralph loops list

# View logs
ralph loops logs ralph-20250126-a3f2

# Follow logs
ralph loops logs a3f2 -f

# Show history
ralph loops history ralph-20250126-a3f2

# Show diff
ralph loops diff ralph-20250126-a3f2
```

### Loop Operations
```bash
# Merge completed loop
ralph loops merge ralph-20250126-a3f2

# Force merge
ralph loops merge ralph-20250126-a3f2 --force

# Discard loop
ralph loops discard ralph-20250126-a3f2 -y

# Stop loop
ralph loops stop ralph-20250126-a3f2

# Stop with force
ralph loops stop ralph-20250126-a3f2 --force

# Retry merge
ralph loops retry ralph-20250126-a3f2

# Attach to worktree
ralph loops attach ralph-20250126-a3f2

# Prune stale loops
ralph loops prune
```

## ralph emit Examples

### Simple Events
```bash
# Emit string event
ralph emit "build.done" "status: success"

# Emit with topic
ralph emit "test.passed" "tests: 15, passed: 15"

# Emit empty payload
ralph emit "workflow.complete"
```

### JSON Events
```bash
# Emit JSON payload
ralph emit "test.results" -j '{"tests": 15, "passed": 12, "failed": 3}'

# Emit with custom timestamp
ralph emit "deployment.complete" --ts 2026-01-26T10:00:00Z

# Emit to custom file
ralph emit "custom.event" "data" --file /path/to/events.jsonl
```

## Other Commands

### ralph plan
```bash
# Start planning session
ralph plan "Build REST API for user management"

# With backend
ralph plan --backend gemini "Design database schema"

# With custom backend
ralph plan "Multi-step refactor" -- /custom/backend --option value
```

### ralph code-task
```bash
# Generate from description
ralph code-task "Implement JWT authentication"

# Generate from plan file
ralph code-task specs/plan.md

# With backend
ralph task --backend gemini "Design caching layer"
```

### ralph clean
```bash
# Preview cleanup
ralph clean --dry-run

# Clean .agent directory
ralph clean

# Clean diagnostics
ralph clean --diagnostics
```

## Chaining Commands

### Complete Workflow
```bash
# Initialize
ralph init --preset feature

# Create prompt
cat > PROMPT.md <<EOF
Build user authentication system
EOF

# Run with recording
ralph run --record-session .ralph/session.jsonl

# Check events
ralph events --last 20

# Check tasks
ralph tools task ready

# List memories
ralph tools memory list
```

### Monitoring Workflow
```bash
# Terminal 1: Run
ralph run --record-session .ralph/session.jsonl

# Terminal 2: Monitor events
watch -n 5 'ralph events --last 10'

# Terminal 3: Monitor tasks
watch -n 5 'ralph tools task ready'
```

### Debugging Workflow
```bash
# Run with recording
ralph run --record-session .ralph/debug-session.jsonl

# Check for errors
cat .ralph/debug-session.jsonl | jq -s 'map(select(.type == "error"))'

# Check events
ralph events --last 20 --format json

# Clear and retry
ralph events --clear
ralph run --continue
```
