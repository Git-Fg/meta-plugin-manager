# Ralph Orchestrator - Detailed Reference

This file contains detailed examples, preset patterns, and comprehensive guidance for Ralph Orchestrator.

## Quick Preset Reference (Expanded)

### Development Workflows

| Preset | Use When | Pattern | Initialize Command |
|--------|----------|---------|-------------------|
| **feature** | Building new functionality with integrated review | Planner → Builder → Reviewer | `ralph init --preset feature` |
| **feature-minimal** | Simple features without ceremony | Single hat with auto-derived instructions | `ralph init --preset feature-minimal` |
| **tdd-red-green** | Test-first development required | Red → Green → Refactor cycle | `ralph init --preset tdd-red-green` |
| **spec-driven** | Specifications exist, implementation follows | Spec → Build → Verify | `ralph init --preset spec-driven` |
| **refactor** | Code quality improvement needed | Analyze → Plan → Execute refactoring | `ralph init --preset refactor` |
| **documentation-first** | Docs drive implementation | Doc → Implement → Sync | `ralph init --preset documentation-first` |

### Review & Quality

| Preset | Use When | Pattern | Initialize Command |
|--------|----------|---------|-------------------|
| **review** | Review code changes without making modifications | Security → Architecture → Performance → Style | `ralph init --preset review` |
| **security-audit** | Security-focused code review | OWASP → Secrets → Dependencies → Infrastructure | `ralph init --preset security-audit` |
| **performance-review** | Performance optimization review | Bottleneck → Metrics → Optimization → Validation | `ralph init --preset performance-review` |

### Analysis & Debugging

| Preset | Use When | Pattern | Initialize Command |
|--------|----------|---------|-------------------|
| **debug** | Investigate and fix specific issues | Reproduce → Root Cause → Fix → Verify | `ralph init --preset debug` |
| **investigation** | Deep codebase understanding | Scan → Map → Analyze → Report | `ralph init --preset investigation` |
| **tests-improvement** | Enhance test coverage and quality | Coverage → Gaps → Strategy → Implementation | `ralph init --preset tests-improvement` |

### Documentation & Knowledge

| Preset | Use When | Pattern | Initialize Command |
|--------|----------|---------|-------------------|
| **docs** | Create or update documentation | Structure → Content → Examples → Review | `ralph init --preset docs` |
| **readme** | Create comprehensive README | Overview → Setup → Usage → Examples → Contributing | `ralph init --preset readme` |
| **architecture-doc** | Document system architecture | Components → Relationships → Patterns → Decisions | `ralph init --preset architecture-doc` |

---

## Spec Creation for Ralph Workflows

See the main SPEC_SETUP_GUIDE.md for detailed specification writing guidance.

### Quick Spec Template

Create `PROMPT.md` in your project root:

```markdown
# [Task Name]

## Objective
[Brief description of what needs to be accomplished]

## Context
- Project: [name/type]
- Language/Framework: [tech stack]
- Current State: [what exists]
- Goal: [what you want to achieve]

## Acceptance Criteria
- [ ] [Specific, testable requirement 1]
- [ ] [Specific, testable requirement 2]
- [ ] [Specific, testable requirement 3]

## Quality Gates
- All tests pass
- Lint checks pass
- Typecheck passes (if applicable)
- Code review standards met

## Constraints
- [Any specific constraints or requirements]
```

---

## Code Review Preset (Detailed Example)

For reviewing code changes without making modifications.

### Purpose
Produces structured feedback, identifies issues, suggests improvements.

### Usage:
```bash
ralph run --prompt "Review PR #123"
ralph run --prompt "Review changes in src/auth/"
```

### Hats Configuration:

**1. Security Auditor**
- Focus: Security vulnerabilities, OWASP Top 10, secrets
- Checks: Input validation, authentication, authorization, data protection

**2. Architecture Reviewer**
- Focus: Design patterns, code organization, maintainability
- Checks: SOLID principles, dependency management, modularity

**3. Performance Analyst**
- Focus: Efficiency, scalability, optimization opportunities
- Checks: N+1 queries, inefficient algorithms, resource usage

**4. Code Quality Reviewer**
- Focus: Style, standards, best practices
- Checks: Naming conventions, documentation, test coverage

### Review Process:

1. **Initial Scan**: Parse changes, identify affected components
2. **Security Review**: Check for vulnerabilities and security issues
3. **Architecture Analysis**: Evaluate design and structure
4. **Performance Review**: Identify bottlenecks and optimizations
5. **Quality Check**: Verify standards and best practices
6. **Report Generation**: Compile findings with actionable recommendations

---

## Feature Implementation Preset (Detailed Example)

### Purpose
Build new functionality with integrated review process.

### Hats Configuration:

**1. Feature Planner**
- Creates implementation plan
- Breaks down feature into tasks
- Identifies dependencies and risks

**2. Feature Builder**
- Implements the feature
- Follows coding standards
- Creates tests

**3. Code Reviewer**
- Reviews implementation
- Suggests improvements
- Validates against requirements

### Implementation Flow:

1. **Plan Phase**: Feature Planner creates detailed implementation plan
2. **Build Phase**: Feature Builder implements feature incrementally
3. **Review Phase**: Code Reviewer validates implementation
4. **Iterate**: Repeat build/review until all acceptance criteria met

---

## Example: Well-Structured Ralph Workflow (Expanded)

### Real-World Example: User Authentication

**Context**: Implementing authentication system for web application

**Setup**:
```bash
ralph init --preset feature
```

**Generated Workflow** (simplified):

```yaml
# ralph.yml
name: authentication-feature
description: Build user authentication system
backend: claude

hats:
  - name: Feature Planner
    prompt: |
      Create detailed implementation plan for authentication system.
      Include: database schema, API endpoints, security considerations.
    completion: |
      ## PLANNING_COMPLETE
      Implementation plan created and approved.

  - name: Feature Builder
    prompt: |
      Implement authentication system based on plan.
      Requirements:
      - User registration with email verification
      - Login with JWT tokens
      - Password reset functionality
      - Secure session management
    completion: |
      ## BUILDING_COMPLETE
      All features implemented with tests.

  - name: Code Reviewer
    prompt: |
      Review authentication implementation for:
      - Security vulnerabilities
      - Code quality and standards
      - Test coverage
      - Performance considerations
    completion: |
      ## REVIEW_COMPLETE
      All issues addressed, code ready for production.
```

---

## Component Name

**Purpose**: Standardize component naming across the project

**Pattern**: kebab-case for files, PascalCase for classes

---

## User Authentication

**Purpose**: Secure user authentication and session management

**Implementation**:
- JWT-based authentication
- Password hashing with bcrypt
- Session management
- CSRF protection

---

## Workflow Design Patterns

### Anti-Patterns to Avoid

❌ **Over-prescription**: Don't tell Ralph exactly what to do step-by-step
✅ **Quality gates**: Set standards Ralph must meet

❌ **Assumption-based handoffs**: Hats don't pass implicit state
✅ **Event coordination**: Clear publish/subscribe pattern

❌ **Single long iteration**: Breaks Fresh Context principle
✅ **Iteration limits**: 10-20 iterations max, restart if needed

❌ **Skipping verification**: Always validate work quality
✅ **Backpressure enforcement**: Reject until standards met

---

## Compliance Status

### Critical Issues (Blocking/Security)
- [ ] No critical issues found

### Major Issues (Functionality/Architecture)
- [ ] All functionality requirements met
- [ ] Architecture follows best practices

### Summary
- [ ] All acceptance criteria verified
- [ ] Quality gates passed
- [ ] Code ready for production

---

## Advanced Configuration

### Event Loop Integration

Ralph uses events to coordinate between hats:

```yaml
events:
  - name: plan.complete
    publisher: Feature Planner
    subscriber: Feature Builder
    payload: implementation_plan

  - name: build.complete
    publisher: Feature Builder
    subscriber: Code Reviewer
    payload: implementation_status

  - name: review.complete
    publisher: Code Reviewer
    subscriber: Feature Planner
    payload: review_results
```

### Analysis Results

```yaml
analysis:
  findings:
    - type: security
      severity: high
      description: SQL injection vulnerability
      location: src/db/user.js:42
      recommendation: Use parameterized queries

    - type: performance
      severity: medium
      description: N+1 query in user posts
      location: src/models/post.js:15
      recommendation: Eager loading with includes()
```

---

## Version History

### v2.2.1 (January 22)
- Multi-platform support (Apple Silicon macOS, Intel macOS, ARM64 Linux, x64 Linux)
- Improved CLI ecosystem integration

### v2.1.1 (January 20)
- Enhanced TUI streaming display
- Refined footer user experience
- Fixed TUI header time tracking

### v2.1.0 (January 20)
- **New TUI iteration architecture** - Major refactor
- Iteration-based model with snapshot testing
- Arrow key navigation (←/→) to review previous iterations
- Fixed content truncation (no more mid-word ellipsis)
- Fixed autoscroll behavior
- Added `opencode` and `copilot` backends
- Fixed Ctrl+C interrupt handling

### v2.0.9
- Added OpenCode CLI backend (7th supported backend)

### v2.0.8
- New `ralph plan` command
- New `ralph task` command
- GitHub Copilot CLI backend support

### Supported Backends (7 total)
1. Claude Code (recommended)
2. Kiro
3. Gemini CLI
4. Codex
5. Amp
6. Copilot CLI
7. OpenCode

### Installation Methods

```bash
# npm
npm install -g @ralph-orchestrator/ralph-cli

# Homebrew (macOS)
brew install ralph-orchestrator

# Cargo
cargo install ralph-cli

# From source
git clone https://github.com/mikeyobrien/ralph-orchestrator
cd ralph-orchestrator
cargo build --release
```

### Resources
- **Website**: https://mikeyobrien.github.io/ralph-orchestrator/
- **Repository**: https://github.com/mikeyobrien/ralph-orchestrator
- **License**: MIT
- **Coverage**: 65% test coverage

---

## Advanced Troubleshooting

### Common Issues and Solutions

**Issue**: Loop doesn't terminate
**Solution**: Check for open tasks in scratchpad, ensure all hats publish completion events

**Issue**: Quality gates failing repeatedly
**Solution**: Review instructions for clarity, check if requirements are realistic

**Issue**: Event handoffs not working
**Solution**: Verify event names match exactly between publish/subscribe

**Issue**: Ralph "hallucinates" files
**Solution**: Enable Fresh Context, explicitly read files in each iteration

### Getting Help

When Ralph behaves unexpectedly, use the same approach you'd use with any complex system:
- **Start with visibility**: Enable verbose output to see what's happening
- **Check the flow**: Understand the sequence of events
- **Test incrementally**: Use limited runs to isolate issues
- **Consult documentation**: CLI help is authoritative for options and flags

**Principle**: Debug systematically. Each piece of information narrows down the problem.

---

## Summary: Ralph's Core Principles

**🎯 Choose the Right Pattern**: Presets for quick tasks, Adaptive Framework for comprehensive analysis.

**Fresh Context**: Every iteration starts clean. Re-reads files/specs/plans to prevent assumptions.

**Backpressure**: Quality gates reject work until standards met. Don't prescribe methods — enforce quality.

**Events Coordinate**: Hats publish events for reliable handoffs. Signal-based > script-based orchestration.

**Claude Default**: Use Claude backend unless you have specific reason to change.

**Investigation First**: When task is unclear, investigate codebase → propose workflow options → user chooses.

**Design for Quality**: Whether using presets or adaptive framework, ensure they have:
- Clear hat responsibilities
- Proper event flow
- Detailed instructions
- Quality gates
- Fresh context enforcement

**Workflow Approaches**:
- **Presets**: Quick setup for specific tasks (feature, review, debug)
- **Adaptive Framework**: Unified analysis with auto-fixing (specs, audits, comprehensive fixes)

**Self-Healing Capability**: The Adaptive Framework doesn't just find issues — it fixes them automatically and verifies all changes.

**Let Ralph Ralph**: Autonomous iteration. Set quality gates, don't micromanage.

You can now orchestrate autonomously with Ralph — investigate if needed → choose workflow approach (preset or adaptive) → implement with quality standards → run loops → troubleshoot, always guided by these principles.

---

## Installation & Version History

### Latest Version Information (v2.2.1 - January 2026)

**Recent Major Updates:**

**v2.2.1** (January 22):
- Multi-platform support (Apple Silicon macOS, Intel macOS, ARM64 Linux, x64 Linux)
- Improved CLI ecosystem integration

**v2.1.1** (January 20):
- Enhanced TUI streaming display
- Refined footer user experience
- Fixed TUI header time tracking

**v2.1.0** (January 20):
- **New TUI iteration architecture** - Major refactor
- Iteration-based model with snapshot testing
- Arrow key navigation (←/→) to review previous iterations
- Fixed content truncation (no more mid-word ellipsis)
- Fixed autoscroll behavior
- Added `opencode` and `copilot` backends
- Fixed Ctrl+C interrupt handling

**Supported Backends (7 total)**:
1. Claude Code (recommended)
2. Kiro
3. Gemini CLI
4. Codex
5. Amp
6. Copilot CLI
7. OpenCode

### Installation Methods

```bash
# npm
npm install -g @ralph-orchestrator/ralph-cli

# Homebrew (macOS)
brew install ralph-orchestrator

# Cargo
cargo install ralph-cli

# From source
git clone https://github.com/mikeyobrien/ralph-orchestrator
cd ralph-orchestrator
cargo build --release
```

### Resources
- **Website**: https://mikeyobrien.github.io/ralph-orchestrator/
- **Repository**: https://github.com/mikeyobrien/ralph-orchestrator
- **License**: MIT
- **Coverage**: 65% test coverage

**Status**: Active development, v2.x is simpler and more structured than v1.x. Works today but expect rough edges and breaking changes.
