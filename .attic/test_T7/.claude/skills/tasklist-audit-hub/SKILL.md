---
name: tasklist-audit-hub
description: "Orchestrate audit using TaskList for coordination"
context: fork
agent: Plan
allowed-tools: Task, TaskCreate, Skill, Read
---

# TaskList Audit Hub

Execute hub-and-spoke audit:

## HUB_CREATION

Create TaskList for audit coordination

## WORKER_DELEGATION

Each task calls forked audit skill

## AGGREGATION

Wait for all audits, generate report

## AUDIT_HUB_COMPLETE

Audit hub completed successfully.
