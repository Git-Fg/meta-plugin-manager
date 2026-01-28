# Principles: The Pilot's Code

**The "Why" behind every rule, the "Tone" of every interaction, and the "Freedom" granted to the Pilot.**

Think of this as a Senior Architect leaving guidance for a Senior Engineer. These principles enable intelligent adaptation—they are not recipes for specific situations.

---

## The High Trust Mandate

<mission_control>
<objective>Provide a Map, not a Script. Empower the Pilot to navigate using architectural guidance.</objective>
<success_criteria>Claude acts as a Senior Partner who uses rules as boundaries, not step-by-step instructions.</success_criteria>
</mission_control>

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

<critical_constraint>
**Define Invariants, Not Instructions.**

Tell the Agent what the output must always be. Trust it to determine how to get there.
</critical_constraint>

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

<critical_constraint>
**ALWAYS check for a skill before implementing.**
</critical_constraint>

**The Protocol:**

1. **Search**: `ls .claude/skills`
2. **Read**: `view_file .claude/skills/SKILL/SKILL.md`
3. **Execute**: Follow the skill's instructions exactly

**Why**: Skills contain the "Genetic Code" - the condensed wisdom of previous sessions. Ignoring them leads to regression.

---

## Deprecation Awareness

<critical_constraint>
**ALWAYS check for library deprecations before implementation.**
</critical_constraint>

**The Protocol:**

1. **Check**: Run `npm view package time` or check docs
2. **Verify**: If using standard libraries, check for `@deprecated` tags
3. **Modernize**: Prefer the stable, modern alternative over the legacy easy path

**Why**: Legacy code drifts. Modern code stays relevant longer.

---

## The Why Matters More Than the What

When writing rules, explain the **rationale**—the Agent can then adapt that logic to situations you didn't anticipate.

**Low Trust (What only):**

- "Use third-person in descriptions."

**High Trust (Why included):**

- "Use third-person in descriptions to ensure the auto-discovery engine matches user intent reliably."

**Result:** The Agent doesn't just follow the rule—it understands the principle and can apply it to new scenarios.

---

## Voice: Commander's Intent

### The Infinitive Voice

**Use the imperative/infinitive form (bare infinitive):**

```
✅ Correct:
- "Validate inputs before processing."
- "Create the skill directory and SKILL.md file."
- "Use third-person in descriptions."
- "Carry genetic code for context: fork isolation."

❌ Incorrect:
- "You should validate inputs..."
- "Let's create the skill directory..."
- "The skill is for another Claude instance..."
```

**Why:** The infinitive form becomes a direct extension of the Agent's internal logic, reducing "persona friction."

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

### When to Use Each Level

1. **Can the task succeed without this?**
   - Yes → Soft reference
   - No → Continue to 2

2. **All uses or specific tasks?**
   - All uses → Critical reference
   - Specific tasks → Hard reference

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

## Progressive Disclosure: Respect the Context Window

Think of the Map as having layers. Not every piece of information belongs in the main file.

**CRITICAL**: Progressive disclosure applies ONLY to `.claude/skills/` - NOT to commands, agents, hooks, or MCP servers.

| Layer      | Content                                         | Tokens        | Guideline                               |
| ---------- | ----------------------------------------------- | ------------- | --------------------------------------- |
| **Tier 1** | YAML metadata (What-When-Not)                   | ~100          | Always                                  |
| **Tier 2** | SKILL.md - full philosophy, patterns, workflows | 1.5k-2k words | Target ~500 lines, flexible for context |
| **Tier 3** | references/ - ultra-situational lookup material | Unlimited     | 2-3 files (rule of thumb)               |

**Principle**: Tier 2 contains the FULL philosophy and context. Tier 3 is ONLY for ultra-situational information that AI would need to look up (API specs, code examples, detailed troubleshooting).

**Key clarifications**:

- **~500 lines is a rule of thumb**, NOT enforced against contextualization and readability
- **Full philosophy in SKILL.md** - Delegation patterns, TDD requirements, domain knowledge belong in Tier 2
- **References/ for ultra-situational info only** - Things you'd grep/search for when needed
- **Each reference must have "Use when" context** - Clear trigger without spoiling content
- **2-3 reference files is typical** - Big libraries/APIs can have more, but prefer fewer

### How to Progressive Disclose

- **Tier 2 (SKILL.md)**: Core concepts, philosophy, main workflows, key patterns, complete examples
- **Tier 3 (references/)**: API specifications, lookup tables, code snippets, edge case details
- **Navigation**: "If you need... Read..." table pattern

### Recognition Questions

- "Is this ultra-situational?" (API spec, lookup) → references/
- "Is this general philosophy/context?" (delegation, TDD) → SKILL.md
- "Would AI need this every time?" → SKILL.md
- "Would AI only need this occasionally?" → references/

---

## Recency Bias: The Final Token Rule

<critical_constraint>
**Place all constraint-related content at the very bottom of files.**

Models attend more strongly to recent tokens during generation.
</critical_constraint>

**File Structure:**

1. Header (identity, mission, trigger)
2. Body (patterns, examples, explanations)
3. Footer (constraints, invariants, non-negotiables)

**Why:** The final tokens are "freshest" in the model's attention. Critical rules buried in the middle get "Lost in the Middle."

---

## The Genetic Code: Self-Contained Philosophy

Every component must carry its own "genetic code"—condensed principles that allow it to work in isolation.

<critical_constraint>
**Portability Invariant: Zero External Dependencies**

Every component MUST work in a project with ZERO `.claude/rules/` access.
</critical_constraint>

### What Genetic Code Contains

- Core invariants (portability, quality standards)
- Critical constraints (security, safety)
- Behavioral rules for context: fork isolation
- Recognition questions for self-validation

### Where Genetic Code Lives

- **Skills**: In the SKILL.md footer, before final `<critical_constraint>`
- **Commands**: In the command body, injected during creation via template
- **Referenced**: Point to `invocable-development/references/genetic-code-template.md`

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

For pattern library, see references/advanced-techniques.md.
```

### Why High Trust Works

1. **Respects intelligence**: Assumes the Agent can handle filesystem operations
2. **Defines boundaries**: Provides the invariants without scripting the execution
3. **Points to resources**: Respects context window by offloading details to references
4. **Enables adaptation**: The Agent can handle edge cases not explicitly covered

---

## Summary: The Pilot's Code

| Principle                  | Application                                                    |
| -------------------------- | -------------------------------------------------------------- |
| **Map, not Script**        | Provide boundaries and invariants; trust the Pilot to navigate |
| **Explain the Why**        | Rationale enables adaptation to edge cases                     |
| **Infinitive Voice**       | "Validate," "Create," "Carry"—not "You should"                 |
| **Natural Teaching**       | "Remember that...", "Think of this as..."                      |
| **Progressive Disclosure** | Tier 2 lean, Tier 3 deep                                       |
| **Recency Bias**           | Constraints at bottom of files                                 |
| **Genetic Code**           | Every component carries its own philosophy                     |

---

<critical_constraint>
MANDATORY: Provide Map, not Script—trust the Pilot's intelligence
MANDATORY: Explain the Why—enable adaptation to edge cases
MANDATORY: Use infiniitive voice—reduce persona friction
MANDATORY: Carry genetic code—ensure portability in isolation
MANDATORY: Place constraints at bottom—exploit recency bias
MANDATORY: Start with high freedom—constrain only when justified
No exceptions. Principles enable intelligent adaptation; recipes create brittleness.
</critical_constraint>
