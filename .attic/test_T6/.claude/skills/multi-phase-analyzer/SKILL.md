---
name: multi-phase-analyzer
description: "Orchestrate multi-phase analysis with subagent and skill"
context: fork
agent: Plan
allowed-tools: Task, Skill, Read, Bash
---

# Multi-Phase Analyzer

Execute multi-phase analysis:

## PHASE_1

Spawn subagent for codebase exploration

## PHASE_2

Call forked skill for vulnerability scanning

## PHASE_3

Aggregate findings from all phases

## MULTI_PHASE_COMPLETE

Multi-phase analysis completed successfully.
