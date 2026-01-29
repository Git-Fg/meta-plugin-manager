# Authentication

Login flows and session management.

## Login Flow

```bash
agent-browser open "https://app.example.com/login"
agent-browser snapshot -i

# Fill credentials
agent-browser fill @e1 "username"
agent-browser fill @e2 "password"
agent-browser click @e3

# Verify login success
agent-browser wait --url "**/dashboard"
agent-browser state save auth.json
```

## Reuse Session

```bash
# After initial login
agent-browser state load auth.json
agent-browser open "https://app.example.com/dashboard"
```

## Headers-Based Auth

```bash
# Auth via HTTP headers (skips login flow)
agent-browser open "https://api.example.com" --headers '{"Authorization": "Bearer <token>"}'
agent-browser snapshot -i
```
