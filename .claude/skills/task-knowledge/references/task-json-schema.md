# Task JSON Schema Reference

Complete guide to TaskList task file structure, JSON schema, and file management operations.

## Overview

Tasks are stored as JSON files in `~/.claude/tasks/[task-list-id]/tasks/`. This file-based storage enables inspection, backup, manual editing, and external tooling integration.

## Directory Structure

### Task List Location

```
~/.claude/tasks/
└── [task-list-id]/
    └── tasks/
        ├── [task-id-1].json
        ├── [task-id-2].json
        ├── [task-id-3].json
        └── ...
```

### Example Structure

```
~/.claude/tasks/
└── my-project/
    └── tasks/
        ├── task-abc123.json
        ├── task-def456.json
        ├── task-ghi789.json
        └── task-jkl012.json
```

## JSON Schema

### Complete Task Schema

```json
{
  "taskId": "string (unique identifier)",
  "subject": "string (task title)",
  "description": "string (detailed task description)",
  "status": "pending|in_progress|completed",
  "activeForm": "string (progress display format)",
  "blockedBy": ["array of task IDs blocking this task"],
  "owner": "string|null (agent or session owning this task)",
  "createdAt": "ISO 8601 timestamp",
  "completedAt": "ISO 8601 timestamp|null",
  "metadata": {
    "priority": "number|null (1-10, optional)",
    "tags": ["array of strings (optional)"],
    "estimatedTime": "string|null (optional)",
    "actualTime": "string|null (optional)"
  }
}
```

### Field Descriptions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `taskId` | string | Yes | Unique task identifier |
| `subject` | string | Yes | Task title (short, descriptive) |
| `description` | string | Yes | Detailed task description |
| `status` | string | Yes | Current status: pending, in_progress, completed |
| `activeForm` | string | Yes | Progress display format ([Verb-ing] [object]) |
| `blockedBy` | array | Yes | List of task IDs that block this task |
| `owner` | string/null | Yes | Session or agent owning this task |
| `createdAt` | string | Yes | ISO 8601 creation timestamp |
| `completedAt` | string/null | No | ISO 8601 completion timestamp (null if not complete) |
| `metadata` | object | No | Optional metadata (priority, tags, time estimates) |

### Status Values

| Status | Meaning | When to Use |
|--------|---------|-------------|
| `pending` | Not started, may be blocked | Initial state, or waiting for dependencies |
| `in_progress` | Currently being worked on | Task claimed and actively executing |
| `completed` | Finished successfully | Task completed, ready for dependents |

### Metadata Schema

```json
{
  "priority": 1-10,
  "tags": ["tag1", "tag2", "tag3"],
  "estimatedTime": "2h",
  "actualTime": "1.5h"
}
```

**Priority Guidelines**:
- 1-3: Low priority (nice to have)
- 4-7: Medium priority (standard tasks)
- 8-10: High priority (critical, blocking)

## Example Task Files

### Example 1: Simple Pending Task

```json
{
  "taskId": "task-abc123",
  "subject": "Scan project structure",
  "description": "Analyze and document the project directory structure, identify main components and their relationships.",
  "status": "pending",
  "activeForm": "Scanning project structure",
  "blockedBy": [],
  "owner": null,
  "createdAt": "2026-01-23T10:00:00Z",
  "completedAt": null,
  "metadata": {
    "priority": 5,
    "tags": ["analysis", "documentation"]
  }
}
```

### Example 2: In-Progress Task with Dependencies

```json
{
  "taskId": "task-def456",
  "subject": "Implement authentication system",
  "description": "Build OAuth 2.0 authentication with support for Google and GitHub providers. Session 1 completed login form UI.",
  "status": "in_progress",
  "activeForm": "Implementing OAuth integration",
  "blockedBy": ["task-abc123"],
  "owner": "session-2",
  "createdAt": "2026-01-23T11:00:00Z",
  "completedAt": null,
  "metadata": {
    "priority": 8,
    "tags": ["feature", "security"],
    "estimatedTime": "4h"
  }
}
```

### Example 3: Completed Task

```json
{
  "taskId": "task-ghi789",
  "subject": "Design database schema",
  "description": "Design normalized database schema for user management, including authentication tokens and profile data.",
  "status": "completed",
  "activeForm": "Designing database schema",
  "blockedBy": [],
  "owner": "session-1",
  "createdAt": "2026-01-23T09:00:00Z",
  "completedAt": "2026-01-23T10:30:00Z",
  "metadata": {
    "priority": 9,
    "tags": ["design", "database"],
    "estimatedTime": "2h",
    "actualTime": "1.5h"
  }
}
```

## File Management Operations

### Inspect Tasks

**Read Individual Task**:
```bash
cat ~/.claude/tasks/my-project/tasks/task-abc123.json | jq
```

**List All Tasks**:
```bash
ls ~/.claude/tasks/my-project/tasks/
```

**Read All Tasks**:
```bash
for task in ~/.claude/tasks/my-project/tasks/*.json; do
    cat "$task" | jq
done
```

**Filter by Status**:
```bash
for task in ~/.claude/tasks/my-project/tasks/*.json; do
    status=$(cat "$task" | jq -r '.status')
    if [ "$status" = "pending" ]; then
        echo "$task"
    fi
done
```

### Backup Tasks

**Backup Single Task List**:
```bash
cp -r ~/.claude/tasks/my-project ~/backups/tasks-$(date +%Y%m%d-%H%M%S)
```

**Backup All Task Lists**:
```bash
cp -r ~/.claude/tasks ~/backups/tasks-$(date +%Y%m%d-%H%M%S)
```

**Compressed Backup**:
```bash
tar -czf ~/backups/tasks-$(date +%Y%m%d-%H%M%S).tar.gz ~/.claude/tasks/
```

### Restore Tasks

**Restore from Backup**:
```bash
cp -r ~/backups/tasks-20260123-100000/my-project ~/.claude/tasks/
```

**Restore Compressed Backup**:
```bash
tar -xzf ~/backups/tasks-20260123-100000.tar.gz -C ~/
```

### Version Control

**Add to Git**:
```bash
cd ~/.claude/tasks/my-project
git init
git add tasks/
git commit -m "Initial task state"
```

**Track Changes**:
```bash
git add tasks/
git commit -m "Update task progress"
```

**View History**:
```bash
git log --oneline tasks/
```

**Revert to Previous State**:
```bash
git checkout HEAD~1 tasks/
```

## Manual Editing

### When to Manually Edit

**Valid Use Cases**:
- Correcting typos in task descriptions
- Adding missing metadata
- Updating owner assignment
- Fixing dependency errors
- Template customization

**Risky Use Cases** (avoid if possible):
- Changing task status (use TaskUpdate instead)
- Modifying dependencies (use TaskUpdate instead)
- Creating new tasks (use TaskCreate instead)

### Safe Editing Practices

**Step 1: Backup**
```bash
cp ~/.claude/tasks/my-project/tasks/task-abc123.json ~/.claude/tasks/my-project/tasks/task-abc123.json.bak
```

**Step 2: Edit**
```bash
# Use your preferred editor
vim ~/.claude/tasks/my-project/tasks/task-abc123.json
```

**Step 3: Validate**
```bash
cat ~/.claude/tasks/my-project/tasks/task-abc123.json | jq
```

**Step 4: Test**
```bash
# Start Claude with task list
CLAUDE_CODE_TASK_LIST_ID=my-project claude
# Verify task appears correctly
```

### Common Manual Edits

**Fix Typos in Description**:
```json
Before: "description": "Implment auth system"
After:  "description": "Implement auth system"
```

**Add Missing Tags**:
```json
Before: "metadata": {"priority": 5}
After:  "metadata": {"priority": 5, "tags": ["feature", "security"]}
```

**Update Owner**:
```json
Before: "owner": null
After:  "owner": "session-2"
```

## External Tooling

### Task Statistics

**Count Tasks by Status**:
```bash
for status in pending in_progress completed; do
    count=$(grep -r "\"status\": \"$status\"" ~/.claude/tasks/my-project/tasks/ | wc -l)
    echo "$status: $count"
done
```

**List Blocked Tasks**:
```bash
for task in ~/.claude/tasks/my-project/tasks/*.json; do
    blocked=$(cat "$task" | jq -r '.blockedBy | length')
    if [ "$blocked" -gt 0 ]; then
        subject=$(cat "$task" | jq -r '.subject')
        echo "Blocked: $subject"
    fi
done
```

**Find Unblocked Tasks**:
```bash
for task in ~/.claude/tasks/my-project/tasks/*.json; do
    blocked=$(cat "$task" | jq -r '.blockedBy | length')
    status=$(cat "$task" | jq -r '.status')
    if [ "$blocked" -eq 0 ] && [ "$status" = "pending" ]; then
        subject=$(cat "$task" | jq -r '.subject')
        echo "Ready: $subject"
    fi
done
```

### Task List Export

**Export to Markdown**:
```bash
echo "# Task List: my-project" > tasks.md
for task in ~/.claude/tasks/my-project/tasks/*.json; do
    subject=$(cat "$task" | jq -r '.subject')
    status=$(cat "$task" | jq -r '.status')
    echo "- [$status] $subject" >> tasks.md
done
```

**Export to CSV**:
```bash
echo "Subject,Status,Owner" > tasks.csv
for task in ~/.claude/tasks/my-project/tasks/*.json; do
    subject=$(cat "$task" | jq -r '.subject')
    status=$(cat "$task" | jq -r '.status')
    owner=$(cat "$task" | jq -r '.owner // "unassigned"')
    echo "$subject,$status,$owner" >> tasks.csv
done
```

### Automation Scripts

**Claim Unassigned Tasks**:
```bash
#!/bin/bash
OWNER="session-$(whoami)"
for task in ~/.claude/tasks/my-project/tasks/*.json; do
    current_owner=$(cat "$task" | jq -r '.owner // "null"')
    if [ "$current_owner" = "null" ]; then
        task_id=$(cat "$task" | jq -r '.taskId')
        echo "Claiming $task_id"
        jq --arg owner "$OWNER" '.owner = $owner' "$task" > "$task.tmp"
        mv "$task.tmp" "$task"
    fi
done
```

**Complete Completed Tasks Cleanup**:
```bash
#!/bin/bash
ARCHIVE_DIR=~/.claude/tasks/my-project/archive
mkdir -p "$ARCHIVE_DIR"
for task in ~/.claude/tasks/my-project/tasks/*.json; do
    status=$(cat "$task" | jq -r '.status')
    if [ "$status" = "completed" ]; then
        filename=$(basename "$task")
        echo "Archiving $filename"
        mv "$task" "$ARCHIVE_DIR/$filename"
    fi
done
```

## Task List as API Surface

### Building External Tools

Task JSON files provide API surface for external tools:

**Tool Ideas**:
1. **Task Dashboard**: Web UI showing task progress
2. **Task Analytics**: Statistics and reporting
3. **Task Sync**: Synchronize with external project management tools
4. **Task Notifications**: Alert on task completion
5. **Task Automation**: Custom workflows triggered by task changes

### File Watching

**Watch for Changes**:
```bash
inotifywait -m ~/.claude/tasks/my-project/tasks/ |
    while read path event; do
        echo "Task changed: $path ($event)"
        # Trigger automation
    done
```

**macOS Alternative**:
```bash
fswatch ~/.claude/tasks/my-project/tasks/ |
    while read path; do
        echo "Task changed: $path"
        # Trigger automation
    done
```

## Troubleshooting

### Issue: Task Not Appearing

**Symptoms**: Created task doesn't show in TaskList

**Diagnosis**:
```bash
ls -la ~/.claude/tasks/my-project/tasks/
```

**Solutions**:
1. Verify CLAUDE_CODE_TASK_LIST_ID matches
2. Check JSON syntax: `jq < task.json`
3. Verify required fields present

### Issue: Invalid JSON

**Symptoms**: Task file corrupted or malformed

**Diagnosis**:
```bash
for task in ~/.claude/tasks/my-project/tasks/*.json; do
    jq empty "$task" > /dev/null || echo "Invalid: $task"
done
```

**Solutions**:
1. Restore from backup
2. Fix JSON syntax manually
3. Delete and recreate task

### Issue: Duplicate Task IDs

**Symptoms**: Multiple tasks with same ID

**Diagnosis**:
```bash
for task in ~/.claude/tasks/my-project/tasks/*.json; do
    cat "$task" | jq -r '.taskId'
done | sort | uniq -d
```

**Solutions**:
1. Rename one of the duplicates with new UUID
2. Delete unintended duplicate
3. Merge if appropriate

## Best Practices

### 1. Regular Backups

**Schedule**: Backup task lists before major changes

```bash
# Cron job example
0 * * * * cp -r ~/.claude/tasks ~/backups/tasks-hourly-$(date +\%Y\%m\%d-\%H\%M)
```

### 2. Version Control for Templates

**Use Case**: Track task list templates in git

```bash
# Template directory
~/project-templates/.claude/tasks/
# Add to git for version control
```

### 3. Descriptive Task IDs

**Good**: Task IDs reflect purpose
```json
"taskId": "auth-oauth-google"
```

**Poor**: Random UUIDs
```json
"taskId": "abc123-def456-ghi789"
```

### 4. Consistent Timestamps

**Use**: ISO 8601 format
```json
"createdAt": "2026-01-23T10:00:00Z"
```

**Avoid**: Other formats
```json
"createdAt": "01/23/2026 10:00 AM"
```

## Summary

**Key Concepts**:
1. Tasks stored as JSON in `~/.claude/tasks/[id]/`
2. File-based storage enables inspection, backup, editing
3. Schema supports status, dependencies, ownership, metadata
4. External tools can read/write task files
5. Version control preserves task history

**Operations**:
- **Inspect**: Read individual or all tasks
- **Backup**: Copy task directories
- **Restore**: Copy from backup
- **Edit**: Manual JSON editing with caution
- **Automate**: External tools via file access

**Benefits**:
- Transparency: Inspect task state anytime
- Safety: Backup before changes
- Portability: Copy task lists between projects
- Extensibility: Build custom tools on task JSON
- Debugging: Inspect task state for troubleshooting

**Result**: TaskList as infrastructure, not just feature
