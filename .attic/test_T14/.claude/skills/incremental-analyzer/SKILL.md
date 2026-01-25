---
name: incremental-analyzer
description: "Test state persistence across skill invocations"
context: fork
agent: Plan
allowed-tools: Read, Write, Bash
---

# Incremental Analyzer

Maintain state across invocations:

## STATE_CREATE

Create state file

## STATE_LOAD

Load existing state

## STATE_CONTINUE

Continue analysis

## INCREMENTAL_COMPLETE

Incremental analysis complete.
