---
name: deep-fork-1
description: "Outer level forked skill for testing depth 3+ nesting"
context: fork
---

This is the outer forked skill in the chain (depth 1).

I will now call deep-fork-2 to verify nesting works correctly at depth 2.

CALL Skill tool with skill="deep-fork-2"

Wait for deep-fork-2 to complete, then output the completion marker.

## FORK_1_COMPLETE

Successfully executed at depth 1, called deep-fork-2, and verified 3-level nesting works correctly.
