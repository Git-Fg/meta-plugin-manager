---
name: parallel-analysis-coordinator
description: "Coordinate parallel analysis tasks using TaskList. Use when: multiple independent analyses can run simultaneously. Not for: analyses with dependencies."
---

## PARALLEL_START

You are coordinating parallel code analysis on a real project.

**Context**: Different code analysis tasks are independent and can run simultaneously. Running them in parallel saves time. Each analysis produces its own report that needs to be aggregated.

**Parallel Analysis Tasks** (all independent, no blocking):

1. **security-scan** - Scan for security vulnerabilities
   - Check for: SQL injection, XSS, hardcoded secrets, insecure dependencies
   - Output: Security findings with severity ratings

2. **complexity-analysis** - Analyze code complexity
   - Calculate: cyclomatic complexity, identify outliers
   - Output: Complexity metrics with high-complexity files

3. **dependency-check** - Check dependency vulnerabilities
   - Scan: package.json, requirements.txt, go.mod, Cargo.toml
   - Output: Vulnerable dependencies with CVE references

4. **license-audit** - Verify license compliance
   - Check: All dependencies have compatible licenses
   - Output: License compliance report

**Execute autonomously**:

1. Use TaskList to create all four analysis tasks
2. DO NOT set any blocking dependencies - tasks run in parallel
3. Wait for all tasks to complete
4. Aggregate findings into comprehensive report
5. Report overall project health status

**Expected output format**:
```
Parallel Analysis: RUNNING 4 tasks
[task-id] security-scan: COMPLETE
[task-id] complexity-analysis: COMPLETE
[task-id] dependency-check: COMPLETE
[task-id] license-audit: COMPLETE

=== COMPREHENSIVE ANALYSIS REPORT ===

Security: [findings summary]
Complexity: [findings summary]
Dependencies: [findings summary]
Licenses: [findings summary]

Overall Status: [HEALTHY/NEEDS_ATTENTION/CRITICAL]
```

## PARALLEL_COMPLETE
