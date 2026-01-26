# Code-Assist TDD Pattern

Structured Test-Driven Development workflow following Explore → Plan → Code → Commit.

## Overview

The code-assist pattern guides implementation using TDD principles:
1. **Explore** - Analyze requirements and research patterns
2. **Plan** - Design tests and implementation strategy
3. **Code** - Write tests first, then implementation
4. **Commit** - Validate and commit with conventional messages

## Execution Modes

### Interactive Mode
- Present proposed actions, ask for confirmation
- Explain pros/cons of multiple approaches
- Pause at key decision points
- Adapt to user feedback

### Auto Mode
- Execute autonomously without confirmation
- Document all decisions in progress.md
- Select most appropriate approach automatically
- Provide comprehensive summary at completion

## Directory Structure

```
{documentation_dir}/implementation/{task_name}/
├── context.md          # Project structure, requirements, patterns
├── plan.md             # Test scenarios, implementation plan
├── progress.md         # Execution tracking, TDD cycles
└── logs/
    └── build_output.log
```

**Important:** All documentation goes in `documentation_dir`. All code goes in `repo_root`. Never mix them.

## Workflow Steps

### 1. Setup
- Create directory structure
- Discover instruction files: `CODEASSIST.md`, `README.md`, `CONTRIBUTING.md`
- Create `context.md` and `progress.md`

### 2. Explore
- **Analyze requirements** - Extract functional requirements and acceptance criteria
- **Research patterns** - Find similar implementations in codebase
- **Create context document** - Compile findings

### 3. Plan
- **Design test strategy** - Cover all acceptance criteria
- **Create implementation plan** - Outline high-level structure
- **Track with checklists** - Use markdown checkboxes in progress.md

### 4. Code

#### 4.1 Implement Tests First
```
RED phase: Write failing tests for ALL requirements
- Follow existing testing conventions
- Execute tests to verify they fail as expected
- Document failure reasons
```

#### 4.2 Implement Code
```
GREEN phase: Write minimal code to pass tests
- Only implement what's needed for current test(s)
- Follow existing coding style
- Run tests after each implementation step
```

#### 4.3 Refactor
```
REFACTOR phase: Improve code quality
- Align with codebase conventions
- Prioritize readability over cleverness
- Maintain test passing status
```

### 5. Commit
- Update task frontmatter (if `.code-task.md` file)
- Follow Conventional Commits specification
- Stage and commit all relevant files
- **Never push** - leave that to user

## CODEASSIST.md Template

Create in repo root to customize behavior:

```markdown
# CODEASSIST.md

## Pre-SOP Instructions
[Steps to run before starting code-assist]

## Additional Constraints
- [Project-specific constraint 1]
- [Project-specific constraint 2]

## Coding Standards
- Naming conventions: [describe]
- Documentation style: [describe]
- Testing patterns: [describe]

## Post-SOP Instructions
[Steps to run after completing code-assist]

## Troubleshooting
### Common Issue 1
[Description and solution]

## Examples
[Example implementations to reference]
```

## Build Output Management

```bash
# Pipe build output to log files
[build-command] > build_output.log 2>&1

# Search for success/failure indicators
grep -E "(PASS|FAIL|error|warning)" build_output.log
```

Save logs to `{documentation_dir}/implementation/{task_name}/logs/`.

## Progress Tracking

Use markdown checklists in `progress.md`:

```markdown
## Implementation Progress

### Test Development
- [x] Write test for requirement 1
- [x] Write test for requirement 2
- [ ] Write test for edge case 3

### Implementation
- [x] Implement core functionality
- [ ] Add error handling
- [ ] Add logging

### TDD Cycles
#### Cycle 1: Core functionality
- RED: Tests written, failing as expected
- GREEN: Minimal implementation, tests pass
- REFACTOR: Aligned with naming conventions
```

## Best Practices

1. **Separation of concerns** - Docs in doc dir, code in repo
2. **Strict TDD cycle** - Never skip RED or REFACTOR phases
3. **One thing at a time** - Implement tests for one requirement before moving on
4. **Build verification** - Run builds after every significant change
5. **Conventional commits** - Use proper commit message format:
   ```
   feat(component): add validation logic
   
   - Implements requirement from task-123
   - Adds unit tests with 95% coverage
   
   🤖 Assisted by code-assist
   ```
