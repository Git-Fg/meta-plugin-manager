# Hook Security Compliance Framework

5-dimensional quality scoring system for evaluating hook security implementation.

---

## Overview

The Hook Security Compliance Framework provides a standardized method for assessing the security posture of Claude Code hook configurations. This framework scores implementations on a 0-100 scale across five critical dimensions.

---

## Scoring Dimensions

### Dimension 1: Security Coverage (25 points)

**Measures**: How well hooks protect critical operations

**Evaluation Criteria**:

| Coverage Area | Points | Requirements |
|---------------|--------|--------------|
| **File Operations** | 5 | PreToolUse on Write/Edit operations |
| **Command Execution** | 5 | PreToolUse on Bash operations |
| **Path Validation** | 5 | Scripts validate paths before write |
| **Secret Detection** | 5 | Scripts detect secrets in file writes |
| **Dangerous Operations** | 5 | Scripts block dangerous commands |

**Scoring Formula**:
```
Coverage Score = (Implemented Areas / 5) × 25
```

**Assessment Checklist**:
- [ ] PreToolUse hooks configured for Write operations
- [ ] PreToolUse hooks configured for Bash operations
- [ ] Path validation scripts present and functional
- [ ] Secret detection scripts present and functional
- [ ] Dangerous command patterns blocked

**Example Scoring**:
```
Implemented: File ops (✅), Commands (✅), Paths (✅), Secrets (❌), Danger ops (✅)
Score: 4/5 × 25 = 20/25
```

---

### Dimension 2: Validation Patterns (20 points)

**Measures**: Quality of input validation and sanitization

**Evaluation Criteria**:

| Validation Aspect | Points | Requirements |
|-------------------|--------|--------------|
| **Input Sanitization** | 5 | Scripts sanitize all inputs |
| **Pattern Matching** | 5 | Regex patterns for threat detection |
| **Whitelist Approach** | 3 | Prefer whitelisting over blacklisting |
| **Edge Case Handling** | 3 | Scripts handle unexpected inputs gracefully |
| **Error Handling** | 2 | Proper error messages and logging |
| **False Positive Management** | 2 | Exceptions for legitimate operations |

**Scoring Formula**:
```
Validation Score = (Sum of Implemented Aspects) / 5 × 20
```

**Assessment Checklist**:
- [ ] All inputs validated before processing
- [ ] Regex patterns for common threats (path traversal, command injection)
- [ ] Whitelist patterns used where possible
- [ ] Scripts handle missing arguments gracefully
- [ ] Error messages are informative
- [ ] Known safe operations have exceptions

**Example Scoring**:
```
Implemented: Sanitization (✅), Patterns (✅), Whitelist (✅), Edge cases (✅), Errors (✅), Exceptions (❌)
Score: 5/6 × 20 = 16.67/20
```

---

### Dimension 3: Exit Code Usage (15 points)

**Measures**: Correct usage of exit codes for allow/block/warn decisions

**Evaluation Criteria**:

| Exit Code | Usage | Points | Requirements |
|-----------|-------|--------|--------------|
| **0** | Success | 5 | Operation passes validation |
| **1** | Warning | 5 | Operation allowed with caution |
| **2** | Blocking | 5 | Operation denied for security |

**Scoring Formula**:
```
Exit Code Score = (Correct Exit Codes / 3) × 15
```

**Assessment Checklist**:
- [ ] Scripts exit 0 for valid operations
- [ ] Scripts exit 1 for warnings (non-blocking)
- [ ] Scripts exit 2 for blocking (dangerous operations)
- [ ] Exit codes are consistent across all scripts
- [ ] Exit codes match operation severity

**Common Mistakes**:
- ❌ Using exit 1 for blocking (should be 2)
- ❌ Using exit 2 for warnings (should be 1)
- ❌ Inconsistent exit codes across scripts

**Example Scoring**:
```
Implemented: Exit 0 (✅), Exit 1 (✅), Exit 2 (✅)
Score: 3/3 × 15 = 15/15
```

---

### Dimension 4: Script Quality (20 points)

**Measures**: Code quality, maintainability, and structure

**Evaluation Criteria**:

| Quality Aspect | Points | Requirements |
|----------------|--------|--------------|
| **Script Structure** | 5 | Clear sections (Input → Check → Action → Exit) |
| **Comments** | 3 | Descriptive comments explaining logic |
| **Naming** | 3 | Descriptive variable and function names |
| **Error Messages** | 3 | Clear, actionable error messages |
| **Performance** | 3 | Execution time <100ms |
| **Idempotency** | 3 | Same input always produces same output |

**Scoring Formula**:
```
Script Quality Score = (Sum of Quality Aspects) / 6 × 20
```

**Assessment Checklist**:
- [ ] Scripts have clear structure with comments
- [ ] Variables have descriptive names (PATH_TO_VALIDATE vs p)
- [ ] Error messages start with emoji indicator (✅❌⚠️)
- [ ] Scripts execute quickly (<100ms)
- [ ] No side effects from script execution
- [ ] Code is readable and maintainable

**Example Structure**:
```bash
#!/bin/bash
# Script Description

# ========== INPUT VALIDATION ==========
# Extract and validate inputs

# ========== SECURITY CHECKS ==========
# Pattern matching, whitelist/blacklist validation

# ========== ACTION ==========
# Allow, block, or warn based on findings

# ========== EXIT ==========
# Exit with appropriate code
```

**Example Scoring**:
```
Implemented: Structure (✅), Comments (✅), Naming (✅), Errors (✅), Performance (✅), Idempotency (✅)
Score: 6/6 × 20 = 20/20
```

---

### Dimension 5: Component Scope (20 points)

**Measures**: Preference for component-scoped hooks over global hooks

**Evaluation Criteria**:

| Scope Type | Points | Percentage |
|------------|--------|------------|
| **Component-Scoped** | 20 | All hooks in skill frontmatter |
| **Mostly Component-Scoped** | 16 | 80% component-scoped, 20% global |
| **Mixed** | 12 | 50% component-scoped, 50% global |
| **Mostly Global** | 8 | 20% component-scoped, 80% global |
| **All Global** | 0 | No component-scoped hooks |

**Scoring Formula**:
```
Component Scope Score = (Component-scoped hooks / Total hooks) × 20
```

**Assessment Checklist**:
- [ ] Count total hooks configured
- [ ] Count component-scoped hooks (in skill frontmatter)
- [ ] Count global hooks (in .claude/hooks.json)
- [ ] Calculate percentage
- [ ] Assign score based on percentage

**Example Calculation**:
```
Total hooks: 10
Component-scoped: 8
Percentage: 8/10 = 80%
Score: 16/20
```

**Why Component-Scoped is Preferred**:
- ✅ Easier to understand scope and impact
- ✅ Can be temporary/experimental
- ✅ No global side effects
- ✅ Auto-cleanup when skill removed
- ✅ Scoped to specific use cases

---

## Quality Grade Thresholds

| Grade | Score Range | Description |
|-------|-------------|-------------|
| **A** | 90-100 | Exemplary security implementation |
| **B** | 75-89 | Good security with minor gaps |
| **C** | 60-74 | Adequate security, needs improvement |
| **D** | 40-59 | Poor security, significant issues |
| **F** | 0-39 | Failing security, critical vulnerabilities |

---

## Workflow-Specific Scoring

### INIT Workflow Scoring

**Purpose**: Establish baseline security for new projects

**Minimum Requirements**:
- Security Coverage: ≥20/25 (80%)
- Validation Patterns: ≥16/20 (80%)
- Exit Code Usage: ≥12/15 (80%)
- Script Quality: ≥16/20 (80%)
- Component Scope: ≥16/20 (80%)

**Target Score**: ≥80/100

**Example INIT Assessment**:
```
Security Coverage: 22/25 (guard-paths, guard-commands, detect-secrets)
Validation Patterns: 18/20 (good patterns, minor gaps)
Exit Code Usage: 15/15 (all exit codes correct)
Script Quality: 18/20 (well-structured, minor comments missing)
Component Scope: 20/20 (component-scoped hooks)
Total: 93/100 (Grade A)
```

### SECURE Workflow Scoring

**Purpose**: Enhance existing security incrementally

**Minimum Requirements**:
- Security Coverage: ≥20/25 (80%)
- All dimensions: ≥15/20 (75%)

**Target Score**: ≥80/100

**Example SECURE Enhancement**:
```
Before: 72/100 (Grade C)
- Added environment validation (+5 coverage)
- Improved error messages (+2 quality)
- Added component-scoped hooks (+4 scope)

After: 88/100 (Grade B)
```

### AUDIT Workflow Scoring

**Purpose**: Assess current security posture

**Output**: Detailed score breakdown with recommendations

**Example AUDIT Report**:
```
## Security Audit Report

### Overall Score: 68/100 (Grade C)

### Breakdown
- Security Coverage: 15/25 (60%) - Missing secret detection
- Validation Patterns: 14/20 (70%) - Good patterns, needs whitelist
- Exit Code Usage: 15/15 (100%) - Perfect implementation
- Script Quality: 16/20 (80%) - Well-structured, needs comments
- Component Scope: 8/20 (40%) - Too many global hooks

### Issues
- Missing secret detection in file writes
- No whitelist patterns (only blacklist)
- Global hooks preferred over component-scoped

### Recommendations
1. Add detect-secrets.sh script (+10 coverage)
2. Implement whitelist patterns (+3 validation)
3. Convert 5 global hooks to component-scoped (+8 scope)
4. Add script comments (+1 quality)

### Expected Improvement
After fixes: 68 → 90/100 (Grade A)
```

### REMEDIATE Workflow Scoring

**Purpose**: Fix critical security issues

**Target**: Improve score to ≥80/100

**Example REMEDIATION**:
```
Before: 45/100 (Grade F)
Issues:
- No input validation (-8 validation)
- Wrong exit codes (-8 exit codes)
- No path safety (-10 coverage)
- Global hooks only (-12 scope)
- Poor error messages (-7 quality)

Fixes Applied:
1. Added input validation (+8 validation)
2. Fixed exit codes (+8 exit codes)
3. Added guard-paths.sh (+10 coverage)
4. Converted to component-scoped (+12 scope)
5. Improved error messages (+7 quality)

After: 83/100 (Grade B)
Improvement: +38 points
```

---

## Common Issues and Scoring Impact

### Critical Issues (Score <60)

| Issue | Impact | Points Lost |
|-------|--------|-------------|
| No PreToolUse hooks configured | Security Coverage | -25 |
| Scripts always exit 0 (no blocking) | Exit Code Usage | -15 |
| No input validation | Validation Patterns | -20 |
| All hooks are global | Component Scope | -20 |
| No error messages | Script Quality | -3 |

### Warning Issues (Score 60-80)

| Issue | Impact | Points Lost |
|-------|--------|-------------|
| Missing one validation pattern | Validation Patterns | -3 |
| Scripts lack comments | Script Quality | -3 |
| Inconsistent exit codes | Exit Code Usage | -5 |
| Mix of global and scoped | Component Scope | -4 |

### Best Practices (Score >90)

| Practice | Bonus | Points Gained |
|----------|-------|---------------|
| Component-scoped hooks only | Scope | +4 |
| Comprehensive test suite | Quality | +3 |
| Performance monitoring | Quality | +2 |
| Detailed logging | Quality | +2 |

---

## Quality Improvement Roadmap

### Current Score <60 (Critical)

**Priority 1: Security Basics**
1. Add PreToolUse hooks for Write and Bash
2. Implement guard-paths.sh script
3. Implement guard-commands.sh script
4. Fix exit codes (0/1/2)
5. Add basic input validation

**Expected Improvement**: +40-50 points

**Target**: 60-75/100 (Grade C)

---

### Current Score 60-75 (Needs Improvement)

**Priority 2: Validation Enhancement**
1. Add detect-secrets.sh script
2. Implement whitelist patterns
3. Improve error messages
4. Add edge case handling
5. Document scripts with comments

**Expected Improvement**: +15-20 points

**Target**: 75-90/100 (Grade B)

---

### Current Score 75-90 (Good)

**Priority 3: Optimization**
1. Convert global hooks to component-scoped
2. Add performance monitoring
3. Implement comprehensive test suite
4. Add logging and audit trail
5. Fine-tune validation patterns

**Expected Improvement**: +5-10 points

**Target**: 90-100/100 (Grade A)

---

### Current Score >90 (Exemplary)

**Priority 4: Excellence**
1. Add custom validation for project-specific needs
2. Implement advanced pattern matching
3. Add automated testing for guardrails
4. Document all custom patterns
5. Share patterns with team

**Target**: Maintain 95-100/100

---

## Scoring Examples

### Example 1: Minimal Security (F Grade)

**Configuration**:
```yaml
# Only global hooks, basic validation
```

**Score Calculation**:
```
Security Coverage: 10/25 (no secret detection, no dangerous command blocking)
Validation Patterns: 8/20 (basic input check, no patterns)
Exit Code Usage: 5/15 (always exit 0)
Script Quality: 12/20 (basic scripts, no structure)
Component Scope: 0/20 (all global)

Total: 35/100 (Grade F)
```

**Issues**:
- No PreToolUse hooks for critical operations
- Scripts don't block anything
- No input validation
- No component-scoped hooks
- Poor script structure

---

### Example 2: Good Security (B Grade)

**Configuration**:
```yaml
# Component-scoped hooks with comprehensive validation
hooks:
  PreToolUse:
    - matcher: {"tool": "Write"}
      hooks:
        - type: command
          command: "./.claude/scripts/guard-paths.sh"
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./.claude/scripts/guard-commands.sh"
```

**Score Calculation**:
```
Security Coverage: 22/25 (paths, commands, basic secrets)
Validation Patterns: 17/20 (good patterns, minor gaps)
Exit Code Usage: 15/15 (correct usage)
Script Quality: 18/20 (well-structured, good comments)
Component Scope: 20/20 (all component-scoped)

Total: 92/100 (Grade A)
```

---

### Example 3: Excellent Security (A Grade)

**Configuration**:
```yaml
# Comprehensive security with all best practices
hooks:
  PreToolUse:
    - matcher: {"tool": "Write"}
      hooks:
        - type: command
          command: "./.claude/scripts/guard-paths.sh"
        - type: command
          command: "./.claude/scripts/detect-secrets.sh"
    - matcher: {"tool": "Bash"}
      hooks:
        - type: command
          command: "./.claude/scripts/guard-commands.sh"
        - type: command
          command: "./.claude/scripts/validate-env.sh"
```

**Score Calculation**:
```
Security Coverage: 25/25 (all areas covered)
Validation Patterns: 20/20 (comprehensive patterns, whitelist)
Exit Code Usage: 15/15 (perfect implementation)
Script Quality: 19/20 (excellent structure, performance monitoring)
Component Scope: 20/20 (all component-scoped)

Total: 99/100 (Grade A)
```

---

## Assessment Workflow

### Step 1: Inventory Hooks
```bash
# List all hooks
grep -r "hooks:" .claude/

# Count component-scoped vs global
grep -r "hooks:" .claude/skills/ | wc -l  # component-scoped
grep -r "hooks:" .claude/hooks.json | wc -l  # global (should be 0 or 1)
```

### Step 2: Evaluate Scripts
```bash
# Check script permissions
ls -la .claude/scripts/

# Validate syntax
for script in .claude/scripts/*.sh; do
  bash -n "$script" || echo "Syntax error in $script"
done

# Check exit codes in scripts
grep -E "exit [012]" .claude/scripts/*.sh
```

### Step 3: Score Each Dimension
1. Calculate Security Coverage percentage
2. Evaluate Validation Patterns quality
3. Check Exit Code Usage correctness
4. Assess Script Quality
5. Calculate Component Scope percentage

### Step 4: Generate Report
```markdown
## Security Compliance Assessment

### Overall Score: XX/100 (Grade [A/B/C/D/F])

### Dimension Breakdown
- Security Coverage: XX/25
- Validation Patterns: XX/20
- Exit Code Usage: XX/15
- Script Quality: XX/20
- Component Scope: XX/20

### Issues Found
1. [Issue 1] - Impact: [points]
2. [Issue 2] - Impact: [points]

### Recommendations
1. [Action 1] → Expected improvement: [+XX points]
2. [Action 2] → Expected improvement: [+XX points]
```

---

## Success Criteria

### Production-Ready Security (≥80/100)
- ✅ All critical operations protected
- ✅ Proper input validation
- ✅ Correct exit codes
- ✅ Component-scoped hooks preferred
- ✅ Well-documented scripts

### Quality Targets by Dimension
- Security Coverage: ≥20/25 (80%)
- Validation Patterns: ≥16/20 (80%)
- Exit Code Usage: ≥12/15 (80%)
- Script Quality: ≥16/20 (80%)
- Component Scope: ≥16/20 (80%)

### Workflow Completion Criteria

**INIT Workflow**:
- Score ≥80/100 after setup
- Baseline security implemented
- All required scripts present

**SECURE Workflow**:
- Score improvement ≥10 points
- New guardrails added
- Coverage increased

**AUDIT Workflow**:
- Accurate score calculation
- Clear issue identification
- Actionable recommendations

**REMEDIATE Workflow**:
- Score ≥80/100 after fixes
- Critical issues resolved
- All recommendations implemented

---

## Quick Reference Scoring Guide

| Dimension | Max Points | Quick Check |
|-----------|-----------|-------------|
| Security Coverage | 25 | Are Write/Bash operations protected? |
| Validation Patterns | 20 | Are inputs validated and sanitized? |
| Exit Code Usage | 15 | Do scripts use 0/1/2 correctly? |
| Script Quality | 20 | Are scripts well-structured and documented? |
| Component Scope | 20 | Are hooks component-scoped? |

**Target**: ≥80/100 (Grade B or higher)
