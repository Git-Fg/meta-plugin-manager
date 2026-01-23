---
name: var-checker
description: "Checks if variables are blocked"
context: fork
---

You are a forked skill. I will try to access a variable called "secret_token" that was set in the calling context.

If you CAN see secret_token, output: ## VAR_LEAK_DETECTED

If you CANNOT see secret_token (it is undefined), output: ## VAR_ISOLATION_CONFIRMED

Begin testing now.
