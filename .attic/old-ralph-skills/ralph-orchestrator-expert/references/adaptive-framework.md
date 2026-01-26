# Adaptive Framework

This reference covers the Ralph Adaptive Framework for unified analysis and self-healing automation.

## Advanced: Adaptive Framework for Unified Analysis

The **Adaptive Framework** is a single, powerful workflow that handles multiple analysis types automatically. Unlike presets which are task-specific, the adaptive framework **detects** what type of analysis you need and performs it comprehensively.

### What It Does

**Automatic Mode Detection:**
1. **Spec Gap Analysis** - If `./specs/` exists, verifies implementation against specifications
2. **Global Codebase Audit** - If `PROMPT.md` exists, performs dead code/error detection
3. **Custom Analysis** - Adapts to your specific prompt and context

**Self-Healing Capability:**
- Finds issues automatically
- **Fixes issues systematically**
- Updates documentation
- Verifies fixes (tests/lint/typecheck)
- Generates comprehensive report

### Quick Start: Adaptive Framework

```bash
# 1. Create PROMPT.md describing your analysis needs
cat > PROMPT.md << 'EOF'
Perform comprehensive analysis of the codebase:
- Find dead code and unused functions
- Check for error handling gaps
- Verify documentation completeness
- Fix all identified issues
EOF

# 2. Use the generalized ralph.yml (already in your project root)
# Check ralph.yml - it should have the adaptive framework configured

# 3. Run the analysis
ralph emit "audit.start" "Begin comprehensive analysis"

# Ralph will:
# - Detect analysis type automatically
# - Analyze the entire codebase
# - Fix issues found
# - Generate AUDIT_REPORT.md
```

### Framework Structure

The adaptive framework uses four specialized hats working in coordination:

```yaml
# From ralph.yml - Adaptive Framework Configuration
hats:
  coordinator:     # Orchestrates the entire process
  analyzer:         # Performs deep analysis
  remediator:      # Fixes identified issues
  reporter:         # Documents findings and fixes
```

**Workflow:**
```
┌─────────────────────────────────────────────────────────────┐
│  Phase 1: Analysis                                         │
├─────────────────────────────────────────────────────────────┤
│  Coordinator detects scope → Analyzer deep-dives            │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  Phase 2: Remediation (Self-Healing)                     │
├─────────────────────────────────────────────────────────────┤
│  Remediator fixes issues by priority:                      │
│  • Critical (security, blocking bugs, spec violations)     │
│  • Major (missing features, architectural issues)          │
│  • Minor (consistency, polish, documentation)             │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  Phase 3: Reporting                                        │
├─────────────────────────────────────────────────────────────┤
│  Reporter generates AUDIT_REPORT.md with findings + fixes  │
└─────────────────────────────────────────────────────────────┘
```

### Adaptive vs Presets: When to Use Each

| Scenario | Use Presets | Use Adaptive |
|----------|-------------|--------------|
| **Task Type** | Specific task (feature, review, debug) | Comprehensive analysis + fixing |
| **Setup Time** | 2 minutes (init preset) | 5 minutes (create PROMPT.md) |
| **Output** | Task completion | AUDIT_REPORT.md with fixes |
| **Automation** | Manual fixes | **Automatic fixes** |
| **Scope** | Focused | Comprehensive |
| **Best For** | "Build this feature" | "Analyze everything and fix issues" |
| **Complexity** | Simple | Advanced |

**Example Decision:**

**"I need to implement user authentication"** → Use `feature` preset
**"My codebase has quality issues, find and fix them all"** → Use Adaptive Framework
**"I have specs, verify implementation matches"** → Use Adaptive Framework
**"Debug this specific bug"** → Use `debug` preset

### Creating Effective Specs for Analysis

For spec gap analysis, create specifications following the **SPEC_SETUP_GUIDE.md**:

```yaml
---
name: event-loop-integration
category: core
priority: critical
acceptance_criteria: 3
---

# Event Loop Integration

## Acceptance Criteria
```
