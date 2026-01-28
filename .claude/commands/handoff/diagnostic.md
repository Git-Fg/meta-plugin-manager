---
name: handoff:diagnostic
description: Create comprehensive diagnostic handoff with complete problem analysis. Document all remarks, issues, incoherences, errors, difficulties, root cause analysis, user feedback, and behavior signals for debugging sessions.
disable-model-invocation: true
allowed-tools: Read, Write, Bash
---

<mission_control>
<objective>Create diagnostic handoff that captures EVERY problem, error, difficulty, user feedback, behavior signal, and behavioral issue encountered during work</objective>
<success_criteria>Diagnostic handoff saved to .claude/workspace/handoffs/diagnostic.yaml with complete problem analysis including user interactions and behavior signals</success_criteria>
</mission_control>

<interaction_schema>
archive_existing → gather_diagnostics → generate_yaml → save_handoff → confirm
</interaction_schema>

# Handoff: Diagnostic Mode

Create comprehensive diagnostic handoffs for debugging sessions, problem analysis, and issue tracking. **Captures not just technical issues but also user feedback and behavioral signals.**

## What This Command Does

Generate a diagnostic handoff document that captures:

- **Remarks** - All observations, notes, and general findings
- **Issues** - Current problems and blockers encountered
- **Incoherences** - Logical inconsistencies and contradictions found
- **Errors** - Exact error messages with stack traces and line numbers
- **Difficulties** - Challenges and obstacles faced during work
- **Diagnostics** - Root cause analysis and problem investigation
- **Workarounds** - Temporary fixes applied to continue progress
- **User Interactions** - All user requests, feedback, complaints, and signals
- **Behavior Signals** - Clues indicating Claude's behavioral issues, drift, or errors

**CRITICAL**: This command is for PROBLEM-SOLVING sessions. Use when debugging, investigating issues, troubleshooting, or when behavioral issues need to be captured.

## How It Works

### Phase 1: Archive Existing Diagnostic

Before creating a new diagnostic handoff, archive the existing one:

- `Bash: DIAGNOSTIC_FILE=".claude/workspace/handoffs/diagnostic.yaml" && [ -f "$DIAGNOSTIC_FILE" ] && mv "$DIAGNOSTIC_FILE" ".attic/diagnostic_$(date +%Y%m%d_%H%M%S).yaml"` → Archive with timestamp

### Phase 2: Gather Diagnostics

**MUST DOCUMENT EVERYTHING** - No detail is too small:

```
**Diagnostic Checklist:**
1. What went wrong? (issues)
2. What error messages appeared? (errors - verbatim)
3. Where did it fail? (file:line for every error)
4. What inconsistencies exist? (incoherences)
5. What obstacles blocked progress? (difficulties)
6. What did you discover? (remarks, findings, diagnostics)
7. What temporary fixes did you apply? (workarounds)
8. **CRITICAL: Did you use the relevant development skill?** (process check)
9. **CRITICAL: What did the USER say/signal?** (user_interactions)
10. **CRITICAL: What behavior signals indicate Claude issues?** (behavior_signals)
```

**Recognition**: "If I don't include this, will the next session understand the problem?"

### Phase 3: Generate Diagnostic Handoff

Create YAML document with this EXACT format:

```yaml
---
date: YYYY-MM-DD
session: { session-name }
status: complete|partial|blocked
outcome: SUCCEEDED|PARTIAL_PLUS|PARTIAL_MINUS|FAILED
severity: low|medium|high|critical
---
goal: { What this session was trying to accomplish }
now: { What the next session must do first }
test: { Command to reproduce or verify the issue }

done_this_session:
  - task: { What you attempted }
    files: [{ file1:line-line }, { file2:line }]

user_interactions:
  - type: request|feedback|complaint|question|clarification
    user_says: |
      { EXACT user message or signal - verbatim }
    context: { What triggered this user response }
    impact: { How this shaped the work direction }
    response: { How you responded to the user }
    resolution: { What the user accepted or rejected }

behavior_signals:
  - signal: repetition|direction_change|clarification_needed|assumption_error|drift
    description: { What behavior pattern you observed }
    evidence: { Specific example showing the signal }
    correction: { How you corrected the behavior }
    severity: low|medium|high
    note: { Why this matters for future sessions }

behavior_issues:
  - issue: { What Claude did wrong }
    context: { Situation where the issue occurred }
    manifestation: { How the issue manifested }
    impact: { Effect on work quality or progress }
    correction: { What was done to fix it }
    prevention: { How to prevent recurrence }

fixes:
  - issue: { Problem being fixed }
    approach: { How you fixed it }
    rationale: { Why this fix was chosen }
    effectiveness: { Whether it worked }
    alternatives: { Other approaches considered }

remarks:
  - { General observation 1 }
  - { General observation 2 }

issues:
  - { Problem description 1 }
  - { Problem description 2 }

incoherences:
  - description: { What contradicts what }
    source_1: { File/section claiming X }
    source_2: { File/section claiming NOT X }
    impact: { How this blocks progress }

errors:
  - message: |
      { Exact error message - verbatim }
    location: { file.ts:line }
    stack_trace: |
      { Stack trace if available }
    frequency: once|repeated|intermittent
    impact: low|medium|high|critical

difficulties:
  - { Challenge 1 - what blocked you }
  - { Challenge 2 }

diagnostics:
  - hypothesis: { What you thought was wrong }
    test: { How you tested it }
    result: { What you found }
    conclusion: { Actual root cause }

workarounds:
  - { Temporary fix applied 1 }
  - { Hack used to continue }

decisions:
  - { decision_name }: { rationale }

findings:
  - { key_finding }: { details }

worked:
  - { Approach that succeeded }

failed:
  - { Approach that failed and why }

next:
  - { Next diagnostic step 1 }
  - { Next diagnostic step 2 }

files:
  created: [{ new files }]
  modified: [{ changed files with line references }]
```

### Phase 4: Save Diagnostic Handoff

Save to standardized location:

- `Write: .claude/workspace/handoffs/diagnostic.yaml` → Save YAML content

**File location**: `.claude/workspace/handoffs/diagnostic.yaml`

**Archived location**: `.attic/diagnostic_YYYYMMDD_HHMMSS.yaml`

### Phase 5: Resume Diagnostic Session

When resuming diagnostic work:

- `Read: .claude/workspace/handoffs/diagnostic.yaml` → Read the diagnostic
- `Grep: "^goal:" .claude/workspace/handoffs/diagnostic.yaml | sed 's/^goal: //'` → Extract goal
- `Grep: "^now:" .claude/workspace/handoffs/diagnostic.yaml | sed 's/^now: //'` → Extract now

## Diagnostic Field Guide

| Field                | REQUIRED | Purpose                                |
| -------------------- | -------- | -------------------------------------- |
| `goal:`              | YES      | What you were trying to accomplish     |
| `now:`               | YES      | What must happen next (critical)       |
| `user_interactions:` | YES      | All user requests, feedback, signals   |
| `behavior_signals:`  | YES      | Claude behavioral drift or issues      |
| `behavior_issues:`   | YES      | Claude-specific errors and mistakes    |
| `fixes:`             | YES      | Applied fixes for issues               |
| `remarks:`           | YES      | All observations - nothing too trivial |
| `issues:`            | YES      | Every problem encountered              |
| `incoherences:`      | YES      | Any contradictions found               |
| `errors:`            | YES      | Exact messages with line numbers       |
| `difficulties:`      | YES      | All obstacles faced                    |
| `diagnostics:`       | YES      | Root cause analysis                    |
| `workarounds:`       | YES      | Temporary fixes applied                |
| `severity:`          | YES      | low / medium / high / critical         |

**CRITICAL**: Even if a field has no value, use `[]` - do NOT omit diagnostic fields.

## User Interactions Documentation Pattern

**CAPTURE EVERY USER SIGNAL** - User feedback reveals behavioral issues and expectation mismatches:

```yaml
user_interactions:
  - type: request|feedback|complaint|question|clarification|correction|clarification_needed
    user_says: |
      { EXACT user message - copy verbatim }
    context: { What led to this user response }
    impact: { How this shaped your work }
    response: { Your response to the user }
    resolution: { User's acceptance or rejection }
```

**What to capture:**

- **Requests** - Original task requests
- **Feedback** - User's reactions to your work
- **Complaints** - Expressions of dissatisfaction
- **Clarifications** - User explaining what they meant
- **Corrections** - User correcting your mistakes
- **Direction changes** - User changing the plan

## Behavior Signals Documentation Pattern

**IDENTIFY BEHAVIORAL DRIFT EARLY** - Signal patterns indicate Claude issues:

```yaml
behavior_signals:
  - signal: repetition|direction_change|clarification_needed|assumption_error|drift|hallucination|over_engineering|under_engineering
    description: { What behavioral pattern you observed }
    evidence: |
      { EXACT example showing the signal }
    correction: { How you corrected course }
    severity: low|medium|high
    note: { Why this matters for future sessions }
```

**Signal Types:**

| Signal                 | Description                                 |
| ---------------------- | ------------------------------------------- |
| `repetition`           | User repeating the same request             |
| `direction_change`     | User steering you back to the original goal |
| `clarification_needed` | You asked too many questions                |
| `assumption_error`     | You made wrong assumptions about intent     |
| `drift`                | You wandered from the original task         |
| `hallucination`        | You asserted something false                |
| `over_engineering`     | You added unnecessary complexity            |
| `under_engineering`    | You missed required features                |

## Behavior Issues Documentation Pattern

**DOCUMENT CLAUDE'S MISTAKES** - Understanding your errors prevents recurrence:

```yaml
behavior_issues:
  - issue: { What Claude did wrong }
    context: { Situation where the issue occurred }
    manifestation: { How the issue showed up }
    impact: { Effect on work quality/progress }
    correction: { What was done to fix it }
    prevention: { How to prevent recurrence }
```

## Fixes Documentation Pattern

**TRACK WHAT WORKED** - Capture applied fixes for knowledge transfer:

```yaml
fixes:
  - issue: { Problem description }
    approach: { How you fixed it }
    rationale: { Why this approach }
    effectiveness: { Success rating 1-10 }
    alternatives: { Other approaches considered }
```

## Diagnostic Example

### Example: Debugging MCP Server Failure

```yaml
---
date: 2026-01-28
session: mcp-perplexity-failure
status: blocked
outcome: PARTIAL_MINUS
severity: critical
---
goal: Integrate Perplexity MCP provider into LLM orchestrator
now: Fix Perplexity API connection - authentication failing with 401
test: pnpm test --testNamePattern="perplexity"

done_this_session:
  - task: Implemented Perplexity provider
    files: [src/providers/perplexity.ts:1-120]
  - task: Added integration tests
    files: [tests/providers/perplexity.test.ts:1-80]

remarks:
  - API endpoint appears to be `https://api.perplexity.ai/chat/completions`
  - Documentation mentions "application/json" content-type
  - Response structure differs from OpenAI format

issues:
  - Authentication failing with 401 Unauthorized
  - API returns "Invalid API key" but key is valid
  - Timeout issues when waiting for response

incoherences:
  - description: Auth header format contradiction
    source_1: Perplexity docs say "Bearer token"
    source_2: Error suggests key format issue
    impact: Cannot authenticate successfully

errors:
  - message: |
      Error: Request failed with status code 401
      at https://api.perplexity.ai/chat/completions
    location: src/providers/perplexity.ts:45
    stack_trace: |
      at PerplexityProvider.request (/src/providers/perplexity.ts:45:12)
      at LLMOrchestrator.query (/src/orchestrator/index.ts:89:8)
    frequency: repeated
    impact: critical
  - message: |
      Error: Request timeout after 30000ms
    location: src/providers/perplexity.ts:52
    stack_trace: |
      at Promise.race (/src/utils/timeout.ts:15:5)
    frequency: intermittent
    impact: medium

difficulties:
  - Perplexity API documentation is incomplete
  - No official TypeScript SDK available
  - Error messages don't indicate specific auth issue

diagnostics:
  - hypothesis: 401 caused by incorrect API key format
    test: Tested key in curl - worked successfully
    result: Key format works in curl but not in axios
    conclusion: Axios may be sending headers differently
  - hypothesis: Network or rate limiting
    test: Added timeout extension
    result: Some requests still timeout
    conclusion: May be rate limiting or server-side issue

workarounds:
  - Added 60 second timeout to prevent hanging
  - Added fallback to Gemini provider if Perplexity fails

decisions:
  - fallback_provider: "Switch to Gemini if Perplexity fails"
  - timeout_extension: "Increased timeout from 30s to 60s"

findings:
  - perplexity_auth: "API key works in curl but not in axios"
  - header_format: "Perplexity may use different auth header format"

worked: [axios request structure, error handling pattern, timeout wrapper]

failed: [current auth implementation - returns 401]

next:
  - Test Perplexity API with curl to isolate issue
  - Check axios vs curl header differences
  - Review Perplexity API docs for auth format
  - Consider using their Python SDK as reference

files:
  created: [src/providers/perplexity.ts, tests/providers/perplexity.test.ts]
  modified: [src/orchestrator/index.ts:80-95, src/utils/timeout.ts:1-30]
```

## Error Documentation Pattern

**MUST INCLUDE** for every error:

```yaml
errors:
  - message: |
      { EXACT error message - copy verbatim }
    location: { file.ts:line }
    stack_trace: |
      { Full stack trace if available }
    frequency: once|repeated|intermittent
    impact: low|medium|high|critical
```

## Incoherence Documentation Pattern

**MUST DOCUMENT** any logical inconsistency:

```yaml
incoherences:
  - description: { What contradicts what }
    source_1: { File/section claiming X }
    source_2: { File/section claiming NOT X }
    impact: { How this blocks progress }
```

## Root Cause Analysis Pattern

```yaml
diagnostics:
  - hypothesis: { What you thought was wrong }
    test: { How you tested it }
    result: { What you found }
    conclusion: { Actual root cause }
```

## Recognition Questions (CRITICAL)

Before saving diagnostic, ask:

- "Did I document EVERY error with exact messages?"
- "Are all file:line references precise?"
- "Is every issue traced to a root cause?"
- "Did I include all workarounds applied?"
- "Would a fresh session reproduce this issue from the diagnostic?"
- "Did I use `[]` for empty diagnostic fields?"
- "**CRITICAL: Did I capture EVERY user interaction?**"
- "**CRITICAL: Are all behavior signals documented?**"
- "**CRITICAL: Are Claude's mistakes documented in behavior_issues?**"
- "**CRITICAL: Are applied fixes tracked in fixes section?**"

<critical_constraint>
MANDATORY: Document EVERY issue, error, difficulty, and incoherence
MANDATORY: Include exact error messages verbatim (no paraphrasing)
MANDATORY: Provide file:line for every error and issue
MANDATORY: Include stack traces when available
MANDATORY: Use `[]` for empty diagnostic fields - NEVER omit them
MANDATORY: Add severity level (low|medium|high|critical)
MANDATORY: Root cause analysis for all blocking problems
MANDATORY: Capture EVERY user interaction, remark, and feedback
MANDATORY: Document ALL behavior signals (repetition, drift, clarification_needed, etc.)
MANDATORY: Document Claude's mistakes in behavior_issues
MANDATORY: Track applied fixes in fixes section with rationale
ALWAYS: Archive existing diagnostic.yaml before creating new one
NEVER: Skip any diagnostic section even when "nothing to report"
CRITICAL: This diagnostic MUST enable perfect issue reproduction
CRITICAL: Missing user_interactions, behavior_signals, or behavior_issues is a failure
No exceptions. Diagnostic handoffs are debugging tools - completeness is non-negotiable.
</critical_constraint>
