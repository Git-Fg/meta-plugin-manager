# Workflow Selection Guide

Use this guide when the user wants to use Ralph but the task is unclear. Follow the investigation workflow to identify the right preset.

---

## Investigation Workflow

When user says "I want to use Ralph" without specifying what to do:

### Step 1: Deep Codebase Analysis

Investigate the entire project to identify the most suitable preset:

- **Language & Framework**: What tech stack?
- **Project Type**: App, library, API, CLI, docs?
- **Maturity**: New, established, legacy?
- **Quality State**: Tests? Docs? Lint? Typecheck?
- **Recent Activity**: What's been changing?
- **Pain Points**: What breaks? What's slow? What's confusing?

### Investigation Approach

Understand the project by examining:
- **Structure**: Key files, directories, main entry points
- **Dependencies**: What frameworks and libraries are used
- **Quality indicators**: Tests, linting, type checking setup
- **Documentation**: README, docs, code comments
- **Recent changes**: Git history, active areas

**Principle**: Use judgment to gather relevant information. Don't run blind commands.

### Step 2: Identify Workflow Options

After investigation, propose **at least 7 Ralph workflows** tailored to the codebase: **3 Simple, 2 Standard, and 2 Custom** (expand up to 10 per category as relevant).

## Workflow Categories (Simple → Elaborate)

### Category 1: Simple Workflows (At least 3, up to 10)

**Characteristics**: Direct execution, single persona, straightforward iteration

#### 1. Direct Task Execution
- **Use when**: Specific, well-defined task with clear success criteria
- **Preset**: `feature-minimal` or `hatless-baseline`
- **Approach**: Ralph runs single iterations until task completes
- **Complexity**: Minimal - no hat coordination, just execution

#### 2. Hatless Baseline
- **Use when**: Comparing hat-based vs traditional mode
- **Preset**: `hatless-baseline`
- **Approach**: Single persona mode to establish baseline behavior
- **Complexity**: Low - one persona, straightforward iteration

#### 3. Single-Hat Iteration
- **Use when**: Need persona guidance but no coordination
- **Preset**: `feature-minimal` customized to single hat
- **Approach**: One specialized hat (planner/builder/reviewer) with instructions
- **Complexity**: Low-Medium - one persona with defined role

#### 4. Documentation-First Simple
- **Use when**: Documenting existing code or process
- **Preset**: `docs` or `documentation-first`
- **Approach**: Single documentation-focused iteration
- **Complexity**: Low - straightforward analysis and write cycle

#### 5. Code Exploration Simple
- **Use when**: Understanding unfamiliar codebase
- **Preset**: `research` or `code-archaeology`
- **Approach**: Single exploration persona with reporting
- **Complexity**: Low - analyze and report pattern

#### 6. Simple Review
- **Use when**: Quick code review without ceremony
- **Preset**: `review` with single iteration
- **Approach**: One pass review with suggestions
- **Complexity**: Low - single persona review

### Category 2: Standard Workflows (At least 2, up to 10)

**Characteristics**: Standard patterns with hat coordination, pre-defined events

#### 1. Standard Feature Workflow
- **Use when**: Building new functionality
- **Preset**: `feature`
- **Approach**: Planner → Builder → Reviewer hat coordination
- **Complexity**: Medium - preset hat coordination with pre-defined events

#### 2. Standard Review Workflow
- **Use when**: Code review or quality assessment
- **Preset**: `review`
- **Approach**: Comprehensive analysis with critique and suggestions
- **Complexity**: Medium - reviewer persona with quality gates

#### 3. Standard Debug Workflow
- **Use when**: Bug investigation and root cause analysis
- **Preset**: `debug`
- **Approach**: Investigate → Hypothesize → Test → Fix cycle
- **Complexity**: Medium - systematic problem-solving pattern

#### 4. Standard TDD Workflow
- **Use when**: Test-driven development required
- **Preset**: `tdd-red-green`
- **Approach**: Red → Green → Refactor cycle
- **Complexity**: Medium - test-first development pattern

#### 5. Standard Refactor Workflow
- **Use when**: Code quality improvement
- **Preset**: `refactor`
- **Approach**: Analyze → Plan → Execute refactoring
- **Complexity**: Medium - systematic improvement pattern

#### 6. Standard Research Workflow
- **Use when**: Deep exploration and analysis
- **Preset**: `research`
- **Approach**: Explore → Synthesize → Document pattern
- **Complexity**: Medium - research coordination pattern

### Category 3: Custom Workflows (At least 2, up to 10)

**Characteristics**: Modified presets or custom hat-based coordination

#### 1. Modified Feature Workflow
- **Use when**: Standard feature work needs project-specific adjustments
- **Start with**: `feature` preset, then customize hat instructions
- **Approach**: Take `feature` preset, customize for project conventions
- **Complexity**: Medium-High - preset structure with custom tweaks
- **Refinements**: Project-specific language/framework conventions

#### 2. Enhanced Review Workflow
- **Use when**: Need security or performance review alongside standard review
- **Start with**: `review` preset, then extend
- **Approach**: Extend `review` preset with specialized security/performance hats
- **Complexity**: High - multiple specialized reviewer hats
- **Refinements**: Add adversarial-review elements for security focus

#### 3. Custom Debug + Research Workflow
- **Use when**: Complex debugging requiring investigation and implementation
- **Start with**: `debug` preset, then add research phase
- **Approach**: Combine `debug` preset with research and implementation phases
- **Complexity**: High - research → debug → implement coordination
- **Refinements**: Add research phase before debugging

#### 4. API Design + Implementation Workflow
- **Use when**: API-first development with implementation
- **Start with**: `api-design` preset, then add implementation
- **Approach**: Combine `api-design` with feature implementation
- **Complexity**: High - design → implement → validate coordination
- **Refinements**: Add implementation hat to api-design preset

#### 5. Migration Safety Workflow
- **Use when**: Database/API migrations with rollback planning
- **Start with**: `migration-safety` preset, then enhance
- **Approach**: `migration-safety` preset enhanced with testing and validation
- **Complexity**: High - analyze → plan → execute with safety checks
- **Refinements**: Add validation and rollback testing stages

#### 6. Performance Optimization Workflow
- **Use when**: Performance bottlenecks identified
- **Start with**: `performance-optimization` preset
- **Approach**: Profile → Analyze → Optimize → Verify cycle
- **Complexity**: High - measurement and optimization coordination
- **Refinements**: Add benchmarking and regression testing

## Workflow Selection Process

For each workflow option, provide:
1. **Name**: Clear identifier
2. **Use Case**: When to choose this approach
3. **Preset**: Which preset to initialize with
4. **Approach**: What Ralph will do
5. **Complexity Level**: Simple/Medium/High
6. **Rationale**: Why it fits this specific codebase

## Selection Guidelines

- **Minimum coverage**: Always provide at least 3 Simple, 2 Standard, and 2 Custom
- **Start with presets**: All workflows use presets as starting points
- **Customize when needed**: Modify presets to fit your specific requirements
- **Expand as needed**: Add more options (up to 10 per category) based on project complexity

## Step 3: Present Options to User

Present your analysis and recommendations naturally:

1. **Summarize findings**: What you discovered about the codebase
2. **List workflow options**: At least 3 Simple, 2 Standard, and 2 Custom (expand as relevant)
3. **Ask for choice**: Which approach aligns with their goals?

**Format**: Use natural language. No rigid templates. Trust your ability to explain why each workflow fits.

## Coverage Check

Ensure you've provided:
- ✅ At least 3 Simple workflow options
- ✅ At least 2 Standard workflow options
- ✅ At least 2 Custom workflow options
- ✅ Each option clearly explained with rationale

## Step 4: Preset Review and Refinement

When using presets, **always review the preset's prompts** before applying. Consider:

### Light Refinements (Implement Directly)

If refinements are minor and improve clarity/effectiveness:
- Adjust hat instructions to match your project's conventions
- Modify quality gates to align with your standards
- Add project-specific context to prompts
- Update event names to match your domain

**Examples of light refinements**:
- Changing "analyze the codebase" to "analyze the Python/Django codebase"
- Adding "check for existing tests in tests/ directory"
- Modifying "run linting" to "run npm run lint"

### Massive Refinements (Ask User)

If refinements fundamentally change the preset's approach:
- Different hat coordination patterns
- Major changes to workflow structure
- Adding/removing entire stages
- Changing core philosophy (e.g., from test-first to doc-first)

**Examples that require user input**:
- Converting from "Builder → Reviewer" to "Researcher → Implementer → Tester" pattern
- Adding database migration stage to feature workflow
- Completely reordering hat coordination
- Changing from iterative to batch processing

**Principle**: If you find yourself rewriting >50% of the preset instructions, ask the user for direction rather than continuing with what becomes a custom workflow.

## When Investigation Is Mandatory

- User says "I want to use Ralph" without specifics
- New project unfamiliar to you
- Legacy codebase with unclear patterns
- Request like "help improve this codebase"
- Request like "what Ralph workflow fits here?"
- Any project where you don't immediately know which preset to use

## Investigation Output

Present your analysis in whatever format makes sense for the situation. Focus on:
- **What you found**: Key characteristics of the codebase
- **Why it matters**: How these characteristics inform Ralph workflow selection
- **Recommendations**: At least 7 workflow options (3 Simple, 2 Standard, 2 Custom) tailored to the codebase

## Next Steps

After analysis, guide the user toward:
- Workflow selection based on findings
- Configuration with `ralph init --preset <name>`
- Troubleshooting if issues arise

## Clean Publishes Pattern

When creating or customizing Ralph workflows, follow the clean publishes pattern:

### Key Principles

**Business Logic Only**: Define hats, triggers, and publishes in YAML
**No Internal Mechanics**: Don't show `ralph emit`, JSONL format, or file paths
**Let Ralph Handle Mechanics**: The binary automatically injects event emission instructions

### Pattern Decision Guide

**Use Scratchpad Pattern** (95% of cases) when:
- Passing detailed context to next hat
- Error logs and stack traces
- Analysis or reasoning
- Any data >100 characters

**Use JSON Pattern** (5% of cases) when:
- Building automated metrics dashboard
- Simple counts, rates, or booleans
- Need programmatic event parsing
- Meta-data without human review needed

### Quick Reference for Workflow Creation

```yaml
# Good YAML Instruction
hats:
  builder:
    publishes: ["build.done"]
    instructions: |
      When you are done, publish build.done.
      The payload MUST include:
      - List of files modified
      - Testing status summary
```

**Ralph will translate this.** The agent knows (via injected system prompt) how to format the CLI command based on your data requirements.

**Trust your judgment** on how to present findings most effectively.

---

## Quick Selection Decision Tree

```
START: What do you want to accomplish?
│
├─ I have a specific task
│  └─→ Use Quick Preset Reference in SKILL.md
│
├─ I want to improve my codebase
│  ├─ New features? → Standard Feature Workflow (feature preset)
│  ├─ Fix bugs? → Standard Debug Workflow (debug preset)
│  └─ Improve quality? → Standard Refactor Workflow (refactor preset)
│
├─ I'm not sure what Ralph can do
│  └─→ Follow Investigation Workflow (this document)
│
└─ I need to choose from workflow options
   └─→ Read this guide, then use Investigation Workflow
```

## Common Scenarios

### Scenario 1: "I want to add a new feature to my React app"
**Investigation**: React app, TypeScript, Jest tests, ESLint configured
**Recommended Workflows**:
1. **Simple**: Direct Task Execution (feature-minimal)
2. **Standard**: Standard Feature Workflow (feature preset)
3. **Custom**: Modified Feature Workflow (feature preset + custom test commands)

### Scenario 2: "My Python API has a memory leak"
**Investigation**: Python FastAPI, PostgreSQL, production issue
**Recommended Workflows**:
1. **Simple**: Code Exploration Simple (scientific-method preset)
2. **Standard**: Standard Debug Workflow (debug preset)
3. **Custom**: Custom Debug + Research Workflow (debug + performance-optimization)

### Scenario 3: "I inherited a legacy PHP codebase"
**Investigation**: PHP 7.4, minimal tests, undocumented
**Recommended Workflows**:
1. **Simple**: Code Exploration Simple (code-archaeology preset)
2. **Standard**: Standard Research Workflow (research preset)
3. **Custom**: Custom Debug + Research Workflow (code-archaeology + research)

### Scenario 4: "I need to migrate from REST to GraphQL"
**Investigation**: Node.js, REST API, database schema changes needed
**Recommended Workflows**:
1. **Simple**: Direct Task Execution (api-design preset)
2. **Standard**: API Design + Implementation Workflow (custom)
3. **Custom**: Migration Safety Workflow (migration-safety preset)

### Scenario 5: "I want to learn this new codebase"
**Investigation**: Go microservice, unfamiliar architecture
**Recommended Workflows**:
1. **Simple**: Code Exploration Simple (code-archaeology preset)
2. **Standard**: Standard Research Workflow (research preset)
3. **Custom**: Socratic Learning Workflow (socratic-learning preset)
