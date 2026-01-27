---
name: root-cause-analysis
description: "Drill down to root causes by asking 'why' iteratively. Use when: investigating bugs, analyzing failures, debugging complex problems, preventing recurrence. Trigger phrases: 'root cause', 'why did this happen', 'find the real issue'."
---

# Root Cause Analysis

Drill down to root causes by iteratively asking "why" to reveal the fundamental issue behind surface problems.

## Core Pattern

Apply the 5 Whys technique by:
1. Starting with an observable problem
2. Asking "why" to identify the cause
3. Repeating until reaching root cause (typically 5 levels)
4. Identifying actionable fixes at each level

**Key Innovation**: Move beyond symptoms to address root causes, preventing recurrence.

## When to Use

Use this methodology when:
- Investigating bugs or incidents
- Analyzing process failures
- Understanding user behavior issues
- Debugging complex problems
- Wanting to prevent problem recurrence

**Recognition test:** "Is this a symptom or the actual problem?" If it's just a surface issue, drill deeper.

## Step-by-Step Process

### The 5 Whys Chain

Start with the problem and ask "why" repeatedly:

```
**Problem**: [Observable symptom]

**Why 1**: [First-level cause]
→ Because [explanation]

**Why 2**: [Second-level cause]
→ Because [explanation]

**Why 3**: [Third-level cause]
→ Because [explanation]

**Why 4**: [Fourth-level cause]
→ Because [explanation]

**Why 5**: [Root cause]
→ Because [explanation]

**Root Cause**: [The fundamental issue]
**Action**: [What to fix to prevent recurrence]
```

### Guidelines

1. **Be specific** - Each why should be factual and verifiable
2. **Avoid blame** - Focus on systems and processes, not people
3. **Check logic** - Ensure each answer directly explains the previous level
4. **Stop at root cause** - When you reach something you can actually fix

## Application Examples

### Example 1: Software Bug

**Problem**: Database query is timing out after 30 seconds

**Why 1**: The query is scanning millions of rows
→ Because there's no index on the filtered column

**Why 2**: The column wasn't indexed
→ Because it wasn't identified as a query column during schema design

**Why 3**: The query requirements weren't known during design
→ Because there was no requirements analysis for data access patterns

**Why 4**: Requirements analysis was skipped
→ Because the team rushed to implement features

**Why 5**: The team rushes because management pressures for quick delivery

**Root Cause**: Process issue - no time allocated for proper design and requirements analysis
**Action**: Implement mandatory design review before implementation

### Example 2: User Behavior

**Problem**: Users aren't completing the signup flow

**Why 1**: Users drop off at the credit card step
→ Because they're asked for payment info too early

**Why 2**: Payment is asked early
→ Because the product design assumes freemium conversion at signup

**Why 3**: The design assumes immediate conversion
→ Because the business model requires early monetization

**Why 4**: Early monetization is required
→ Because customer acquisition costs are high

**Why 5**: CAC is high
→ Because marketing channels are expensive and conversion is low

**Root Cause**: Business model mismatch - expensive channels for low-intent users
**Action**: Pivot to organic channels and/or improve product-market fit before paid acquisition

### Example 3: Incident Response

**Problem**: Production deployment caused 2-hour outage

**Why 1**: The deployment had a breaking database migration
→ Because the migration wasn't tested in staging

**Why 2**: Staging environment wasn't used
→ Because staging was broken from previous issues

**Why 3**: Staging issues weren't fixed
→ Because no one is responsible for staging maintenance

**Why 4**: No clear ownership
→ Because staging wasn't considered a critical system

**Why 5**: Staging wasn't critical
→ Because deployments were done directly to production in the past

**Root Cause**: Missing deployment infrastructure and process
**Action**: Build proper CI/CD pipeline with mandatory staging environment

## Output Format

After analysis, produce structured output:

```markdown
# 5 Whys Analysis: [Problem]

## Problem Statement
[The observable symptom or issue]

## The 5 Whys Chain

| Level | Question | Answer |
|-------|----------|--------|
| 1 | Why did [problem] happen? | [First cause] |
| 2 | Why did [first cause] happen? | [Second cause] |
| 3 | Why did [second cause] happen? | [Third cause] |
| 4 | Why did [third cause] happen? | [Fourth cause] |
| 5 | Why did [fourth cause] happen? | [Root cause] |

## Root Cause
[The fundamental issue that must be addressed]

## Action Items

### Immediate (Fix the symptom)
- [ ] [Action to address current problem]

### Short-term (Fix the cause)
- [ ] [Action to address intermediate causes]

### Long-term (Fix the root cause)
- [ ] [Action to prevent recurrence]

## Prevention Measures
- [ ] [Process change to prevent this happening again]
- [ ] [Monitoring or alerting to catch early]
- [ ] [Documentation or training needed]
```

## Recognition Questions

**During analysis**:
- "Is this answer factual, not speculative?"
- "Does this directly explain the previous level?"
- "Can I verify this answer with evidence?"

**After finding root cause**:
- "Is this something I can actually fix?"
- "Will fixing this prevent recurrence?"
- "Am I stopping at symptoms or going to the root?"

## Common Mistakes

**❌ Wrong**: Stopping at symptoms (Levels 1-2)
**✅ Correct**: Continue until reaching actionable root cause

**❌ Wrong**: Blaming individuals ("John made a mistake")
**✅ Correct**: Blaming systems ("Process allowed mistakes to reach production")

**❌ Wrong**: Single causal path when there are multiple
**✅ Correct**: Acknowledge when multiple factors contribute (create separate 5 Whys chains)

**❌ Wrong**: Proceeding with 5 even when root cause is found earlier
**✅ Correct**: Stop when you reach something you can actually fix

## When Not to Use

Don't use 5 Whys when:
- Problem has multiple independent causes (use fishbone diagram instead)
- Root cause is obvious from the start
- Problem is one-time and won't recur
- Complexity requires more sophisticated analysis methods

## Related Techniques

**Fishbone Diagram** (Ishikawa) - For problems with multiple causal factors
**Fault Tree Analysis** - For systematic risk analysis
**Root Cause Analysis (RCA)** - Formal incident investigation methodology

**Trust intelligence** - 5 Whys is powerful precisely because it's simple. Don't overcomplicate it, but do verify each answer with evidence.
