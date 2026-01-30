---
name: premortem
description: "Identify failure modes before they occur through systematic plan analysis. Use when reviewing plans, designs, or PRs to catch risks early, or when validating architectural decisions. Includes failure scenario enumeration, risk prioritization, and mitigation strategy development. Not for post-incident analysis, debugging active issues, or implementing fixes."
user-invocable: true
---

# Pre-Mortem

<mission_control>
<objective>Identify failure modes before they occur by systematically questioning plans, designs, and implementations with verified evidence requirements</objective>
<success_criteria>Risks categorized (Tiger/Paper/Elephant) with specific verification evidence, HIGH severity risks addressed before proceeding</success_criteria>
</mission_control>

<mission_control>

1. **Imagined Failure Beats Real Failure**: When you envision failure scenarios BEFORE implementation, you catch risks at 1/100th the cost of post-deployment fixes. This mental time-travel surfaces blind spots that optimism hides.

2. **Evidence Prevents False Alarms**: Verifying findings with context (±20 lines) and checking for mitigations prevents wasting time on non-issues. Verified findings build credibility; unverified claims erode it.

3. **Categorization Enables Triage**: Tigers (clear threats), Paper Tigers (looks scary, actually fine), and Elephants (undiscussable) help you prioritize what actually needs attention. Not all risks deserve equal weight.

4. **Collaboration Surfaces Elephants**: Some risks live in silence—not technical impossibility, but organizational reluctance. The premortem creates psychological safety to name what everyone sees but no one says.

5. **HIGH Risks Demand Decisions**: When severity is HIGH, stop and require user acknowledgment. Proceeding without explicit acceptance creates "I told you so" moments that destroy trust.


Identify failure modes before they occur by systematically questioning plans, designs, and implementations. Based on Gary Klein's technique, popularized by Shreyas Doshi (Stripe).

## Core Concept

> "Imagine it's 3 months from now and this project has failed spectacularly. Why did it fail?"

## Workflow

**Imagine failure:** "It's 3 months from now and this failed. Why?"

**Identify risks:** Generate failure scenarios from multiple perspectives

**Categorize:** Tiger (clear threat), Paper Tiger (looks scary but fine), Elephant (undiscussed)

**Verify:** HIGH severity risks require evidence before proceeding

**Why:** Proactive risk identification catches issues before they manifest—cheaper to fix at design time.

## Navigation

| If you need...           | Read...                                |
| :----------------------- | :------------------------------------- |
| Imagine failure scenario | ## Core Concept → workflow step        |
| Identify failure risks   | ## Workflow → Identify risks           |
| Categorize risks         | ## Workflow → Categorize               |
| Verify severity          | ## Workflow → Verify                   |
| Risk categories          | ## Risk Categories                     |
| Premortem questioning    | ## Implementation Patterns → Pattern 1 |

## Operational Patterns

This skill follows these behavioral patterns:

- **Tracking**: Maintain a visible task list for premortem analysis
- **Management**: Manage task lifecycle for risk mitigation

## Risk Categories

| Category        | Symbol       | Meaning                                         |
| --------------- | ------------ | ----------------------------------------------- |
| **Tiger**       | `[TIGER]`    | Clear threat that will hurt us if not addressed |
| **Paper Tiger** | `[PAPER]`    | Looks threatening but probably fine             |
| **Elephant**    | `[ELEPHANT]` | Thing nobody wants to talk about                |

## Implementation Patterns

### Pattern 1: Premortem Questioning

```typescript
// Imagine: "It's 3 months from now and this failed. Why?"
function runPremortem(plan: Plan): Risk[] {
  return [
    {
      category: "tiger",
      question: "What would cause catastrophic failure?",
      evidence: traceFailurePath(plan),
    },
    {
      category: "paper",
      question: "What looks scary but is probably fine?",
      evidence: verifyMitigations(plan),
    },
    {
      category: "elephant",
      question: "What's nobody discussing?",
      evidence: identifySilence(plan),
    },
  ];
}
```

### Pattern 2: Tiger Verification Checklist

```typescript
// Before flagging ANY tiger, verify:
const verification = {
  contextRead: readSurroundingLines(finding, 20),
  fallbackCheck: hasTryCatchOrExists(finding),
  scopeCheck: isInScope(finding),
  devOnlyCheck: notInMainTestsDev(finding),
};

// ALL must pass to flag as tiger
if (allChecksPass(verification)) {
  flagAsTiger(finding);
}
```

### Pattern 3: Required Evidence Format

```yaml
risk: "<description>"
location: "file.py:42"
severity: high|medium
mitigation_checked: "<what was checked and NOT found>" # REQUIRED

# Example:
risk: "No fallback for missing config file"
location: "config.ts:15"
severity: high
mitigation_checked: "No try/catch, no if (exists) check, no else branch"
```

## Troubleshooting

### Issue: False Positives

| Symptom                           | Solution                                     |
| --------------------------------- | -------------------------------------------- |
| Flagging issues that aren't real  | Use verification checklist before flagging   |
| Pattern-matching without evidence | Every tiger needs `mitigation_checked` field |

### Issue: Missing Context

| Symptom                                 | Solution                       |
| --------------------------------------- | ------------------------------ |
| Flagging line N without reading N±20    | Read surrounding context first |
| Assuming error handling without tracing | Follow the code path           |

### Issue: Scope Confusion

| Symptom                        | Solution                    |
| ------------------------------ | --------------------------- |
| Flagging features not in scope | Check scope before flagging |
| Flagging dev-only code         | Check if in main/ or tests/ |

### Issue: Verification Check Fails

| Symptom                       | Solution                             |
| ----------------------------- | ------------------------------------ |
| Can't fill mitigation_checked | Don't flag as tiger                  |
| Evidence is vague             | Be specific about what was NOT found |

### Issue: Ignoring Elephants

| Symptom              | Solution                           |
| -------------------- | ---------------------------------- |
| Only finding tigers  | Ask "What's nobody talking about?" |
| Uncomfortable topics | Surface them anyway                |

## Workflows

### When Reviewing Plans/Designs

1. **IMAGINE FAILURE** → "It's 3 months from now and this failed. Why?"
2. **IDENTIFY RISKS** → What could go wrong?
3. **CATEGORIZE** → Tiger / Paper Tiger / Elephant
4. **VERIFY** → Check evidence for every tiger
5. **PRESENT** → Show risks with severity

### When Reviewing Code/PRs

1. **READ CONTEXT** → ±20 lines around finding
2. **CHECK MITIGATIONS** → try/catch, exists(), else
3. **VERIFY SCOPE** → Is this in scope?
4. **FLAG ACCORDINGLY** → Only tigers with evidence

potential_risks: # Pass 1: Pattern-matching findings

- "hardcoded path at line 42"
- "missing error handling for X"

tigers: # Pass 2: After verification

- risk: "<description>"
  location: "file.py:42"
  severity: high|medium
  category: dependency|integration|requirements|testing
  mitigation_checked: "<what was NOT found>"

elephants:

- risk: "<unspoken concern>"
  severity: medium

paper_tigers:

- risk: "<looks scary but ok>"
  reason: "<why it's fine - what mitigation EXISTS>"

````

#### Deep Checklist (Before Implementation)

Work through each category systematically:

**Technical Risks:**

- [ ] Scalability: Works at 10x/100x current load?
- [ ] Dependencies: External services + fallbacks defined?
- [ ] Data: Availability, consistency, migrations clear?
- [ ] Latency: SLA requirements will be met?
- [ ] Security: Auth, injection, OWASP considered?
- [ ] Error handling: All failure modes covered?

**Integration Risks:**

- [ ] Breaking changes identified?
- [ ] Migration path defined?
- [ ] Rollback strategy exists?
- [ ] Feature flags needed?

**Process Risks:**

- [ ] Requirements clear and complete?
- [ ] All stakeholder input gathered?
- [ ] Tech debt being tracked?
- [ ] Maintenance burden understood?

**Testing Risks:**

- [ ] Coverage gaps identified?
- [ ] Integration test plan exists?
- [ ] Load testing needed?
- [ ] Manual testing plan defined?

### Step 3: Present Risks via AskUserQuestion

**BLOCKING:** Present findings and require user decision on HIGH severity tigers.

Build the question with these options:

1. **Accept risks and proceed** - Acknowledged but not blocking
2. **Add mitigations to plan** - Update plan with risk mitigations before proceeding
3. **Research mitigation options** - Help find solutions for unknown mitigations
4. **Discuss specific risks** - Talk through particular concerns

### Step 4: Handle User Response

#### If "Accept risks and proceed"

Log acceptance for audit trail and continue to next workflow step.

#### If "Add mitigations to plan"

Update plan file with mitigations section, then re-run quick premortem to verify mitigations address risks.

#### If "Research mitigation options"

For each HIGH severity tiger:

1. Internal: Use Read/Grep to find how codebase handled this before
2. External: Use WebSearch for best practices
3. Synthesize 2-4 options
4. Present via AskUserQuestion

#### If "Discuss specific risks"

Ask which risk to discuss, then have conversation about that specific risk.

### Step 5: Update Plan (if mitigations added)

Append to the plan:

```markdown
## Risk Mitigations (Pre-Mortem)

### Tigers Addressed:

1. **{risk}** (severity: {severity})
   - Mitigation: {mitigation}
   - Added to phase: {phase_number}

### Accepted Risks:

1. **{risk}** - Accepted because: {reason}

### Pre-Mortem Run:

- Date: {timestamp}
- Mode: {quick|deep}
- Tigers: {count}
- Elephants: {count}
````

## Severity Thresholds

| Severity | Blocking? | Action Required                   |
| -------- | --------- | --------------------------------- |
| HIGH     | Yes       | Must address or explicitly accept |
| MEDIUM   | No        | Inform user, recommend addressing |
| LOW      | No        | Note for awareness                |

## Example Session

```
Running deep pre-mortem on API rate limiting plan...

Pre-mortem complete. Found 2 tigers, 1 elephant:

TIGERS:
1. [HIGH] No circuit breaker for external payment API
   - Category: dependency
   - If payment API is slow/down, requests will pile up
   - mitigation_checked: "No timeout, no retries, no circuit breaker pattern"

2. [HIGH] No rollback strategy defined
   - Category: integration
   - If rate limiting breaks auth flow, no quick fix path

ELEPHANTS:
1. [MEDIUM] Team hasn't used Redis before
   - We're introducing Redis for rate limit counters

PAPER TIGERS:
1. Database migration size - Only adds one index, <1s migration
```

## Integration Points

### In Planning Workflows

After plan structure is approved:

1. Run quick premortem
2. If HIGH risks found, block until addressed
3. If only MEDIUM/LOW, inform and proceed

### Before Implementation

Run deep premortem on full plan:

1. Block until all HIGH tigers addressed
2. Update plan with mitigations

### In Code Review

Run quick premortem on diff scope:

1. Inform of any risks found
2. Suggest mitigations if applicable

## References

- [Pre-Mortems by Shreyas Doshi](https://coda.io/@shreyas/pre-mortems)
- [Gary Klein's Original Research](https://hbr.org/2007/09/performing-a-project-premortem)

---

## Common Mistakes to Avoid

### Mistake 1: Flagging Tigers Without Evidence

❌ **Wrong:**
```markdown
TIGER: No error handling for API calls
```

✅ **Correct:**
```markdown
TIGER: [HIGH] No error handling for API calls
- Location: api.ts:42
- mitigation_checked: "No try/catch, no if (response.ok), no early return on error"
```

### Mistake 2: Ignoring Paper Tigers

❌ **Wrong:**
Found 3 tigers, flagged all as high risk without checking if they already have mitigations.

✅ **Correct:**
- Check for existing try/catch, exists() checks, else branches before flagging
- If mitigations exist, categorize as [PAPER] with explanation of why it's fine

### Mistake 3: Skipping Context Reading

❌ **Wrong:**
Flagged line 42 as risky without reading lines 22-62 to understand the full context.

✅ **Correct:**
Always read ±20 lines around any potential finding to understand:
- Is this in an error handler path?
- Is there fallback logic nearby?
- Is this a deliberate design choice?

### Mistake 4: Missing Elephants

❌ **Wrong:**
Only finding technical tigers, never surfacing organizational or process concerns.

✅ **Correct:**
Ask "What's nobody talking about?" explicitly:
- Team has no experience with this technology
- Timeline is unrealistic but nobody wants to say so
- Stakeholder alignment is unclear

### Mistake 5: Proceeding Past HIGH Risks

❌ **Wrong:**
Found 2 HIGH severity tigers, proceeded anyway because "user will handle it."

✅ **Correct:**
Use AskUserQuestion to present HIGH severity risks and require explicit acknowledgment:
1. Accept risks and proceed
2. Add mitigations to plan
3. Research mitigation options
4. Discuss specific risks
Never proceed past HIGH risks without user decision.

---

## Validation Checklist

Before claiming premortem analysis complete:

**Identification:**
- [ ] Imagined failure scenarios from multiple perspectives
- [ ] Considered technical, integration, and process risks
- [ ] Asked "What's nobody talking about?" for elephants

**Categorization:**
- [ ] Risks classified as Tiger, Paper Tiger, or Elephant
- [ ] Tigers have clear evidence of missing mitigations
- [ ] Paper Tigers have explanation of existing safeguards

**Verification:**
- [ ] ±20 lines read around every tiger finding
- [ ] Every tiger has `mitigation_checked` field documenting what was NOT found
- [ ] Scope verified (in scope for this plan/PR)

**Severity:**
- [ ] HIGH severity risks require explicit user acknowledgment
- [ ] MEDIUM/LOW risks documented with recommendations

**Presentation:**
- [ ] Risks presented with AskUserQuestion for HIGH severity
- [ ] User decision captured and logged

---

## Best Practices Summary

✅ **DO:**
- Read ±20 lines of context before flagging any finding
- Use the verification checklist before calling something a tiger
- Document what mitigations were checked and NOT found
- Ask "What's nobody talking about?" to surface elephants
- Block on HIGH severity risks until user acknowledges
- Categorize as [PAPER] when mitigations already exist

❌ **DON'T:**
- Flag risks without reading surrounding context
- Skip the `mitigation_checked` field on tigers
- Proceed past HIGH severity risks without user decision
- Flag every pattern-match as a tiger (check scope first)
- Only find technical tigers, ignore organizational elephants
- Use HIGH severity for non-blocking issues

---

<critical_constraint>
Portability invariant: This component must work standalone with zero external dependencies. All necessary philosophy and patterns are self-contained.
</critical_constraint>
