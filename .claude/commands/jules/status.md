---
name: jules:status
description: Quick Jules status check. Lists active sessions, recent completions, and pending reviews. Use for: monitoring Jules activity, checking session progress, quick overview.
argument-hint: [session-id or omit for all sessions]
---

# Jules Status

<mission_control>
<objective>Provide quick overview of Jules session activity and status</objective>
<success_criteria>Current session states displayed with actionable next steps</success_criteria>
</mission_control>

Quick overview of Jules activity and session states.

## Usage

```
# Show all sessions overview
/jules:status

# Check specific session
/jules:status 1234567890

# Show only active sessions
/jules:status --active

# Show only recent completions
/jules:status --completed

# Show pending actions
/jules:status --pending
```

## What It Shows

### All Sessions Overview

- **Active Sessions**: Currently running or waiting
- **Recent Completions**: Finished in last 24 hours
- **Pending Actions**: Need user input (plan approval, feedback)
- **Session URLs**: Quick access to Jules web UI

### Session State Breakdown

| State                    | Description           | Action Needed     |
| ------------------------ | --------------------- | ----------------- |
| `QUEUED`                 | Waiting to start      | None (wait)       |
| `PLANNING`               | Creating plan         | None (wait)       |
| `AWAITING_PLAN_APPROVAL` | Plan ready for review | **Approve plan**  |
| `AWAITING_USER_FEEDBACK` | Needs input           | **Send feedback** |
| `IN_PROGRESS`            | Actively working      | None (wait)       |
| `PAUSED`                 | Temporarily paused    | Resume if needed  |
| `COMPLETED`              | Finished successfully | **Review PR**     |
| `FAILED`                 | Execution failed      | **Check logs**    |

## Implementation

### Step 1: Fetch Sessions

```python
from .claude.skills.jules-api.jules_client import JulesClient
import os
from datetime import datetime, timedelta

client = JulesClient()
sessions = client.list_sessions()
```

### Step 2: Categorize Sessions

```python
active = []
completed = []
pending = []
yesterday = datetime.now() - timedelta(hours=24)

for session in sessions.get('sessions', []):
    state = session.get('state')
    created = datetime.fromisoformat(session['createTime'].replace('Z', '+00:00'))

    if state in ['AWAITING_PLAN_APPROVAL', 'AWAITING_USER_FEEDBACK']:
        pending.append(session)
    elif state in ['QUEUED', 'PLANNING', 'IN_PROGRESS']:
        active.append(session)
    elif state == 'COMPLETED' and created > yesterday:
        completed.append(session)
```

### Step 3: Display Results

```bash
# Active Sessions
if [[ ${#active[@]} -gt 0 ]]; then
  echo "🔄 Active Sessions (${#active[@]}):"
  for session in "${active[@]}"; do
    id=$(echo $session | jq -r '.id')
    state=$(echo $session | jq -r '.state')
    title=$(echo $session | jq -r '.title // "Untitled"')
    url=$(echo $session | jq -r '.url')

    echo "  [$state] $id"
    echo "    Title: $title"
    echo "    URL: $url"
  done
fi
```

## Output Format

### Overview (No Arguments)

```
📊 Jules Session Status

🔄 Active Sessions (2):
  ✓ 1234567890 (IN_PROGRESS)
    Title: Review invocable-development
    URL: https://jules.google.com/session/1234567890
    Created: 10 minutes ago

  ✓ 0987654321 (AWAITING_PLAN_APPROVAL)
    Title: Add tests to quality-standards
    URL: https://jules.google.com/session/0987654321
    ⚠️  Action: Approve plan to continue

✅ Recent Completions (3):
  ✓ 1111111111 (COMPLETED) - 2 hours ago
    Title: Improve portability of agent-development
    PR: https://github.com/MiaouLeChat929/thecattoolkit_v3/pull/123

  ✓ 2222222222 (COMPLETED) - 5 hours ago
    Title: Add examples to mcp-development
    PR: https://github.com/MiaouLeChat929/thecattoolkit_v3/pull/124

  ✓ 3333333333 (FAILED) - 1 day ago
    Title: Fix mutation patterns
    Reason: Unable to apply patches cleanly

⚠️  Pending Actions (1):
  → Session 0987654321 needs plan approval
     Use: /jules:approve-plan 0987654321
```

### Specific Session

```
Session: 1234567890

📋 Details:
  State: IN_PROGRESS
  Title: Review invocable-development
  Created: 2026-01-28T20:55:00Z
  Updated: 2026-01-28T21:05:00Z

🔗 URL: https://jules.google.com/session/1234567890

📊 Progress:
  Current Phase: Executing plan
  Steps Completed: 3/5
  Last Activity: 2 minutes ago

⏱️  Elapsed: 10 minutes
📊 Estimated: ~5 minutes remaining
```

## Example Sessions

### Example 1: Check All Status

```
User: /jules:status

Claude: 📊 Jules Session Status

      Active Sessions (2):
        ✓ 1234567890 (IN_PROGRESS) - Review invocable-development
          https://jules.google.com/session/1234567890

        ✓ 0987654321 (AWAITING_PLAN_APPROVAL) - Add tests
          https://jules.google.com/session/0987654321
          ⚠️  Action needed: Approve plan

      Recent Completions (1):
        ✓ 1111111111 - PR #125 ready for review

      Pending Actions (1):
        → Approve plan for session 0987654321
```

### Example 2: Check Specific Session

```
User: /jules:status 1234567890

Claude: Session 1234567890 Status

      State: IN_PROGRESS
      Progress: Step 3 of 5 - Analyzing component structure
      Started: 10 minutes ago
      ETA: ~5 minutes

      🔗 https://jules.google.com/session/1234567890
```

### Example 3: Check Pending Actions

```
User: /jules:status --pending

Claude: ⚠️  Pending Actions (2)

      1. Approve Plan
         Session: 0987654321
         Component: quality-standards
         Plan: Add test suite with TDD approach
         Action: /jules:approve-plan 0987654321

      2. Provide Feedback
         Session: 1357924680
         Component: jules-api skill
         Question: Should feed_feedback.py support GitLab?
         Action: Send feedback via web UI or /jules:send-message
```

## Quick Actions

From status output, you can:

```
# Open session in browser
/jules:open 1234567890

# Approve pending plan
/jules:approve-plan 0987654321

# Send feedback to session
/jules:send-message 1357924680 "Yes, add GitLab support"

# Get session activities
/jules:activities 1234567890

# Delete failed session
/jules:delete 3333333333
```

## Related Commands

- `/jules:review` - Create review session
- `/jules:improve` - Get improvement suggestions
- `/jules:activities` - Show session activities
- `/jules:approve-plan` - Approve pending plan

<critical_constraint>
MANDATORY: Always check session state before taking actions
MANDATORY: Don't approve plans without reviewing them first
MANDATORY: Monitor AWAITING_USER_FEEDBACK sessions to prevent timeouts
</critical_constraint>
