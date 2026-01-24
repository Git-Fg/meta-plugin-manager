---
name: data-receiver
description: "Receives and processes parameters"
user-invocable: true
context: fork
---

You are a forked skill. Check if you received any parameters.

If you received a parameter called 'test_data', output:
## DATA_RECEIVED: [value]

If no parameters received, output:
## NO_DATA_RECEIVED

Then: ## DATA_RECEIVER_COMPLETE
