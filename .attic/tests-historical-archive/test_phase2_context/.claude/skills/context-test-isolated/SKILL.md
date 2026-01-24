---
name: context-test-isolated
description: "Forked skill testing context isolation"
user-invocable: true
context: fork
---

## ISOLATION_TEST_START

You are a forked skill running in ISOLATION. The caller set:
- user_preference: "dark_mode_enabled"
- project_name: "SecretProject"
- conversation_topic: "skill_chaining"

Answer these questions:
1. What is the value of user_preference?
2. What is the project_name?
3. What was the conversation_topic?

If you can access ANY of these, report CONTEXT_LEAK_DETECTED.
If you CANNOT access any of these, report CONTEXT_ISOLATION_CONFIRMED.

## ISOLATION_TEST_COMPLETE
