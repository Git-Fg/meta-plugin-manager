---
name: ralph-orchestrator-expert
description: This skill should be used when the user asks to "set up a ralph wiggum", "create a ralph loop", or needs guidance on Ralph Orchestrator workflow design, preset selection, or orchestration patterns.
---

# Ralph Orchestrator Guide

Ralph implements autonomous task completion through continuous iteration. The core philosophy: **Fresh Context** (each loop starts clean) + **Backpressure** (quality gates reject bad work) = reliable automation.

## 🎯 GOLDEN RULE: Choose the Right Pattern for Your Task

Ralph offers two powerful orchestration approaches:

### 1️⃣ **Preset Workflows** (Recommended for Most Users)
- Start with proven patterns for common tasks
- Quick setup: `ralph init --preset <name>`
- Predictable structure and outcomes
- Ideal for: features, reviews, debugging, documentation

### 2️⃣ **Adaptive Framework** (Advanced - Unified Analysis)
- Single workflow handles **spec analysis + codebase audits + custom analysis**
- Auto-detects what type of analysis to perform
- Self-healing: finds issues AND fixes them automatically
- Ideal for: comprehensive codebase analysis, spec-driven development

**Decision Tree:**
```
Need quick task completion? → Use Presets
Need comprehensive analysis + fixing? → Use Adaptive Framework
Not sure? → Start with Presets, upgrade to Adaptive as needed
```

```bash
# ✅ GOOD: Use preset when it fits
ralph init --preset feature
ralph run

# ✅ GOOD: Custom workflow when needed
# Create custom ralph.yml using proven patterns
```

**When to Use Presets:**
- Common workflows (review, feature, refactor, debug, etc.)
- Proven patterns that fit your task
- When you want speed and proven structure

**When to Create Custom Workflows:**
- No preset matches your specific needs
- Unique domain requirements
- Complex multi-stage processes
- When presets would require >50% customization

**Quality Standards for All Workflows:**
- **Fresh Context**: Re-read state every iteration
- **Backpressure**: Quality gates that reject low-quality work
- **Event Coordination**: Hats communicate via events, not assumptions
- **Clear Instructions**: Detailed, unambiguous guidance for each hat
- **Scratchpad Format**: Structured output format

**Priority: Long-Running, Non-Interactive Workflows**
Ralph excels at autonomous processing. Configure for long-running tasks:
- **max_iterations**: 20-50 (not 5-10)
- **max_runtime_seconds**: 3600-7200+ (1-2+ hours)
- **Non-interactive**: No user input required during execution
- **Batch processing**: Multiple files, comprehensive analysis, extensive validation

**Critical**: A ralph loop runs externally to the repository code, in the project root. It does not modify core repository files when setting up.

This guide assumes CLI fluency and focuses on Ralph-specific orchestration patterns.

---

## Core Ralph Tenets (2026 Latest Practices)

Ralph follows six foundational principles that ensure reliable orchestration. See [references/core-tenets.md](references/core-tenets.md) for detailed guidance on:

- Fresh Context: Re-read state every iteration
- Backpressure: Quality gates reject bad work
- The Plan Is Disposable: Regeneration is cheap
- Disk Is State, Git Is Memory: Simple handoff mechanisms
- Steer With Signals, Not Scripts: Use the codebase as instruction manual
- Let Ralph Ralph: Autonomous iteration over micromanagement

Anti-patterns to avoid and best practices for each tenet are documented in the reference.

---

## Adaptive Framework (Advanced)

The **Adaptive Framework** provides unified analysis with automatic mode detection and self-healing. Unlike presets which are task-specific, the adaptive framework **detects** what type of analysis you need (Spec Gap Analysis, Global Codebase Audit, or Custom Analysis) and performs it comprehensively.

**Key capabilities:**
- Automatic mode detection based on project state
- Self-healing: finds issues AND fixes them systematically
- Comprehensive AUDIT_REPORT.md output with verification

**Quick Start:**
```bash
# 1. Create PROMPT.md with your analysis requirements
# 2. Run: ralph emit "audit.start"
# Ralph detects analysis type, fixes issues, generates report
```

**Use Adaptive Framework when:** comprehensive codebase analysis, spec verification, or automatic fixing is needed. **Use Presets when:** quick, specific tasks (feature, review, debug).

See [references/adaptive-framework.md](references/adaptive-framework.md) for complete guide including framework structure, spec creation, quality standards, and TaskList integration.

---

## Reading Guide

### RECOMMENDED READING (Read when Ralph work is needed)

Read these reference files when accuracy matters for Ralph orchestration:

#### 1. **references/adaptive-framework.md** (Comprehensive Analysis)
- Complete Adaptive Framework guide with automatic mode detection
- Self-healing capability: finds issues AND fixes them
- Framework structure, spec creation, quality standards
- AUDIT_REPORT.md output examples and TaskList integration
- When to use Adaptive vs Presets

**When**: Comprehensive codebase analysis, spec verification, automatic fixing

#### 2. **references/preset-patterns.md** (Recommended)
- Multi-agent architecture patterns (Pipeline, Critic-Actor, etc.)
- Event coordination system - how hats communicate via triggers and publications
- Understanding hat coordination through events
- Quality gates and backpressure enforcement
- All 13+ preset patterns explained with YAML examples

**When**: Before Ralph work, or when unsure about patterns

#### 3. **references/quick-start.md** (Recommended)
- 5 most common workflows with step-by-step instructions
- Copy-pasteable commands and expected outputs
- Customization patterns and quality gates
- Real examples of feature, debug, review, refactor, and learning workflows

**When**: First time using Ralph, or when needing a refresher on basic workflows

#### 4. **references/workflow-selection.md** (Recommended)
- Investigation workflow for unclear tasks
- How to analyze a codebase and propose workflow options
- 3 Simple + 2 Standard + 2 Custom workflow categories
- Decision trees and common scenarios

**When**: When user wants to use Ralph but task is unclear

#### 5. **references/prompt-engineering.md** (Recommended)
- Ralph-specific prompt patterns (Fresh Context, Event Emission, etc.)
- Hat instruction patterns (Builder, Reviewer, Planner hats)
- Quality gate enforcement techniques
- Error handling and retry logic

**When**: To understand how to write effective Ralph prompts

#### 6. **references/troubleshooting.md** (Recommended)
- Common issues and diagnostic procedures
- Event flow debugging techniques
- Hat coordination problems and solutions
- Debugging checklist and emergency procedures

**When**: To understand how Ralph works and how to fix issues

### When to Read vs Skip
**Read when**:
- Starting new Ralph orchestration work
- User requests verification of Ralph patterns
- Encountering issues with Ralph workflows
- Documentation may have changed recently

**Skip when**:
- Simple Ralph execution following known patterns
- Local-only work without external dependencies
- Working offline
- Recently read and patterns are stable

**Trust your judgment**: You know when validation is needed for accurate Ralph orchestration.

### REFERENCE MATERIALS (Available when needed)

#### **references/preset-patterns.md** (Contains all preset examples)
- All documented preset patterns explained with full YAML examples
- Use this to understand specific preset structures
- Contains examples of multi-stage pipelines, critic-actor loops, investigation workflows, and more


---

## Quick Decision Tree

**Core Question**: What type of workflow do you need?

### Path 1: Quick Task Completion
**"I have a specific task to complete"**
→ Use [Preset Workflows](#quick-preset-reference)
→ `ralph init --preset <name>`

**Examples:**
- Build a feature → `feature` preset
- Review code → `review` preset
- Debug an issue → `debug` preset
- Write docs → `docs` preset

### Path 2: Comprehensive Analysis
**"I need comprehensive analysis AND automatic fixing"**
→ Use [Adaptive Framework](#advanced-adaptive-framework-for-unified-analysis)
→ Create `PROMPT.md` → `ralph emit "audit.start"`

**Examples:**
- Find and fix all dead code
- Verify specs match implementation
- Comprehensive quality audit
- Spec-driven development

### Path 3: Unclear Requirements
**"I'm not sure what I need"**
→ Investigate codebase → Propose options → Choose workflow

**Process:**
1. Analyze project structure
2. Identify pain points
3. Propose 3-5 workflow options
4. User selects approach

### Decision Matrix

| Your Goal | Recommended Approach | Setup |
|-----------|-------------------|-------|
| Build feature quickly | Preset (feature) | `ralph init --preset feature` |
| Find and fix issues | Adaptive Framework | Create PROMPT.md + run |
| Verify code quality | Preset (review) | `ralph init --preset review` |
| Comprehensive audit | Adaptive Framework | Create PROMPT.md + run |
| Debug specific bug | Preset (debug) | `ralph init --preset debug` |
| Spec-driven dev | Adaptive Framework | Create specs + run |
| Write documentation | Preset (docs) | `ralph init --preset docs` |

**Default Backend**: Claude (use unless you have specific reason to change)

---

## 1. Initialize Ralph

Ralph requires a configuration file (`ralph.yml`) created from a preset. This ensures optimal starting patterns for your workflow.

### The Fresh Context Foundation
Ralph's power: each iteration starts clean without assumptions. Re-reads files, re-analyzes state, re-evaluates the plan. This isn't inefficiency — it's reliability through explicit context.

### Decision Tree: Direct Setup vs Investigation

**Do you have a specific task/workflow in mind?**
- **Yes** → Use [Quick Preset Reference](#quick-decision-tree)
- **No** → See [references/workflow-selection.md](references/workflow-selection.md) for investigation guidance

### Setup Process

**ALWAYS start with a preset** - never create `ralph.yml` from scratch:

1. **List available presets**: `ralph init --list-presets`
2. **Select preset**: Choose from [Quick Decision Tree](#quick-decision-tree)
3. **Initialize**: `ralph init --preset <name>` (Claude backend is default)
4. **Review configuration**: Read generated `ralph.yml` to understand structure
5. **Light customization** (if needed):
   - Adjust hat instructions to match your conventions
   - Update event names for your domain
   - Modify quality gates to your standards
   - Add project-specific context
6. **Create PROMPT.md**: Write your task in the human-readable format
7. **Run**: `ralph run` or `ralph run --tui` for real-time monitoring

**When to customize vs. choose different preset:**
- **Light edits**: Change names, add minor instructions, adjust quality gates
- **Choose different preset**: If you're changing >50% of the structure
- **Ask user**: If fundamental changes are needed (different hat pattern, etc.)

### When to Use --help
- **Choosing presets**: Start with `--list-presets`, read descriptions, cross-reference with your task type
- **Backend selection**: Use `ralph init --help` (defaults to Claude for reliability)
- **Configuration debugging**: `ralph <subcommand> --help` when behavior seems unexpected

### First Loop Example (Preset)
```bash
ralph init --preset feature  # Claude is default backend
ralph run --iterations 1 --verbose
```

**What's happening**: Ralph reads project state, generates plan, executes iteration. Fresh context ensures visibility into every decision.

### First Run Example (Adaptive Framework)
```bash
# 1. Create PROMPT.md describing your analysis task
cat > PROMPT.md << 'EOF'
Perform a comprehensive audit:
- Detect dead code, errors, incoherence
- Find missing error handling
- Fix all issues found
- Generate structured report
EOF

# 2. Run the adaptive framework
ralph emit "audit.start"
```

**What's happening**: Ralph detects analysis type, performs comprehensive audit, fixes issues automatically, generates report.

---

## 2. Quick Preset Reference

**Choose the right preset for your task:**

- **Development**: feature, feature-minimal, tdd-red-green, spec-driven, refactor, documentation-first
- **Review & Quality**: review, security-audit, performance-review
- **Analysis & Debugging**: debug, investigation, tests-improvement
- **Documentation & Knowledge**: docs, readme, architecture-doc

See [references/preset-reference.md](references/preset-reference.md) for complete list and detailed descriptions. For detailed preset patterns and examples, see [references/detailed-content.md](references/detailed-content.md).

---

## Summary: Ralph's Core Principles

**🎯 Choose the Right Pattern**: Presets for quick tasks, Adaptive Framework for comprehensive analysis.

**Fresh Context**: Every iteration starts clean. Re-reads files/specs/plans to prevent assumptions.

**Backpressure**: Quality gates reject work until standards met. Don't prescribe methods — enforce quality.

**Events Coordinate**: Hats publish events for reliable handoffs. Signal-based > script-based orchestration.

**Design for Quality**: Clear hat responsibilities, proper event flow, detailed instructions, quality gates, and Fresh Context enforcement.

**Workflow Approaches**:
- **Presets**: Quick setup for specific tasks (feature, review, debug)
- **Adaptive Framework**: Unified analysis with auto-fixing (specs, audits, comprehensive fixes)

**Let Ralph Ralph**: Autonomous iteration. Set quality gates, don't micromanage.

You can now orchestrate autonomously with Ralph — investigate if needed → choose workflow approach → implement with quality standards → run loops.

---

## Additional Resources

See [references/additional-resources.md](references/additional-resources.md) for complete list of:
- Core documentation (detailed-content, preset-patterns, quick-start, etc.)
- Specialized reference materials (workflow-selection, troubleshooting, prompt-engineering)
