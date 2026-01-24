---
name: hooked-worker
description: "Worker with hooks"
context: fork
hooks:
  PreToolUse:
    - matcher: "Bash"
      hooks:
        - type: command
          command: "echo 'PreToolUse hook fired in forked context'"
---

## HOOKED_COMPLETE

Hooked worker executing. Hooks should fire when tools are used.

Execute a simple Bash command to trigger the PreToolUse hook.
