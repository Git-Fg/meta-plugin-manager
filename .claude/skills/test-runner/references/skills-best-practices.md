# Skills Best Practices

This reference covers best practices for skill development and usage in testing workflows.

## Skills Best Practices

### When to Use Scripts

If you need to perform complex operations repeatedly, create a simple helper script:

**Good candidates for scripting**:
- Complex JSON transformations
- Batch file operations
- Repeated validation logic
- Data aggregation tasks

**Script organization**:
- Keep scripts in a scripts/ subdirectory
- Make them simple and focused
- Document what each script does
- Test scripts independently

**Natural language first**:
- Prefer clear instructions over complex scripts
- Only use scripts when operations are repetitive
- Make scripts optional, not required

### Progressive Disclosure

**Tier 1** (213 lines): SKILL.md - Quick start, examples, workflows
**Tier 2** (references/): Deep documentation by domain
- json-management.md - JSON operations
- analysis-engine.md - Verification logic
- autonomy-testing.md - Scoring methodology
- And 7 more specialized guides

**Tier 3** (scripts/): Implementation details
- analyze_tools.sh - Verification logic

### Skill Composition Patterns

**Chain Multiple Skills**:
```
test-runner → toolkit-quality-validator → skills-architect
(Execute)    → (Validate)                 → (Refine)
```

**Parallel Execution**:
```
test-runner (fork) → Worker A (fork) → Aggregate results
                    → Worker B (fork)
                    → Worker C (fork)
```

**Context Isolation**:
```
Regular Skill → Forked test-runner → Isolated execution
             → Returns to caller
```

**Agent Integration**:
```
test-runner (context: fork, agent: Explore)
→ Research capabilities with subagent tools
→ Returns structured findings
```

### Autonomy Standards

**Required for PASS**:
- Autonomy score ≥80%
- All completion markers present
- NDJSON structure valid (3 lines)
- No unexpected errors

**Recommended**:
- Autonomy score ≥90%
- 0 permission denials (100% autonomy)
- All validation criteria met
- Clear findings documented
