# API Reference

Complete reference for Jules API resources, endpoints, and operations. Use when you need to look up specific endpoint details, resource field definitions, or error codes.

---

## Base Configuration

```
Base URL: https://jules.googleapis.com
API Version: v1alpha
Authentication: X-Goog-Api-Key header
```

---

## Session Resource

The Session resource represents an asynchronous coding task.

### Resource Fields

| Field                 | Type            | Description                                           |
| --------------------- | --------------- | ----------------------------------------------------- |
| `name`                | string          | Output only. Full resource name: `sessions/{session}` |
| `id`                  | string          | Output only. Session identifier                       |
| `prompt`              | string          | **Required**. Initial prompt for the session          |
| `sourceContext`       | SourceContext   | **Required** for repo sessions. Source specification  |
| `title`               | string          | Optional. Auto-generated if not provided              |
| `requirePlanApproval` | boolean         | Optional. Require explicit approval before execution  |
| `automationMode`      | AutomationMode  | Optional. Automation behavior                         |
| `createTime`          | Timestamp       | Output only. RFC 3339 creation timestamp              |
| `updateTime`          | Timestamp       | Output only. RFC 3339 last modification timestamp     |
| `state`               | State           | Output only. Current session status                   |
| `url`                 | string          | Output only. Jules web app URL                        |
| `outputs[]`           | SessionOutput[] | Output only. Generated outputs                        |

### Session States

| State                    | Description                |
| ------------------------ | -------------------------- |
| `STATE_UNSPECIFIED`      | Unspecified state          |
| `QUEUED`                 | Awaiting processing        |
| `PLANNING`               | Agent developing strategy  |
| `AWAITING_PLAN_APPROVAL` | Requires user confirmation |
| `AWAITING_USER_FEEDBACK` | Needs additional input     |
| `IN_PROGRESS`            | Actively executing         |
| `PAUSED`                 | Temporarily halted         |
| `FAILED`                 | Execution unsuccessful     |
| `COMPLETED`              | Successfully finished      |

### Automation Modes

| Mode                          | Description                                            |
| ----------------------------- | ------------------------------------------------------ |
| `AUTOMATION_MODE_UNSPECIFIED` | Default (no automation)                                |
| `AUTO_CREATE_PR`              | Automatically creates branch and PR from final patches |

---

## Source Resource

The Source resource represents an input data source (GitHub repository).

### Resource Fields

| Field        | Type       | Description                            |
| ------------ | ---------- | -------------------------------------- |
| `name`       | string     | Full resource name: `sources/{source}` |
| `id`         | string     | Output only. Source identifier         |
| `githubRepo` | GitHubRepo | GitHub repository data                 |

### GitHubRepo Object

| Field           | Type           | Description                                       |
| --------------- | -------------- | ------------------------------------------------- |
| `owner`         | string         | Repository owner from `github.com/<owner>/<repo>` |
| `repo`          | string         | Repository name                                   |
| `isPrivate`     | boolean        | Whether the repository is private                 |
| `defaultBranch` | GitHubBranch   | Primary branch configuration                      |
| `branches[]`    | GitHubBranch[] | Active branches list                              |

### GitHubBranch Object

| Field         | Type   | Description            |
| ------------- | ------ | ---------------------- |
| `displayName` | string | The GitHub branch name |

---

## Activity Resource

Activities represent units of work within a session.

### Resource Fields

| Field         | Type       | Description                                                    |
| ------------- | ---------- | -------------------------------------------------------------- |
| `name`        | string     | Full resource name: `sessions/{session}/activities/{activity}` |
| `id`          | string     | Activity identifier                                            |
| `description` | string     | Human-readable summary                                         |
| `createTime`  | Timestamp  | RFC 3339 creation timestamp                                    |
| `originator`  | string     | Source: "user", "agent", or "system"                           |
| `artifacts[]` | Artifact[] | Data units produced by the activity                            |

### Activity Types (union field - exactly one present)

| Type               | Description                                        |
| ------------------ | -------------------------------------------------- |
| `agentMessaged`    | Agent posted a message                             |
| `userMessaged`     | User posted a message                              |
| `planGenerated`    | Plan was created (contains Plan object with steps) |
| `planApproved`     | Plan was approved (references plan by ID)          |
| `progressUpdated`  | Progress notification (title + description)        |
| `sessionCompleted` | Session finished                                   |
| `sessionFailed`    | Session encountered failure (includes reason)      |

### Artifact Types (union field)

| Type         | Description                                              |
| ------------ | -------------------------------------------------------- |
| `changeSet`  | Code modifications via Git patches (source + gitPatch)   |
| `media`      | Files like images/videos (base64-encoded + MIME type)    |
| `bashOutput` | Command execution results (command + output + exit code) |

### GitPatch Object

| Field                    | Type   | Description                  |
| ------------------------ | ------ | ---------------------------- |
| `patch`                  | string | Unidiff format patch content |
| `baseCommitId`           | string | Base commit ID               |
| `suggestedCommitMessage` | string | Suggested commit message     |

---

## Endpoints

### Create a Session

**Endpoint**: `POST /v1alpha/sessions`

**Request Body (with repository)**:

```json
{
  "prompt": "Your coding task description",
  "sourceContext": {
    "source": "sources/github/username/repository",
    "githubRepoContext": {
      "startingBranch": "main"
    },
    "environmentVariablesEnabled": true
  },
  "title": "Optional session title",
  "requirePlanApproval": false,
  "automationMode": "AUTO_CREATE_PR"
}
```

**Request Body (repoless session)**:

```json
{
  "prompt": "Create a Python CLI that fetches weather data from an API",
  "title": "Weather CLI Prototype",
  "requirePlanApproval": false
}
```

**Response**:

```json
{
  "name": "sessions/123456789",
  "id": "123456789",
  "state": "QUEUED",
  "url": "https://jules.google.com/session/123456789",
  "createTime": "2026-01-28T10:00:00Z"
}
```

---

### Get Session Status

**Endpoint**: `GET /v1alpha/sessions/{sessionId}`

**Response**:

```json
{
  "name": "sessions/abc123",
  "id": "abc123",
  "state": "COMPLETED",
  "outputs": [
    {
      "pullRequest": {
        "url": "https://github.com/owner/repo/pull/42",
        "title": "Feature implementation"
      }
    }
  ]
}
```

---

### Delete a Session

**Endpoint**: `DELETE /v1alpha/sessions/{sessionId}`

**Response**: Empty body on success.

---

### List All Sessions

**Endpoint**: `GET /v1alpha/sessions`

**Query Parameters**:
| Parameter | Type | Description |
| ----------- | ------- | ------------------------------------------------ |
| `pageSize` | integer | Number of sessions to return (1-100, default 30) |
| `pageToken` | string | Token from previous call for pagination |

**Response**:

```json
{
  "sessions": [...],
  "nextPageToken": "TOKEN_FOR_NEXT_PAGE"
}
```

---

### Send Message to Session

**Endpoint**: `POST /v1alpha/sessions/{sessionId}:sendMessage`

**Request Body**:

```json
{
  "prompt": "Your message or feedback"
}
```

**Response**: Empty body on success.

---

### Approve Plan

**Endpoint**: `POST /v1alpha/sessions/{sessionId}:approvePlan`

**Response**: Empty body on success.

---

### Get Session Activities

**Endpoint**: `GET /v1alpha/sessions/{sessionId}/activities`

**Query Parameters**:
| Parameter | Type | Description |
| ------------ | ------- | --------------------------------------------------------- |
| `pageSize` | integer | Number of activities to return (1-100, default 50) |
| `pageToken` | string | Token from previous call for pagination |
| `createTime` | string | Filter activities created after this timestamp (RFC 3339) |

---

### Get Single Activity

**Endpoint**: `GET /v1alpha/sessions/{sessionId}/activities/{activityId}`

---

### List Sources

**Endpoint**: `GET /v1alpha/sources`

**Query Parameters**:
| Parameter | Type | Description |
| ----------- | ------- | ----------------------------------------------- |
| `filter` | string | Filter expression (AIP-160 syntax) |
| `pageSize` | integer | Number of sources to return (1-100, default 30) |
| `pageToken` | string | Token from previous call for pagination |

**Response**:

```json
{
  "sources": [
    {
      "name": "sources/github/myorg/myrepo",
      "id": "github/myorg/myrepo",
      "githubRepo": {
        "owner": "myorg",
        "repo": "myrepo",
        "isPrivate": false,
        "defaultBranch": { "displayName": "main" },
        "branches": [{ "displayName": "main" }, { "displayName": "develop" }]
      }
    }
  ],
  "nextPageToken": "..."
}
```

---

### Get Single Source

**Endpoint**: `GET /v1alpha/sources/{source}`

---

## Error Handling

### HTTP Status Codes

| Code               | Meaning                    |
| ------------------ | -------------------------- |
| `200 OK`           | Success                    |
| `400 Bad Request`  | Invalid request parameters |
| `401 Unauthorized` | Authentication failed      |
| `403 Forbidden`    | Insufficient permissions   |
| `404 Not Found`    | Session doesn't exist      |

### Session ID Format Handling

**Important**: The API returns session names as `"sessions/123456789"` but accepts both formats:

```python
# API returns this format
session_name = session['name']  # "sessions/123456789"

# Extract just the ID
session_id = session['name'].split('/')[-1]  # "123456789"

# Both formats work in subsequent calls
httpx.get(f"/v1alpha/sessions/{session_id}")      # Works
httpx.get(f"/v1alpha/sessions/{session_name}")   # Also works
```

---

## Subscription Tiers

| Feature         | Free    | Google AI Pro | Google AI Ultra    |
| --------------- | ------- | ------------- | ------------------ |
| Session limits  | Base    | 5x higher     | 20x higher         |
| Suggested Tasks | No      | Yes (5 repos) | Yes (5 repos)      |
| Scheduled Tasks | Limited | Full          | Full               |
| Gemini 3 Pro    | No      | Yes           | Yes (first access) |

---

## External References

- **Official API Documentation**: https://developers.google.com/jules/api/reference/rest
- **Sessions API**: https://developers.google.com/jules/api/reference/rest/v1alpha/sessions
- **Sources API**: https://developers.google.com/jules/api/reference/rest/v1alpha/sources
- **Activities API**: https://developers.google.com/jules/api/reference/rest/v1alpha/sessions.activities
- **Changelog**: https://jules.google.com/docs/changelog/
