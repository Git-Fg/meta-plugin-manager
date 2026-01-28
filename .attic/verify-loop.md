---
name: verify-loop
description: "Execute 6-phase verification loop for comprehensive quality assurance. Runs: build → type → lint → test → security → diff gates sequentially."
disable-model-invocation: true
---

<mission_control>
<objective>Execute 6-phase verification loop (build → type → lint → test → security → diff)</objective>
<success_criteria>All gates pass sequentially, verification complete, exit code reflects result</success_criteria>
</mission_control>

<interaction_schema>
build_gate → type_gate → lint_gate → test_gate → security_gate → diff_gate
</interaction_schema>

# Verify Loop Command

Execute the comprehensive 6-phase verification loop to validate code quality.

## What This Does

Runs all 6 verification gates sequentially:

1. **Build Gate** - Verifies project builds successfully
2. **Type Gate** - Verifies type safety
3. **Lint Gate** - Verifies code style and quality
4. **Test Gate** - Verifies tests pass with 80%+ coverage
5. **Security Gate** - Verifies no security issues
6. **Diff Gate** - Reviews changes for potential issues

## Execution

```bash
.claude/scripts/gates/verification-loop.sh
```

## Exit Codes

- **0**: All gates passed (or passed with warnings)
- **1**: One or more gates failed
- **2**: Command not found

## Sequential Enforcement

Gates run in order. If a gate fails, verification stops immediately and reports the failure.

## Output

Results are logged to `~/.claude/homunculus/verification-log.jsonl` for analysis.

## Integration

This command integrates with:

- `verification-loop` skill - Full documentation
- `verification-before-completion` - Evidence-based completion
- `tdd-workflow` - Test-driven development validation

---

<critical_constraint>
MANDATORY: Execute all 6 gates sequentially - no skipping
MANDATORY: Stop immediately on first gate failure - report and halt
MANDATORY: Log results to verification-log.jsonl for analysis
MANDATORY: Exit code must reflect actual gate status (0=pass, 1=fail)
No exceptions. Sequential enforcement ensures comprehensive quality gates.
</critical_constraint>
