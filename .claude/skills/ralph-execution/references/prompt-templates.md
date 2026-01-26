# Prompt Templates

Templates for Ralph inputs (PROMPT.md) and Claude instructions (invoking Ralph).

## Template Structure

All Ralph prompts follow the Requirements/Constraints/Success Criteria triad:

```markdown
# Task Title

Brief description of what needs to be accomplished.

## Requirements
- Specific requirement 1
- Specific requirement 2

## Constraints
- Any limitations or boundaries

## Success Criteria
- How to know the task is complete
```

---

## Part 1: Ralph PROMPT.md Templates

These are the content of the PROMPT.md file that Ralph consumes.

## Feature Implementation Template

```markdown
# Add User Authentication

Implement JWT-based authentication for the API.

## Requirements
- Login endpoint at POST /auth/login
- Token refresh at POST /auth/refresh
- Protected route middleware
- User model with email/password

## Constraints
- Use existing database schema
- No breaking changes to public API

## Success Criteria
- All tests pass
- Can obtain and use tokens via curl
```

## Bug Fix Template

```markdown
# Fix Memory Leak in User Service

Resolve memory leak causing service crashes after 24 hours.

## Requirements
- Identify root cause of memory leak
- Implement fix without breaking functionality
- Add monitoring to detect future leaks

## Constraints
- Cannot restart service during business hours
- Must maintain backward compatibility
- No new dependencies

## Success Criteria
- Memory usage stable over 48 hours
- All existing functionality works
- Monitoring alerts configured
```

## Refactor Template

```markdown
# Refactor Legacy Authentication Module

Modernize authentication system to use OAuth 2.0.

## Requirements
- Replace session-based auth with JWT
- Implement OAuth 2.0 provider integration
- Update all API endpoints
- Maintain existing user data

## Constraints
- Zero downtime during migration
- Support existing API consumers
- No breaking changes for 6 months

## Success Criteria
- All tests pass
- Performance maintained or improved
- Documentation updated
```

## Research Template

```markdown
# Research Database Migration Strategy

Evaluate options for migrating from MySQL 5.7 to PostgreSQL 13.

## Requirements
- Compare migration tools and methods
- Assess data consistency risks
- Evaluate performance implications
- Document rollback procedures

## Constraints
- Minimize downtime (<4 hours)
- Preserve all existing data
- No data corruption acceptable

## Success Criteria
- Detailed migration plan with timelines
- Risk assessment completed
- Performance benchmarks documented
- Rollback strategy validated
```

## Testing Template

```markdown
# Implement End-to-End Test Suite

Create comprehensive E2E tests for critical user workflows.

## Requirements
- Test login/logout flow
- Test payment processing
- Test data export functionality
- Test error handling

## Constraints
- Tests run in under 5 minutes
- Use existing test environment
- No production data exposure

## Success Criteria
- All critical paths tested
- Tests run reliably on CI/CD
- Coverage report shows >80%
```

## Template Selection Guide

**Choose template based on task type:**
- Feature work → Feature Implementation
- Bug fixing → Bug Fix
- Code changes → Refactor
- Investigation → Research
- Quality assurance → Testing

**Recognition:** Match template to task nature for optimal Ralph performance.

---

## Part 2: Claude-to-Ralph Invocation Templates

These are prompts you give to Claude Code to start and manage the Ralph process.

### Basic Start
```text
Run "ralph run --no-tui --verbose 2>&1 | tee .ralph/latest.log" in the background.
```

### Watchdog with Invariants
```text
Start Ralph in the background. Monitor the output for these invariants:
1. Iterations must increment.
2. No "FATAL" or "Traceback" errors.
3. Process must finish within 1000 iterations.

If an invariant is violated:
1. Stop the background task.
2. Analyze .ralph/latest.log.
3. Fix the issue and restart.
```

### Subagent Delegation
```text
Launch a subagent to manage this Ralph run:
1. Start "ralph run --max-iterations 500" in background.
2. Monitor logs every 30 seconds.
3. If you see "Out of Memory", restart with half the batch size.
4. Report back to me when done or if you can't fix it.
```

### Resume from Checkpoint
```text
Ralph crashed previously. Run "ralph run --continue --no-tui --verbose" in the background.
Watch to ensure it doesn't crash again at the same spot.
```

## Template Selection Guide

| Scenario | Ralph Template | Claude Strategy |
| :--- | :--- | :--- |
| **New Feature** | Feature Implementation | Background + Watchdog |
| **Simple Bug** | Bug Fix | Foreground (if fast) or Background |
| **Long Refactor** | Refactor | Subagent Delegation |
| **Research Task** | Research | Background + Periodic Status |
