# Troubleshooting

Debugging and resolving issues with Jules sessions. Use when a session is stuck in `AWAITING_USER_FEEDBACK` or `AWAITING_PLAN_APPROVAL` for an extended time, or when you need to understand what's blocking a session.

---

## Debugging Workflow

### Step 1: Check Session State

```python
response = httpx.get(
    f"{BASE_URL}/sessions/{session_id}",
    headers=headers
)
session = response.json()

print(f"State: {session['state']}")
print(f"Created: {session['createTime']}")
print(f"Updated: {session['updateTime']}")
```

**What to look for**:

- How long has session been in current state?
- When was last activity (`updateTime`)?
- Is state `AWAITING_USER_FEEDBACK` or `AWAITING_PLAN_APPROVAL`?

---

### Step 2: Read Activities to Understand Context

```python
response = httpx.get(
    f"{BASE_URL}/sessions/{session_id}/activities",
    headers=headers,
    params={"pageSize": 10}
)
activities = response.json()['activities']

# Show last 10 activities
for activity in activities[-10:]:
    originator = activity['originator']
    create_time = activity['createTime']

    if originator == 'agent':
        msg = activity.get('agentMessaged', {}).get('agentMessage', '')
        print(f"\n[JULES at {create_time}]")
        print(msg[:300] + ('...' if len(msg) > 300 else ''))
    elif originator == 'user':
        msg = activity.get('userMessaged', {}).get('userMessage', '')
        print(f"\n[USER at {create_time}]")
        print(msg[:300] + ('...' if len(msg) > 300 else ''))
```

**What to look for**:

- What was Jules' last message/question?
- What error or blocker did Jules encounter?
- Is there a plan awaiting approval?

---

### Step 3: Identify What Jules Is Asking

Look for the most recent agent message to understand:

- **Implementation Blocker**: Jules hit a technical issue and needs guidance
- **Unclear Requirements**: Jules needs clarification on what to build
- **Decision Paralysis**: Jules has multiple options and needs direction
- **Test Failures**: Jules can't get tests passing

---

### Step 4: Provide Targeted Feedback

```python
feedback = """
Based on your question about [TOPIC]:

**Decision**: [Pick one approach clearly]
**Reasoning**: [Explain why this approach]

**Context for your task**:
1. [Specific requirement 1]
2. [Specific requirement 2]
3. [Clear next steps]

Proceed autonomously with this guidance. If you encounter further issues,
be specific about what's blocking you.
"""

httpx.post(
    f"{BASE_URL}/sessions/{session_id}:sendMessage",
    headers=headers,
    json={"prompt": feedback}
)
```

**Feedback best practices**:

- Be specific and decisive
- Provide clear requirements
- Explain your reasoning
- Give explicit next steps

---

## Common Stuck Session Patterns

### Pattern 1: Implementation Blocker

**Symptoms**: Jules reports technical error it can't resolve

**Solution**: Read activities to identify the specific error, then provide fix or workaround

**Example**:

```
[Jules]: "I'm getting a ModuleNotFoundError for package X"

[Your feedback]: "Package X was renamed to Y in version 2.0.
             Use import Y instead. Update requirements.txt to specify Y>=2.0"
```

---

### Pattern 2: Unclear Requirements

**Symptoms**: Jules asks clarifying questions about what to build

**Solution**: Pick one approach clearly and explain the reasoning

**Example**:

```
[Jules]: "Should I use sync or async I/O for this?"

[Your feedback]: "Use async I/O. This service will handle many concurrent
             requests and async provides better throughput. Use aiohttp for HTTP calls.
             Acceptance criteria: Handles 1000 concurrent requests without blocking."
```

---

### Pattern 3: Decision Paralysis

**Symptoms**: Jules has multiple valid options and can't decide

**Solution**: Make the decision for Jules

**Example**:

```
[Jules]: "I could use a linked list or array for this. Which do you prefer?"

[Your feedback]: "Use array. Simpler, faster for our use case, and sufficient
             for the expected data size. Don't over-optimize prematurely."
```

---

### Pattern 4: Test Failures

**Symptoms**: Jules can't get tests passing and doesn't know how to proceed

**Solution**: Debug the test failure, provide specific fix or suggest accepting current state

**Example**:

```
[Jules]: "Tests are failing because the API returns different data than expected"

[Your feedback]: "The test expectations are wrong. Update tests to match the actual
             API response. The API is correct, the test mock was outdated.

             Update expected_data to match this structure:
             { 'id': str, 'name': str, 'created_at': str }

             Then verify tests pass."
```

---

## Handling AWAITING_PLAN_APPROVAL

When session is waiting for plan approval:

```python
# Get activities to find the plan
activities_data = httpx.get(
    f"{BASE_URL}/sessions/{session_id}/activities",
    headers=headers
).json()

# Find the planGenerated activity
for activity in reversed(activities_data['activities']):
    if 'planGenerated' in activity:
        plan = activity['planGenerated']['plan']
        print(f"Plan has {len(plan['steps'])} steps:\n")
        for i, step in enumerate(plan['steps'], 1):
            print(f"{i}. {step.get('title', 'N/A')}")
            print(f"   {step.get('description', 'N/A')[:100]}")
        break

# Approve if plan looks good
response = input("\nApprove this plan? (y/n): ")
if response.lower() == 'y':
    httpx.post(
        f"{BASE_URL}/sessions/{session_id}:approvePlan",
        headers=headers
    )
    print("Plan approved - session will resume")
```

**What to check before approving**:

- Are the steps reasonable?
- Is the scope appropriate?
- Are there any risky operations?
- Does the plan align with requirements?

---

## Session Never Completes

**Symptoms**: Session stuck in `IN_PROGRESS` for extended time (>30 minutes)

**Possible causes**:

1. Long-running operation (compile, large refactor)
2. Jules is still working (normal for complex tasks)
3. Session hung (rare)

**Actions**:

1. Check activities for recent progress
2. If no activity for 10+ minutes, may be hung
3. Consider creating new session with clearer scope
4. Contact support if sessions consistently hang

---

## Jules PR Comment Resume Feature

**IMPORTANT**: Jules monitors PRs and automatically resumes sessions when you comment!

**How it works**:

1. Jules creates PR #466
2. Session completes (state: `COMPLETED`)
3. You comment on PR: "Wrong SDK used (google.generativeai vs google.genai)"
4. **Jules AUTOMATICALLY resumes session**
5. State changes: `COMPLETED` → `AWAITING_PLAN_APPROVAL`
6. Jules generates new plan to address your feedback
7. You approve the plan
8. Jules fixes issues and updates PR

**Best practices**:

- **DO**: Comment on PRs with specific, actionable feedback
- **DO**: Check if session auto-resumed before creating duplicate
- **DO**: Approve Jules' new plan if it looks good
- **DO**: Use detailed comments - Jules understands context
- **DON'T**: Create new session if existing one can resume
- **DON'T**: Use vague comments like "fix this"

---

## Quick Reference: Unsticking Sessions

```python
# Complete unsticking workflow
def unstick_session(session_id):
    """Debug and unstick a stuck Jules session"""

    # 1. Check state
    session = client.get_session(session_id)
    print(f"State: {session['state']}")

    # 2. Read last 10 activities
    activities = client.get_activities(session_id)['activities'][-10:]

    # 3. Find last agent message
    for activity in reversed(activities):
        if activity['originator'] == 'agent':
            msg = activity.get('agentMessaged', {}).get('agentMessage', '')
            print(f"\nLast Jules message:\n{msg}")
            break

    # 4. Send targeted feedback
    feedback = input("\nYour feedback: ")
    client.send_message(session_id, feedback)
    print("Sent - monitor for state change")
```
