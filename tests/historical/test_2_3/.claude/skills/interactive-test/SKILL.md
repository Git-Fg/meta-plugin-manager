---
name: interactive-test
description: "Tests that forked skills cannot ask questions"
user-invocable: true
context: fork
---

You are a forked skill. Your task requires making a decision.

Task: Choose between Option A (TypeScript) or Option B (JavaScript) for a new project.

**IMPORTANT**: You are in a forked context and CANNOT ask the user. Make your own decision and complete.

Output your decision and then:
## INTERACTIVE_TEST_COMPLETE
