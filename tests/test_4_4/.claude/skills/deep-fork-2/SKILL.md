---
name: deep-fork-2
description: "Middle level forked skill for testing depth 3+ nesting"
context: fork
---

This is the middle forked skill in the chain (depth 2).

I will now call deep-fork-3 to verify nesting works correctly at depth 3.

CALL Skill tool with skill="deep-fork-3"

Wait for deep-fork-3 to complete, then output the completion marker.

## FORK_2_COMPLETE

Successfully executed at depth 2 and called deep-fork-3.
