# activeForm Quality Guide

Complete guide to writing high-quality activeForm values for better Ctrl+T progress display in Claude Code.

## Overview

The `activeForm` field appears in Ctrl+T progress display when tasks are in progress. Quality activeForms significantly improve user experience by providing clear, actionable progress information.

## activeForm in Ctrl+T Display

### What Users See

When a task is in progress, Ctrl+T shows:
```
[✓] Completed task
[🔄] Running active form text
[⏳] Pending task
```

### activeForm Impact

**Good activeForm**:
```
[🔄] Implementing OAuth integration
```

**Poor activeForm**:
```
[🔄] Processing
```

**Difference**: User knows exactly what's happening vs. vague "processing"

## activeForm Convention

### Format: [Verb-ing] [Specific Object]

**Pattern**: Present continuous verb + specific object

**Examples**:
- ✅ "Running database migrations"
- ✅ "Analyzing codebase structure"
- ✅ "Validating component dependencies"
- ✅ "Implementing authentication flow"

### Anti-Patterns

**❌ Vague verbs**:
- "Processing" (what are you processing?)
- "Working" (working on what?)
- "Running" (running what?)
- "Doing" (doing what?)

**❌ Missing object**:
- "Implementing" (implementing what?)
- "Creating" (creating what?)
- "Analyzing" (analyzing what?)

**❌ Static state**:
- "In progress" (not helpful)
- "Pending" (status, not action)
- "Started" (not current action)

## Verb Selection

### Good Verbs for activeForm

| Verb | Use When | Examples |
|------|-----------|----------|
| **Analyzing** | Examining data, code, structure | "Analyzing dependencies", "Analyzing test results" |
| **Building** | Creating constructs, artifacts | "Building API client", "Building UI components" |
| **Configuring** | Setting up configuration | "Configuring MCP server", "Configuring hooks" |
| **Creating** | Making new files, components | "Creating skill scaffolding", "Creating test suite" |
| **Deploying** | Deploying to production | "Deploying to staging", "Deploying to production" |
| **Designing** | Architecture, planning | "Designing system architecture", "Designing database schema" |
| **Executing** | Running commands, processes | "Executing test suite", "Executing build process" |
| **Implementing** | Writing code, features | "Implementing auth flow", "Implementing API endpoints" |
| **Migrating** | Data migration, changes | "Migrating database schema", "Migrating to new API" |
| **Optimizing** | Performance improvements | "Optimizing query performance", "Optimizing bundle size" |
| **Refactoring** | Code restructuring | "Refactoring auth module", "Refactoring component hierarchy" |
| **Running** | Executing processes | "Running linter", "Running security scan" |
| **Scanning** | Examining files, codebase | "Scanning for vulnerabilities", "Scanning project structure" |
| **Testing** | Validation, verification | "Testing authentication flow", "Testing API endpoints" |
| **Updating** | Modifying existing code | "Updating dependencies", "Updating configuration files" |
| **Validating** | Checking correctness | "Validating JSON schema", "Validating MCP compliance" |

### Verbs to Avoid

| Verb | Why to Avoid | Better Alternative |
|------|---------------|-------------------|
| **Processing** | Too vague | Use specific verb: "Analyzing", "Parsing", "Transforming" |
| **Working** | Too vague | Use specific verb based on actual work |
| **Handling** | Too vague | Use specific verb: "Processing", "Managing", "Executing" |
| **Stuff** | Unprofessional | Never use |
| **Things** | Unprofessional | Never use |

## Object Selection

### Specific Objects

**Good** (specific, clear):
```
"Analyzing OAuth 2.0 configuration"
"Running user authentication tests"
"Implementing REST API endpoints"
"Scanning for SQL injection vulnerabilities"
```

**Poor** (vague, generic):
```
"Analyzing configuration"
"Running tests"
"Implementing endpoints"
"Scanning for vulnerabilities"
```

### Object Detail Level

**Sweet Spot**: Specific enough to be informative, general enough to be readable

**Too Specific** (hard to read):
```
"Implementing user authentication OAuth 2.0 Google provider integration with refresh token rotation"
```

**Too Generic** (not informative):
```
"Implementing authentication"
```

**Just Right**:
```
"Implementing Google OAuth authentication"
```

## activeForm by Phase

### Planning Phase

**Pattern**: "Designing/Planning/Analyzing [object]"

**Examples**:
- "Designing system architecture"
- "Planning implementation strategy"
- "Analyzing requirements"
- "Analyzing dependencies"
- "Designing database schema"

### Execution Phase

**Pattern**: "[Verb-ing] [object]" (use action verb)

**Examples**:
- "Creating component scaffolding"
- "Implementing feature X"
- "Configuring MCP server"
- "Writing test cases"
- "Building API client"

### Validation Phase

**Pattern**: "Validating/Testing/Scanning [object]"

**Examples**:
- "Validating JSON schema"
- "Testing authentication flow"
- "Scanning for security issues"
- "Running compliance checks"
- "Validating MCP protocol"

### Completion Phase

**Pattern**: "Generating/Creating/Updating [output]"

**Examples**:
- "Generating documentation"
- "Creating deployment package"
- "Updating project README"
- "Finalizing validation report"

## Domain-Specific Examples

### Development

```
"Implementing user registration"
"Refactoring payment module"
"Optimizing database queries"
"Updating API documentation"
```

### Security

```
"Scanning for vulnerabilities"
"Validating security headers"
"Testing authentication bypass"
"Analyzing permission model"
```

### DevOps

```
"Configuring CI/CD pipeline"
"Deploying to staging environment"
"Running container builds"
"Updating Kubernetes manifests"
```

### Data

```
"Migrating user database"
"Transforming data format"
"Validating data integrity"
"Backing up production data"
```

### Testing

```
"Running unit tests"
"Executing integration tests"
"Validating edge cases"
"Analyzing test coverage"
```

## ActiveForm Evolution

### Updating activeForm During Execution

**Pattern**: Refine activeForm as work progresses

**Initial** (broad):
```
"Implementing authentication system"
```

**Later** (specific):
```
"Implementing OAuth integration"
```

**Final** (completion):
```
"Finalizing authentication tests"
```

### Multi-Phase Tasks

**Pattern**: activeForm reflects current phase

**Phase 1**:
```
"Designing authentication architecture"
```

**Phase 2**:
```
"Implementing authentication flow"
```

**Phase 3**:
```
"Testing authentication system"
```

## Quality Checklist

### activeForm Quality Criteria

✓ **Starts with verb ending in -ing**
✓ **Includes specific object**
✓ **Describes current action** (not state)
✓ **Readable in Ctrl+T display** (under 50 chars)
✓ **Informative to user** (what's happening?)
✓ **Actionable** (what work is being done?)

### Quality Examples by Criteria

**Verb-ing**:
- ✅ "Analyzing codebase"
- ❌ "Analysis" (noun, not verb-ing)

**Specific Object**:
- ✅ "Scanning for SQL injection vulnerabilities"
- ❌ "Scanning for vulnerabilities" (too generic)

**Current Action**:
- ✅ "Running test suite"
- ❌ "In progress" (state, not action)

**Readable**:
- ✅ "Implementing OAuth authentication" (32 chars)
- ❌ "Implementing comprehensive OAuth 2.0 authentication system with support for multiple providers and refresh token rotation" (too long)

**Informative**:
- ✅ "Migrating production database"
- ❌ "Processing" (not informative)

## Common Mistakes

### ❌ Mistake 1: Using Nouns

**Bad**:
```
"In progress"
"Analysis"
"Implementation"
```

**Good**:
```
"Analyzing requirements"
"Implementing feature X"
```

### ❌ Mistake 2: Missing Object

**Bad**:
```
"Building"
"Creating"
"Testing"
```

**Good**:
```
"Building API client"
"Creating test suite"
"Testing authentication flow"
```

### ❌ Mistake 3: Too Long

**Bad**:
```
"Implementing comprehensive user authentication system with OAuth 2.0 support for multiple providers including Google and GitHub with refresh token rotation and secure session management"
```

**Good**:
```
"Implementing OAuth authentication system"
```

### ❌ Mistake 4: Too Vague

**Bad**:
```
"Processing data"
"Handling request"
"Working on task"
```

**Good**:
```
"Processing user registration data"
"Handling API request"
"Working on authentication feature"
```

## activeForm vs. Subject

### Distinction

**Subject**: Task title (short, noun phrase)
```
Subject: "User authentication"
```

**activeForm**: Current action (verb-ing + object)
```
activeForm: "Implementing OAuth authentication"
```

### Relationship

- Subject: What the task is (static)
- activeForm: What's happening now (dynamic)

**Example**:
```
Subject: "Database migration"
activeForm: "Migrating user table" (during execution)
activeForm: "Validating migration results" (later phase)
```

## Testing activeForm Quality

### User Perspective Test

**Question**: If I saw this activeForm in Ctrl+T, would I know what's happening?

**Examples**:

**Pass**:
```
"Running database migrations" → Yes, I know database is being migrated
```

**Fail**:
```
"Processing" → No, I don't know what's being processed
```

### Actionability Test

**Question**: Does the activeForm describe an action or a state?

**Examples**:

**Pass** (action):
```
"Implementing feature X" → Action, good
```

**Fail** (state):
```
"In progress" → State, bad
```

### Specificity Test

**Question**: Is the object specific enough?

**Examples**:

**Pass** (specific):
```
"Scanning for SQL injection vulnerabilities" → Specific, good
```

**Fail** (vague):
```
"Scanning for vulnerabilities" → Vague, bad
```

## Quick Reference Card

| Phase | Pattern | Examples |
|-------|---------|----------|
| **Planning** | Designing/Planning/Analyzing [object] | Designing architecture, Planning strategy, Analyzing requirements |
| **Execution** | [Verb-ing] [object] | Implementing feature, Creating component, Configuring server |
| **Validation** | Validating/Testing/Scanning [object] | Validating schema, Testing flow, Scanning for issues |
| **Completion** | Generating/Creating/Updating [output] | Generating docs, Creating package, Updating README |

## Summary

**Key Principles**:
1. Use [Verb-ing] [Specific Object] format
2. Start with present continuous verb (-ing)
3. Include specific, informative object
4. Keep under 50 characters for readability
5. Describe current action, not state
6. Make it informative for Ctrl+T display

**Quality activeForm**:
```
✅ "Implementing OAuth authentication"
✅ "Running database migrations"
✅ "Validating MCP protocol compliance"
✅ "Analyzing codebase dependencies"
```

**Poor activeForm**:
```
❌ "Processing"
❌ "Working"
❌ "In progress"
❌ "Doing stuff"
```

**Result**: Better user experience through clear, actionable progress display
