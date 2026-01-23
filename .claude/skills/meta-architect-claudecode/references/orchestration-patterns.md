# Orchestration Patterns

Detailed guidance on when to use different orchestration patterns for skills and subagents.

## Linear Skill Chaining

**Use For**: Deterministic, simple, repeatable workflows

**Examples**:
- `diff → lint → commit`
- `validate → format → validate`
- `extract → transform → load`

**Pros**:
- Simple to implement
- Deterministic behavior
- Low token overhead

**Cons**:
- Brittle for complex workflows (single point of failure)
- Limited flexibility
- No error recovery between steps

**When to Avoid**:
- Workflows requiring decision-making between steps
- Dynamic problem solving where output is unpredictable
- Workflows with >3 steps that need error recovery

## Hub-and-Spoke

**Use For**: Complex, dynamic workflows requiring flexibility

**Examples**:
- `research → plan → code → test` (with decision points)
- Parallel research with aggregation
- Multi-stage analysis with branching logic

**Pros**:
- Centralized state management
- Error recovery and retry capability
- Dynamic rerouting based on results
- Resilient to individual worker failures

**Cons**:
- Higher complexity
- Token overhead (hub reads everything)
- More moving parts

**Sources**:
- [Anthropic: Building Effective Agents (Hub & Spoke)](https://www.anthropic.com/research/building-effective-agents)
- [LangChain: Chains vs Agents](https://python.langchain.com/docs/modules/chains/)
- [Microsoft: Autogen Design Patterns](https://microsoft.github.io/autogen/)

## Worker Orchestration (Noise Isolation)

**Pattern**: Router (this skill) + Worker (toolkit-worker)

**Use When**:
- Task involves high-volume output (audit, grep, log analysis)
- User asks for "Deep Analysis" or "Comprehensive Audit"
- Need to keep main context clean

**Instructions**:
1. **Identify**: User task is "noisy" (e.g., "Audit this repo structure")
2. **Delegate**: Spawn `toolkit-worker` subagent
3. **Inject**: Dynamic context (repo structure, file lists)
4. **Instructions**: "Perform audit based on your internal knowledge and this injected context."

**Example Delegation**:
```javascript
const workerResult = await Task({
  subagent_type: "toolkit-worker", // Uses agents/toolkit-worker.md configuration
  prompt: `Perform a comprehensive structural audit of the current repository.

  Context:
  - Repository Root: ${env.CLAUDE_PROJECT_DIR}
  - Focus: Architecture compliance, progressive disclosure checks

  Report Requirements:
  - Quality Score (0-10 scale)
  - Anti-patterns detected
  - Remediation list
  `,
  formatted_output: true
});
```

## Decision Tree

```
Need to orchestrate multiple skills?
│
├─ Simple, deterministic workflow?
│  ├─ Yes → Linear Chaining (≤3 steps)
│  └─ No → Continue below
│
├─ Requires decision-making between steps?
│  ├─ Yes → Hub-and-Spoke
│  └─ No → Continue below
│
├─ Parallel execution needed?
│  ├─ Yes → Hub-and-Spoke with context: fork
│  └─ No → Linear Chaining
│
└─ Error recovery required?
   ├─ Yes → Hub-and-Spoke
   └─ No → Linear Chaining
```

## Prompt Budget Playbook

**Goal**: Complete each unit of work in 1-2 top-level prompts maximum.

### Budget Rules

1. **Define the Work Unit**: Explicitly state what "done" looks like
2. **Success Criteria Must Be Measurable**: Binary pass/fail, not "improved"
3. **Hard Stop Conditions**:
   - Max 3 subagent spawns per task
   - Max 2 correction cycles on any file
   - Immediate stop if criteria met
4. **Prefer Deterministic Commands**: For validation/format/test
5. **Anti-2nd-Turn Checklist**:
   - [ ] All inputs available or identified as missing
   - [ ] Success criteria explicitly defined
   - [ ] Expected output format specified
   - [ ] Rollback strategy known

**Budget Equation**:
```
Target Budget = 1 (plan/assess) + 1 (execute/verify)
Max Budget = 1 (plan) + 2 (execute cycles) + 1 (validate)
```

## Common Use Cases

### Use Case 1: Building First Skill

**Path**: Layer Selection → Build Workflow

```
1. "I need domain expertise Claude can discover"
   → Skill (Minimal Pack)
2. Follow: Load: skills-knowledge (Steps 1-9)
3. Test: Fresh Eyes Test
4. Evaluate: 12-dimension framework
```

### Use Case 2: Choosing Context: Fork

**Path**: Layer Selection → Context Fork Criteria

```
1. "Will this generate high-volume output?"
   → Yes → Consider context: fork
2. "Would output clutter the conversation?"
   → Yes → Use context: fork
3. Pattern A: Router + Worker (recommended)
   Pattern B: Single Forked (simpler)
```

### Use Case 3: Evaluating Existing Skill

**Path**: Build Workflow → Evaluation Section

```
1. Load: skills-knowledge#evaluating-skill-quality
2. Scan: D1 (Knowledge Delta) first
3. Score: All 12 dimensions
4. Grade: A (144+), B (128-143), C (112-127), D (96-111), F (<96)
5. Fix: Common failure patterns
```

### Use Case 4: Creating CLAUDE.md Rules

**Path**: Advanced Patterns → Rules Section

```
1. Location: ~/.claude/ or project root
2. Structure: Context → Standards → Principles → Safety
3. Principles: Specificity, Context, Actionability, Safety
4. Anti-patterns: Vague rules, over-prescription, static docs
```

## Anti-Patterns to Avoid

### Development

- **Deep Nesting** — `references/v1/setup/config.md` → Flatten to `references/setup-config.md`
- **Vague Description** — "Helps with coding" → Use clear capability + use case
- **Over-Engineering** — Scripts for simple tasks → Use native tools first

### Layer Selection

- **Using subagents** for simple tasks (overkill)
- **Using all layers** for simple workflows (premature abstraction)
- **Creating skills that require commands** (violates autonomy principle)

### Skill Design

- **Kitchen Sink** — One skill tries to do everything
- **Indecisive Orchestrator** — Too many paths, unclear direction
- **Pretend Executor** — Scripts requiring constant guidance

## Writing Style Requirements

### Imperative Form

**Correct**: "To create a hook, define the event type."
**Incorrect**: "You should create a hook by defining the event type."

### Third-Person Description

**Correct**: `description: "This skill should be used when the user asks..."`
**Incorrect**: `description: "Use this skill when you want to..."`
