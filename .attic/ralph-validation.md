# Ralph: Staged Validation Workflow

Ralph is the component development orchestrator that implements **Test-Driven Development + Confession Loop** for building portable components.

## The Staging Architecture

**Ralph creates validation artifacts in `ralph_validated/` rather than deploying directly to `.claude/`.** This creates a safer, auditable workflow.

```
ralph_validated/
├── YYYY-MM-DD_HHMM-task-name/          # Unique Run Container
│   ├── artifacts/                      # The validated component(s)
│   │   └── .claude/skills/my-skill/
│   ├── evidence/                       # Proof of work
│   │   ├── blueprint.yaml              # Architectural contract
│   │   ├── test_spec.json              # Test specification
│   │   └── raw_execution.log           # Execution telemetry
│   ├── REPORT.md                       # Validation certificate
│   └── _INDEX.txt                      # Navigation guide
```

## Workflow

### 1. Create
```bash
ralph run -p "create a skill for X"
```
- Ralph generates blueprint in `specs/`
- Tests designed and executed
- Validation report generated
- Artifacts staged to `ralph_validated/<timestamp>/`

### 2. Review
```bash
cat ralph_validated/<timestamp>/REPORT.md
```
- Read validation results
- Check confidence score (must be >= 80)
- Review gap analysis and recommendations

### 3. Approve (or Reject)
```bash
# If satisfied: move to production
mv ralph_validated/<timestamp>/artifacts/.claude/* .claude/

# If unsatisfied: delete, no changes made
rm -rf ralph_validated/<timestamp>/
```

## The Hat Architecture

Ralph uses specialized "hats" for each workflow phase:

| Hat | Responsibility | Output |
|-----|---------------|--------|
| **Coordinator** | Mode detection, Run ID generation, Blueprint creation | `specs/blueprint.yaml` |
| **Test Designer** | Test specification, security test generation | `test_spec.json` |
| **Executor** | Test execution, log capture | `raw_execution.log` |
| **Validator** | Evidence analysis, report generation | `VALIDATION_REPORT.md` |
| **Confession Handler** | Staging sequence, workflow completion | `ralph_validated/<RUN_ID>/` |

## Validation Report Structure

Each `REPORT.md` includes:
1. **Executive Summary**: Component name, type, result, confidence score
2. **Verification Matrix**: Blueprint compliance, test results, portability checks
3. **Execution Telemetry**: Tools used, steps taken, autonomy score
4. **Gap Analysis**: What works, what needs improvement, deviations
5. **Recommendations**: Before production, future enhancements
6. **Evidence References**: Links to all supporting files

## Safety Features

- **No direct deployment**: All changes staged to isolated directory first
- **Full audit trail**: Every run preserves blueprint, specs, logs, and report
- **Manual approval**: User explicitly moves artifacts to production
- **Atomic operations**: Either full success or no changes
- **Rollback safety**: Delete staging directory if unsatisfied
