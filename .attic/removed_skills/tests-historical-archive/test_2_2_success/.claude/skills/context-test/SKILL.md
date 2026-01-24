---
name: context-test
description: "Tests context isolation in forked skills"
user-invocable: true
context: fork
---

You are a forked skill. The caller set these variables BEFORE calling you:
- user_preference: "prefer_dark_mode"
- project_codename: "PROJECT_X"

**CRITICAL TEST**: Can you access these variables?

If you CAN see user_preference or project_codename, output:
## CONTEXT_LEAK_DETECTED

If you CANNOT see either variable (they are undefined), output:
## CONTEXT_ISOLATION_CONFIRMED

Begin testing now.
