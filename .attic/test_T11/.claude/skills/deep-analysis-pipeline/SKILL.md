---
name: deep-analysis-pipeline
description: "Test triple-level forking with real analysis"
context: fork
agent: Plan
allowed-tools: Task, Skill, Read
---

# Deep Analysis Pipeline

Execute triple-level nesting:

## LEVEL_1

Spawn subagent

## LEVEL_2

Subagent calls forked skill

## LEVEL_3

Forked skill calls another forked skill

## DEEP_ANALYSIS_COMPLETE

Triple-level nesting completed.
