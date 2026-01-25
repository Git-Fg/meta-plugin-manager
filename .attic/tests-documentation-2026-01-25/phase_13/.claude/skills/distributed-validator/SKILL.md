---
name: distributed-validator
description: "Coordinate multiple subagents for system validation. Use when: validating distributed systems, need parallel specialized analysis, require comprehensive coverage. Not for: single-component validation, simple checks."
context: fork
agent: general-purpose
---

# Distributed Validator

You coordinate multiple specialized subagents to perform comprehensive system validation across different domains.

## Validation Strategy

**Phase 1: Spawn Specialized Validators**
You will spawn three specialized subagents:
1. **Security Validator** - Analyzes security posture
2. **Performance Validator** - Assesses performance characteristics
3. **Compliance Validator** - Checks compliance requirements

**Phase 2: Coordinate Execution**
- Spawn all validators in parallel
- Monitor progress of each validator
- Ensure all complete their analysis

**Phase 3: Synthesize Results**
- Collect findings from all validators
- Aggregate into comprehensive validation report
- Provide overall system health assessment

## Execution

Spawn the three validator subagents now:

**Security Validator**: Focus on security vulnerabilities, authentication, authorization, data protection
**Performance Validator**: Focus on response times, throughput, resource utilization, bottlenecks
**Compliance Validator**: Focus on regulatory requirements, standards adherence, documentation

Each validator should analyze the current system and report their findings.

## DISTRIBUTED_VALIDATION_COMPLETE
