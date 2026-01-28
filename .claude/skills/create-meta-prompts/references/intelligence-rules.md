## Overview

Guidelines for determining prompt complexity, tool usage, and optimization patterns.

<complexity_assessment>

<simple_prompts>
Single focused task, clear outcome:

**Indicators:**
- Single artifact output
- No dependencies on other files
- Straightforward requirements
- No decision-making needed

**Prompt characteristics:**
- Concise objective
- Minimal context
- Direct requirements
- Simple verification

<complex_prompts>
Multi-step tasks, multiple considerations:

**Indicators:**
- Multiple artifacts or phases
- Dependencies on research/plan files
- Trade-offs to consider
- Integration with existing code

**Prompt characteristics:**
- Detailed objective with context
- Referenced files
- Explicit implementation guidance
- Comprehensive verification
- Extended thinking triggers

<extended_thinking_triggers>

<when_to_include>
Use these phrases to activate deeper reasoning in complex prompts:
- Complex architectural decisions
- Multiple valid approaches to evaluate
- Security-sensitive implementations
- Performance optimization tasks
- Trade-off analysis

<trigger_phrases>
```
"Thoroughly analyze..."
"Consider multiple approaches..."
"Deeply consider the implications..."
"Explore various solutions before..."
"Carefully evaluate trade-offs..."
```

<example_usage>
```xml

## Requirements

Thoroughly analyze the authentication options and consider multiple
approaches before selecting an implementation. Deeply consider the
security implications of each choice.

```

<when_not_to_use>
- Simple, straightforward tasks
- Tasks with clear single approach
- Following established patterns
- Basic CRUD operations

<parallel_tool_calling>

<when_to_include>
```xml
<efficiency>
For maximum efficiency, invoke all independent tool operations
simultaneously rather than sequentially. Multiple file reads,
searches, and API calls that don't depend on each other should
run in parallel.

```

<applicable_scenarios>
- Reading multiple files for context
- Running multiple searches
- Fetching from multiple sources
- Creating multiple independent files

<context_loading>

<when_to_load>
- Modifying existing code
- Following established patterns
- Integrating with current systems
- Building on research/plan outputs

<when_not_to_load>
- Greenfield features
- Standalone utilities
- Pure research tasks
- Standard patterns without customization

<loading_patterns>
```xml

## Context

<!-- Chained artifacts -->
Research: @.prompts/001-auth-research/auth-research.md
Plan: @.prompts/002-auth-plan/auth-plan.md

<!-- Existing code to modify -->
Current implementation: @src/auth/middleware.ts
Types to extend: @src/types/auth.ts

<!-- Patterns to follow -->
Similar feature: @src/features/payments/

```

<output_optimization>

<streaming_writes>
For research and plan outputs that may be large:

**Instruct incremental writing:**
```xml

## Process

1. Create output file with XML skeleton
2. Write each section as completed:
   - Finding 1 discovered → Append immediately
   - Finding 2 discovered → Append immediately
   - Code example found → Append immediately
3. Finalize summary and metadata after all sections complete

```

**Why this matters:**
- Prevents lost work from token limit failures
- No need to estimate output size
- Agent creates natural checkpoints
- Works for any task complexity

**When to use:**
- Research prompts (findings accumulate)
- Plan prompts (phases accumulate)
- Any prompt that might produce >15k tokens

**When NOT to use:**
- Do prompts (code generation is different workflow)
- Simple tasks with known small outputs

<claude_to_claude>
For Claude-to-Claude consumption:

**Use heavy XML structure:**
```xml
<findings>
  <finding category="security">
    <title>Token Storage
    <recommendation>httpOnly cookies
    
## Rationale

Prevents XSS access
  

```

**Include metadata:**
```xml
<metadata>
  
### high

Verified in official docs
  
## Dependencies

Cookie parser middleware
  <open_questions>SameSite policy for subdomains

```

**Be explicit about next steps:**
```xml
<next_actions>
  <action priority="high">Create planning prompt using these findings
  <action priority="medium">Validate rate limits in sandbox

```

<human_consumption>
For human consumption:
- Clear headings
- Bullet points for scanning
- Code examples with comments
- Summary at top

<prompt_depth_guidelines>

<minimal>
Simple Do prompts:
- 20-40 lines
- Basic objective, requirements, output, verification
- No extended thinking
- No parallel tool hints

<standard>
Typical task prompts:
- 40-80 lines
- Full objective with context
- Clear requirements and implementation notes
- Standard verification

<comprehensive>
Complex task prompts:
- 80-150 lines
- Extended thinking triggers
- Parallel tool calling hints
- Multiple verification steps
- Detailed success criteria

<why_explanations>

Always explain why constraints matter:

<bad_example>
```xml

## Requirements

Never store tokens in localStorage.

```

<good_example>
```xml

## Requirements

Never store tokens in localStorage - it's accessible to any
JavaScript on the page, making it vulnerable to XSS attacks.
Use httpOnly cookies instead.

```

This helps the executing Claude make good decisions when facing edge cases.

<verification_patterns>

<for_code>
```xml

## Verification

1. Run test suite: `npm test`
2. Type check: `npx tsc --noEmit`
3. Lint: `npm run lint`
4. Manual test: [specific flow to test]

```

<for_documents>
```xml

## Verification

1. Validate structure: [check required sections]
2. Verify links: [check internal references]
3. Review completeness: [check against requirements]

```

<for_research>
```xml

## Verification

1. Sources are current (2024-2025)
2. All scope questions answered
3. Metadata captures uncertainties
4. Actionable recommendations included

```

<for_plans>
```xml

## Verification

1. Phases are sequential and logical
2. Tasks are specific and actionable
3. Dependencies are clear
4. Metadata captures assumptions

```

<chain_optimization>

<research_prompts>
Research prompts should:
- Structure findings for easy extraction
- Include code examples for implementation
- Clearly mark confidence levels
- List explicit next actions

<plan_prompts>
Plan prompts should:
- Reference research explicitly
- Break phases into prompt-sized chunks
- Include execution hints per phase
- Capture dependencies between phases

<do_prompts>
Do prompts should:
- Reference both research and plan
- Follow plan phases explicitly
- Verify against research recommendations
- Update plan status when done