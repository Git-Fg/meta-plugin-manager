---
name: ralph-orchestrator-expert
description: This skill should be used when the user asks to "set up a ralph wiggum", "create a ralph loop", or needs guidance on Ralph Orchestrator workflow design, preset selection, or orchestration patterns.
---

# Ralph Orchestrator Guide

Think of Ralph as an **autonomous drone with quality sensors**—it flies through your codebase autonomously, making decisions based on fresh context each iteration, while quality gates ensure it only accepts work that meets your standards.

## Core Philosophy

**Fresh Context** + **Backpressure** = reliable automation

- **Fresh Context**: Each loop starts clean, re-reading state every iteration
- **Backpressure**: Quality gates reject bad work
- **Event Coordination**: Hats communicate via events, not assumptions
- **The Plan Is Disposable**: Regeneration is cheap
- **Let Ralph Ralph**: Autonomous iteration over micromanagement

## Recognition Patterns

**When to use ralph-orchestrator-expert:**
```
✅ Good: "Set up autonomous task completion"
✅ Good: "Create a ralph loop"
✅ Good: "Need workflow orchestration"
✅ Good: "Multi-stage autonomous processing"
❌ Bad: Simple single-task operations
❌ Bad: Interactive debugging sessions

Why good: Ralph excels at long-running, non-interactive workflows with quality gates.
```

**Pattern Match:**
- User mentions "ralph", "orchestrator", "autonomous loop"
- Need multi-stage task completion
- Want quality gates and backpressure
- Long-running workflows

**Recognition:** "Do you need autonomous task completion with quality gates?" → Use ralph-orchestrator-expert.

## Two Orchestration Approaches

### 1. Preset Workflows (Recommended)
Start with proven patterns for common tasks.

**Setup:**
```bash
ralph init --preset <name>
ralph run
```

**Ideal for:**
- Features, reviews, debugging, documentation
- Quick setup with predictable structure
- Common workflows with proven patterns

**Decision Tree:**
```
Need quick task completion? → Use Presets
Not sure? → Start with Presets
```

### 2. Adaptive Framework (Advanced)
Single workflow handles comprehensive analysis with auto-detection.

**Setup:**
```bash
# 1. Create PROMPT.md with analysis requirements
# 2. Run: ralph emit "audit.start"
```

**Ideal for:**
- Comprehensive codebase analysis
- Spec verification
- Automatic fixing

**Auto-detects:**
- Spec Gap Analysis
- Global Codebase Audit
- Custom Analysis

## Decision Matrix

| Your Goal | Approach | Setup |
|-----------|----------|-------|
| Build feature quickly | Preset (feature) | `ralph init --preset feature` |
| Find and fix issues | Adaptive Framework | Create PROMPT.md + run |
| Review code quality | Preset (review) | `ralph init --preset review` |
| Comprehensive audit | Adaptive Framework | Create PROMPT.md + run |
| Debug specific bug | Preset (debug) | `ralph init --preset debug` |
| Write documentation | Preset (docs) | `ralph init --preset docs` |

## Setup Process

**ALWAYS start with a preset** - never create ralph.yml from scratch:

1. **List presets**: `ralph init --list-presets`
2. **Select preset**: Choose from Decision Matrix
3. **Initialize**: `ralph init --preset <name>`
4. **Review configuration**: Read generated ralph.yml
5. **Customize** (if needed):
   - Adjust hat instructions
   - Update event names
   - Modify quality gates
   - Add project context
6. **Create PROMPT.md**: Write task in human-readable format
7. **Run**: `ralph run` or `ralph run --tui`

**When to customize vs choose different preset:**
- **Light edits**: Change names, minor instructions, quality gates
- **Choose different preset**: If changing >50% of structure
- **Ask user**: If fundamental changes needed

## Quick Preset Reference

**Development:**
- `feature` - Build features
- `feature-minimal` - Minimal feature workflow
- `tdd-red-green` - Test-driven development
- `spec-driven` - Specification-driven development
- `refactor` - Code refactoring
- `documentation-first` - Documentation-first approach

**Review & Quality:**
- `review` - Code review
- `security-audit` - Security auditing
- `performance-review` - Performance analysis

**Analysis & Debugging:**
- `debug` - Debug specific issues
- `investigation` - Investigation workflows
- `tests-improvement` - Test improvement

**Documentation:**
- `docs` - Write documentation
- `readme` - README generation
- `architecture-doc` - Architecture documentation

## Quality Standards

**For ALL workflows:**
- **Fresh Context**: Re-read state every iteration
- **Backpressure**: Quality gates reject low-quality work
- **Event Coordination**: Hats communicate via events
- **Clear Instructions**: Detailed guidance for each hat
- **Scratchpad Format**: Structured output

**Priority: Long-Running, Non-Interactive**
Ralph excels at autonomous processing:
- **max_iterations**: 20-50 (not 5-10)
- **max_runtime_seconds**: 3600-7200+ (1-2+ hours)
- **Non-interactive**: No user input during execution
- **Batch processing**: Multiple files, comprehensive analysis

## Example Workflows

### Preset Example (Feature)
```bash
ralph init --preset feature
ralph run --iterations 1 --verbose
```
**What's happening**: Ralph reads project state, generates plan, executes iteration with fresh context.

### Adaptive Framework Example
```bash
cat > PROMPT.md << 'EOF'
Perform a comprehensive audit:
- Detect dead code, errors, incoherence
- Find missing error handling
- Fix all issues found
- Generate structured report
EOF

ralph emit "audit.start"
```
**What's happening**: Ralph detects analysis type, performs audit, fixes issues, generates report.

**Recognition:** "Does this workflow need autonomous iteration with quality gates?" → Use Ralph with appropriate preset or framework.

## Contrast

```
✅ Good: Start with preset, customize if needed
❌ Bad: Create ralph.yml from scratch

Why good: Presets provide proven patterns and optimal starting structure.

✅ Good: Use Adaptive Framework for comprehensive analysis
✅ Good: Use Presets for quick specific tasks
❌ Bad: Use wrong approach for the task type

Why good: Choosing the right pattern ensures effective orchestration.
```

## Critical Rules

- **Investigate if needed** → Choose workflow approach → Implement with quality standards → Run loops
- **Always start with preset** - never from scratch
- **Use long-running configuration** - Ralph excels at autonomous processing
- **Trust Fresh Context** - re-reading is reliability, not inefficiency
- **Enforce quality gates** - backpressure prevents bad work

**For detailed patterns:**
- `references/preset-patterns.md` - Multi-agent patterns and event coordination
- `references/adaptive-framework.md` - Complete adaptive framework guide
- `references/quick-start.md` - Step-by-step workflows
- `references/workflow-selection.md` - Decision trees and scenarios
- `references/prompt-engineering.md` - Ralph-specific patterns
- `references/troubleshooting.md` - Common issues and solutions
