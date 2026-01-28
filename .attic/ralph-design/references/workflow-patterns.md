# Ralph CLI: Workflow Patterns

Detailed workflow examples and patterns for common Ralph CLI use cases.

## Workflow Patterns by Category

| Category | Workflows |
|----------|-----------|
| **Getting Started** | Preset Initialization, First Run |
| **Development** | Feature Development, Debugging, Refactoring |
| **Testing** | Single Test, Batch Test, Parallel Test |
| **Validation** | Code Review, Confession Loop, Adversarial Review |
| **Monitoring** | Event Tracking, Session Recording, Loop Management |
| **Recovery** | State Injection, Checkpoint Resume, Error Diagnosis |

## Getting Started Workflows

### Workflow: Preset Initialization

**Use when**: Starting new project with proven patterns

```bash
# 1. List available presets
ralph init --list-presets

# Output shows 24+ presets including:
# - feature: Standard feature development
# - debug: Bug investigation
# - review: Code review workflow
# - docs: Documentation generation
# - confession-loop: Confidence-aware completion
# - adversarial-review: Security review
# - tdd-red-green: Test-driven development
# - mob-programming: Collaborative development

# 2. Initialize from preset
ralph init --preset feature

# 3. Review generated configuration
cat ralph.yml

# 4. Customize if needed (light edits only)
# Edit hat instructions, event names, quality gates

# 5. Create PROMPT.md with task
cat > PROMPT.md <<'EOF'
# Requirements

Implement user authentication with JWT tokens.

# Constraints

- Use PostgreSQL for user storage
- Tokens expire after 24 hours
- Password must be bcrypt hashed
- Test coverage >80%

# Success Criteria

- [ ] Login endpoint returns valid JWT
- [ ] Logout invalidates token
- [ ] Protected routes require valid token
- [ ] All tests pass
- [ ] Lint passes
EOF

# 6. Run orchestration
ralph run
```

**Key points**:
- Always start from preset (proven patterns)
- Review generated config before customizing
- Use PROMPT.md for task specification
- Let Ralph handle orchestration

### Workflow: Custom Configuration

**Use when**: Preset doesn't match requirements

```bash
# 1. Start with closest preset
ralph init --preset feature

# 2. Edit ralph.yml for custom needs
# - Add/remove hats
# - Modify triggers/publishes
# - Adjust quality gates
# - Change completion promise

# 3. Validate configuration
ralph run --dry-run

# 4. If dry-run succeeds, run for real
ralph run
```

## Development Workflows

### Workflow: Feature Development

**Use when**: Building new functionality

```bash
# 1. Initialize from feature preset
ralph init --preset feature

# 2. Create detailed PROMPT.md
cat > PROMPT.md <<'EOF'
# Requirements

Build user profile management system with:
- Profile creation
- Profile updates
- Profile viewing
- Avatar upload

# Constraints

- Use existing user auth system
- Avatars stored in S3
- Profile data in PostgreSQL
- API versioning: /v1/profile

# Success Criteria

- [ ] All CRUD operations work
- [ ] Avatar upload succeeds
- [ ] API returns proper error codes
- [ ] Integration tests pass
- [ ] API documentation updated
EOF

# 3. Run with session recording for validation
ralph run --record-session .ralph/session.jsonl

# 4. Monitor progress
ralph events --last 20

# 5. After completion, validate
cat .ralph/session.jsonl | jq -s 'map(select(.type == "tool_use")) | length'
```

### Workflow: Debug Session

**Use when**: Investigating and fixing bugs

```bash
# 1. Initialize from debug preset
ralph init --preset debug

# 2. Create PROMPT.md with bug description
cat > PROMPT.md <<'EOF'
# Bug Report

Login endpoint returns 500 error when user has special characters in password.

# Error Details

Endpoint: POST /api/v1/auth/login
Error: Internal Server Error
Log: "unhandled exception in password validation"

# Environment

- Production environment
- PostgreSQL database
- Node.js backend

# Expected Behavior

Should accept passwords with special characters (@, #, $, etc.)
Should return proper validation error if password invalid

# Success Criteria

- [ ] Bug identified and root cause found
- [ ] Fix implemented
- [ ] Tests added for edge cases
- [ ] All tests pass
EOF

# 3. Run debug orchestration
ralph run --record-session .ralph/debug-session.jsonl

# 4. Monitor hypothesis generation
ralph events --topic "hypothesis"

# 5. Review fix implementation
ralph events --topic "fix"

# 6. Validate fix worked
cat .ralph/debug-session.jsonl | jq -s 'map(select(.type == "message")) | .[-5:]'
```

### Workflow: Refactoring

**Use when**: Improving existing code structure

```bash
# 1. Initialize from refactor preset
ralph init --preset refactor

# 2. Create PROMPT.md with refactoring goals
cat > PROMPT.md <<'EOF'
# Refactoring Goals

Refactor user service to:
- Separate concerns (auth vs profile)
- Improve testability
- Reduce coupling

# Current Issues

- User service handles auth and profile (600+ lines)
- Hard to test (too many responsibilities)
- Direct database access everywhere

# Target Architecture

- AuthService: login, logout, token validation
- ProfileService: profile CRUD
- Repository layer: database access abstraction
- Dependency injection for testing

# Constraints

- Maintain backward compatibility
- All existing tests must pass
- No API changes during refactor

# Success Criteria

- [ ] Services separated by concern
- [ ] Tests pass for each service
- [ ] Integration tests pass
- [ ] Code coverage maintained
- [ ] API compatibility verified
EOF

# 3. Run with expand-migrate-contract pattern
ralph run --record-session .ralph/refactor-session.jsonl

# 4. Monitor refactoring phases
ralph events --topic "expand"    # Create new alongside old
ralph events --topic "migrate"   # Switch to new implementation
ralph events --topic "contract"  # Remove old code

# 5. Verify backward compatibility
grep -E "API.*compat" .ralph/refactor-session.jsonl
```

## Testing Workflows

### Workflow: Single Component Test

**Use when**: Testing individual skill/command/hook

```bash
# 1. Initialize from minimal preset
ralph init --preset feature-minimal

# 2. Create PROMPT.md with test requirements
cat > PROMPT.md <<'EOF'
# Test Requirements

Test the git-diff skill for correctness.

# Test Cases

1. Basic diff: Show changes between commits
2. Path filtering: Show changes for specific file
3. Context lines: Control diff context
4. Format: Parseable JSON output

# Success Criteria

- [ ] All test cases pass
- [ ] Tool usage verified in session
- [ ] No errors in session log
- [ ] Component loaded successfully
EOF

# 3. Run test orchestration
ralph run --record-session .ralph/test-session.jsonl

# 4. Validate component loaded
cat .ralph/test-session.jsonl | jq -r '.content' | grep -i "skill"

# 5. Verify tool usage
cat .ralph/test-session.jsonl | jq -s 'map(select(.type == "tool_use")) | length'

# 6. Check for errors
cat .ralph/test-session.jsonl | jq -s 'map(select(.type == "error"))'
```

### Workflow: Parallel Batch Testing

**Use when**: Testing multiple components simultaneously

```bash
# 1. Start with manual merge control
ralph run --no-auto-merge -p "Test all skills in .claude/skills/"

# 2. Monitor all spawned loops
ralph loops list

# Output shows:
# LOOP_ID           STATUS      WORKTREE
# ralph-0126-ab12   running     /path/to/worktree1
# ralph-0126-cd34   running     /path/to/worktree2
# ralph-0126-ef56   completed   /path/to/worktree3

# 3. Monitor specific loop
ralph loops logs ralph-0126-ab12 -f

# 4. Review changes before merging
ralph loops diff ralph-0126-ab12

# 5. Merge successful loops individually
for loop in $(ralph loops list | grep completed | awk '{print $1}'); do
  echo "Reviewing $loop"
  ralph loops diff $loop
  read -p "Merge $loop? (y/n) " answer
  if [ "$answer" = "y" ]; then
    ralph loops merge $loop
  else
    ralph loops discard $loop -y
  fi
done

# 6. Clean up stale loops
ralph loops prune
```

**Benefits**:
- True isolation (each component in separate worktree)
- Parallel execution (faster completion)
- Selective merging (keep only what passes)
- Clean rollback (discard removes worktree)

## Validation Workflows

### Workflow: Code Review

**Use when**: Reviewing code changes before merge

```bash
# 1. Initialize from review preset
ralph init --preset review

# 2. Create PROMPT.md with review scope
cat > PROMPT.md <<'EOF'
# Review Scope

Review PR #123: User authentication implementation

# Files Changed

- src/auth/jwt.ts (new)
- src/auth/login.ts (new)
- src/auth/middleware.ts (new)
- tests/auth.test.ts (new)

# Review Focus Areas

- Security: Token validation, password hashing
- Error handling: Proper error responses
- Testing: Coverage of edge cases
- Code quality: Type safety, clarity
- Documentation: API docs updated

# Success Criteria

- [ ] Security issues identified (if any)
- [ ] Code quality verified
- [ ] Tests reviewed for completeness
- [ ] Documentation checked
- [ ] Approval/rejection decision made
EOF

# 3. Run review orchestration
ralph run --record-session .ralph/review-session.jsonl

# 4. Monitor review phases
ralph events --topic "security"
ralph events --topic "quality"
ralph events --topic "tests"

# 5. Review final decision
ralph events --topic "approval" --last 5
```

### Workflow: Confession Loop

**Use when**: Validation with uncertainty tracking

```bash
# 1. Initialize from confession-loop preset
ralph init --preset confession-loop

# 2. Create PROMPT.md with validation requirements
cat > PROMPT.md <<'EOF'
# Validation Requirements

Validate the payment processing system for production readiness.

# Validation Scope

- Transaction correctness
- Error handling
- Edge cases
- Security concerns
- Performance characteristics

# Confession Areas

Be explicit about uncertainties:
- Assumptions made
- Tests not run
- Edge cases not covered
- Potential issues suspected

# Success Criteria

- [ ] All tests pass
- [ ] Confessions recorded for uncertainties
- [ ] Confidence score calculated
- [ ] Production readiness decision made
EOF

# 3. Run confession loop
ralph run --record-session .ralph/confession-session.jsonl

# 4. Monitor confessions
ralph events --topic "confession"

# 5. Review confession memories
ralph tools memory search --tags confession --format json

# 6. Check final confidence
ralph events --last 5 | grep "confidence"
```

### Workflow: Adversarial Review

**Use when**: Security-focused validation

```bash
# 1. Initialize from adversarial-review preset
ralph init --preset adversarial-review

# 2. Create PROMPT.md with security scope
cat > PROMPT.md <<'EOF'
# Security Review Scope

Review user authentication system for vulnerabilities.

# Attack Vectors to Test

1. SQL injection in login
2. JWT token manipulation
3. Password brute force
4. Session hijacking
5. CSRF attacks
6. XSS in profile fields

# Red Team Focus

- Find exploitable vulnerabilities
- Test authentication bypasses
- Attempt privilege escalation
- Test input validation

# Blue Team Focus

- Verify defenses are in place
- Check logging and monitoring
- Validate rate limiting
- Review error handling

# Success Criteria

- [ ] All attack vectors tested
- [ ] Vulnerabilities documented
- [ ] Defenses verified
- [ ] Remediation plan created (if needed)
EOF

# 3. Run adversarial review
ralph run --record-session .ralph/security-session.jsonl

# 4. Monitor red/blue team interactions
ralph events --topic "red.team"
ralph events --topic "blue.team"

# 5. Review findings
ralph events --topic "vulnerability" --format json
```

## Monitoring Workflows

### Workflow: Event-Driven Monitoring

**Use when**: Real-time phase tracking

```bash
# Terminal 1: Run orchestration
ralph run --record-session .ralph/session.jsonl

# Terminal 2: Monitor specific phase
watch -n 5 'ralph events --topic "design.tests" --last 5'

# Terminal 3: Monitor task queue
watch -n 5 'ralph tools task ready'

# Terminal 4: Monitor session growth
watch -n 5 'wc -l .ralph/session.jsonl'
```

**Key events to monitor**:

| Phase | Topic Pattern | Purpose |
|-------|---------------|---------|
| Initialization | `workflow.*` | Setup and planning |
| Design | `design.*` | Test/spec creation |
| Execution | `execution.*` | Building/implementing |
| Validation | `validation.*` | Testing/verification |
| Completion | `LOOP_COMPLETE` | Workflow finished |

### Workflow: Iteration Debugging

**Use when**: Hat switching issues

```bash
# 1. Check iteration counts
grep -c "_meta.loop_start\|ITERATION" .ralph/events.jsonl
grep -c "bus.publish" .ralph/events.jsonl

# Expected: iterations ≈ events (one event per iteration)
# Bad: 2-3 iterations but 5+ events (same-iteration switching)

# 2. Find same-iteration switching
ralph events --format json | jq -r '.iteration' | sort | uniq -c | grep -v '^ *1'

# 3. Investigate specific iteration
ralph events --iteration 15

# 4. Check hat sequence
ralph events --format json | jq '.[] | {iteration, topic}' | head -20
```

## Recovery Workflows

### Workflow: State Injection Recovery

**Use when**: Recoverable errors during execution

```bash
# 1. Diagnose via event filtering
ralph events --last 20 --topic "execution"

# 2. Parse session for root cause
cat .ralph/session.jsonl | jq -s 'map(select(.type == "error"))'

# 3. Identify stuck task
ralph tools task list

# Output:
# TASK_ID           STATUS      TITLE
# task-abc123       blocked     Implement feature X

# 4. Inject fix task
ralph tools task add "Fix: Missing import causing compile error" -p 1 --blocked-by task-abc123

# 5. Monitor recovery
ralph events --last 10

# 6. Verify task processed
ralph tools task list | grep task-abc123
```

**When to inject vs restart**:

| Situation | Action |
|-----------|--------|
| Deadlock (active iteration, no events) | Inject fix task |
| Hat stuck waiting for condition | Inject task to satisfy condition |
| Syntax/config error | Inject fix |
| Hat instructions broken | Kill and restart |
| Configuration prevents startup | Kill and restart |
| No progress after 90s | Kill and restart |

### Workflow: Checkpoint Resume

**Use when**: Resuming interrupted workflow

```bash
# 1. Check for existing checkpoint
ls -la .agent/scratchpad.md

# 2. Review checkpoint content
cat .agent/scratchpad.md

# 3. Resume from checkpoint
ralph run --continue --no-tui --record-session .ralph/resume-session.jsonl

# 4. Monitor resumed execution
ralph events --last 20

# 5. Validate continuation
grep -c "ITERATION" .ralph/events.jsonl
```

## Memory Accumulation Workflows

### Workflow: Pattern Discovery

**Use when**: Learning codebase patterns

```bash
# After discovering a pattern
ralph tools memory add "pattern: API routes use kebab-case, snake_case for DB columns" -t pattern --tags api,database

# After architectural decision
ralph tools memory add "decision: Chose PostgreSQL over SQLite for concurrent writes" -t decision --tags database,architecture

# After solving recurring problem
ralph tools memory add "fix: ECONNREFUSED on :5432 means run docker-compose up" -t fix --tags docker,postgres

# After learning project-specific knowledge
ralph tools memory add "context: /legacy folder is deprecated, use /v2 endpoints" -t context --tags api,migration
```

### Workflow: Context Priming

**Use when**: Starting similar work

```bash
# 1. Search for prior patterns
ralph tools memory search "api" --tags pattern

# 2. Prime context before work
ralph tools memory prime -t pattern --tags api --budget 1500

# 3. Review recent confessions
ralph tools memory prime -t context --tags confession --recent 7

# 4. Check prior fixes
ralph tools memory search -t fix "postgres"
```

## Complete Example: Feature to Production

```bash
# Phase 1: Setup
ralph init --preset feature
cat > PROMPT.md <<'EOF'
# Requirements
Build user notification system (email + SMS)

# Constraints
- Use existing user service
- Email via SendGrid
- SMS via Twilio
- Queue for async processing

# Success Criteria
- [ ] Email notifications work
- [ ] SMS notifications work
- [ ] Queue processing verified
- [ ] Tests pass
- [ ] API documented
EOF

# Phase 2: Development with recording
ralph run --record-session .ralph/feature-session.jsonl

# Phase 3: Monitor progress
watch -n 10 'ralph events --last 10'

# Phase 4: Validate implementation
cat .ralph/feature-session.jsonl | jq -s 'map(select(.type == "tool_use")) | length'

# Phase 5: Code review
ralph init --preset review
# Update PROMPT.md for review scope
ralph run --record-session .ralph/review-session.jsonl

# Phase 6: Security validation
ralph init --preset adversarial-review
# Update PROMPT.md for security scope
ralph run --record-session .ralph/security-session.jsonl

# Phase 7: Accumulate learnings
ralph tools memory add "pattern: Notification system uses queue for async processing" -t pattern --tags notifications,queue
ralph tools memory add "fix: SendGrid rate limit requires batch size <100" -t fix --tags email,sendgrid

# Phase 8: Deploy (if preset available)
ralph init --preset deploy
# Update PROMPT.md for deployment
ralph run
```
