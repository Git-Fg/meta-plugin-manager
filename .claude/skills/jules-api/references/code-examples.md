# Code Examples

Working code examples for interacting with the Jules API. Use when you need ready-to-copy code patterns for Python or Bash.

**Note**: Prefer direct API calls (curl/httpx) over the Python client for transparency and portability.

---

## Python with httpx

Use when: You're working in Python and need to make API calls programmatically.

### Setup

```python
import os
import httpx

API_KEY = os.environ.get("JULES_API_KEY")
BASE_URL = "https://jules.googleapis.com/v1alpha"

headers = {
    "X-Goog-Api-Key": API_KEY,
    "Content-Type": "application/json"
}
```

### Create Session

```python
response = httpx.post(
    f"{BASE_URL}/sessions",
    headers=headers,
    json={
        "prompt": "Add error handling to API endpoints",
        "sourceContext": {
            "source": "sources/github/myorg/myproject",
            "githubRepoContext": {"startingBranch": "main"},
            "environmentVariablesEnabled": True
        },
        "requirePlanApproval": True,
        "automationMode": "AUTO_CREATE_PR"
    }
)
session = response.json()
session_id = session['name'].split('/')[-1]
```

### Get Status

```python
response = httpx.get(
    f"{BASE_URL}/sessions/{session_id}",
    headers=headers
)
status = response.json()
```

### Send Message

```python
if status['state'] == 'AWAITING_USER_FEEDBACK':
    httpx.post(
        f"{BASE_URL}/sessions/{session_id}:sendMessage",
        headers=headers,
        json={"prompt": "Proceed with the implementation"}
    )
```

---

## Bash with curl

Use when: You're working in a terminal, writing scripts, or need quick API calls.

### Setup

```bash
export JULES_API_KEY="your-api-key-here"
export BASE_URL="https://jules.googleapis.com/v1alpha"
```

### Create Session

```bash
curl -X POST "$BASE_URL/sessions" \
  -H "X-Goog-Api-Key: $JULES_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Add error handling to API endpoints",
    "sourceContext": {
      "source": "sources/github/myorg/myproject",
      "githubRepoContext": {"startingBranch": "main"},
      "environmentVariablesEnabled": true
    },
    "automationMode": "AUTO_CREATE_PR"
  }'
```

### Get Status

```bash
curl "$BASE_URL/sessions/SESSION_ID" \
  -H "X-Goog-Api-Key: $JULES_API_KEY"
```

### Send Message

```bash
curl -X POST "$BASE_URL/sessions/SESSION_ID:sendMessage" \
  -H "X-Goog-Api-Key: $JULES_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"prompt": "Proceed with implementation"}'
```

---

## Polling for Completion

Use when: You need to wait for a session to complete and retrieve results automatically.

```python
import time

def wait_for_completion(session_id, timeout_minutes=30):
    """Poll session status until completion or timeout"""
    start = time.time()
    timeout = timeout_minutes * 60

    while time.time() - start < timeout:
        response = httpx.get(
            f"{BASE_URL}/sessions/{session_id}",
            headers=headers
        )
        state = response.json()['state']

        if state == 'COMPLETED':
            return True
        elif state == 'FAILED':
            return False

        time.sleep(30)  # Check every 30 seconds

    return False
```

---

## Error Handling

Use when: You need robust error handling in your API integration code.

```python
try:
    response = httpx.post(
        f"{BASE_URL}/sessions",
        headers=headers,
        json={...},
        timeout=30.0
    )
    response.raise_for_status()
    session = response.json()

except httpx.HTTPStatusError as e:
    if e.response.status_code == 401:
        print("Authentication failed - check API key")
    elif e.response.status_code == 404:
        print("Session not found")
    elif e.response.status_code == 400:
        print(f"Bad request: {e.response.text}")
    else:
        print(f"HTTP error: {e.response.status_code}")

except httpx.TimeoutException:
    print("Request timed out")
```

---

## Best Practices Summary

- **Always set automationMode to AUTO_CREATE_PR** for automatic PR creation
- **Check session state after ~10 minutes** for typical completion
- **Handle AWAITING_PLAN_APPROVAL and AWAITING_USER_FEEDBACK** states
- **Extract session_id from session['name']** using split('/')
- **Use environment variables for API keys** - never hardcode
- **Prefer direct API calls** over the Python client for transparency
