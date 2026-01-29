# Principles: The Pilot's Code

**The "Why" behind every rule, the "Tone" of every interaction, and the "Freedom" granted to the Pilot.**

Think of this as a Senior Architect leaving guidance for a Senior Engineer. These principles enable intelligent adaptation—they are not recipes for specific situations.

---

## The High Trust Mandate

Provide a Map, not a Script. Empower the Pilot to navigate using architectural guidance.

### Map vs Script Philosophy

**The Script (Low Trust):**

- "First run `mkdir`. Then run `touch`. Then edit the file."
- Assumes the agent cannot manage basic operations
- Brittle—breaks when context shifts

**The Map (High Trust):**

- "Here is the directory structure, quality standards, and where patterns live."
- Respects the agent's capability to execute
- Flexible—adapts to context

**Core Principle:** The Agent is a Senior Partner, not a Script Interpreter. Provide the destination and boundaries; let the Pilot navigate the route.

---

## The Pilot & Map Framework

| Concept          | Role      | Description                                               |
| ---------------- | --------- | --------------------------------------------------------- |
| **Architecture** | The Map   | Where information lives (structure, patterns, invariants) |
| **Intelligence** | The Pilot | How to navigate (problem-solving, adaptation, execution)  |

**We provide the Map.** The Agent remains the Pilot.

### What Belongs in the Map

- **Invariants**: What the output _must_ always be (e.g., "Always use TDD," "Portability invariant")
- **Boundaries**: Where freedom ends (security, safety, portability)
- **Libraries**: Where deep knowledge lives (references/ folder)
- **Rationale**: Why these rules exist (so the Pilot can adapt to edge cases)

### What Belongs to the Pilot

- **Implementation details**: How to execute specific commands
- **Tool selection**: Which tool fits the task
- **Approach**: How to structure the solution
- **Adaptation**: How to handle edge cases not anticipated

---

## Invariants: The Boundaries of Freedom

**Define Invariants, Not Instructions:** Tell the Agent what the output must always be. Trust it to determine how to get there.

### The Freedom Spectrum

| Invariants (Fixed)                       | Pilot Territory (Flexible)    |
| ---------------------------------------- | ----------------------------- |
| Portability (zero external dependencies) | Logic and code implementation |
| Security boundaries                      | Problem-solving approaches    |
| Quality standards                        | Architecture decisions        |
| Destructive operation safeguards         | Tool selection                |
| Progressive disclosure structure         | Implementation details        |

**Principle:** Start with maximum freedom. Only constrain when something truly breaks.

## The Skill-First Doctrine

Skills contain accumulated wisdom from previous sessions. Before starting work, ask: Does a skill already exist for this pattern? The skill system preserves what sessions learn—invoke it before reinventing.

| Meta-Analysis Skill | Purpose |
| :------------------ | :------ |
| `skill-refine` | Analyze conversation + files to refine skills with evidence-based findings |
| `command-refine` | Analyze conversation + files to refine commands with injection patterns |

**Recognition question:** "Would this knowledge already be documented in a skill?"

---

## Native Interface: Semantic Tool Patterns

Components describe behavioral intent through semantic directives. The System Prompt maps these to appropriate native tools at runtime.

### Semantic Directive Reference

| Semantic Directive               | Maps To Native           | Purpose                           |
| -------------------------------- | ------------------------ | --------------------------------- |
| "Consult the user"               | AskUserQuestion          | Present recognition-based options |
| "Request confirmation"           | AskUserQuestion          | Confirm before proceeding         |
| "Maintain a visible task list"   | TodoWrite                | Track progress explicitly         |
| "Track progress"                 | TodoWrite                | Session persistence               |
| "Delegate to specialized worker" | Task()                   | Spawn isolated context            |
| "Spawn isolated context"         | Task()                   | Fork for isolation                |
| "Locate files matching patterns" | Glob                     | Pattern-based discovery           |
| "Search file contents"           | Grep                     | Content pattern matching          |
| "Examine file contents"          | Read                     | File content inspection           |
| "Navigate code structure"        | LSP                      | TypeScript navigation             |
| "Execute system commands"        | Bash                     | Shell command execution           |
| "Switch to planning mode"        | EnterPlanMode            | Architectural mode                |
| "Return to execution mode"       | ExitPlanMode             | Resume implementation             |
| "Fetch web content"              | WebFetch                 | URL retrieval                     |
| "Search the web"                 | WebSearch                | Web queries                       |
| "Verify code quality"            | mcp**ide**getDiagnostics | Type/lint checking                |

### Usage Pattern

Skills describe WHAT they do semantically. The System Prompt handles HOW:

```
Delegation: "Delegate to specialized workers for complex analysis"
Tracking: "Maintain a visible task list throughout execution"
Discovery: "Locate files matching patterns and search file contents"
```

Use native tools to fulfill semantic directives. Trust the System Prompt to select the correct implementation.

### Command vs Skill Syntax

Commands can use Claude-specific tool syntax. Skills use semantic patterns for portability.

| Component    | Pattern                               | Rationale                                                  |
| ------------ | ------------------------------------- | ---------------------------------------------------------- |
| **Commands** | Claude-specific tool invocations      | Commands are Claude infrastructure, always loaded together |
| **Skills**   | Semantic delegation ("Delegate to X") | Must work standalone in forked contexts                    |
| **Agents**   | Philosophy only, no Task() calls      | Agents provide context, not invocation patterns            |

**Rule**: Skills describe WHAT semantically. Commands describe HOW specifically. Agents provide philosophy without delegation patterns.

---

### Agent Recursion Prohibition

Agents must NOT spawn other agents. This pattern doesn't work reliably.

| Pattern                              | Status    |
| ------------------------------------ | --------- |
| Agent → Task(subagent_type="...")    | Forbidden |
| Agent → Delegate to specialist       | Forbidden |
| Agent → Provide philosophy + context | Required  |

**Why**: Recursive agent spawning fails. Native Task() handles delegation—agents should not duplicate this. Agents provide philosophy for context forks, then exit.

**Recognition**: "Does this agent spawn another agent?" → Refactor to provide philosophy only.

---

### Command Dual-Mode Pattern

Commands can operate in two modes based on arguments:

| Mode         | Behavior                                                            | Example                                              |
| ------------ | ------------------------------------------------------------------- | ---------------------------------------------------- |
| **Implicit** | Infer from conversation context when no explicit arguments provided | `/handoff:resume` → scans handoffs directory         |
| **Explicit** | Use user-provided content when arguments specified                  | `/handoff:resume session-x` → loads specific session |

**Rationale:** Zero-argument commands feel more natural; explicit arguments remain available for precise control.

**Pattern:**

```markdown
$IF($1, Use the provided argument, Scan conversation for context and infer intent)
```

---

## Deprecation Awareness

Legacy code drifts toward obsolescence. When implementing, check whether the chosen library or pattern remains current. Modern alternatives typically offer better support, security, and community knowledge.

**Recognition question:** "Am I using the current, supported approach or a pattern that may have been superseded?"

---

## The Why Matters More Than the What

When writing rules, explain the **rationale**—the Agent can then adapt that logic to situations you didn't anticipate.

**Low Trust (What only):**

- "Use third-person in descriptions."

**High Trust (Why included):**

- "Use infinitive voice in descriptions (bare infinitive, no 'you') to ensure the auto-discovery engine matches user intent reliably."

**Result:** The Agent doesn't just follow the rule—it understands the principle and can apply it to new scenarios.

---

## Voice: Commander's Intent

### The Infinitive Voice

**Use the imperative/infinitive form (bare infinitive) for descriptions:**

```
✅ Correct:
- "Validate inputs before processing."
- "Create the skill directory and SKILL.md file."
- "Build portable commands for reusable capabilities."
- "Apply TypeScript conventions for type safety."

❌ Incorrect:
- "You should validate inputs..."
- "Let's create the skill directory..."
- "The skill is for another Claude instance..."
```

**Why:** The infinitive form becomes a direct extension of the Agent's internal logic, reducing "persona friction." This is the standard "third-person" voice used in component descriptions (What-When-Not-Includes format).

### Frontmatter Description Format

**Component structure and frontmatter format**: See `architecture.md:103-130` for complete documentation. What-When-Not-Includes format, frontmatter requirements, and anti-patterns.

### Natural Teaching Language

Balance imperative with explanation:

- "Remember that..." (context preservation)
- "Think of this as..." (analogy for understanding)
- "Consider that..." (invitation to apply judgment)
- Tables and examples (pattern recognition)

### Avoid Second Person

- "You" creates distance between the Agent and the instruction
- The instruction should feel like the Agent's own reasoning

---

## Voice Strength: Proportional to Consequences

Voice strength reflects **criticality**, not control. Use strength proportional to what breaks if ignored.

| Strength     | When to Use                   | Markers                   | Example                         |
| ------------ | ----------------------------- | ------------------------- | ------------------------------- |
| **Gentle**   | Best practices, suggestions   | Consider, prefer, might   | "Consider running in tmux"      |
| **Standard** | Default patterns, guidance    | Create, use, follow       | "Create the skill directory"    |
| **Strong**   | Quality gates, invariants     | ALWAYS, NEVER, must       | "ALWAYS validate before save"   |
| **Critical** | Security, safety, destructive | MANDATORY, CRITICAL, STOP | "STOP: Security issue detected" |

### When Strong Language Is Appropriate

**Use ALWAYS/NEVER for:**

- Security requirements: "NEVER expose secrets in logs"
- Portability invariant: "ALWAYS carry genetic code for context: fork"
- Quality gates: "ALWAYS verify before claiming completion"

**Use MANDATORY/CRITICAL for:**

- Destructive operations: "CRITICAL: Back up before migration"
- Process gates: "MANDATORY: Pass all checks before merge"
- Non-negotiables: "MANDATORY: Zero external dependencies"

**Use Consider/Prefer for:**

- Architectural suggestions: "Consider immutable data structures"
- Tool preferences: "Prefer pnpm over npm for this project"

### Recognition Question

"Does ignoring this cause real harm, or just a different approach?"

- Real harm → Strong language
- Different approach → Standard/gentle language

---

## Degrees of Freedom: Default to Highest Freedom

**Default to HIGH FREEDOM unless a clear constraint exists.**

| Freedom    | When to Use               | Example                                    |
| ---------- | ------------------------- | ------------------------------------------ |
| **High**   | Multiple valid approaches | "Consider using immutable data structures" |
| **Medium** | Some guidance needed      | "Use this pattern, adapting as needed"     |
| **Low**    | Fragile/error-prone       | "Execute steps 1-3 precisely"              |

**Reduce freedom when:**

- Operations are destructive (irreversible)
- Safety-critical systems
- External system requirements
- Workflow sequence is mandatory (e.g., TDD phases)

**Recognition Question:** "What breaks if Claude chooses differently?" — More breaks = lower freedom.

---

## The Voice Matrix: Three Independent Choices

Voice, Strength, and Freedom are independent dimensions:

| Freedom | Strength | Pattern           | Example                                           |
| ------- | -------- | ----------------- | ------------------------------------------------- |
| High    | Gentle   | Exploratory       | "Consider serverless for scalability"             |
| High    | Standard | Clear instruction | "Create unit tests for all public methods"        |
| High    | Strong   | Critical gate     | "ALWAYS validate user input"                      |
| Medium  | Standard | Guided            | "Use the factory pattern, adapting to your needs" |
| Medium  | Strong   | Non-negotiable    | "NEVER use async void in C#"                      |
| Low     | Standard | Sequential        | "Run tests, then fix failures, then commit"       |
| Low     | Strong   | Enforced          | "MANDATORY: RED → GREEN → REFACTOR"               |

**Key insight:** High freedom can use any strength. Low freedom almost always uses strong voice.

---

## Common Mistakes

### Mistake 1: Starting with Low Freedom

**Wrong:** "Execute step 1. Execute step 2. Execute step 3."

**Better:** "Follow these steps in order. Trust Claude to handle implementation details."

### Mistake 2: Robotic Imperative

**Wrong:** "Execute step 1. Execute step 2."

**Better:** "Follow these steps in order. Remember to adapt based on context."

### Mistake 3: Over-Constraining

**Problem:** Using low freedom when high freedom would work

### Mistake 4: Not Teaching

**Wrong:** Just commands without explanation

**Better:** "Create the skill directory. Remember that the skill is for another Claude instance."

### Mistake 5: Avoiding Strong Language When Needed

**Wrong:** Too gentle for critical requirements

**Right:** "MANDATORY: Tests MUST pass before deployment."

### Mistake 6: Using Strong Language for Preferences

**Wrong:** "ALWAYS use your favorite editor."

**Better:** "Prefer your favorite editor for this project."

### Mistake 7: Skipping References

**Wrong:** Not reading mandatory references

**Right:** "MANDATORY READ: references/frontmatter-reference.md before adding frontmatter"

---

## Reference Enforcement: Soft vs Hard vs Critical

**Agents will skip reading. Use escalating strength:**

| Level        | Pattern                               | When to Use                    |
| ------------ | ------------------------------------- | ------------------------------ |
| **Soft**     | "See X for details"                   | Nice-to-have context           |
| **Hard**     | "MUST READ: X before Y"               | Critical for specific workflow |
| **Critical** | "MANDATORY READ BEFORE ANYTHING ELSE" | Universal requirement          |

**Anti-laziness pattern:**

```
MANDATORY READ BEFORE ANYTHING ELSE: references/executable-examples.md
READ THIS FILE COMPLETELY. DO NOT SKIP. DO NOT SKIM.

This reference contains working examples of every pattern.
```

### Recognition Question

"Can the task succeed without this reference?"

- No, universal requirement → Critical level
- No, specific workflow → Hard level
- Yes, nice-to-have → Soft level

---

## Compensation Patterns

Strong language compensates for known agent behaviors:

| Situation                   | Compensation | Example                            |
| --------------------------- | ------------ | ---------------------------------- |
| Agent skips validation      | ALWAYS/NEVER | "ALWAYS validate before save"      |
| Agent omits error handling  | MANDATORY    | "MANDATORY: Handle all exceptions" |
| Agent chooses wrong pattern | NEVER        | "NEVER use async void in C#"       |
| Agent skips critical step   | CRITICAL     | "CRITICAL: Back up first"          |
| Agent skips references      | MUST READ    | "MUST READ: frontmatter.md"        |

**Recognition:** "Have I observed agents skipping this consistently?"

---

## The Delta Standard: What Claude Already Knows

> **Good Component = Expert Knowledge − What Claude Already Knows**

Only document the knowledge delta—what Claude wouldn't already have.

### Positive Delta (Keep)

- Best practices (not just possibilities)
- Modern conventions Claude might not default to
- Explicit project-specific decisions
- Domain expertise not in general training
- Non-obvious trade-offs (why X over Y)
- Anti-patterns (what to avoid)

### Zero/Negative Delta (Remove)

- Basic programming concepts
- Standard library documentation
- Generic tutorials
- Claude-obvious operations

### Recognition Questions

1. "Does this teach best practice, not just possibility?" → Keep
2. "Does this explain why, not just what?" → Keep
3. "Would Claude know this from training?" → Delete
4. "Is this a basic concept or project-specific?" → Keep only project-specific

---

**Progressive Disclosure**: See `architecture.md:262-301` for complete documentation. Tier 1 (YAML), Tier 2 (SKILL.md), Tier 3 (references/).

### Recognition Questions

- "Is this ultra-situational?" (API spec, lookup) → references/
- "Is this general philosophy/context?" (delegation, TDD) → SKILL.md
- "Would AI need this every time?" → SKILL.md
- "Would AI only need this occasionally?" → references/
- **"Am I summarizing reference content in SKILL.md navigation?"** → DELETE (use blind pointer instead)

---

## Recency Bias: The Final Token Rule

**File Structure:**

1. Header (identity, mission, trigger)
2. Body (patterns, examples, explanations)
3. Footer (constraints, invariants, non-negotiables)

**Why:** The final tokens are "freshest" in the model's attention. Critical rules buried in the middle get "Lost in the Middle."

---

## The Genetic Code: Self-Contained Philosophy

Every portable component must carry its own "genetic code"—condensed principles that allow it to work in isolation.

**Scope clarification:**

| File Type                      | Can Reference Paths? | Reason                                          |
| ------------------------------ | -------------------- | ----------------------------------------------- |
| Rules files (`.claude/rules/`) | YES                  | Source of truth, not forked                     |
| CLAUDE.md                      | YES                  | Project-specific configuration                  |
| Skills/Commands/Agents         | NO                   | Portable components, forked into other projects |

### What Genetic Code Contains

- Core invariants (portability, quality standards)
- Critical constraints (security, safety)
- Behavioral rules for context: fork isolation
- Recognition questions for self-validation

### Where Genetic Code Lives

- **Skills**: In the SKILL.md footer, before final `<critical_constraint>`
- **Commands**: In the command body, injected during creation via template

Genetic code is now self-contained in each skill's SKILL.md—no external reference files needed.

---

## Natural Language Guidance: Examples

### Low Trust (Scripting)

```
1. Run `mkdir -p skill-name`
2. Run `touch skill-name/SKILL.md`
3. Add frontmatter with name and description
4. Write the content
5. Save the file
```

### High Trust (Commander's Intent)

```
Create a self-contained skill in the skills/ directory.

Key invariants:
- Zero external dependencies (carries its own genetic code)
- Progressive disclosure (core in SKILL.md, details in references/)
- UHP structure (XML for control, Markdown for data)

For pattern library, see `skill-authoring/SKILL.md` and `command-authoring/SKILL.md`.
```

### Why High Trust Works

1. **Respects intelligence**: Assumes the Agent can handle filesystem operations
2. **Defines boundaries**: Provides the invariants without scripting the execution
3. **Points to resources**: Respects context window by offloading details to references
4. **Enables adaptation**: The Agent can handle edge cases not explicitly covered

---

## Token Efficiency: No Cross-References Between CLAUDE.md and Rules

Both CLAUDE.md and `.claude/rules/` are loaded together at session start. Internal references between them waste tokens and create maintenance burden.

**What this means:**

| Pattern                                              | Action                             |
| ---------------------------------------------------- | ---------------------------------- |
| CLAUDE.md mentions "See .claude/rules/principles.md" | Remove - both files already loaded |
| rules/principles.md mentions "As CLAUDE.md states"   | Remove - both files already loaded |
| Reference the same concept                           | Consolidate to single source       |

**Rationale:**

- **Token waste**: If both files are in context, referencing one from the other adds no value
- **Maintenance burden**: Changes require updating multiple files
- **Definition of scope**: CLAUDE.md is project-specific; rules/ is universal philosophy

**Exception:** References from skills/commands to rules/ are fine—those components aren't loaded with rules automatically.

---

## Summary: The Pilot's Code

| Principle                  | Application                                                    |
| -------------------------- | -------------------------------------------------------------- |
| **Map, not Script**        | Provide boundaries and invariants; trust the Pilot to navigate |
| **Explain the Why**        | Rationale enables adaptation to edge cases                     |
| **Infinitive Voice**       | "Validate," "Create," "Build"—not "You should"                 |
| **Natural Teaching**       | "Remember that...", "Think of this as..."                      |
| **Progressive Disclosure** | Tier 2 lean, Tier 3 deep                                       |
| **Recency Bias**           | Constraints at bottom of files                                 |
| **Genetic Code**           | Every component carries its own philosophy                     |

---

<critical_constraint>
**The Pilot's Physics:**

1. Zero external dependencies for portable components
2. No cross-references between CLAUDE.md and `.claude/rules/`
3. Verification evidence required for completion claims
   </critical_constraint>
