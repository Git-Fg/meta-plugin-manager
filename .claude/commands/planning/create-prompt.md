---
name: create-prompt
description: Generate structured prompts using markdown. Separate analysis from execution - first clarify requirements, then generate rigorous specification prompts for delegation to fresh contexts.
disable-model-invocation: true
allowed-tools: ["AskUserQuestion", "Read", "Write", "Bash"]
---

# Create Prompt: Meta-Prompting System

Generate rigorous, specification-grade prompts using markdown structure. Separate analysis (current context) from execution (fresh sub-agent).

## What This Command Does

Execute a two-phase meta-prompting workflow:

1. **Analysis Phase** (current context) - Clarify requirements, ask questions, understand scope
2. **Prompt Generation** (current context) - Create structured prompt with all necessary context
3. **Execution Phase** (fresh context) - Delegate generated prompt to sub-agent for clean execution

**Key Innovation**: Transforms vague ideas into rigorous specifications while keeping main context clean for analysis.

## How It Works

### Phase 1: Analysis and Clarification

First, understand the task deeply by asking questions:

```
**Clarification Process:**
1. Parse initial task description
2. Identify ambiguities and gaps
3. Use AskUserQuestion to resolve unknowns
4. Establish scope boundaries
5. Define success criteria
```

**Recognition**: "Do I understand WHAT to build, WHY it's needed, and WHAT DONE looks like?"

If unclear, ask specific questions:
- "What's the primary goal of this [component/task]?"
- "What problem does this solve?"
- "Are there specific constraints or requirements?"
- "What does success look like?"

**Goal**: Zero ambiguity before prompt generation.

### Phase 2: Structured Prompt Generation

Generate a markdown-structured prompt with these sections:

#### Required Sections

```markdown
# Task: [Brief Title]

## Objective
[Clear statement of what needs to be accomplished]

## Context
[Background information, why this matters, relevant context]

## Requirements
[Specific, testable requirements]

## Implementation Guidance
[Technical approach, patterns to follow, considerations]

## What to Avoid (and WHY)
[Critical anti-patterns with explanations of WHY they're problematic]

## Output Format
[Expected deliverables, structure, format]

## Success Criteria
[Measurable criteria for determining completion]
```

#### Section Details

**Objective**: One-sentence clear statement of what needs to be done.

**Context**: Background information including:
- Why this task matters
- Relevant project context
- Dependencies or constraints
- User scenario or use case

**Requirements**: Specific, testable statements:
- Functional requirements (what it must do)
- Non-functional requirements (performance, security, etc.)
- Constraints (technologies, patterns, limitations)
- Edge cases to handle

**Implementation Guidance**: Technical direction including:
- Architecture patterns to follow
- Files or systems to modify/create
- Order of operations
- Critical decisions already made

**What to Avoid (and WHY)**: Critical anti-patterns:
- List specific pitfalls
- Explain WHY each is problematic
- Provide correct alternatives
- Focus on lessons learned and common mistakes

**Output Format**: Expected deliverables:
- File paths and structure
- Format specifications
- Code examples or templates
- Documentation requirements

**Success Criteria**: Measurable completion indicators:
- Test coverage requirements
- Functional acceptance criteria
- Quality standards to meet
- Verification steps

### Phase 3: Prompt Storage

Save the generated prompt to `.agent/prompts/` directory:

```bash
# Create prompts directory
mkdir -p .agent/prompts

# Save prompt with timestamp
PROMPT_FILE=".agent/prompts/$(date +%Y%m%d_%H%M%S)-[task-name].md"
```

**File naming pattern**: `YYYYMMDD_HHMMSS-[descriptive-name].md`

**Recognition**: "Is the prompt file name descriptive enough to identify it later?"

### Phase 4: Execution

Delegate the saved prompt to a fresh sub-agent:

```bash
# Execute prompt in fresh context
claude --prompt "$(cat .agent/prompts/[file].md)"
```

Or use the `/run-prompt` command to execute saved prompts.

## Prompt Structure Examples

### Example 1: Simple Task

```markdown
# Task: Add User Authentication

## Objective
Implement JWT-based authentication for user login/logout endpoints.

## Context
Building a REST API for task management. Currently has no authentication. Need to secure endpoints before production deployment.

## Requirements
- Implement JWT token generation on login
- Validate JWT tokens on protected endpoints
- Provide /login and /logout endpoints
- Return 401 for unauthorized access
- Store user passwords hashed (bcrypt)

## Implementation Guidance
- Use existing User model in models/user.ts
- Add auth middleware to middleware/auth.ts
- Create auth routes in routes/auth.ts
- Follow existing API response patterns

## What to Avoid (and WHY)
- **Plain text passwords** - Security vulnerability. Always hash before storing.
- **Hardcoded secrets** - Use environment variables for JWT secret.
- **Token expiration > 24h** - Increases security risk. Set reasonable expiry.
- **Missing CORS headers** - Breaks frontend integration. Configure properly.

## Output Format
- middleware/auth.ts - JWT validation middleware
- routes/auth.ts - Login/logout endpoints
- Updated models/user.ts - Password hashing methods
- Integration tests showing login/logout flow

## Success Criteria
- Valid credentials return JWT token
- Invalid credentials return 401
- Protected routes require valid JWT
- Logout invalidates token
- All tests pass
- Passwords hashed before storage
```

### Example 2: Complex Component

```markdown
# Task: Create Data Processing Pipeline

## Objective
Build a fault-tolerant data processing pipeline that ingests CSV files, validates records, transforms data, and outputs to PostgreSQL database.

## Context
Processing daily sales data from multiple vendors. Data quality varies - need robust validation and error handling. Pipeline must handle large files (1M+ records) efficiently.

## Requirements
- Accept CSV upload via API endpoint
- Validate each record against schema
- Transform data to internal format
- Batch insert to database (1000 records/batch)
- Log all validation errors
- Provide processing status endpoint
- Handle duplicate records (upsert)
- Return processing summary

## Implementation Guidelines
- Use streaming CSV parser (papaparse or csv-parser)
- Implement validation layer using schemas
- Use database transactions for batch inserts
- Store job status in Redis for real-time updates
- Implement retry logic for transient failures
- Add comprehensive logging

## What to Avoid (and WHY)
- **Loading entire CSV in memory** - Causes memory issues with large files. Use streaming.
- **Processing records one by one** - Too slow for 1M+ records. Use batching.
- **Silent failures** - Makes debugging impossible. Log all errors.
- **Missing transaction boundaries** - Partial data on failure breaks integrity. Wrap batches in transactions.
- **Synchronous processing** - Blocks API responses. Use job queue pattern.

## Output Format
- jobs/processor.js - Main pipeline orchestration
- jobs/validator.js - Record validation logic
- jobs/transformer.js - Data transformation logic
- jobs/database.js - Batch insert operations
- routes/upload.js - CSV upload endpoint
- routes/status.js - Processing status endpoint
- Validation schema file
- Integration tests with sample CSV data

## Success Criteria
- Process 1M records in < 5 minutes
- Handle invalid records without failing entire job
- All valid records inserted to database
- Invalid records logged with reasons
- Status endpoint returns accurate progress
- Zero data loss on failures
- All tests pass including edge cases
```

## Best Practices

### During Analysis Phase
- Ask clarifying questions before generating prompts
- Focus on understanding WHY, not just WHAT
- Identify constraints and dependencies early
- Define measurable success criteria
- Document assumptions

### During Prompt Generation
- Use clear, concise language
- Be specific about requirements
- Explain the WHY behind constraints
- Include concrete examples when helpful
- Focus on critical anti-patterns in "What to Avoid"
- Make success criteria measurable

### During Execution
- Use fresh context for prompt execution
- Monitor for semantic errors (intent drift, context issues)
- Validate outputs against success criteria
- Archive prompts after completion
- Document any deviations from requirements

## Prompt Archiving

After execution completes, archive prompts:

```bash
# Move executed prompts to archive
mv .agent/prompts/[file].md .agent/prompts/archive/
```

**Archive structure**: `.agent/prompts/archive/YYYY/MM/[file].md`

**Recognition**: "Is this prompt still relevant? Archive completed work to keep workspace clean."

## Integration with Run-Prompt

Use `/run-prompt` to execute saved prompts:

```
/run-prompt .agent/prompts/[file].md
```

The `/run-prompt` command:
- Loads the prompt file
- Spawns fresh sub-agent context
- Provides clean execution environment
- Returns results to main context

## Related Commands

This command integrates with:
- `/run-prompt` - Execute saved prompts in fresh contexts
- `/handoff` - Create context handoff for pausing work
- `/think:*` - Structured reasoning for analysis phase

## Arguments

First argument: Task description (required)

```
/create-prompt "Add JWT authentication to API"
/create-prompt "Create data pipeline for CSV processing"
```

## Recognition Questions

Before prompt generation, ask:
- "Do I understand WHY this task matters?"
- "Are all ambiguities resolved?"
- "Are success criteria measurable?"
- "Is the 'What to Avoid' section specific with WHY explanations?"

Before execution, ask:
- "Is the prompt complete enough for autonomous execution?"
- "Would a fresh context understand everything needed?"
- "Are success criteria verifiable?"

**Trust intelligence** - Use structured prompting to ensure quality, not to constrain creativity.
