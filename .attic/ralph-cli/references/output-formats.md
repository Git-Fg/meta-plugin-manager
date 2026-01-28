# Output Formats Reference

Complete reference for output formats in Ralph CLI commands.

## Format Types

Ralph CLI supports multiple output formats for different use cases:

| Format | Description | Use Case |
|--------|-------------|----------|
| `table` | Human-readable table | Default display |
| `json` | Structured JSON | Programmatic access |
| `quiet` | Minimal output | Scripting, automation |
| `markdown` | Markdown formatted | Documentation |

## Table Format (Default)

Human-readable table format with headers and alignment.

**Example - ralph events:**
```
ITERATION  TOPIC              TIMESTAMP               DATA
15         test.passed        2026-01-26T10:15:23Z   tests: 15, passed: 15
14         execution.ready     2026-01-26T10:14:45Z   implementation: complete
```

**Example - ralph tools task list:**
```
TASK_ID            STATUS        TITLE                         PRIORITY
task-abc123        open          Implement auth                 1
task-def456        in_progress   Add tests                     2
task-ghi789        closed        Initial setup                 3
```

**Example - ralph tools memory list:**
```
ID                  TYPE        CONTENT                              TAGS
mem-123             pattern     API uses kebab-case               api,routing
mem-456             decision    Chose PostgreSQL                 database
mem-789             fix         ECONNREFUSED = run docker        docker
```

## JSON Format

Structured JSON output for programmatic access.

### ralph events --format json

**Structure:**
```json
[
  {
    "iteration": 15,
    "topic": "test.passed",
    "timestamp": "2026-01-26T10:15:23Z",
    "data": "tests: 15, passed: 15"
  },
  {
    "iteration": 14,
    "topic": "execution.ready",
    "timestamp": "2026-01-26T10:14:45Z",
    "data": "implementation: complete"
  }
]
```

**Example queries:**
```bash
# Extract topics
ralph events --format json | jq -r '.[].topic'

# Count events
ralph events --format json | jq 'length'

# Filter by topic
ralph events --format json | jq '.[] | select(.topic == "test.passed")'

# Extract iteration numbers
ralph events --format json | jq -r '.[].iteration'

# Find events after iteration 10
ralph events --format json | jq '.[] | select(.iteration > 10)'

# Show timeline
ralph events --format json | jq -r '.[] | "\(.timestamp): \(.topic)"'
```

### ralph tools task --format json

**Structure:**
```json
[
  {
    "id": "task-abc123",
    "title": "Implement auth",
    "status": "open",
    "priority": 1,
    "description": null,
    "blocked_by": []
  },
  {
    "id": "task-def456",
    "title": "Add tests",
    "status": "in_progress",
    "priority": 2,
    "description": "Add unit tests for auth module",
    "blocked_by": ["task-abc123"]
  }
]
```

**Example queries:**
```bash
# List open tasks
ralph tools task list --format json | jq '.[] | select(.status == "open")'

# Count tasks by status
ralph tools task list --format json | jq 'group_by(.status) | map({status: .[0].status, count: length})'

# Show task titles
ralph tools task list --format json | jq -r '.[].title'

# Find blocked tasks
ralph tools task list --format json | jq '.[] | select(.blocked_by | length > 0)'
```

### ralph tools memory --format json

**Structure:**
```json
[
  {
    "id": "mem-123",
    "type": "pattern",
    "content": "API uses kebab-case",
    "tags": ["api", "routing"],
    "timestamp": "2026-01-26T09:00:00Z"
  },
  {
    "id": "mem-456",
    "type": "decision",
    "content": "Chose PostgreSQL for concurrent writes",
    "tags": ["database", "architecture"],
    "timestamp": "2026-01-25T15:30:00Z"
  }
]
```

**Example queries:**
```bash
# List patterns only
ralph tools memory list --format json | jq '.[] | select(.type == "pattern")'

# Find by tag
ralph tools memory list --format json | jq '.[] | select(.tags[] == "api")'

# Extract content
ralph tools memory list --format json | jq -r '.[].content'

# Count by type
ralph tools memory list --format json | jq 'group_by(.type) | map({type: .[0].type, count: length})'
```

## Quiet Format

Minimal output for scripting and automation.

### ralph tools task list --format quiet

**Output:**
```
task-abc123
task-def456
task-ghi789
```

**Example - Check if tasks exist:**
```bash
#!/bin/bash
TASKS=$(ralph tools task list -s open --format quiet)
if [ -z "$TASKS" ]; then
  echo "No open tasks"
else
  echo "Open tasks found"
fi
```

**Example - Loop through tasks:**
```bash
for task in $(ralph tools task list -s open --format quiet); do
  echo "Processing task: $task"
  ralph tools task show $task --format json
done
```

### ralph tools memory list --format quiet

**Output:**
```
mem-123
mem-456
mem-789
```

**Example - Delete all fix memories:**
```bash
for mem in $(ralph tools memory list -t fix --format quiet); do
  ralph tools memory delete $mem
done
```

### ralph loops list --format quiet

**Output:**
```
ralph-0126-a3f2
ralph-0126-cd34
ralph-0126-ef56
```

**Example - Monitor all loops:**
```bash
for loop in $(ralph loops list --format quiet); do
  echo "Checking loop: $loop"
  ralph loops history $loop --json | jq '.[-1].topic'
done
```

## Markdown Format

Markdown formatted output for documentation.

### ralph tools memory prime --format markdown

**Output:**
```markdown
# Memory Context

## Patterns
- API uses kebab-case
- Authentication uses JWT tokens

## Decisions
- Chose PostgreSQL for concurrent writes
- Used REST over GraphQL for simplicity

## Fixes
- ECONNREFUSED means run docker-compose up
- npm install fails = clear cache and reinstall
```

**Use case:** Generate documentation from memories.

### Custom Commands

Some commands support specific format options:

```bash
# Events as markdown table
ralph events --format json | jq -r '
  ["Iteration", "Topic", "Timestamp", "Data"],
  ["---------", "-----", "---------", "----"],
  (.[] | [.iteration, .topic, .timestamp, .data])
  | @tsv
' | column -t -s $'\t'
```

## Parsing Examples

### Bash Parsing

```bash
# Extract task IDs
ralph tools task list --format json | jq -r '.[].id'

# Count events
ralph events --format json | jq 'length'

# Check if task exists
if ralph tools task list --format quiet | grep -q "task-abc123"; then
  echo "Task exists"
fi

# Get latest event topic
LATEST=$(ralph events --last 1 --format json | jq -r '.[0].topic')
echo "Latest event: $LATEST"
```

### Python Parsing

```python
import subprocess
import json

# Get events
result = subprocess.run(
    ['ralph', 'events', '--format', 'json'],
    capture_output=True,
    text=True
)
events = json.loads(result.stdout)

# Process events
for event in events:
    if event['topic'] == 'test.passed':
        print(f"Tests passed in iteration {event['iteration']}")
```

### jq Advanced Examples

```bash
# Group events by topic
ralph events --format json | jq 'group_by(.topic) | map({topic: .[0].topic, count: length})'

# Find events with specific data
ralph events --format json | jq '.[] | select(.data | contains("error"))'

# Calculate event rate
ralph events --format json | jq 'length / (now - .[0].timestamp | fromdateiso8601)'

# Extract unique topics
ralph events --format json | jq '[.[].topic] | unique'

# Find longest running iteration
ralph events --format json | jq 'group_by(.iteration) | max_by(length) | .[0].iteration'
```

## Output Redirection

### Save to File

```bash
# Save events to file
ralph events --format json > events.json

# Save tasks to CSV
ralph tools task list --format json | jq -r '
  ["ID", "Status", "Title", "Priority"],
  (.[] | [.id, .status, .title, .priority]),
  (@csv)
' > tasks.csv

# Save memories as markdown
ralph tools memory list --format json | jq -r '
  [.[] | "- " + .type + ": " + .content]
' > memories.md
```

### Pipe to Other Tools

```bash
# Count events
ralph events --format json | jq 'length'

# Filter with grep
ralph events --format json | jq -r '.[].topic' | grep "test"

# Sort topics
ralph events --format json | jq -r '.[].topic' | sort | uniq -c

# Monitor in real-time
watch -n 1 'ralph events --last 1 --format json | jq -r "Latest: \(.[0].topic)"'
```

## Format Selection Guidelines

### Use Table Format When:
- Interactive terminal use
- Human readability needed
- Quick status checks

### Use JSON Format When:
- Parsing in scripts
- Data transformation needed
- Integration with other tools
- Complex queries required

### Use Quiet Format When:
- Simple scripting
- Checking existence
- Looping through IDs
- Automation workflows

### Use Markdown Format When:
- Generating documentation
- Creating reports
- Documentation files
- Knowledge bases

## Error Handling

### Check Exit Codes

```bash
# Check command success
ralph events --format json > events.json
if [ $? -eq 0 ]; then
  echo "Success"
else
  echo "Failed"
fi

# Handle empty results
TASKS=$(ralph tools task list --format quiet)
if [ -z "$TASKS" ]; then
  echo "No tasks found"
fi
```

### Validate JSON Output

```bash
# Validate JSON
ralph events --format json | jq . > /dev/null
if [ $? -eq 0 ]; then
  echo "Valid JSON"
fi

# Check for errors in JSON
ralph events --format json | jq -e '.[].error' > /dev/null
if [ $? -eq 0 ]; then
  echo "Errors found"
fi
```
