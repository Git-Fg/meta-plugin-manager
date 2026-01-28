---
name: learn
description: Extract reusable patterns from the current session. Use when: you've solved a non-trivial problem, discovered a workaround, or learned a valuable pattern. Saves patterns as skills to .claude/skills/learned/. Supports instinct-based learning with confidence scoring.
disable-model-invocation: true
---

# Learn Command (Enhanced with Instinct-Based Learning)

Extract reusable patterns from the current session and save them as portable skills.

## What This Command Does

Analyze the conversation history to identify valuable patterns and save them as reusable skills:

1. **Review session** - Scan conversation for extractable patterns
2. **Identify patterns** - Look for error resolutions, debugging techniques, workarounds
3. **Choose granularity** - Select between full skills (v1) or atomic instincts (v2)
4. **Assign confidence** - Score patterns by reliability (0.3-0.9)
5. **Categorize by type** - Error resolution, debugging, workarounds, project-specific
6. **Draft skill file** - Create structured skill with problem/solution format
7. **Confirm and save** - Request approval, save to `.claude/skills/learned/`

## v2 Instinct-Based Learning

### What Are Instincts?

**Instincts** are atomic learned behaviors with confidence scoring:

```yaml
---
id: prefer-functional-style
trigger: "when writing new functions"
confidence: 0.7
domain: "code-style"
source: "session-observation"
---

# Prefer Functional Style

## Action
Use functional patterns over classes when appropriate.

## Evidence
- Observed 5 instances of functional pattern preference
- User corrected class-based approach to functional on 2025-01-15
```

**Properties:**

- **Atomic** — one trigger, one action
- **Confidence-weighted** — 0.3 = tentative, 0.9 = near certain
- **Domain-tagged** — code-style, testing, git, debugging, workflow
- **Evidence-backed** — tracks what observations created it

### Confidence Scoring

| Score | Meaning      | Behavior                      |
| ----- | ------------ | ----------------------------- |
| 0.3   | Tentative    | Suggested but not enforced    |
| 0.5   | Moderate     | Applied when relevant         |
| 0.7   | Strong       | Auto-approved for application |
| 0.9   | Near-certain | Core behavior, always apply   |

**Confidence increases** when:

- Pattern is repeatedly observed
- User doesn't correct the suggested behavior
- Similar instincts from other sources agree

**Confidence decreases** when:

- User explicitly corrects the behavior
- Pattern isn't observed for extended periods
- Contradicting evidence appears

### Instinct Evolution

```
instincts/ (atomic behaviors)
      ↓
   /evolve (cluster related instincts)
      ↓
evolved/ (skills/commands/agents)
```

- **Cluster**: Group related instincts by domain
- **Evolve**: Transform clusters into full components
- **Deploy**: Move to appropriate location based on complexity

## What to Extract

### ✅ DO Extract

**Error Resolution Patterns**:

- What error occurred?
- What was the root cause?
- What fixed it?
- Is this reusable for similar errors?

**Debugging Techniques**:

- Non-obvious debugging steps
- Tool combinations that worked
- Diagnostic patterns

**Workarounds**:

- Library quirks
- API limitations
- Version-specific fixes

**Project-Specific Patterns**:

- Codebase conventions discovered
- Architecture decisions made
- Integration patterns

### ❌ DON'T Extract

- Trivial fixes (typos, simple syntax errors)
- One-time issues (specific API outages, temporary failures)
- Generic patterns Claude already knows
- Obvious solutions

## Output Format

### v1: Full Skills (Traditional)

````markdown
# [Descriptive Pattern Name]

**Extracted:** [Date]
**Context:** [Brief description of when this applies]

## Problem

[What problem this solves - be specific]

## Solution

[The pattern/technique/workaround]

## Example

[Code example if applicable]

### v2: Atomic Instincts (New)

```markdown
---
id: [unique-id]
trigger: [when this pattern should activate]
confidence: 0.7
domain: [category: code-style, testing, git, debugging, workflow]
source: "session-observation"
---

# [Pattern Name]

## Action

[What to do when this pattern triggers]

## Evidence

- [Observation 1]
- [Observation 2]
- [User correction/confirmation]
```
````

## Output Location

Patterns are saved to:

```
.claude/skills/learned/[pattern-name].md                    # v1 skills
~/.claude/homunculus/instincts/personal/[pattern-name].md  # v2 instincts
```

**Storage approach:**

- v1 skills → project-specific (`.claude/skills/learned/`)
- v2 instincts → user-wide (`~/.claude/homunculus/instincts/personal/`) for cross-session learning

## Extraction Process

### For Full Skills (v1)

1. **Review session** - Analyze conversation from beginning
2. **Identify insights** - Look for "aha moments" and problem solutions
3. **Select best pattern** - Choose most valuable/reusable insight
4. **Draft skill** - Create structured skill following format
5. **Request approval** - Show proposed skill and ask for confirmation
6. **Save skill** - Write to `.claude/skills/learned/` once approved

### For Atomic Instincts (v2)

1. **Observe session** - Track patterns throughout conversation:
   - **Hook-based observations** (automatic, 100% reliable via PostToolUse hook)
   - Manual observations during extraction
2. **Extract instincts** - Identify atomic behaviors:
   - User corrections → instinct
   - Error resolutions → instinct
   - Repeated workflows → instinct
3. **Score confidence** - Assign initial confidence (0.3-0.9):
   - 0.3: Tentative, first-time observation
   - 0.5: Observed multiple times, user approved
   - 0.7: Confirmed pattern, high reliability
   - 0.9: Core behavior, always apply
4. **Tag domains** - Code-style, testing, git, debugging, workflow
5. **Save instincts** - Write to `~/.claude/homunculus/instincts/personal/`

**Note:** Hook-based observations are automatically captured to `~/.claude/homunculus/observations.jsonl` and can be processed by the learning-observer agent for pattern detection.

## Evolution Path

### Manual Evolution

```bash
# View current instincts
/instinct-status

# Cluster related instincts into skills
/evolve

# Export instincts for sharing
/instinct-export

# Import instincts from others
/instinct-import <file>
```

### Evolution Thresholds

- **3+ related instincts** → Consider clustering
- **5+ instincts in same domain** → Create skill
- **10+ instincts** → Consider command or agent

## Skill Format Guidelines

- **Keep focused** - One pattern per skill/instinct
- **Be specific** - Include actual code/command examples
- **Explain WHY** - Context and rationale matter
- **Make it actionable** - Clear when to use
- **Keep it concise** - Instincts: 20-50 lines, Skills: 50-150 lines

## Example Extracted Skill (v1)

````markdown
# Supabase Connection Timeout Fix

**Extracted:** 2024-01-15
**Context:** Supabase connections timing out after 30s during development

## Problem

Supabase database connections were timing out after 30 seconds when the database was under load. Default connection timeout was too short.

## Solution

Increase connection timeout in Supabase client configuration:

```typescript
import { createClient } from "@supabase/supabase-js";

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY,
  {
    db: { schema: "public" },
    global: {
      timeout: 60000, // 60 seconds instead of default 30s
    },
  },
);
```
````

## When to Use

- When Supabase connections timeout during development
- When database queries take longer than 30 seconds
- When working with large datasets

````

## Example Instinct (v2)

```yaml
---
id: supabase-timeout-increase
trigger: "when Supabase connection times out"
confidence: 0.8
domain: "database"
source: "session-observation"
---

# Supabase Connection Timeout Fix

## Action
When Supabase connection times out, increase timeout in client configuration:

```typescript
global: {
  timeout: 60000  // 60 seconds instead of default 30s
}
````

## Evidence

- Observed 3 instances of timeout errors in development
- User confirmed fix resolved issue (2025-01-15)
- Pattern consistent across Supabase projects

```

## Quality Checklist

Before extracting, ask yourself:
- [ ] Is this non-trivial? (not obvious fix)
- [ ] Is this reusable? (could apply to future sessions)
- [ ] Is this valuable? (saves time/effort)
- [ ] Is this specific enough? (includes context and examples)
- [ ] Would this help in a different project? (portability)

## Integration

This command integrates with:
- `meta-critic` - Quality validation of extracted patterns
- `skill-development` - Follows skill creation best practices
- `verify` - Run after learning to ensure changes work

## Arguments

This command does not interpret special arguments. Everything after `learning/extract` is treated as additional context for pattern extraction.

**Optional context you can provide**:
- Granularity: "instinct" (v2 atomic) or "skill" (v1 full)
- Domain: "code-style", "testing", "git", "debugging", "workflow"
- Minimum confidence: "0.7" (only high-confidence patterns)
- Focus area: "focus on debugging techniques"
```
