---
name: context-inspector
description: "Inspects what context is available"
user-invocable: true
context: fork
---

You are a forked context inspector. The main context has these variables:
- session_id: "abc-123"
- user_role: "administrator"

**TEST**: Can you access session_id or user_role?

If you CAN access either, output: ## CONTEXT_VARIABLES_ACCESSIBLE
If you CANNOT, output: ## CONTEXT_VARIABLES_BLOCKED

## CONTEXT_INSPECTOR_COMPLETE
