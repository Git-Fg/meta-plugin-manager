---
name: jules-api
description: "Programmatic interface to Google's Jules API for asynchronous coding task delegation. Use when creating Jules sessions, monitoring async work, or integrating code reviews/refactoring/tests into workflows. Includes session creation, progress monitoring, and output retrieval. Not for synchronous coding tasks, immediate execution requirements, or non-async workflows."
---

# Jules API Integration

<mission_control>
<objective>Delegate asynchronous coding tasks to Jules (Google's AI coding agent) for maximum efficiency. Claude creates sessions, monitors progress, and retrieves outputs while user continues other work.</objective>
<success_criteria>Jules session created with proper TDD prompt, session ID returned to user, async workflow established</success_criteria>
</mission_control>

<trigger>When user mentions code review, refactoring, adding tests, bug fixes, or when code is pushed to remote branch</trigger>

<guiding_principles>

## The Path to High-Impact Async Delegation

### 1. TDD First Ensures Correctness Before Implementation

Writing behavior-relevant tests before code guarantees that implementations solve actual problems. This prevents regressions, creates clear acceptance criteria, and produces maintainable test suites that validate what the code does rather than how it's implemented.

**Why this works**: Tests written from the user/caller perspective remain stable during refactoring. Implementation tests that mock internal details break when code structure changes, creating maintenance burden.

### 2. Async Delegation Multiplies Your Impact

While Jules handles tactical work (code review, test generation, bug fixes), you focus on strategic tasks. This parallel processing increases throughput—Jules completes tasks in ~10 minutes while you continue other work.

**Why this works**: Synchronous waiting wastes your most valuable resource. Async delegation creates two workstreams that execute simultaneously, multiplying your effective output.

### 3. Script-First Usage Ensures Consistency

The `jules_client.py` script encapsulates best practices for all API operations with proper error handling and state management. Using the script instead of raw HTTP calls prevents common mistakes and provides a unified interface.

**Why this works**: Centralized implementation means improvements benefit all operations. Direct HTTP calls scatter behavior and increase maintenance burden.

### 4. AUTO_CREATE_PR Enables Full Automation

Setting `automationMode: "AUTO_CREATE_PR"` allows Jules to create pull requests automatically. This closes the loop—Jules doesn't just write code, it delivers reviewable changes ready for integration.

**Why this works**: Manual PR creation interrupts workflow. Automation preserves async benefits by eliminating the "come back and click" step.

### 5. PR Comment Resume Creates Iteration Loops

Jules monitors PRs and automatically resumes sessions when you comment. This creates a powerful feedback loop—review, comment, Jules revises, repeat—without creating duplicate sessions.

**Why this works**: Traditional delegation ends with the first deliverable. PR comment resume transforms one-shot delegation into iterative collaboration, improving quality through natural conversation.

### 6. Specific Prompts Enable Quality Results

Clear, actionable prompts with TDD instructions produce better outcomes than vague requests. Jules needs context about what you want, how to validate it (tests), and any constraints or preferences.

**Why this works**: AI agents execute instructions precisely. Ambiguity creates uncertainty—specific prompts channel that precision toward your desired outcome.

</guiding_principles>

> **API Status**: Alpha (v1alpha) - specifications may stabilize

## Quick Start

**Create session:** `jules.createSession()` → Returns session ID

**Monitor progress:** `jules.getSessionState()` → Returns current state

**Retrieve output:** `jules.getSessionArtifacts()` → Returns PR/files

**Why:** Async delegation frees Claude for strategic work—Jules handles code review, refactoring, tests in background.

This skill integrates with Claude Code native tools for optimal execution:

## Operational Patterns

This skill follows these behavioral patterns:

- **Tracking**: Maintain a visible task list for Jules session creation
- **Management**: Manage task lifecycle for session monitoring

Trust native tools to fulfill these patterns. The System Prompt selects the correct implementation.

## Navigation

| If you need...        | Read...                                     |
| :-------------------- | :------------------------------------------ |
| Create session        | ## Jules API Methods                        |
| Monitor progress      | ## Jules API Methods                        |
| Retrieve output       | ## Jules API Methods                        |
| Overview              | ## Overview                                 |
| Delegation philosophy | ## Delegation Philosophy                    |
| When to delegate      | ## Delegation Philosophy → When to Delegate |
| Code examples         | `references/pattern_code-examples.md`       |

---

## Overview

Jules API enables asynchronous coding task delegation:

- Create sessions with prompts (repo-based or repoless)
- Monitor progress through state transitions
- Retrieve outputs (PRs, artifacts, files)
- Approve plans or provide feedback interactively

---

## Delegation Philosophy

**KEY PRINCIPLE**: Use Jules for async tasks to free Claude for strategic work.

### When to Delegate

Claude should proactively suggest Jules for:

| Task          | Example                                                  |
| ------------- | -------------------------------------------------------- |
| Code Reviews  | "Review authentication changes in feature/auth"          |
| Refactoring   | "Refactor parser to use Polars for 10x performance"      |
| Adding Tests  | "Add comprehensive tests for payment module"             |
| Bug Fixes     | "Fix timezone bug (commit abc123) with regression tests" |
| Documentation | "Update API docs for new endpoints"                      |
| Maintenance   | Weekly dependency updates, nightly linting               |

### Effective Delegation Patterns

**Pattern 1: Implement → Review**

1. Claude implements feature
2. Push branch to remote
3. Create Jules session: "Review and improve feature X"
4. Jules creates PR with improvements
5. Claude integrates feedback

**Pattern 2: Test Generation**

1. Claude implements feature
2. Create Jules session: "Add comprehensive tests for module X"
3. Jules generates test suite
4. Merge when tests pass

**Pattern 3: Bug Fix**

1. Investigate and identify root cause
2. Create Jules session with reproduction steps
3. Jules fixes and adds regression tests

**Pattern 4: Repoless Prototype**

1. Create session without sourceContext
2. Jules creates code in ephemeral environment
3. Download and integrate results

### Claude's Role in Delegation

When delegating to Jules, Claude should:

1. **Prepare the context** - Ensure branch is pushed and up-to-date
2. **Write clear prompts** - Specific, actionable instructions with TDD
3. **Create the session** - Use direct API calls
4. **Return session info** - Give user the session ID and URL
5. **Suggest next steps** - Explain what Jules will do and when to check back

**Example dialogue**:

```
User: "Can you review my authentication changes?"

Claude: "I'll create a Jules session to review your authentication code.
         Jules works asynchronously and will create a PR with feedback.

         Session ID: 123456789
         URL: https://jules.google.com/session/123456789

         Jules typically completes tasks in ~10 minutes.
         You can continue other work while Jules reviews."
```

---

## TDD Prompt Template

Include TDD instructions in every Jules prompt to ensure behavior-relevant test coverage:

```
Use Test-Driven Development (TDD) approach:
1. Write behavior-relevant tests first (expected behavior, edge cases, error conditions)
2. Run tests to confirm they fail (red phase)
3. Implement minimal code to make tests pass (green phase)
4. Refactor while keeping tests passing (refactor phase)
5. Ensure all tests have meaningful assertions that validate actual behavior
```

**Feature implementation example**:

```
Add user authentication to the API.

Use TDD approach:
1. Write tests for: successful login, invalid credentials, token expiration, rate limiting
2. Implement authentication logic to pass tests
3. Refactor for security best practices

Tests should validate actual behavior, not implementation details.
```

**Refactoring example**:

```
Refactor the parser to use Polars instead of Pandas.

Use TDD approach:
1. Write behavior tests that validate current parser output
2. Refactor to use Polars while keeping tests green
3. Add performance benchmarks as tests

Focus on behavior: input -> output validation, not internal implementation.
```

---

## Base Configuration

```
Base URL: https://jules.googleapis.com
API Version: v1alpha
Authentication: X-Goog-Api-Key header
```

### Session States

| State                    | Meaning                    |
| ------------------------ | -------------------------- |
| `QUEUED`                 | Awaiting processing        |
| `PLANNING`               | Agent developing strategy  |
| `AWAITING_PLAN_APPROVAL` | Requires user confirmation |
| `AWAITING_USER_FEEDBACK` | Needs additional input     |
| `IN_PROGRESS`            | Actively executing         |
| `COMPLETED`              | Successfully finished      |
| `FAILED`                 | Execution unsuccessful     |

**Recommended**: Use `"automationMode": "AUTO_CREATE_PR"` for automatic PR creation (enables full async workflow).

---

## Authentication

1. Get API key: https://jules.google.com/settings#api
2. Set environment variable:

```bash
export JULES_API_KEY="your-api-key-here"
```

**Security**: Never commit API keys to version control.

---

## Quick Start

**CLI Commands**:

```bash
# Create session with repository
uv run scripts/jules_client.py create "Add TDD tests for auth" owner repo

# Create repoless session
uv run scripts/jules_client.py create "Create weather CLI" --title "Weather CLI"

# Check status
uv run scripts/jules_client.py get SESSION_ID

# List all sessions
uv run scripts/jules_client.py list
```

---

## System Requirements

- **Jules API Key**: Set `JULES_API_KEY` environment variable
- **Node.js**: >= 18
- **HTTP Client**: Built-in fetch or axios

---

## Implementation Patterns

**Create session with repository context**:

```python
import httpx

url = "https://jules.googleapis.com/v1alpha/sessions"
headers = {"X-Goog-Api-Key": "YOUR_API_KEY"}

payload = {
    "sourceContext": {"owner": "myorg", "repo": "myrepo"},
    "prompt": "Add tests using TDD approach",
    "config": {
        "automationMode": "AUTO_CREATE_PR",
        "requirePlanApproval": False,
        "environmentVariablesEnabled": True
    }
}

response = httpx.post(url, json=payload, headers=headers)
print(response.json())
```

**Create repoless session**:

```python
payload = {
    "prompt": "Create a Python CLI that fetches weather data",
    "config": {
        "automationMode": "AUTO_CREATE_PR",
        "requirePlanApproval": False
    }
}
# No sourceContext = repoless
```

**Monitor session state**:

```python
def check_session(session_id):
    url = f"https://jules.googleapis.com/v1alpha/sessions/{session_id}"
    response = httpx.get(url, headers=headers)
    state = response.json()["state"]

    if state == "AWAITING_PLAN_APPROVAL":
        print("Review and approve plan")
    elif state == "IN_PROGRESS":
        print("Jules is working...")
    elif state == "COMPLETED":
        print("Check outputs for PR/artifacts")
    elif state == "FAILED":
        print("Check error message")
```

---

## Troubleshooting

**Issue**: Session stuck in PLANNING state

- **Symptom**: State remains PLANNING for >5 minutes
- **Solution**: Check requirePlanApproval setting; Jules may be waiting for clarification

**Issue**: AUTH_FAILURE error

- **Symptom**: 401 or 403 error on API calls
- **Solution**: Verify JULES_API_KEY is set and valid at https://jules.google.com/settings#api

**Issue**: No PR created after completion

- **Symptom**: Session COMPLETED but no PR link in outputs
- **Solution**: Ensure automationMode: "AUTO_CREATE_PR" was set in config

**Issue**: Missing sourceContext in results

- **Symptom**: Files not appearing in expected repository
- **Solution**: Verify owner/repo are correct; check if repo is accessible with API key

---

## Proactive Delegation Triggers

Claude should automatically suggest Jules delegation when:

- User pushes a branch and asks "what do you think?"
- User says "add tests", "improve tests", or "review"
- User mentions "refactor" or "optimize"
- Feature is complete and needs polish
- User reports a well-defined bug
- Documentation needs updating
- Recurring maintenance tasks mentioned

**Example proactive response**:

```
User: "Just pushed the new API endpoint to feature/api-v2"

Claude: "Great! Would you like me to create a Jules session to review it?
         Jules can check for edge cases, add tests, and optimize while you
         continue working on other features. Sessions typically complete
         in ~10 minutes."
```

---

## Best Practices

1. **Use Descriptive Prompts**: Specific, actionable instructions
2. **Monitor State**: Poll session status to track progress
3. **Enable Plan Approval**: Set `requirePlanApproval: true` for sensitive operations
4. **Handle States**: Respond to AWAITING_USER_FEEDBACK and AWAITING_PLAN_APPROVAL
5. **Check Outputs**: Review outputs array for PRs and artifacts
6. **Use Pagination**: Handle nextPageToken for large result sets
7. **Enable Environment Variables**: Set `environmentVariablesEnabled: true` for credentials
8. **Use Repoless for Prototypes**: Quick experiments don't need a repository

---

## Jules PR Comment Resume Feature

Jules monitors PRs and automatically resumes sessions when you comment.

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

This creates a powerful iteration loop.

---

## Timing Considerations

**Jules session duration**:

- Typical: ~10 minutes
- Simple tasks: 5-10 minutes
- Complex tasks: 15-30 minutes
- Large refactors: 30+ minutes

**Workflow optimization**:

- Create Jules session immediately when delegation is appropriate
- Continue other work while Jules executes (don't wait synchronously)
- Check session status after ~10 minutes
- Use this time for strategic planning or other tasks

---

## Usage Philosophy

This skill uses `jules_client.py` as the primary interface for all Jules API operations. The script encapsulates best practices with proper error handling and state management.

**Available commands**:

| Command                                                     | Purpose                  |
| ----------------------------------------------------------- | ------------------------ |
| `uv run scripts/jules_client.py create "prompt" owner repo` | Create new session       |
| `uv run scripts/jules_client.py get SESSION_ID`             | Get session details      |
| `uv run scripts/jules_client.py list`                       | List all sessions        |
| `uv run scripts/jules_client.py message SESSION_ID "text"`  | Send message to session  |
| `uv run scripts/jules_client.py approve-plan SESSION_ID`    | Approve plan             |
| `uv run scripts/jules_client.py activities SESSION_ID`      | Get session activities   |
| `uv run scripts/jules_client.py check SESSION_ID`           | Check if needs attention |

---

## Tools

### Feed Feedback (CI/Reviews)

This skill includes a script `feed_feedback.py` designed to run in a scheduled workflow. It enables Jules to receive feedback from CI failures and code reviews on its own Pull Requests.

**Purpose**: Closes the feedback loop by reporting CI errors and review comments back to the active Jules session so it can interactively fix issues.

**Usage**:

```bash
# Run locally (requires JULES_API_KEY and GITHUB_TOKEN)
uv run scripts/feed_feedback.py

# Run for a specific bot author (default: jules-bot)
uv run scripts/feed_feedback.py --author my-bot-name
```

**How it works**:

1. Scans for open PRs by `jules-bot`
2. Checks CI status (failed) and Reviews (changes requested)
3. Extracts the Jules Session ID from the branch name or PR body
4. Sends a prompt to the session with error logs and feedback
5. Posts a comment on the PR to prevent spamming the same feedback

---

## Navigation

**External Documentation**:

- Official API → https://developers.google.com/jules/api/reference/rest
- Changelog → https://jules.google.com/docs/changelog/
- Jules Blog → https://blog.google/technology/google-labs/jules-tools-jules-api/

**Local References**:

| If you need...                        | Read...                                             |
| ------------------------------------- | --------------------------------------------------- |
| Complete API documentation, endpoints | [api-reference.md](references/api-reference.md)     |
| Working Python/Bash code examples     | [code-examples.md](references/code-examples.md)     |
| Debugging stuck sessions              | [troubleshooting.md](references/troubleshooting.md) |

---

## Dynamic Sourcing

<fetch*protocol>
**Syntax Source**: This skill focuses on \_patterns* and _philosophy_. For raw Jules API syntax (endpoints, request/response schemas):

1. **Fetch**: `https://developers.google.com/jules/api/reference/rest`
2. **Extract**: The specific endpoint or schema you need
3. **Discard**: Do not retain the fetch in context

**Additional Sources** (when needed):

- Changelog → `https://jules.google.com/docs/changelog/`
- API key setup → `https://jules.google.com/settings#api`
  </fetch_protocol>

---

## Critical Constraints

<critical_constraint>
**Portability Invariant**: This skill must work standalone in any project with zero external dependencies to `.claude/rules/` or CLAUDE.md. All philosophy for async delegation, TDD, and Jules integration is bundled within this skill.
</critical_constraint>
