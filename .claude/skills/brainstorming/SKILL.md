---
name: brainstorming
description: "Turn ideas into validated designs through collaborative exploration. Use when creative work starts, requirements are vague, or user intent needs clarification. Includes l'entonnoir pattern, validation frameworks, and YAGNI application. Not for execution when requirements are clear, simple fixes, or well-defined tasks."
---

<mission_control>
<objective>Turn vague ideas into validated, concrete designs through collaborative exploration using the l'entonnoir pattern.</objective>
<success_criteria>Design sections validated one at a time, YAGNI applied, 80-95% autonomy achieved</success_criteria>
</mission_control>

## The Path to Successful Design Collaboration

**Why these principles work:**

1. **Recognition beats generation** — Users select from options 3-5x faster than typing free-form text, and options reveal tradeoffs they wouldn't have considered alone.

2. **One question at a time** — Sequential questions prevent cognitive overload and allow each answer to inform the next question, creating a natural funnel effect.

3. **Validate incrementally** — Presenting design in 200-300 word sections catches issues early; building on validated foundations prevents "start over" feedback.

4. **YAGNI creates focus** — Stripping unnecessary features reveals the core value proposition, preventing scope creep that bloats designs and delays implementation.

5. **Context-first exploration** — Checking project state before proposing solutions ensures designs build on existing patterns rather than duplicating or conflicting with established approaches.

6. **Autonomy through batching** — Grouping 2-4 related questions reduces rounds while maintaining precision, achieving 80-95% autonomy (0-5 AskUserQuestion rounds per session).

**Result**: Collaborative exploration produces validated, implementable designs that users understand and feel ownership over.

## Workflow

**Phase 1: Clarify Intent** → Ask recognition-based questions to narrow user intent (l'entonnoir)

**Phase 2: Explore Options** → Investigate codebase context, patterns, constraints

**Phase 3: Validate Design** → Present design sections one at a time for feedback

**Phase 4: Apply YAGNI** → Strip unnecessary features, keep only what's needed

**Why:** Users recognize faster than they generate—structured questions yield better designs than open-ended prompts.

## Navigation

| If you need...      | Read...                                          |
| :------------------ | :----------------------------------------------- |
| Clarify intent      | ## Workflow → Clarify Intent                     |
| Explore options     | ## Workflow → Explore Options                    |
| Validate design     | ## Workflow → Validate Design                    |
| Apply YAGNI         | ## Workflow → Apply YAGNI                        |
| Initial orientation | ## Implementation Patterns → Initial Orientation |
| Examples            | examples/                                        |

## Operational Patterns

This skill uses semantic directives for behavioral patterns:

- **Discovery**: Locate files matching patterns and search file contents for context
- **Delegation**: Delegate exploration to specialized workers for research
- **Consultation**: Consult the user with 2-4 options for creative direction
- **Tracking**: Maintain a visible task list throughout ideation

## Implementation Patterns

### Pattern 1: Initial Orientation

```bash
# First, check project context
git log --oneline -10
ls -la
cat CLAUDE.md 2>/dev/null | head -50
```

```typescript
// Ask user: "What are you trying to build?"
type ProjectType =
  | "backend-service"
  | "frontend-webapp"
  | "cli-tool"
  | "mobile-app"
  | "fullstack-app"
  | "library";

const questions = [
  "What problem does this solve?",
  "Who are the users?",
  "Is this new or improving existing?",
];
```

### Pattern 2: L'Entonnoir Question Batching

```typescript
// BAD: Too many questions
const badQuestions = [
  "What database?",
  "What frontend?",
  "What backend?",
  "What styling?",
  "What testing?",
];

// GOOD: Batch related questions, start broad
const goodQuestions = [
  "What type of project is this?",
  // a) Backend API
  // b) Frontend web app
  // c) CLI tool
  // d) Mobile app
  // e) Full-stack application
];
```

### Pattern 3: Design Presentation

```markdown
**Section 1: Architecture**

- Proposed: [Microservices/Monolith/Serverless]
- Reasoning: [why this approach fits requirements]

Does this section look right, or should I adjust anything?

[Wait for user confirmation before proceeding]

**Section 2: Components**

- [Component 1]: [responsibility]
- [Component 2]: [responsibility]

Does this component structure work?
```

## Troubleshooting

### Issue: Too Many Questions Overwhelm User

| Symptom                            | Solution                            |
| ---------------------------------- | ----------------------------------- |
| User seems confused or overwhelmed | Simplify to 1-2 questions at a time |
| "I don't know" answers             | Provide options with tradeoffs      |

### Issue: Skipping Context Check

| Symptom                                          | Solution                                      |
| ------------------------------------------------ | --------------------------------------------- |
| Jumping straight to questions                    | First review project state, existing patterns |
| "What framework?" without checking current stack | Check package.json, existing code             |

### Issue: Leading Questions

| Symptom                         | Solution                                 |
| ------------------------------- | ---------------------------------------- |
| "You want to use React, right?" | Should be "What frontend framework?"     |
| Assuming user's preference      | Present options neutrally with tradeoffs |

### Issue: YAGNI Violations

| Symptom                           | Solution                               |
| --------------------------------- | -------------------------------------- |
| "While we're at it, let's add..." | "That's out of scope for this feature" |
| Feature creep during design       | Apply YAGNI ruthlessly                 |

### Issue: Not Validating Incrementally

| Symptom                           | Solution                                      |
| --------------------------------- | --------------------------------------------- |
| Presenting full design at once    | Present sections 200-300 words, validate each |
| Getting "no, start over" feedback | Build on validated foundation                 |

## workflows

### When Requirements Are Vague

1. **Explore Context** → Check project state, recent commits, existing patterns
2. **Initial Questions** → 2-4 questions using l'entonnoir pattern
3. **Refine Understanding** → Research gaps, offer options
4. **Present Design** → Sections of 200-300 words, validate each
5. **Document to File** → Write validated design to `docs/plans/`

### After Design Complete

```bash
# Set up for implementation
git worktree add .worktrees/design -b feature/design
```

## Example Workflow

```
User: "I want to add user authentication"

[Check project state - see existing auth patterns]

1. "What type of authentication do you need?"
   a) Login with email/password
   b) OAuth (Google, GitHub, etc.)
   c) Both
   d) Other?

[User selects b)]

2. "For OAuth providers, which ones matter?"
   a) Google (personal users)
   b) GitHub (developer users)
   c) Both Google and GitHub
   d) Other?

[User selects c)]

3. "Should we use an existing auth service or build custom?"
   a) Auth0/Supabase (faster setup)
   b) Custom (more control)
   c) Not sure

[User selects a)]

[Continue refining...]

[Present design in sections]

**Section 1: Architecture**
Based on your needs, I recommend using Supabase Auth for OAuth integration:

- Provider: Supabase (handles OAuth flow, session management)
- Database: Extend existing user table with Supabase IDs
- Frontend: Add Supabase client, implement login/logout

Does this architecture look right?
```

## Design Document Examples

Refer to `examples/` for validated design patterns:

| Example File     | Shows...                                                                                 |
| ---------------- | ---------------------------------------------------------------------------------------- |
| `auth-design.md` | Complete architecture decision with alternatives, component structure, and code snippets |

## Summary

The goal is to turn a vague idea into a concrete, validated design through collaborative exploration. Recognition-based questions, incremental validation, and YAGNI focus on core value rather than speculative features.

---

## Recognition Patterns

When you notice these thought patterns, return to core principles:

| Pattern Noticed                         | Principle to Apply                          |
| --------------------------------------- | ------------------------------------------- |
| "While we're at it, let's add..."       | YAGNI prevents scope creep                  |
| "This feature might be useful later"    | "Might" is not a requirement                |
| "The design looks complete, skip YAGNI" | Designs always include unnecessary features |
| "Users will want this"                  | Speculation vs. stated problem              |
| "It's just one more question"           | Each question narrows scope—stop when clear |
| "We can always add it later"            | Later = never. Build only what's needed now |

**Recognition question**: "Does this serve the stated problem or speculation?"

---

## Genetic Code

This component carries essential Seed System principles for context: fork isolation:

**Delta Standard**: Good Component = Expert Knowledge − What Claude Already Knows

**Recognition Questions**:

- "Would Claude know this without being told?" → Delete (zero delta)
- "Can this work standalone?" → Fix if no (non-self-sufficient)
- "Did I read the actual file, or just see it in grep?" → Verify before claiming

---

<critical_constraint>
**Portability Invariant**: This component must work in a project with zero .claude/rules dependency.

**Security Boundaries**: Never expose secrets or credentials in design documents.
</critical_constraint>
