---
name: refactor-elegant-teaching
description: "Refactor code to be cleaner, more modular, and self-documenting. Use when making code more teachable, maintainable, or educational. Includes modular design, self-documenting patterns, and teaching-focused restructuring. Not for quick fixes, non-educational changes, style-only changes, or performance optimization."
---

<mission_control>
<objective>Refactor code toward elegance where structure teaches intent through self-documenting, modular design.</objective>
<success_criteria>Code refactored with clear intent, self-documenting structure, maintainable modules</success_criteria>
</mission_control>

# Refactor: Elegant Teaching

Refactor code toward elegance—where structure teaches intent. Clean code reads like well-written prose: self-documenting, modular, and obvious to the next reader.

## Workflow

**Understand:** Explore codebase, grasp current structure and intent

**Identify pattern:** Find anti-patterns (naming, structure, duplication)

**Apply refactor:** Extract, rename, restructure toward self-documenting code

**Verify:** Tests still pass, readability improved

**Why:** Elegant code teaches intent through structure—maintainability improves when code reads like prose.

## Operational Patterns

This skill follows these behavioral patterns:

- **Discovery**: Locate files matching patterns and search file contents for refactoring scope
- **Delegation**: Delegate exploration to specialized workers
- **Tracking**: Maintain a visible task list for refactoring phases
- **Navigation**: Navigate code structure for refactoring analysis

Trust native tools to fulfill these patterns. The System Prompt selects the correct implementation.

## Navigation

| If you need...         | Read...                                |
| :--------------------- | :------------------------------------- |
| Understand structure   | ## Workflow → Understand               |
| Identify anti-patterns | ## Workflow → Identify pattern         |
| Apply refactoring      | ## Workflow → Apply refactor           |
| Verify changes         | ## Workflow → Verify                   |
| Rename for clarity     | ## Implementation Patterns → Pattern 1 |
| Examples               | examples/                              |

## Implementation Patterns

### Pattern 1: Rename for Clarity

```typescript
// Before: Names require mental translation
const d = data.filter((x) => x.active);
const h = handleUser(u);

// After: Names describe purpose
const activeUsers = data.filter((user) => user.isActive);
const handleAuthenticatedUser = (user: User) =>
  UserAuthenticator.authenticate(user);
```

### Pattern 2: Extract Function

```typescript
// Before: Function does too many things
function processOrder(order) {
  if (!order.id || !order.items) return null;
  let total = 0;
  for (const item of order.items) {
    total += item.price * item.quantity;
  }
  return db.save({ ...order, total });
}

// After: Each function has single responsibility
function processOrder(order: Order): ProcessedOrder | null {
  if (!isValidOrder(order)) return null;
  const total = calculateOrderTotal(order.items);
  return saveOrder({ ...order, total });
}
```

### Pattern 3: Flatten Nesting

```typescript
// Before: Deep nesting obscures control flow
function processUser(user) {
  if (user) {
    if (user.isActive) {
      if (user.hasPermission) {
        // Do the thing
      }
    }
  }
}

// After: Early returns clarify path
function processUser(user: User | null) {
  if (!user) return;
  if (!user.isActive) return;
  if (!user.hasPermission) return;
  // Do the thing
}
```

### Pattern 4: Remove Duplication

```typescript
// Before: Same logic repeated
const formattedDate = `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`;

// After: Single source of truth
export function formatDateISO(date: Date): string {
  return date.toISOString().split("T")[0];
}
```

### Pattern 5: Replace Magic Values

```typescript
// Before: Unclear values
if (retryCount > 3 && elapsed > 5000) {
}

// After: Named constants
const MAX_RETRIES = 3;
const REQUEST_TIMEOUT_MS = 5000;
if (retryCount > MAX_RETRIES && elapsed > REQUEST_TIMEOUT_MS) {
}
```

## Troubleshooting

### Issue: Shotgun Refactoring

| Symptom                     | Solution                                 |
| --------------------------- | ---------------------------------------- |
| Changing everything at once | Focus on one pattern at a time           |
| Tests fail after refactor   | Revert and make smaller, focused changes |
| Hard to isolate what broke  | One change at a time, verify after each  |

### Issue: Refactoring Without Tests

| Symptom             | Solution                                |
| ------------------- | --------------------------------------- |
| No test coverage    | Create tests before refactoring         |
| Fear of breaking    | Write behavioral tests first            |
| Manual verification | Document expected behavior, then verify |

### Issue: Premature Abstraction

| Symptom                     | Solution                                    |
| --------------------------- | ------------------------------------------- |
| Abstracting "just in case"  | Wait until pattern appears 2+ times         |
| Over-engineered solution    | Solve the actual problem, not hypotheticals |
| Indirection without benefit | Inline simple code that isn't reused        |

### Issue: Behavior Change

| Symptom                       | Solution                                    |
| ----------------------------- | ------------------------------------------- |
| Output differs after refactor | Revert immediately, preserve behavior first |
| Tests fail                    | Fix the refactor, not the tests             |
| Edge cases broken             | Ensure edge cases are handled identically   |

## Editing Protocol

**Principle**: Minimal Disruption.

| Pattern                             | Result                        |
| ----------------------------------- | ----------------------------- |
| Rewriting whole file for one change | BAD - breaks context/RSID     |
| Targeted search/replace for lines   | GOOD - preserves RSID context |
| Verifying RSID around edit          | REQUIRED                      |

**RSID Preservation**: When editing code:

1. Identify exact lines to change
2. Use targeted replace, not broad rewrites
3. Verify surrounding context remains unchanged

## Workflows

### Refactoring Workflow

1. **UNDERSTAND** → Read code and trace current behavior
2. **IDENTIFY** → What specifically obscures intent?
3. **APPLY** → Use targeted pattern (rename, extract, flatten, deduplicate)
4. **VERIFY** → Tests pass, behavior unchanged

### TDD Integration

- **RED phase**: Do NOT refactor (focus on making tests pass)
- **GREEN phase**: Safe to refactor (tests provide safety net)
- **Refactor in small steps**: One pattern at a time

### Code Review Integration

1. **IDENTIFY** → Comment flags unclear code
2. **ACCEPT** → Agreement on refactoring approach
3. **REFACTOR** → Apply patterns with safety net
4. **VERIFY** → Review passes, behavior preserved

---

## Core Invariants

Two principles guide every refactoring decision. First, preservation: the existing behavior must remain identical after any change. Second, clarity: the code's intent must become more obvious, not more obscured.

Understanding what code currently does matters more than any pattern. Dogma serves the code, not the other way around. Verify changes through tests or manual checks before proceeding.

---

## When to Use This Skill

**Apply this skill when:**

- Code is difficult to understand at first glance
- Functions do too many things (violating single responsibility)
- Variable names require comments to explain
- Nesting makes control flow hard to follow
- Duplication creates maintenance burden

**Do NOT use when:**

- Only formatting changes are needed (use a formatter)
- Adding new features (that's feature development)
- Fixing bugs (that's debugging)
- Code is already clear and maintainable

**Recognition question**: "Would this change make the code's intent more obvious to someone seeing it for the first time?"

---

## Core Philosophy

**Decision Flow:**

1. **Read code** → Understand intent?
   - No → Read more context
   - Yes → Continue

2. **Identify** → What obscures intent?
   - Bad names → Rename variables/functions
   - Too long → Extract functions
   - Nested → Flatten nesting
   - Duplicated → Remove duplication

3. **Preserve** → Behavior must remain identical
4. **Verify** → Tests pass

**Remember**: Elegant code teaches. A reader should understand WHAT the code does, WHY it exists, and HOW it works—without needing additional explanation.

**Think of it this way**: Every line of code is a lesson plan for the next developer. Are you teaching clearly or obscuring the lesson?

---

## Refactoring Patterns

Apply these patterns based on what obscures intent in the specific code you're working with.

### Pattern 1: Rename for Clarity

**Problem**: Names require comments or mental translation.

**Solution**: Rename variables and functions to describe their purpose.

**Reference**: See `examples/01-rename-before-after.ts`

**Recognition**: "Does this name explain WHAT it is, not just its data type?"

### Pattern 2: Extract to Comprehend

**Problem**: Functions do multiple things or are too long to understand.

**Solution**: Extract logical chunks into named functions.

**Reference**: See `examples/02-extract-before-after.ts`

**Recognition**: "Can I describe what this code block does in a simple function name?"

### Pattern 3: Flatten Nesting

**Problem**: Deep nesting makes control flow hard to follow.

**Solution**: Use early returns and guard clauses.

**Reference**: See `examples/03-flatten-before-after.ts`

**Recognition**: "Am I indenting more than 3 levels? Time to flatten."

### Pattern 4: Remove Duplication

**Problem**: Same logic appears in multiple places.

**Solution**: Extract to a named function.

**Reference**: See `examples/05-duplicate-before-after.ts`

**Recognition**: "Have I seen this logic before? Extract it."

### Pattern 5: Replace Magic with Constants

**Problem**: Numbers or strings appear without explanation.

**Solution**: Name the values.

**Reference**: See `examples/04-magic-before-after.ts`

**Recognition**: "Would I understand this value in 6 months without context?"

---

## Before/After Examples

| Example File                   | Shows...                                                 |
| ------------------------------ | -------------------------------------------------------- |
| `01-rename-before-after.ts`    | Obscure names → Self-documenting code                    |
| `02-extract-before-after.ts`   | Multi-purpose function → Single-responsibility functions |
| `03-flatten-before-after.ts`   | Deep nesting → Early returns                             |
| `04-magic-before-after.ts`     | Magic numbers → Named constants                          |
| `05-duplicate-before-after.ts` | Duplicated logic → Single source of truth                |

---

## Degrees of Freedom

**High freedom**: These patterns are guidelines, not rules. Adapt them based on:

- Language idioms (Python differs from Rust)
- Codebase conventions (consistency with surrounding code matters)
- Performance constraints (sometimes clarity must yield to efficiency)
- Team preferences

**System Physics** (non-negotiable):

- Behavior preservation (refactoring must not change output)
- Test coverage (if tests exist, they must still pass)

**Recognition**: "What breaks if I don't follow this pattern?" If nothing breaks, consider skipping it.

---

## The Refactoring Discipline

Begin with understanding. Before changing anything, trace what the code currently does. Then ask: what specifically obscures its intent? The patterns follow naturally from the diagnosis.

Change one thing at a time. Run tests after each change. Verify behavior remains unchanged. The sequence emerges from the problem, not from a checklist.

---

## Verification Checklist

Before considering refactoring complete:

- [ ] Tests pass (if tests exist)
- [ ] Behavior is unchanged (verified manually if no tests)
- [ ] Code is more readable than before
- [ ] No new abstractions were created "just in case"
- [ ] Names describe WHAT and WHY, not just data type
- [ ] Nesting is minimized (early returns used)
- [ ] Duplication was removed where it existed

---

## Integration

This skill works alongside:

- **engineering-lifecycle**: Refactor during the GREEN phase, never during RED
- **code-review**: Identify refactoring opportunities in PRs
- **quality-standards**: Verify refactoring preserved behavior

**Recognition**: "Am I in the RED phase? STOP—do not refactor yet."

---

## Genetic Code

<critical_constraint>
This component carries essential Seed System principles for context: fork isolation. All components must be self-contained with zero .claude/rules dependency. Descriptions use What-When-Not-Includes format in third person. Progressive disclosure applies—core in SKILL.md, details in references/. XML provides control (mission_control, critical_constraint), Markdown provides data. No exceptions. Portability invariant must be maintained.
</critical_constraint>

**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows

**Recognition Questions**:

- "Would Claude know this without being told?" → Delete (zero delta)
- "Can this work standalone?" → Fix if no (non-self-sufficient)
- "Did I read the actual file, or just see it in grep?" → Verify before claiming

---

## Final Reminder

Refactoring without understanding the current behavior invites bugs. The goal is cleaner structure, not new behavior. Run tests to confirm nothing changed. In TDD workflows, wait for the GREEN phase—refactoring during RED breaks the feedback loop.

---

## Common Mistakes to Avoid

### Mistake 1: Refactoring Without Understanding First

❌ **Wrong:**
Read function → "This looks messy" → Refactor → Tests fail → Bug introduced

✅ **Correct:**
Read function → Trace every code path → Understand behavior → Refactor → Tests pass → Success

### Mistake 2: Changing Behavior While Refactoring

❌ **Wrong:**
"This condition looks wrong, let me fix it too" → Behavior changed → Bug introduced

✅ **Correct:**
Refactor structure only → Keep behavior identical → Create separate task for bug fixes

### Mistake 3: Premature Abstraction

❌ **Wrong:**
"This might be used elsewhere someday" → Create generic abstraction → Over-engineered

✅ **Correct:**
Extract only when duplication exists (Rule of 3: appear 3 times before abstracting)

### Mistake 4: Renaming Without Improving Clarity

❌ **Wrong:**
`const x = data.process()` → `const processedData = data.process()`
// Name changed, but still unclear what process() does

✅ **Correct:**
`const validatedOrders = data.filter(order => isValid(order))`
// Name describes WHAT and HOW

### Mistake 5: Refactoring During RED Phase (TDD)

❌ **Wrong:**
RED phase → Tests failing → "While I'm here, let me refactor" → TDD cycle broken

✅ **Correct:**
Wait for GREEN phase → Tests passing → Refactor → Maintain GREEN
If you see refactoring opportunities during RED, note them and return later.

### Mistake 6: Breaking Single Responsibility

❌ **Wrong:**
Extract function that still does multiple things → Just moved the problem

✅ **Correct:**
Each extracted function should do ONE thing and do it well
`calculateTotal()` should only calculate total, not validate or save

---

## Best Practices Summary

✅ **DO:**
- Understand current behavior before changing anything
- Run tests after each individual change
- Preserve behavior exactly (refactoring = structure change, not behavior change)
- Use TDD GREEN phase for refactoring
- Rename to describe WHAT and WHY, not just data type
- Extract when logic appears 3+ times (Rule of 3)
- Flatten nesting with early returns
- Replace magic numbers with named constants

❌ **DON'T:**
- Refactor without tracing all code paths first
- Change behavior while refactoring (create separate bug-fix tasks)
- Abstract too early ("just in case" is not a reason)
- Create functions that still do multiple things
- Rename without improving clarity
- Refactor during TDD RED phase
- Leave magic numbers un-named
- Break working code to make it "cleaner"

---

<critical_constraint>
This skill carries its own genetic code. It works in isolation from .claude/rules/.
The description uses What-When-Not-Includes format in third person.
Progressive disclosure applies: core philosophy in SKILL.md, details in references/.
XML tags provide control (mission_control, critical_constraint), Markdown provides data.
</critical_constraint>```
