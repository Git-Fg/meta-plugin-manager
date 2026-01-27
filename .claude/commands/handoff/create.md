---
name: handoff
description: Create structured handoff document for pausing work and resuming in fresh context. Preserves task boundaries, work completed, work remaining, and critical context.
disable-model-invocation: true
allowed-tools: ["Read", "Write", "Bash", "TaskList"]
---

# Handoff: Context Preservation

Create structured handoff documents for seamless continuation of work across different conversation contexts.

## What This Command Does

Generate a comprehensive handoff document that preserves:
- Original task and objectives
- Work completed with precise locations
- Work remaining with priorities
- Critical context and decisions
- Current state of deliverables

**Key Innovation**: Pause work at any point and resume in fresh context without losing progress or context.

## How It Works

### Phase 1: Analyze Current State

Gather current context by examining:

```
**State Analysis:**
1. Read conversation history (implicit in context)
2. Check TaskList for pending/completed work
3. Identify files modified during session
4. Note decisions made and approaches tried
5. Catalog blockers or issues encountered
```

**Recognition**: "What would a fresh context need to know to continue this work?"

### Phase 2: Generate Handoff Document

Create structured YAML document with this EXACT format:

#### Required Format

```yaml
---
date: YYYY-MM-DD
session: {session-name}
status: complete|partial|blocked
outcome: SUCCEEDED|PARTIAL_PLUS|PARTIAL_MINUS|FAILED
---

goal: {What this session accomplished - shown in statusline}
now: {What next session should do first - shown in statusline}
test: {Command to verify this work, e.g., pytest tests/test_foo.py}

done_this_session:
  - task: {First completed task}
    files: [{file1.py}, {file2.py}]
  - task: {Second completed task}
    files: [{file3.py}]

blockers: [{any blocking issues}]

questions: [{unresolved questions for next session}]

decisions:
  - {decision_name}: {rationale}

findings:
  - {key_finding}: {details}

worked: [{approaches that worked}]

failed: [{approaches that failed and why}]

next:
  - {First next step}
  - {Second next step}

files:
  created: [{new files}]
  modified: [{changed files}]
```

**CRITICAL**: Use EXACTLY this YAML format. Do NOT deviate or use alternative field names.

The `goal:` and `now:` fields are shown in the statusline - they MUST be named exactly this.

**Field guide:**
- `goal:` + `now:` - REQUIRED, shown in statusline
- `done_this_session:` - What was accomplished with file references
- `decisions:` - Important choices and rationale
- `findings:` - Key learnings
- `worked:` / `failed:` - What to repeat vs avoid
- `next:` - Action items for next session

DO NOT use alternative field names like `session_goal`, `objective`, `focus`, `current`, etc.

### Phase 3: Save Handoff

Save to standardized location:

```bash
# Create handoff directory
mkdir -p .agent/handoffs

# Save with timestamp
HANDOFF_FILE=".agent/handoffs/$(date +%Y-%m-%d_%H-%M)-[task-name].yaml"
```

**File naming**: `YYYY-MM-DD_HH-MM-[descriptive-name].yaml`

**Recognition**: "Is the handoff file name descriptive enough to identify it later?"

### Phase 4: Resume from Handoff

When resuming work:

```bash
# List available handoffs
ls -la .agent/handoffs/

# Load specific handoff
# @ .agent/handoffs/[file].yaml
```

**Resume process**:
1. Read handoff YAML file completely
2. Understand goal and next steps
3. Identify immediate next action
4. Execute step 1 from "next:" section
5. Update handoff as work progresses

## Handoff Structure Examples

### Example 1: Component Creation

```yaml
---
date: 2026-01-26
session: jwt-auth
status: partial
outcome: PARTIAL_PLUS
---

goal: Implemented JWT authentication middleware and login/logout endpoints
now: Fix failing integration test for concurrent login scenarios
test: pytest tests/auth.test.ts -v

done_this_session:
  - task: Created JWT validation middleware
    files: [middleware/auth.ts:1-45]
  - task: Implemented login/logout endpoints
    files: [routes/auth.ts:1-80]
  - task: Added password hashing with bcrypt
    files: [models/user.ts:25-40]
  - task: Wrote integration tests
    files: [tests/auth.test.ts:1-120]

blockers: []

questions: [Should we use refresh tokens or just extend JWT expiration?]

decisions:
  - bcrypt_password_hashing: "Industry standard, proven security"
  - jwt_expiration_24h: "Balance between security and UX"
  - http_only_cookie: "Prevents XSS attacks"

findings:
  - localStorage_xss_risk: "Client-side storage vulnerable to XSS attacks"
  - session_scalability: "Sessions don't scale as well as JWT for stateless auth"

worked: [bcrypt for hashing, HTTP-only cookies, stateless JWT validation]

failed: [localStorage for token storage, session-based auth for scalability]

next:
  - Add password reset functionality
  - Implement refresh token rotation
  - Fix failing integration test in tests/auth.test.ts:95-120

files:
  created: [tests/auth.test.ts]
  modified: [middleware/auth.ts, routes/auth.ts, models/user.ts]
```

### Example 2: Bug Fix

```yaml
---
date: 2026-01-26
session: payment-race-condition
status: partial
outcome: PARTIAL_PLUS
---

goal: Added idempotency keys and button disable logic to prevent duplicate charges
now: Create load test for idempotency key generation under concurrent requests
test: Load test with 100 concurrent payment requests

done_this_session:
  - task: Added idempotency key checking
    files: [services/payment.ts:50-85]
  - task: Implemented button disabling logic
    files: [controllers/checkout.ts:120-145]

blockers: []

questions: [What load testing framework should we use?]

decisions:
  - idempotency_keys: "Standard pattern for preventing duplicates"
  - client_side_button_disable: "Provides immediate user feedback"

findings:
  - race_condition_window: "~200ms between click and charge"
  - uuid_v4_client_side: "Sufficient uniqueness for idempotency keys"

worked: [idempotency pattern, client-side prevention]

failed: [database unique constraints, Redis locks]

next:
  - Create load test for idempotency key generation
  - Add integration test for duplicate payment scenario
  - Add monitoring for idempotency key collisions

files:
  created: []
  modified: [services/payment.ts, controllers/checkout.ts]
```

### Example 3: Feature Implementation

```yaml
---
date: 2026-01-26
session: user-dashboard-feature
status: complete
outcome: SUCCEEDED
---

goal: Implemented user dashboard with profile editing and settings
now: Ready for user testing and feedback collection
test: npm test -- --testNamePattern="dashboard"

done_this_session:
  - task: Created dashboard UI components
    files: [src/components/Dashboard.tsx, src/components/ProfileEditor.tsx]
  - task: Implemented API endpoints for profile updates
    files: [src/api/profile.ts, src/routes/profile.ts]
  - task: Added form validation and error handling
    files: [src/validators/profile.ts]
  - task: Wrote comprehensive tests
    files: [tests/dashboard.test.tsx, tests/profile.api.test.ts]

blockers: []

questions: []

decisions:
  - react_hook_form: "Better performance than formik for large forms"
  - zod_validation: "Type-safe validation with runtime checking"

findings:
  - components_composition: "Breaking into smaller components improved testability"
  - api_design: "RESTful endpoints easier to maintain than GraphQL for this use case"

worked: [component composition, RESTful API design, Zod validation]

failed: []

next:
  - Deploy to staging for user testing
  - Collect feedback on dashboard UX
  - Implement remaining settings tabs

files:
  created: [src/components/Dashboard.tsx, src/components/ProfileEditor.tsx, tests/dashboard.test.tsx]
  modified: [src/api/profile.ts, src/routes/profile.ts, src/validators/profile.ts]
```

## Best Practices

### When Creating Handoffs
- Be specific about file locations (use file:line format)
- Document WHY decisions were made, not just WHAT
- Include dead ends to avoid repeating mistakes
- Prioritize remaining work clearly
- Make the next step unambiguous

### When Resuming from Handoffs
- Read the ENTIRE handoff before acting
- Understand what was tried and why
- Start with the "Next Immediate Step"
- Update the handoff as work progresses
- Archive completed handoffs

### What to Include
- Precise file locations (path:line format)
- Context for decisions (not just decisions themselves)
- Dead ends and why they failed
- Dependencies between tasks
- Current state of deliverables

### What to Exclude
- Entire file contents (just reference locations)
- Obvious information (focus on non-obvious context)
- Conversation history (focus on outcomes)
- Irrelevant tangents (stay focused on task)

## Integration with Token Management

Handoff is auto-triggered at 10% token remaining:

```bash
# Check token usage periodically
TOKENS_USED=$(estimate_token_usage)
TOKENS_TOTAL=$(context_window_size)
PERCENT_REMAINING=$((100 - (TOKENS_USED * 100 / TOKENS_TOTAL)))

if [ $PERCENT_REMAINING -le 10 ]; then
  echo "WARNING: At 10% tokens. Creating handoff..."
  /handoff
fi
```

**Recognition**: "Should I create a handoff before context becomes limiting?"

## Handoff Archiving

After work completes, archive handoffs:

```bash
# Archive completed handoffs
ARCHIVE_PATH=".agent/handoffs/archive/$(date +%Y/%m)/"
mkdir -p "$ARCHIVE_PATH"
mv .agent/handoffs/[file].yaml "$ARCHIVE_PATH/"
```

**Archive structure**: `.agent/handoffs/archive/YYYY/MM/[file].yaml`

## Related Commands

This command integrates with:
- `/create-prompt` - Meta-prompting for structured work
- `/run-prompt` - Executing in fresh contexts
- Task tool - Context for TaskList state

## Arguments

First argument: Handoff name/description (optional)

```
/handoff                                    # Auto-generate name from context
/handoff "User authentication progress"     # Specific handoff name
```

## Recognition Questions

Before creating handoff, ask:
- "Is all critical work documented?"
- "Are file locations precise?"
- "Is the next step clear and unambiguous?"
- "Would a fresh context understand everything needed?"

**Trust intelligence** - Good handoffs enable seamless context switches. Bad handoffs cause confusion and repeated work.

**Remember**: The handoff is for a FRESH context that has NO memory of this conversation. Include everything they need.
