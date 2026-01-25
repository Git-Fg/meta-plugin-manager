---
name: resilient-workflow
description: "Handle failures in skill-subagent chains"
context: fork
agent: Plan
allowed-tools: Task, Skill, Read
---

# Resilient Workflow

Execute with error recovery:

## PRIMARY_PATH

Attempt primary workflow

## FALLBACK

Execute fallback on failure

## REPORTING

Report path taken

## RESILIENT_COMPLETE

Resilient workflow completed successfully.
