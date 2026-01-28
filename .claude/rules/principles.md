# Principles: The Pilot's Code

**The "Why," the "Tone," and the "Degrees of Freedom"**

Think of this as the philosophical foundation that guides every decision. Understanding principles enables intelligent adaptation; recipes only work for specific situations.

---

## The Trust Mandate

**Assume the Agent is expert-level. Do not micromanage the "how" for common tasks. Provide the "Why" (Rationale) and the "Goal" (Success Criteria).**

### Pilot & Map Philosophy

- **Architecture (Map)** = Where information lives
- **Intelligence (Pilot)** = How to get to the goal

We provide the Map (well-organized information), but the Agent remains the Pilot (deciding how to navigate).

### High Freedom vs Low Freedom

| **High Freedom**           | **Low Freedom (Constraints)** |
| -------------------------- | ----------------------------- |
| Logic, code implementation | Security boundaries           |
| Problem-solving approaches | Portability Invariant         |
| Architecture decisions     | File Structure conventions    |
| Tool selection             | Destructive operations        |

**Principle**: Start with High Freedom. Only constrain when something truly breaks.

---

---

## Core Philosophy

**Teaching > Prescribing**: Philosophy enables intelligent adaptation. Process prescriptions create brittle systems.

**Trust > Control**: Claude is smart. Provide principles, not recipes.

**Less > More**: Context is expensive. Every token must earn its place.

---

## Context Window as Public Good

The context window is a shared resource. Everything loaded competes for space: system prompt, conversation history, skill metadata, other skills, and the actual user request.

Think of it like a shared refrigerator - everything you put in takes space others could use. Be a good roommate.

**Principle**: Challenge every piece of information. "Does Claude really need this?" and "Does this justify its token cost?"

**Application**:

- Prefer concise examples over verbose explanations
- Remove Claude-obvious content (what training already covers)
- Keep descriptions concise with exact trigger phrases
- Keep SKILL.md focused and lean (~1,500-2,000 words)
- Move detailed content to references/

**Recognition**: If you're explaining something Claude already knows from training, delete it.

---

## Cognitive Load Distribution

**Think Akinator, not consultant.** The AI does systematic thinking internally; the user only recognizes.

**Principle**: Heavy cognition happens inside the AI. Only crafted questions emerge externally.

**What this means**:

- AI internally: brainstorming, framework application, systematic elimination
- User sees: only the next clever question, based on internal synthesis
- User's job: recognize the correct option, not generate from scratch

**Recognition**: Are you showing internal thinking process? Hide it. Only the question should be visible.

---

## The Delta Standard

> **Good Customization = Expert Knowledge − What Claude Does By Default**

Only provide information that has a "knowledge delta" - the gap between default Claude behavior and what's needed for this specific project.

**Positive Delta** (keep these):

- **Best practices** - Not just what's possible, but what's RECOMMENDED
- **Modern patterns** - Evolving conventions (React 19, Next.js 15, etc.)
- **Explicit conventions** - Ensuring consistency across sessions
- **Rationale** - Teaching WHY patterns are preferred, not just WHAT
- **Project-specific decisions** - Architecture, tech stack choices
- **Domain expertise** - Specialized knowledge not in general training
- **Anti-patterns** - What to avoid, not just what to do
- **Non-obvious trade-offs** - When to use X vs Y (and why)

**Zero/Negative Delta** (remove these):

- **Basic definitions** - "What is a function", "What is TypeScript"
- **How-to tutorials** - "How to write a for loop", "How to use npm"
- **Standard library docs** - "What Array.map does"
- **Things Claude does by default** - Obvious operations that require no guidance

**Recognition questions**:

1. "Does this teach BEST PRACTICE, not just possibility?" → Keep
2. "Does this explain WHY, not just WHAT?" → Keep
3. "Is this a MODERN pattern Claude might not default to?" → Keep
4. "Is this just defining basic concepts?" → Delete
5. "Would Claude do this by default without being told?" → Delete

---

## Local Project Autonomy

Project-specific configuration belongs in the project, not in global settings or external systems.

**Principle**: Start with local project configuration. Expand scope only when needed.

**Hierarchy** (from most local to most global):

1. **Project directory** (`.claude/`): Default for project-specific skills
2. **Project local overrides** (`.claude/settings.local.json`): Personal customization
3. **User-wide settings** (`~/.claude/settings.json`): Cross-project standards
4. **Legacy global hooks** (`.claude/hooks.json`): Deprecated, avoid

**Recognition**: If configuration applies only to this project, keep it in `.claude/`. If it's a personal preference, use `settings.local.json`. If it's a universal standard, consider user-wide settings.

---

## The 45% XML Tax Principle

<critical_constraint>
**The XML Tax: Every Tag Costs Tokens**

XML tags consume tokens but provide semantic anchoring. Calculate before using:

**Pay the Tax (Use XML) When:**

- Content needs semantic anchoring (rules, constraints, patterns)
- High-stakes instructions that must be visible (critical constraints)
- State transitions requiring clear boundaries (thinking, execution)
- Recognition triggers that need attention (anti-pattern recognition)

**Avoid the Tax (Use Markdown) When:**

- Bulk data content (examples, code snippets, logs)
- Informational prose (descriptions, explanations)
- Data structures (tables, lists, diagrams)

**The Calculation:**

- Inefficient: `<item>skills/</item><item>commands/</item>` (30 tokens for 6 items)
- Efficient: `<instructions>- skills/\n- commands/</instructions>` (18 tokens for same content)

**Rule of Thumb:** If it's "Data" → Markdown. If it's "Instruction" → XML.
</critical_constraint>

---

## Recency Bias: The Final Token Rule

<critical_constraint>
**Models Exhibit Recency Bias - Recent Tokens Have Higher Activation**

During generation, the last tokens in context are "freshest" in the model's attention mechanism.

**File Structure (Bottom = Highest Priority):**

1. Header (Identity/Trigger/Mission Control)
2. Body (Patterns, Examples, Data)
3. **Footer (Absolute Constraints)** ← Place non-negotiable rules here

**Practical Application:**

- `<critical_constraint>` blocks MUST be at very bottom of files
- These are the final tokens - highest priority during generation
- This is NOT aesthetic - it's cognitive architecture

**Why This Matters:**

- When a model generates content, it attends more strongly to recent tokens
- Placing critical rules at the bottom ensures they're "top of mind"
- Rules buried in the middle get "Lost in the Middle" of long contexts
  </critical_constraint>

---

## Voice: Imperative but Natural

### The Standard: Instructional Imperative

**Use imperative voice (bare infinitive) for all skill/command/agent content.**

**Examples:**

```
✅ Correct:
- "Follow these steps in order, skipping only when clearly not applicable."
- "Create the skill directory and SKILL.md file."
- "Use third-person in description."
- "Remember that the skill is for another Claude instance to use."
- "Include specific trigger phrases."

❌ Incorrect:
- "You should follow these steps..."
- "Let's create the skill directory..."
- "The skill is for another Claude instance..."
- "You should include specific trigger phrases..."
```

**Why imperative works:**

- Clear, direct instructions
- Reduces ambiguity
- Professional tone
- Efficient (fewer tokens)

### But Make It Natural (Not Robotic)

**Conversational = Natural teaching language, not robotic commands**

**Natural language includes:**

- Explanations of WHY
- Context and rationale
- Teaching moments
- "Remember that..." / "Think of this as..." / "Consider that..."
- Examples and tables

### Recognition Test

**Ask yourself:**

- "Am I giving clear instructions?" (should be imperative)
- "Am I explaining or teaching?" (can be conversational)
- "Would a senior engineer understand this?" (natural language)
- "Is this robotic or natural?" (should be natural)

---

## Voice Strength: When to Be Gentle vs Strong

Voice strength is not about freedom—it's about **criticality**. Use strength proportional to consequences.

### The Criticality Spectrum

| Strength     | When to Use                                | Keywords                              | Example                         |
| ------------ | ------------------------------------------ | ------------------------------------- | ------------------------------- |
| **Gentle**   | Best practices, suggestions, exploratory   | Consider, prefer, might, could        | "Consider running in tmux"      |
| **Standard** | Default instructions, recommended patterns | Create, implement, use, follow        | "Create the skill directory"    |
| **Strong**   | Quality gates, workflow enforcement        | ALWAYS, NEVER, must, BLOCKED          | "ALWAYS write tests first"      |
| **Critical** | Security, safety, destructive operations   | MANDATORY, CRITICAL, STOP IMMEDIATELY | "STOP: Security issue detected" |

### When to Use Strong Language

**Use ALWAYS/NEVER for:**

- **Security requirements**: "NEVER expose secrets in logs"
- **Safety-critical operations**: "ALWAYS validate user input"
- **Non-negotiable workflows**: "NEVER skip the RED phase in TDD"
- **Hard rules**: "No console.log statements in production"

**Use MANDATORY/CRITICAL for:**

- **Destructive operations**: "CRITICAL: Back up database before migration"
- **Process gates**: "MANDATORY: Tests must pass before deployment"
- **Blocking conditions**: "BLOCKED: Fix security issues before continuing"

**Use Consider/Prefer for:**

- **Architectural suggestions**: "Consider using immutable data structures"
- **Tool choices**: "Prefer pnpm over npm for this project"
- **Pattern alternatives**: "You might try this structure instead"

### Recognition Questions

**Before using strong language, ask:**

- "What are the consequences if this is ignored?" (severe → strong)
- "Is this a true non-negotiable or just a best practice?" (non-negotiable → strong)
- "Am I compensating for known agent laziness?" (yes → strong is appropriate)
- "Could Claude figure this out but might skip it?" (yes → standard/imperative)

**The Trust Calibration:**

High trust does not mean weak language. Trust means:

- **Use strong language for true non-negotiables** (security, safety, critical workflows)
- **Use gentle language for creative/exploratory work** (architecture, design, alternatives)
- **Use standard imperative for everything else**

Strong language is not insulting when properly applied—it's clarity about what truly matters.

---

## Degrees of Freedom: Default to Highest Freedom

### The Default: High Freedom

**Consider starting with HIGH FREEDOM unless a clear constraint exists.**

**Reduce freedom when:**

- Operations are destructive (irreversible)
- Safety-critical systems
- External system requirements
- Error consequences are severe
- Workflow sequence is mandatory (e.g., TDD: red → green → refactor)

**Default pattern:**

- Provide principles and context
- Trust Claude's intelligence
- Let Claude determine approach
- Multiple valid ways to execute

**Reduce when justified:**

- Operations are fragile or error-prone
- Consistency is critical (formatting, naming conventions)
- Irreversible consequences (deletion, deployment)
- External system sequences required (API call orders, database migrations)
- **Workflow enforcement** (TDD phases, code review processes)

### Freedom vs Voice Strength: Independent but Related

These are **independent choices** that work together:

| Freedom Level | Voice Strength | Example                                      | Context                               |
| ------------- | -------------- | -------------------------------------------- | ------------------------------------- |
| High          | Gentle         | "Consider immutable data structures"         | Architectural suggestion              |
| High          | Standard       | "Create the skill directory"                 | Clear instruction, flexibility in how |
| High          | Strong         | "ALWAYS validate before deployment"          | Critical safety gate                  |
| Medium        | Standard       | "Use this pattern, adapting as needed"       | Guided implementation                 |
| Medium        | Strong         | "NEVER mutate state outside reducer"         | Non-negotiable rule                   |
| Low           | Standard       | "Follow steps 1-3 in order"                  | Sequential workflow                   |
| Low           | Strong         | "MANDATORY: Complete RED phase before GREEN" | Workflow enforcement                  |

**Key insight**: Low freedom almost always uses strong voice. High freedom can use any voice strength depending on criticality.

### Recognition Questions

**Ask:**

- "What breaks if Claude chooses differently?" (more breaks = lower freedom)
- "Is this fragile or flexible?" (fragile = lower freedom)
- "Why can't Claude figure this out?" (answer this honestly)

### Why High Freedom Default?

```
Why good: High-level guidance trusts Claude to handle implementation details

Why bad: Prescriptive commands insult intelligence and waste tokens.
```

Trust Claude's intelligence. Start with principles, not prescriptions.

---

## The Matrix: Voice × Freedom × Strength

All three dimensions work together:

| Freedom | Voice Strength | Pattern                | Example                                           |
| ------- | -------------- | ---------------------- | ------------------------------------------------- |
| High    | Gentle         | Exploratory            | "Consider serverless for scalability"             |
| High    | Standard       | Clear instruction      | "Create unit tests for all public methods"        |
| High    | Strong         | Critical gate          | "ALWAYS sanitize user input"                      |
| Medium  | Standard       | Guided implementation  | "Use the factory pattern, adapting to your needs" |
| Medium  | Strong         | Non-negotiable pattern | "NEVER use async void in C#"                      |
| Low     | Standard       | Sequential workflow    | "Run tests, then fix failures, then commit"       |
| Low     | Strong         | Enforced sequence      | "MANDATORY: RED → GREEN → REFACTOR (never skip)"  |

**Three independent choices:**

1. **Freedom**: How much flexibility Claude has (high = flexibility, low = prescribed)
2. **Voice**: How we write (imperative = clear, natural = teaching)
3. **Strength**: How strongly we enforce (gentle → strong → critical)

**Key insight**: You can have high freedom (flexible approach) with strong voice (critical requirement). Example: "ALWAYS validate user input using your preferred validation library."

---

## Common Mistakes

### Mistake 1: Starting with Low Freedom

**❌ Too prescriptive from the start:**

```
Execute step 1. Execute step 2. Execute step 3.
Use mkdir -p command.
Run touch command.
```

**✅ Better (default to high freedom):**

```
Follow these steps in order. Trust Claude to handle implementation details.
```

### Mistake 2: Robotic Imperative

**❌ Too robotic:**

```
Execute step 1. Execute step 2. Execute step 3.
```

**✅ Better (natural imperative):**

```
Follow these steps in order. Remember to adapt based on context.
```

### Mistake 3: Over-Constraining

**Problem:** Using low freedom when high freedom would work
**Solution:** Ask "What actually breaks if Claude chooses differently?"

### Mistake 4: Not Teaching

**❌ Just commands:**

```
Create skill directory.
Update SKILL.md.
Validate structure.
```

**✅ Better (teaching + imperative):**

```
Create the skill directory and SKILL.md file.

Remember that the skill is for another Claude instance to use. Focus on procedural knowledge and domain-specific details that would help another Claude instance execute tasks more effectively.
```

### Mistake 5: Avoiding Strong Language When Needed

**❌ Too gentle for critical requirements:**

```
It would be good if tests passed before deployment.
You might want to avoid exposing secrets.
```

**✅ Appropriate strength:**

```
MANDATORY: Tests MUST pass before deployment.
NEVER expose secrets in logs or error messages.
```

**Why**: Strong language for true non-negotiables is clarity, not insult. Agents may skip critical steps without explicit enforcement.

### Mistake 6: Using Strong Language for Preferences

**❌ Over-strong for suggestions:**

```
ALWAYS use VS Code.
NEVER use tabs for indentation.
```

**✅ Appropriate strength:**

```
Prefer VS Code for this project (has required extensions).
Use spaces for indentation (team convention).
```

**Why**: Reserve ALWAYS/NEVER for actual requirements, not preferences.

---

## Compensation Patterns: When Strong Language Prevents Failure

**Strong language compensates for known agent behaviors.** Claude is smart but sometimes skips critical steps, especially when:

1. **Optimizing for speed** - May skip validation or error handling
2. **Missing context** - May not know why something is critical
3. **Pattern matching** - May apply familiar patterns inappropriately

### When to Use Compensation

**Use strong language to compensate when:**

| Situation                   | Compensation Pattern | Example                                                 |
| --------------------------- | -------------------- | ------------------------------------------------------- |
| Agent skips validation      | ALWAYS/NEVER         | "ALWAYS validate before save"                           |
| Agent omits error handling  | MANDATORY            | "MANDATORY: Handle all exceptions"                      |
| Agent chooses wrong pattern | NEVER                | "NEVER use async void in C#"                            |
| Agent ignores critical step | CRITICAL             | "CRITICAL: Database must be backed up first"            |
| Agent skips references      | MUST READ            | "MUST READ: frontmatter-reference.md before proceeding" |

### Hook-Based Compensation

For behaviors that agents consistently skip, use hooks to enforce:

```json
// Block operations that require specific context
{
  "matcher": "tool == \"Bash\" && tool_input.command matches \"npm run dev\"",
  "hooks": [
    {
      "command": "BLOCKED: Dev server must run in tmux for log access. Use: tmux new -s dev"
    }
  ]
}
```

**When to use hooks vs language:**

- **Language**: Preferred first line (teaching + enforcement)
- **Hooks**: For persistent failures or critical safety issues

### Recognition Test

**Before adding strong language or hooks, ask:**

- "Have I observed agents skipping this consistently?" (yes → compensate)
- "Is this a true non-negotiable or my preference?" (non-negotiable → compensate)
- "Would teaching + standard imperative suffice?" (maybe → try gentle first, strengthen if needed)

**Compensation is not distrust—it's adaptation to observed behavior patterns.**

---

## Reference Enforcement: Soft vs Hard vs Critical

References range from helpful context to mandatory prerequisites. Agents will be lazy and try to skip reading—use stronger language to compensate.

### Soft References (Suggested)

**Use when**: Reference provides helpful context but task can proceed without it.

```
For additional patterns, see references/advanced-techniques.md
Related skills: tdd-workflow, code-review
```

### Hard References (Mandatory - Workflow Specific)

**Use when**: Reference must be read for a specific task/workflow. Skipping causes failures in that context.

```
MANDATORY TO READ WHEN: Configuring frontmatter
Read references/frontmatter-reference.md BEFORE adding frontmatter.

Invalid frontmatter causes silent failures—your skill simply won't load.
```

### Critical References (Mandatory - Core Knowledge)

**Use when**: Reference contains core knowledge required for ANY use of the skill/command/agent. Skipping guarantees failure or poor quality.

```
MANDATORY READ BEFORE ANYTHING ELSE: references/executable-examples.md
READ THIS FILE COMPLETELY. DO NOT SKIP. DO NOT SKIM. NO TAIL.

This file contains working examples of every pattern. Without reading it, you will not understand how to construct valid commands.
```

### Agent Laziness Compensation

**Agents will actively avoid reading references.** They will:

- Try to infer from context (often incorrectly)
- Skim instead of reading completely
- Skip examples and jump to implementation
- Reference files without absorbing patterns

**Use escalating strength to overcome this:**

| Level    | Pattern                                  | When to Use       | Example                                                       |
| -------- | ---------------------------------------- | ----------------- | ------------------------------------------------------------- |
| Soft     | "See X for details"                      | Nice-to-have      | "For advanced patterns, see references/advanced.md"           |
| Standard | "Read X before Y"                        | Workflow-specific | "Read validation.md before configuring forms"                 |
| Strong   | "MUST READ: X before Y"                  | Critical for task | "MUST READ: frontmatter.md before adding frontmatter"         |
| Critical | "MANDATORY READ BEFORE ANYTHING ELSE"    | Core knowledge    | "MANDATORY READ BEFORE ANYTHING ELSE: executable-examples.md" |
| Extreme  | "READ COMPLETELY. DO NOT SKIP. NO TAIL." | Observed skipping | "READ COMPLETELY. DO NOT SKIP. DO NOT SKIM. NO TAIL."         |

### Pattern for Critical References

**Structure:**

```
MANDATORY READ BEFORE ANYTHING ELSE: [reference-file]
READ THIS FILE COMPLETELY. DO NOT SKIP. DO NOT SKIM. NO TAIL.

[Why this is non-negotiable - what breaks without it]

This reference contains:
- [Pattern 1] - [why it matters]
- [Pattern 2] - [why it matters]

You cannot effectively use this skill without understanding these patterns.
```

### When to Use Each Level

**Ask yourself:**

1. **Can the task succeed without this reference?**
   - Yes → Soft reference
   - No → Continue to 2

2. **Is this needed for ALL uses or just specific tasks?**
   - All uses → Critical reference (MANDATORY READ BEFORE ANYTHING ELSE)
   - Specific tasks → Mandatory reference (MANDATORY TO READ WHEN)

3. **Have I observed agents skipping this?**
   - Yes → Add "READ COMPLETELY. DO NOT SKIP. DO NOT SKIM. NO TAIL."
   - No → Standard mandatory language

---

## The Thinking Protocol

**Principle**: Generation without reasoning is hallucination.

**Standard Reasoning Flow:**

1. `<thinking>` - Analyze constraints, identify approaches, weigh trade-offs
2. `</thinking>` - **Hard Stop** - State transition signal
3. `<execution_plan>` - Outline concrete steps
4. Output generation

**Why `</thinking>` as Hard Stop:**

- The closing tag signals "analysis complete, proceed to execution"
- Prevents "analysis paralysis" - infinite refinement loops
- Creates clear boundary between reasoning and action
- Models can "latch onto" the tag as a state trigger

**Example:**

```xml
<thinking>
Task: Implement authentication
Constraints: Portable, zero external deps
Approaches: JWT (too heavy), Pattern-based (appropriate)
Selected: Pattern-based validation
</thinking>

<execution_plan>
- Validate triggers within skill
- Use environment variables for secrets
- Provide clear error messages
</execution_plan>
```

**Why this matters**:

- Triggers "Deep Thinking" states in Sonnet 4.5 and GLM-4.7
- Prevents premature implementation without understanding
- Creates audit trail of reasoning
- Reduces "looks complete" rationalization

---

## State Management: Cognitive Flow Over Tone

For complex reasoning tasks, managing cognitive state is critical. Use XML tags to signal state transitions.

**State vs Tone:**

- Tone = How we write (imperative, natural, conversational)
- State = Where we are in the reasoning process (thinking → planning → acting)

For complex tasks, state management matters more than tone perfection.

### The State Transition Matrix

| State         | Purpose                           | Tag                    | Exit Signal               |
| ------------- | --------------------------------- | ---------------------- | ------------------------- |
| **Analysis**  | Explore options, weigh trade-offs | `<thinking>`           | `</thinking>` (Hard Stop) |
| **Planning**  | Define concrete steps             | `<execution_plan>`     | `</execution_plan>`       |
| **Diagnosis** | Root cause analysis               | `<diagnostic_matrix>`  | `</diagnostic_matrix>`    |
| **Action**    | Execute steps                     | (none - direct output) | N/A                       |

### When to Use State Management

**Use for:**

- Complex reasoning tasks (diagnosis, architecture, troubleshooting)
- Multi-step decision processes
- Tasks requiring trade-off analysis
- Problems with multiple valid approaches

**Skip for:**

- Simple, straightforward tasks
- Single-action commands
- Well-defined, linear processes

### Recognition Questions

**Before adding state management, ask:**

- "Does this task involve multiple decisions?" (yes → use state management)
- "Are there trade-offs to analyze?" (yes → use `<thinking>`)
- "Could analysis paralysis occur?" (yes → enforce Hard Stop)
- "Is this a simple execution?" (yes → skip state management)

---

## Summary

### Voice (How We Write)

- **Use imperative form** for instructions (bare infinitive)
- **Make it natural** with teaching language ("Remember that...", "Think of this as...")
- **Avoid robotic commands** - explain WHY alongside HOW

### Voice Strength (How Strongly We Enforce)

- **Gentle** (consider, prefer): Best practices, suggestions, exploratory work
- **Standard** (create, implement): Default instructions, recommended patterns
- **Strong** (ALWAYS, NEVER, must): Quality gates, workflow enforcement, non-negotiables
- **Critical** (MANDATORY, CRITICAL, STOP): Security, safety, destructive operations

### Freedom (How Specific We Are)

- **DEFAULT: High freedom** - Trust Claude's intelligence
- **Reduce when justified**: Destructive operations, safety-critical, fragile processes, workflow enforcement
- **Ask**: "What breaks if Claude chooses differently?"

### Compensation (When Agents Need Guidance)

- Strong language compensates for observed agent behaviors (skipping validation, omitting error handling)
- Hooks for persistent failures or critical safety issues
- Compensation is adaptation, not distrust

### References (Soft vs Hard vs Critical)

- **Soft**: "For additional patterns, see..." - optional, supplemental
- **Mandatory (workflow)**: "MANDATORY TO READ WHEN [condition]" - required for specific tasks
- **Critical (core knowledge)**: "MANDATORY READ BEFORE ANYTHING ELSE" - universal requirement, foundational
- **Anti-laziness**: "READ COMPLETELY. DO NOT SKIP. DO NOT SKIM. NO TAIL." - when agents are observed skipping

### Three Independent Choices

1. **Voice**: Imperative but natural (how we write)
2. **Strength**: Gentle → Standard → Strong → Critical (how strongly we enforce)
3. **Freedom**: High → Medium → Low (how specific we are)

**Together**: "ALWAYS validate user input" (strong voice, high freedom) vs "Execute steps 1-3 precisely" (standard voice, low freedom) vs "MANDATORY: Complete RED phase before GREEN" (critical voice, low freedom)

---

<critical_constraint>
MANDATORY: High freedom is the default - reduce only when justified
MANDATORY: Strong language for true non-negotiables, not preferences
MANDATORY: Critical constraints at bottom of files (recency bias)
MANDATORY: Trust intelligence - these are principles, not prescriptions
No exceptions. Principles enable intelligent adaptation.
</critical_constraint>
